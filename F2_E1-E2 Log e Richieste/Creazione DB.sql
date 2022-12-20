DROP SCHEMA l CASCADE ;
CREATE SCHEMA l;

CREATE TABLE l.risorsa(
    CodRisorsa INTEGER  ,
    Locazione VARCHAR(50)   ,
    Valore VARCHAR(50)   ,
    STATO VARCHAR(50)   ,

    CONSTRAINT PK_risorsa PRIMARY KEY (CodRisorsa)
);

CREATE TABLE l.richieste(
    CodTransazione INTEGER   ,
    Tempo INTEGER   ,
    TipoAccesso VARCHAR(50)   ,
    CodRisorsa INTEGER   ,

    CONSTRAINT PK_richieste PRIMARY KEY (CodTransazione),
    CONSTRAINT FK_richieste_risorsa FOREIGN KEY (CodRisorsa) REFERENCES l.risorsa(CodRisorsa)
);

CREATE TABLE l.assegnazione(
    CodTransazione INTEGER,
    Tempo INTEGER,
    TipoAccesso VARCHAR(50),
    CodRisorsa INTEGER,

    CONSTRAINT PK_assegnazione PRIMARY KEY (CodTransazione),
    CONSTRAINT FK_assegnazione_richieste FOREIGN KEY (CodTransazione) REFERENCES l.richieste(CodTransazione),
    CONSTRAINT FK_assegnazione_risorsa FOREIGN KEY (CodRisorsa) REFERENCES l.risorsa(CodRisorsa)
);

CREATE TABLE l.log(
    Cod INTEGER  ,
    Operazione VARCHAR(50)  ,
    CodRisorsa INTEGER  ,
    ValorePrima VARCHAR(50)  ,
    ValoreDopo VARCHAR(50)  ,
    CodTransazione INTEGER  ,
    TimeStamp INTEGER  ,

    CONSTRAINT log_pk PRIMARY KEY (Cod),
    CONSTRAINT risorse_fk FOREIGN KEY (CodRisorsa) REFERENCES l.risorsa(CodRisorsa)
);