CREATE SCHEMA r;

CREATE TABLE r.Profilo
(
    CodProfilo VARCHAR(32),
    Tipo VARCHAR(32),
    MaxGiorno INTEGER,
    MaxMese INTEGER,
    CONSTRAINT PK_Profilo PRIMARY KEY (CodProfilo)
);

CREATE TABLE r.Utente
(
    CF VARCHAR(32),
    email VARCHAR(32),
    CodProfilo VARCHAR(32),
    Nome VARCHAR(32),
    Cognome VARCHAR(32),
    DataNascita DATE,
    CONSTRAINT PK_Utente PRIMARY KEY (CF),
    CONSTRAINT FK_Utente_Profilo FOREIGN KEY (CodProfilo) REFERENCES r.Profilo (CodProfilo)
);

CREATE TABLE r.Descrizione
(
    Parola VARCHAR(32),
    Doi VARCHAR(32),
    CONSTRAINT FK_Descrizione_Articolodoc FOREIGN KEY (Doi) REFERENCES r.Articolo (Doi)
);

CREATE TABLE r.ParoleChiave
(
    Parola VARCHAR(32),
    ISNN VARCHAR(32),

    CONSTRAINT FK_ParoleChiave_ FOREIGN KEY (ISNN) REFERENCES r.Articolo (ISNN)
);

