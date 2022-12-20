--START
CREATE OR REPLACE PROCEDURE f2_figli(tagalbum f.album.coda%TYPE) AS $$
    DECLARE
        numFigli INTEGER = (SELECT Count(*) FROM f.album AS A WHERE A.inalbum=tagalbum);
        figlio f.album.coda%TYPE;
    BEGIN
        FOR figlio IN (SELECT codA FROM f.album AS A WHERE A.inalbum=tagalbum) LOOP
            RAISE NOTICE 'figlio: %', figlio;
            CALL f2_figli(figlio);
            INSERT INTO f.tmp(codA) values (figlio);
        end loop;
    end
$$ language plpgsql;

CREATE OR REPLACE PROCEDURE f1_rec(tagalbum f.album.coda%TYPE) AS $$
    DECLARE
        Album f.album.coda%TYPE;
        output VARCHAR(500);
    BEGIN
        CREATE TABLE f.tmp(codA INTEGER);
        INSERT INTO f.tmp VALUES (tagalbum);
        CALL f2_figli(tagalbum);
        FOR Album IN (SELECT codA FROM f.tmp) LOOP
            output = CONCAT(output, ' ', Album);
        end loop;
        DROP TABLE f.tmp CASCADE;
        RAISE NOTICE '-----------';
        RAISE NOTICE 'Output {%}', output;
    end;
$$ language plpgsql;

CALL f1_rec(1);
