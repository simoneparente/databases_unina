DROP SCHEMA f CASCADE;
CREATE SCHEMA f;

CREATE TABLE f.hashtag (
    Parola VARCHAR(50),

    CONSTRAINT hashtag_pk PRIMARY KEY (parola)
);

CREATE TABLE f.utente(
    CodU INTEGER,
    Nome VARCHAR(50),
    Cognome VARCHAR(50),
    email VARCHAR(50),
    CONSTRAINT utente_pk PRIMARY KEY (codU)
);

CREATE TABLE f.album(
    CodA INTEGER,
    Nome VARCHAR(50),
    Titolo VARCHAR(50),
    Owner INTEGER,
    InAlbum INTEGER,

    CONSTRAINT album_pk PRIMARY KEY (codA),
    CONSTRAINT utente_fk FOREIGN KEY (owner) REFERENCES f.utente(codU)
);

CREATE TABLE f.foto (
    Codf SERIAL,
    Uri VARCHAR(100),
    Titolo VARCHAR(50),
    Owner INTEGER,
    CodAlbum INTEGER,
    Aggiunta TIMESTAMP,
    Rimossa TIMESTAMP,

    CONSTRAINT foto_pk PRIMARY KEY (codf),
    CONSTRAINT album_fk FOREIGN KEY (codalbum) REFERENCES f.album(codA),
    CONSTRAINT utente_fk FOREIGN KEY (owner) REFERENCES f.utente(codU)
);

CREATE TABLE f.tagfoto (
    CodF INTEGER,
    Parola VARCHAR(50),

    CONSTRAINT tagfoto_pk PRIMARY KEY (codf, parola),
    CONSTRAINT foto_fk FOREIGN KEY (codf) REFERENCES f.foto(codf),
    CONSTRAINT hashtag_fk FOREIGN KEY (parola) REFERENCES f.hashtag(parola)
);

CREATE TABLE f.visibile(
    CodProp INTEGER,
    CodUt INTEGER,
    CodA INTEGER,

    CONSTRAINT visibile_pk PRIMARY KEY (codprop, codut, coda),
    CONSTRAINT proprietario_fk FOREIGN KEY (codprop) REFERENCES f.utente(codU),
    CONSTRAINT utente_fk FOREIGN KEY (codut) REFERENCES f.utente(codU),
    CONSTRAINT album_fk FOREIGN KEY (coda) REFERENCES f.album(codA)
);

CREATE TABLE f.log(
    CodU INTEGER,
    CodF INTEGER,
    Time TIMESTAMP,
    Operation VARCHAR(50),

    CONSTRAINT log_pk PRIMARY KEY (codu, codf, time),
    CONSTRAINT utente_fk FOREIGN KEY (codu) REFERENCES f.utente(codU),
    CONSTRAINT foto_fk FOREIGN KEY (codf) REFERENCES f.foto(codf)
);

CREATE TABLE f.tagalbum
(
    CodA INTEGER,
    Parola VARCHAR(50),

    CONSTRAINT tagalbum_pk PRIMARY KEY (coda, parola),
    CONSTRAINT album_fk FOREIGN KEY (coda) REFERENCES f.album(codA),
    CONSTRAINT hashtag_fk FOREIGN KEY (parola) REFERENCES f.hashtag(parola)
);

CREATE TABLE f.temp
(
    CodA INTEGER,
    CONSTRAINT PK_temp PRIMARY KEY (CodA)
);