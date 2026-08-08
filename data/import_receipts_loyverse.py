#!/usr/bin/env python3
"""
Import des reçus Loyverse — VERSION FINALE
• restaurant_option_id via IDs fixes (Livré=1, Sur place=2, Eat=3, À emporter=4)
• cloture_at = date du reçu
• TVA aimantée sur les taux standards (2.5 / 7.7)
• paiements multiples "Cash, Twint" découpés
"""

import csv
import sys
import unicodedata
from datetime import datetime
from collections import defaultdict
from pathlib import Path


# =====================================================
# CONFIGURATION
# =====================================================

# IDs de pos_restaurant_options (copiés depuis ta base)
RESTO_OPTION_IDS = {
    'livré': 1,
    'sur place': 2,
    'eat': 3,
    'à emporter': 4,
}


# =====================================================
# UTILITAIRES
# =====================================================

def nfc(s):
    return unicodedata.normalize('NFC', str(s or '').strip())

def fnum(v):
    try: return float(str(v).strip() or 0)
    except ValueError: return 0.0

def parse_date(s):
    try: return datetime.strptime(str(s).strip(), '%d/%m/%Y %H:%M').strftime('%Y-%m-%d %H:%M:%S')
    except Exception: return None

def esc(s):
    if s is None: return ''
    return str(s).replace("\\", "\\\\").replace("'", "''")

def snap_rate(rate):
    """Aimante le taux calculé sur les taux suisses standards"""
    for std in (2.5, 3.8, 7.7, 8.1):
        if abs(rate - std) < 0.6:
            return std
    return round(rate, 2)

def ask_file(prompt):
    while True:
        p = input(prompt).strip().strip('"').strip("'")
        if p and Path(p).exists():
            return p
        print(f"❌ Fichier introuvable : {p}")


# =====================================================
# PARSING
# =====================================================

def parse_receipts(file_path):
    """receipts.csv : 1 ligne = 1 reçu"""
    receipts = {}
    with open(file_path, encoding='utf-8', errors='replace') as f:
        for row in csv.reader(f):
            if len(row) < 19 or parse_date(row[0]) is None:
                continue
            num = nfc(row[1])
            if not num:
                continue
            receipts[num] = {
                'date': row[0].strip(),
                'type': nfc(row[2]),
                'gross': fnum(row[3]), 'discount': fnum(row[4]),
                'net': fnum(row[5]), 'tax': fnum(row[6]),
                'tips': fnum(row[7]), 'total': fnum(row[8]),
                'payment': nfc(row[11]),
                'delivery': nfc(row[13]) if len(row) > 13 else '',   # ✅ Option de restauration
                'register': nfc(row[14]) if len(row) > 14 else '',
                'business': nfc(row[15]) if len(row) > 15 else '',
                'employee': nfc(row[16]) if len(row) > 16 else '',
                'customer': nfc(row[17]) if len(row) > 17 else '',
                'phone': nfc(row[18]) if len(row) > 18 else '',
            }
    return receipts


def parse_items(file_path):
    """receipts-by-item.csv : 1 ligne = 1 article, groupé par reçu"""
    by_receipt = defaultdict(list)
    with open(file_path, encoding='utf-8', errors='replace') as f:
        for row in csv.reader(f):
            if len(row) < 16 or parse_date(row[0]) is None:
                continue
            num = nfc(row[1])
            category = nfc(row[3])
            if category in ('Paiement', 'Abonnement'):
                continue
            qty = fnum(row[8]); gross = fnum(row[9]); net = fnum(row[11]); tax = fnum(row[14])
            rate = snap_rate(abs(tax) / abs(net) * 100) if net != 0 else 0
            by_receipt[num].append({
                'sku': nfc(row[4]), 'name': nfc(row[5]), 'option': nfc(row[6]),
                'qty': qty, 'gross': gross,
                'unit': gross / qty if qty else 0,
                'tax_rate': rate,
                'comments': nfc(row[21]) if len(row) > 21 else '',
            })
    return dict(by_receipt)


# =====================================================
# GÉNÉRATION SQL
# =====================================================

def generate_sql(receipts, items_by_receipt, user_id, output_file):
    count_r = count_i = skipped = 0

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"-- Import reçus Loyverse — {datetime.now():%Y-%m-%d %H:%M:%S} — user {user_id}\n")
        f.write("SET NAMES utf8mb4;\n")
        f.write(f"SET @uid = {user_id};\n\n")

        f.write("-- 0. article_id NULL autorisé pour l'historique\n")
        f.write("ALTER TABLE pos_receipt_items MODIFY article_id INT NULL;\n\n")

        f.write("-- 1. MODES DE PAIEMENT\n")
        modes = set()
        for r in receipts.values():
            for m in (r['payment'] or 'Cash').split(','):
                if m.strip(): modes.add(m.strip())
        for m in sorted(modes):
            f.write(f"INSERT IGNORE INTO pos_modes_paiement (utilisateur_id, nom, est_actif) VALUES (@uid, '{esc(m)}', 1);\n")

        f.write("\n-- 2. CLIENTS\n")
        clients = {}
        for r in receipts.values():
            if r['customer']: clients[r['customer']] = r['phone']
        for name, phone in clients.items():
            f.write(f"INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, '{esc(name)}', '{esc(phone)}');\n")

        f.write("\n-- 3. REÇUS + ITEMS + PAIEMENTS\n")
        for num, r in sorted(receipts.items(), key=lambda kv: kv[1]['date']):
            date_sql = parse_date(r['date'])
            if not date_sql:
                skipped += 1; continue

            rtype = 'Vente' if r['type'] == 'Vente' else 'Remboursement'
            is_remb = 1 if rtype == 'Remboursement' else 0

            # ✅ ID de l'option de restauration (NULL si inconnue)
            resto_id = RESTO_OPTION_IDS.get(r['delivery'].lower())
            resto_sql = str(resto_id) if resto_id else 'NULL'

            f.write(f"\n-- Reçu {num} ({r['date']}) — {rtype} — {r['delivery'] or 'sans option'}\n")
            f.write("INSERT INTO pos_receipts (\n")
            f.write("  utilisateur_id, date, cloture_at, recu_numero, nom_ticket, receipt_type,\n")
            f.write("  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,\n")
            f.write("  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client,\n")
            f.write("  restaurant_option_id, status\n")
            f.write(") VALUES (\n")
            f.write(f"  @uid, '{date_sql}', '{date_sql}', '{esc(num)}', 'Import Loyverse', '{rtype}',\n")
            f.write(f"  {r['gross']:.2f}, {r['discount']:.2f}, {r['net']:.2f}, {r['tax']:.2f}, {r['tips']:.2f}, {r['total']:.2f},\n")
            f.write(f"  '{esc(r['register'])}', '{esc(r['business'])}', '{esc(r['employee'])}',\n")
            f.write(f"  '{esc(r['customer'])}', '{esc(r['phone'])}',\n")
            if r['customer']:
                f.write(f"  (SELECT id FROM pos_clients WHERE utilisateur_id=@uid AND nom_client='{esc(r['customer'])}' LIMIT 1),\n")
            else:
                f.write("  NULL,\n")
            f.write(f"  {resto_sql},\n")
            f.write("  'Fermé');\n")
            f.write("SET @receipt_id = LAST_INSERT_ID();\n")

            for it in items_by_receipt.get(num, []):
                name = f"{it['name']} ({it['option']})" if it['option'] else it['name']
                f.write("INSERT INTO pos_receipt_items (\n")
                f.write("  receipt_id, article_id, nom_article, quantite,\n")
                f.write("  prix_unitaire, total_ligne, taux_taxe_applique, commentaire\n")
                f.write(") SELECT @receipt_id,\n")
                f.write("  COALESCE(\n")
                f.write(f"    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='{esc(it['sku'])}' LIMIT 1),\n")
                f.write(f"    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='{esc(it['name'])}' LIMIT 1),\n")
                f.write(f"    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('{esc(it['name'])}') LIMIT 1),\n")
                f.write("    NULL),\n")
                f.write(f"  '{esc(name)}', {it['qty']:.2f}, {it['unit']:.2f}, {it['gross']:.2f}, {it['tax_rate']:.2f}, '{esc(it['comments'])}';\n")
                count_i += 1

            raw = [m.strip() for m in (r['payment'] or 'Cash').split(',') if m.strip()]
            share = abs(r['total']) / len(raw) if raw else abs(r['total'])
            for m in raw:
                f.write("INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)\n")
                f.write(f"SELECT @receipt_id, mp.id, {share:.2f}, {is_remb}\n")
                f.write("FROM pos_modes_paiement mp\n")
                f.write(f"WHERE mp.utilisateur_id=@uid AND mp.nom='{esc(m)}' LIMIT 1;\n")
            count_r += 1

        f.write("\n-- 4. RÉPARATION des article_id NULL\n")
        f.write("UPDATE pos_receipt_items ri\n")
        f.write("JOIN pos_articles a ON a.utilisateur_id=@uid AND LOWER(TRIM(a.nom_article))=LOWER(TRIM(ri.nom_article))\n")
        f.write("SET ri.article_id=a.id WHERE ri.article_id IS NULL;\n")

        f.write("\n-- 5. VÉRIFICATION\n")
        f.write("SELECT COUNT(*) AS recus FROM pos_receipts WHERE nom_ticket='Import Loyverse';\n")
        f.write("SELECT COUNT(*) AS items_sans_article FROM pos_receipt_items ri JOIN pos_receipts r ON r.id=ri.receipt_id WHERE r.nom_ticket='Import Loyverse' AND ri.article_id IS NULL;\n")

    return count_r, count_i, skipped


# =====================================================
# MAIN
# =====================================================

def main():
    print("=" * 60)
    print("  IMPORT DES REÇUS LOYVERSE — VERSION FINALE")
    print("=" * 60)

    receipts_file = ask_file("📄 receipts.csv : ")
    items_file = ask_file("📄 receipts-by-item.csv : ")
    user_id = int(input("👤 ID utilisateur : ").strip())
    out = input("💾 Fichier SQL [import_receipts.sql] : ").strip() or "import_receipts.sql"

    print("\n⏳ Parsing...")
    receipts = parse_receipts(receipts_file)
    items = parse_items(items_file)
    print(f"   ✓ {len(receipts)} reçus / {sum(len(v) for v in items.values())} articles")

    print("⏳ Génération du SQL...")
    cr, ci, sk = generate_sql(receipts, items, user_id, out)

    print("\n" + "=" * 60)
    print(f"  ✅ {out} : {cr} reçus, {ci} items, {sk} ignorés")
    print("=" * 60)
    print("📌 1. Sauvegarde ta base")
    print(f"📌 2. Exécute {out} dans phpMyAdmin")
    print("📌 3. Vérifie avec les 2 SELECT finaux")


if __name__ == '__main__':
    main()