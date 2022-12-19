CREATE OR REPLACE PROCEDURE f2_figli(tagalbum f.album.coda%TYPE) AS $$
    DECLARE
        prendiFigli CURSOR FOR (SELECT codA FROM f.album AS A WHERE A.inalbum=tagalbum);
        numFigli INTEGER = (SELECT Count(*) FROM f.album AS A WHERE A.inalbum=tagalbum);
        figlio f.album.coda%TYPE;
    BEGIN
        --FETCH prendiFigli INTO figlio;
        IF numFigli>0 THEN
            prendiFigli = random_portal_name();
            OPEN prendiFigli;
            FOR i IN 1..numFigli LOOP
                FETCH prendiFigli INTO figlio;
                RAISE NOTICE 'figlio: %', figlio;
                CALL f2_figli(figlio);
                INSERT INTO f.tmp(codA) values (figlio);
            end loop;
        end if;
    end;
$$ language plpgsql;


CREATE OR REPLACE PROCEDURE f1_rec(tagalbum f.album.tagalbum%TYPE) AS $$
    DECLARE

    BEGIN
$$ language plpgsql;

CREATE TABLE f.tmp(
    codA INTEGER
);

CALL f2_figli(1);
