    def create_transfert_interne(self, source_type: str, source_id: int,
                                dest_type: str, dest_id: int, user_id: int,
                                montant: Decimal, description: str = "",
                                date_transaction: datetime = None) -> Tuple[bool, str]:
        """
        Exécute un transfert interne entre deux comptes gérés.

        Args:
            source_type (str): Le type du compte source ('compte_principal' ou 'sous_compte').
            source_id (int): L'ID du compte source.
            dest_type (str): Le type du compte de destination ('compte_principal' ou 'sous_compte').
            dest_id (int): L'ID du compte de destination.
            user_id (int): L'ID de l'utilisateur effectuant le transfert.
            montant (Decimal): Le montant à transférer.
            description (str): Une description optionnelle pour la transaction.
            date_transaction (datetime): Date et heure de la transaction (maintenant par défaut).

        Returns:
            Tuple[bool, str]: Un tuple indiquant le succès (True/False) et un message.
        """
        logger.info(f"=== DÉBUT TRANSFERT INTERNE ===")
        logger.info(f"Source: {source_type} ID {source_id}")
        logger.info(f"Destination: {dest_type} ID {dest_id}")
        logger.info(f"Utilisateur: {user_id}, Montant: {montant}")

        # Validations initiales
        if montant <= 0:
            logger.warning("❌ Échec: Le montant doit être positif")
            return False, "Le montant doit être positif"

        if source_type == dest_type and source_id == dest_id:
            logger.warning("❌ Échec: Les comptes source et destination doivent être différents")
            return False, "Les comptes source et destination doivent être différents"

        if date_transaction is None:
            date_transaction = datetime.now()

        try:
            with self.db.get_cursor(dictionary=True, commit=True) as cursor:
                # Vérifier l'appartenance des comptes
                if not self._verifier_appartenance_compte_with_cursor(cursor, source_type, source_id, user_id):
                    return False, "Compte source non trouvé ou non autorisé"

                #if not self._verifier_appartenance_compte_with_cursor(cursor, dest_type, dest_id, user_id):
                #    return False, "Compte destination non trouvé ou non autorisé"

                # Récupérer les soldes
                solde_ok, _ = self._valider_solde_suffisant_with_cursor(cursor, source_type, source_id, montant)
                if not solde_ok:
                    return False, "Solde insuffisant sur le compte source"


                # Générer une référence unique
                timestamp = int(time.time())
                reference = f"TRF_{timestamp}_{source_type}_{source_id}_{dest_type}_{dest_id}"

                # Créer la description complète
                desc_complete = f"{description} (Réf: {reference})"

                # 1. Transaction de DÉBIT sur le compte source
                success, message, debit_tx_id = self._inserer_transaction_with_cursor(
                    cursor, source_type, source_id, 'transfert_sortant', montant,
                    desc_complete, user_id, date_transaction, True
                )

                if not success:
                    return False, f"Erreur transaction débit: {message}"

                # 2. Transaction de CRÉDIT sur le compte destination
                success, message, credit_tx_id = self._inserer_transaction_with_cursor(
                    cursor, dest_type, dest_id, 'transfert_entrant', montant,
                    desc_complete, user_id, date_transaction,  False
                )

                if not success:
                    return False, f"Erreur transaction crédit: {message}"

                # Déterminer les IDs de source et de destination pour les liens
                source_compte_id = source_id if source_type == 'compte_principal' else None
                source_sous_compte_id = source_id if source_type == 'sous_compte' else None

                dest_compte_id = dest_id if dest_type == 'compte_principal' else None
                dest_sous_compte_id = dest_id if dest_type == 'sous_compte' else None

                # Mettre à jour les deux transactions avec les liens bidirectionnels
                update_query = """
                UPDATE transactions
                SET
                    compte_source_id = %s,
                    sous_compte_source_id = %s,
                    compte_destination_id = %s,
                    sous_compte_destination_id = %s
                WHERE id IN (%s, %s)
                """
                cursor.execute(update_query, (
                    source_compte_id, source_sous_compte_id,
                    dest_compte_id, dest_sous_compte_id,
                    debit_tx_id, credit_tx_id
                ))

                # Optionnel : loguer les IDs des transactions créées
                logger.info(f"✅ Transfert interne réussi : débit={debit_tx_id}, crédit={credit_tx_id}")

                # Le commit est automatique à la sortie du bloc 'with'
                return True, "Transfert interne effectué avec succès"

        except Exception as e:
            logger.error(f"❌ Erreur lors du transfert interne: {e}", exc_info=True)
            return False, f"Erreur lors du transfert: {str(e)}"

    