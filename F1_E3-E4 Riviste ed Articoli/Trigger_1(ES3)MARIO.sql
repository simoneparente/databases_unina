--ES3 Mario Penna
CREATE OR REPLACE FUNCTION r.funz_1() RETURNS TRIGGER AS $$
    DECLARE
        word r.parolechiave.parola%TYPE;
        cursore CURSOR FOR SELECT parola FROM r.fascicolo NATURAL JOIN r.parolechiave
                           WHERE r.fascicolo.codf=NEW.codf;
        i int:=0;
        n int:=(SELECT COUNT(*) FROM r.fascicolo NATURAL JOIN r.parolechiave);
    BEGIN
        OPEN cursore;
        WHILE (i<n) LOOP
            FETCH cursore into word;
            IF(NEW.sommario LIKE '%' || word || '%') THEN
                INSERT INTO r.descrizione(parola, doi)
                values (word, new.doi);
            END IF;
            i=i+1;
            END LOOP;
        CLOSE cursore;
        RETURN NEW;
    END ;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigg_1 AFTER INSERT ON r.articolo
FOR EACH ROW
EXECUTE PROCEDURE r.funz_1();