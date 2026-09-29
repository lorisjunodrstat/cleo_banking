#!/usr/bin/env python3
"""
Import des shifts Loyverse — VERSION TRANSACTIONS MULTI-COMPTES
- SQL       : pos_periodes_travail
- Python    : payins  -> create_depot(compte_du_pdv, ...)
              payouts -> create_retrait(compte_du_pdv, ...)
              Le compte cible est résolu via pos_points_de_vente.compte_bancaire_id
"""

import csv
import unicodedata
from datetime import datetime
from pathlib import Path

# Compte utilisé en secours si un PDV n'a pas de compte_bancaire_id
COMPTE_FALLBACK_ID = None   # ex: 193  ou  None pour ignorer


# =====================================================
# UTILITAIRES
# =====================================================
def nfc(s): return unicodedata.normalize('NFC', str(s or '').strip())

def fnum(v):
    try: return float(str(v).strip().replace("'", "") or 0)
    except ValueError: return 0.0

def parse_date(s):
    try:
        return datetime.strptime(str(s).strip(), '%d/%m/%Y %H:%M').strftime('%Y-%m-%d %H:%M:%S')
    except Exception:
        return None

def esc(s):
    if s is None: return ''
    return str(s).replace("\\", "\\\\").replace("'", "''")

def ask_file(prompt):
    while True:
        p = input(prompt).strip().strip('"').strip("'")
        if p and Path(p).exists(): return p
        print(f"❌ Fichier introuvable : {p}")

def ask_pdv_mapping(pdv_names):
    print("\n" + "-" * 60)
    print("  CORRESPONDANCE DES POINTS DE VENTE (PDV)")
    print("  (utilisée pour pos_periodes_travail.pdv_id ET")
    print("   pour retrouver compte_bancaire_id via la table pdv)")
    print("-" * 60)
    mapping = {}
    for name in sorted(pdv_names):
        while True:
            raw = input(f"  '{name}' -> pdv_id : ").strip()
            if raw == '':
                mapping[name] = None; break
            if raw.isdigit():
                mapping[name] = int(raw); break
            print("    ❌ Entier ou vide.")
    return mapping


# =====================================================
# PARSING
# =====================================================
def parse_shifts(file_path):
    shifts = []
    with open(file_path, encoding='utf-8', errors='replace') as f:
        reader = csv.reader(f); next(reader, None)
        for row in reader:
            if len(row) < 15: continue
            dd = parse_date(row[3])
            if dd is None: continue
            shifts.append({
                'magasin': nfc(row[0]), 'pdv': nfc(row[1]),
                'numero_equipe': nfc(row[2]),
                'date_debut': dd,
                'ouvert_par': nfc(row[4]),
                'date_fin': parse_date(row[5]),
                'ferme_par': nfc(row[6]),
                'espece_depart': fnum(row[7]),
                'reglement_especes': fnum(row[8]),
                'remboursements_especes': fnum(row[9]),
                'paiement_entrant': fnum(row[10]),
                'paiement_sortant': fnum(row[11]),
                'montant_prevu': fnum(row[12]),
                'montant_reel': fnum(row[13]),
                'difference': fnum(row[14]),
            })
    return shifts

def parse_payins_payouts(file_path):
    movements = []
    with open(file_path, encoding='utf-8', errors='replace') as f:
        reader = csv.reader(f); next(reader, None)
        for row in reader:
            if len(row) < 8: continue
            d = parse_date(row[0])
            if d is None: continue
            movements.append({
                'date': d,
                'magasin': nfc(row[1]), 'pdv': nfc(row[2]),
                'numero_equipe': nfc(row[3]),
                'type': nfc(row[4]).lower(),
                'employe': nfc(row[5]),
                'commentaire': nfc(row[6]),
                'montant': fnum(row[7]),
            })
    return movements


# =====================================================
# SQL PÉRIODES
# =====================================================
def generate_periodes_sql(shifts, user_id, output_file, pdv_map):
    count = 0
    def pdv_id_sql(pdv_name):
        pid = pdv_map.get(pdv_name)
        return str(pid) if pid is not None else 'NULL'

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"-- Périodes de travail Loyverse — {datetime.now():%Y-%m-%d %H:%M:%S} — user {user_id}\n")
        f.write("SET NAMES utf8mb4;\n")
        f.write(f"SET @uid = {user_id};\n\n")

        for s in sorted(shifts, key=lambda x: x['date_debut']):
            date_fin_sql = f"'{s['date_fin']}'" if s['date_fin'] else 'NULL'
            status = "'Fermé'" if s['date_fin'] else "'Ouvert'"
            pdv_lookup = pdv_id_sql(s['pdv'])

            f.write(f"\n-- Shift équipe {s['numero_equipe']} — {s['magasin']} / {s['pdv']} "
                    f"— {s['date_debut']} -> {s['date_fin'] or 'en cours'}\n")
            f.write("INSERT INTO pos_periodes_travail (\n")
            f.write("  utilisateur_id, magasin, pdv_id, date_debut, date_fin,\n")
            f.write("  montant_debut_prevu, montant_debut_reel,\n")
            f.write("  montant_fin_prevu, montant_fin_reel,\n")
            f.write("  montant_retrait, montant_depot, difference, status\n")
            f.write(") VALUES (\n")
            f.write(f"  @uid, '{esc(s['magasin'])}', {pdv_lookup}, '{s['date_debut']}', {date_fin_sql},\n")
            f.write(f"  {s['espece_depart']:.2f}, {s['espece_depart']:.2f},\n")
            f.write(f"  {s['montant_prevu']:.2f}, {s['montant_reel']:.2f},\n")
            f.write(f"  {s['paiement_sortant']:.2f}, {s['paiement_entrant']:.2f}, "
                    f"{s['difference']:.2f}, {status}\n")
            f.write(");\n")
            count += 1
    return count


# =====================================================
# PYTHON — TRANSACTIONS (résolution par PDV)
# =====================================================
def generate_transactions_py(movements, output_file, pdv_map, fallback_compte_id=None):
    """
    Génère un fichier Python autonome qui :
      - reçoit un `pdv_id -> compte_bancaire_id` mapping construit à l'exécution
      - utilise `create_depot` / `create_retrait` sur le compte du PDV
    """
    moves_sorted = sorted(movements, key=lambda x: x['date'])
    skipped = 0
    entries = []
    for m in moves_sorted:
        if m['type'] not in ('payin', 'payout'):
            skipped += 1
            continue
        pdv_id = pdv_map.get(m['pdv'])
        entries.append((
            m['date'], m['type'], m['montant'],
            (m['commentaire'] or m['employe'] or ''),
            m['numero_equipe'], m['magasin'], m['pdv'],
            pdv_id,
        ))

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('#!/usr/bin/env python3\n')
        f.write('"""\n')
        f.write('Création des transactions financières des shifts Loyverse.\n')
        f.write('Le compte cible de chaque mouvement est résolu via :\n')
        f.write('    pos_points_de_vente.compte_bancaire_id\n')
        f.write('La correspondance pdv_id <-> nom du PDV est stockée ci-dessous.\n')
        f.write('"""\n\n')
        f.write('from datetime import datetime\n')
        f.write('from decimal import Decimal\n\n')
        f.write(f'FALLBACK_COMPTE_ID = {fallback_compte_id!r}\n\n')
        f.write('# nom_pdv (tel qu\'apparaît dans le CSV) -> pdv_id (base de données)\n')
        f.write('PDV_NAME_TO_ID = {\n')
        for name, pid in sorted(pdv_map.items()):
            if pid is not None:
                f.write(f"    {name!r}: {pid},\n")
        f.write('}\n\n')
        f.write('# (date, type, montant, description, num_equipe, magasin, pdv_name, pdv_id)\n')
        f.write('MOVEMENTS = [\n')
        for (dt, typ, montant, desc, num, mag, pdv, pdv_id) in entries:
            f.write(
                f"    ({dt!r}, {typ!r}, {montant!r}, {desc!r}, "
                f"{num!r}, {mag!r}, {pdv!r}, {pdv_id!r}),\n"
            )
        f.write(']\n\n')
        f.write('''

def _resolve_compte_par_pdv(db, pdv_id):
    """Récupère pos_points_de_vente.compte_bancaire_id pour un pdv_id donné."""
    if pdv_id is None:
        return None
    with db.get_cursor(dictionary=True) as cursor:
        cursor.execute("""
            SELECT compte_bancaire_id
            FROM pos_points_de_vente
            WHERE id = %s
        """, (pdv_id,))
        row = cursor.fetchone()
    return row['compte_bancaire_id'] if row else None


def run(transaction_service, db, user_id, fallback_compte_id=None, verbose=True):
    """
    transaction_service : instance de TransactionFinanciere
    db                  : instance de DatabaseManager (pour résoudre les PDV)
    Retourne (nb_depots, nb_retraits, nb_echecs, nb_ignores).
    """
    fb = fallback_compte_id if fallback_compte_id is not None else FALLBACK_COMPTE_ID
    nb_depots = nb_retraits = nb_echecs = nb_ignores = 0
    cache_pdv = {}

    for (date_str, mtype, montant, desc, num, mag, pdv_name, pdv_id) in MOVEMENTS:
        # Résolution du compte bancaire via le PDV
        if pdv_id not in cache_pdv:
            cache_pdv[pdv_id] = _resolve_compte_par_pdv(db, pdv_id)
        compte_id = cache_pdv[pdv_id]

        if not compte_id:
            if fb:
                compte_id = fb
                if verbose:
                    print(f"  ! PDV {pdv_name!r} sans compte bancaire -> fallback {fb}")
            else:
                nb_ignores += 1
                print(f"  - Ignore  {date_str}  PDV {pdv_name!r} sans compte bancaire")
                continue

        dt = datetime.strptime(date_str, '%Y-%m-%d %H:%M:%S')
        montant_dec = Decimal(str(montant))
        full_desc = f"[{mtype.upper()}] equipe {num} - {mag}/{pdv_name} - {desc}".strip()

        if mtype == 'payin':
            ok, msg = transaction_service.create_depot(
                compte_id, user_id, montant_dec,
                full_desc, 'compte_principal', dt
            )
            if ok:
                nb_depots += 1
                if verbose:
                    print(f"  + Depot   {date_str} {montant:>10.2f}  "
                          f"(cpt {compte_id}, equipe {num})")
            else:
                nb_echecs += 1
                print(f"  X Payin   {date_str} {montant:>10.2f}  -> {msg}")

        elif mtype == 'payout':
            ok, msg = transaction_service.create_retrait(
                compte_id, user_id, montant_dec,
                full_desc, 'compte_principal', dt
            )
            if ok:
                nb_retraits += 1
                if verbose:
                    print(f"  - Retrait {date_str} {montant:>10.2f}  "
                          f"(cpt {compte_id}, equipe {num})")
            else:
                nb_echecs += 1
                print(f"  X Payout  {date_str} {montant:>10.2f}  -> {msg}")

        else:
            nb_echecs += 1
            print(f"  ? Type inconnu : {mtype!r}")

    print(f"\\n=== Resultat : {nb_depots} depots, {nb_retraits} retraits, "
          f"{nb_echecs} echecs, {nb_ignores} ignores ===")
    return nb_depots, nb_retraits, nb_echecs, nb_ignores


if __name__ == '__main__':
    print("Ce fichier doit être importé depuis votre application.")
    print("Exemple :")
    print("    from import_shifts_transactions_multi import run")
    print("    run(transaction_service, db, user_id=1)")
''')
    return len(entries), skipped


# =====================================================
# MAIN
# =====================================================
def main():
    print("=" * 62)
    print("  IMPORT SHIFTS -> TRANSACTIONS MULTI-COMPTES (via PDV)")
    print("=" * 62)

    shifts_file    = ask_file("📄 shifts.csv : ")
    movements_file = ask_file("📄 payins-payouts.csv : ")
    user_id        = int(input("👤 ID utilisateur : ").strip())
    sql_out = input("💾 Fichier SQL (périodes) [import_shifts_periodes.sql] : ").strip() \
              or "import_shifts_periodes.sql"
    py_out  = input("🐍 Fichier Python (transactions) [import_shifts_transactions_multi.py] : ").strip() \
              or "import_shifts_transactions_multi.py"
    fb_raw = input("🆘 Compte de secours (ID) si PDV sans compte [laisser vide = ignorer] : ").strip()
    fallback_id = int(fb_raw) if fb_raw.isdigit() else None

    print("\n⏳ Parsing…")
    shifts    = parse_shifts(shifts_file)
    movements = parse_payins_payouts(movements_file)
    print(f"   ✓ {len(shifts)} périodes / {len(movements)} mouvements")

    pdv_names = {s['pdv'] for s in shifts} | {m['pdv'] for m in movements}
    pdv_map   = ask_pdv_mapping(pdv_names)

    print("\n⏳ Génération du SQL des périodes…")
    nb_periodes = generate_periodes_sql(shifts, user_id, sql_out, pdv_map)

    print("⏳ Génération du fichier Python des transactions…")
    nb_tx, nb_skip = generate_transactions_py(movements, py_out, pdv_map, fallback_id)

    print("\n" + "=" * 62)
    print(f"  ✅ {sql_out} : {nb_periodes} périodes de travail")
    print(f"  ✅ {py_out} : {nb_tx} mouvements, {nb_skip} ignorés")
    if fallback_id:
        print(f"  🆘 Compte de secours : {fallback_id}")
    else:
        print("  🆘 Compte de secours : aucun (mouvements ignorés si PDV sans compte)")
    print("=" * 62)
    print("📌 1. Sauvegarde ta base")
    print(f"📌 2. Exécute {sql_out} dans phpMyAdmin")
    print(f"📌 3. Depuis ton app Python :")
    print(f"        from {Path(py_out).stem} import run")
    print(f"        run(g.models.transaction_financiere_model, g.models.transaction_financiere_model.db, user_id={user_id})")
    print("📌 4. Vérifie les soldes des comptes liés aux PDV")


if __name__ == '__main__':
    main()