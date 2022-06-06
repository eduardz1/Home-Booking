-- @block initialize the database
CREATE DATABASE IF NOT EXISTS home_booking;
-- @endblock

-- @block initialize the tables
CREATE TABLE Utente (
  Nome VARCHAR(45) NOT NULL,
  Cognome VARCHAR(45) NOT NULL,
  Email VARCHAR(45) NOT NULL,
  Host BOOLEAN NOT NULL,
  Superhost BOOLEAN NOT NULL,
  PRIMARY KEY (Email)
);

CREATE TABLE Alloggio (
  IDAlloggio INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(45) NOT NULL,
  Host VARCHAR(45) NOT NULL,
  Tipologia VARCHAR(45) NOT NULL,
  OrarioCheckIn DATETIME NOT NULL,
  OrarioCheckOut DATETIME NOT NULL,
  Costo INT NOT NULL,
  CostoPulizia INT DEFAULT 0,
  CAP INT,
  Comune VARCHAR(45),
  Civico INT,
  Via VARCHAR(45),
  FOREIGN KEY (Host) REFERENCES Utente(Email) ON DELETE CASCADE,
  PRIMARY KEY (IDAlloggio)
);

CREATE TABLE Prenotazione (
  IDPrenotazione INT NOT NULL AUTO_INCREMENT,
  Richiedente VARCHAR(45) NOT NULL,
  IDAlloggio INT NOT NULL,
  DataInizio DATETIME NOT NULL,
  DataFine DATETIME NOT NULL,
  Soggiorno BOOLEAN NOT NULL,
  NumeroOspiti INT NOT NULL,
  Stato ENUM('Prenotato', 'Confermato', 'Rifiutato', 'Cancellato', 'Cancellato dall" host') NOT NULL,
  FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE CASCADE,
  FOREIGN KEY (Richiedente) REFERENCES Utente(Email) ON DELETE CASCADE,
  PRIMARY KEY (IDPrenotazione)
);

CREATE TABLE Recensione (
    IDRecensione INT NOT NULL AUTO_INCREMENT,
    Autore VARCHAR(45) NOT NULL,
    IDPrenotazione INT NOT NULL,
    Data_ DATE NOT NULL,
    ValutazionePosizione INT,-- set >= 0 and <= 5
    ValutazionePulizia INT,-- set >= 0 and <= 5
    ValutazioneQualitaPrezzo INT,-- set >= 0 and <= 5
    ValutazioneComunicazione INT,-- set >= 0 and <= 5
    Corpo TEXT,
    FOREIGN KEY (IDPrenotazione) REFERENCES Prenotazione(IDPrenotazione) ON DELETE CASCADE,
    FOREIGN KEY (Autore) REFERENCES Utente(Email) ON DELETE CASCADE,
    PRIMARY KEY (IDRecensione)
);

CREATE TABLE Commento (
    IDCommento INT NOT NULL AUTO_INCREMENT,
    Data_ DATE NOT NULL,
    IDRecensione INT NOT NULL,
    Autore VARCHAR(45) NOT NULL,
    Corpo TEXT,
    FOREIGN KEY (IDRecensione) REFERENCES Recensione(IDRecensione) ON DELETE CASCADE,
    FOREIGN KEY (Autore) REFERENCES Utente(Email) ON DELETE CASCADE,
    PRIMARY KEY (IDCommento)
);

CREATE TABLE Lista (
    IDLista INT NOT NULL AUTO_INCREMENT,
    Nome VARCHAR(45) NOT NULL,
    Descrizione TEXT,
    Autore VARCHAR(45) NOT NULL,
    FOREIGN KEY (Autore) REFERENCES Utente(Email) ON DELETE CASCADE,
    PRIMARY KEY (IDLista)
);

CREATE TABLE Contenuto (
    IDLista INT NOT NULL,
    IDAlloggio INT NOT NULL,
    FOREIGN KEY (IDLista) REFERENCES Lista(IDLista) ON DELETE CASCADE,
    FOREIGN KEY (IDAlloggio) REFERENCES Alloggio(IDAlloggio) ON DELETE CASCADE,
    PRIMARY KEY (IDLista, IDAlloggio)
);
-- @endblock