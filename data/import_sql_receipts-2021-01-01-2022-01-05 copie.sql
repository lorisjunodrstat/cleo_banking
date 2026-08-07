-- =====================================================
-- Import des reçus Loyverse
-- Généré le 2026-08-07 18:58:58
-- User ID: 6
-- =====================================================

SET @uid = 6;

-- === 3. REÇUS ET ITEMS ===

-- Reçu 6-4385 (01/04/2021 18:24) - Vente
INSERT INTO pos_receipts (
    utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
    ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
    pdv, magasin, nom_du_caissier, nom_du_client, numero_client, status
) VALUES (
    @uid, '2021-04-01 18:24:00', '6-4385', 'Import Loyverse', 'Vente',
    42.00, 2.10, 39.90, 0.97, 0.00, 39.90,
    'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
    'Toth', '0774345585', 'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
-- Article: Menu Végétarien Ii x1.0
INSERT INTO pos_receipt_items (
    receipt_id, article_id, nom_article, variante_id, quantite,
    prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT
    @receipt_id,
    COALESCE((SELECT id FROM pos_articles WHERE utilisateur_id = @uid AND code_barre = '10070' LIMIT 1),
             (SELECT id FROM pos_articles WHERE utilisateur_id = @uid AND nom_article = 'Menu Végétarien Ii' LIMIT 1),
             NULL),
    'Menu Végétarien Ii',
    NULL,
    1.00,
    22.00,
    22.00,
    2.44,
    'Décoration anniversaire'
;
-- Article: Menu Végétarien x1.0
INSERT INTO pos_receipt_items (
    receipt_id, article_id, nom_article, variante_id, quantite,
    prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT
    @receipt_id,
    COALESCE((SELECT id FROM pos_articles WHERE utilisateur_id = @uid AND code_barre = '10067' LIMIT 1),
             (SELECT id FROM pos_articles WHERE utilisateur_id = @uid AND nom_article = 'Menu Végétarien' LIMIT 1),
             NULL),
    'Menu Végétarien',
    NULL,
    1.00,
    20.00,
    20.00,
    2.42,
    ''
;
-- Paiement: Cash
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 39.90, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id = @uid AND mp.nom = 'Cash' LIMIT 1;
