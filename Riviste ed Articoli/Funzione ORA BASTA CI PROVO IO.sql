CREATE OR REPLACE PROCEDURE r.funzMario(stringa VARCHAR(1000)) AS $$
    DECLARE
        cursore_numPC CURSOR FOR SELECT d.doi, count(d.parola) FROM r.descrizione as d GROUP BY d.doi;
        numPC INTEGER;
    BEGIN
        open cursore_numPC;
        cursore_numPC INTO numPC;
    end;


$$