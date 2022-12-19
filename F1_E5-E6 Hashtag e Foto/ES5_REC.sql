DROP TABLE f.temp;
CREATE OR REPLACE PROCEDURE f.f_interna(tagalbum f.album.codA%TYPE)
AS
$$
DECLARE

BEGIN
    RAISE NOTICE 'ALbero passato(%)', tagalbum;

    INSERT INTO f.temp(coda) VALUES (tagalbum);
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE f.f1_rec(input f.album.codA%TYPE) AS
$$
DECLARE
    figli_input CURSOR FOR (SELECT coda
                            FROM f.album
                            WHERE inalbum = input);
    figlio f.album.codA%TYPE;
BEGIN
    CREATE TABLE f.TEMP
    (
        CodA INTEGER
    );
    OPEN figli_input;
    LOOP
        FETCH figli_input INTO figlio;
        CALL f.f_interna(figlio);
        EXIT WHEN NOT FOUND;
    END LOOP;
END;
$$
    LANGUAGE plpgsql;

CALL f.f1_rec(1);