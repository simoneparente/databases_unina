CREATE OR REPLACE FUNCTION ES4_1(myInput text) RETURNS text AS
    $$
    DECLARE
        match int;
        myOutput text:= '';
        myParola r.parolechiave.parola%TYPE;
        n_parole int;
        n_doi int := (SELECT COUNT(doi) FROM r.descrizione);
        myDoi r.articolo.doi%TYPE;
        --curs_doi cursor for select doi from r.descrizione;
        sql text := 'SELECT ? FROM ?' ;
        curs_doi refcursor;
        rec record;
    BEGIN
        open curs_doi for EXECUTE sql USING 'doi', 'r.descrizione';

    END $$ LANGUAGE plpgsql;

SELECT ES4_1('silvio1+barra2');



