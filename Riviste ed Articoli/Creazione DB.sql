DROP SCHEMA r CASCADE ;
CREATE SCHEMA r;

CREATE TABLE r.rivista (
    isnn varchar(32),
    titolo varchar(32),
    editore varchar(32),
    periodicita varchar(32),
    CONSTRAINT pk_rivista PRIMARY KEY (isnn)
);


CREATE TABLE r.fascicolo(
    CodF varchar(32),
    isnn varchar(32),
    numero int,
    anno int,
    CONSTRAINT pk_fascicolo PRIMARY KEY (CodF),
    CONSTRAINT fk_fascicolo_rivista FOREIGN KEY (isnn) REFERENCES r.rivista(isnn)
);
CREATE TABLE r.articolo (
    doi varchar(32),
    CodF VARCHAR(32),
    titolo varchar(32),
    autore varchar(32),
    sommario varchar(32),
    PagI INTEGER,
    PagF INTEGER,
    CONSTRAINT pk_articolo PRIMARY KEY (doi),
    CONSTRAINT FK_ARTICOLO_RIVISTA FOREIGN KEY (CodF) REFERENCES r.fascicolo(CodF)
);
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

CREATE TABLE r.accesso(
    CF varchar(32),
    doi varchar(32),
    data date,
    CONSTRAINT pk_accesso PRIMARY KEY (CF,doi,data),
    CONSTRAINT fk_accesso_articolo FOREIGN KEY (doi) REFERENCES r.articolo(doi),
    CONSTRAINT fk_accesso_utente FOREIGN KEY (CF) REFERENCES r.utente(CF)
);


CREATE TABLE r.Descrizione
(
    Parola VARCHAR(32),
    Doi VARCHAR(32),
    CONSTRAINT PK_Descrizione PRIMARY KEY (Parola,Doi),
    CONSTRAINT FK_Descrizione_Articolodoc FOREIGN KEY (Doi) REFERENCES r.Articolo (Doi)
);

CREATE TABLE r.ParoleChiave
(
    Parola VARCHAR(32),
    ISNN VARCHAR(32),

    CONSTRAINT PK_ParoleChiave PRIMARY KEY (Parola, ISNN),
    CONSTRAINT FK_ParoleChiave_ FOREIGN KEY (ISNN) REFERENCES r.rivista(ISNN)
);

------------------------------------------------------------------------------------------------------------------------
--Trigger 1
CREATE OR REPLACE FUNCTION r.trig1() RETURNS TRIGGER AS $$
    DECLARE
        i INTEGER := 0;
        n INTEGER := (SELECT COUNT(*) FROM r.parolechiave NATURAL JOIN fascicolo);
        word r.parolechiave.parola%TYPE;
        cursore CURSOR FOR SELECT p.parola FROM r.parolechiave as p NATURAL JOIN fascicolo as f WHERE r.fascicolo.codf=NEW.codf;

    BEGIN
        OPEN cursore;

        WHILE (i<n) LOOP
            FETCH cursore INTO word;
            IF (NEW.sommario LIKE '%'|| word || '%') THEN
                INSERT INTO r.descrizione(parola, doi)
                values (word, NEW.doi);
            END IF;
            i = i + 1;
        END LOOP ;
        CLOSE cursore;
        RETURN NEW;
    END;
$$LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER TRIGGER_1  AFTER INSERT ON r.articolo
FOR EACH ROW
EXECUTE PROCEDURE r.trig1();

------------------------------------------------------------------------------------------------------------------------
--Trigger 2
