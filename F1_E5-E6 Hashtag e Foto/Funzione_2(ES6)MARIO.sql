--ES6 MARIO PENNA
CREATE OR REPLACE FUNCTION f.pro(IN stringa VARCHAR(500)) RETURNS VARCHAR(500) AS $$
    DECLARE
        numParoleSTR INTEGER;
        parolaSTR f.tagfoto.parola%TYPE;
        numURI INTEGER;
        cursURI CURSOR FOR SELECT DISTINCT uri FROM f.foto;
        currentURI   f.foto.uri%TYPE;
        match INTEGER;
        output VARCHAR(500);
        count INTEGER = 0;
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
                IF EXISTS(SELECT * FROM f.tagfoto as T NATURAL JOIN f.foto as F
                          WHERE F.uri = currentURI AND T.parola = parolaSTR) THEN
                    match = match + 1;
                    RAISE NOTICE 'Match: {%}', match;
                end if;
                IF match = numParoleSTR THEN
                    IF count = 0 THEN
                        output = CONCAT(OUTPUT, currentURI);
                    ELSE
                        output = CONCAT(OUTPUT, '@', currentURI);
                    END IF;
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

SELECT f.pro('provatabelle1e3');