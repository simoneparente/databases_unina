CREATE SCHEMA r;
CREATE TABLE rivista (
    issn varchar(32),
    titolo varchar(32),
    editore varchar(32),
    periodicita varchar(32),
    CONSTRAINT pk_rivista PRIMARY KEY (issn)
);

CREATE TABLE articolo (
    doi varchar(32),
    titolo varchar(32),
    autore varchar(32),
    sommario varchar(32),
    PagI int,
    PagF int,
    CONSTRAINT pk_articolo PRIMARY KEY (doi)
);

CREATE TABLE fascicolo(
    CodF varchar(32),
    isnn varchar(32),
    numero int,
    anno int,
    CONSTRAINT pk_fascicolo PRIMARY KEY (CodF)
);

CREATE TABLE accesso(
    CF varchar(32),
    doi varchar(32),
    data date
);