-- =====================================================
-- Import reçus Loyverse — généré le 2026-08-08 11:02:52
-- User ID : 6
-- =====================================================
SET NAMES utf8mb4;
SET @uid = 6;

-- 0. Les vieux articles introuvables garderont article_id = NULL
--    (le nom historique reste dans nom_article)
ALTER TABLE pos_receipt_items MODIFY article_id INT NULL;

-- 1. MODES DE PAIEMENT
INSERT IGNORE INTO pos_modes_paiement (utilisateur_id, nom, est_actif) VALUES (@uid, 'Card', 1);
INSERT IGNORE INTO pos_modes_paiement (utilisateur_id, nom, est_actif) VALUES (@uid, 'Cash', 1);
INSERT IGNORE INTO pos_modes_paiement (utilisateur_id, nom, est_actif) VALUES (@uid, 'Eat.ch', 1);
INSERT IGNORE INTO pos_modes_paiement (utilisateur_id, nom, est_actif) VALUES (@uid, 'Twint', 1);

-- 2. CLIENTS
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Plattet', '0794227066');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Carrell mariella', '0787103462');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Schwaller Marco', '0792816742');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Christophe Khuu (/Sari Amstutz)', '0798307821');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Byrde Benjamin', '0792733978');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Rossier Jocelyne', '0793894288');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Lucia Paolicelli Damiano Rickenbach', '0788598173');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Stefano Pedrojetta', '0763429129');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Quinodoz Madison', '0791046441');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Léa Gaillet', '0798420148');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Python Kevin', '0797677007');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Maya Meister', '0788371437');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Marco Meyer', '0767477317');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Croset Sylvain', '0792568013');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Porche Janique', '0793459156');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Camille Amman', '0799037994');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'De Bernardini Maelle', '0796857641');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Bussard Thierry', '0796687562');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Fragniere Gaelle', '0795542407');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Bertschy Julianne', '0798543367');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Sahitaj Adrian', '0796416795');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Ana Andrade', '0762398271');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Leonardi', '0799106249');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Toth', '0774345585');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Monney Yves', '0794832949');
INSERT IGNORE INTO pos_clients (utilisateur_id, nom_client, telephone) VALUES (@uid, 'Ballaman Jennifer', '0766831700');

-- 3. REÇUS, ITEMS ET PAIEMENTS

-- Reçu 11-3883 (02/01/2022 18:20) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 18:20:00', '11-3883', 'Import Loyverse', 'Vente',
  65.90, 0.00, 65.90, 1.61, 0.00, 65.90,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Ballaman Jennifer', '0766831700',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Ballaman Jennifer' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10068' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Duo' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Duo') LIMIT 1),
    NULL),
  'Menu Duo', 1.00, 44.90, 44.90, 2.45, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10031' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon cuit mayonnaise' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon cuit mayonnaise') LIMIT 1),
    NULL),
  'California thon cuit mayonnaise', 1.00, 9.50, 9.50, 2.42, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10025' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki foie gras confis d''oignons' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki foie gras confis d''oignons') LIMIT 1),
    NULL),
  'Maki foie gras confis d''oignons', 1.00, 10.50, 10.50, 2.48, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10156' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Baguettes' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Baguettes') LIMIT 1),
    NULL),
  'Baguettes', 2.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10163' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Suppléments standarts' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Suppléments standarts') LIMIT 1),
    NULL),
  'Suppléments standarts', 2.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 65.90, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Card' LIMIT 1;

-- Reçu 11-3884 (02/01/2022 18:29) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 18:29:00', '11-3884', 'Import Loyverse', 'Vente',
  45.00, 0.00, 45.00, 1.10, 0.00, 45.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Monney Yves', '0794832949',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Monney Yves' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10026' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='california saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('california saumon avocat') LIMIT 1),
    NULL),
  'california saumon avocat', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10029' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon avocat') LIMIT 1),
    NULL),
  'California thon avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10019' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki crevette concombre' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki crevette concombre') LIMIT 1),
    NULL),
  'Maki crevette concombre', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10009' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki thon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki thon') LIMIT 1),
    NULL),
  'Maki thon', 1.00, 8.50, 8.50, 2.35, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10007' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon avocat') LIMIT 1),
    NULL),
  'Maki saumon avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 3.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 45.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 11-3885 (02/01/2022 18:41) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 18:41:00', '11-3885', 'Import Loyverse', 'Vente',
  44.00, 0.00, 44.00, 1.07, 0.00, 44.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Toth', '0774345585',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Toth' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10070' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Végétarien Ii' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Végétarien Ii') LIMIT 1),
    NULL),
  'Menu Végétarien Ii', 2.00, 22.00, 44.00, 2.43, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 44.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Card' LIMIT 1;

-- Reçu 11-3886 (02/01/2022 18:58) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 18:58:00', '11-3886', 'Import Loyverse', 'Vente',
  42.50, 0.00, 42.50, 1.04, 0.00, 42.50,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Leonardi', '0799106249',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Leonardi' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10144' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California crevette spicy mangue' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California crevette spicy mangue') LIMIT 1),
    NULL),
  'California crevette spicy mangue', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10028' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon spicy' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon spicy') LIMIT 1),
    NULL),
  'California thon spicy', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10026' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='california saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('california saumon avocat') LIMIT 1),
    NULL),
  'california saumon avocat', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10023' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki avocat') LIMIT 1),
    NULL),
  'Maki avocat', 1.00, 6.00, 6.00, 2.33, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10024' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki poulet mangue poivron' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki poulet mangue poivron') LIMIT 1),
    NULL),
  'Maki poulet mangue poivron', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 3.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 42.50, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 11-3887 (02/01/2022 19:09) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 19:09:00', '11-3887', 'Import Loyverse', 'Vente',
  50.00, 0.00, 50.00, 1.18, 0.00, 50.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Ana Andrade', '0762398271',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Ana Andrade' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10027' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California saumon concombre cheese' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California saumon concombre cheese') LIMIT 1),
    NULL),
  'California saumon concombre cheese', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10009' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki thon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki thon') LIMIT 1),
    NULL),
  'Maki thon', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10006' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon') LIMIT 1),
    NULL),
  'Maki saumon', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10113' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri crevette' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri crevette') LIMIT 1),
    NULL),
  'Nigiri crevette', 1.00, 7.50, 7.50, 2.53, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10057' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri Saumon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri Saumon') LIMIT 1),
    NULL),
  'Nigiri Saumon', 2.00, 7.50, 15.00, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10000' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Sauce soja salé' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Sauce soja salé') LIMIT 1),
    NULL),
  'Sauce soja salé', 3.00, 0.50, 1.50, 0.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 50.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 11-3888 (02/01/2022 19:17) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 19:17:00', '11-3888', 'Import Loyverse', 'Vente',
  35.50, 0.00, 35.50, 0.87, 0.00, 35.50,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Sahitaj Adrian', '0796416795',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Sahitaj Adrian' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10028' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon spicy' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon spicy') LIMIT 1),
    NULL),
  'California thon spicy', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10026' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='california saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('california saumon avocat') LIMIT 1),
    NULL),
  'california saumon avocat', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10012' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki Thon cuit mayonaise' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki Thon cuit mayonaise') LIMIT 1),
    NULL),
  'Maki Thon cuit mayonaise', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10008' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon cheese' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon cheese') LIMIT 1),
    NULL),
  'Maki saumon cheese', 1.00, 8.00, 8.00, 2.50, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 35.50, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 11-3889 (02/01/2022 19:42) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 19:42:00', '11-3889', 'Import Loyverse', 'Vente',
  42.50, 0.00, 42.50, 1.01, 0.00, 42.50,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Bertschy Julianne', '0798543367',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Bertschy Julianne' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10038' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California poulet mangue menthe' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California poulet mangue menthe') LIMIT 1),
    NULL),
  'California poulet mangue menthe', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10145' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki vegetarien' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki vegetarien') LIMIT 1),
    NULL),
  'Maki vegetarien', 1.00, 6.00, 6.00, 2.50, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10143' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='maki surimi mayonnaise' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('maki surimi mayonnaise') LIMIT 1),
    NULL),
  'maki surimi mayonnaise', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10063' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri thon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri thon') LIMIT 1),
    NULL),
  'Nigiri thon', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10057' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri Saumon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri Saumon') LIMIT 1),
    NULL),
  'Nigiri Saumon', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10053' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Sauce soja sucré' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Sauce soja sucré') LIMIT 1),
    NULL),
  'Sauce soja sucré', 1.00, 1.00, 1.00, 0.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 42.50, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 6-5120 (02/01/2022 20:07) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 20:07:00', '6-5120', 'Import Loyverse', 'Vente',
  59.90, 0.00, 59.90, 1.46, 0.00, 59.90,
  'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Bussard Thierry', '0796687562',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Bussard Thierry' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10011' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Tokyo' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Tokyo') LIMIT 1),
    NULL),
  'Menu Tokyo', 1.00, 59.90, 59.90, 2.44, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 59.90, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Cash' LIMIT 1;

-- Reçu 6-5119 (02/01/2022 20:07) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 20:07:00', '6-5119', 'Import Loyverse', 'Vente',
  79.50, 0.00, 79.50, 1.94, 0.00, 79.50,
  'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Fragniere Gaelle', '0795542407',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Fragniere Gaelle' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10012' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki Thon cuit mayonaise' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki Thon cuit mayonaise') LIMIT 1),
    NULL),
  'Maki Thon cuit mayonaise', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10089' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki crevette avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki crevette avocat') LIMIT 1),
    NULL),
  'Maki crevette avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10007' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon avocat') LIMIT 1),
    NULL),
  'Maki saumon avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10186' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California saumon avocat cheese' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California saumon avocat cheese') LIMIT 1),
    NULL),
  'California saumon avocat cheese', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10030' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon avocat mangue' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon avocat mangue') LIMIT 1),
    NULL),
  'California thon avocat mangue', 1.00, 9.50, 9.50, 2.42, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10038' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California poulet mangue menthe' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California poulet mangue menthe') LIMIT 1),
    NULL),
  'California poulet mangue menthe', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10014' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California foie gras' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California foie gras') LIMIT 1),
    NULL),
  'California foie gras', 1.00, 10.00, 10.00, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10076' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki banane nutela' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki banane nutela') LIMIT 1),
    NULL),
  'Maki banane nutela', 1.00, 7.50, 7.50, 2.53, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10077' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki mangue speculos' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki mangue speculos') LIMIT 1),
    NULL),
  'Maki mangue speculos', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 79.50, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Card' LIMIT 1;

-- Reçu 6-5121 (02/01/2022 20:42) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 20:42:00', '6-5121', 'Import Loyverse', 'Vente',
  126.50, 0.00, 126.50, 3.09, 0.00, 126.50,
  'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
  'De Bernardini Maelle', '0796857641',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'De Bernardini Maelle' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10057' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri Saumon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri Saumon') LIMIT 1),
    NULL),
  'Nigiri Saumon', 2.00, 7.50, 15.00, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10060' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri saumon grillé' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri saumon grillé') LIMIT 1),
    NULL),
  'Nigiri saumon grillé', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10063' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri thon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri thon') LIMIT 1),
    NULL),
  'Nigiri thon', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10113' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri crevette' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri crevette') LIMIT 1),
    NULL),
  'Nigiri crevette', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10112' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri thon grillé' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri thon grillé') LIMIT 1),
    NULL),
  'Nigiri thon grillé', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10006' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon') LIMIT 1),
    NULL),
  'Maki saumon', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10009' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki thon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki thon') LIMIT 1),
    NULL),
  'Maki thon', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10089' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki crevette avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki crevette avocat') LIMIT 1),
    NULL),
  'Maki crevette avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10026' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='california saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('california saumon avocat') LIMIT 1),
    NULL),
  'california saumon avocat', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10029' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon avocat') LIMIT 1),
    NULL),
  'California thon avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10188' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California crevette avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California crevette avocat') LIMIT 1),
    NULL),
  'California crevette avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10186' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California saumon avocat cheese' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California saumon avocat cheese') LIMIT 1),
    NULL),
  'California saumon avocat cheese', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10007' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon avocat') LIMIT 1),
    NULL),
  'Maki saumon avocat', 2.00, 9.00, 18.00, 2.44, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 126.50, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Cash' LIMIT 1;

-- Reçu 11-3890 (02/01/2022 21:01) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 21:01:00', '11-3890', 'Import Loyverse', 'Vente',
  62.40, 0.00, 62.40, 1.52, 0.00, 62.40,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Camille Amman', '0799037994',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Camille Amman' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10068' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Duo' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Duo') LIMIT 1),
    NULL),
  'Menu Duo', 1.00, 44.90, 44.90, 2.45, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10063' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri thon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri thon') LIMIT 1),
    NULL),
  'Nigiri thon', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10113' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri crevette' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri crevette') LIMIT 1),
    NULL),
  'Nigiri crevette', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 62.40, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 11-3891 (02/01/2022 21:06) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 21:06:00', '11-3891', 'Import Loyverse', 'Vente',
  26.00, 0.00, 26.00, 0.63, 0.00, 26.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Porche Janique', '0793459156',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Porche Janique' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10006' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon') LIMIT 1),
    NULL),
  'Maki saumon', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10007' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon avocat') LIMIT 1),
    NULL),
  'Maki saumon avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10009' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki thon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki thon') LIMIT 1),
    NULL),
  'Maki thon', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 26.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 6-5123 (02/01/2022 21:13) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 21:13:00', '6-5123', 'Import Loyverse', 'Vente',
  16.70, 0.00, 16.70, 0.41, 0.00, 16.70,
  'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
  '', '',
  NULL,
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10023' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki avocat') LIMIT 1),
    NULL),
  'Maki avocat', 1.00, 6.00, 6.00, 2.50, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10036' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California concombre avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California concombre avocat') LIMIT 1),
    NULL),
  'California concombre avocat', 1.00, 7.50, 7.50, 2.40, 'Avocat';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10059' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Thé froid' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Thé froid') LIMIT 1),
    NULL),
  'Thé froid', 1.00, 3.20, 3.20, 2.50, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 16.70, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Cash' LIMIT 1;

-- Reçu 6-5122 (02/01/2022 21:13) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 21:13:00', '6-5122', 'Import Loyverse', 'Vente',
  59.90, 0.00, 59.90, 1.46, 0.00, 59.90,
  'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Croset Sylvain', '0792568013',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Croset Sylvain' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10011' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Tokyo' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Tokyo') LIMIT 1),
    NULL),
  'Menu Tokyo', 1.00, 59.90, 59.90, 2.44, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 59.90, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Cash' LIMIT 1;

-- Reçu 11-3892 (02/01/2022 21:27) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-02 21:27:00', '11-3892', 'Import Loyverse', 'Vente',
  63.00, 0.00, 63.00, 1.54, 0.00, 63.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Marco Meyer', '0767477317',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Marco Meyer' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10065' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Maki' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Maki') LIMIT 1),
    NULL),
  'Menu Maki', 1.00, 20.00, 20.00, 2.45, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10069' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Best of' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Best of') LIMIT 1),
    NULL),
  'Menu Best of', 1.00, 22.00, 22.00, 2.41, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10067' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Végétarien' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Végétarien') LIMIT 1),
    NULL),
  'Menu Végétarien', 1.00, 20.00, 20.00, 2.45, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 3.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 63.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 11-3897 (04/01/2022 20:21) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-04 20:21:00', '11-3897', 'Import Loyverse', 'Vente',
  65.00, 0.00, 65.00, 1.59, 0.00, 65.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Stefano Pedrojetta', '0763429129',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Stefano Pedrojetta' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10103' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Whiteroll crevette concombre menthe' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Whiteroll crevette concombre menthe') LIMIT 1),
    NULL),
  'Whiteroll crevette concombre menthe', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10031' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon cuit mayonnaise' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon cuit mayonnaise') LIMIT 1),
    NULL),
  'California thon cuit mayonnaise', 2.00, 9.50, 19.00, 2.42, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10028' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon spicy' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon spicy') LIMIT 1),
    NULL),
  'California thon spicy', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10026' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='california saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('california saumon avocat') LIMIT 1),
    NULL),
  'california saumon avocat', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10062' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri saumon cheese' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri saumon cheese') LIMIT 1),
    NULL),
  'Nigiri saumon cheese', 1.00, 8.50, 8.50, 2.35, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10072' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Springroll Saumon cheese aneth' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Springroll Saumon cheese aneth') LIMIT 1),
    NULL),
  'Springroll Saumon cheese aneth', 1.00, 10.50, 10.50, 2.48, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 3.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 65.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Cash' LIMIT 1;

-- Reçu 11-3896 (04/01/2022 20:21) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-04 20:21:00', '11-3896', 'Import Loyverse', 'Vente',
  31.00, 0.00, 31.00, 0.76, 0.00, 31.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Quinodoz Madison', '0791046441',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Quinodoz Madison' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10069' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Best of' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Best of') LIMIT 1),
    NULL),
  'Menu Best of', 1.00, 22.00, 22.00, 2.45, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10101' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Whiteroll saumon avocat aneth' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Whiteroll saumon avocat aneth') LIMIT 1),
    NULL),
  'Whiteroll saumon avocat aneth', 1.00, 8.00, 8.00, 2.50, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 31.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Twint' LIMIT 1;

-- Reçu 11-3895 (04/01/2022 20:21) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-04 20:21:00', '11-3895', 'Import Loyverse', 'Vente',
  66.50, 0.00, 66.50, 1.62, 0.00, 66.50,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Léa Gaillet', '0798420148',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Léa Gaillet' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10038' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California poulet mangue menthe' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California poulet mangue menthe') LIMIT 1),
    NULL),
  'California poulet mangue menthe', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10065' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Maki' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Maki') LIMIT 1),
    NULL),
  'Menu Maki', 2.00, 20.00, 40.00, 2.45, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10057' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri Saumon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri Saumon') LIMIT 1),
    NULL),
  'Nigiri Saumon', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10063' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri thon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri thon') LIMIT 1),
    NULL),
  'Nigiri thon', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 66.50, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 11-3894 (04/01/2022 20:21) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-04 20:21:00', '11-3894', 'Import Loyverse', 'Vente',
  27.00, 0.00, 27.00, 0.66, 0.00, 27.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Python Kevin', '0797677007',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Python Kevin' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10026' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='california saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('california saumon avocat') LIMIT 1),
    NULL),
  'california saumon avocat', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10029' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon avocat') LIMIT 1),
    NULL),
  'California thon avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10009' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki thon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki thon') LIMIT 1),
    NULL),
  'Maki thon', 1.00, 8.50, 8.50, 2.35, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 3.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 27.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 11-3893 (04/01/2022 20:21) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-04 20:21:00', '11-3893', 'Import Loyverse', 'Vente',
  31.00, 0.00, 31.00, 0.76, 0.00, 31.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Maya Meister', '0788371437',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Maya Meister' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10014' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California foie gras' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California foie gras') LIMIT 1),
    NULL),
  'California foie gras', 1.00, 10.00, 10.00, 2.50, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10066' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Kyoto' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Kyoto') LIMIT 1),
    NULL),
  'Menu Kyoto', 1.00, 20.00, 20.00, 2.45, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 31.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 11-3898 (04/01/2022 21:10) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-04 21:10:00', '11-3898', 'Import Loyverse', 'Vente',
  26.00, 0.00, 26.00, 0.63, 0.00, 26.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Lucia Paolicelli Damiano Rickenbach', '0788598173',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Lucia Paolicelli Damiano Rickenbach' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10026' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='california saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('california saumon avocat') LIMIT 1),
    NULL),
  'california saumon avocat', 1.00, 8.50, 8.50, 2.47, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10007' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon avocat') LIMIT 1),
    NULL),
  'Maki saumon avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10057' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Nigiri Saumon' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Nigiri Saumon') LIMIT 1),
    NULL),
  'Nigiri Saumon', 1.00, 7.50, 7.50, 2.40, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 26.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Eat.ch' LIMIT 1;

-- Reçu 6-5124 (05/01/2022 18:26) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-05 18:26:00', '6-5124', 'Import Loyverse', 'Vente',
  18.00, 0.00, 18.00, 0.44, 0.00, 18.00,
  'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
  '', '',
  NULL,
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10157' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='A la piece' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('A la piece') LIMIT 1),
    NULL),
  'A la piece', 1.00, 18.00, 18.00, 2.44, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 18.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Cash' LIMIT 1;

-- Reçu 6-5125 (05/01/2022 19:56) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-05 19:56:00', '6-5125', 'Import Loyverse', 'Vente',
  91.50, 0.00, 91.50, 2.23, 0.00, 91.50,
  'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Rossier Jocelyne', '0793894288',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Rossier Jocelyne' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10025' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki foie gras confis d''oignons' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki foie gras confis d''oignons') LIMIT 1),
    NULL),
  'Maki foie gras confis d''oignons', 1.00, 10.50, 10.50, 2.48, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10008' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon cheese' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon cheese') LIMIT 1),
    NULL),
  'Maki saumon cheese', 1.00, 8.00, 8.00, 2.38, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10007' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon avocat') LIMIT 1),
    NULL),
  'Maki saumon avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10010' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki thon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki thon avocat') LIMIT 1),
    NULL),
  'Maki thon avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10024' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki poulet mangue poivron' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki poulet mangue poivron') LIMIT 1),
    NULL),
  'Maki poulet mangue poivron', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10026' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='california saumon avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('california saumon avocat') LIMIT 1),
    NULL),
  'california saumon avocat', 2.00, 8.50, 17.00, 2.41, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10031' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon cuit mayonnaise' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon cuit mayonnaise') LIMIT 1),
    NULL),
  'California thon cuit mayonnaise', 1.00, 9.50, 9.50, 2.53, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10027' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California saumon concombre cheese' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California saumon concombre cheese') LIMIT 1),
    NULL),
  'California saumon concombre cheese', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10072' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Springroll Saumon cheese aneth' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Springroll Saumon cheese aneth') LIMIT 1),
    NULL),
  'Springroll Saumon cheese aneth', 1.00, 10.50, 10.50, 2.38, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 91.50, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Cash' LIMIT 1;

-- Reçu 6-5126 (05/01/2022 19:57) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-05 19:57:00', '6-5126', 'Import Loyverse', 'Vente',
  54.50, 2.00, 52.50, 1.28, 0.00, 52.50,
  'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Byrde Benjamin', '0792733978',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Byrde Benjamin' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10008' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki saumon cheese' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki saumon cheese') LIMIT 1),
    NULL),
  'Maki saumon cheese', 1.00, 8.00, 8.00, 2.46, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10012' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki Thon cuit mayonaise' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki Thon cuit mayonaise') LIMIT 1),
    NULL),
  'Maki Thon cuit mayonaise', 3.00, 9.00, 27.00, 2.42, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10031' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California thon cuit mayonnaise' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California thon cuit mayonnaise') LIMIT 1),
    NULL),
  'California thon cuit mayonnaise', 1.00, 9.50, 9.50, 2.51, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10300' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Sashimi saumon 6 pieces' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Sashimi saumon 6 pieces') LIMIT 1),
    NULL),
  'Sashimi saumon 6 pieces', 1.00, 10.00, 10.00, 2.39, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10156' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Baguettes' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Baguettes') LIMIT 1),
    NULL),
  'Baguettes', 2.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10148' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Soja sucré' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Soja sucré') LIMIT 1),
    NULL),
  'Soja sucré', 6.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 52.50, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Twint' LIMIT 1;

-- Reçu 6-5127 (05/01/2022 19:58) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-05 19:58:00', '6-5127', 'Import Loyverse', 'Vente',
  28.50, 0.00, 28.50, 0.70, 0.00, 28.50,
  'Caisse principal 3', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Christophe Khuu (/Sari Amstutz)', '0798307821',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Christophe Khuu (/Sari Amstutz)' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 2.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10038' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California poulet mangue menthe' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California poulet mangue menthe') LIMIT 1),
    NULL),
  'California poulet mangue menthe', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10101' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Whiteroll saumon avocat aneth' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Whiteroll saumon avocat aneth') LIMIT 1),
    NULL),
  'Whiteroll saumon avocat aneth', 1.00, 8.00, 8.00, 2.50, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10072' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Springroll Saumon cheese aneth' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Springroll Saumon cheese aneth') LIMIT 1),
    NULL),
  'Springroll Saumon cheese aneth', 1.00, 10.50, 10.50, 2.48, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10162' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Pas de baguette' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Pas de baguette') LIMIT 1),
    NULL),
  'Pas de baguette', 1.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10147' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Soja salé' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Soja salé') LIMIT 1),
    NULL),
  'Soja salé', 1.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10148' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Soja sucré' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Soja sucré') LIMIT 1),
    NULL),
  'Soja sucré', 1.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 28.50, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Twint' LIMIT 1;

-- Reçu 11-3900 (05/01/2022 20:46) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-05 20:46:00', '11-3900', 'Import Loyverse', 'Vente',
  60.90, 0.00, 60.90, 1.49, 0.00, 60.90,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Carrell mariella', '0787103462',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Carrell mariella' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10011' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Tokyo' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Tokyo') LIMIT 1),
    NULL),
  'Menu Tokyo', 1.00, 59.90, 59.90, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 3.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10156' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Baguettes' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Baguettes') LIMIT 1),
    NULL),
  'Baguettes', 2.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10147' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Soja salé' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Soja salé') LIMIT 1),
    NULL),
  'Soja salé', 4.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10149' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Gingembre' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Gingembre') LIMIT 1),
    NULL),
  'Gingembre', 1.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 60.90, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Card' LIMIT 1;

-- Reçu 11-3899 (05/01/2022 20:46) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-05 20:46:00', '11-3899', 'Import Loyverse', 'Vente',
  55.00, 0.00, 55.00, 1.34, 0.00, 55.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Schwaller Marco', '0792816742',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Schwaller Marco' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10099' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Springroll poulet mangue poivron' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Springroll poulet mangue poivron') LIMIT 1),
    NULL),
  'Springroll poulet mangue poivron', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10090' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California Thon cuit avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California Thon cuit avocat') LIMIT 1),
    NULL),
  'California Thon cuit avocat', 1.00, 9.50, 9.50, 2.42, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10027' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California saumon concombre cheese' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California saumon concombre cheese') LIMIT 1),
    NULL),
  'California saumon concombre cheese', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10188' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California crevette avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California crevette avocat') LIMIT 1),
    NULL),
  'California crevette avocat', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10038' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='California poulet mangue menthe' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('California poulet mangue menthe') LIMIT 1),
    NULL),
  'California poulet mangue menthe', 1.00, 9.00, 9.00, 2.44, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10152' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Maki Thon cuit mayo avocat' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Maki Thon cuit mayo avocat') LIMIT 1),
    NULL),
  'Maki Thon cuit mayo avocat', 1.00, 9.50, 9.50, 2.42, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 55.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Card' LIMIT 1;

-- Reçu 11-3901 (05/01/2022 20:47) — Vente
INSERT INTO pos_receipts (
  utilisateur_id, date, recu_numero, nom_ticket, receipt_type,
  ventes_brutes, reduction, ventes_nettes, taxes, tips, total_collecte,
  pdv, magasin, nom_du_caissier, nom_du_client, numero_client, id_client, status
) VALUES (
  @uid, '2022-01-05 20:47:00', '11-3901', 'Import Loyverse', 'Vente',
  23.00, 10.00, 13.00, 0.32, 0.00, 13.00,
  'SamsungA40', 'Esprit Sushi Fribourg', 'Propriétaire',
  'Plattet', '0794227066',
  (SELECT id FROM (SELECT id FROM pos_clients WHERE utilisateur_id = @uid AND nom_client = 'Plattet' LIMIT 1) tmp),
  'Fermé'
);
SET @receipt_id = LAST_INSERT_ID();
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10136' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Frais de livraison' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Frais de livraison') LIMIT 1),
    NULL),
  'Frais de livraison', 1.00, 1.00, 1.00, 1.75, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10069' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Menu Best of' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Menu Best of') LIMIT 1),
    NULL),
  'Menu Best of', 1.00, 22.00, 22.00, 2.49, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10147' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Soja salé' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Soja salé') LIMIT 1),
    NULL),
  'Soja salé', 1.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_receipt_items (
  receipt_id, article_id, nom_article, quantite,
  prix_unitaire, total_ligne, taux_taxe_applique, commentaire
) SELECT @receipt_id,
  COALESCE(
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND TRIM(code_barre)='10156' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND nom_article='Baguettes' LIMIT 1),
    (SELECT id FROM pos_articles WHERE utilisateur_id=@uid AND LOWER(TRIM(nom_article))=LOWER('Baguettes') LIMIT 1),
    NULL),
  'Baguettes', 1.00, 0.00, 0.00, 0.00, '';
INSERT INTO pos_payments (receipt_id, mode_paiement_id, montant, est_remboursement)
SELECT @receipt_id, mp.id, 13.00, 0
FROM pos_modes_paiement mp
WHERE mp.utilisateur_id=@uid AND mp.nom='Card' LIMIT 1;

-- 4. RÉPARATION : relie les items orphelins à leur article (insensible
--    aux majuscules/espaces/accents)
UPDATE pos_receipt_items ri
JOIN pos_articles a
  ON a.utilisateur_id = @uid
 AND LOWER(TRIM(a.nom_article)) = LOWER(TRIM(ri.nom_article))
SET ri.article_id = a.id
WHERE ri.article_id IS NULL;

-- 5. VÉRIFICATION
SELECT COUNT(*) AS recus_importes FROM pos_receipts WHERE nom_ticket='Import Loyverse';
SELECT COUNT(*) AS items_sans_article FROM pos_receipt_items ri
JOIN pos_receipts r ON r.id=ri.receipt_id
WHERE r.nom_ticket='Import Loyverse' AND ri.article_id IS NULL;
