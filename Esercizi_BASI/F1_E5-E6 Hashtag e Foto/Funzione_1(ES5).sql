/*
Si scriva una funzione PLSQL che riceve in ingresso l’identificativo
di un album e che restituisce una stringa contenente tutti i tag associati all’album e agli album in
esso contenuti (ad ogni livello di profondit`a) senza ripetizioni.
 */
INSERT INTO f.temp(coda)
VALUES (1),
       (11),
       (12),
       (13);

DROP TABLE f.temp CASCADE;
CREATE OR REPLACE  FUNCTION f.Tag_Associati(input f.album.coda%type)RETURNS VARCHAR(500) AS
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
                if(i=1) THEN output=CONCAT(output, parola);
                    ELSE
                    output=CONCAT(output, ', ', parola);
                        END IF;
                end loop;
            RETURN output;
            END
$$
LANGUAGE plpgsql;

SELECT f.Tag_Associati(1);