--START
CREATE OR REPLACE PROCEDURE f.pro(stringa VARCHAR(500))  AS $$
    DECLARE
        numParoleSTR INTEGER;
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
                --Per quale cazzo di motivo sta variabile di merda non prende valore dio cristo !!!!!!
                parolaSTR = split_part(parolaSTR, '@', j);
                --parolaSTR = 'provatabelle1e3';
                RAISE NOTICE 'Stringa {%}', stringa;
                RAISE NOTICE 'Parola Attuale Stringa: {%}', parolaSTR;
                RAISE NOTICE 'split_part: {%}', split_part(parolaSTR, '@', j);
                RAISE NOTICE 'j: {%}', j;
                IF EXISTS (SELECT *
                           FROM f.tagfoto as T NATURAL JOIN f.foto as F
                           WHERE F.uri=currentURI AND T.parola=parolaSTR) THEN
                    match = match + 1;
                    RAISE NOTICE 'Match: {%}', match;
                end if;
                IF match = numParoleSTR THEN
                    output=CONCAT(OUTPUT, currentURI);
                    RAISE NOTICE 'URI giusto: {%}', currentURI;
                end if;
            end loop;
        end loop;
        RAISE NOTICE '----------------';
        RAISE NOTICE 'Output: {%}', output;
    end;
$$ language plpgsql;

CALL f.pro('prova11@prova12@provatabelle1e3');

CALL f.pro('provatabelle1e3');

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
        FOR i in 1..3 LOOP
        test = split_part(string, '@', i);
        RAISE NOTICE 'Split_Part {%}', test;
        END LOOP;
    end
$$ language plpgsql;

CALL f.test('prova11@prova12@provatabelle1e3');