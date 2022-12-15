CREATE OR REPLACE PROCEDURE r.funz_1_TRY2(stringa VARCHAR(128))AS
$$
    DECLARE
    /*cursore CURSOR FOR
        SELECT *
        FROM (r.rivista NATURAL JOIN r.fascicolo F), r.articolo A, r.parolechiave as p
        WHERE F.codf=a.codf AND p.isnn=rivista.isnn;*/
        recordtabella INTEGER:= (SELECT COUNT (*) FROM r.descrizione);
        cursore CURSOR FOR
            SELECT parola
                FROM r.descrizione;
        paroladamatchare VARCHAR(32);
        n INTEGER:=0;
        paroladatable r.descrizione.parola%TYPE;
        controllo INTEGER:=0;

    BEGIN
        stringa=replace(stringa, '+', '@');
        n=regexp_count(stringa, '@')+1;
        RAISE NOTICE 'recordatabella(%)', recordtabella;

         for i IN 1..n LOOP
            OPEN cursore;
             paroladamatchare=split_part(stringa, '@', i);
             FOR j IN 1..recordtabella LOOP
             FETCH cursore INTO paroladatable;
             IF(paroladatable=paroladamatchare) THEN
                 controllo=controllo+1;
             end if;
             RAISE NOTICE 'matchare(%)', paroladamatchare;
             RAISE NOTICE 'query: (%)', paroladatable;
             RAISE NOTICE 'controllo(%)', controllo;
             END LOOP;
             CLOSE cursore;
            --RAISE NOTICE '(%)', paroladamatchare;
            --RAISE NOTICE 'query: (%)', paroladatable;
        END LOOP;
    END
$$
LANGUAGE plpgsql;

CALL r.funz_1_TRY2('barra2+prova2');