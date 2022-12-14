/*Si implementi un trigger azionato quando viene inserito
un nuovo articolo. Il trigger cerca la presenza nel sommario dell’articolo delle parole chiave
associate alla rivista dell’articolo. Se viene trovata la presenza di una parola chiave questa
viene memorizzata nella tabella DESCRIZIONE.*/
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