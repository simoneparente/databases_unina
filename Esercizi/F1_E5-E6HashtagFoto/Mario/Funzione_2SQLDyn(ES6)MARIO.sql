--START
CREATE OR REPLACE PROCEDURE pro_2(stringa text) AS $$
    DECLARE
        numParoleSTR INTEGER = regexp_count(stringa, '@') + 1;
        parolaSTR f.tagfoto.parola%TYPE;
        currentURI   f.foto.uri%TYPE;
        match INTEGER;
        strQry text = 'SELECT uri FROM l.foto as f WHERE ';
        ctQRY INTEGER = 0;
        rcurs
    BEGIN
        FOR currentURI in (SELECT DISTINCT uri FROM f.foto) LOOP
            match = 0;
            FOR j in 1..numParoleSTR LOOP
                parolaSTR = split_part(stringa, '@', j);
                IF EXISTS (SELECT * FROM f.tagfoto as T NATURAL JOIN f.foto as F
                           WHERE F.uri = currentURI AND T.parola = parolaSTR) THEN
                    match = match + 1;
                end if;
                IF match = numParoleSTR THEN
                    IF ctQRY = 0 THEN
                        strQry = CONCAT(strQry,'f.uri=', currentURI, ' ');
                    ELSE
                        strQry = CONCAT(strQRY, 'AND', 'f.uri=', currentURI, ' ' );
                    end if;
                end if;
            end loop;
        end loop;
        -----------ESEGUO SQL DYN------------

    end;
$$ LANGUAGE plpgsql;


SELECT codF
FROM tagfoto