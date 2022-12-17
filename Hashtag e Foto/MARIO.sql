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
        RAISE NOTICE 'Numero Uri: {%}', numURI;
        RAISE NOTICE 'Numero ParoleSTR: {%}', numParoleSTR;
        OPEN cursURI;
        FOR i in 1..numURI LOOP
            FETCH cursURI INTO currentURI;
            RAISE NOTICE '----------------';
            RAISE NOTICE 'Uri Attuale: {%}', currentURI;
            match = 0;
            FOR j in 1..numParoleSTR LOOP
                parolaSTR = split_part(parolaSTR, '@', j); --Per quale cazzo di motivo sta variabile di merda non prende valore dio cristo !!!!!!
                --parolaSTR = 'provatabelle1e3';
                RAISE NOTICE 'Parola Attuale Stringa: {%}', parolaSTR;
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

SELECT split_part('prova11@prova12@provatabelle1e3', '@', 1);

SELECT *
FROM f.tagfoto as T NATURAL JOIN f.foto as F
WHERE F.uri='uri2' AND T.parola='provatabelle1e3'


