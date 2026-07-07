
@bp.route('/import/csv', methods=['GET', 'POST'])
@login_required
def import_csv_upload():
    
    if request.method == 'GET':
        return render_template('banking/import_csv_upload.html')
    
    file = request.files.get('csv_file')
    if not file or not file.filename.endswith('.csv'):
        flash("Veuillez uploader un fichier CSV.", "danger")
        return redirect(url_for('banking.import_csv_upload'))

    # Lire le CSV
    stream = io.TextIOWrapper(file.stream, encoding='utf-8')
    raw_lines = stream.read().splitlines()
    if not raw_lines:
        flash("Fichier vide", "danger")
        return redirect(url_for('banking.import_csv_upload'))
    import csv as csv_mod
    # Détecter le délimiteur
    sample = '\n'.join(raw_lines[:5])  # Prendre un échantillon
    try:
        delimiter = csv_mod.Sniffer().sniff(sample, delimiters=";,|\t").delimiter
    except:
        delimiter = ';'  # Fallback pour les exports bancaires suisses

    reader_raw = csv_mod.reader(raw_lines, delimiter=delimiter)
    headers_raw = next(reader_raw)
    headers = [h.strip().strip('"') for h in headers_raw]
    rows = []
    logging.error('changement')
    for row_raw in reader_raw:
        row_dict = {}
        for i, h in enumerate(headers):
            value = row_raw[i].strip().strip('"') if i < len(row_raw) else ''
            row_dict[h] = value
        rows.append(row_dict)
    rows = rows



    # Sauvegarder dans la session
    session['csv_headers'] = headers
    session['csv_rows'] = rows

    # Récupérer les comptes de l'utilisateur
    user_id = current_user.id
    comptes = g.models.compte_model.get_all_accounts()
    sous_comptes = g.models.sous_compte_model.get_all_sous_comptes_by_user_id(user_id)

    comptes_possibles = []
    for c in comptes:
        comptes_possibles.append({
            'id': c['id'],
            'nom': c['nom_compte'],
            'type': 'compte_principal'
        })
    for sc in sous_comptes:
        comptes_possibles.append({
            'id': sc['id'],
            'nom': sc['nom_sous_compte'],
            'type': 'sous_compte'
        })

    session['comptes_possibles'] = comptes_possibles
    comptes_possibles.sort(key=lambda x: x['nom'])

    return redirect(url_for('banking.import_csv_map'))


@bp.route('/import/csv/map', methods=['GET'])
@login_required
def import_csv_map():
    if 'csv_headers' not in session:
        return redirect(url_for('banking.import_csv_upload'))
    return render_template('banking/import_csv_map.html')


@bp.route('/import/csv/confirm', methods=['POST'])
@login_required
def import_csv_confirm():
    user_id = current_user.id
    mapping = {
        'date': request.form['col_date'],
        'montant': request.form['col_montant'],
        'type': request.form['col_type'],
        'description': request.form.get('col_description') or None,
        'source': request.form['col_source'],
        'dest': request.form.get('col_dest') or None,
    }
    session['column_mapping'] = mapping

    # === 🔁 TRIER LES LIGNES DÈS MAINTENANT ===
    csv_rows = session.get('csv_rows', [])
    print("=== CONTENU DE csv_rows ===")
    for i, row in enumerate(csv_rows):
        print(f"Ligne {i}: {row}")
    type_col = mapping['type']
    date_col = mapping['date']

    # Ajouter le type à chaque ligne + trier
    enriched_rows = []
    for row in csv_rows:
        tx_type = row.get(type_col, '').strip().lower()
        if tx_type not in ('depot', 'retrait', 'transfert'):
            tx_type = 'inconnu'
        enriched_rows.append({**row, '_tx_type': tx_type})

    def parse_date_for_sort(row):
        d = row.get(date_col, '').strip()
        if not d:
            return datetime.max
        # Formats supportés : ISO + format suisse (jj.mm.yy HH:MM)
        for fmt in ('%Y-%m-%d %H:%M', '%Y-%m-%dT%H:%M', '%Y-%m-%d', '%d.%m.%y %H:%M'):
            try:
                return datetime.strptime(d, fmt)
            except ValueError:
                continue
        return datetime.max

    enriched_rows_sorted = sorted(enriched_rows, key=parse_date_for_sort)
    session['csv_rows_with_type'] = enriched_rows_sorted  # <-- on remplace par la version triée

    # Préparer les lignes avec options de sélection (dans le nouvel ordre)
    rows_for_template = []
    for i, row in enumerate(enriched_rows_sorted):
        source_val = row.get(mapping['source'], '').strip()
        dest_val = row.get(mapping['dest'], '').strip() if mapping['dest'] else ''
        rows_for_template.append({
            'index': i,
            'tx_type': row['_tx_type'],
            'source_val': source_val,
            'dest_val': dest_val,
        })
    comptes_possibles = session.get('comptes_possibles', [])
    comptes_possibles = sorted(comptes_possibles, key=lambda x: x.get('nom', ''))
    return render_template('banking/import_csv_confirm.html', rows=rows_for_template, comptes_possibles=comptes_possibles)


@bp.route('/import/csv/final', methods=['POST'])
@login_required
def import_csv_final():
    user_id = current_user.id
    mapping = session.get('column_mapping')
    csv_rows = session.get('csv_rows_with_type', [])
    comptes_possibles = {str(c['id']) + '|' + c['type']: c for c in session.get('comptes_possibles', [])}

    if not mapping or not csv_rows:
        flash("Données d'import manquantes. Veuillez recommencer.", "danger")
        return redirect(url_for('banking.import_csv_upload'))

    success_count = 0
    errors = []

    for i, row in enumerate(csv_rows):
        try:
            # Extraction
            date_str = row[mapping['date']].strip()
            montant_str = row[mapping['montant']].strip().replace(',', '.')
            tx_type = row[mapping['type']].lower().strip()
            desc = row.get(mapping['description'], '').strip() if mapping['description'] else ''

            # Conversion
            try:
                montant = Decimal(montant_str)
                if montant <= 0:
                    raise ValueError("Montant doit être > 0")
            except (InvalidOperation, ValueError) as e:
                errors.append(f"Ligne {i+1}: montant invalide ({montant_str})")
                continue

            date_tx = None
            for fmt in ('%Y-%m-%d %H:%M', '%Y-%m-%dT%H:%M', '%Y-%m-%d', '%d.%m.%y %H:%M'):
                try:
                    date_tx = datetime.strptime(date_str, fmt)
                    break
                except ValueError:
                    continue

            if date_tx is None:
                errors.append(f"Ligne {i+1}: date invalide ({date_str})")
                continue

            # Récupérer les choix utilisateur
            source_key = request.form.get(f'row_{i}_source')
            dest_key = request.form.get(f'row_{i}_dest')

            if not source_key or source_key not in comptes_possibles:
                errors.append(f"Ligne {i+1}: compte source invalide")
                continue

            source_info = comptes_possibles[source_key]
            source_id = source_info['id']
            source_type = source_info['type']

            if tx_type in ['depot', 'retrait']:
                if tx_type == 'depot':
                    ok, msg = g.models.transaction_financiere_model.create_depot(
                        compte_id=source_id,
                        user_id=user_id,
                        montant=montant,
                        description=desc,
                        compte_type=source_type,
                        date_transaction=date_tx
                    )
                else:  # retrait
                    ok, msg = g.models.transaction_financiere_model.create_retrait(
                        compte_id=source_id,
                        user_id=user_id,
                        montant=montant,
                        description=desc,
                        compte_type=source_type,
                        date_transaction=date_tx
                    )
                if ok:
                    success_count += 1
                else:
                    errors.append(f"Ligne {i+1}: {msg}")

            elif tx_type == 'transfert':
                if not dest_key or dest_key not in comptes_possibles:
                    errors.append(f"Ligne {i+1}: compte destination requis pour transfert")
                    continue
                dest_info = comptes_possibles[dest_key]
                dest_id = dest_info['id']
                dest_type = dest_info['type']

                # Vérifier que les comptes sont différents
                if source_id == dest_id and source_type == dest_type:
                    errors.append(f"Ligne {i+1}: source et destination identiques")
                    continue

                ok, msg = g.models.transaction_financiere_model.create_transfert_interne(
                    source_type=source_type,
                    source_id=source_id,
                    dest_type=dest_type,
                    dest_id=dest_id,
                    user_id=user_id,
                    montant=montant,
                    description=desc,
                    date_transaction=date_tx
                )
                if ok:
                    success_count += 1
                else:
                    errors.append(f"Ligne {i+1}: {msg}")

            else:
                errors.append(f"Ligne {i+1}: type inconnu '{tx_type}' (attendu: depot, retrait, transfert)")

        except Exception as e:
            errors.append(f"Ligne {i+1}: erreur inattendue ({str(e)})")

    # Nettoyer la session
    session.pop('csv_headers', None)
    session.pop('csv_rows', None)
    session.pop('comptes_possibles', None)
    session.pop('column_mapping', None)

    flash(f"✅ Import terminé : {success_count} transaction(s) créée(s).", "success")
    for err in errors[:5]:  # Limiter les messages d'erreur affichés
        flash(f"❌ {err}", "danger")

    return redirect(url_for('banking.banking_dashboard'))

@bp.route('/import/csv/distinct_confirm', methods=['POST'])
@login_required
def import_csv_distinct_confirm():
    mapping = {
        'date': request.form['col_date'],
        'montant': request.form['col_montant'],
        'type': request.form['col_type'],
        'description': request.form.get('col_description') or None,
        'source': request.form['col_source'],
        'dest': request.form.get('col_dest') or None,
    }
    print("=== MAPPING ===")
    print("source =", mapping['source'])
    print("dest =", mapping.get('dest'))
    session['column_mapping'] = mapping

    csv_rows = session.get('csv_rows', [])
    print("=== CONTENU DE csv_rows ===")
    for i, row in enumerate(csv_rows):
        print(f"Ligne {i}: {row}")
    if not csv_rows:
        flash("Aucune donnée à traiter.", "danger")
        return redirect(url_for('banking.import_csv_upload'))

    # 🔥 Extraire TOUTES les valeurs uniques de source ET destination
    compte_names = set()

    source_col = mapping['source']
    for row in csv_rows:
        val = row.get(source_col, '').strip()
        if val:
            compte_names.add(val)

    dest_col = mapping.get('dest')
    if dest_col:
        for row in csv_rows:
            val = row.get(dest_col, '').strip()
            if val:
                compte_names.add(val)

    compte_names = sorted(compte_names)

    session['distinct_compte_names'] = compte_names
    session['csv_rows_raw'] = csv_rows

    comptes_possibles = sorted(
        session.get('comptes_possibles', []),
        key=lambda x: x.get('nom', '')
    )

    return render_template(
        'banking/import_csv_distinct_confirm_temp.html',
        compte_names=compte_names,
        comptes_possibles=comptes_possibles
    )


@bp.route('/import/csv/final_distinct', methods=['POST'])
@login_required
def import_csv_final_distinct():
    user_id = current_user.id
    mapping = session.get('column_mapping')
    csv_rows = session.get('csv_rows_raw', [])
    comptes_possibles = {str(c['id']) + '|' + c['type']: c for c in session.get('comptes_possibles', [])}

    if not mapping or not csv_rows:
        flash("Données d'import manquantes.", "danger")
        return redirect(url_for('banking.import_csv_upload'))

    # 🔥 Construire un mapping GLOBAL : nom → compte
    global_mapping = {}
    i = 0
    while f'compte_name_{i}' in request.form:
        name = request.form[f'compte_name_{i}']
        key = request.form[f'account_{i}']
        if key and key in comptes_possibles:
            global_mapping[name] = key
        i += 1

    success_count = 0
    errors = []

    for idx, row in enumerate(csv_rows):
        try:
            date_str = row[mapping['date']].strip()
            montant_str = row[mapping['montant']].strip().replace(',', '.')
            tx_type = row[mapping['type']].lower().strip()
            desc = row.get(mapping['description'], '').strip() if mapping.get('description') else ''

            try:
                montant = Decimal(montant_str)
                if montant <= 0:
                    raise ValueError("Montant doit être > 0")
            except (InvalidOperation, ValueError):
                errors.append(f"Ligne {idx+1}: montant invalide ({montant_str})")
                continue

            try:
                date_tx = datetime.strptime(date_str, '%Y-%m-%d')
            except ValueError:
                try:
                    date_tx = datetime.strptime(date_str, '%Y-%m-%dT%H:%M')
                except ValueError:
                    errors.append(f"Ligne {idx+1}: date invalide ({date_str})")
                    continue

            # 🔥 Récupérer les comptes via le mapping global UNIQUE
            source_val = row.get(mapping['source'], '').strip()
            source_key = global_mapping.get(source_val)

            if tx_type in ('depot', 'retrait'):
                if not source_key:
                    errors.append(f"Ligne {idx+1}: compte non associé pour '{source_val}'")
                    continue
            elif tx_type == 'transfert':
                dest_val = row.get(mapping['dest'], '').strip() if mapping.get('dest') else ''
                dest_key = global_mapping.get(dest_val) if dest_val else None
                if not source_key or not dest_key:
                    errors.append(f"Ligne {idx+1}: compte(s) non associé(s) (source: '{source_val}', dest: '{dest_val}')")
                    continue
                if source_key == dest_key:
                    errors.append(f"Ligne {idx+1}: source et destination identiques")
                    continue
            else:
                errors.append(f"Ligne {idx+1}: type inconnu '{tx_type}'")
                continue

            # --- Logique métier ---
            source_info = comptes_possibles[source_key]
            source_id = source_info['id']
            source_type = source_info['type']

            if tx_type == 'depot':
                ok, msg = g.models.transaction_financiere_model.create_depot(
                    compte_id=source_id, user_id=user_id, montant=montant,
                    description=desc, compte_type=source_type, date_transaction=date_tx
                )
            elif tx_type == 'retrait':
                ok, msg = g.models.transaction_financiere_model.create_retrait(
                    compte_id=source_id, user_id=user_id, montant=montant,
                    description=desc, compte_type=source_type, date_transaction=date_tx
                )
            elif tx_type == 'transfert':
                dest_info = comptes_possibles[dest_key]
                dest_id = dest_info['id']
                dest_type = dest_info['type']
                ok, msg = g.models.transaction_financiere_model.create_transfert_interne(
                    source_type=source_type, source_id=source_id,
                    dest_type=dest_type, dest_id=dest_id,
                    user_id=user_id, montant=montant, description=desc, date_transaction=date_tx
                )

            if ok:
                success_count += 1
            else:
                errors.append(f"Ligne {idx+1}: {msg}")

        except Exception as e:
            errors.append(f"Ligne {idx+1}: erreur inattendue ({str(e)})")

    # Nettoyer la session
    for key in ['csv_headers', 'csv_rows', 'comptes_possibles', 'column_mapping',
                'distinct_compte_names', 'csv_rows_raw']:
        session.pop(key, None)

    flash(f"✅ Import terminé : {success_count} transaction(s) créée(s).", "success")
    for err in errors[:5]:
        flash(f"❌ {err}", "danger")

    return redirect(url_for('banking.banking_dashboard'))
