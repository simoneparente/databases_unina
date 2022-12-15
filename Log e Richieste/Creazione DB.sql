--DROP SCHEMA l CASCADE ;
CREATE SCHEMA l;

CREATE TABLE l.risorsa(
    CodRisorsa INTEGER NOT NULL ,
    Locazione VARCHAR(50) NOT NULL ,
    Valore VARCHAR(50) NOT NULL ,
    STATO VARCHAR(50) NOT NULL ,

    CONSTRAINT PK_risorsa PRIMARY KEY (CodRisorsa)
);

CREATE TABLE l.richieste(
    CodTransazione INTEGER NOT NULL ,
    Tempo TIMESTAMP NOT NULL ,
    TipoAccesso VARCHAR(50) NOT NULL ,
    CodRisorsa INTEGER NOT NULL ,

    CONSTRAINT PK_richieste PRIMARY KEY (CodTransazione),
    CONSTRAINT FK_richieste_risorsa FOREIGN KEY (CodRisorsa) REFERENCES l.risorsa(CodRisorsa)
);

CREATE TABLE l.assegnazione(
    CodTransazione INTEGER NOT NULL ,
    Tempo TIMESTAMP NOT NULL ,
    TipoAccesso VARCHAR(50) NOT NULL ,
    CodRisorsa INTEGER NOT NULL ,

    CONSTRAINT PK_assegnazione PRIMARY KEY (CodTransazione),
    CONSTRAINT FK_assegnazione_richieste FOREIGN KEY (CodTransazione) REFERENCES l.richieste(CodTransazione),
    CONSTRAINT FK_assegnazione_risorsa FOREIGN KEY (CodRisorsa) REFERENCES l.risorsa(CodRisorsa)
);

CREATE TABLE l.log(
    Cod INTEGER NOT NULL,
    Operazione VARCHAR(50) NOT NULL,
    CodRisorsa INTEGER NOT NULL,
    ValorePrima VARCHAR(50) NOT NULL,
    ValoreDopo VARCHAR(50) NOT NULL,
    CodTransazione INTEGER NOT NULL,
    TimeStamp TIMESTAMP NOT NULL,

    CONSTRAINT log_pk PRIMARY KEY (Cod),
    CONSTRAINT richieste_fk FOREIGN KEY (CodTransazione) REFERENCES l.richieste(CodTransazione),
    CONSTRAINT risorse_fk FOREIGN KEY (CodRisorsa) REFERENCES l.risorsa(CodRisorsa)
);