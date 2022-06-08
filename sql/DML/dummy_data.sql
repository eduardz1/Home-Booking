-- @block Dump dei dati per la tabella Utente --
INSERT INTO Utente (Nome, Cognome, Email, Password, Host) VALUES ('Marco', 'Molica', 'marco.molica@edu.unito.to', 'a', TRUE);
INSERT INTO Utente (Nome, Cognome, Email, Password) VALUES ('Iman', 'Solaih', 'iman.solaih@edu.unito.to', 'a');
INSERT INTO Utente (Nome, Cognome, Email, Password, Host) VALUES ('Eduard', 'Occhipinti', 'eduard.occhipinti@edu.unito.to', 'a', TRUE);
INSERT INTO Utente (Nome, Cognome, Email, Password) VALUES ('Host', 'Incredibile', 'host.incredibile@edu.unito.to', 'a');
INSERT INTO Utente (Nome, Cognome, Email, Password) VALUES ('Host', 'Sensazionale', 'host.sensazionale@edu.unito.to', 'a');
INSERT INTO Utente (Nome, Cognome, Email, Password) VALUES ('Super', 'Hostone', 'superhostone@edu.unito.to', 'a');

-- @block Dump dei dati per la tabella Telefono --
INSERT INTO Telefono (Utente, Numero, Prefisso) VALUES ('marco.molica@edu.unito.to', '3465432121', '+39');
INSERT INTO Telefono (Utente, Numero, Prefisso) VALUES ('marco.molica@edu.unito.to', '3392516621', '+39');

-- @block Dump dei dati per la tabella Pagamento --
INSERT INTO Pagamento (Utente, Numero, Prefisso) VALUES ('marco.molica@edu.unito.to', '0000012345678901', 'Visa');
INSERT INTO Pagamento (Utente, Numero, Prefisso) VALUES ('iman.solaih@edu.unito.to', '2141512512231231', 'American Express');

-- @block Dump dei dati per la tabella Alloggio --
INSERT INTO Alloggio (Nome, Host, Descrizione, Tipologia, OrarioCheckIn, OrarioCheckOut, Costo, CostoPulizia, CAP, Comune, Civico, Via) 
VALUES ('Casa di Emme', 
        'marco.molica@edu.unito.to', 
        'Un alloggio sempre disponibile per lo studio in compagnia e la realizzazione del progetto di db',
        'Appartamento', '18:00:00', '23:59:00',
        1,0,
        10129,'Torino', 3, 'Via Peano');

INSERT INTO Alloggio (Nome, Host, Descrizione, Tipologia, OrarioCheckIn, OrarioCheckOut, Costo, CostoPulizia, CAP, Comune, Civico, Via) 
VALUES ('Casa di Eduard', 
        'eduard.occhipinti@edu.unito.to', 
        'Stanza molto tranquilla e confortevole, ottima per studenti del dipartimento di informatica',
        'Stanza condivisa', '09:00:00', '22:00:00',
        10,5,
        10129,'Torino', 12, 'Via non ricordo indirizzo');

-- @block Dump dei dati per la tabella Prenotazione --
INSERT INTO Prenotazione (Richiedente, IDAlloggio, DataInizio, DataFine, NumeroOspiti, Stato)
VALUES ('marco.molica@edu.unito.to', 2, '2022-01-05', '2023-01-05', 0, 'Confermato');

INSERT INTO Prenotazione (Richiedente, IDAlloggio, DataInizio, DataFine, NumeroOspiti, Stato, Soggiorno)
VALUES ('marco.molica@edu.unito.to', 2, '2021-01-01', '2022-01-01', 0, 'Confermato', TRUE);

INSERT INTO Prenotazione (Richiedente, IDAlloggio, DataInizio, DataFine, NumeroOspiti)
VALUES ('iman.solaih@edu.unito.to', 1, '2022-10-06', '2023-10-13', 0);

-- @block Dump dei dati per la tabella Recensione --
INSERT INTO Recensione (IDPrenotazione,Autore,DataRecensione, ValutazionePosizione, ValutazionePulizia, Corpo, Categoria)
VALUES ( 2, 'marco.molica@edu.unito.to', '2022-01-05', 4, 5, 'Ottima casa, ci tornerò', 'Alloggio');
 
INSERT INTO Recensione (IDPrenotazione,Autore,DataRecensione, ValutazioneComunicazione, Corpo, Categoria)
VALUES ( 2, 'marco.molica@edu.unito.to', '2022-01-05', 2, 'Ho avuto molte difficoltà a comunicare con Eduard perchè parla spesso russo', 'Host');

INSERT INTO Recensione (IDPrenotazione,Autore,DataRecensione, Corpo, Categoria)
VALUES ( 2, 'eduard.occhipinti@edu.unito.to', '2022-01-05', 'Marco è stato un grande ospite, mi ha aiutato in tutti i progetti', 'Utente');

-- @block Dump dei dati per la tabella Commento --
INSERT INTO Commento (IDrecensione, DataCommento, Autore, Corpo) 
VALUES (1, '2022-01-06 12:04:21', 'eduard.occhipinti@edu.unito.to', 'Sono molto contento che sia stato tutto di tuo gradimento');
 
INSERT INTO Commento (IDrecensione, DataCommento, Autore, Corpo) 
VALUES (1, '2022-01-06 13:01:18', 'marco.molica@edu.unito.to', 'Grazie, lo sono anche io');

-- @block Dump dei dati per la tabella Commento --
INSERT INTO Lista (Nome, Descrizione, Autore) VALUES ('Lista1', 'Lista di prova', 'marco.molica@edu.unito.to');

-- @block Dump dei dati per la tabella Contenuto --
INSERT INTO Contenuto (IDLista, IDAlloggio) VALUES (1, 1);
INSERT INTO Contenuto (IDLista, IDAlloggio) VALUES (1, 2);









-- useful, da rimuovere
-- INSERT INTO alloggio (Nome, Host, Descrizione, Tipologia, OrarioCheckIn, OrarioCheckOut, Costo, CostoPulizia, CAP, Comune, Civico, Via) 
-- VALUES ('A', 
--         'eduard.occhipinti@edu.unito.to', 
--         'Stanza molto tranquilla e confortevole, ottima per studenti del dipartimento di informatica',
--         'Stanza condivisa', '09:00:00', '22:00:00',
--         10,5,
--         10129,'Torino', 15, 'Via non ricordo indirizzo');

-- INSERT INTO alloggio (Nome, Host, Descrizione, Tipologia, OrarioCheckIn, OrarioCheckOut, Costo, CostoPulizia, CAP, Comune, Civico, Via) 
-- VALUES ('B', 
--         'eduard.occhipinti@edu.unito.to', 
--         'Stanza molto tranquilla e confortevole, ottima per studenti del dipartimento di informatica',
--         'Stanza condivisa', '09:00:00', '22:00:00',
--         10,5,
--         10129,'Torino', 15, 'Via non ricordo indirizzo');

-- Delete from utente where TRUE
-- Delete from alloggio where TRUE
-- Delete from prenotazione where TRUE

-- UPDATE utente SET Host = TRUE WHERE Email = 'eduard.occhipinti@edu.unito.to';

