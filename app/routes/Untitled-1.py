# app/routes.py
from flask import (Blueprint, render_template, request, redirect, 
                   url_for, flash, current_app, session, jsonify)
from flask_login import login_user, logout_user, login_required, current_user
from werkzeug.security import check_password_hash, generate_password_hash
from app import db, models
from datetime import datetime, date
from decimal import Decimal
import pandas as pd
import io
import re
import json


main_bp = Blueprint('main', __name__)


# ============================================================
# UTILITAIRES
# ============================================================
def safe_float(val, default=0):
    """Convertit une valeur en float de manière sûre"""
    if pd.isna(val) or val is None or val == '':
        return default
    try:
        return float(str(val).replace(',', '.'))
    except (ValueError, TypeError):
        return default


def safe_decimal(val, default=Decimal('0')):
    """Convertit une valeur en Decimal de manière sûre"""
    if pd.isna(val) or val is None or val == '':
        return default
    try:
        return Decimal(str(val).replace(',', '.'))
    except (ValueError, TypeError):
        return default


def parse_date(date_str):
    """Parse une date dans différents formats"""
    if pd.isna(date_str) or date_str is None:
        return datetime.now()
    
    date_str = str(date_str).strip()
    
    formats = [
        '%d/%m/%y %H:%M',
        '%d/%m/%Y %H:%M',
        '%Y-%m-%d %H:%M:%S',
        '%Y-%m-%d %H:%M',
        '%d/%m/%Y',
        '%d/%m/%y',
        '%m/%d/%y %H:%M',
    ]
    
    for fmt in formats:
        try:
            return datetime.strptime(date_str, fmt)
        except ValueError:
            continue
    
    return datetime.now()


def get_or_create_client_pos(nom, numero=None):
    """Récupère ou crée un client POS"""
    if not nom or nom == '' or nom == 'nan':
        return None
    
    clients = models.client_pos_model.search(current_user.id, nom, limit=1)
    if clients:
        return clients[0]
    
    # Créer le client
    client_id = models.client_pos_model.create(current_user.id, {
        'nom_client': nom,
        'numero_client': numero or ''
    })
    
    if client_id:
        return models.client_pos_model.get_by_id(client_id, current_user.id)
    return None


# ============================================================
# AUTHENTIFICATION
# ============================================================
@main_bp.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('main.index'))
    
    if request.method == 'POST':
        email = request.form.get('email', '').strip()
        password = request.form.get('password', '')
        remember = request.form.get('remember') == 'on'
        
        if not email or not password:
            flash('Veuillez remplir tous les champs.', 'error')
            return render_template('login.html')
        
        user = models.user_model.get_by_email(email, db)
        
        if user and check_password_hash(user.mot_de_passe, password):
            login_user(user, remember=remember)
            flash(f'Bienvenue {user.nom} {user.prenom} !', 'success')
            
            next_page = request.args.get('next')
            if next_page:
                return redirect(next_page)
            return redirect(url_for('main.index'))
        else:
            flash('Email ou mot de passe incorrect.', 'error')
    
    return render_template('login.html')


@main_bp.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Vous avez été déconnecté.', 'info')
    return redirect(url_for('main.login'))


@main_bp.route('/profil', methods=['GET', 'POST'])
@login_required
def profil():
    if request.method == 'POST':
        nom = request.form.get('nom', '').strip()
        prenom = request.form.get('prenom', '').strip()
        email = request.form.get('email', '').strip()
        new_password = request.form.get('new_password', '')
        
        # Mise à jour via le modèle
        # Note: Il faudrait ajouter une méthode update dans Utilisateur
        # Pour l'instant, on utilise directement db
        with db.get_cursor() as cursor:
            query = "UPDATE utilisateurs SET nom = %s, prenom = %s, email = %s"
            params = [nom, prenom, email]
            
            if new_password and len(new_password) >= 6:
                query += ", mot_de_passe = %s"
                params.append(generate_password_hash(new_password))
            
            query += " WHERE id = %s"
            params.append(current_user.id)
            
            cursor.execute(query, params)
        
        flash('Profil mis à jour avec succès.', 'success')
        return redirect(url_for('main.profil'))
    
    return render_template('/pos/profil.html')


# ============================================================
# PAGE D'ACCUEIL
# ============================================================
@main_bp.route('/')
@login_required
def index():
    return render_template('index.html')


# ============================================================
# PAGE DES REÇUS
# ============================================================
@main_bp.route('/recu')
@login_required
def recu():
    page = request.args.get('page', 1, type=int)
    search = request.args.get('search', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    # Récupérer les reçus via le modèle POS
    receipts = models.receipt_pos_model.get_all(
        user_id=current_user.id,
        date_from=date_from,
        date_to=date_to,
        limit=100
    )
    
    # Filtrer par recherche si nécessaire
    if search:
        receipts = [r for r in receipts if 
                   search.lower() in (r.get('recu_numero', '') or '').lower() or
                   search.lower() in (r.get('nom_du_client', '') or '').lower() or
                   search.lower() in (r.get('nom_du_caissier', '') or '').lower()]
    
    # Pagination simple
    per_page = 20
    total = len(receipts)
    start = (page - 1) * per_page
    end = start + per_page
    paginated_receipts = receipts[start:end]
    
    # Statistiques globales
    total_receipts = total
    total_revenue = sum(float(r.get('total_collecte', 0) or 0) for r in receipts)
    sales_count = sum(1 for r in receipts if r.get('receipt_type') == 'Vente')
    refunds_count = sum(1 for r in receipts if r.get('receipt_type') == 'Remboursement')
    
    # Modes de paiement
    payment_methods = models.mode_paiement_pos_model.get_all(current_user.id)
    
    # Caissiers uniques
    employees = list(set(r.get('nom_du_caissier', '') for r in receipts if r.get('nom_du_caissier')))
    
    return render_template('index.html', 
                         receipts_data=[{'r': r, 'payment_str': '-'} for r in paginated_receipts],
                         pagination={'page': page, 'total': total, 'per_page': per_page},
                         search=search,
                         date_from=date_from,
                         date_to=date_to,
                         total_receipts=total_receipts,
                         total_revenue=total_revenue,
                         payment_methods=[p['nom'] for p in payment_methods],
                         employees=employees,
                         sales_count=sales_count,
                         refunds_count=refunds_count)


# ============================================================
# DÉTAIL D'UN REÇU
# ============================================================
@main_bp.route('/receipt/<int:id>')
@login_required
def receipt_detail(id):
    receipt = models.receipt_pos_model.get_by_id(id, current_user.id)
    
    if not receipt:
        flash('Reçu non trouvé.', 'error')
        return redirect(url_for('main.recu'))
    
    return render_template('/pos/receipt_detail.html', 
                         receipt=receipt,
                         paiements=receipt.get('payments', []),
                         articles_lies=receipt.get('items', []))


@main_bp.route('/receipt/<int:id>/json')
@login_required
def receipt_detail_json(id):
    """Retourne les données du reçu en JSON pour le modal"""
    receipt = models.receipt_pos_model.get_by_id(id, current_user.id)
    
    if not receipt:
        return jsonify({'error': 'Reçu non trouvé'}), 404
    
    return {
        'id': receipt['id'],
        'receipt_number': receipt['recu_numero'],
        'date_formatted': receipt['date'].strftime('%d/%m/%Y %H:%M') if receipt['date'] else '',
        'receipt_type': receipt['receipt_type'],
        'status': receipt['status'],
        'client_name': receipt.get('nom_du_client', ''),
        'cashier_name': receipt.get('nom_du_caissier', ''),
        'ventes_brutes': float(receipt.get('ventes_brutes', 0) or 0),
        'reduction': float(receipt.get('reduction', 0) or 0),
        'ventes_nettes': float(receipt.get('ventes_nettes', 0) or 0),
        'taxes': float(receipt.get('taxes', 0) or 0),
        'tips': float(receipt.get('tips', 0) or 0),
        'total_collecte': float(receipt.get('total_collecte', 0) or 0),
        'description': receipt.get('description', ''),
        'paiements': [{
            'mode_paiement': p.get('mode_paiement_nom', ''),
            'montant': float(p.get('montant', 0) or 0)
        } for p in receipt.get('payments', [])],
        'items': [{
            'nom_article': item.get('nom_article', ''),
            'quantite': item.get('quantite', 1),
            'prix_unitaire': float(item.get('prix_unitaire', 0) or 0),
            'total_ligne': float(item.get('total_ligne', 0) or 0)
        } for item in receipt.get('items', [])]
    }


# ============================================================
# VENTES PAR MODE DE PAIEMENT
# ============================================================
@main_bp.route('/payment-methods')
@login_required
def payment_methods():
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    # Récupérer tous les reçus
    receipts = models.receipt_pos_model.get_all(
        user_id=current_user.id,
        date_from=date_from,
        date_to=date_to
    )
    
    # Agréger par mode de paiement
    payment_stats = {}
    for receipt in receipts:
        for payment in receipt.get('payments', []):
            mode_nom = payment.get('mode_paiement_nom', 'Inconnu')
            if mode_nom not in payment_stats:
                payment_stats[mode_nom] = {
                    'method': mode_nom,
                    'transactions': 0,
                    'amount': 0,
                    'refund_transactions': 0,
                    'refund_amount': 0,
                    'net': 0
                }
            
            payment_stats[mode_nom]['transactions'] += 1
            montant = float(payment.get('montant', 0) or 0)
            payment_stats[mode_nom]['amount'] += montant
            
            if receipt.get('receipt_type') == 'Remboursement':
                payment_stats[mode_nom]['refund_transactions'] += 1
                payment_stats[mode_nom]['refund_amount'] += montant
            else:
                payment_stats[mode_nom]['net'] += montant
    
    payment_data = list(payment_stats.values())
    
    # Totaux
    totals = {
        'transactions': sum(p['transactions'] for p in payment_data),
        'amount': sum(p['amount'] for p in payment_data),
        'refund_transactions': sum(p['refund_transactions'] for p in payment_data),
        'refund_amount': sum(p['refund_amount'] for p in payment_data),
        'net': sum(p['net'] for p in payment_data)
    }
    
    # Caissiers uniques
    employees = list(set(r.get('nom_du_caissier', '') for r in receipts if r.get('nom_du_caissier')))
    
    return render_template('/pos/payment_methods.html',
                         payment_data=payment_data,
                         totals=totals,
                         date_from=date_from,
                         date_to=date_to,
                         employees=employees)


# ============================================================
# VENTES PAR ARTICLE
# ============================================================
@main_bp.route('/by-article')
@login_required
def by_article():
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    # Récupérer tous les reçus
    receipts = models.receipt_pos_model.get_all(
        user_id=current_user.id,
        date_from=date_from,
        date_to=date_to
    )
    
    # Agréger par article
    article_stats = {}
    for receipt in receipts:
        for item in receipt.get('items', []):
            article_id = item.get('article_id')
            if article_id not in article_stats:
                article_stats[article_id] = {
                    'name': item.get('nom_article', ''),
                    'category': item.get('nom_categorie', ''),
                    'times_sold': 0,
                    'total_qty': 0,
                    'total_revenue': 0
                }
            
            article_stats[article_id]['times_sold'] += 1
            article_stats[article_id]['total_qty'] += item.get('quantite', 1)
            article_stats[article_id]['total_revenue'] += float(item.get('total_ligne', 0) or 0)
    
    articles = sorted(article_stats.values(), key=lambda x: x['total_revenue'], reverse=True)
    
    return render_template('/pos/by_article.html',
                         articles=articles,
                         date_from=date_from,
                         date_to=date_to)


# ============================================================
# VENTES PAR CATÉGORIE
# ============================================================
@main_bp.route('/by-category')
@login_required
def by_category():
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    # Récupérer tous les reçus
    receipts = models.receipt_pos_model.get_all(
        user_id=current_user.id,
        date_from=date_from,
        date_to=date_to
    )
    
    # Agréger par catégorie
    category_stats = {}
    for receipt in receipts:
        for item in receipt.get('items', []):
            category = item.get('nom_categorie', 'Sans catégorie')
            if category not in category_stats:
                category_stats[category] = {
                    'name': category,
                    'times_sold': 0,
                    'total_qty': 0,
                    'total_revenue': 0
                }
            
            category_stats[category]['times_sold'] += 1
            category_stats[category]['total_qty'] += item.get('quantite', 1)
            category_stats[category]['total_revenue'] += float(item.get('total_ligne', 0) or 0)
    
    categories = sorted(category_stats.values(), key=lambda x: x['total_revenue'], reverse=True)
    
    return render_template('/pos/by_category.html',
                         categories=categories,
                         date_from=date_from,
                         date_to=date_to)


# ============================================================
# VENTES PAR EMPLOYÉ
# ============================================================
@main_bp.route('/by-employee')
@login_required
def by_employee():
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    # Récupérer tous les reçus
    receipts = models.receipt_pos_model.get_all(
        user_id=current_user.id,
        date_from=date_from,
        date_to=date_to
    )
    
    # Agréger par caissier
    employee_stats = {}
    for receipt in receipts:
        cashier = receipt.get('nom_du_caissier', 'Inconnu')
        if cashier not in employee_stats:
            employee_stats[cashier] = {
                'name': cashier,
                'receipt_count': 0,
                'total_sales': 0,
                'total_taxes': 0,
                'total_tips': 0
            }
        
        employee_stats[cashier]['receipt_count'] += 1
        employee_stats[cashier]['total_sales'] += float(receipt.get('ventes_nettes', 0) or 0)
        employee_stats[cashier]['total_taxes'] += float(receipt.get('taxes', 0) or 0)
        employee_stats[cashier]['total_tips'] += float(receipt.get('tips', 0) or 0)
    
    employees = sorted(employee_stats.values(), key=lambda x: x['total_sales'], reverse=True)
    
    return render_template('/pos/by_employee.html',
                         employees=employees,
                         date_from=date_from,
                         date_to=date_to)


# ============================================================
# LISTE D'ARTICLES
# ============================================================
@main_bp.route('/items')
@login_required
def items():
    page = request.args.get('page', 1, type=int)
    search = request.args.get('search', '')
    category_filter = request.args.get('category', '')
    
    # Récupérer les articles
    articles = models.article_pos_model.get_all(
        user_id=current_user.id,
        categorie_id=int(category_filter) if category_filter else None
    )
    
    # Filtrer par recherche
    if search:
        articles = [a for a in articles if search.lower() in a.get('nom_article', '').lower()]
    
    # Pagination simple
    per_page = 20
    total = len(articles)
    start = (page - 1) * per_page
    end = start + per_page
    paginated_articles = articles[start:end]
    
    # Catégories
    categories = models.categorie_pos_model.get_all(current_user.id)
    
    return render_template('/pos/items.html',
                         items=paginated_articles,
                         pagination={'page': page, 'total': total, 'per_page': per_page},
                         search=search,
                         category_filter=category_filter,
                         categories=categories)


# ============================================================
# CATÉGORIES
# ============================================================
@main_bp.route('/categories')
@login_required
def categories():
    cats = models.categorie_pos_model.get_all(current_user.id)
    
    categories_data = [{
        'id': cat['id'],
        'name': cat['nom_categorie'],
        'item_count': cat.get('nb_articles', 0)
    } for cat in cats]
    
    return render_template('/pos/categories.html', categories=categories_data)


# ============================================================
# MODIFICATEURS
# ============================================================
@main_bp.route('/modifiers')
@login_required
def modifiers():
    search = request.args.get('search', '')
    
    mods = models.modificateur_pos_model.get_all(current_user.id)
    
    if search:
        mods = [m for m in mods if search.lower() in m.get('nom_modificateur', '').lower()]
    
    return render_template('/pos/modifiers.html', modifiers=mods, search=search)


# ============================================================
# PÉRIODES DE TRAVAIL
# ============================================================
@main_bp.route('/work-periods')
@login_required
def work_periods():
    """Liste des périodes de travail"""
    date_filter = request.args.get('date', datetime.now().strftime('%Y-%m-%d'))
    
    # Récupérer les périodes via le modèle
    # Note: Il faudrait ajouter une méthode get_by_date dans PeriodeTravailPOS
    # Pour l'instant, on utilise get_ouverte
    period = models.periode_travail_pos_model.get_ouverte(current_user.id)
    
    periods = [period] if period else []
    
    return render_template('/pos/work_periods.html',
                         periods=periods,
                         date_filter=date_filter)


@main_bp.route('/work-period/open', methods=['GET', 'POST'])
@login_required
def open_work_period():
    """Ouvrir une nouvelle période de travail"""
    pdvs = []  # Récupérer les PDV via le modèle
    
    if request.method == 'POST':
        pdv_id = request.form.get('pdv_id')
        magasin = request.form.get('magasin', '')
        montant_debut = safe_decimal(request.form.get('montant_debut', 0))
        
        period_id = models.periode_travail_pos_model.ouvrir_caisse(current_user.id, {
            'magasin': magasin,
            'pdv_id': pdv_id,
            'montant_debut_prevu': float(montant_debut),
            'montant_debut_reel': float(montant_debut)
        })
        
        if period_id:
            flash('Période de travail ouverte avec succès !', 'success')
            return redirect(url_for('main.work_periods'))
        else:
            flash('Impossible d\'ouvrir la période. Une période est peut-être déjà ouverte.', 'error')
    
    return render_template('/pos/open_work_period.html', pdvs=pdvs)


@main_bp.route('/work-period/<int:period_id>/close', methods=['GET', 'POST'])
@login_required
def close_work_period(period_id):
    """Fermer une période de travail"""
    # Récupérer la période
    # Note: Il faudrait ajouter une méthode get_by_id dans PeriodeTravailPOS
    
    if request.method == 'POST':
        montant_fin_reel = safe_decimal(request.form.get('montant_fin_reel', 0))
        
        success, msg = models.periode_travail_pos_model.fermer_caisse(
            period_id, 
            current_user.id,
            {'montant_fin_reel': float(montant_fin_reel)}
        )
        
        if success:
            flash(msg, 'success')
            return redirect(url_for('main.work_periods'))
        else:
            flash(msg, 'error')
    
    return render_template('/pos/close_work_period.html', period_id=period_id)


@main_bp.route('/work-period/<int:period_id>/cash-movement', methods=['GET', 'POST'])
@login_required
def add_cash_movement(period_id):
    """Ajouter un retrait ou dépôt d'espèces"""
    if request.method == 'POST':
        type_mouvement = request.form.get('type')
        montant = safe_decimal(request.form.get('montant', 0))
        compte_bancaire_id = request.form.get('compte_bancaire_id')
        
        if type_mouvement == 'retrait':
            success, msg = models.mouvement_caisse_pos_model.enregistrer_retrait(
                period_id, 
                current_user.id,
                montant,
                int(compte_bancaire_id) if compte_bancaire_id else None
            )
        else:
            success, msg = models.mouvement_caisse_pos_model.enregistrer_depot(
                period_id,
                current_user.id,
                montant,
                int(compte_bancaire_id) if compte_bancaire_id else None
            )
        
        if success:
            flash(msg, 'success')
        else:
            flash(msg, 'error')
        
        return redirect(url_for('main.work_periods'))
    
    return render_template('/pos/add_cash_movement.html', period_id=period_id)


# ============================================================
# TAXES
# ============================================================
@main_bp.route('/taxes')
@login_required
def taxes():
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    receipts = models.receipt_pos_model.get_all(
        user_id=current_user.id,
        date_from=date_from,
        date_to=date_to
    )
    
    # Filtrer ceux avec taxes > 0
    receipts_with_taxes = [r for r in receipts if float(r.get('taxes', 0) or 0) > 0]
    total_taxes = sum(float(r.get('taxes', 0) or 0) for r in receipts_with_taxes)
    
    return render_template('/pos/taxes.html',
                         receipts=receipts_with_taxes,
                         total=total_taxes,
                         label='Taxes',
                         date_from=date_from,
                         date_to=date_to)


# ============================================================
# CRÉATION D'ARTICLES
# ============================================================
@main_bp.route('/create/article', methods=['GET', 'POST'])
@login_required
def create_article():
    categories = models.categorie_pos_model.get_all(current_user.id)
    taxes = models.taxe_pos_model.get_all(current_user.id)
    
    if request.method == 'POST':
        article_id = models.article_pos_model.create(current_user.id, {
            'nom_article': request.form.get('nom_article'),
            'id_categorie': int(request.form.get('id_categorie')),
            'id_sous_categorie': int(request.form.get('id_sous_categorie')) if request.form.get('id_sous_categorie') else None,
            'prix_unitaire': float(request.form.get('prix_unitaire', 0)),
            'cout_unitaire': float(request.form.get('cout_unitaire', 0)),
            'is_variable_price': 'is_variable_price' in request.form,
            'description': request.form.get('description', ''),
            'stock': int(request.form.get('stock', 0)),
            'stock_alerte': int(request.form.get('stock_alerte', 0))
        })
        
        if article_id:
            # Assigner la taxe
            taxe_id = request.form.get('taxe_id')
            if taxe_id:
                models.taxe_pos_model.assigner_to_article(
                    article_id,
                    int(taxe_id),
                    datetime.now().date()
                )
            
            flash('Article créé avec succès !', 'success')
            return redirect(url_for('main.items'))
        else:
            flash('Erreur lors de la création de l\'article.', 'error')
    
    return render_template('/pos/create_article.html', 
                         categories=categories, 
                         taxes=taxes)


@main_bp.route('/edit/article/<int:article_id>', methods=['GET', 'POST'])
@login_required
def edit_article(article_id):
    article = models.article_pos_model.get_by_id(article_id)
    
    if not article or article.get('utilisateur_id') != current_user.id:
        flash('Article non trouvé.', 'error')
        return redirect(url_for('main.items'))
    
    categories = models.categorie_pos_model.get_all(current_user.id)
    taxes = models.taxe_pos_model.get_all(current_user.id)
    all_modifiers = models.modificateur_pos_model.get_all(current_user.id)
    
    if request.method == 'POST':
        success = models.article_pos_model.update(article_id, current_user.id, {
            'nom_article': request.form.get('nom_article'),
            'id_categorie': int(request.form.get('id_categorie')),
            'id_sous_categorie': int(request.form.get('id_sous_categorie')) if request.form.get('id_sous_categorie') else None,
            'prix_unitaire': float(request.form.get('prix_unitaire', 0)),
            'cout_unitaire': float(request.form.get('cout_unitaire', 0)),
            'is_variable_price': 'is_variable_price' in request.form,
            'description': request.form.get('description', ''),
            'stock': int(request.form.get('stock', 0)),
            'stock_alerte': int(request.form.get('stock_alerte', 0))
        })
        
        if success:
            # Mettre à jour la taxe
            taxe_id = request.form.get('taxe_id')
            if taxe_id:
                models.taxe_pos_model.assigner_to_article(
                    article_id,
                    int(taxe_id),
                    datetime.now().date()
                )
            
            flash('Article modifié avec succès !', 'success')
            return redirect(url_for('main.items'))
        else:
            flash('Erreur lors de la modification.', 'error')
    
    # Récupérer les détails complets
    article_details = models.article_pos_model.get_with_details(article_id)
    
    return render_template('/pos/edit_article.html', 
                         article=article_details,
                         categories=categories, 
                         taxes=taxes,
                         all_modifiers=all_modifiers)


@main_bp.route('/delete/article/<int:article_id>', methods=['POST'])
@login_required
def delete_article(article_id):
    success = models.article_pos_model.delete(article_id, current_user.id)
    
    if success:
        flash('Article supprimé avec succès.', 'success')
    else:
        flash('Impossible de supprimer cet article (utilisé dans des reçus).', 'error')
    
    return redirect(url_for('main.items'))


# ============================================================
# CRUD CATÉGORIES
# ============================================================
@main_bp.route('/create/category', methods=['GET', 'POST'])
@login_required
def create_category():
    if request.method == 'POST':
        cat_id = models.categorie_pos_model.create(
            current_user.id,
            request.form.get('nom_categorie'),
            request.form.get('description', '')
        )
        
        if cat_id:
            flash('Catégorie créée avec succès !', 'success')
            return redirect(url_for('main.categories'))
        else:
            flash('Erreur lors de la création.', 'error')
    
    return render_template('/pos/create_category.html')


@main_bp.route('/edit/category/<int:category_id>', methods=['GET', 'POST'])
@login_required
def edit_category(category_id):
    categorie = models.categorie_pos_model.get_by_id(category_id, current_user.id)
    
    if not categorie:
        flash('Catégorie non trouvée.', 'error')
        return redirect(url_for('main.categories'))
    
    if request.method == 'POST':
        success = models.categorie_pos_model.update(category_id, current_user.id, {
            'nom_categorie': request.form.get('nom_categorie'),
            'description': request.form.get('description', '')
        })
        
        if success:
            flash('Catégorie modifiée avec succès !', 'success')
            return redirect(url_for('main.categories'))
        else:
            flash('Erreur lors de la modification.', 'error')
    
    return render_template('/pos/edit_category.html', categorie=categorie)


@main_bp.route('/delete/category/<int:category_id>', methods=['POST'])
@login_required
def delete_category(category_id):
    success = models.categorie_pos_model.delete(category_id, current_user.id)
    
    if success:
        flash('Catégorie supprimée avec succès.', 'success')
    else:
        flash('Impossible de supprimer cette catégorie (articles liés).', 'error')
    
    return redirect(url_for('main.categories'))


# ============================================================
# CRUD MAGASINS
# ============================================================
@main_bp.route('/stores/list')
@login_required
def store_list():
    stores = models.magasin_pos_model.get_by_user(current_user.id)
    return render_template('/pos/store_list.html', stores=stores)


@main_bp.route('/create/store', methods=['GET', 'POST'])
@login_required
def create_store():
    if request.method == 'POST':
        store_id = models.magasin_pos_model.create(current_user.id, {
            'nom_magasin': request.form.get('nom_magasin'),
            'adresse': request.form.get('adresse', ''),
            'ville': request.form.get('ville', ''),
            'code_postal': request.form.get('code_postal', ''),
            'canton': request.form.get('canton', ''),
            'pays': request.form.get('pays', 'Suisse'),
            'telephone': request.form.get('telephone', ''),
            'email': request.form.get('email', ''),
            'description': request.form.get('description', '')
        })
        
        if store_id:
            flash('Magasin créé avec succès !', 'success')
            return redirect(url_for('main.store_list'))
        else:
            flash('Erreur lors de la création.', 'error')
    
    return render_template('/pos/create_store.html')


@main_bp.route('/edit/store/<int:store_id>', methods=['GET', 'POST'])
@login_required
def edit_store(store_id):
    magasin = models.magasin_pos_model.get_by_id(store_id, current_user.id)
    
    if not magasin:
        flash('Magasin non trouvé.', 'error')
        return redirect(url_for('main.store_list'))
    
    if request.method == 'POST':
        success = models.magasin_pos_model.update(store_id, current_user.id, {
            'nom_magasin': request.form.get('nom_magasin'),
            'adresse': request.form.get('adresse', ''),
            'ville': request.form.get('ville', ''),
            'code_postal': request.form.get('code_postal', ''),
            'canton': request.form.get('canton', ''),
            'pays': request.form.get('pays', 'Suisse'),
            'telephone': request.form.get('telephone', ''),
            'email': request.form.get('email', ''),
            'description': request.form.get('description', '')
        })
        
        if success:
            flash('Magasin modifié avec succès !', 'success')
            return redirect(url_for('main.store_list'))
        else:
            flash('Erreur lors de la modification.', 'error')
    
    return render_template('/pos/edit_store.html', magasin=magasin)


@main_bp.route('/delete/store/<int:store_id>', methods=['POST'])
@login_required
def delete_store(store_id):
    success = models.magasin_pos_model.delete(store_id, current_user.id)
    
    if success:
        flash('Magasin supprimé avec succès.', 'success')
    else:
        flash('Impossible de supprimer ce magasin.', 'error')
    
    return redirect(url_for('main.store_list'))


# ============================================================
# CRUD POINTS DE VENTE
# ============================================================
@main_bp.route('/pos/list')
@login_required
def pos_list():
    magasins = models.magasin_pos_model.get_by_user(current_user.id)
    
    pos_list = []
    for magasin in magasins:
        pdvs = models.pdv_pos_model.get_by_magasin(magasin['id'], current_user.id)
        pos_list.extend(pdvs)
    
    return render_template('/pos/pos_list.html', pos_list=pos_list)


@main_bp.route('/create/pos', methods=['GET', 'POST'])
@login_required
def create_pos():
    magasins = models.magasin_pos_model.get_by_user(current_user.id)
    
    if request.method == 'POST':
        magasin_id = int(request.form.get('magasin_id'))
        pdv_id = models.pdv_pos_model.create(current_user.id, magasin_id, {
            'nom_pdv': request.form.get('nom_pdv'),
            'description': request.form.get('description', '')
        })
        
        if pdv_id:
            flash('Point de vente créé avec succès !', 'success')
            return redirect(url_for('main.pos_list'))
        else:
            flash('Erreur lors de la création.', 'error')
    
    return render_template('/pos/create_pos.html', magasins=magasins)


@main_bp.route('/edit/pos/<int:pos_id>', methods=['GET', 'POST'])
@login_required
def edit_pos(pos_id):
    pos = models.pdv_pos_model.get_by_id(pos_id)
    
    if not pos:
        flash('Point de vente non trouvé.', 'error')
        return redirect(url_for('main.pos_list'))
    
    magasins = models.magasin_pos_model.get_by_user(current_user.id)
    
    if request.method == 'POST':
        # Note: Il faudrait ajouter une méthode update dans PointDeVentePOS
        flash('Fonctionnalité à implémenter.', 'warning')
        return redirect(url_for('main.pos_list'))
    
    return render_template('/pos/edit_pos.html', pos=pos, magasins=magasins)


@main_bp.route('/delete/pos/<int:pos_id>', methods=['POST'])
@login_required
def delete_pos(pos_id):
    success = models.pdv_pos_model.delete(pos_id, current_user.id)
    
    if success:
        flash('Point de vente supprimé avec succès.', 'success')
    else:
        flash('Impossible de supprimer ce point de vente.', 'error')
    
    return redirect(url_for('main.pos_list'))


# ============================================================
# CRUD MODES DE PAIEMENT
# ============================================================
@main_bp.route('/payment-methods-list')
@login_required
def payment_methods_list():
    modes = models.mode_paiement_pos_model.get_all(current_user.id)
    return render_template('/pos/payment_methods_list.html', modes=modes)


@main_bp.route('/create/payment-method', methods=['GET', 'POST'])
@login_required
def create_payment_method():
    if request.method == 'POST':
        mode_id = models.mode_paiement_pos_model.create(current_user.id, {
            'nom': request.form.get('nom', '').strip(),
            'description': request.form.get('description', '').strip(),
            'icone': request.form.get('icone', 'credit-card'),
            'couleur': request.form.get('couleur', '#28a745')
        })
        
        if mode_id:
            flash('Mode de paiement créé avec succès !', 'success')
            return redirect(url_for('main.payment_methods_list'))
        else:
            flash('Erreur lors de la création.', 'error')
    
    return render_template('/pos/create_payment_method.html')


@main_bp.route('/edit/payment-method/<int:mode_id>', methods=['GET', 'POST'])
@login_required
def edit_payment_method(mode_id):
    modes = models.mode_paiement_pos_model.get_all(current_user.id)
    mode = next((m for m in modes if m['id'] == mode_id), None)
    
    if not mode:
        flash('Mode de paiement non trouvé.', 'error')
        return redirect(url_for('main.payment_methods_list'))
    
    if request.method == 'POST':
        success = models.mode_paiement_pos_model.update(mode_id, current_user.id, {
            'nom': request.form.get('nom', '').strip(),
            'description': request.form.get('description', '').strip(),
            'icone': request.form.get('icone', 'credit-card'),
            'couleur': request.form.get('couleur', '#28a745'),
            'est_actif': 'est_actif' in request.form
        })
        
        if success:
            flash('Mode de paiement mis à jour avec succès !', 'success')
            return redirect(url_for('main.payment_methods_list'))
        else:
            flash('Erreur lors de la modification.', 'error')
    
    return render_template('/pos/edit_payment_method.html', mode=mode)


@main_bp.route('/delete/payment-method/<int:mode_id>', methods=['POST'])
@login_required
def delete_payment_method(mode_id):
    success = models.mode_paiement_pos_model.delete(mode_id, current_user.id)
    
    if success:
        flash('Mode de paiement supprimé avec succès.', 'success')
    else:
        flash('Impossible de supprimer ce mode de paiement.', 'error')
    
    return redirect(url_for('main.payment_methods_list'))


# ============================================================
# CRUD TAXES
# ============================================================
@main_bp.route('/taxes-list')
@login_required
def taxes_list():
    taxes = models.taxe_pos_model.get_all(current_user.id, actif_only=False)
    return render_template('/pos/taxes_list.html', taxes=taxes)


@main_bp.route('/create/taxe', methods=['GET', 'POST'])
@login_required
def create_taxe():
    if request.method == 'POST':
        taxe_id = models.taxe_pos_model.create(current_user.id, {
            'nom': request.form.get('nom', '').strip(),
            'taux': float(request.form.get('taux', '0').replace(',', '.')),
            'date_debut': datetime.strptime(request.form.get('date_debut'), '%Y-%m-%d').date(),
            'date_fin': datetime.strptime(request.form.get('date_fin'), '%Y-%m-%d').date() if request.form.get('date_fin') else None,
            'est_actif': 'est_actif' in request.form
        })
        
        if taxe_id:
            flash('Taxe créée avec succès !', 'success')
            return redirect(url_for('main.taxes_list'))
        else:
            flash('Erreur lors de la création.', 'error')
    
    today = datetime.now().strftime('%Y-%m-%d')
    return render_template('/pos/create_taxe.html', today=today)


@main_bp.route('/edit/taxe/<int:taxe_id>', methods=['GET', 'POST'])
@login_required
def edit_taxe(taxe_id):
    # Note: Il faudrait ajouter une méthode get_by_id dans TaxePOS
    flash('Fonctionnalité à implémenter.', 'warning')
    return redirect(url_for('main.taxes_list'))


@main_bp.route('/delete/taxe/<int:taxe_id>', methods=['POST'])
@login_required
def delete_taxe(taxe_id):
    # Note: Il faudrait ajouter une méthode delete dans TaxePOS
    flash('Fonctionnalité à implémenter.', 'warning')
    return redirect(url_for('main.taxes_list'))


# ============================================================
# CLIENTS
# ============================================================
@main_bp.route('/clients')
@login_required
def clients_list():
    search = request.args.get('search', '')
    
    clients = models.client_pos_model.get_all(current_user.id, limit=100)
    
    if search:
        clients = [c for c in clients if 
                  search.lower() in c.get('nom_client', '').lower() or
                  search.lower() in c.get('email', '').lower() or
                  search.lower() in c.get('telephone', '').lower()]
    
    total_clients = len(clients)
    clients_actifs = sum(1 for c in clients if c.get('segment') != 'Inactif')
    total_ca_clients = sum(float(c.get('total_depense', 0) or 0) for c in clients)
    
    return render_template('/pos/clients_list.html',
                         clients=clients,
                         search=search,
                         total_clients=total_clients,
                         clients_actifs=clients_actifs,
                         total_ca_clients=total_ca_clients)


@main_bp.route('/client/<int:client_id>')
@login_required
def client_detail(client_id):
    client = models.client_pos_model.get_by_id(client_id, current_user.id)
    
    if not client:
        flash('Client non trouvé.', 'error')
        return redirect(url_for('main.clients_list'))
    
    # Historique des visites
    visites = models.receipt_pos_model.get_all(
        user_id=current_user.id,
        limit=20
    )
    visites = [v for v in visites if v.get('id_client') == client_id]
    
    return render_template('/pos/client_detail.html',
                         client=client,
                         visites=visites)


# ============================================================
# OPTIONS DE RESTAURATION
# ============================================================
@main_bp.route('/restaurant-options')
@login_required
def restaurant_options_list():
    options = models.restaurant_option_pos_model.get_all(current_user.id)
    return render_template('/pos/restaurant_options.html', options=options)


@main_bp.route('/create/restaurant-option', methods=['GET', 'POST'])
@login_required
def create_restaurant_option():
    if request.method == 'POST':
        option_id = models.restaurant_option_pos_model.create(current_user.id, {
            'nom': request.form.get('nom', '').strip(),
            'description': request.form.get('description', '').strip(),
            'icone': request.form.get('icone', 'utensils')
        })
        
        if option_id:
            flash('Option de restauration créée avec succès !', 'success')
            return redirect(url_for('main.restaurant_options_list'))
        else:
            flash('Erreur lors de la création.', 'error')
    
    return render_template('/pos/create_restaurant_option.html')


# ============================================================
# RÉDUCTIONS
# ============================================================
@main_bp.route('/discounts')
@login_required
def discounts_list():
    discounts = models.discount_pos_model.get_all(current_user.id)
    return render_template('/pos/discounts.html', discounts=discounts)


@main_bp.route('/create/discount', methods=['GET', 'POST'])
@login_required
def create_discount():
    if request.method == 'POST':
        discount_id = models.discount_pos_model.create(current_user.id, {
            'nom': request.form.get('nom', '').strip(),
            'type_reduction': request.form.get('type_reduction', 'percentage'),
            'valeur': float(request.form.get('valeur', '0').replace(',', '.')) if request.form.get('valeur') else None,
            'acces_restreint': 'acces_restreint' in request.form
        })
        
        if discount_id:
            flash('Réduction créée avec succès !', 'success')
            return redirect(url_for('main.discounts_list'))
        else:
            flash('Erreur lors de la création.', 'error')
    
    return render_template('/pos/create_discount.html')


# ============================================================
# IMPORT DE DONNÉES
# ============================================================
@main_bp.route('/import', methods=['GET', 'POST'])
@login_required
def import_data():
    if request.method == 'POST':
        if 'file' not in request.files:
            flash('Aucun fichier sélectionné', 'error')
            return redirect(request.url)
        
        file = request.files['file']
        file_type = request.form.get('file_type', 'receipts')
        
        if file.filename == '':
            flash('Aucun fichier sélectionné', 'error')
            return redirect(request.url)
        
        if file and file.filename.endswith(('.csv', '.xlsx')):
            try:
                if file.filename.endswith('.csv'):
                    df = pd.read_csv(file, encoding='utf-8')
                else:
                    df = pd.read_excel(file)
                
                count = 0
                
                if file_type == 'items':
                    count = import_items_pos(df)
                elif file_type == 'categories':
                    count = import_categories_pos(df)
                elif file_type == 'modifiers':
                    count = import_modifiers_pos(df)
                
                flash(f'{count} enregistrements importés avec succès!', 'success')
                return redirect(url_for('main.index'))
                
            except Exception as e:
                flash(f'Erreur lors de l\'import: {str(e)}', 'error')
        else:
            flash('Format de fichier non supporté. Utilisez CSV ou Excel.', 'error')
    
    return render_template('/pos/import.html')


def import_items_pos(df):
    """Import des articles POS"""
    count = 0
    
    for idx, row in df.iterrows():
        if pd.isna(row.get('Name')):
            continue
        
        # Créer/récupérer la catégorie
        categorie_nom = str(row.get('Category', 'Divers'))
        categories = models.categorie_pos_model.get_all(current_user.id)
        categorie = next((c for c in categories if c['nom_categorie'] == categorie_nom), None)
        
        if not categorie:
            cat_id = models.categorie_pos_model.create(current_user.id, categorie_nom, '')
            categorie = {'id': cat_id}
        
        # Créer l'article
        article_id = models.article_pos_model.create(current_user.id, {
            'nom_article': str(row.get('Name', '')).strip(),
            'id_categorie': categorie['id'],
            'prix_unitaire': safe_float(row.get('Price', 0)),
            'cout_unitaire': safe_float(row.get('Cost', 0)),
            'stock': int(safe_float(row.get('Stock', 0))),
            'description': str(row.get('Description', '')) if pd.notna(row.get('Description')) else ''
        })
        
        if article_id:
            count += 1
    
    return count


def import_categories_pos(df):
    """Import des catégories"""
    count = 0
    
    for _, row in df.iterrows():
        nom = str(row.get('Nom', row.get('Catégorie', '')))
        if nom:
            cat_id = models.categorie_pos_model.create(current_user.id, nom, '')
            if cat_id:
                count += 1
    
    return count


def import_modifiers_pos(df):
    """Import des modificateurs"""
    count = 0
    
    for _, row in df.iterrows():
        nom = str(row.get('Nom', row.get('Modificateur', '')))
        if nom:
            mod_id = models.modificateur_pos_model.create(current_user.id, {
                'nom_modificateur': nom,
                'prix_modificateur': safe_float(row.get('Prix', 0)),
                'description': str(row.get('Description', '')) if pd.notna(row.get('Description')) else ''
            })
            if mod_id:
                count += 1
    
    return count


# ============================================================
# STATS GÉNÉRALES
# ============================================================
@main_bp.route('/stats')
@login_required
def stats():
    # Statistiques par mode de paiement
    receipts = models.receipt_pos_model.get_all(user_id=current_user.id)
    
    payment_stats = {}
    for receipt in receipts:
        for payment in receipt.get('payments', []):
            mode_nom = payment.get('mode_paiement_nom', 'Inconnu')
            if mode_nom not in payment_stats:
                payment_stats[mode_nom] = {'count': 0, 'total': 0}
            payment_stats[mode_nom]['count'] += 1
            payment_stats[mode_nom]['total'] += float(payment.get('montant', 0) or 0)
    
    # Statistiques mensuelles
    monthly_stats = {}
    for receipt in receipts:
        if receipt.get('date'):
            month_key = receipt['date'].strftime('%Y-%m')
            if month_key not in monthly_stats:
                monthly_stats[month_key] = {'count': 0, 'total': 0}
            monthly_stats[month_key]['count'] += 1
            monthly_stats[month_key]['total'] += float(receipt.get('total_collecte', 0) or 0)
    
    return render_template('/pos/stats.html', 
                        payment_stats=payment_stats.items(),
                        monthly_stats=sorted(monthly_stats.items()))