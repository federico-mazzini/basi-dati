-- 1. Inserimento Modelli
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('IPH15P', 'iPhone 15 Pro', 'Smartphone Apple 128GB Titanio', 'Smartphone', 1239.00);
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('SAM-S24', 'Samsung Galaxy S24', 'Smartphone Android 256GB', 'Smartphone', 929.00);
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('MAC-M3', 'MacBook Air M3', 'Laptop 13 pollici 8GB RAM', 'Computer', 1349.00);
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('IPAD-A6', 'iPad Air M2', 'Tablet 11 pollici Wi-Fi', 'Tablet', 719.00);
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('SONY-WH', 'Sony WH-1000XM5', 'Cuffie Noise Cancelling', 'Audio', 349.00);
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('LG-OLED', 'LG OLED C3 55"', 'TV Smart 4K 55 pollici', 'TV', 1199.00);
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('PS5-SLM', 'PlayStation 5 Slim', 'Console con lettore disco', 'Gaming', 549.00);
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('NIN-SWI', 'Nintendo Switch OLED', 'Console portatile', 'Gaming', 329.00);
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('APP-W9', 'Apple Watch Series 9', 'Smartwatch 45mm GPS', 'Wearable', 459.00);
INSERT INTO modelli_prodotto (cod_modello, nome, descrizione, categoria, prezzo_listino) VALUES ('BO-QC45', 'Bose QuietComfort', 'Cuffie Bluetooth', 'Audio', 269.00);

-- 2. Inserimento Clienti
INSERT INTO clienti (nome, cognome, data_nascita, email) VALUES
('Mario', 'Rossi', DATE '2000-10-10', 'mario.rossi@email.it'),
('Luca', 'Bianchi', DATE '1999-10-10', 'l.bianchi@gmail.com'),
('Elena', 'Verdi', DATE '1983-10-10', 'elena.verdi@outlook.com'),
('Giulia', 'Neri', DATE '1968-10-10', 'giulia.n@yahoo.it');

-- 3. Inserimento Prodotti
INSERT INTO prodotti (id_modello, cod_seriale, data_arrivo, disponibilita) VALUES
(1, 'SER-IPH-001', DATE '2023-10-10', 'N'), 
(1, 'SER-IPH-002', DATE '2023-10-10', 'N'), 
(1, 'SER-IPH-003', DATE '2024-01-15', 'S'),
(2, 'SER-SAM-999', DATE '2023-11-20', 'N'), 
(3, 'SER-MAC-777', DATE '2024-02-01', 'N'), 
(5, 'SER-SON-123', DATE '2023-12-05', 'N'), 
(5, 'SER-SON-456', DATE '2023-12-05', 'N'), 
(7, 'SER-PS5-000', DATE '2024-03-10', 'S'),
(10, 'SER-BOS-555', DATE '2024-01-20', 'N'),
(1, 'SN-IPH-A1', DATE '2024-05-01', 'N'), 
(1, 'SN-IPH-A2', DATE '2024-05-01', 'N'), 
(1, 'SN-IPH-A3', DATE '2024-06-10', 'S'), 
(1, 'SN-IPH-A4', DATE '2024-06-10', 'S'),
(2, 'SN-SAM-B1', DATE '2024-04-12', 'N'), 
(2, 'SN-SAM-B2', DATE '2024-04-12', 'N'),
(2, 'SN-SAM-B3', DATE '2024-07-01', 'S'),
(3, 'SN-MAC-C1', DATE '2024-01-20', 'N'), 
(3, 'SN-MAC-C2', DATE '2024-01-20', 'N'),
(4, 'SN-PAD-D1', DATE '2024-03-15', 'N'), 
(4, 'SN-PAD-D2', DATE '2024-03-15', 'N'),
(5, 'SN-SON-E1', DATE '2024-05-20', 'N'), 
(5, 'SN-SON-E2', DATE '2024-05-20', 'N'),
(7, 'SN-PS5-F1', DATE '2024-06-01', 'N'), 
(7, 'SN-PS5-F2', DATE '2024-06-01', 'N'),
(7, 'SN-PS5-F3', DATE '2024-06-01', 'N'),
(8, 'SN-NSW-G1', DATE '2024-02-10', 'N'), 
(8, 'SN-NSW-G2', DATE '2024-02-10', 'N'),
(9, 'SN-WAT-H1', DATE '2024-05-15', 'N'), 
(9, 'SN-WAT-H2', DATE '2024-05-15', 'N');

-- 4. Inserimento Ordini
INSERT INTO ordini (id_cliente, data_ordine, prezzo_totale_pagato) VALUES
(1, TO_DATE ('2023-11-15 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 1588.00),
(2, TO_DATE ('2024-02-14 16:45:00', 'YYYY-MM-DD HH24:MI:SS'), 2278.00),
(3, TO_DATE ('2024-03-01 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 1198.00),
(1, TO_DATE ('2024-05-10 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2168.00), 
(2, TO_DATE ('2024-05-22 18:30:00', 'YYYY-MM-DD HH24:MI:SS'), 349.00),  
(3, TO_DATE ('2024-06-05 14:20:00', 'YYYY-MM-DD HH24:MI:SS'), 1788.00), 
(4, TO_DATE ('2024-06-12 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 1239.00), 
(1, TO_DATE ('2024-07-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 549.00),  
(2, TO_DATE ('2024-07-15 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1647.00), 
(4, TO_DATE ('2024-07-20 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 1068.00);

-- 5. Inserimento Dettagli Ordine
INSERT INTO dettagli_ordine (id_ordine, id_prodotto, prezzo_vendita_effettivo) VALUES
(1, 1, 1239.00),
(1, 6, 349.00),
(4, 17, 1349.00), 
(4, 14, 819.00), 
(5, 21, 349.00),
(6, 23, 549.00), 
(6, 10, 1239.00),
(7, 11, 1239.00),
(8, 24, 549.00),
(9, 25, 549.00), 
(9, 18, 549.00), 
(9, 19, 549.00),
(10, 19, 719.00), 
(10, 26, 349.00),
(2, 2, 1239.00),
(2, 1039.00),
(3, 4, 929.00),
(3, 9, 269.00);

-- 6. Inserimento Garanzie 
INSERT INTO garanzie (id_prodotto, data_inizio, durata_mesi, stato_garanzia) VALUES
(1, DATE '2023-11-15', 24, 'attiva'),
(2, DATE '2024-02-14', 24, 'attiva'),
(4, DATE '2024-03-01', 24, 'attiva'),
(6, DATE '2023-11-15', 12, 'in assistenza');

COMMIT;