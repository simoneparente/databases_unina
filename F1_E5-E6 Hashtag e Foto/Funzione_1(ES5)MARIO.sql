--ES5 MARIO PENNA
CREATE OR REPLACE PROCEDURE f.f2_figli(tagalbum f.album.coda%TYPE) AS $$
    DECLARE
        figlio f.album.coda%TYPE;
    BEGIN
        FOR figlio IN (SELECT codA FROM f.album AS A WHERE A.inalbum=tagalbum) LOOP

            CALL f.f2_figli(figlio);
            RAISE NOTICE 'figlio: %', figlio;
            INSERT INTO f.tmp(codA) values (figlio);
        end loop;
    end
$$ language plpgsql;


CREATE OR REPLACE FUNCTION f.f1_rec(IN Input f.album.coda%type)RETURNS VARCHAR(500) AS $$
    DECLARE
        stringa f.tagalbum.parola%TYPE;
        output VARCHAR(500);
        counter INTEGER = 1;
        BEGIN
            CREATE TABLE f.tmp(codA INTEGER);
            INSERT INTO f.tmp VALUES (Input);
            CALL f.f2_figli(Input);
            FOR stringa IN (SELECT DISTINCT parola FROM f.tmp NATURAL JOIN f.tagalbum) LOOP
                IF(counter>1) THEN
                    output=CONCAT(output, ', ', stringa);
                ELSE
                    output=stringa;
                END IF;
                    counter = counter + 1;
            END LOOP;
            DROP TABLE f.tmp CASCADE;
            RETURN output;
        END
$$ LANGUAGE plpgsql;

SELECT f.f1_rec(1);