DELIMITER $$

DROP PROCEDURE IF EXISTS PopolaScuola $$

CREATE PROCEDURE PopolaScuola()
BEGIN
    -- 1. DICHIARAZIONE PARAMETRI
    DECLARE v_num_sezioni INT DEFAULT 2;
    DECLARE v_stud_per_classe INT DEFAULT 20;
    DECLARE v_num_docenti INT DEFAULT 20;
    DECLARE v_num_materie INT DEFAULT 8;
    DECLARE v_num_sessioni INT DEFAULT 100;
    
    -- Variabili di supporto
    DECLARE i, j, k INT DEFAULT 1;
    DECLARE v_id_cl, v_id_mat, v_id_sess, v_id_stud INT;
    DECLARE done INT DEFAULT FALSE;
    
    -- Cursor per scorrere gli studenti di una classe durante le verifiche
    DECLARE cur_studenti CURSOR FOR SELECT id_studente FROM studenti WHERE id_classe = v_id_cl;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 2. PREPARAZIONE DATI (Tabelle Temporanee invece di Array PL/SQL)
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_nomi (id INT AUTO_INCREMENT PRIMARY KEY, val VARCHAR(50));
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_cognomi (id INT AUTO_INCREMENT PRIMARY KEY, val VARCHAR(50));
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_materie (id INT AUTO_INCREMENT PRIMARY KEY, val VARCHAR(50));

    TRUNCATE tmp_nomi; TRUNCATE tmp_cognomi; TRUNCATE tmp_materie;
    
    INSERT INTO tmp_nomi (val) VALUES ('Luca'),('Anna'),('Marco'),('Sara'),('Paolo'),('Elena'),('Giovanni'),('Giulia'),('Matteo'),('Chiara');
    INSERT INTO tmp_cognomi (val) VALUES ('Rossi'),('Bianchi'),('Verdi'),('Neri'),('Russo'),('Galli'),('Costa'),('Fontana'),('Ferraro'),('Serra');
    INSERT INTO tmp_materie (val) VALUES ('Italiano'),('Matematica'),('Inglese'),('Storia'),('Informatica'),('Fisica'),('Scienze'),('Diritto');

    -- 3. INSERIMENTO CLASSI
    SET i = 1;
    WHILE i <= 5 DO
        SET j = 1;
        WHILE j <= v_num_sezioni DO
            INSERT INTO classi (nome, anno) VALUES (CONCAT(i, CHAR(64 + j)), i);
            SET j = j + 1;
        END WHILE;
        SET i = i + 1;
    END WHILE;

    -- 4. INSERIMENTO DOCENTI
    SET i = 1;
    WHILE i <= v_num_docenti DO
        INSERT INTO docenti (nome, cognome, email) 
        VALUES (
            (SELECT val FROM tmp_nomi ORDER BY RAND() LIMIT 1),
            (SELECT val FROM tmp_cognomi ORDER BY RAND() LIMIT 1),
            CONCAT('docente', i, '@scuola.it')
        );
        SET i = i + 1;
    END WHILE;

    -- 5. INSERIMENTO MATERIE
    SET i = 1;
    WHILE i <= v_num_materie DO
        INSERT INTO materie (nome, id_docente) 
        VALUES (
            (SELECT val FROM tmp_materie WHERE id = i),
            (SELECT id_docente FROM docenti ORDER BY RAND() LIMIT 1)
        );
        SET i = i + 1;
    END WHILE;

    -- 6. INSERIMENTO STUDENTI
    -- Usiamo un CROSS JOIN per popolare ogni classe
    INSERT INTO studenti (matricola, nome, cognome, data_nascita, id_classe)
    SELECT 
        CONCAT('M-', c.id_classe, '-', LPAD(t.n, 2, '0'), '-', FLOOR(RAND()*99)),
        (SELECT val FROM tmp_nomi ORDER BY RAND() LIMIT 1),
        (SELECT val FROM tmp_cognomi ORDER BY RAND() LIMIT 1),
        DATE_SUB(CURDATE(), INTERVAL (14 + RAND()*5) YEAR),
        c.id_classe
    FROM classi c
    JOIN (SELECT a.N + b.N * 10 + 1 AS n FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a, (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b) t
    WHERE t.n <= v_stud_per_classe;

    -- 7. GENERAZIONE VERIFICHE E VOTI
    SET i = 1;
    WHILE i <= v_num_sessioni DO
        -- Seleziona classe e materia casuale
        SELECT id_classe INTO v_id_cl FROM classi ORDER BY RAND() LIMIT 1;
        SELECT id_materia INTO v_id_mat FROM materie ORDER BY RAND() LIMIT 1;

        -- Crea sessione
        INSERT INTO verifiche (id_materia, id_classe, data_verifica, tipo)
        VALUES (v_id_mat, v_id_cl, DATE_SUB(CURDATE(), INTERVAL RAND()*150 DAY), 
                IF(RAND() > 0.5, 'Scritto', 'Orale'));
        
        SET v_id_sess = LAST_INSERT_ID();

        -- Inserisci voti per tutti gli studenti della classe
        INSERT INTO verifiche_studenti (id_verifica, id_studente, voto, commento)
        SELECT v_id_sess, id_studente, ROUND(3 + RAND()*7, 1), 'Voto automatico'
        FROM studenti WHERE id_classe = v_id_cl;

        SET i = i + 1;
    END WHILE;

    DROP TEMPORARY TABLE tmp_nomi;
    DROP TEMPORARY TABLE tmp_cognomi;
    DROP TEMPORARY TABLE tmp_materie;
    
    SELECT 'Popolamento completato!' AS Risultato;
END $$

DELIMITER ;