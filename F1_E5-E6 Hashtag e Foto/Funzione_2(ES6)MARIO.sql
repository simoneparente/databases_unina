--START
--DROP PROCEDURE f.pro;
CREATE OR REPLACE FUNCTION f.pro(stringa VARCHAR(500))  RETURNS VARCHAR(500) AS $$
    DECLARE
        numParoleSTR INTEGER;
        count INTEGER:=0;
        parolaSTR f.tagfoto.parola%TYPE;
        numURI INTEGER;
        cursURI CURSOR FOR SELECT DISTINCT uri FROM f.foto;
        currentURI f.foto.uri%TYPE;
        match INTEGER;
        output VARCHAR(500);
    BEGIN
        numParoleSTR = regexp_count(stringa, '@') + 1;
        numURI = (SELECT Count(uri) FROM f.foto);
        RAISE NOTICE 'Numero ParoleSTR: {%}', numParoleSTR;
        RAISE NOTICE 'Numero Uri: {%}', numURI;
        OPEN cursURI;
        FOR i in 1..numURI LOOP
            FETCH cursURI INTO currentURI;
            RAISE NOTICE '----------------';
            RAISE NOTICE 'Uri Attuale: {%}', currentURI;
            match = 0;
            FOR j in 1..numParoleSTR LOOP
                parolaSTR = split_part(stringa, '@', j);
                RAISE NOTICE 'Parola Attuale Stringa: {%}', parolaSTR;
                IF EXISTS (SELECT *
                           FROM f.tagfoto as T NATURAL JOIN f.foto as F
                           WHERE F.uri=currentURI AND T.parola=parolaSTR) THEN
                    match = match + 1;
                    RAISE NOTICE 'Match: {%}', match;
                end if;
                IF match = numParoleSTR AND count>0 THEN
                    output=CONCAT(OUTPUT, '@',currentURI);
                    count=count+1;
                    ELSE IF match = numParoleSTR and count=0 THEN
                        output=currenturi;
                        count=count+1;
                    end if;
                    RAISE NOTICE 'URI giusto: {%}', currentURI;
                end if;
            end loop;
        end loop;
        RAISE NOTICE '----------------';
        RAISE NOTICE 'Output: {%}', output;
        RETURN output;
    end;
$$ language plpgsql;

SELECT f.pro('prova11@prova12@provatabelle1e3');

select f.pro('provatabelle1e3');

--TEST Query IF
SELECT *
FROM f.tagfoto as T NATURAL JOIN f.foto as F
WHERE F.uri='uri2' AND T.parola='provatabelle1e3';

------------------------------------------------------------------------------------------------------------------------
--SplitPart TEST

SELECT split_part('prova11@prova12@provatabelle1e3', '@', 1);

--Per quale cazzo di ragione qui funziona?????
CREATE OR REPLACE PROCEDURE f.test(string VARCHAR(500)) AS $$
    DECLARE
        test VARCHAR(500);
    BEGIN
        FOR j in 1..3 LOOP
        test = split_part(string, '@', j);
        RAISE NOTICE 'Split_Part {%}', test;
        END LOOP;
    end
$$ language plpgsql;

CALL f.test('prova11@prova12@provatabelle1e3');