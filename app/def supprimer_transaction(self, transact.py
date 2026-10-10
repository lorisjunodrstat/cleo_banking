 def supprimer_transaction(self, transaction_id: int, user_id: int) -> Tuple[bool, str]:
        """Supprime une transaction. Si c'est un transfert, supprime les deux transactions liées."""
        try:
            with self.db.get_cursor() as cursor:
                # Récupérer la transaction AVANT de la supprimer
                cursor.execute("""
                    SELECT t.*,
                        COALESCE(cp.utilisateur_id, (
                            SELECT cp2.utilisateur_id
                            FROM sous_comptes sc
                            JOIN comptes_principaux cp2 ON sc.compte_principal_id = cp2.id
                            WHERE sc.id = t.sous_compte_id
                        )) as owner_user_id
                    FROM transactions t
                    LEFT JOIN comptes_principaux cp ON t.compte_principal_id = cp.id
                    WHERE t.id = %s
                """, (transaction_id,))
                transaction = cursor.fetchone()
                if not transaction:
                    return False, "Transaction non trouvée"
                    logger.info(f'Transaction {transaction_id} non trouvée pour suppression')
                #if transaction['owner_user_id'] != user_id:
                #    logger.info(f'Utilisateur {user_id} non autorisé à supprimer cette transaction')
                #    return False, "Non autorisé à supprimer cette transaction"
                type_tx = transaction['type_transaction']
                compte_type = 'compte_principal' if transaction['compte_principal_id'] else 'sous_compte'
                compte_id = transaction['compte_principal_id'] or transaction['sous_compte_id']
                date_transaction = transaction['date_transaction']
                # === CAS SPÉCIAL : TRANSFERT INTERNE (entrant/sortant) ===
                if type_tx in ('transfert_entrant', 'transfert_sortant'):
                    contrepartie, erreur = self._trouver_contrepartie_transfert(cursor, transaction)
                    if erreur:
                        logger.warning(f"Transfert {transaction_id} : {erreur}")
                        return False, erreur

                    # Vérification de propriété sur le compte source (sortant)
                    tx_source = transaction if type_tx == 'transfert_sortant' else contrepartie
                    if tx_source['compte_principal_id']:
                        cursor.execute("SELECT utilisateur_id FROM comptes_principaux WHERE id = %s",
                                    (tx_source['compte_principal_id'],))
                    else:
                        cursor.execute("""
                            SELECT cp.utilisateur_id
                            FROM sous_comptes sc
                            JOIN comptes_principaux cp ON sc.compte_principal_id = cp.id
                            WHERE sc.id = %s
                        """, (tx_source['sous_compte_id'],))
                    owner_row = cursor.fetchone()
                    if not owner_row or owner_row['utilisateur_id'] != user_id:
                        return False, "Non autorisé à annuler ce transfert"

                    # Suppression des deux
                    cursor.execute(
                        "DELETE FROM transactions WHERE id IN (%s, %s)",
                        (transaction_id, contrepartie['id'])
                    )

                    # Recalcul des soldes des deux comptes
                    for tx in (transaction, contrepartie):
                        tx_compte_type = 'compte_principal' if tx['compte_principal_id'] else 'sous_compte'
                        tx_compte_id = tx['compte_principal_id'] or tx['sous_compte_id']
                        if not self._verifier_appartenance_compte_with_cursor(cursor, tx_compte_type, tx_compte_id, user_id):
                            continue
                        if not self._recalculer_soldes_apres_date_with_cursor(
                            cursor, tx_compte_type, tx_compte_id, tx['date_transaction']
                        ):
                            raise Exception(f"Échec du recalcul du solde pour {tx_compte_type} ID {tx_compte_id}")

                    return True, "Transfert annulé avec succès"
                # === CAS NORMAL : transaction simple (dépôt, retrait, etc.) ===
                else:
                    # Supprimer la transaction unique
                    cursor.execute("DELETE FROM transactions WHERE id = %s", (transaction_id,))
                    logger.info(f"Demande de suppression de la Transaction {transaction_id} supprimée avec succès")
                    cursor.execute("SELECT * FROM transactions WHERE id = %s", (transaction_id,))
                    logger.info(f"Vérification post-suppression: {cursor.fetchone()} (devrait être None)")
                    # Recalculer les soldes à partir de la date de la transaction
                    success = self._recalculer_soldes_apres_date_with_cursor(
                        cursor, compte_type, compte_id, date_transaction
                    )
                    logger.info(f"Recalcul des soldes après suppression de la transaction {transaction_id} du compte {compte_id} en date du {date_transaction} {'réussi' if success else 'échoué'}")
                    if not success:
                        raise Exception("Erreur lors du recalcul des soldes")
                    return True, "Transaction supprimée avec succès"
        except MySQLError as e:
            logger.error(f"Erreur lors de la suppression de la transaction {transaction_id}")
            return False, f"Erreur lors de la suppression : {str(e)}"
def modifier_transaction(self, transaction_id: int, user_id: int,
                         nouveau_montant: Decimal = None,
                         nouvelle_description: str = None,
                         nouvelle_date: datetime = None,
                         nouvelle_reference: str = None) -> Tuple[bool, str]:
    try:
        with self.db.get_cursor() as cursor:
            cursor.execute("""
                SELECT t.*,
                    COALESCE(cp.utilisateur_id, (
                        SELECT cp2.utilisateur_id
                        FROM sous_comptes sc
                        JOIN comptes_principaux cp2 ON sc.compte_principal_id = cp2.id
                        WHERE sc.id = t.sous_compte_id
                    )) as owner_user_id
                FROM transactions t
                LEFT JOIN comptes_principaux cp ON t.compte_principal_id = cp.id
                WHERE t.id = %s
            """, (transaction_id,))
            transaction = cursor.fetchone()
            if not transaction:
                return False, "Transaction non trouvée"

            type_tx = transaction['type_transaction']
            est_transfert = type_tx in ('transfert_entrant', 'transfert_sortant')
            compte_type = 'compte_principal' if transaction['compte_principal_id'] else 'sous_compte'
            compte_id = transaction['compte_principal_id'] or transaction['sous_compte_id']
            ancien_montant = safe_decimal(transaction['montant'])
            ancienne_date = transaction['date_transaction']

            # --- Construire les modifications demandées ---
            modifs = {}
            if nouveau_montant is not None and nouveau_montant != ancien_montant and nouveau_montant >= 0:
                modifs['montant'] = float(nouveau_montant)
            if nouvelle_description is not None and nouvelle_description != transaction.get('description', ''):
                modifs['description'] = nouvelle_description
            if nouvelle_date is not None and nouvelle_date != ancienne_date:
                if nouvelle_date > datetime.now() + timedelta(days=365):
                    return False, "La date ne peut pas être dans le futur lointain"
                modifs['date_transaction'] = nouvelle_date
            if nouvelle_reference is not None and nouvelle_reference != transaction.get('reference', ''):
                modifs['reference'] = nouvelle_reference

            if not modifs:
                return True, "Aucune modification nécessaire"

            # --- Récupérer la contrepartie si transfert ---
            contrepartie = None
            if est_transfert:
                contrepartie, erreur = self._trouver_contrepartie_transfert(cursor, transaction)
                if erreur:
                    logger.warning(f"Transfert {transaction_id} : {erreur}")
                    return False, erreur

            # --- Déterminer les champs à répercuter sur la contrepartie ---
            # Le montant et la date doivent être strictement identiques sur les deux moitiés.
            # La description peut différer (souvent inversée), on ne la répercute pas.
            # La reference doit être répercutée pour garder la cohérence.
            modifs_contrepartie = {}
            if 'montant' in modifs:
                modifs_contrepartie['montant'] = modifs['montant']
            if 'date_transaction' in modifs:
                modifs_contrepartie['date_transaction'] = modifs['date_transaction']
            if 'reference' in modifs and contrepartie is not None:
                modifs_contrepartie['reference'] = modifs['reference']

            # --- Appliquer les UPDATE ---
            def _update(tx_id, champs):
                if not champs:
                    return
                set_clause = ", ".join(f"{k} = %s" for k in champs)
                params = list(champs.values()) + [tx_id]
                cursor.execute(f"UPDATE transactions SET {set_clause} WHERE id = %s", params)

            _update(transaction_id, modifs)
            if contrepartie is not None:
                _update(contrepartie['id'], modifs_contrepartie)

            # --- Recalcul des soldes ---
            date_reference = self._date_reference_pour_recalcul(
                ancienne_date, modifs.get('date_transaction')
            )
            recalcul_necessaire = (
                'montant' in modifs or 'date_transaction' in modifs
            )

            if recalcul_necessaire:
                if not self._recalculer_soldes_apres_date_with_cursor(
                    cursor, compte_type, compte_id, date_reference
                ):
                    raise Exception("Erreur lors du recalcul des soldes")

                if contrepartie is not None:
                    autre_compte_type = 'compte_principal' if contrepartie['compte_principal_id'] else 'sous_compte'
                    autre_compte_id = contrepartie['compte_principal_id'] or contrepartie['sous_compte_id']
                    if not self._recalculer_soldes_apres_date_with_cursor(
                        cursor, autre_compte_type, autre_compte_id, date_reference
                    ):
                        raise Exception("Erreur lors du recalcul des soldes de la contrepartie")

            return True, "Transaction modifiée avec succès"

    except MySQLError as e:
        logger.exception("Erreur modification transaction")
        return False, f"Erreur lors de la modification: {str(e)}"

        