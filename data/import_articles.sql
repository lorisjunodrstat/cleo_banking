SET @uid = 6;

-- ===== CATÉGORIES =====
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Abonnement');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Accompagnement');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Boissons');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'California');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Desserts');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Devis');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Divers');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Gunkan');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Ingrédients');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Lunchbox');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Maki');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Menus');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Nigiri');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Originaux');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Paiement');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Raviolis');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Sashimi');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Springroll');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Supplements gratuits');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Suppléments');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'Tartare');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'livraison');
INSERT IGNORE INTO pos_categories (utilisateur_id, nom_categorie) VALUES (@uid, 'whiteroll');

-- ===== TAXES =====
INSERT IGNORE INTO pos_taxes (utilisateur_id, nom, taux, date_debut, est_actif) VALUES (@uid, 'Alcool', 7.70, CURDATE(), 1);
INSERT IGNORE INTO pos_taxes (utilisateur_id, nom, taux, date_debut, est_actif) VALUES (@uid, 'Alimentaire', 2.50, CURDATE(), 1);

-- ===== ARTICLES =====

-- A la piece (SKU 10157)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'A la piece', '', 'piece', 0.00, 0.00, 0, 0, 1, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Accompagnement';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Avocat (SKU 10207)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Avocat', '', 'piece', 0.00, 0.00, 0, 0, 1, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Ingrédients';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Baguettes (SKU 10156)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Baguettes', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Biere (SKU 10004)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Biere', '', 'piece', 5.00, 0.00, -72, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Boissons';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alcool';
SET @opt_name = NULL;

-- Bon cadeau (SKU 10160)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Bon cadeau', '', 'piece', 0.00, 0.00, 0, 0, 1, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'livraison';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Box de Noël (SKU 10173)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Box de Noël', '', 'piece', 89.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alcool';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Box Saint valentin (SKU 10175)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Box Saint valentin', '', 'piece', 59.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Saint Valentin';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Brochette de poulet (SKU 10146)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Brochette de poulet', '', 'piece', 8.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Accompagnement';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California 2*3 (SKU 10220)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California 2*3', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'California';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'fromage';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, '1', @opt_name, 9.00, 0, 1);

-- California avocat cheese (SKU 10168)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California avocat cheese', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California avocat thon cuit mayonnaise (SKU 10187)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California avocat thon cuit mayonnaise', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Ciboulette';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California concombre avocat (SKU 10036)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California concombre avocat', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California concombre avocat cheese (SKU 10037)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California concombre avocat cheese', '', 'piece', 8.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California concombre cheese (SKU 10035)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California concombre cheese', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California crevette avocat (SKU 10188)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California crevette avocat', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California crevette concombre (SKU 10033)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California crevette concombre', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Menthe';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California crevette concombre menthe (SKU 10034)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California crevette concombre menthe', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California crevette spicy mangue (SKU 10144)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California crevette spicy mangue', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California foie gras (SKU 10014)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California foie gras', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California Poulet avocat poivron (SKU 10015)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California Poulet avocat poivron', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California poulet mangue menthe (SKU 10038)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California poulet mangue menthe', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California poulet mangue moutarde de Bénichon (SKU 10190)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California poulet mangue moutarde de Bénichon', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California Poulet mangue poivron (SKU 10172)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California Poulet mangue poivron', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- california saumon avocat (SKU 10026)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'california saumon avocat', '', 'piece', 8.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California saumon avocat cheese (SKU 10186)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California saumon avocat cheese', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California saumon avocat mangue (SKU 10213)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California saumon avocat mangue', '<p>California saumon avocat mangue</p>', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California saumon concombre cheese (SKU 10027)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California saumon concombre cheese', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California standard (SKU 10170)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California standard', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Divers';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California surimi avocat mayonnaise (SKU 10185)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California surimi avocat mayonnaise', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California Surimi concombre mayonnaise (SKU 10032)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California Surimi concombre mayonnaise', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California thon avocat (SKU 10029)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California thon avocat', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California thon avocat mangue (SKU 10030)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California thon avocat mangue', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California Thon cuit avocat (SKU 10090)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California Thon cuit avocat', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Ciboulette';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California thon cuit mayonnaise (SKU 10031)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California thon cuit mayonnaise', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Ciboulette';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California thon spicy (SKU 10028)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California thon spicy', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California tobikko Surimi concombre mayo (SKU 10105)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California tobikko Surimi concombre mayo', '', 'piece', 11.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Originaux';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- California tofu au basilic (SKU 10013)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'California tofu au basilic', '', 'piece', 8.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Confiture de figue';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- california tofu au basilic confiture de figue (SKU 10039)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'california tofu au basilic confiture de figue', '', 'piece', 8.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'California';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Californias (90 pièces) (SKU 10177)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Californias (90 pièces)', '', 'piece', 90.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Cheese (SKU 10208)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Cheese', '', 'piece', 0.00, 0.00, 0, 0, 1, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Ingrédients';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Coca cola (SKU 10212)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Coca cola', '', 'piece', 3.20, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Boissons';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Coca';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'Coca Cola';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'Coca Cola Zéro', @opt_name, 3.20, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'normal', @opt_name, 0.00, 9, 1);

-- Demander sauces et baguettes à la livraison (SKU 10203)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Demander sauces et baguettes à la livraison', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Feuille nori California (SKU 10210)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Feuille nori California', '', 'piece', 0.00, 0.00, 0, 0, 1, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Ingrédients';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Frais de livraison (SKU 10136)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Frais de livraison', '', 'piece', 1.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'livraison';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gingembre (SKU 10074)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gingembre', '', 'piece', 0.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Suppléments';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gingembre (SKU 10149)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gingembre', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gunkan massago (SKU 10111)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gunkan massago', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Gunkan';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gunkan poulet mangue poivron (SKU 10174)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gunkan poulet mangue poivron', '', 'piece', 8.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Gunkan';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gunkan saumon avocat aneth (SKU 10106)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gunkan saumon avocat aneth', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Gunkan';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gunkan Tartare concombre carotte (SKU 10110)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gunkan Tartare concombre carotte', '', 'piece', 8.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Gunkan';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gunkan Tartare de crevette (SKU 10109)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gunkan Tartare de crevette', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Gunkan';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gunkan Tartare de Surimi (SKU 10108)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gunkan Tartare de Surimi', '', 'piece', 8.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Gunkan';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gunkan thon avocat ciboulette (SKU 10107)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gunkan thon avocat ciboulette', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Gunkan';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Gyozas (SKU 10087)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Gyozas', '', 'piece', 28.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Raviolis';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Ravioli';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Accompagnement ravioli';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'Nombre';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, '15', @opt_name, 28.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, '9', @opt_name, 25.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, '9', @opt_name, 20.00, 0, 1);

-- Henniez (SKU 10120)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Henniez', '', 'piece', 3.00, 0.00, -3, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Boissons';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Henniez';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'type';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'gazeuse', @opt_name, 3.00, -3, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'plate', @opt_name, 3.00, -7, 1);

-- Henniez (SKU 10151)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Henniez', '', 'piece', 3.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Boissons';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Henniez';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Lunchbox gyoza (SKU 10139)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Lunchbox gyoza', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Lunchox gyoza';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- lunchbox gyozas Poulet / Crevette (SKU 10133)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'lunchbox gyozas Poulet / Crevette', '', 'piece', 11.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'type';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'standard', @opt_name, 11.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'étudiant', @opt_name, 9.00, 0, 1);

-- lunchbox gyozas végétarien (SKU 10131)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'lunchbox gyozas végétarien', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'type';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'normal', @opt_name, 10.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'étudiant', @opt_name, 8.00, 0, 1);

-- Lunchbox maki (SKU 10138)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Lunchbox maki', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Lunchox maki';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Lunchbox maki végétariens (SKU 10123)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Lunchbox maki végétariens', '', 'piece', 12.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'type';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'standard', @opt_name, 12.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'étudiant', @opt_name, 10.00, 0, 1);

-- Lunchox Maki Saumon thon (SKU 10056)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Lunchox Maki Saumon thon', '', 'piece', 12.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'Type';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'Etudiant', @opt_name, 12.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'standard', @opt_name, 15.00, 0, 1);

-- Maki 2*3 (SKU 10194)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki 2*3', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Maki pour menus';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki anguille grillée mangue (SKU 10142)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki anguille grillée mangue', '', 'piece', 13.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki avocat (SKU 10023)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki avocat', '', 'piece', 6.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki avocat cheese (SKU 10600)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki avocat cheese', '', 'piece', 6.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki Avocat Mangue (SKU 10206)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki Avocat Mangue', '', 'piece', 6.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki banana speculos (SKU 10075)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki banana speculos', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Desserts';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki banane nutela (SKU 10076)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki banane nutela', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Desserts';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki concombre (SKU 10205)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki concombre', '', 'piece', 7.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki concombre avocat (SKU 10021)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki concombre avocat', '', 'piece', 6.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki concombre avocat cheese (SKU 10022)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki concombre avocat cheese', '', 'piece', 6.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki concombre cheese (SKU 10020)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki concombre cheese', '', 'piece', 6.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki crevette avocat (SKU 10089)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki crevette avocat', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki crevette concombre (SKU 10019)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki crevette concombre', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Menthe';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki foie gras confis d'oignons (SKU 10025)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki foie gras confis d\'oignons', '', 'piece', 10.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki mangue speculos (SKU 10077)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki mangue speculos', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Desserts';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki poire Nutella choco (SKU 10078)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki poire Nutella choco', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Desserts';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki poulet mangue poivron (SKU 10024)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki poulet mangue poivron', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki poulet moutarde de benichon (SKU 10189)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki poulet moutarde de benichon', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki saumon (SKU 10006)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki saumon', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki saumon avocat (SKU 10007)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki saumon avocat', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki saumon cheese (SKU 10008)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki saumon cheese', '', 'piece', 8.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki standart (SKU 10169)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki standart', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Divers';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- maki surimi mayonnaise (SKU 10143)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'maki surimi mayonnaise', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki surimi mayonnaise avocat (SKU 10184)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki surimi mayonnaise avocat', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki thon (SKU 10009)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki thon', '', 'piece', 8.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki thon avocat (SKU 10010)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki thon avocat', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki thon cheese (SKU 10001)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki thon cheese', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki Thon cuit mayo avocat (SKU 10152)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki Thon cuit mayo avocat', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Ciboulette';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki Thon cuit mayonaise (SKU 10012)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki Thon cuit mayonaise', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Ciboulette';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki Thon cuit mayonnaise avocat (SKU 10183)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki Thon cuit mayonnaise avocat', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Ciboulette';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- maki tofu au basilic (SKU 10016)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'maki tofu au basilic', '', 'piece', 7.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Confiture de figue';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki tofu au basilic confiture de figue (SKU 10017)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki tofu au basilic confiture de figue', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Maki vegetarien (SKU 10145)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Maki vegetarien', '', 'piece', 6.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Maki';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Makis (120 pièces) (SKU 10176)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Makis (120 pièces)', '', 'piece', 109.20, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Mangajo (SKU 10061)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Mangajo', '', 'piece', 4.50, 0.00, -122, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Boissons';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Mangajo';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Best of (SKU 10069)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Best of', '', 'piece', 22.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boissons';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Duo (SKU 10068)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Duo', '', 'piece', 44.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boissons';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boisson 2';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Edo (SKU 10201)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Edo', '', 'piece', 79.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Maki pour menus';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'California';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Nigiri pour menu';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Dessert';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Empereur (SKU 10071)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Empereur', '', 'piece', 109.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Maki pour menus';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'California';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Nigiri pour menu';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Sashimi';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu hajime (SKU 10217)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu hajime', '<p>24 Maki, 18 California, 12 springroll, 6 Nigiri</p>', 'piece', 99.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Maki pour menus';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'California';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Nigiri pour menu';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Springroll Pour Menu';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Kobe (SKU 10005)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Kobe', '', 'piece', 129.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Maki pour menus';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'California';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Nigiri pour menu';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Sashimi';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Kobe (réduction 303) (SKU 10180)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Kobe (réduction 303)', '', 'piece', 90.95, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Kyoto (SKU 10066)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Kyoto', '', 'piece', 20.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boissons';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Maguro (SKU 10215)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Maguro', '<p id="isPasted" style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>Menu sp&eacute;cial thon</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>- 3 maki thon</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>- 3 maki thon avocat</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>- 3 california thon avocat</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>- 3 california thon avocat mangue</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>- 1 nigiri thon</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>- 1 nigiri thpn grill&eacute;</p><p><a style="color: rgb(235, 73, 71); transition: color 400ms, background-color 400ms; font-family: &quot;Open Sans&quot;, sans-serif;"></a></p>', 'piece', 27.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boissons';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Maki (SKU 10065)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Maki', '', 'piece', 20.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boissons';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Michiru-Akihiro (SKU 10216)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Michiru-Akihiro', '', 'piece', 64.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Maki pour menus';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'California';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Nigiri pour menu';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Springroll Pour Menu';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Nigiri (SKU 10064)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Nigiri', '', 'piece', 30.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boissons';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Shake (SKU 10214)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Shake', '<p id="isPasted" style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>Menu sp&eacute;cial saumon</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>3 maki saumon</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>3 maki saumon avocat</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>3 california saumon concombre cheese</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>3 california saumon avocat mangue</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>1 nigiri saumon</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>1 nigiri saumon cheese</p><p style=\'caret-color: rgb(51, 51, 51); color: rgb(51, 51, 51); font-family: "Open Sans", sans-serif;\'>1 nigiri saumon grill&eacute;</p><p><a style="color: rgb(235, 73, 71); transition: color 400ms, background-color 400ms; font-family: &quot;Open Sans&quot;, sans-serif;"></a></p>', 'piece', 25.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boissons';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Shimamoto-san (SKU 10218)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Shimamoto-san', '', 'piece', 119.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Maki pour menus';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'California';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Nigiri pour menu';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Springroll Pour Menu';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Tokyo (SKU 10011)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Tokyo', '', 'piece', 59.90, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Maki pour menus';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'California';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Nigiri pour menu';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Sashimi';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Option menu tokyo';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Végétarien (SKU 10067)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Végétarien', '', 'piece', 20.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boissons';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Menu Végétarien Ii (SKU 10070)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Menu Végétarien Ii', '', 'piece', 22.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Menus';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Choix Menu vegetarien II';
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Boissons';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri anguille grillée (SKU 10114)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri anguille grillée', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri avocat (SKU 10115)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri avocat', '', 'piece', 6.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri chamallow (SKU 10083)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri chamallow', '', 'piece', 6.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Desserts';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri crevette (SKU 10113)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri crevette', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri foie gras (SKU 10118)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri foie gras', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri mangue (SKU 10084)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri mangue', '', 'piece', 6.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Desserts';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri mozzarella (SKU 10116)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri mozzarella', '', 'piece', 6.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri omelette japonaise (SKU 10117)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri omelette japonaise', '', 'piece', 6.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri Saumon (SKU 10057)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri Saumon', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri saumon cheese (SKU 10062)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri saumon cheese', '', 'piece', 8.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri saumon grillé (SKU 10060)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri saumon grillé', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri thon (SKU 10063)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri thon', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiri thon grillé (SKU 10112)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiri thon grillé', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Nigiri';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Nigiris (20 pièces9 (SKU 10178)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Nigiris (20 pièces9', '', 'piece', 52.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Onion roll poulet mangue poivron (SKU 10159)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Onion roll poulet mangue poivron', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Originaux';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Onionroll poulet avocat poivron (SKU 10104)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Onionroll poulet avocat poivron', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Originaux';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Onionroll poulet mangue moutarde de Bénichon (SKU 10211)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Onionroll poulet mangue moutarde de Bénichon', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Originaux';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Pas de baguette (SKU 10162)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Pas de baguette', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Pourboire (SKU 10153)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Pourboire', '', 'piece', 0.00, 0.00, 0, 0, 1, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Divers';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Pourboire (SKU 10154)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Pourboire', '', 'piece', 0.00, 0.00, 0, 0, 1, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Divers';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Pourboire (SKU 10155)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Pourboire', '', 'piece', 0.00, 0.00, 0, 0, 1, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'livraison';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Ramune (SKU 10055)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Ramune', '', 'piece', 4.50, 0.00, -37, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Boissons';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Rien (SKU 10161)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Rien', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Riz California (SKU 10209)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Riz California', '', 'kg', 0.00, 0.00, 0, 0, 1, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Ingrédients';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Riz vinaigré (SKU 10082)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Riz vinaigré', '', 'piece', 3.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Accompagnement';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Salade d'algue wakame (SKU 10080)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Salade d\'algue wakame', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Accompagnement';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Salade de chou (SKU 10079)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Salade de chou', '', 'piece', 3.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Accompagnement';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Salade quinoa Edamame (SKU 10400)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Salade quinoa Edamame', '', 'piece', 7.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Accompagnement';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Sashimi 6 pieces saumon thon (SKU 10301)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sashimi 6 pieces saumon thon', '', 'piece', 11.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Sashimi';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Sashimi saumon (10pc) (SKU 10002)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sashimi saumon (10pc)', '', 'piece', 16.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Sashimi';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Sashimi saumon 6 pieces (SKU 10300)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sashimi saumon 6 pieces', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Sashimi';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Sashimi saumon thon (5/5pc) (SKU 10003)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sashimi saumon thon (5/5pc)', '', 'piece', 18.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Sashimi';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Sauce soja salé (SKU 10000)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sauce soja salé', '', 'piece', 0.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Suppléments';
SET @art_id = LAST_INSERT_ID();
SET @opt_name = NULL;

-- Sauce soja sucré (SKU 10053)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sauce soja sucré', '', 'piece', 1.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Suppléments';
SET @art_id = LAST_INSERT_ID();
SET @opt_name = NULL;

-- Sauce spicy (SKU 10094)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sauce spicy', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Soja salé (SKU 10147)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Soja salé', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Soja sucré (SKU 10148)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Soja sucré', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Soupe miso (SKU 10081)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Soupe miso', '', 'piece', 6.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Accompagnement';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Springroll (30 pièces) (SKU 10179)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Springroll (30 pièces)', '', 'piece', 1.60, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Springroll concombre avocat cheese (SKU 10100)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Springroll concombre avocat cheese', '', 'piece', 10.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Springroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Springroll crevette concombre menthe (SKU 10098)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Springroll crevette concombre menthe', '', 'piece', 10.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Springroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Springroll poulet mangue poivron (SKU 10099)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Springroll poulet mangue poivron', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Springroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Springroll saumon avocat ciboulette (SKU 10158)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Springroll saumon avocat ciboulette', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Springroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Springroll Saumon cheese aneth (SKU 10072)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Springroll Saumon cheese aneth', '', 'piece', 10.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Springroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Springroll saumon cheese aneth (SKU 10095)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Springroll saumon cheese aneth', '', 'piece', 10.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Springroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Springroll thon avocat coriandre (SKU 10096)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Springroll thon avocat coriandre', '', 'piece', 11.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Springroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Springroll thon spicy ciboulette (SKU 10097)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Springroll thon spicy ciboulette', '', 'piece', 11.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Springroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Supplément foie gras (SKU 10182)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Supplément foie gras', '', 'piece', 1.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Accompagnement';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Supplément maki fois gras (SKU 10181)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Supplément maki fois gras', '', 'piece', 1.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Accompagnement';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Suppléments standarts (SKU 10163)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Suppléments standarts', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
SET @opt_name = NULL;

-- Sushiwich (SKU 10137)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sushiwich', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_modificateurs (article_id, modificateur_id) SELECT @art_id, m.id FROM pos_modificateurs m WHERE m.utilisateur_id = @uid AND m.nom_modificateur = 'Sushiwich';
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Sushiwich poulet (SKU 10127)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sushiwich poulet', '', 'piece', 11.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'type';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'standard', @opt_name, 11.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'étudiant', @opt_name, 9.00, 0, 1);

-- Sushiwich saumon (SKU 10129)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sushiwich saumon', '', 'piece', 12.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'type';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'normal', @opt_name, 12.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'étudiant', @opt_name, 10.00, 0, 1);

-- Sushiwich thon (SKU 10125)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sushiwich thon', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'type';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'normal', @opt_name, 10.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'étudiant', @opt_name, 9.00, 0, 1);

-- Sushiwich végétarien (SKU 10141)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Sushiwich végétarien', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Lunchbox';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = 'type';
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'standard', @opt_name, 10.00, 0, 1);
INSERT INTO pos_variantes (article_id, nom, option_name, prix, stock, is_active) VALUES (@art_id, 'étudiant', @opt_name, 8.00, 0, 1);

-- Tartare saumon avocat aneth (SKU 10073)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Tartare saumon avocat aneth', '', 'piece', 19.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Tartare';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- tartare saumon avocat aneth Sans Riz (SKU 10135)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'tartare saumon avocat aneth Sans Riz', '', 'piece', 15.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Tartare';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- tartare thon saumon (SKU 10134)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'tartare thon saumon', '', 'piece', 21.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Tartare';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Thé froid (SKU 10059)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Thé froid', '', 'piece', 3.20, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Boissons';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Thon cuit mayo ciboulette (SKU 10171)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Thon cuit mayo ciboulette', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Springroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Wasabi (SKU 10054)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Wasabi', '', 'piece', 0.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Suppléments';
SET @art_id = LAST_INSERT_ID();
SET @opt_name = NULL;

-- Wasabi (SKU 10150)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Wasabi', '', 'piece', 0.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Supplements gratuits';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll crevette concombre (SKU 10040)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll crevette concombre', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll crevette concombre menthe (SKU 10041)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll crevette concombre menthe', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Whiteroll crevette concombre menthe (SKU 10103)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Whiteroll crevette concombre menthe', '', 'piece', 8.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Originaux';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll foie gras (SKU 10042)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll foie gras', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll poulet mangue menthe (SKU 10044)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll poulet mangue menthe', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll Poulet mangue poivron (SKU 10043)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll Poulet mangue poivron', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll saumon avocat (SKU 10045)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll saumon avocat', '', 'piece', 8.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll saumon avocat aneth (SKU 10046)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll saumon avocat aneth', '', 'piece', 8.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Whiteroll saumon avocat aneth (SKU 10101)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Whiteroll saumon avocat aneth', '', 'piece', 8.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Originaux';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll Surimi concombre mayonnaise (SKU 10047)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll Surimi concombre mayonnaise', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll thon avocat (SKU 10048)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll thon avocat', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll thon avocat coriandre (SKU 10049)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll thon avocat coriandre', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- Whiteroll thon avocat coriandre (SKU 10102)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'Whiteroll thon avocat coriandre', '', 'piece', 10.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'Originaux';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll thon cuit mayonnaise (SKU 10050)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll thon cuit mayonnaise', '', 'piece', 9.50, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll thon spicy (SKU 10051)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll thon spicy', '', 'piece', 9.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;

-- whiteroll tofu au basilic (SKU 10052)
INSERT INTO pos_articles (utilisateur_id, id_categorie, nom_article, description, vendu_type, prix_unitaire, cout_unitaire, stock, stock_alerte, is_variable_price, code_barre, actif) SELECT @uid, c.id, 'whiteroll tofu au basilic', '', 'piece', 8.00, 0.00, 0, 0, 0, '', 1 FROM pos_categories c WHERE c.utilisateur_id = @uid AND c.nom_categorie = 'whiteroll';
SET @art_id = LAST_INSERT_ID();
INSERT IGNORE INTO pos_article_taxes (article_id, taxe_id, date_debut, est_actuelle) SELECT @art_id, t.id, CURDATE(), 1 FROM pos_taxes t WHERE t.utilisateur_id = @uid AND t.nom = 'Alimentaire';
SET @opt_name = NULL;