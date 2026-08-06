-- ============================================================
-- INSERTION DES MODIFICATEURS ET OPTIONS POUR UTILISATEUR 6
-- ============================================================

-- ============================================================
-- 1. MENU TOKYO
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu Tokyo', 0, 'Menu complet avec makis, californias, nigiris et sashimi');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Version classique saumon thon crevette', @mod_id, 0, ''),
(6, 'Maki saumon', @mod_id, 0, ''),
(6, 'Maki saumon avocat', @mod_id, 0, ''),
(6, 'Maki saumon cheese', @mod_id, 0, ''),
(6, 'Maki thon', @mod_id, 0, ''),
(6, 'Maki thon avocat', @mod_id, 0, ''),
(6, 'Maki thon cuit mayo ciboulette', @mod_id, 0, ''),
(6, 'Maki surimi mayo', @mod_id, 0, ''),
(6, 'Maki crevette concombre', @mod_id, 0, ''),
(6, 'Maki crevette concombre menthe', @mod_id, 0, ''),
(6, 'Maki concombre cheese', @mod_id, 0, ''),
(6, 'Maki concombre avocat', @mod_id, 0, ''),
(6, 'Maki concombre avocat cheese', @mod_id, 0, ''),
(6, 'Maki avocat', @mod_id, 0, ''),
(6, 'Maki tofu basilic', @mod_id, 0, ''),
(6, 'Maki tofu basilic figue', @mod_id, 0, ''),
(6, 'Maki foie gras confit d\'oignon', @mod_id, 0, ''),
(6, 'Maki poulet mangue poivron', @mod_id, 0, ''),
(6, 'California saumon avocat', @mod_id, 0, ''),
(6, 'California saumon concombre cheese', @mod_id, 0, ''),
(6, 'California thon avocat', @mod_id, 0, ''),
(6, 'California thon avocat mangue', @mod_id, 0, ''),
(6, 'California thon spicy', @mod_id, 0, ''),
(6, 'California thon mayonnaise', @mod_id, 0, ''),
(6, 'California surimi concombre mayo', @mod_id, 0, ''),
(6, 'California crevette concombre', @mod_id, 0, ''),
(6, 'California crevette spicy mangue', @mod_id, 0, ''),
(6, 'California concombre cheese', @mod_id, 0, ''),
(6, 'California concombre avocat', @mod_id, 0, ''),
(6, 'California concombre avocat cheese', @mod_id, 0, ''),
(6, 'California Tofu basilic', @mod_id, 0, ''),
(6, 'California tofu basilic figue', @mod_id, 0, ''),
(6, 'California poulet mangue menthe', @mod_id, 0, ''),
(6, 'California poulet avocat poivron', @mod_id, 0, ''),
(6, 'California Foie gras', @mod_id, 0, ''),
(6, 'Nigiri saumon', @mod_id, 0, ''),
(6, 'Nigiri saumon grillé', @mod_id, 0, ''),
(6, 'Nigiri Saumon cheese', @mod_id, 0, ''),
(6, 'Nigiri thon', @mod_id, 0, ''),
(6, 'Nigiri thon grillé', @mod_id, 0, ''),
(6, 'Nigiri crevette', @mod_id, 0, ''),
(6, 'Nigiri avocat', @mod_id, 0, ''),
(6, 'Nigiri omelette', @mod_id, 0, ''),
(6, 'Nigiri mozzarella', @mod_id, 0, ''),
(6, 'Nigiri Foie gras', @mod_id, 0, ''),
(6, 'Sashimi saumon', @mod_id, 0, ''),
(6, 'Sashimi Saumon/thon', @mod_id, 0, '');

-- ============================================================
-- 2. MENU EMPEREUR
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu Empereur', 0, 'Menu premium avec sélection élargie');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Version classique saumon thon crevette', @mod_id, 0, ''),
(6, 'Maki saumon', @mod_id, 0, ''),
(6, 'Maki saumon avocat', @mod_id, 0, ''),
(6, 'Maki saumon cheese', @mod_id, 0, ''),
(6, 'Maki thon', @mod_id, 0, ''),
(6, 'Maki thon avocat', @mod_id, 0, ''),
(6, 'Maki thon cuit mayonnaise ciboulette', @mod_id, 0, ''),
(6, 'Maki surimi mayonnaise', @mod_id, 0, ''),
(6, 'Maki crevette concombre', @mod_id, 0, ''),
(6, 'Maki crevette concombre menthe', @mod_id, 0, ''),
(6, 'Maki concombre cheese', @mod_id, 0, ''),
(6, 'Maki concombre avocat', @mod_id, 0, ''),
(6, 'Maki concombre avocat cheese', @mod_id, 0, ''),
(6, 'Maki avocat', @mod_id, 0, ''),
(6, 'Maki Tofu au basilic', @mod_id, 0, ''),
(6, 'Maki Tofu au basilic confiture de figue', @mod_id, 0, ''),
(6, 'Maki poulet mangue poivron', @mod_id, 0, ''),
(6, 'California saumon avocat', @mod_id, 0, ''),
(6, 'California Saumon concombre cheese', @mod_id, 0, ''),
(6, 'California thon spicy', @mod_id, 0, ''),
(6, 'California thon avocat', @mod_id, 0, ''),
(6, 'California thon avocat mangue', @mod_id, 0, ''),
(6, 'California thon cuit ciboulette', @mod_id, 0, ''),
(6, 'California surimi concombre mayonnaise', @mod_id, 0, ''),
(6, 'California crevette concombre', @mod_id, 0, ''),
(6, 'California crevette spicy mangue', @mod_id, 0, ''),
(6, 'California concombre cheese', @mod_id, 0, ''),
(6, 'California concombre avocat', @mod_id, 0, ''),
(6, 'California concombre avocat cheese', @mod_id, 0, ''),
(6, 'California Tofu au basilic', @mod_id, 0, ''),
(6, 'California Tofu au basilic figue', @mod_id, 0, ''),
(6, 'California poulet mangue menthe', @mod_id, 0, ''),
(6, 'California poulet avocat poivron', @mod_id, 0, ''),
(6, 'Nigiri Saumon', @mod_id, 0, ''),
(6, 'Nigiri saumon cheese', @mod_id, 0, ''),
(6, 'Nigiri saumon grillé', @mod_id, 0, ''),
(6, 'Nigiri thon', @mod_id, 0, ''),
(6, 'Nigiri thon grillé', @mod_id, 0, ''),
(6, 'Nigiri crevette', @mod_id, 0, ''),
(6, 'Nigiri avocat', @mod_id, 0, ''),
(6, 'Nigiri mozzarella', @mod_id, 0, ''),
(6, 'Nigiri omelette japonaise', @mod_id, 0, ''),
(6, 'Sashimi saumon', @mod_id, 0, ''),
(6, 'Sashimi saumon/thon', @mod_id, 0, '');

-- ============================================================
-- 3. MENU KOBE
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu Kobe', 0, 'Menu classique avec sélection équilibrée');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Version classique saumon thon crevette', @mod_id, 0, ''),
(6, 'Maki saumon', @mod_id, 0, ''),
(6, 'Maki saumon avocat', @mod_id, 0, ''),
(6, 'Maki saumon cheese', @mod_id, 0, ''),
(6, 'Maki thon', @mod_id, 0, ''),
(6, 'Maki thon avocat', @mod_id, 0, ''),
(6, 'Maki thon cuit mayonnaise', @mod_id, 0, ''),
(6, 'Maki surimi mayonnaise', @mod_id, 0, ''),
(6, 'Maki crevette', @mod_id, 0, ''),
(6, 'Maki crevette concombre', @mod_id, 0, ''),
(6, 'Maki crevette concombre menthe', @mod_id, 0, ''),
(6, 'Maki concombre cheese', @mod_id, 0, ''),
(6, 'Maki concombre avocat', @mod_id, 0, ''),
(6, 'Maki concombre avocat cheese', @mod_id, 0, ''),
(6, 'Maki avocat', @mod_id, 0, ''),
(6, 'Maki tofu au basilic', @mod_id, 0, ''),
(6, 'Maki Tofu au basilic confiture de figue', @mod_id, 0, ''),
(6, 'Maki poulet mangue poivron', @mod_id, 0, ''),
(6, 'California saumon avocat', @mod_id, 0, ''),
(6, 'California saumon concombre cheese', @mod_id, 0, ''),
(6, 'California thon spicy', @mod_id, 0, ''),
(6, 'California thon avocat', @mod_id, 0, ''),
(6, 'California thon avocat mangue', @mod_id, 0, ''),
(6, 'California thon cuit ciboulette', @mod_id, 0, ''),
(6, 'California surimi concombre mayonnaise', @mod_id, 0, ''),
(6, 'California crevette concombre', @mod_id, 0, ''),
(6, 'California crevette concombre menthe', @mod_id, 0, ''),
(6, 'California concombre cheese', @mod_id, 0, ''),
(6, 'California concombre avocat', @mod_id, 0, ''),
(6, 'California concombre avocat cheese', @mod_id, 0, ''),
(6, 'California tofu basilic confiture figue', @mod_id, 0, ''),
(6, 'California poulet mangue menthe', @mod_id, 0, ''),
(6, 'California poulet avocat poivron', @mod_id, 0, ''),
(6, 'Nigiri saumon', @mod_id, 0, ''),
(6, 'Nigiri saumon cheese', @mod_id, 0, ''),
(6, 'Nigiri saumon grillé', @mod_id, 0, ''),
(6, 'Nigiri thon', @mod_id, 0, ''),
(6, 'Nigiri thon grillé', @mod_id, 0, ''),
(6, 'Nigiri avocat', @mod_id, 0, ''),
(6, 'Nigiri mozzarella', @mod_id, 0, ''),
(6, 'Nigiri omelette japonaise', @mod_id, 0, ''),
(6, 'Nigiri crevette', @mod_id, 0, ''),
(6, 'Sashimi saumon', @mod_id, 0, ''),
(6, 'Sashimi saumon thon', @mod_id, 0, '');

-- ============================================================
-- 4. MENU MAKI
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu Maki', 0, 'Choix de boissons pour le menu Maki');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Mangajo Grenade', @mod_id, 0, ''),
(6, 'Mangajo Baie de Goji', @mod_id, 0, ''),
(6, 'Mangajo Citron', @mod_id, 0, ''),
(6, 'Coca', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, ''),
(6, 'Coca Zéro', @mod_id, 0, ''),
(6, 'Thé froid', @mod_id, 0, ''),
(6, 'Bière Ichiban', @mod_id, 0, ''),
(6, 'Henniez plate', @mod_id, 0, ''),
(6, 'Henniez gazeuse', @mod_id, 0, '');

-- ============================================================
-- 5. MENU KYOTO
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu Kyoto', 0, 'Boissons pour menu Kyoto');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Bière', @mod_id, 0, ''),
(6, 'Henniez plate', @mod_id, 0, ''),
(6, 'Henniez gazeuse', @mod_id, 0, ''),
(6, 'Coca cola', @mod_id, 0, ''),
(6, 'Coca zero', @mod_id, 0, ''),
(6, 'Mangajo citron', @mod_id, 0, ''),
(6, 'Mangajo baie de goji', @mod_id, 0, ''),
(6, 'Mangajo grenade', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, ''),
(6, 'Thé froid', @mod_id, 0, '');

-- ============================================================
-- 6. MENU NIGIRI
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu Nigiri', 0, 'Boissons pour menu Nigiri');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Bière', @mod_id, 0, ''),
(6, 'Coca cola', @mod_id, 0, ''),
(6, 'Coca zero', @mod_id, 0, ''),
(6, 'Mangajo baie de goji', @mod_id, 0, ''),
(6, 'Mangajo citron', @mod_id, 0, ''),
(6, 'Mangajo grenade', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, ''),
(6, 'Thé froid', @mod_id, 0, ''),
(6, 'Henniez plate', @mod_id, 0, ''),
(6, 'Henniez gazeuse', @mod_id, 0, '');

-- ============================================================
-- 7. MENU VÉGÉTARIEN I
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu végétarien I', 0, 'Boissons pour menu végétarien I');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Bière', @mod_id, 0, ''),
(6, 'Coca cola', @mod_id, 0, ''),
(6, 'Coca zero', @mod_id, 0, ''),
(6, 'Mangajo baie de goji', @mod_id, 0, ''),
(6, 'Mangajo grenade', @mod_id, 0, ''),
(6, 'Mangajo citron', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, ''),
(6, 'Thé froid', @mod_id, 0, ''),
(6, 'Henniez plate', @mod_id, 0, ''),
(6, 'Henniez gazeuse', @mod_id, 0, '');

-- ============================================================
-- 8. MENU BEST OF
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu Best of', 0, 'Boissons pour menu Best of');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Bière', @mod_id, 0, ''),
(6, 'Coca', @mod_id, 0, ''),
(6, 'Coca zéro', @mod_id, 0, ''),
(6, 'Thé froid', @mod_id, 0, ''),
(6, 'Mangajo citron', @mod_id, 0, ''),
(6, 'Mangajo grenade', @mod_id, 0, ''),
(6, 'Mangajo baie de Goji', @mod_id, 0, ''),
(6, 'Henniez plate', @mod_id, 0, ''),
(6, 'Henniez gazeuse', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, '');

-- ============================================================
-- 9. MENU VÉGÉTARIEN II
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu Végétarien II', 0, 'Boissons pour menu végétarien II');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Bière', @mod_id, 0, ''),
(6, 'Coca cola', @mod_id, 0, ''),
(6, 'Coca zero', @mod_id, 0, ''),
(6, 'Mangajo baie de goji', @mod_id, 0, ''),
(6, 'Mangajo citron', @mod_id, 0, ''),
(6, 'Mangajo grenade', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, ''),
(6, 'Thé froid', @mod_id, 0, ''),
(6, 'Henniez plate', @mod_id, 0, ''),
(6, 'Henniez gazeuse', @mod_id, 0, '');

-- ============================================================
-- 10. MENU DUO
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menu Duo', 0, 'Menu pour 2 personnes avec boissons dédoublées');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Bière', @mod_id, 0, ''),
(6, 'Bière 2', @mod_id, 0, ''),
(6, 'Mangajo Citron', @mod_id, 0, ''),
(6, 'Mangajo Citron 2', @mod_id, 0, ''),
(6, 'Mangajo grenade', @mod_id, 0, ''),
(6, 'Mangajo grenade 2', @mod_id, 0, ''),
(6, 'Mangajo baie de Goji', @mod_id, 0, ''),
(6, 'Mangajo baie de Goji 2', @mod_id, 0, ''),
(6, 'Coca', @mod_id, 0, ''),
(6, 'Coca 2', @mod_id, 0, ''),
(6, 'Coca zéro', @mod_id, 0, ''),
(6, 'Coca zéro 2', @mod_id, 0, ''),
(6, 'Thé froid', @mod_id, 0, ''),
(6, 'Thé froid 2', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, ''),
(6, 'Ramune 2', @mod_id, 0, ''),
(6, 'Henniez gazeuse', @mod_id, 0, ''),
(6, 'Henniez gazeuse 2', @mod_id, 0, ''),
(6, 'Henniez plate', @mod_id, 0, ''),
(6, 'Henniez plate 2', @mod_id, 0, '');

-- ============================================================
-- 11. GYOZAS
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Gyozas', 0, 'Choix de gyozas et accompagnements');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Par 9 crevette', @mod_id, 0, ''),
(6, 'Par 9 poulet', @mod_id, 0, ''),
(6, 'Par 9 végétarien', @mod_id, 0, ''),
(6, 'Par 9, 3 de chaque', @mod_id, 0, ''),
(6, 'Par 12 crevette', @mod_id, 0, ''),
(6, 'Par 12 poulet', @mod_id, 0, ''),
(6, 'Par 12 végétarien', @mod_id, 0, ''),
(6, 'Par 12, 4 de chaque', @mod_id, 0, ''),
(6, 'Par 15 crevette', @mod_id, 0, ''),
(6, 'Par 15 poulet', @mod_id, 0, ''),
(6, 'Par 15 végétarien', @mod_id, 0, ''),
(6, 'Par 15, 5 de chaque', @mod_id, 0, ''),
(6, 'Bol de riz', @mod_id, 0, ''),
(6, 'Salade de chou', @mod_id, 0, ''),
(6, 'Soupe miso', @mod_id, 0, '');

-- ============================================================
-- 12. MANGAJO
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Mangajo', 0, 'Parfums de Mangajo');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Baie de Goji', @mod_id, 0, ''),
(6, 'Grenade', @mod_id, 0, ''),
(6, 'Citron', @mod_id, 0, ''),
(6, 'Baie d\'Açaï', @mod_id, 0, '');

-- ============================================================
-- 13. COCA
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Coca', 0, 'Type de Coca');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Normal', @mod_id, 0, ''),
(6, 'Zero', @mod_id, 0, '');

-- ============================================================
-- 14. HENNIEZ
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Henniez', 0, 'Eau Henniez plate ou gazeuse');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Plate', @mod_id, 0, ''),
(6, 'Gazeuse', @mod_id, 0, '');

-- ============================================================
-- 15. SUSHIWICH
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Sushiwich', 0, 'Variantes de Sushiwich');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Végétarien étudiant', @mod_id, 0, ''),
(6, 'Végétarien standard', @mod_id, 0, ''),
(6, 'Poulet étudiant', @mod_id, 0, ''),
(6, 'Poulet standard', @mod_id, 0, ''),
(6, 'Thon cuit étudiant', @mod_id, 0, ''),
(6, 'Thon cuit standard', @mod_id, 0, ''),
(6, 'Saumon étudiant', @mod_id, 0, ''),
(6, 'Saumon standard', @mod_id, 0, '');

-- ============================================================
-- 16. LUNCHOX MAKI
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Lunchox maki', 0, 'Variantes de Lunchox maki');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Végétarien étudiant', @mod_id, 0, ''),
(6, 'Végétarien standard', @mod_id, 0, ''),
(6, 'Saumon thon étudiant', @mod_id, 0, ''),
(6, 'Saumon thon standard', @mod_id, 0, '');

-- ============================================================
-- 17. LUNCHOX GYOZA
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Lunchox gyoza', 0, 'Variantes de Lunchox gyoza');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Végétarien étudiant', @mod_id, 0, ''),
(6, 'Végétarien standard', @mod_id, 0, ''),
(6, 'Poulet/crevette étudiant', @mod_id, 0, ''),
(6, 'Poulet/crevette standard', @mod_id, 0, '');

-- ============================================================
-- 18. CIBOULETTE
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Ciboulette', 0, 'Ajout de ciboulette');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Avec ciboulette', @mod_id, 0, ''),
(6, 'Non', @mod_id, 0, '');

-- ============================================================
-- 19. SAINT VALENTIN
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Saint Valentin', 0, 'Boissons pour menu Saint Valentin');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Bière', @mod_id, 0, ''),
(6, 'Mangajo citron', @mod_id, 0, ''),
(6, 'Mangajo baie de goji', @mod_id, 0, ''),
(6, 'Mangajo Grenade', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, '');

-- ============================================================
-- 20. MENTHE
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Menthe', 0, 'Ajout de menthe');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Avec menthe', @mod_id, 0, ''),
(6, 'Sans Menthe', @mod_id, 0, '');

-- ============================================================
-- 21. CONFITURE DE FIGUE
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Confiture de figue', 0, 'Ajout confiture de figue');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Confiture de figue', @mod_id, 0, '');

-- ============================================================
-- 22. RAVIOLI
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Ravioli', 0, 'Parfums de ravioli');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Végétarien', @mod_id, 0, ''),
(6, 'Poulet', @mod_id, 0, ''),
(6, 'Crevette', @mod_id, 0, ''),
(6, 'Canard', @mod_id, 0, '');

-- ============================================================
-- 23. ACCOMPAGNEMENT RAVIOLI
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Accompagnement ravioli', 0, 'Accompagnement des raviolis');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Salade de chou', @mod_id, 0, ''),
(6, 'Soupe Miso', @mod_id, 0, ''),
(6, 'Bol de riz', @mod_id, 0, '');

-- ============================================================
-- 24. CHOIX MENU VÉGÉTARIEN II
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Choix Menu végétarien II', 0, 'Entrée au choix');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Springroll', @mod_id, 0, ''),
(6, 'California', @mod_id, 0, '');

-- ============================================================
-- 25. MAKI POUR MENUS
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Maki pour menus', 0, 'Choix de maki dans les menus');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Maki saumon', @mod_id, 0, ''),
(6, 'Maki saumon avocat', @mod_id, 0, ''),
(6, 'Maki saumon cheese', @mod_id, 0, ''),
(6, 'Maki thon', @mod_id, 0, ''),
(6, 'Maki thon avocat', @mod_id, 0, ''),
(6, 'Maki crevette', @mod_id, 0, ''),
(6, 'Maki crevette concombre', @mod_id, 0, ''),
(6, 'Maki crevette concombre menthe', @mod_id, 0, ''),
(6, 'Maki crevette avocat', @mod_id, 0, ''),
(6, 'Maki avocat', @mod_id, 0, ''),
(6, 'Maki concombre', @mod_id, 0, ''),
(6, 'Maki concombre avocat', @mod_id, 0, ''),
(6, 'Maki concombre cheese', @mod_id, 0, ''),
(6, 'Maki concombre avocat cheese', @mod_id, 0, ''),
(6, 'Maki avocat cheese', @mod_id, 0, ''),
(6, 'Maki poulet mangue poivron', @mod_id, 0, ''),
(6, 'Maki poulet Moutarde de Bénichon', @mod_id, 0, ''),
(6, 'Maki foie gras confit d\'oignons', @mod_id, 0, ''),
(6, 'Maki anguille grillée mangue', @mod_id, 0, ''),
(6, 'Maki thon cuit mayo', @mod_id, 0, ''),
(6, 'Maki thon cuit mayo ciboulette', @mod_id, 0, ''),
(6, 'Maki thon cuit mayo avocat', @mod_id, 0, ''),
(6, 'Maki thon cuit mayo avocat ciboulettes', @mod_id, 0, ''),
(6, 'Maki surimi', @mod_id, 0, ''),
(6, 'Maki Surimi avocat', @mod_id, 0, ''),
(6, 'Maki foie gras Confis d\'oignons', @mod_id, 0, ''),
(6, 'Maki anguille grillé mangue', @mod_id, 0, '');

-- ============================================================
-- 26. CALIFORNIA
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'California', 0, 'Choix de California rolls');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'California saumon avocat', @mod_id, 0, ''),
(6, 'California saumon concombre cheese', @mod_id, 0, ''),
(6, 'California saumon avocat cheese', @mod_id, 0, ''),
(6, 'California thon spicy', @mod_id, 0, ''),
(6, 'California thon avocat', @mod_id, 0, ''),
(6, 'California thon avocat mangue', @mod_id, 0, ''),
(6, 'California crevette concombre', @mod_id, 0, ''),
(6, 'California crevette concombre menthe', @mod_id, 0, ''),
(6, 'California crevette spicy mangue', @mod_id, 0, ''),
(6, 'California crevette avocat', @mod_id, 0, ''),
(6, 'California poulet mangue menthe', @mod_id, 0, ''),
(6, 'California poulet mangue poivron', @mod_id, 0, ''),
(6, 'California poulet avocat poivron', @mod_id, 0, ''),
(6, 'California surimi concombre mayonnaise', @mod_id, 0, ''),
(6, 'California surimi avocat mayonnaise', @mod_id, 0, ''),
(6, 'California avocat', @mod_id, 0, ''),
(6, 'California avocat cheese', @mod_id, 0, ''),
(6, 'California concombre', @mod_id, 0, ''),
(6, 'California concombre avocat', @mod_id, 0, ''),
(6, 'California concombre avocat cheese', @mod_id, 0, ''),
(6, 'California thon cuit mayonnaise', @mod_id, 0, ''),
(6, 'California thon cuit mayo ciboulette', @mod_id, 0, ''),
(6, 'California thon cuit avocat ciboule', @mod_id, 0, ''),
(6, 'California foie gras', @mod_id, 0, ''),
(6, 'California Poulet Moutarde de Bénichon', @mod_id, 0, ''),
(6, 'California Mangue Poulet Moutarde Bénichon', @mod_id, 0, '');

-- ============================================================
-- 27. NIGIRI POUR MENU
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Nigiri pour menu', 0, 'Choix de nigiri dans les menus');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Nigiri saumon', @mod_id, 0, ''),
(6, 'Nigiri saumon cheese', @mod_id, 0, ''),
(6, 'Nigiri saumon grillée', @mod_id, 0, ''),
(6, 'Nigiri thon', @mod_id, 0, ''),
(6, 'Nigiri thon grillé', @mod_id, 0, ''),
(6, 'Nigiri crevette', @mod_id, 0, ''),
(6, 'Nigiri avocat', @mod_id, 0, ''),
(6, 'Nigiri omelette japonaise', @mod_id, 0, ''),
(6, 'Nigiri Anguille grillée', @mod_id, 0, ''),
(6, 'Nigiri foie gras', @mod_id, 0, '');

-- ============================================================
-- 28. SASHIMI
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Sashimi', 0, 'Choix de sashimi');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Sashimi saumon', @mod_id, 0, ''),
(6, 'Sashimi saumon thon', @mod_id, 0, '');

-- ============================================================
-- 29. OPTION MENU TOKYO
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Option menu tokyo', 0, 'Option pour menu Tokyo');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Version classique', @mod_id, 0, '');

-- ============================================================
-- 30. BOISSONS
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Boissons', 0, 'Choix de boisson');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Mangajo Citron', @mod_id, 0, ''),
(6, 'Mangajo Grenade', @mod_id, 0, ''),
(6, 'Mangajo Baie de Goji', @mod_id, 0, ''),
(6, 'Mangajo Baie d\'Açaï', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, ''),
(6, 'Ramune Lychee', @mod_id, 0, ''),
(6, 'Bière', @mod_id, 0, ''),
(6, 'Coca', @mod_id, 0, ''),
(6, 'Coca zéro', @mod_id, 0, ''),
(6, 'Ice Tea', @mod_id, 0, ''),
(6, 'Henniez plate', @mod_id, 0, ''),
(6, 'Henniez gazeuse', @mod_id, 0, '');

-- ============================================================
-- 31. BOISSON 2
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Boisson 2', 0, 'Deuxième boisson du menu');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Mangajo Citron', @mod_id, 0, ''),
(6, 'Mangajo Grenade', @mod_id, 0, ''),
(6, 'Mangajo Baie de Goji', @mod_id, 0, ''),
(6, 'Mangajo Baie d\'Açaï', @mod_id, 0, ''),
(6, 'Ramune', @mod_id, 0, ''),
(6, 'Ramune Lychee', @mod_id, 0, ''),
(6, 'Bière', @mod_id, 0, ''),
(6, 'Coca', @mod_id, 0, ''),
(6, 'Coca zéro', @mod_id, 0, ''),
(6, 'Ice Tea Citron', @mod_id, 0, ''),
(6, 'Henniez plate', @mod_id, 0, ''),
(6, 'Henniez gazeuse', @mod_id, 0, '');

-- ============================================================
-- 32. FORMULE
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Formule', 0, 'Formules de prix');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Formule Taika [20 - 30 CHF]', @mod_id, 0, ''),
(6, 'Formule Hakuchi [30 - 40 CHF]', @mod_id, 0, ''),
(6, 'Formule Shuchō [40 - 50 CHF]', @mod_id, 0, '');

-- ============================================================
-- 33. DESSERT
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Dessert', 0, 'Makis sucrés pour dessert');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Maki Banane nutella', @mod_id, 0, ''),
(6, 'Maki Banane spéculos', @mod_id, 0, ''),
(6, 'Maki Mangue spéculos', @mod_id, 0, ''),
(6, 'Maki poire nutella choco', @mod_id, 0, '');

-- ============================================================
-- 34. RAMUNE
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Ramune', 0, 'Parfums de Ramune');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Standard', @mod_id, 0, ''),
(6, 'Lychee', @mod_id, 0, '');

-- ============================================================
-- 35. SPRINGROLL POUR MENU
-- ============================================================
INSERT INTO pos_modificateurs (utilisateur_id, nom_modificateur, prix_modificateur, description)
VALUES (6, 'Springroll Pour Menu', 0, 'Parfums de springrolls dans les menus');
SET @mod_id = LAST_INSERT_ID();
INSERT INTO pos_options_modificateurs (utilisateur_id, nom_option, id_modificateur, prix_supplement, description) VALUES
(6, 'Concombre avocat cheese', @mod_id, 0, ''),
(6, 'Crevette concombre menthe', @mod_id, 0, ''),
(6, 'Poulet mangue poivron', @mod_id, 0, ''),
(6, 'Saumon avocat ciboulette', @mod_id, 0, ''),
(6, 'Saumon cheese aneth', @mod_id, 0, ''),
(6, 'Thon spicy ciboulette', @mod_id, 0, ''),
(6, 'Thon avocat coriandre', @mod_id, 0, '');

-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
-- Total : 35 modificateurs avec leurs options
-- Pour vérifier :
-- SELECT m.nom_modificateur, COUNT(o.id) as nb_options 
-- FROM pos_modificateurs m 
-- LEFT JOIN pos_options_modificateurs o ON o.id_modificateur = m.id 
-- WHERE m.utilisateur_id = 6 
-- GROUP BY m.id, m.nom_modificateur 
-- ORDER BY m.nom_modificateur;