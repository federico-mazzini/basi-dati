-- Facoltativo: elimina prima le tabelle se esistono già
DROP TABLE IF EXISTS `4CTL_verifiche_studenti`;
DROP TABLE IF EXISTS `4CTL_verifiche`;
DROP TABLE IF EXISTS `4CTL_materie`;
DROP TABLE IF EXISTS `4CTL_studenti`;
DROP TABLE IF EXISTS `4CTL_docenti`;
DROP TABLE IF EXISTS `4CTL_classi`;

-- 2. Creazione tabelle di base
CREATE TABLE `4CTL_classi` (
    id_classe INT AUTO_INCREMENT PRIMARY KEY,
    nome      VARCHAR(5) NOT NULL UNIQUE,
    anno      INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `4CTL_studenti` (
    id_studente     INT AUTO_INCREMENT PRIMARY KEY,
    matricola       VARCHAR(20) NOT NULL UNIQUE,
    nome            VARCHAR(50) NOT NULL,
    cognome         VARCHAR(50) NOT NULL,
    data_nascita    DATE NOT NULL,
    id_classe       INT NOT NULL,
    email           VARCHAR(100),
    telefono        VARCHAR(20),
    data_iscrizione DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_studenti_classe
        FOREIGN KEY (id_classe)
        REFERENCES `4CTL_classi`(id_classe)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `4CTL_docenti` (
    id_docente INT AUTO_INCREMENT PRIMARY KEY,
    nome       VARCHAR(50) NOT NULL,
    cognome    VARCHAR(50) NOT NULL,
    email      VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE `4CTL_materie` (
    id_materia INT AUTO_INCREMENT PRIMARY KEY,
    nome       VARCHAR(50) NOT NULL,
    id_docente INT,
    CONSTRAINT fk_materie_docente
        FOREIGN KEY (id_docente)
        REFERENCES `4CTL_docenti`(id_docente)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- 3. Sessioni di verifica
CREATE TABLE `4CTL_verifiche` (
    id_verifica   INT AUTO_INCREMENT PRIMARY KEY,
    id_materia    INT NOT NULL,
    id_classe     INT NOT NULL,
    data_verifica DATE NOT NULL,
    tipo          VARCHAR(20),
    note          VARCHAR(255),
    CONSTRAINT fk_sess_materia
        FOREIGN KEY (id_materia)
        REFERENCES `4CTL_materie`(id_materia),
    CONSTRAINT fk_sess_classe
        FOREIGN KEY (id_classe)
        REFERENCES `4CTL_classi`(id_classe)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Voti studenti
CREATE TABLE `4CTL_verifiche_studenti` (
    id_voto     INT AUTO_INCREMENT PRIMARY KEY,
    id_verifica INT NOT NULL,
    id_studente INT NOT NULL,
    voto        DECIMAL(3,1),
    commento    VARCHAR(255),
    CONSTRAINT fk_voto_sessione
        FOREIGN KEY (id_verifica)
        REFERENCES `4CTL_verifiche`(id_verifica)
        ON DELETE CASCADE,
    CONSTRAINT fk_voto_studente
        FOREIGN KEY (id_studente)
        REFERENCES `4CTL_studenti`(id_studente)
        ON DELETE CASCADE
) ENGINE=InnoDB;