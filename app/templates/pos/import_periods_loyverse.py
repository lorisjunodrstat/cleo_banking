#!/usr/bin/env python3
"""
Import des périodes de travail Loyverse (shifts + pay in/out)
Vers : pos_periodes_travail, pos_retraits, pos_depots

Usage : python import_shifts_loyverse.py
"""

import csv
import sys
import unicodedata
from datetime import datetime
from pathlib import Path


# =====================================================
# CONFIGURATION — mapping PDV Loyverse → pos_points_de_vente.id
# (SamsungA40 → Samsung=1, Caisse principal 3 → Caisse Principale 3=2, etc.)
# =====================================================
PDV_MAP = {
    'samsunga40': 1,
    'samsung': 1,
    'caisse principal 3': 2,
    'caisse principale 3': 2,
    'terminal mobile': 3,
    'iphone roberto': 4,
    'caisse principale 2': 5,
    'caisse principal 2': 5,
}
DEFAULT_PDV_ID = 1   # utilisé si un PDV inconnu apparaît


# =====================================================
# UTILITAIRES
# =====================================================
def norm(s):
    """Normalise un en-tête : minuscule, sans accents, sans espaces/points"""
    s = unicodedata.normalize('NFKD', str(s or ''))
    s = ''.join(c for c in s if not unicodedata.combining(c))
    return re.sub(r'[^a-z0-9]', '', s.lower())


def fnum(v):
    try:
        return float(str(v).strip().replace(',', '.') or 0)
    except ValueError:
        return 0.0


def parse_dt(s):
    s = (s or '').strip()
    if not s:
        return None
    for fmt in ('%Y-%m-%d %H:%M:%S', '%Y-%m-%d %H:%M', '%d/%m/%Y %H:%M:%S', '%d/%m/%Y %H:%M'):
        try:
            return datetime.strptime(s, fmt).strftime('%Y-%m-%d %H:%M:%S')
        except ValueError:
            continue
    return None


def esc(s):
    if s is None:
        return ''
    return str(s).replace("\\", "\\\\").replace("'", "''")


def ask_file(prompt):
    while True:
        p = input(prompt).strip().strip('"').strip("'")
        if p and Path(p).exists():
            return p
        print(f"❌ Fichier introuvable : {p}")


def read_csv(path):
    """Lit un CSV et retourne des dicts avec clés normalisées
    (fonctionne avec les en-têtes Loyverse 'Numéro d'équipe'
     OU les exports R 'Numéro.d.équipe')"""
    rows = []
    with open(path, encoding='utf-8', errors='replace') as f:
        reader = csv.DictReader(f)
        fieldmap = {norm(h): h for h in (reader.fieldnames or [])}
        for raw in reader:
            rows.append({nk: (raw.get(orig) or '').strip() for nk, orig in fieldmap.items()})
    return rows


# =====================================================
# GÉNÉRATION SQL
# =====================================================
def generate_sql(shifts, moves, user_id, output_file):
    nb_shifts = nb_moves = skipped_moves = 0
    known_teams = set()
    unknown_pdv = set()

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"-- Import périodes de travail Loyverse — {datetime.now():%Y-%m-%d %H:%M:%S}\n")
        f.write("SET NAMES utf8mb4;\n")
        f.write(f"SET @uid = {user_id};\n\n")

        # ---------- 1. PÉRIODES DE TRAVAIL ----------
        f.write("-- ===== 1. PÉRIODES DE TRAVAIL (shifts) =====\n")
        for r in shifts:
            try:
                team = int(r.get('numerodequipe') or 0)
            except ValueError:
                continue
            if not team:
                continue

            pdv_name = r.get('pdv', '')
            pdv_id = PDV_MAP.get(pdv_name.lower())
            if pdv_id is None:
                unknown_pdv.add(pdv_name)
                pdv_id = DEFAULT_PDV_ID

            date_debut = parse_dt(r.get('heuredouverturedequartdetravail'))
            date_fin = parse_dt(r.get('heuredefermeturedequartdetravail'))
            if not date_debut:
                continue

            status = 'Fermé' if date_fin else 'Ouvert'
            especes_depart = fnum(r.get('especesdedepart'))
            prevu = fnum(r.get('montantenespecesprevu'))
            reel = fnum(r.get('montantenespecesreel'))
            depots = fnum(r.get('montantpaiemententrant'))
            retraits = fnum(r.get('montantpaiementsortant'))
            diff = fnum(r.get('difference'))

            f.write(f"-- Équipe Loyverse #{team} — {date_debut}\n")
            f.write("INSERT INTO pos_periodes_travail (\n")
            f.write("  utilisateur_id, magasin, pdv_id, date_debut, date_fin,\n")
            f.write("  montant_debut_prevu, montant_debut_reel,\n")
            f.write("  montant_fin_prevu, montant_fin_reel,\n")
            f.write("  montant_retrait, montant_depot, difference, status\n")
            f.write(") VALUES (\n")
            f.write(f"  @uid, '{esc(r.get('magasin'))}', {pdv_id}, '{date_debut}', "
                    f"{'' if not date_fin else chr(39) + date_fin + chr(39)},\n")
            f.write(f"  {especes_depart:.2f}, {especes_depart:.2f},\n")
            f.write(f"  {prevu:.2f}, {reel:.2f},\n")
            f.write(f"  {retraits:.2f}, {depots:.2f}, {diff:.2f}, '{status}'\n")
            f.write(");\n")
            f.write(f"SET @p{team} = LAST_INSERT_ID();\n\n")

            known_teams.add(team)
            nb_shifts += 1

        # ---------- 2. MOUVEMENTS D'ESPÈCES ----------
        f.write("-- ===== 2. MOUVEMENTS D'ESPÈCES (pay in / pay out) =====\n")
        for r in moves:
            try:
                team = int(r.get('numerodequipe') or 0)
            except ValueError:
                continue
            if team not in known_teams:
                skipped_moves += 1   # période absente du fichier shifts
                continue

            date_mvt = parse_dt(r.get('date'))
            if not date_mvt:
                continue

            montant = fnum(r.get('montant'))
            type_raw = norm(r.get('type'))
            commentaire = r.get('commentaire', '')
            employe = r.get('employe', '')
            desc = f"{commentaire} — {employe}".strip(' —')

            if type_raw.startswith('payo'):          # Payout → retrait
                f.write("INSERT INTO pos_retraits (periode_travail_id, montant_retrait, date_retrait, description)\n")
                f.write(f"VALUES (@p{team}, {montant:.2f}, '{date_mvt}', '{esc(desc)}');\n")
            elif type_raw.startswith('payi'):        # Payin → dépôt
                f.write("INSERT INTO pos_depots (periode_travail_id, montant_depot, date_depot, description)\n")
                f.write(f"VALUES (@p{team}, {montant:.2f}, '{date_mvt}', '{esc(desc)}');\n")
            else:
                continue
            nb_moves += 1

        # ---------- 3. VÉRIFICATION ----------
        f.write("\n-- ===== 3. VÉRIFICATION =====\n")
        f.write("SELECT COUNT(*) AS periodes_importees FROM pos_periodes_travail WHERE utilisateur_id = @uid;\n")
        f.write("SELECT COUNT(*) AS retraits FROM pos_retraits;\n")
        f.write("SELECT COUNT(*) AS depots FROM pos_depots;\n")

    return nb_shifts, nb_moves, skipped_moves, unknown_pdv


# =====================================================
# MAIN
# =====================================================
def main():
    print("=" * 60)
    print("  IMPORT PÉRIODES DE TRAVAIL LOYVERSE")
    print("=" * 60)

    shifts_file = ask_file("📄 CSV des shifts : ")
    moves_file = ask_file("📄 CSV pay in / pay out : ")
    user_id = int(input("👤 ID utilisateur : ").strip())
    out = input("💾 Fichier SQL [import_shifts.sql] : ").strip() or "import_shifts.sql"

    print("\n⏳ Parsing...")
    shifts = read_csv(shifts_file)
    moves = read_csv(moves_file)
    print(f"   ✓ {len(shifts)} shifts / {len(moves)} mouvements")

    print("⏳ Génération du SQL...")
    ns, nm, skipped, unknown_pdv = generate_sql(shifts, moves, user_id, out)

    print("\n" + "=" * 60)
    print(f"  ✅ {out} généré")
    print(f"     {ns} périodes importées")
    print(f"     {nm} mouvements liés")
    print(f"     {skipped} mouvements ignorés (période absente du fichier shifts)")
    if unknown_pdv:
        print(f"  ⚠️  PDV inconnus (mappés sur id {DEFAULT_PDV_ID}) : {', '.join(sorted(unknown_pdv))}")
    print("=" * 60)
    print("📌 1. Sauvegarde ta base")
    print(f"📌 2. Exécute {out} dans phpMyAdmin")
    print("📌 3. ⚠️ Ne pas exécuter 2 fois (doublons)")


if __name__ == '__main__':
    main()