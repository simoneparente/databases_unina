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
FOR  ROW
EXECUTE PROCEDURE v.setInfraction();

INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo)
values ('prova', '1', 9, '2001-01-01', '00:00:00'); -- non infrangono

INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo)
values ('prova', '1', 110, '2001-01-01', '00:00:10'); -- infrangono
