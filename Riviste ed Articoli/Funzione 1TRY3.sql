/*
 Si scriva una funzione in SQL DINAMICO che riceve in
ingresso una stringa di parole chiave separate dal carattere +. La funzione restituisce la stringa
di doi degli articoli a cui sono associate TUTTE le parole chiave nella stringa.
 */



CREATE OR REPLACE PROCEDURE r.riproviamoci(stringa VARCHAR(100)) AS
$$
DECLARE
    paroladastringa r.descrizione.parola%TYPE;
    numeroparolestringa INTEGER;
    cursore CURSOR FOR SELECT parola, doi FROM descrizione;
BEGIN
    stringa=replace(stringa, '+', '@');
    RAISE NOTICE 'Stringa: {%}', stringa;

    numeroparolestringa=regexp_count(stringa, '@')+1;
    RAISE NOTICE 'N parole stringa: (%)', numeroparolestringa;

    for i IN 1..numeroparolestringa LOOP
            OPEN cursore;
                paroladastringa=split_part(stringa, '@', i);
                RAISE NOTICE 'Parola Stringa attuale: {%}', paroladastringa;
            SELECT *
            FROM r.descrizione AS D
            WHERE parola <> ALL

    END LOOP;
END;
$$
LANGUAGE plpgsql;

CALL r.riproviamoci('barra2+prova2');

SELECT DOI
FROM r.descrizione
EXCEPT