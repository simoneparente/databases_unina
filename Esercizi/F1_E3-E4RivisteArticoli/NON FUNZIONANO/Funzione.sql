/*
 Si scriva una funzione in SQL DINAMICO che riceve in
ingresso una stringa di parole chiave separate dal carattere +. La funzione restituisce la stringa
di doi degli articoli a cui sono associate TUTTE le parole chiave nella stringa.
 */

DROP FUNCTION r.funz_1(stringa VARCHAR(128));
SELECT parola
FROM (r.rivista NATURAL JOIN r.fascicolo F), r.articolo A, r.parolechiave as p
WHERE F.codf=a.codf AND p.isnn=rivista.isnn;

SELECT *
FROM ((r.rivista AS R JOIN r.fascicolo AS F ON r.isnn = f.isnn) JOIN r.articolo AS A ON a.codf=f.codf)
    JOIN r.parolechiave AS p ON p.isnn=r.isnn;


    --------------FUNCTION---------------------------------------inserire VARCHAR
CREATE OR REPLACE PROCEDURE r.funz_1_TRY1(stringa VARCHAR(128))AS
$$
    DECLARE
    /*cursore CURSOR FOR
        SELECT *
        FROM (r.rivista NATURAL JOIN r.fascicolo F), r.articolo A, r.parolechiave as p
        WHERE F.codf=a.codf AND p.isnn=rivista.isnn;*/
        recordtabella INTEGER:=(SELECT COUNT(*) FROM r.descrizione);
        cursore CURSOR FOR
            SELECT parola
                FROM r.descrizione;
        paroladamatchare VARCHAR(32);
        n INTEGER:=0;

    BEGIN
    OPEN cursore;
    stringa=replace(stringa, '+', '@');
    n=regexp_count(stringa, '@')+1;
    CREATE TABLE r.tableDOI(DOI VARCHAR(32), parola VARCHAR(32));
    --INSERT INTO r.tabledoi(DOI, parola) SELECT * FROM r.descrizione;
    --INSERT INTO r.tableDOI(DOI) SELECT DISTINCT doi from r.descrizione;
    for i IN 1..n LOOP
        paroladamatchare=split_part(stringa, '@', i);
        RAISE NOTICE '(%)', paroladamatchare;
        for j IN 1..recordtabella LOOP
        RAISE NOTICE 'query: (%)', cursore;
        DELETE FROM r.tabledoi WHERE tabledoi.parola=paroladamatchare;
        END LOOP
    --DROP TABLE r.tableDOI(DOI VARCHAR(32));
    END
$$
LANGUAGE plpgsql;

CALL r.funz_1('silvio1+salernitana1');
DROP TABLE r.tabledoi;

SELECT split_part('abc~@~def~@~ghi', '~@~', 4);

SELECT rtrim('prova+ejfcrei',['+']);

SELECT btrim('++trim++','+');

SELECT REPLACE('prova+d+c+dgrhtt','+','@');