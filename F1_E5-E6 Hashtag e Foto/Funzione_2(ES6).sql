/*
  Usando SQL DINAMICO si scriva una funzione che riceve in ingresso
una lista di tag separati dal carattere @ e che restituisce una stringa degli
uri delle foto (separati da @) a cui sono associati tutti i tag passati per parametro
 */
CREATE OR REPLACE PROCEDURE f.funz2(input VARCHAR(500)) AS
$$
    DECLARE
        count INTEGER;
        comando VARCHAR(500);
        cursoreuri CURSOR FOR (SELECT f.uri, count(*) FROM f.tagfoto NATURAL JOIN f.foto f GROUP BY f.uri);
        cursore CURSOR FOR
        (SELECT uri, parola
            FROM f.tagfoto NATURAL JOIN f.foto
            ORDER BY uri);
    BEGIN

        IF EXISTS() THEN
            count=count+1;
        end if;
    END;
$$

SELECT *
FROM f.tagfoto AS TF NATURAL JOIN f.foto
WHERE parola='prova11' or parola='provatabelle1e3'