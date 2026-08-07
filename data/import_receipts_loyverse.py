#!/usr/bin/env python3
"""
Import des reçus Loyverse vers le système POS
Combine receipts.csv et receipts-by-item.csv pour un import complet.

Usage:
    python import_receipts_loyverse.py
    
Le script va vous demander :
1. Le chemin vers receipts.csv
2. Le chemin vers receipts-by-item.csv  
3. L'ID utilisateur
4. Le nom du fichier SQL de sortie
"""

import csv
import sys
from datetime import datetime
from collections import defaultdict
from pathlib import Path


def ask_file(prompt):
    """Demande un chemin de fichier et vérifie qu'il existe"""
    while True:
        path = input(prompt).strip().strip('"').strip("'")
        if not path:
            print("❌ Chemin vide, réessayez.")
            continue
        if not Path(path).exists():
            print(f"❌ Fichier introuvable : {path}")
            continue
        return path


def parse_receipts(file_path):
    """Parse receipts.csv : 1 ligne = 1 reçu (paiements et totaux)"""
    receipts = {}
    with open(file_path, encoding='utf-8', errors='replace') as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) < 20:
                continue
            # ✅ SAUTE la ligne d'en-tête (date invalide)
            if parse_date(row[0]) is None:
                continue
            receipt_num = row[1].strip()
            if not receipt_num:
                continue
            
            receipts[receipt_num] = {
                'date': row[0].strip(),
                'type': row[2].strip(),
                'gross': fnum(row[3]),
                'discount': fnum(row[4]),
                'net': fnum(row[5]),
                'tax': fnum(row[6]),
                'tips': fnum(row[7]),
                'total': fnum(row[8]),
                'payment': row[11].strip(),
                'items_text': row[12] if len(row) > 12 else '',
                'delivery': row[13].strip() if len(row) > 13 else '',
                'register': row[14].strip() if len(row) > 14 else '',
                'business': row[15].strip() if len(row) > 15 else '',
                'employee': row[16].strip() if len(row) > 16 else '',
                'customer': row[17].strip() if len(row) > 17 else '',
                'phone': row[18].strip() if len(row) > 18 else '',
            }
    return receipts

def parse_items(file_path):
    """Parse receipts-by-item.csv : 1 ligne = 1 article, groupé par reçu"""
    items_by_receipt = defaultdict(list)
    with open(file_path, encoding='utf-8', errors='replace') as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) < 16:
                continue
            # ✅ SAUTE la ligne d'en-tête (date invalide)
            if parse_date(row[0]) is None:
                continue
            
            receipt_num = row[1].strip()
            category = row[3].strip() if len(row) > 3 else ''
            
            # Ignorer les lignes "Paiement", "Abonnement", "Devis"
            if category in ('Paiement', 'Abonnement', 'Devis'):
                continue
            
            qty = fnum(row[8])
            gross = fnum(row[9])
            net = fnum(row[11])
            tax = fnum(row[14]) if len(row) > 14 else 0
            
            # Calcul du taux de taxe appliqué
            tax_rate = 0
            if net > 0 and tax > 0:
                tax_rate = round((tax / net) * 100, 2)
            elif tax > 0 and gross > 0:
                tax_rate = round((tax / gross) * 100, 2)
            
            unit_price = gross / qty if qty != 0 else 0
            
            item = {
                'category': category,
                'sku': row[4].strip() if len(row) > 4 else '',
                'name': row[5].strip() if len(row) > 5 else '',
                'option': row[6].strip() if len(row) > 6 else '',
                'qty': qty,
                'gross': gross,
                'discount': fnum(row[10]),
                'net': net,
                'tax': tax,
                'tax_rate': tax_rate,
                'unit_price': unit_price,
                'comments': row[21].strip() if len(row) > 21 else '',
            }
            items_by_receipt[receipt_num].append(item)
    
    return dict(items_by_receipt)

def parse_date(date_str):
    """Parse 'DD/MM/YYYY HH:MM' en format SQL 'YYYY-MM-DD HH:MM:SS'"""
    try:
        dt = datetime.strptime(date_str.strip(), '%d/%m/%Y %H:%M')
        return dt.strftime('%Y-%m-%d %H:%M:%S')
    except Exception:
        return None

def fnum(v):
    """Convertit en float sans planter"""
    try:
        return float(str(v).strip() or 0)
    except ValueError:
        return 0.0

def escape_sql(s):
    """Échapper les caractères spéciaux pour SQL"""
    if s is None:
        return ''
    return str(s).replace("\\", "\\\\").replace("'", "''")


def generate_sql(receipts, items_by_receipt, user_id, output_file):
    """Génère le fichier SQL d'import"""
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"-- =====================================================\n")
        f.write(f"-- Import des reçus Loyverse\n")
        f.write(f"-- Généré le {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"-- User ID: {user_id}\n")
        f.write(f"-- =====================================================\n\n")
        f.write(f"SET @uid = {user_id};\n\n")
        
        # === MODES DE PAIEMENT ===
        f.write("-- === 1. MODES DE PAIEMENT ===\n")
        f.write("-- Crée les modes manquants (évite les doublons avec INSERT IGNORE)\n")
        payment_modes = set()
        for r in receipts.values():
            if r['payment']:
                # Normaliser : 'Eat.ch' → 'Eat.ch', 'Card' → 'Card'
                payment_modes.add(r['payment'])
        
        for mode in sorted(payment_modes):
            f.write(f"INSERT IGNORE INTO pos_modes_paiement (utilisateur_id, nom, est_actif) ")
            f.write(f"VALUES (@uid, '{escape_sql(mode)}', 1);\n")
        f.write("\n")
        
        # === CLIENTS ===
        f.write("-- === 2. CLIENTS ===\n")
        customers = {}
        for r in receipts.values():
            name = r['customer'].strip()
            if name:
                customers[name] = r['phone']
        
        for name, phone in customers.items():
            phone_sql = f", '{escape_sql(phone)}'" if phone else ''
            f.write(f"INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) ")
            f.write(f"VALUES (@uid, '{escape_sql(name)}'{phone_sql if phone else ', NULL'});\n")
        f.write("\n")
        
        # === REÇUS ===
        f.write("-- === 3. REÇUS ET ITEMS ===\n")
        receipt_count = 0
        item_count = 0
        skipped = 0
        
        for receipt_num, r in sorted(receipts.items(), key=lambda x: x[1]['date']):
            date_sql = parse_date(r['date'])
            if not date_sql:
                skipped += 1
                continue
            
            items = items_by_receipt.get(receipt_num, [])
            
            # Cas particulier : reçu sans items (ex: remboursement sans détail)
            # On crée quand même le reçu mais sans items
            if not items and r['total'] == 0:
                skipped += 1
                continue
            
            receipt_type = 'Vente' if r['type'] == 'Vente' else 'Remboursement'
            status = 'Fermé'  # Tous les reçus importés sont fermés
            
            # Nom du reçu : on utilise le numéro Loyverse
            f.write(f"\n-- Reçu {receipt_num} ({r['date']}) - {receipt_type}\n")
            f.write(f"INSERT INTO pos_receipts (\n")
            f.write(f"    utilisateur_id, date, recu_numero, nom_ticket, receipt_type,\n")
            f.write(f"    ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,\n")
            f.write(f"    pdv, magasin, nom_du_caissier, nom_du_client, numero_client, status\n")
            f.write(f") VALUES (\n")
            f.write(f"    @uid, '{date_sql}', '{escape_sql(receipt_num)}', ")
            f.write(f"'Import Loyverse', '{receipt_type}',\n")
            f.write(f"    {r['gross']:.2f}, {r['discount']:.2f}, {r['net']:.2f}, ")
            f.write(f"{r['tax']:.2f}, {r['tips']:.2f}, {r['total']:.2f},\n")
            f.write(f"    '{escape_sql(r['register'])}', '{escape_sql(r['business'])}', ")
            f.write(f"'{escape_sql(r['employee'])}',\n")
            f.write(f"    '{escape_sql(r['customer'])}', '{escape_sql(r['phone'])}', '{status}'\n")
            f.write(f");\n")
            f.write(f"SET @receipt_id = LAST_INSERT_ID();\n")
            
            # === ITEMS ===
            for item in items:
                item_name = item['name']
                option = item['option']
                if option:
                    item_name = f"{item_name} ({option})"
                
                # Essayer de mapper à un article existant via SKU ou nom
                f.write(f"-- Article: {item_name} x{item['qty']}\n")
                f.write(f"INSERT INTO pos_receipt_items (\n")
                f.write(f"    receipt_id, article_id, nom_article, variante_id, quantite,\n")
                f.write(f"    prix_unitaire, total_ligne, taux_taxe_applique, commentaire\n")
                f.write(f") SELECT\n")
                f.write(f"    @receipt_id,\n")
                f.write(f"    COALESCE((SELECT id FROM pos_articles WHERE utilisateur_id = @uid AND code_barre = '{escape_sql(item['sku'])}' LIMIT 1),\n")
                f.write(f"             (SELECT id FROM pos_articles WHERE utilisateur_id = @uid AND nom_article = '{escape_sql(item['name'])}' LIMIT 1),\n")
                f.write(f"             NULL),\n")
                f.write(f"    '{escape_sql(item_name)}',\n")
                f.write(f"    NULL,\n")
                f.write(f"    {item['qty']:.2f},\n")
                f.write(f"    {item['unit_price']:.2f},\n")
                f.write(f"    {item['gross']:.2f},\n")
                f.write(f"    {item['tax_rate']:.2f},\n")
                f.write(f"    '{escape_sql(item['comments'])}'\n")
                f.write(f";\n")
                item_count += 1
            
            # === PAIEMENT ===
            payment_mode = r['payment'] or 'Cash'
            payment_amount = abs(r['total'])
            f.write(f"-- Paiement: {payment_mode}\n")
            f.write(f"INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)\n")
            f.write(f"SELECT @receipt_id, mp.id, {payment_amount:.2f}, ")
            f.write(f"{'1' if receipt_type == 'Remboursement' else '0'}\n")
            f.write(f"FROM pos_modes_paiement mp\n")
            f.write(f"WHERE mp.utilisateur_id = @uid AND mp.nom = '{escape_sql(payment_mode)}' LIMIT 1;\n")
            
            receipt_count += 1
        
        f.write(f"\n-- =====================================================\n")
        f.write(f"-- RÉSUMÉ DE L'IMPORT\n")
        f.write(f"-- {receipt_count} reçus importés\n")
        f.write(f"-- {item_count} lignes d'articles\n")
        f.write(f"-- {skipped} reçus ignorés (date invalide ou vide)\n")
        f.write(f"-- =====================================================\n")
    
    return receipt_count, item_count, skipped


def main():
    print("=" * 60)
    print("  IMPORT DES REÇUS LOYVERSE")
    print("=" * 60)
    print()
    print("Ce script va importer vos reçus Loyverse en combinant :")
    print("  - receipts.csv (paiements et totaux)")
    print("  - receipts-by-item.csv (articles détaillés)")
    print()
    
    try:
        receipts_file = ask_file("📄 Chemin vers receipts.csv : ")
        items_file = ask_file("📄 Chemin vers receipts-by-item.csv : ")
        
        user_id_str = input("👤 ID utilisateur (ex: 6) : ").strip()
        user_id = int(user_id_str)
        
        output_file = input("💾 Fichier SQL de sortie [import_receipts.sql] : ").strip()
        if not output_file:
            output_file = "import_receipts.sql"
        
        print()
        print("⏳ Parsing des fichiers...")
        
        receipts = parse_receipts(receipts_file)
        print(f"   ✓ {len(receipts)} reçus trouvés dans receipts.csv")
        
        items = parse_items(items_file)
        total_items = sum(len(v) for v in items.values())
        print(f"   ✓ {len(items)} reçus avec {total_items} articles dans receipts-by-item.csv")
        
        print()
        print("⏳ Génération du SQL...")
        count_r, count_i, skipped = generate_sql(receipts, items, user_id, output_file)
        
        print()
        print("=" * 60)
        print(f"  ✅ TERMINÉ !")
        print("=" * 60)
        print(f"  📁 Fichier SQL : {output_file}")
        print(f"  📋 {count_r} reçus à importer")
        print(f"  📦 {count_i} lignes d'articles")
        print(f"  ⚠️  {skipped} reçus ignorés")
        print()
        print("📌 PROCHAINES ÉTAPES :")
        print(f"  1. Ouvrez {output_file} et vérifiez les premières lignes")
        print(f"  2. Importez-le dans phpMyAdmin ou votre client SQL")
        print(f"  3. Vérifiez les données dans pos_receipts et pos_receipt_items")
        print()
        
    except KeyboardInterrupt:
        print("\n\n❌ Annulé par l'utilisateur.")
        sys.exit(1)
    except Exception as e:
        print(f"\n\n❌ Erreur : {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()