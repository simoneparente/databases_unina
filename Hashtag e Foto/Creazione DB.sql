--DROP SCHEMA f CASCADE;
CREATE SCHEMA f;

CREATE TABLE f.hashtag (
    Parola VARCHAR(50) NOT NULL,

    CONSTRAINT hashtag_pk PRIMARY KEY (parola)
);

CREATE TABLE f.utente(
                         CodU INTEGER NOT NULL,
                         Nome VARCHAR(50) NOT NULL,
                         Cognome VARCHAR(50) NOT NULL,
                         email VARCHAR(50) NOT NULL,

                         CONSTRAINT utente_pk PRIMARY KEY (codU)
);

CREATE TABLE f.album(
    CodA INTEGER NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Titolo VARCHAR(50) NOT NULL,
    Owner INTEGER NOT NULL,
    InAlbum INTEGER NOT NULL,

    CONSTRAINT album_pk PRIMARY KEY (codA),
    CONSTRAINT utente_fk FOREIGN KEY (owner) REFERENCES f.utente(codU)
);

CREATE TABLE f.foto (
    Codf SERIAL NOT NULL,
    Url VARCHAR(100) NOT NULL,
    Titolo VARCHAR(50) NOT NULL,
    Owner INTEGER NOT NULL,
    CodAlbum INTEGER NOT NULL,
    Aggiunta TIMESTAMP NOT NULL,
    Rimossa TIMESTAMP,

    CONSTRAINT foto_pk PRIMARY KEY (codf),
    CONSTRAINT album_fk FOREIGN KEY (codalbum) REFERENCES f.album(codA),
    CONSTRAINT utente_fk FOREIGN KEY (owner) REFERENCES f.utente(codU)
);

CREATE TABLE f.tagfoto (
    CodF INTEGER NOT NULL,
    Parola VARCHAR(50) NOT NULL,

    CONSTRAINT tagfoto_pk PRIMARY KEY (codf, parola),
    CONSTRAINT foto_fk FOREIGN KEY (codf) REFERENCES f.foto(codf),
    CONSTRAINT hashtag_fk FOREIGN KEY (parola) REFERENCES f.hashtag(parola)
);

CREATE TABLE f.visibile(
    CodProp INTEGER NOT NULL,
    CodUt INTEGER NOT NULL,
    CodA INTEGER NOT NULL,

    CONSTRAINT visibile_pk PRIMARY KEY (codprop, codut, coda),
    CONSTRAINT proprietario_fk FOREIGN KEY (codprop) REFERENCES f.utente(codU),
    CONSTRAINT utente_fk FOREIGN KEY (codut) REFERENCES f.utente(codU)
);

CREATE TABLE f.log(
    CodU INTEGER NOT NULL,
    CodF INTEGER NOT NULL,
    Time TIMESTAMP NOT NULL,
    Operation VARCHAR(50) NOT NULL,

    CONSTRAINT log_pk PRIMARY KEY (codu, codf, time),
    CONSTRAINT utente_fk FOREIGN KEY (codu) REFERENCES f.utente(codU),
    CONSTRAINT foto_fk FOREIGN KEY (codf) REFERENCES f.foto(codf)
);