SET SERVEROUTPUT ON;

DECLARE
    -- ==========================================
    -- CONFIGURAZIONE PARAMETRI
    -- ==========================================
    v_num_sezioni     CONSTANT NUMBER := 2;   -- A, B
    v_stud_per_classe CONSTANT NUMBER := 20;  
    v_num_docenti     CONSTANT NUMBER := 20;  
    v_num_materie     CONSTANT NUMBER := 8;   
    v_num_sessioni    CONSTANT NUMBER := 100; -- Numero di compiti in classe
    -- ==========================================

    v_tmp_nome     VARCHAR2(50);
    v_tmp_cognome  VARCHAR2(50);
    v_id_sess      NUMBER;
    
    -- Collezioni per mappare gli ID reali generati
    TYPE t_ids IS TABLE OF NUMBER;
    v_id_classi   t_ids := t_ids();
    v_id_materie  t_ids := t_ids();

    TYPE t_list IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    v_nomi t_list; v_cognomi t_list; v_lista_mat t_list;

BEGIN
    -- 1. PREPARAZIONE DATI ANAGRAFICI
    v_nomi(1):='Luca'; v_nomi(2):='Anna'; v_nomi(3):='Marco'; v_nomi(4):='Sara'; v_nomi(5):='Paolo';
    v_nomi(6):='Elena'; v_nomi(7):='Giovanni'; v_nomi(8):='Giulia'; v_nomi(9):='Matteo'; v_nomi(10):='Chiara';
    
    v_cognomi(1):='Rossi'; v_cognomi(2):='Bianchi'; v_cognomi(3):='Verdi'; v_cognomi(4):='Neri'; v_cognomi(5):='Russo';
    v_cognomi(6):='Galli'; v_cognomi(7):='Costa'; v_cognomi(8):='Fontana'; v_cognomi(9):='Ferraro'; v_cognomi(10):='Serra';
    
    v_lista_mat(1):='Italiano'; v_lista_mat(2):='Matematica'; v_lista_mat(3):='Inglese'; v_lista_mat(4):='Storia';
    v_lista_mat(5):='Informatica'; v_lista_mat(6):='Fisica'; v_lista_mat(7):='Scienze'; v_lista_mat(8):='Diritto';

    -- 2. INSERIMENTO CLASSI
    FOR anno IN 1..5 LOOP
        FOR sez IN 1..v_num_sezioni LOOP
            INSERT INTO classi (nome, anno) 
            VALUES (anno || CHR(64 + sez), anno);
        END LOOP;
    END LOOP;
    -- Recuperiamo gli ID delle classi appena inserite
    SELECT id_classe BULK COLLECT INTO v_id_classi FROM classi;

    -- 3. INSERIMENTO DOCENTI
    FOR i IN 1..v_num_docenti LOOP
        INSERT INTO docenti (nome, cognome, email) 
        VALUES (v_nomi(TRUNC(DBMS_RANDOM.VALUE(1, 11))), 
                v_cognomi(TRUNC(DBMS_RANDOM.VALUE(1, 11))), 
                'docente' || DBMS_RANDOM.STRING('x', 5) || '@scuola.it');
    END LOOP;

    -- 4. INSERIMENTO MATERIE (Associate ai primi docenti inseriti)
    FOR i IN 1..v_num_materie LOOP
        INSERT INTO materie (nome, id_docente) 
        VALUES (v_lista_mat(i), i);
    END LOOP;
    SELECT id_materia BULK COLLECT INTO v_id_materie FROM materie;

    -- 5. INSERIMENTO STUDENTI
    -- Cicliamo sugli ID reali delle classi per evitare errori di Foreign Key
    FOR i_cl IN 1..v_id_classi.COUNT LOOP
        FOR i IN 1..v_stud_per_classe LOOP
            INSERT INTO studenti (matricola, nome, cognome, data_nascita, id_classe)
            VALUES (
                'M-' || v_id_classi(i_cl) || '-' || LPAD(i, 2, '0') || '-' || TRUNC(DBMS_RANDOM.VALUE(10,99)), 
                v_nomi(TRUNC(DBMS_RANDOM.VALUE(1,11))), 
                v_cognomi(TRUNC(DBMS_RANDOM.VALUE(1,11))),
                SYSDATE - (DBMS_RANDOM.VALUE(14,19)*365), 
                v_id_classi(i_cl)
            );
        END LOOP;
    END LOOP;

    -- 6. GENERAZIONE VERIFICHE E VOTI
    FOR i IN 1..v_num_sessioni LOOP
        DECLARE
            v_curr_cl  NUMBER := v_id_classi(TRUNC(DBMS_RANDOM.VALUE(1, v_id_classi.COUNT + 1)));
            v_curr_mat NUMBER := v_id_materie(TRUNC(DBMS_RANDOM.VALUE(1, v_id_materie.COUNT + 1)));
        BEGIN
            -- Creazione della sessione di verifica
            INSERT INTO verifiche (id_materia, id_classe, data_verifica, tipo)
            VALUES (v_curr_mat, v_curr_cl, SYSDATE - DBMS_RANDOM.VALUE(1, 150), 
                    CASE WHEN DBMS_RANDOM.VALUE(0,1) > 0.5 THEN 'Scritto' ELSE 'Orale' END)
            RETURNING id_verifica INTO v_id_sess;

            -- Inserimento voti per gli studenti che appartengono alla classe della sessione
            FOR r_stud IN (SELECT id_studente FROM studenti WHERE id_classe = v_curr_cl) LOOP
                INSERT INTO verifiche_studenti (id_verifica, id_studente, voto, commento)
                VALUES (v_id_sess, r_stud.id_studente, ROUND(DBMS_RANDOM.VALUE(3, 10), 1), 'Voto inserito automaticamente');
            END LOOP;
        END;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Inserimento completato con successo.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERRORE DURANTE L''INSERT: ' || SQLERRM);
END;
/