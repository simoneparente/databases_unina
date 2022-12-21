/*
  Si scriva una funzione in SQL DINAMICO che riceve in
ingresso una stringa di parole chiave separate dal carattere +. La funzione restituisce la
stringa di doi degli articoli a cui sono associate TUTTE le parole chiave nella stringa.
 */

CREATE OR REPLACE PROCEDURE r.funzione1(IN input VARCHAR(500)) AS
$$
    DECLARE
        n_parole_input INTEGER;

        match INTEGER;
        parola_attuale_input r.descrizione.parola%TYPE;
        n_doi INTEGER:=(SELECT COUNT (doi) FROM (SELECT DISTINCT doi FROM R.descrizione) AS Q);
        doi_attuale r.descrizione.doi%TYPE;
        scorri_doi CURSOR FOR SELECT DISTINCT DOI FROM r.descrizione;

        output VARCHAR(500);
        count_out INTEGER:=0;
    BEGIN
        OPEN scorri_doi;
        --RAISE NOTICE 'Parole table(%)', n_parole_table;
        input=replace(input, '+', '@');                --sostituisco i + con gli @
        n_parole_input=regexp_count(input, '@')+1;     --così da poter contare il numero di parole
        RAISE NOTICE 'n_parole_in(%)', n_parole_input; --stampo il numero di parole
        for i IN 1..n_doi LOOP
            match=0;
            FETCH scorri_doi INTO doi_attuale;
            FOR j IN 1..n_parole_input LOOP
                 parola_attuale_input=split_part(input, '@', j);
                 IF EXISTS(SELECT * FROM r.descrizione WHERE parola=parola_attuale_input and doi=doi_attuale) THEN
                     match=match+1;
                 end if;
                 RAISE NOTICE 'MATCH(%)', match;
                if(match=n_parole_input) THEN
                    IF(count_out=0) THEN
                        output=doi_attuale;
                        count_out=count_out+1;
                        ELSE
                        output=output || ', ' || doi_attuale;
                    end if;
                    end if;
            end loop;

            end loop;
            RAISE NOTICE '(%)', output;
    end
$$
LANGUAGE plpgsql;

CALL r.funzione1('perfavore1e2');

--SELECT *
--FROM r.descrizione;

