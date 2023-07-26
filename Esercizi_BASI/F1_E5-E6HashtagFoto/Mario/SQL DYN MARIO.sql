--START

CREATE OR REPLACE FUNCTION f.f_sqlDYN(IN stringa text) RETURNS text AS $$
    DECLARE
        strQRY text;
        numParoleSTR INTEGER = regexp_count(stringa, '@') + 1;
        parolaSTR f.tagfoto.parola%TYPE;
        count INTEGER = 0;
        selectQRY text = 'SELECT uri FROM f.tagfoto as t NATURAL JOIN f.foto WHERE t.parola = ';
        cursQRY refcursor;
        output text;
        correctURI f.foto.uri%TYPE;
    BEGIN
        FOR i in 1..numParoleSTR LOOP
            parolaSTR = split_part(stringa, '@', i);
            IF count = 0 THEN
                strQRY = concat('(',selectQRY, '''', parolaSTR, '''', ')');
                count = 1;
            ELSE
                strQRY = concat(' ', strQRY, ' INTERSECT ', '(',selectQRY, '''', parolaSTR, '''', ')');
            end if;
        end loop;
        RAISE NOTICE 'Query: {%}', strQRY;

        OPEN cursQRY FOR EXECUTE strQRY;
        count = 0;
        LOOP
            FETCH cursQRY INTO correctURI;
            EXIT WHEN NOT FOUND;
            IF count = 0 THEN
            output = correctURI;
            count = 1;
            ELSE
            output = concat(output, '@', correctURI);
            end if;
        end loop;
        RAISE NOTICE 'RISULTATO: {%}', output;
        RETURN output;
    end
$$ LANGUAGE plpgsql;

SELECT f.f_sqlDYN('provatabelle1e3');

--(SELECT uri FROM f.tagfoto as t NATURAL JOIN f.foto WHERE t.parola = 'provatabelle1e3') INTERSECT (SELECT uri FROM f.tagfoto as t NATURAL JOIN f.foto WHERE t.parola = 'prova11')
--SELECT uri FROM f.tagfoto NATURAL JOIN f.foto WHERE parola = 'x';

