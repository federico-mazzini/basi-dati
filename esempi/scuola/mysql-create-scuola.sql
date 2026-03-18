-- 1. Pulizia tabelle esistenti (MySQL style)
SET FOREIGN_KEY_CHECKS = 0; -- Disabilita i vincoli per permettere il drop in qualsiasi ordine
DROP TABLE IF EXISTS verifiche_studenti;
DROP TABLE IF EXISTS verifiche;
DROP TABLE IF EXISTS materie;
DROP TABLE IF EXISTS docenti;
DROP TABLE IF EXISTS studenti;
DROP TABLE IF EXISTS classi;
SET FOREIGN_KEY_CHECKS = 1; -- Riabilita i vincoli

-- 2. Creazione tabelle di base
CREATE TABLE classi (
    id_classe    INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(5) NOT NULL UNIQUE,  
    anno         INT NOT NULL                 
);

CREATE TABLE studenti (
    id_studente     INT AUTO_INCREMENT PRIMARY KEY,
    matricola       VARCHAR(10) NOT NULL UNIQUE,
    nome            VARCHAR(50) NOT NULL,
    cognome         VARCHAR(50) NOT NULL,
    data_nascita    DATE NOT NULL,
    id_classe       INT NOT NULL,
    email           VARCHAR(100),
    telefono        VARCHAR(20),
    data_iscrizione DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_studenti_classe FOREIGN KEY (id_classe) 
        REFERENCES classi(id_classe) ON DELETE CASCADE
);

CREATE TABLE docenti (
    id_docente INT AUTO_INCREMENT PRIMARY KEY,
    nome       VARCHAR(50) NOT NULL,
    cognome    VARCHAR(50) NOT NULL,
    email      VARCHAR(100)
);

CREATE TABLE materie (
    id_materia INT AUTO_INCREMENT PRIMARY KEY,
    nome       VARCHAR(50) NOT NULL,
    id_docente INT,
    CONSTRAINT fk_materie_docente FOREIGN KEY (id_docente) 
        REFERENCES docenti(id_docente)
);

-- 3. Sessioni di Verifica
CREATE TABLE verifiche (
    id_verifica   INT AUTO_INCREMENT PRIMARY KEY,
    id_materia    INT NOT NULL,
    id_classe     INT NOT NULL, 
    data_verifica DATE NOT NULL,
    tipo          VARCHAR(20),    
    note          VARCHAR(255),
    CONSTRAINT fk_sess_materia FOREIGN KEY (id_materia) REFERENCES materie(id_materia),
    CONSTRAINT fk_sess_classe FOREIGN KEY (id_classe) REFERENCES classi(id_classe) ON DELETE CASCADE
);

-- 4. Voti Studenti
CREATE TABLE verifiche_studenti (
    id_voto       INT AUTO_INCREMENT PRIMARY KEY,
    id_verifica   INT NOT NULL,
    id_studente   INT NOT NULL,
    voto          DECIMAL(3,1), -- MySQL usa DECIMAL per precisione fissa
    commento      VARCHAR(255),
    CONSTRAINT fk_voto_sessione FOREIGN KEY (id_verifica) REFERENCES verifiche(id_verifica) ON DELETE CASCADE,
    CONSTRAINT fk_voto_studente FOREIGN KEY (id_studente) REFERENCES studenti(id_studente) ON DELETE CASCADE
);