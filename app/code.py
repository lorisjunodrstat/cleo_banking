
class DatabaseManager:
    """
    Gère la connexion à la base de données en utilisant un pool de connexions
    pour une gestion plus robuste et performante, avec la bibliothèque pymysql.
    """
    def __init__(self, db_config):
        self.db_config = db_config
        self._connection_pool = None


    def _get_connection_pool(self):
        """Initialise et retourne le pool de connexions avec DBUtils."""
        if self._connection_pool is None:
            logger.info("Initialisation du pool de connexions avec DBUtils...")
            try:
                self._connection_pool = PooledDB(
                    creator=pymysql,
                    maxconnections=5,
                    mincached=2,
                    maxcached=5,
                    maxshared=0,
                    blocking=True,
                    maxusage=None,
                    setsession=None,
                    reset=True,
                    failures=None,
                    ping=1,
                    **self.db_config
                )
                logger.info("Pool de connexions DBUtils initialisé avec succès.")
            except Error as err:
                logger.error(f"Erreur lors de l'initialisation du pool de connexions : {err}")
                self._connection_pool = None
        return self._connection_pool
    def close_connection(self):
        """
        Ferme le pool de connexions.
        Cette méthode est optionnelle car DBUtils gère normalement la fermeture automatiquement.
        """
        if self._connection_pool is not None:
            self._connection_pool.close()
            self._connection_pool = None
            logger.info("Pool de connexions fermé")
    
    def close(self):
        """Alias pour close_connection pour compatibilité"""
        self.close_connection()
    @contextmanager
    def get_cursor(self, dictionary=False, commit=True):
        """
        Fournit un curseur de base de données depuis le pool.
        Gère automatiquement la connexion et la fermeture des ressources.

        :param dictionary: Si True, retourne un curseur de type dictionnaire
        :param commit: Si True, commit la transaction après l'exécution
        """
        connection = None
        cursor = None
        try:
            pool = self._get_connection_pool()
            if not pool:
                raise RuntimeError("Impossible d'obtenir une connexion à la base de données.")

            # Obtient une connexion du pool
            connection = pool.connection()

            # Crée un curseur (dictionnaire si nécessaire)
            cursor = connection.cursor(pymysql.cursors.DictCursor) if dictionary else connection.cursor()

            yield cursor

            # Commit la transaction après une exécution réussie si commit=True
            if commit:
                connection.commit()
        except Exception as e:
            logger.error(f"Erreur dans le gestionnaire de curseur : {e}", exc_info=True)
            if connection:
                try:
                    connection.rollback()  # Annule les changements en cas d'erreur
                except Exception as rollback_error:
                    logger.error(f"Erreur lors du rollback : {rollback_error}", exc_info=True)
            raise  # Relance l'exception
        finally:
            if cursor:
                try:
                    cursor.close()
                except Exception as close_error:
                    logger.error(f"Erreur lors de la fermeture du curseur : {close_error}", exc_info=True)
            if connection:
                try:
                    connection.close()  # Retourne la connexion au pool
                except Exception as close_error:
                    logger.error(f"Erreur lors de la fermeture de la connexion : {close_error}", exc_info=True)

    def create_tables(self):
        """
        Crée toutes les tables de la base de données si elles n'existent pas.
        """
        logger.info("Vérification et création des tables de la base de données...")
        try:
            # Utilisation du gestionnaire de contexte pour la création des tables.
            with self.get_cursor() as cursor:
                cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")

                # Table utilisateurs
                create_users_table_query = """
                CREATE TABLE IF NOT EXISTS utilisateurs (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    nom VARCHAR(255) NOT NULL,
                    prenom VARCHAR(255) NOT NULL,
                    email VARCHAR(255) NOT NULL UNIQUE,
                    mot_de_passe VARCHAR(255) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                """
                cursor.execute(create_users_table_query)

                # Table PeriodeFavorite
                create_periode_favorite_table_query = """
                CREATE TABLE IF NOT EXISTS periode_favorite (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    user_id INT NOT NULL,
                    compte_id INT NOT NULL,
                    compte_type ENUM('principal','sous_compte') NOT NULL,
                    nom VARCHAR(255) NOT NULL,
                    date_debut DATE NOT NULL,
                    date_fin DATE NOT NULL,
                    statut ENUM('active','inactive') DEFAULT 'active',
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_periode_favorite_table_query)

                # Table banques
                create_banques_table_query = """
                CREATE TABLE IF NOT EXISTS banques (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    nom VARCHAR(255) NOT NULL,
                    code_banque VARCHAR(50) UNIQUE,
                    pays VARCHAR(100) DEFAULT 'Suisse',
                    couleur VARCHAR(7) DEFAULT '#3498db',
                    site_web VARCHAR(255),
                    logo_url VARCHAR(255),
                    actif BOOLEAN DEFAULT TRUE,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                """
                cursor.execute(create_banques_table_query)


                # Table employe
                create_employes_table_query = """
                CREATE TABLE IF NOT EXISTS employes (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    user_id INT NOT NULL,
                    nom VARCHAR(100) NOT NULL,
                    prenom VARCHAR(100) NOT NULL,
                    email VARCHAR(150),
                    telephone VARCHAR(20),
                    rue VARCHAR(255),
                    code_postal VARCHAR(10),
                    commune VARCHAR(100),
                    genre ENUM('M', 'F') NOT NULL,
                    date_de_naissance DATE NOT NULL,
                    code_acces_salaire VARCHAR(50),
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
                );"""
                cursor.execute(create_employes_table_query)
                
                # Tables types_cotisation 
                create_types_cotisation_table_query = """
                CREATE TABLE IF NOT EXISTS types_cotisation (
                id INT PRIMARY KEY AUTO_INCREMENT,
                user_id INT NOT NULL,
                nom VARCHAR(100) NOT NULL,
                description TEXT,
                est_obligatoire BOOLEAN DEFAULT FALSE,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
                );"""
                cursor.execute(create_types_cotisation_table_query)

                # Table contrats
                create_contrats_table_query = """
                CREATE TABLE IF NOT EXISTS contrats (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    user_id INT NOT NULL,
                    heures_hebdo DECIMAL(4,2) NOT NULL,
                    date_debut DATE NOT NULL,
                    date_fin DATE,
                    salaire_horaire DECIMAL(7,2) DEFAULT 24.05,
                    jour_estimation_salaire INT DEFAULT 15,
                    versement_10 BOOLEAN DEFAULT TRUE,
                    versement_25 BOOLEAN DEFAULT TRUE,
                    indemnite_vacances_tx DECIMAL(5,2),
                    indemnite_jours_feries_tx DECIMAL(5,2),
                    indemnite_jour_conges_tx DECIMAL(5,2),
                    indemnite_repas_tx DECIMAL(5,2),
                    indemnite_retenues_tx DECIMAL(5,2),
                    cotisation_avs_tx DECIMAL(5,2),
                    cotisation_ac_tx DECIMAL(5,2),
                    cotisation_accident_n_prof_tx DECIMAL(5,2),
                    cotisation_assurance_indemnite_maladie_tx DECIMAL(5,2),
                    cotisation_cap_tx DECIMAL(5,2),
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_contrats_table_query)
                
                # Table comptes_principaux
                create_comptes_table_query = """
                CREATE TABLE IF NOT EXISTS comptes_principaux (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    utilisateur_id INT NOT NULL,
                    banque_id INT NOT NULL,
                    nom_compte VARCHAR(255) NOT NULL,
                    numero_compte VARCHAR(255),
                    iban VARCHAR(34),
                    bic VARCHAR(11),
                    type_compte ENUM('courant', 'epargne', 'compte_jeune', 'autre') DEFAULT 'courant',
                    solde DECIMAL(15,2) DEFAULT 0.00,
                    devise VARCHAR(3) DEFAULT 'CHF',
                    date_ouverture DATE,
                    actif BOOLEAN DEFAULT TRUE,
                    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id),
                    FOREIGN KEY (banque_id) REFERENCES banques(id)
                );
                """
                cursor.execute(create_comptes_table_query)

                # Table sous_comptes
                create_sous_comptes_table_query = """
                CREATE TABLE IF NOT EXISTS sous_comptes (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    compte_principal_id INT NOT NULL,
                    nom_sous_compte VARCHAR(255) NOT NULL,
                    description TEXT,
                    objectif_montant DECIMAL(15,2),
                    solde DECIMAL(15,2) DEFAULT 0.00,
                    couleur VARCHAR(7) DEFAULT '#28a745',
                    icone VARCHAR(50) DEFAULT 'piggy-bank',
                    date_objectif DATE,
                    actif BOOLEAN DEFAULT TRUE,
                    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (compte_principal_id) REFERENCES comptes_principaux(id)
                );
                """
                cursor.execute(create_sous_comptes_table_query)

                # Table transactions
                create_transactions_table_query = """
                CREATE TABLE IF NOT EXISTS transactions (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    compte_principal_id INT,
                    sous_compte_id INT,
                    compte_source_id INT,
                    sous_compte_source_id INT,
                    compte_destination_id INT,
                    sous_compte_destination_id INT,
                    type_transaction ENUM('depot', 'retrait', 'transfert_entrant', 'transfert_sortant', 'transfert_externe', 'recredit_annulation', 'transfert_compte_vers_sous', 'transfert_sous_vers_compte') NOT NULL,
                    montant DECIMAL(15,2) NOT NULL,
                    description TEXT,
                    reference VARCHAR(100),
                    utilisateur_id INT NOT NULL,
                    date_transaction DATETIME NOT NULL,
                    solde_apres DECIMAL(15,2),
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (compte_principal_id) REFERENCES comptes_principaux(id),
                    FOREIGN KEY (sous_compte_id) REFERENCES sous_comptes(id),
                    FOREIGN KEY (compte_source_id) REFERENCES comptes_principaux(id),
                    FOREIGN KEY (sous_compte_source_id) REFERENCES sous_comptes(id),
                    FOREIGN KEY (compte_destination_id) REFERENCES comptes_principaux(id),
                    FOREIGN KEY (sous_compte_destination_id) REFERENCES sous_comptes(id),
                    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_transactions_table_query)

                # Table categories_transactions
                create_categories_table_query = """
                CREATE TABLE IF NOT EXISTS categories_transactions (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    utilisateur_id INT NOT NULL,
                    nom VARCHAR(100) NOT NULL,
                    description TEXT,
                    type_categorie ENUM('Revenu', 'Dépense', 'Transfert') NOT NULL DEFAULT 'Dépense',
                    couleur VARCHAR(7) DEFAULT '#007bff',
                    icone VARCHAR(50),
                    budget_mensuel DECIMAL(15,2) DEFAULT 0,
                    actif BOOLEAN DEFAULT TRUE,
                    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id),
                    UNIQUE KEY unique_categorie_user (utilisateur_id, nom, type_categorie)
                );
                """
                cursor.execute(create_categories_table_query)

                # table transactions_categories
                create_transactions_categories_table_query = """
                CREATE TABLE IF NOT EXISTS transaction_categories (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    transaction_id INT NOT NULL,
                    categorie_id INT NOT NULL,
                    utilisateur_id INT NOT NULL,
                    date_association TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE,
                    FOREIGN KEY (categorie_id) REFERENCES categories_transactions(id) ON DELETE CASCADE,
                    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id),
                    UNIQUE KEY unique_transaction_categorie (transaction_id, categorie_id)
                );
                """
                cursor.execute(create_transactions_categories_table_query)
                # Table transferts_externes
                create_transferts_externes_table_query = """
                CREATE TABLE IF NOT EXISTS transferts_externes (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    transaction_id INT NOT NULL,
                    iban_dest VARCHAR(34) NOT NULL,
                    bic_dest VARCHAR(11),
                    nom_dest VARCHAR(255) NOT NULL,
                    montant DECIMAL(15,2) NOT NULL,
                    devise VARCHAR(3) DEFAULT 'EUR',
                    statut ENUM('pending', 'processed', 'cancelled') DEFAULT 'pending',
                    date_demande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    date_traitement TIMESTAMP NULL,
                    FOREIGN KEY (transaction_id) REFERENCES transactions(id)
                );
                """
                cursor.execute(create_transferts_externes_table_query)

                # Table categories_comptables
                create_categories_table_query = """
                CREATE TABLE IF NOT EXISTS categories_comptables (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    numero VARCHAR(10) NOT NULL UNIQUE,
                    nom VARCHAR(255) NOT NULL,
                    parent_id INT,
                    type_compte ENUM('Actif', 'Passif', 'Charge', 'Revenus') NOT NULL,
                    compte_systeme BOOLEAN DEFAULT FALSE,
                    compte_associe VARCHAR(10),
                    type_tva ENUM('taux_plein', 'taux_reduit', 'taux_zero', 'exonere') DEFAULT 'taux_plein',
                    actif BOOLEAN DEFAULT TRUE,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                );
                """
                cursor.execute(create_categories_table_query)

                # Table contacts
                create_contacts_table_query = """
                CREATE TABLE IF NOT EXISTS contacts (
                    id_contact INT AUTO_INCREMENT PRIMARY KEY,
                    nom VARCHAR(255) NOT NULL,
                    email VARCHAR(255),
                    telephone VARCHAR(20),
                    adresse TEXT,
                    code_postal VARCHAR(10),
                    ville VARCHAR(100),
                    pays VARCHAR(100),
                    utilisateur_id INT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_contacts_table_query)


                # Table contact plan
                create_contact_plans_table_query = """
                CREATE TABLE IF NOT EXISTS contact_plans(
                contact_id INT NOT NULL,
                plan_id INT NOT NULL,
                PRIMARY KEY (contact_id, plan_id),
                FOREIGN KEY (contact_id) REFERENCES contacts(id_contact) ON DELETE CASCADE,
                FOREIGN KEY (plan_id) REFERENCES plans_comptables(id) ON DELETE CASCADE
                )
                """
                cursor.execute(create_contact_plans_table_query)


                #Table ecritures_comptables
                create_ecritures_table_query = """
                CREATE TABLE IF NOT EXISTS ecritures_comptables (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    date_ecriture DATE NOT NULL,
                    compte_bancaire_id INT NOT NULL,
                    sous_compte_id INT,
                    categorie_id INT NOT NULL,
                    montant DECIMAL(15,2) NOT NULL,
                    montant_htva DECIMAL(15,2) NOT NULL,
                    devise VARCHAR(3) DEFAULT 'CHF',
                    description TEXT,
                    id_contact INT,
                    reference VARCHAR(100),
                    type_ecriture ENUM('depense', 'recette') NOT NULL,
                    tva_taux DECIMAL(5,2),
                    tva_montant DECIMAL(15,2),
                    utilisateur_id INT NOT NULL,
                    justificatif_url VARCHAR(255),
                    statut ENUM('pending', 'validée', 'rejetée') DEFAULT 'pending',
                    date_validation TIMESTAMP NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                    FOREIGN KEY (compte_bancaire_id) REFERENCES comptes_principaux(id),
                    FOREIGN KEY (sous_compte_id) REFERENCES sous_comptes(id),
                    FOREIGN KEY (categorie_id) REFERENCES categories_comptables(id),
                    FOREIGN KEY (id_contact) REFERENCES contacts(id_contact),
                    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_ecritures_table_query)

                
                cursor.execute(create_plan_comptable_table_query)

    
                # Table Plan comptable
                create_plan_comptable_table_query = """
                CREATE TABLE IF NOT EXISTS plans_comptables (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    nom VARCHAR(100) NOT NULL,
                    description TEXT,
                    devise VARCHAR(3) DEFAULT 'CHF',
                    utilisateur_id INT NOT NULL,
                    actif TINYINT(1) DEFAULT 1,
                    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
                );
                """
                # Table plan_category
                create_plan_categorie_table_query = """
                CREATE TABLE IF NOT EXISTS plan_categorie (
                    plan_id INT NOT NULL,
                    categorie_id INT NOT NULL,
                    PRIMARY KEY (plan_id, categorie_id),
                    FOREIGN KEY (plan_id) REFERENCES plans_comptables(id) ON DELETE CASCADE,
                    FOREIGN KEY (categorie_id) REFERENCES categories_comptables(id) ON DELETE CASCADE
                );
                """
                cursor.execute(create_plan_categorie_table_query)


                # Table contactCompte
                create_contact_compte_table_query = """
                CREATE TABLE IF NOT EXISTS contact_comptes (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    contact_id INT NOT NULL,
                    compte_id INT NOT NULL,
                    utilisateur_id INT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                    -- Clés étrangères
                    FOREIGN KEY (contact_id) REFERENCES contacts(id_contact) ON DELETE CASCADE,
                    FOREIGN KEY (compte_id) REFERENCES comptes_principaux(id) ON DELETE CASCADE,
                    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,

                    -- Contrainte d'unicité : un utilisateur ne peut lier un contact à un compte qu'une seule fois
                    UNIQUE KEY unique_contact_compte_user (contact_id, compte_id, utilisateur_id),

                    -- Index pour les recherches fréquentes
                    INDEX idx_contact_user (contact_id, utilisateur_id),
                    INDEX idx_compte_user (compte_id, utilisateur_id)
                );
                """
                cursor.execute(create_contact_compte_table_query)

                # Table parametres_utilisateur
                create_parametres_table_query = """
                CREATE TABLE IF NOT EXISTS parametres_utilisateur (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    utilisateur_id INT NOT NULL UNIQUE,
                    devise_principale VARCHAR(3) DEFAULT 'CHF',
                    theme ENUM('clair', 'sombre') DEFAULT 'clair',
                    notifications_email BOOLEAN DEFAULT TRUE,
                    alertes_solde BOOLEAN DEFAULT TRUE,
                    seuil_alerte_solde DECIMAL(15,2) DEFAULT 500.00,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_parametres_table_query)

                # Table heures_travail
                create_heures_travail_table_query = """
                CREATE TABLE IF NOT EXISTS heures_travail (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    date DATE NOT NULL,
                    user_id INT NOT NULL,
                    employe_id INT NULL,
                    h1d TIME,
                    h1f TIME,
                    h2d TIME,
                    h2f TIME,
                    total_h DECIMAL(5,2),
                    type_heures ENUM('reelles', 'simulees') NOT NULL DEFAULT 'reelles',
                    vacances BOOLEAN DEFAULT FALSE,
                    jour_semaine VARCHAR(10),
                    semaine_annee INT,
                    mois INT,
                    employeur VARCHAR(255),
                    id_contrat INT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    UNIQUE KEY unique_date_user_contrat_employe (date, user_id, id_contrat, employe_id),
                    FOREIGN KEY (user_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
                    FOREIGN KEY (employe_id) REFERENCES employes(id) ON DELETE SET NULL,
                    FOREIGN KEY (id_contrat) REFERENCES contrats(id) ON DELETE CASCADE
                );
                """
                cursor.execute(create_heures_travail_table_query)

                

                # Table salaires
                create_salaires_table_query = """
                CREATE TABLE IF NOT EXISTS salaires (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    mois INT NOT NULL,
                    annee INT NOT NULL,
                    heures_reelles DECIMAL(7,2),
                    salaire_horaire DECIMAL(7,2) DEFAULT 24.05,
                    salaire_calcule DECIMAL(10,2),
                    salaire_net DECIMAL(10,2),
                    salaire_verse DECIMAL(10,2),
                    acompte_25 DECIMAL(10,2),
                    acompte_10 DECIMAL(10,2),
                    acompte_25_estime DECIMAL(10,2),
                    acompte_10_estime DECIMAL(10,2),
                    difference DECIMAL(10,2),
                    difference_pourcent DECIMAL(5,2),
                    user_id INT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_salaires_table_query)

                # Table synthese_hebdo
                create_synthese_hebdo_table_query = """
                CREATE TABLE IF NOT EXISTS synthese_hebdo (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    semaine_numero INT NOT NULL,
                    annee INT NOT NULL,
                    heures_reelles DECIMAL(7,2),
                    heures_simulees DECIMAL(7,2),
                    difference DECIMAL(7,2),
                    moyenne_mobile DECIMAL(7,2),
                    user_id INT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_synthese_hebdo_table_query)

                # Table synthese_mensuelle
                create_synthese_mensuelle_table_query = """
                CREATE TABLE IF NOT EXISTS synthese_mensuelle (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    mois INT NOT NULL,
                    annee INT NOT NULL,
                    heures_reelles DECIMAL(7,2),
                    heures_simulees DECIMAL(7,2),
                    salaire_reel DECIMAL(10,2),
                    salaire_simule DECIMAL(10,2),
                    user_id INT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_synthese_mensuelle_table_query)



                

                # Tables types_indemnite 
                create_types_indemnite_table_query = """
                CREATE TABLE IF NOT EXISTS types_indemnite (
                id INT PRIMARY KEY AUTO_INCREMENT,
                user_id INT NOT NULL,
                nom VARCHAR(100) NOT NULL,
                description TEXT,
                est_obligatoire BOOLEAN DEFAULT FALSE,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
                );"""
                cursor.execute(create_types_indemnite_table_query)

                # cotisations_contrat
                create_cotisations_contrat_table_query = """
                CREATE TABLE IF NOT EXISTS cotisations_contrat (
                id INT PRIMARY KEY AUTO_INCREMENT,
                contrat_id INT NOT NULL,
                type_cotisation_id INT NOT NULL,
                taux DECIMAL(10,4) NOT NULL, -- peut être % ou montant fixe
                base_calcul ENUM('brut', 'brut_tot') DEFAULT 'brut',
                annee YEAR NOT NULL,
                actif BOOLEAN DEFAULT TRUE,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                UNIQUE KEY unique_contrat_type_annee (contrat_id, type_cotisation_id, annee),
                FOREIGN KEY (contrat_id) REFERENCES contrats(id) ON DELETE CASCADE,
                FOREIGN KEY (type_cotisation_id) REFERENCES types_cotisation(id) ON DELETE CASCADE
                );
                """
                cursor.execute(create_cotisations_contrat_table_query)

                 # indemnites_contrat
                create_indemnites_contrat_table_query = """
                CREATE TABLE IF NOT EXISTS indemnites_contrat (
                id INT PRIMARY KEY AUTO_INCREMENT,
                contrat_id INT NOT NULL,
                type_indemnite_id INT NOT NULL,
                taux DECIMAL(10,4) NOT NULL, -- interprété comme % du brut
                base_calcul ENUM('brut', 'brut_tot') DEFAULT 'brut',
                annee YEAR NOT NULL,
                actif BOOLEAN DEFAULT TRUE,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                UNIQUE KEY unique_indemnite_contrat_annee (contrat_id, type_indemnite_id, annee),
                FOREIGN KEY (contrat_id) REFERENCES contrats(id) ON DELETE CASCADE,
                FOREIGN KEY (type_indemnite_id) REFERENCES types_indemnite(id) ON DELETE CASCADE
                );
                """
                cursor.execute(create_indemnites_contrat_table_query)
                # regles_cotisation

                create_regles_cotisations_table_query = """
                CREATE TABLE IF NOT EXISTS regles_cotisation (
                id INT AUTO_INCREMENT PRIMARY KEY,
                type_cotisation_id INT NOT NULL,
                seuil_min DECIMAL(10,2) DEFAULT 0.00,   -- salaire mensuel brut minimum inclus
                seuil_max DECIMAL(10,2) DEFAULT NULL,   -- NULL = sans limite
                montant_fixe DECIMAL(10,2) DEFAULT 0.00,
                taux DECIMAL(5,2) DEFAULT 0.00,         -- à utiliser si montant non fixe
                type_valeur ENUM('taux','fixe') NOT NULL DEFAULT 'fixe',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (type_cotisation_id) REFERENCES types_cotisation(id) ON DELETE CASCADE
                );"""
                cursor.execute(create_regles_cotisations_table_query)
                 # baremes_indemnite

                create_baremes_indemnite_table_query = """
                CREATE TABLE IF NOT EXISTS baremes_indemnite (
                id INT AUTO_INCREMENT PRIMARY KEY,
                type_indemnite_id INT NOT NULL,
                seuil_min DECIMAL(10,2) NOT NULL DEFAULT 0.00,
                seuil_max DECIMAL(10,2) DEFAULT NULL,
                montant_fixe DECIMAL(10,2) NOT NULL DEFAULT 0.00,
                taux DECIMAL(5,2) NOT NULL DEFAULT 0.00,
                type_valeur ENUM('taux','fixe') NOT NULL DEFAULT 'fixe',
                ordre INT NOT NULL DEFAULT 0,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (type_indemnite_id) REFERENCES types_indemnite(id) ON DELETE CASCADE
                 );"""
                cursor.execute(create_baremes_indemnite_table_query)
                # baremes_cotisation
                create_baremes_cotisation_table_query = """
                CREATE TABLE IF NOT EXISTS baremes_cotisation (
                id INT AUTO_INCREMENT PRIMARY KEY,
                type_cotisation_id INT NOT NULL,
                seuil_min DECIMAL(10,2) NOT NULL DEFAULT 0.00,
                seuil_max DECIMAL(10,2) DEFAULT NULL,
                montant_fixe DECIMAL(10,2) NOT NULL DEFAULT 0.00,
                taux DECIMAL(5,2) NOT NULL DEFAULT 0.00,
                type_valeur ENUM('taux','fixe') NOT NULL DEFAULT 'fixe',
                ordre INT NOT NULL DEFAULT 0,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (type_cotisation_id) REFERENCES types_cotisation(id) ON DELETE CASCADE
                 );"""
                cursor.execute(create_baremes_cotisation_table_query)

                #plages_horaires
                create_plages_horaires_table_query = """
                CREATE TABLE IF NOT EXISTS plages_horaires (
                id INT PRIMARY KEY AUTO_INCREMENT,
                heure_travail_id INT NOT NULL,
                ordre TINYINT NOT NULL,
                debut TIME,
                fin TIME,
                FOREIGN KEY (heure_travail_id) REFERENCES heures_travail(id) ON DELETE CASCADE,
                UNIQUE KEY unique_heure_travail_ordre (heure_travail_id, ordre)
                );
                """
                cursor.execute(create_plages_horaires_table_query)


                

                #Table equipes
                create_equipes_table_query = """
                CREATE TABLE IF NOT EXISTS equipes (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                nom VARCHAR(100) NOT NULL,
                description VARCHAR(255) NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES utilisateurs(id)
                );"""
                cursor.execute(create_equipes_table_query)


                #Table equipes_employes
                create_equipes_employes_table_query = """
                CREATE TABLE IF NOT EXISTS equipes_employes (
                equipe_id INT,
                employe_id INT,
                added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (equipe_id, employe_id),
                FOREIGN KEY (equipe_id) REFERENCES equipes(id) ON DELETE CASCADE,
                FOREIGN KEY (employe_id) REFERENCES employes(id) ON DELETE CASCADE
                );"""
                cursor.execute(create_equipes_employes_table_query)

                # Table heures_simules
                create_heures_simules_table_query = """
                CREATE TABLE heures_simulees (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                employe_id INT NOT NULL,
                equipe_id INT NULL,
                date DATE NOT NULL,
                h1d TIME,            -- heure début
                h2f TIME,            -- heure fin
                total_h FLOAT,       -- heures totales
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES utilisateurs(id),
                FOREIGN KEY (employe_id) REFERENCES employes(id),
                FOREIGN KEY (equipe_id) REFERENCES equipes(id)
                );"""
                cursor.execute(create_heures_simules_table_query)


                #Table competences
                create_competences_table_query = """
                CREATE TABLE IF NOT EXISTS competences (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                nom VARCHAR(100) NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES utilisateurs(id)
                );
                """
                cursor.execute(create_competences_table_query)

                #Table employes_competences
                create_equipes_competences_table_query = """
                CREATE TABLE IF NOT EXISTS employes_competences (
                competence_id INT,
                employe_id INT,
                assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (competence_id, employe_id),
                FOREIGN KEY (competence_id) REFERENCES competences(id) ON DELETE CASCADE,
                FOREIGN KEY (employe_id) REFERENCES employes(id) ON DELETE CASCADE
                );"""
                cursor.execute(create_equipes_competences_table_query)

                # #Table equipes_competences_requises
                create_equipes_competences_requises_table_query = """
                CREATE TABLE IF NOT EXISTS equipes_competences_requises (
                equipe_id INT,
                competence_id INT,
                quantite_min INT DEFAULT 1,
                PRIMARY KEY (equipe_id, competence_id),
                FOREIGN KEY (equipe_id) REFERENCES equipes(id) ON DELETE CASCADE,
                FOREIGN KEY (competence_id) REFERENCES competences(id) ON DELETE CASCADE
                );
                """
                cursor.execute(create_equipes_competences_requises_table_query)

                #Table palnning regles
                create_planning_regles_table_query = """
                CREATE TABLE IF NOT EXISTS planning_regles (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                nom VARCHAR(150) NOT NULL,
                type_regle VARCHAR(50) NOT NULL,
                params_json JSON NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES utilisateurs(id)
                );"""
                cursor.execute(create_planning_regles_table_query)

                # Table entreprise
                create_entreprise_table_query = """
                CREATE TABLE IF NOT EXISTS entreprise (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL UNIQUE,
                nom VARCHAR(255) NOT NULL,
                rue VARCHAR(255),
                code_postal VARCHAR(20),
                commune VARCHAR(100),
                email VARCHAR(255),
                telephone VARCHAR(50),
                logo_path VARCHAR(255),  -- ex: 'uploads/logos/user_123.png'
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
                );"""
                cursor.execute(create_entreprise_table_query)


                cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")
            logger.info("Toutes les tables ont été vérifiées/créées avec succès.")
            print("✅ Toutes les tables ont été créées ou vérifiées.")
        except Exception as e:
            logger.error(f"Erreur lors de la création des tables : {e}")
