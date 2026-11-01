@bp.route('/comptabilite/ecritures/multiple/nouvelle', methods=['GET', 'POST'])
@login_required
def nouvelle_ecriture_multiple():
    if request.method == 'POST':
        try:
            id_contact_principal = int(request.form['id_contact']) if request.form.get('id_contact') else None
            # --- 1. PARSER LES DÉBITS ---
            lignes_debit = _parse_lignes(request.form, 'debit', [
                'date_debit', 'type_debit', 'compte_bancaire_debit', 'categorie_debit_id', 
                'montant_debit', 'tva_taux_debit', 'description_debit', 'reference_debit', 'statut_debit'
            ])
            # --- 2. PARSER LES CRÉDITS ---
            lignes_credit = _parse_lignes(request.form, 'credit', [
                'date_credit', 'type_credit', 'compte_bancaire_credit', 'categorie_credit_id', 
                'montant_credit', 'tva_taux_credit', 'description_credit', 'reference_credit', 'statut_credit'
            ])
            errors = []
            debits_valides = []
            credits_valides = []
            # --- VALIDATION DÉBITS ---
            for i, ligne in enumerate(lignes_debit):
                date_val = ligne.get('date_debit')
                cat_id = ligne.get('categorie_debit_id')
                montant_str = ligne.get('montant_debit')
                if not date_val or not cat_id or not montant_str or montant_str.strip() == '':
                    continue
                try:
                    montant_dec = Decimal(str(montant_str))
                except Exception:
                    errors.append(f"Débit ligne {i+1} : Format de montant invalide.")
                    continue
                if montant_dec <= 0:
                    continue
                # Validation de la TVA (BIEN INDENTÉ DANS LA BOUCLE FOR)
                annee_ligne = int(date_val[:4])
                taux_tva_str = ligne.get('tva_taux_debit') or '0'
                taux_tva_val = float(taux_tva_str)
                if taux_tva_val > 0:
                    taux_valides = g.models.taux_tva_model.get_taux_for_select(annee_ligne)
                    taux_valides_values = [float(t['taux']) for t in taux_valides]
                    if taux_tva_val not in taux_valides_values:
                        errors.append(f"Débit ligne {i+1} : Le taux {taux_tva_val}% est invalide pour l'année {annee_ligne}.")
                        continue
                compte_id = int(ligne.get('compte_bancaire_debit')) if ligne.get('compte_bancaire_debit') else None
                id_contact_ligne = id_contact_principal
                if not id_contact_ligne and compte_id:
                    contact_lie = g.models.contact_compte_model.get_contact_by_compte(compte_id, current_user.id)
                    if contact_lie:
                        id_contact_ligne = contact_lie['contact_id']
                debits_valides.append({
                    'date_ecriture': date_val,
                    'type_ecriture': ligne.get('type_debit', 'depense'),
                    'compte_bancaire_id': compte_id,
                    'categorie_id': int(cat_id),
                    'montant': montant_dec,
                    'tva_taux': Decimal(str(taux_tva_val)),
                    'description': ligne.get('description_debit', ''),
                    'reference': ligne.get('reference_debit', ''),
                    'statut': ligne.get('statut_debit', 'pending'),
                    'id_contact': id_contact_ligne
                })
            # --- VALIDATION CRÉDITS ---
            for i, ligne in enumerate(lignes_credit):
                date_val = ligne.get('date_credit')
                cat_id = ligne.get('categorie_credit_id')
                montant_str = ligne.get('montant_credit')
                if not date_val or not cat_id or not montant_str or montant_str.strip() == '':
                    continue
                try:
                    montant_dec = Decimal(str(montant_str))
                except Exception:
                    errors.append(f"Crédit ligne {i+1} : Format de montant invalide.")
                    continue
                if montant_dec <= 0:
                    continue
                compte_id = int(ligne.get('compte_bancaire_credit')) if ligne.get('compte_bancaire_credit') else None
                id_contact_ligne = id_contact_principal
                if not id_contact_ligne and compte_id:
                    contact_lie = g.models.contact_compte_model.get_contact_by_compte(compte_id, current_user.id)
                    if contact_lie:
                        id_contact_ligne = contact_lie['contact_id']
                credits_valides.append({
                    'date_ecriture': date_val,
                    'type_ecriture': ligne.get('type_credit', 'recette'),
                    'compte_bancaire_id': compte_id,
                    'categorie_id': int(cat_id),
                    'montant': montant_dec,
                    'tva_taux': Decimal('0'),
                    'description': ligne.get('description_credit', ''),
                    'reference': ligne.get('reference_credit', ''),
                    'statut': ligne.get('statut_credit', 'pending'),
                    'id_contact': id_contact_ligne
                })
            if not debits_valides and not credits_valides:
                flash("Aucune écriture valide n'a été saisie.", "warning")
                return redirect(url_for('banking.liste_ecritures'))
            # --- VÉRIFICATION D'ÉQUILIBRE ---
            total_debit = sum(d['montant'] for d in debits_valides)
            total_credit = sum(c['montant'] for c in credits_valides)
            if total_debit != total_credit:
                flash(f"Déséquilibre comptable : Total Débits ({total_debit} CHF) ≠ Total Crédits ({total_credit} CHF)", "error")
                return redirect(url_for('banking.liste_ecritures'))
            for error in errors:
                flash(error, "warning")
            if errors:
                return redirect(url_for('banking.liste_ecritures'))
            # --- CRÉATION EN BASE ---
            groupe_id = f"MULTI-{datetime.now().strftime('%Y%m%d%H%M%S')}"
            succes_count = 0
            secondary_count = 0
            for d in debits_valides:
                if d['tva_taux'] > 0:
                    montant_htva = d['montant'] / (1 + d['tva_taux'] / Decimal('100'))
                    tva_montant = d['montant'] - montant_htva
                else:
                    montant_htva = d['montant']
                    tva_montant = Decimal('0')
                data = {
                    'date_ecriture': d['date_ecriture'],
                    'compte_bancaire_id': d['compte_bancaire_id'],
                    'categorie_id': d['categorie_id'],
                    'montant': montant_htva,
                    'montant_htva': montant_htva,
                    'tva_montant': tva_montant,
                    'description': d['description'],
                    'id_contact': d['id_contact'],
                    'reference': d['reference'],
                    'type_ecriture': d['type_ecriture'],
                    'tva_taux': d['tva_taux'],
                    'utilisateur_id': current_user.id,
                    'statut': d['statut'],
                    'devise': 'CHF',
                    'groupe_ecriture_id': groupe_id,
                    'type_ecriture_comptable': 'principale'
                }
                if g.models.ecriture_comptable_model.create(data):
                    succes_count += 1
                    ecriture_id = g.models.ecriture_comptable_model.get_last_insert_id()
                    secondaires = g.models.ecriture_comptable_model.get_ecritures_complementaires(ecriture_id, current_user.id)
                    secondary_count += len(secondaires)
            for c in credits_valides:
                data = {
                    'date_ecriture': c['date_ecriture'],
                    'compte_bancaire_id': c['compte_bancaire_id'],
                    'categorie_id': c['categorie_id'],
                    'montant': c['montant'],
                    'montant_htva': c['montant'],
                    'tva_montant': Decimal('0'),
                    'description': c['description'],
                    'id_contact': c['id_contact'],
                    'reference': c['reference'],
                    'type_ecriture': c['type_ecriture'],
                    'tva_taux': Decimal('0'),
                    'utilisateur_id': current_user.id,
                    'statut': c['statut'],
                    'devise': 'CHF',
                    'groupe_ecriture_id': groupe_id,
                    'type_ecriture_comptable': 'principale'
                }
                if g.models.ecriture_comptable_model.create(data):
                    succes_count += 1
            if succes_count > 0:
                msg = f"{succes_count} écriture(s) enregistrée(s) avec succès !"
                if secondary_count > 0:
                    msg += f" ({secondary_count} écriture(s) secondaire(s) créée(s))"
                flash(msg, "success")
            else:
                flash("Aucune écriture n'a pu être enregistrée.", "warning")
            return redirect(url_for('banking.liste_ecritures'))
        except Exception as e:
            flash(f"Erreur inattendue : {str(e)}", "error")
            return redirect(url_for('banking.liste_ecritures'))
    elif request.method == 'GET':
        comptes = g.models.compte_model.get_all_accounts(user_id=current_user.id)
        categories = g.models.categorie_comptable_model.get_all_categories(current_user.id)
        contacts = g.models.contact_model.get_all(current_user.id)
        categories_avec_complementaires = g.models.categorie_comptable_model.get_categories_avec_complementaires(current_user.id)
        taux_disponibles = g.models.taux_tva_model.get_taux_for_select()
        return render_template('comptabilite/nouvelle_ecriture_multiple.html',
            comptes=comptes,
            categories=categories,
            categories_avec_complementaires=categories_avec_complementaires,
            contacts=contacts,
            taux_disponibles=taux_disponibles,
            today=datetime.now().strftime('%Y-%m-%d'),
            statuts_disponibles=[
                {'value': 'pending', 'label': 'En attente'},
                {'value': 'validée', 'label': 'Validée'}
            ])