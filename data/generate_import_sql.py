# generate_import_sql.py
import csv, re

UID = 6
CSV_PATH = '/Users/ljunodrstat/AppBancaireLocaldocker/data/export_items-5.csv'
OUT_PATH = '/Users/ljunodrstat/AppBancaireLocaldocker/data/import_articles.sql'

# Catégories "techniques" à ne pas importer comme articles vendables
EXCLUDE_CATEGORIES = {'Paiement', 'Abonnement', 'Devis'}

def esc(s):
    return str(s or '').replace("\\", "\\\\").replace("'", "\\'")

def num(v, default=0.0):
    try: return float(str(v).strip().replace(',', '.'))
    except (ValueError, TypeError): return default

with open(CSV_PATH, encoding='utf-8') as f:
    reader = csv.DictReader(f)
    headers = reader.fieldnames
    rows = list(reader)

modifier_cols = [h for h in headers if h and h.startswith('Modifier - ')]
tax_cols      = [h for h in headers if h and h.startswith('Tax - ')]

def mod_name(h): return h.replace('Modifier - ', '').strip().strip('"')
def tax_name(h):
    m = re.search(r'"([^"]+)"', h)
    return m.group(1) if m else h

sql = [f"SET @uid = {UID};"]

# ===== CATÉGORIES =====
cats = sorted({(r.get('Category') or 'Divers').strip() or 'Divers'
               for r in rows if (r.get('Name') or '').strip()})
sql.append("\n-- ===== CATÉGORIES =====")
for c in cats:
    sql.append(f"INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, '{esc(c)}');")

# ===== TAXES =====
sql.append("\n-- ===== TAXES =====")
sql.append("INSERT IGNORE INTO pos_taxes (utilisateur_id, nom, taux, date_debut, est_actif) VALUES (@uid, 'Alcool', 7.70, CURDATE(), 1);")
sql.append("INSERT IGNORE INTO pos_taxes (utilisateur_id, nom, taux, date_debut, est_actif) VALUES (@uid, 'Alimentaire', 2.50, CURDATE(), 1);")

# ===== ARTICLES + LIAISONS + VARIANTES =====
sql.append("\n-- ===== ARTICLES =====")
last_handle = None
nb_articles = 0

for r in rows:
    handle = (r.get('Handle') or '').strip()
    name   = (r.get('Name') or '').strip()

    # Ligne de variante (continuation d'un article : Name vide, même Handle)
    if not name and handle and handle == last_handle:
        opt_val = (r.get('Option 1 value') or '').strip()
        if opt_val:
            prix  = num(r.get('Price [Esprit Sushi Fribourg]'))
            stock = int(num(r.get('In stock [Esprit Sushi Fribourg]')))
            sql.append(f"INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) "
                       f"VALUES (@art_id, '{esc(opt_val)}', @opt_name, {prix:.2f}, {stock}, 1);")
        continue

    if not name or not handle:
        continue

    cat = (r.get('Category') or 'Divers').strip() or 'Divers'
    if cat in EXCLUDE_CATEGORIES:
        last_handle = None   # ⚠️ important : ne pas attacher les variantes au mauvais article
        continue

    price_raw = (r.get('Price [Esprit Sushi Fribourg]') or '').strip()
    is_var = price_raw.lower() == 'variable'
    prix   = 0.0 if is_var else num(price_raw)
    cout   = num(r.get('Cost'))
    stock  = int(num(r.get('In stock [Esprit Sushi Fribourg]')))
    low    = int(num(r.get('Low stock [Esprit Sushi Fribourg]')))
    actif  = 1 if (r.get('Available for sale [Esprit Sushi Fribourg]') or '').strip().upper() == 'Y' else 0
    vendu  = 'kg' if (r.get('Sold by weight') or '').strip().upper() == 'Y' else 'piece'
    barcode = (r.get('Barcode') or '').strip()
    desc   = (r.get('Description') or '').strip()

    sql.append(f"\n-- {name} (SKU {r.get('SKU')})")
    sql.append(
        "INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, "
        "prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) "
        f"SELECT @uid, c.id, '{esc(name)}', '{esc(desc)}', '{vendu}', {prix:.2f}, {cout:.2f}, {stock}, {low}, "
        f"{1 if is_var else 0}, '{esc(barcode)}', {actif} "
        f"FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = '{esc(cat)}';"
    )
    sql.append("SET @art_id = LAST_INSERT_ID();")
    nb_articles += 1
    last_handle = handle

    # Liaisons modificateurs (colonnes Y/N)
    for h in modifier_cols:
        if (r.get(h) or '').strip().upper() == 'Y':
            sql.append("INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) "
                       f"SELECT @art_id, m.id FROM pos_modificateurs m "
                       f"WHERE m.utilisateur_id = @uid AND m.nom_modificateur = '{esc(mod_name(h))}';")

    # Liaisons taxes
    for h in tax_cols:
        if (r.get(h) or '').strip().upper() == 'Y':
            sql.append("INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) "
                       f"SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t "
                       f"WHERE t.utilisateur_id = @uid AND t.nom = '{esc(tax_name(h))}';")

    # Variante principale (Option 1 de la ligne mère)
    opt_name = (r.get('Option 1 name') or '').strip()
    opt_val  = (r.get('Option 1 value') or '').strip()
    if opt_name and opt_val:
        sql.append(f"SET @opt_name = '{esc(opt_name)}';")
        sql.append(f"INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) "
                   f"VALUES (@art_id, '{esc(opt_val)}', @opt_name, {prix:.2f}, {stock}, 1);")
    else:
        sql.append("SET @opt_name = NULL;")

with open(OUT_PATH, 'w', encoding='utf-8') as f:
    f.write('\n'.join(sql))

print(f"✅ {nb_articles} articles → {OUT_PATH}")