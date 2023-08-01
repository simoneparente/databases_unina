DROP SCHEMA IF EXISTS r CASCADE ;
CREATE SCHEMA IF NOT EXISTS r;

CREATE TABLE r.rivista (
    isnn VARCHAR(32),
    titolo VARCHAR(32),
    editore VARCHAR(32),
    periodicita VARCHAR(32),
    CONSTRAINT pk_rivista PRIMARY KEY (isnn)
);
CREATE TABLE r.fascicolo(
    CodF VARCHAR(32),
    isnn VARCHAR(32),
    numero int,
    anno int,
    CONSTRAINT pk_fascicolo PRIMARY KEY (CodF),
    CONSTRAINT fk_fascicolo_rivista FOREIGN KEY (isnn) REFERENCES r.rivista(isnn)
);
CREATE TABLE r.articolo (
    doi      VARCHAR(32),
    CodF     VARCHAR(32),
    titolo   VARCHAR(32),
    autore   VARCHAR(32),
    sommario VARCHAR(32),
    PagI     INTEGER,
    PagF     INTEGER,
    CONSTRAINT pk_articolo         PRIMARY KEY (doi),
    CONSTRAINT FK_ARTICOLO_RIVISTA FOREIGN KEY (CodF) REFERENCES r.fascicolo(CodF)
);
CREATE TABLE r.Profilo
(
    CodProfilo VARCHAR(32),
    Tipo       VARCHAR(32),
    MaxGiorno  INTEGER,
    MaxMese    INTEGER,
    CONSTRAINT PK_Profilo PRIMARY KEY (CodProfilo)
);
CREATE TABLE r.Utente
(
    CF          VARCHAR(32),
    email       VARCHAR(32),
    CodProfilo  VARCHAR(32),
    Nome        VARCHAR(32),
    Cognome     VARCHAR(32),
    DataNascita DATE,
    CONSTRAINT PK_Utente         PRIMARY KEY (CF),
    CONSTRAINT FK_Utente_Profilo FOREIGN KEY (CodProfilo) REFERENCES r.Profilo (CodProfilo)
);

CREATE TABLE r.accesso(
    CF   VARCHAR(32),
    doi  VARCHAR(32),
    data DATE,
    CONSTRAINT pk_accesso          PRIMARY KEY (CF,doi,data),
    CONSTRAINT fk_accesso_articolo FOREIGN KEY (doi) REFERENCES r.articolo(doi),
    CONSTRAINT fk_accesso_utente   FOREIGN KEY (CF)  REFERENCES r.utente(CF)
);
CREATE TABLE r.Descrizione
(
    Parola VARCHAR(32),
    Doi    VARCHAR(32),
    CONSTRAINT FK_Descrizione_Articolodoc FOREIGN KEY (Doi) REFERENCES r.Articolo (Doi)
);
CREATE TABLE r.ParoleChiave
(
    Parola VARCHAR(32),
    ISNN   VARCHAR(32),
    CONSTRAINT PK_ParoleChiave PRIMARY KEY (Parola, ISNN),
    CONSTRAINT FK_ParoleChiave_ FOREIGN KEY (ISNN) REFERENCES r.rivista(ISNN)
);