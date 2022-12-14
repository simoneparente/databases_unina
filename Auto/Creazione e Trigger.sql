--I TRIGGER SONO IN FONDO


--DROP SCHEMA v CASCADE;
CREATE SCHEMA v;


CREATE TABLE v.TARIFFE
(
    Ingresso  VARCHAR(32) NOT NULL,
    Uscita    VARCHAR(32) NOT NULL,
    KM        INTEGER NOT NULL,
    Categoria INTEGER NOT NULL,
    Costo     DOUBLE PRECISION NOT NULL,
    CONSTRAINT PK_TARIFFE PRIMARY KEY (Ingresso, Uscita, Categoria)
);

CREATE TABLE v.AUTO
(
    Targa     VARCHAR(10) NOT NULL,
    CODFIS    VARCHAR(16) NOT NULL,
    Categoria INTEGER NOT NULL,
    CONSTRAINT PK_AUTO PRIMARY KEY (Targa)
);


CREATE TABLE v.PCHECK
(
    PuntoCheck    VARCHAR(10) NOT NULL,
    VelocitaMax   INTEGER NOT NULL,

    CONSTRAINT PK_PCHECK PRIMARY KEY (PuntoCheck)
);

CREATE TABLE v.CHECK
(
    PuntoCheck VARCHAR(10) NOT NULL,
    Targa      VARCHAR(10) NOT NULL,
    Velocita   INTEGER NOT NULL,
    Data      DATE NOT NULL,
    Tempo      TIME NOT NULL,
    Infrazione BOOLEAN,

    CONSTRAINT PK_CHECK PRIMARY KEY (PuntoCheck, Targa, Data, Tempo),
    CONSTRAINT FK_PCHECK FOREIGN KEY (PuntoCheck) REFERENCES v.PCHECK (PuntoCheck),
    CONSTRAINT FK_AUTO FOREIGN KEY (Targa) REFERENCES v.AUTO (Targa)
);

CREATE TABLE v.VIAGGIO
(
    CodiceViaggio VARCHAR(10) NOT NULL,
    Targa         VARCHAR(10) NOT NULL,
    DataI         DATE NOT NULL,
    DataF         DATE,
    OraI          TIME NOT NULL,
    OraF          TIME,
    Ingresso      VARCHAR(32) NOT NULL,
    Uscita        VARCHAR(32),
    Tariffa       DOUBLE PRECISION,
    KM            INTEGER,

    CONSTRAINT PK_VIAGGIO PRIMARY KEY (CodiceViaggio),
    CONSTRAINT FK_VIAGGIO_AUTO FOREIGN KEY (Targa) REFERENCES v.AUTO (Targa),
    CONSTRAINT CK_VIAGGIO CHECK (DataF > DataI OR (DataF = DataI AND OraF > OraI)),
    CONSTRAINT CK_VIAGGIO2 CHECK (KM > 0),
    CONSTRAINT CK_VIAGGIO3 CHECK (Tariffa > 0)
);

-----------------------------------------------------------------------------------------------------------------------
--TRIGGER 1
/*
 Si scriva il seguente trigger. Quando viene inserito un
check per un viaggio si controlla se la velocit`a rilevata è
superiore alla velocit`a massima. Se è superiore, si pone a TRUE
 il campo infrazione del CHECK.
 */

CREATE OR REPLACE FUNCTION v.setInfraction() RETURNS trigger AS
$$
    DECLARE
        MAXvelocita v.pcheck.velocitaMAX%TYPE;
        BEGIN
            SELECT velocitaMAX INTO MAXvelocita
                FROM v.pcheck WHERE puntocheck = NEW.puntocheck;

            IF NEW.velocita > MAXvelocita THEN
                UPDATE v.check
                SET infrazione = TRUE WHERE puntocheck = NEW.puntocheck
                    AND targa = NEW.targa
                    AND velocita=NEW.velocita
                    AND data=NEW.data
                    AND tempo=NEW.tempo;
            END IF;
            RAISE NOTICE 'Infrazione: %', new.infrazione;
        RETURN NULL;
        END
$$  LANGUAGE plpgsql;

CREATE or REPLACE TRIGGER Infractions AFTER INSERT ON v.check
FOR EACH ROW
EXECUTE PROCEDURE v.setInfraction();

-----------------------------------------------------------------------------------------------------------------------
--TRIGGER 2
/*Si scriva il seguente trigger. Quando viene aggiornato un
viaggio esprimendo un valore per il casello di uscita si aggiornano anche gli
attributi Km e Tariffa recuperando i valori dalla tabella TARIFFE (la tariffa
dipende da ingresso, uscita e categoria dell’auto).*/

CREATE OR REPLACE FUNCTION v.update_viaggio() RETURNS trigger AS
    $$
    DECLARE
    prezzo v.tariffe.costo%TYPE;
    chilometraggio v.viaggio.KM%TYPE;
    viaggio v.viaggio.codiceviaggio%TYPE:=NEW.codiceviaggio;

    BEGIN
        IF (NEW.uscita IS NOT NULL) THEN --quando viene inserita l'uscita
            SELECT T.costo, T.KM         --salvo il prezzo e i km relativi al viaggio
            INTO prezzo, chilometraggio
        FROM V.AUTO AS A NATURAL JOIN V.viaggio AS V,
             v.tariffe AS T
        WHERE (NEW.uscita=T.uscita)
        AND   (OLD.ingresso=T.ingresso)
        AND   (T.categoria=A.categoria);

            UPDATE v.viaggio
            SET km=chilometraggio, tariffa=prezzo
            WHERE OLD.codiceviaggio=codiceviaggio;
            --RAISE NOTICE 'Old_Viaggio: %', OLD.codiceviaggio;
        END IF;
        RETURN NEW;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Errore';
    END

    $$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER TRIGGER_2 AFTER UPDATE OF uscita ON v.viaggio
    FOR EACH ROW
    EXECUTE PROCEDURE v.update_viaggio();