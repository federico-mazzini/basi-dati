DELIMITER $$

DROP PROCEDURE IF EXISTS popola_dati_4ctl $$

CREATE PROCEDURE popola_dati_4ctl()
BEGIN
    -- ==========================================
    -- CONFIGURAZIONE PARAMETRI
    -- ==========================================
    DECLARE v_num_sezioni INT DEFAULT 2;
    DECLARE v_stud_per_classe INT DEFAULT 20;
    DECLARE v_num_docenti INT DEFAULT 20;
    DECLARE v_num_materie INT DEFAULT 8;
    DECLARE v_num_sessioni INT DEFAULT 100;

    DECLARE i INT DEFAULT 1;
    DECLARE anno INT DEFAULT 1;
    DECLARE sez INT DEFAULT 1;

    DECLARE v_id_sess INT;
    DECLARE v_curr_cl INT;
    DECLARE v_curr_mat INT;
    DECLARE v_nome VARCHAR(50);
    DECLARE v_cognome VARCHAR(50);
    DECLARE v_email VARCHAR(100);
    DECLARE v_tipo VARCHAR(20);
    DECLARE v_random_classe_id INT;
    DECLARE v_random_materia_id INT;
    DECLARE v_nascita DATE;

    DECLARE done INT DEFAULT 0;
    DECLARE curr_classe_id INT;
    DECLARE curr_studente_id INT;

    DECLARE cur_classi CURSOR FOR
        SELECT id_classe FROM `4CTL_classi`;

    DECLARE cur_studenti CURSOR FOR
        SELECT id_studente
        FROM `4CTL_studenti`
        WHERE id_classe = v_curr_cl;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERRORE DURANTE L''INSERT' AS messaggio;
    END;

    START TRANSACTION;

    -- =====================================================
    -- Tabelle temporanee di supporto per nomi, cognomi, materie
    -- =====================================================
    DROP TEMPORARY TABLE IF EXISTS tmp_nomi;
    CREATE TEMPORARY TABLE tmp_nomi (
        id INT PRIMARY KEY AUTO_INCREMENT,
        valore VARCHAR(50) NOT NULL
    );

    INSERT INTO tmp_nomi (valore) VALUES
    ('Luca'), ('Anna'), ('Marco'), ('Sara'), ('Paolo'),
    ('Elena'), ('Giovanni'), ('Giulia'), ('Matteo'), ('Chiara');

    DROP TEMPORARY TABLE IF EXISTS tmp_cognomi;
    CREATE TEMPORARY TABLE tmp_cognomi (
        id INT PRIMARY KEY AUTO_INCREMENT,
        valore VARCHAR(50) NOT NULL
    );

    INSERT INTO tmp_cognomi (valore) VALUES
    ('Rossi'), ('Bianchi'), ('Verdi'), ('Neri'), ('Russo'),
    ('Galli'), ('Costa'), ('Fontana'), ('Ferraro'), ('Serra');

    DROP TEMPORARY TABLE IF EXISTS tmp_materie;
    CREATE TEMPORARY TABLE tmp_materie (
        id INT PRIMARY KEY AUTO_INCREMENT,
        valore VARCHAR(50) NOT NULL
    );

    INSERT INTO tmp_materie (valore) VALUES
    ('Italiano'), ('Matematica'), ('Inglese'), ('Storia'),
    ('Informatica'), ('Fisica'), ('Scienze'), ('Diritto');

    -- =====================================================
    -- 1. INSERIMENTO CLASSI
    -- =====================================================
    SET anno = 1;
    WHILE anno <= 5 DO
        SET sez = 1;
        WHILE sez <= v_num_sezioni DO
            INSERT INTO `4CTL_classi` (nome, anno)
            VALUES (
                CONCAT(anno, CHAR(64 + sez)),
                anno
            );
            SET sez = sez + 1;
        END WHILE;
        SET anno = anno + 1;
    END WHILE;

    -- =====================================================
    -- 2. INSERIMENTO DOCENTI
    -- =====================================================
    SET i = 1;
    WHILE i <= v_num_docenti DO

        SELECT valore INTO v_nome
        FROM tmp_nomi
        ORDER BY RAND()
        LIMIT 1;

        SELECT valore INTO v_cognome
        FROM tmp_cognomi
        ORDER BY RAND()
        LIMIT 1;

        SET v_email = CONCAT(
            'docente',
            SUBSTRING(MD5(RAND()), 1, 5),
            '@scuola.it'
        );

        INSERT INTO `4CTL_docenti` (nome, cognome, email)
        VALUES (v_nome, v_cognome, v_email);

        SET i = i + 1;
    END WHILE;

    -- =====================================================
    -- 3. INSERIMENTO MATERIE
    -- Associate ai primi docenti inseriti
    -- =====================================================
    SET i = 1;
    WHILE i <= v_num_materie DO
        INSERT INTO `4CTL_materie` (nome, id_docente)
        VALUES (
            (SELECT valore FROM tmp_materie WHERE id = i),
            i
        );

        SET i = i + 1;
    END WHILE;

    -- =====================================================
    -- 4. INSERIMENTO STUDENTI
    -- Cicliamo sulle classi reali presenti in tabella
    -- =====================================================
    SET done = 0;
    OPEN cur_classi;

    read_classi: LOOP
        FETCH cur_classi INTO curr_classe_id;
        IF done = 1 THEN
            LEAVE read_classi;
        END IF;

        SET i = 1;
        WHILE i <= v_stud_per_classe DO

            SELECT valore INTO v_nome
            FROM tmp_nomi
            ORDER BY RAND()
            LIMIT 1;

            SELECT valore INTO v_cognome
            FROM tmp_cognomi
            ORDER BY RAND()
            LIMIT 1;

            SET v_nascita = DATE_SUB(
                CURDATE(),
                INTERVAL FLOOR(14 * 365 + RAND() * (5 * 365)) DAY
            );

            INSERT INTO `4CTL_studenti` (
                matricola,
                nome,
                cognome,
                data_nascita,
                id_classe
            )
            VALUES (
                CONCAT(
                    'M-',
                    curr_classe_id,
                    '-',
                    LPAD(i, 2, '0'),
                    '-',
                    FLOOR(10 + RAND() * 90)
                ),
                v_nome,
                v_cognome,
                v_nascita,
                curr_classe_id
            );

            SET i = i + 1;
        END WHILE;

    END LOOP;

    CLOSE cur_classi;

    -- =====================================================
    -- 5. GENERAZIONE VERIFICHE E VOTI
    -- =====================================================
    SET i = 1;
    WHILE i <= v_num_sessioni DO

        SELECT id_classe INTO v_curr_cl
        FROM `4CTL_classi`
        ORDER BY RAND()
        LIMIT 1;

        SELECT id_materia INTO v_curr_mat
        FROM `4CTL_materie`
        ORDER BY RAND()
        LIMIT 1;

        SET v_tipo = IF(RAND() > 0.5, 'Scritto', 'Orale');

        INSERT INTO `4CTL_verifiche` (
            id_materia,
            id_classe,
            data_verifica,
            tipo
        )
        VALUES (
            v_curr_mat,
            v_curr_cl,
            DATE_SUB(CURDATE(), INTERVAL FLOOR(1 + RAND() * 150) DAY),
            v_tipo
        );

        SET v_id_sess = LAST_INSERT_ID();

        -- Cursor sugli studenti della classe corrente
        SET done = 0;
        OPEN cur_studenti;

        read_studenti: LOOP
            FETCH cur_studenti INTO curr_studente_id;
            IF done = 1 THEN
                LEAVE read_studenti;
            END IF;

            INSERT INTO `4CTL_verifiche_studenti` (
                id_verifica,
                id_studente,
                voto,
                commento
            )
            VALUES (
                v_id_sess,
                curr_studente_id,
                ROUND(3 + RAND() * 7, 1),
                'Voto inserito automaticamente'
            );
        END LOOP;

        CLOSE cur_studenti;
        SET done = 0;

        SET i = i + 1;
    END WHILE;

    COMMIT;

    SELECT 'Inserimento completato con successo.' AS messaggio;

END $$

DELIMITER ;

CALL popola_dati_4ctl();