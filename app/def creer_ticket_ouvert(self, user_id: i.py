def creer_ticket_ouvert(self, user_id: int, data: Dict) -> Tuple[bool, str, Optional[int]]:
        """Enregistre un ticket sans paiement (status 'Ouvert'), sans transaction bancaire."""
        try:
            with self.db.get_cursor(dictionary=True) as cursor:
                ventes_brutes_ht = Decimal('0')
                total_taxes = Decimal('0')
                items_data = []
                
                for item in data.get('items', []):
                    cursor.execute("SELECT * FROM pos_articles WHERE id = %s", (item['article_id'],))
                    article = cursor.fetchone()
                    if not article:
                        return False, f"Article {item['article_id']} introuvable", None
                    
                    prix_ttc = Decimal(str(item.get('prix_unitaire', article['prix_unitaire'])))
                    qte = int(item.get('quantite', 1))
                    total_ligne_ttc = prix_ttc * qte
                    
                    taxe = self._get_taxe_active(cursor, item['article_id'])
                    taux_taxe = Decimal('0')
                    if taxe:
                        taux_taxe = Decimal(str(taxe['taux']))
                        
                    if taux_taxe > Decimal('0'):
                        diviseur = Decimal('1') + (taux_taxe / Decimal('100'))
                        ligne_ht = (total_ligne_ttc / diviseur).quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)
                    else:
                        ligne_ht = total_ligne_ttc.quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)
                        
                    ligne_taxe = (total_ligne_ttc - ligne_ht).quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)
                    
                    ventes_brutes_ht += ligne_ht
                    total_taxes += ligne_taxe
                    
                    items_data.append({
                        'article_id': item['article_id'],
                        'nom_article': article['nom_article'],
                        'variante_id': item.get('variante_id'),
                        'quantite': qte,
                        'prix_ttc': prix_ttc,
                        'total_ligne_ttc': total_ligne_ttc,
                        'taux_taxe': taux_taxe,
                        'commentaire': item.get('commentaire', '') or '',
                    })
                
                total_collecte = ventes_brutes_ht + total_taxes
                recu_numero = f"O-{datetime.now().strftime('%Y%m%d%H%M%S')}-{user_id}"
                reduction_ttc = Decimal('0')
                reduction_ht = Decimal('0')
                if data.get('discount_id'):
                    cursor.execute("SELECT * FROM pos_discounts WHERE id = %s", (data['discount_id'],))
                    discount = cursor.fetchone()
                    if discount:
                        total_ttc_global = sum(i['total_ligne_ttc'] for i in items_data)
                        if discount['type_reduction'] == 'percentage':
                            reduction_ttc = total_ttc_global * (Decimal(str(discount['valeur'])) / Decimal('100'))
                        else:
                            reduction_ttc = Decimal(str(discount['valeur']))
                        # HT de la réduction
                        if total_taxes > 0 and ventes_brutes_ht > 0:
                            taux_moyen = (total_taxes / ventes_brutes_ht) * 100
                            reduction_ht = reduction_ttc / (Decimal('1') + taux_moyen/Decimal('100'))
                        else:
                            reduction_ht = reduction_ttc
                                cursor.execute("""
                    INSERT INTO pos_receipts 
                        (utilisateur_id, date, recu_numero, nom_ticket, description, receipt_type,
                        ventes_brutes, reduction, ventes_nettes, taxes, total_collecte,
                        restaurant_option_id, pdv, magasin, nom_du_caissier,
                        nom_du_client, id_client, discount_id, discount_amount, status)
                        VALUES (%s, NOW(), %s, %s, %s, 'Vente', %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 'Ouvert')
                        """, (
                        user_id, recu_numero,
                        data.get('nom_ticket', ''), data.get('commentaire', ''),
                        float(ventes_brutes_ht), float(reduction_ht), 
                        float(ventes_brutes_ht - reduction_ht), float(total_taxes), 
                        float(total_collecte - reduction_ttc),  # <--- CORRECTION ICI
                        data.get('restaurant_option_id'), data.get('pdv'), data.get('magasin'),
                        data.get('nom_du_caissier'), data.get('nom_du_client'), data.get('id_client'),
                        data.get('discount_id'), float(reduction_ttc)
                    ))
                receipt_id = cursor.lastrowid
                
                for item in items_data:
                    cursor.execute("""
                        INSERT INTO pos_receipt_items 
                        (receipt_id, article_id, nom_article, variante_id, quantite, prix_unitaire, 
                        total_ligne, taux_taxe_applique, commentaire)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """, (
                        receipt_id, item['article_id'], item['nom_article'], item['variante_id'],
                        item['quantite'], float(item['prix_ttc']),
                        float(item['total_ligne_ttc']), float(item['taux_taxe'])
                    ))
                
                return True, "Ticket enregistré", receipt_id
                
        except Exception as e:
            logger.error(f"Erreur ticket ouvert: {e}")
            return False, f"Erreur: {str(e)}", None

