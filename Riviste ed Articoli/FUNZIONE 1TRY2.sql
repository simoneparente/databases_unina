--

CREATE OR REPLACE PROCEDURE r.funz_1_TRY2(stringa VARCHAR(128))AS
$$
    DECLARE
        recordtabella INTEGER:= (SELECT COUNT (*) FROM r.descrizione);
        cursore CURSOR FOR
            SELECT parola, doi
                FROM r.descrizione;
        paroladastringa VARCHAR(32);
        numeroparolestringa INTEGER:=0;
        doi r.descrizione.doi%TYPE;
        prev_doi r.descrizione.doi%TYPE;
        paroladatable r.descrizione.parola%TYPE;
        controllo INTEGER:=0;

    BEGIN
        stringa=replace(stringa, '+', '@');
        RAISE NOTICE 'Stringa: {%}', stringa;
        numeroparolestringa=regexp_count(stringa, '@')+1;
        RAISE NOTICE 'N parole stringa: (%)';
        RAISE NOTICE 'Recordatabella: (%)', recordtabella;

         for i IN 1..numeroparolestringa LOOP
            OPEN cursore;
                paroladastringa=split_part(stringa, '@', i);
                RAISE NOTICE 'Parola Stringa attuale: {%}', paroladastringa;

             FOR j IN 1..recordtabella LOOP
             FETCH cursore INTO paroladatable, doi;
             RAISE NOTICE 'Parola Table Attuale: {%}', paroladatable
             IF(paroladatable=paroladastringa) THEN
             end if;
             prev_doi=doi;
             RAISE NOTICE 'matchare(%)', paroladastringa;
             RAISE NOTICE 'query: (%)', paroladatable;
             RAISE NOTICE 'controllo(%)', controllo;
             END LOOP;
             CLOSE cursore;
        END LOOP;
    END
$$
LANGUAGE plpgsql;

CALL r.funz_1_TRY2('silvio1+salernitana1+prova2');