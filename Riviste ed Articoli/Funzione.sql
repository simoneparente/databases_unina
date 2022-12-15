/*
 Si scriva una funzione in SQL DINAMICO che riceve in
ingresso una stringa di parole chiave separate dal carattere +. La funzione restituisce la stringa
di doi degli articoli a cui sono associate TUTTE le parole chiave nella stringa.
 */

SELECT *
FROM (r.rivista NATURAL JOIN r.fascicolo F), r.articolo A, r.parolechiave as p
WHERE F.codf=a.codf AND p.isnn=rivista.isnn;

SELECT *
FROM ((r.rivista AS R JOIN r.fascicolo AS F ON r.isnn = f.isnn) JOIN r.articolo AS A ON a.codf=f.codf)
    JOIN r.parolechiave AS p ON p.isnn=r.isnn;



CREATE OR REPLACE FUNCTION funz_1(stringa VARCHAR(128))  RETURNS  VARCHAR(32) AS
$$
    DECLARE
    cursore CURSOR FOR
        SELECT *
        FROM (r.rivista NATURAL JOIN r.fascicolo F), r.articolo A, r.parolechiave as p
        WHERE F.codf=a.codf AND p.isnn=rivista.isnn;
        paroladamatchare VARCHAR(32);
        i
    BEGIN

    END;
$$
