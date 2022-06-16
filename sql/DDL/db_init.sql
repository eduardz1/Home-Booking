-- @block initialize the database
-- CREATE DATABASE home_booking;
DROP TABLE IF EXISTS Utente, 
                     Telefono,
                     Pagamento,
                     Prenotazione,
                     Alloggio,
                     Recensione,
                     Commento,
                     Lista,
                     Contenuto,
                     Servizio,
                     Foto;

DROP TYPE IF EXISTS StatoPrenotazione,
                    CategoriaRecensione,
                    TipologiaAlloggio;
-- @endblock

-- @block initialize the enums
CREATE TYPE StatoPrenotazione AS ENUM ('Prenotato', 'Confermato', 'Rifiutato', 'Cancellato', 'Cancellato dall" host');
CREATE TYPE TipologiaAlloggio AS ENUM ('Appartamento', 'Stanza singola', 'Stanza condivisa');
CREATE TYPE CategoriaRecensione AS ENUM ('Host', 'Utente', 'Alloggio');

-- @endblock



-- @block initialize Utente
-- Superhost: Non si può essere superhost se non si è host
-- Verificato: Non si può essere verificati se non si ha la carta di identità
CREATE TABLE Utente (
  Nome VARCHAR(45) NOT NULL,
  Cognome VARCHAR(45) NOT NULL,
  Password VARCHAR(40) NOT NULL,
  Email VARCHAR(45),
  DataRegistrazione TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Host BOOLEAN DEFAULT FALSE NOT NULL,
  Superhost BOOLEAN DEFAULT FALSE NOT NULL,
  Verificato BOOLEAN DEFAULT FALSE NOT NULL,
  CartaIdentita VARCHAR(30),	
  PRIMARY KEY (Email),
  Constraint user_valid_host CHECK ((Superhost = TRUE AND Host = TRUE) OR Superhost = FALSE),
  Constraint user_valid_verified CHECK ((Verificato = TRUE AND CartaIdentita IS NOT NULL) OR Verificato = FALSE),
  Constraint user_valid_email CHECK (email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
);

-- @block initialize Telefono
CREATE TABLE Telefono (
    Utente VARCHAR(45) NOT NULL,
    Numero VARCHAR(15) NOT NULL,
    Prefisso VARCHAR(5) NOT NULL,
    FOREIGN KEY (Utente) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (Utente, Numero)
);

-- @block initialize Pagamento
CREATE TABLE Pagamento (
    Utente VARCHAR(45) NOT NULL,
    Numero VARCHAR(16) NOT NULL CHECK (char_length(Numero) = 16),
    Prefisso VARCHAR(30) NOT NULL,
    FOREIGN KEY (Utente) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (Utente, Numero)
);

-- @block initialize Alloggio 
-- Nome: Si potrebbe creare un indice su Nome per velocizzare le operazioni di ricerca sull'alloggio
-- Host: Può essere NULL per supportare le casistiche in cui un host è stato cancellato dal sistema
CREATE TABLE Alloggio (
  IDAlloggio UUID NOT NULL DEFAULT gen_random_uuid(),
  Nome VARCHAR(45) NOT NULL, 
  Host VARCHAR(45),
  Descrizione TEXT,
  Tipologia TipologiaAlloggio NOT NULL,
  OrarioCheckIn TIME NOT NULL,
  OrarioCheckOut TIME NOT NULL,
  Costo NUMERIC NOT NULL CHECK (Costo > 0),
  CostoPulizia NUMERIC DEFAULT 0 CHECK (CostoPulizia >= 0),
  CAP INT NOT NULL CHECK (CAP > 0),
  Comune VARCHAR(45) NOT NULL,
  Civico INT NOT NULL CHECK (Civico > 0),
  Via VARCHAR(45) NOT NULL,
  FOREIGN KEY (Host) REFERENCES Utente(Email) ON DELETE SET NULL ON UPDATE CASCADE,
  PRIMARY KEY (IDAlloggio)
);

-- @block initialize Prenotazione 
-- IDAlloggio: Può essere NULL per supportare le casistiche in cui un alloggio è stato cancellato dal sistema
-- Il check su DataInizio > CURRENT_TIMESTAMP potrebbe non permettere inserimenti massivi futuri da parte di un DBA,
--  in caso di manutenzione: meglio evitare questo tipo di controllo
CREATE TABLE Prenotazione (
  IDPrenotazione UUID NOT NULL DEFAULT gen_random_uuid(),
  IDAlloggio UUID,
  Richiedente VARCHAR(45) NOT NULL,
  DataInizio TIMESTAMP NOT NULL,
  DataFine TIMESTAMP NOT NULL,
  Soggiorno BOOLEAN DEFAULT FALSE NOT NULL,
  NumeroOspiti INT NOT NULL CHECK (NumeroOspiti >= 0),
  Stato StatoPrenotazione NOT NULL DEFAULT 'Prenotato',
  Visibile BOOLEAN DEFAULT FALSE NOT NULL,
  FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE SET NULL,
  FOREIGN KEY (Richiedente) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (IDPrenotazione),
  Constraint prenotazione_start_before_end CHECK (DataInizio < DataFine)
  -- CHECK (DataInizio > CURRENT_TIMESTAMP)
);

-- @block initialize Recensione 
-- IDPrenotazione: Una prenotazione non può essere cancellata dal sistema, a meno di attività manuali sul db
CREATE TABLE Recensione (
    IDRecensione UUID NOT NULL DEFAULT gen_random_uuid(),
    IDPrenotazione UUID NOT NULL,
    Autore VARCHAR(45) NOT NULL,
    DataRecensione DATE NOT NULL,
    ValutazionePosizione INT CHECK(ValutazionePosizione >= 0 AND ValutazionePosizione <= 5),
    ValutazionePulizia INT CHECK(ValutazionePulizia >= 0 AND ValutazionePulizia <= 5),
    ValutazioneQualitaPrezzo INT CHECK(ValutazioneQualitaPrezzo >= 0 AND ValutazioneQualitaPrezzo <= 5),
    ValutazioneComunicazione INT CHECK(ValutazioneComunicazione >= 0 AND ValutazioneComunicazione <= 5),
    Corpo TEXT,
    Categoria TEXT NOT NULL,
    FOREIGN KEY (IDPrenotazione) REFERENCES Prenotazione(IDPrenotazione) ON DELETE CASCADE,
    FOREIGN KEY (Autore) REFERENCES Utente(Email) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY (IDRecensione),
    Constraint recensione_valid_category CHECK (
      (Categoria = 'Host' AND ValutazionePosizione IS NULL AND ValutazionePulizia IS NULL AND ValutazioneQualitaPrezzo IS NUll) OR 
      (Categoria = 'Utente' AND ValutazionePosizione IS NULL AND ValutazionePulizia IS NULL AND ValutazioneQualitaPrezzo IS NUll AND ValutazioneComunicazione IS NULL) OR
      (Categoria = 'Alloggio' AND ValutazioneComunicazione IS NULL))
);

-- @block initialize Commento 
CREATE TABLE Commento (
    IDCommento UUID NOT NULL DEFAULT gen_random_uuid(),
    IDRecensione UUID NOT NULL,
    DataCommento TIMESTAMP NOT NULL,
    Autore VARCHAR(45) NOT NULL,
    Corpo TEXT,
    FOREIGN KEY (IDRecensione) REFERENCES Recensione(IDRecensione) ON DELETE CASCADE,
    FOREIGN KEY (Autore) REFERENCES Utente(Email) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY (IDCommento)
);

-- @block initialize Lista
CREATE TABLE Lista (
    IDLista UUID NOT NULL DEFAULT gen_random_uuid(),
    Nome VARCHAR(45) NOT NULL,
    Descrizione TEXT,
    Autore VARCHAR(45) NOT NULL,
    FOREIGN KEY (Autore) REFERENCES Utente(Email) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (IDLista)
);

-- @block initialize Contenuto
CREATE TABLE Contenuto (
    IDLista UUID NOT NULL,
    IDAlloggio UUID NOT NULL,
    FOREIGN KEY (IDLista) REFERENCES Lista(IDLista) ON DELETE CASCADE,
    FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE CASCADE,
    PRIMARY KEY (IDLista, IDAlloggio)
);

-- @block initialize Foto
CREATE TABLE Foto (
    Path TEXT,
    IDAlloggio UUID NOT NULL,
    FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE CASCADE,
    PRIMARY KEY (Path, IDAlloggio)
);

-- @block initialize Servizio
CREATE TABLE Servizio (
    TipoServizio TEXT,
    IDAlloggio UUID NOT NULL,
    FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE CASCADE,
    PRIMARY KEY (TipoServizio, IDAlloggio)
);
