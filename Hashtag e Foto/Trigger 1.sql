/*
Si scriva una funzione PLSQL che riceve in ingresso l’identificativo
di un album e che restituisce una stringa contenente tutti i tag associati all’album e agli album in
esso contenuti (ad ogni livello di profondit`a) senza ripetizioni.
 */
--DROP TABLE f.temp CASCADE;
CREATE OR REPLACE  PROCEDURE f.funz_1(input f.album.coda%type) AS
$$
    DECLARE
        count INTEGER:= (SELECT COUNT(DISTINCT parola) FROM f.temp NATURAL JOIN f.tagalbum);
        cursore CURSOR FOR SELECT DISTINCT parola FROM f.temp NATURAL JOIN f.tagalbum;
        parola VARCHAR(50);
        output VARCHAR(500);
        BEGIN
            OPEN cursore;
            FOR i IN 1..count LOOP
                FETCH cursore INTO parola;
                RAISE NOTICE 'parola:{%}', parola;
                if(i=1) THEN output=CONCAT(output, parola);
                    ELSE
                    output=CONCAT(output, ', ', parola);
                        END IF;

                RAISE NOTICE 'output in loop:{%}', output;
                end loop;
            RAISE NOTICE 'output:{%}', output;
            END
$$
LANGUAGE plpgsql;

CALL f.funz_1(1);