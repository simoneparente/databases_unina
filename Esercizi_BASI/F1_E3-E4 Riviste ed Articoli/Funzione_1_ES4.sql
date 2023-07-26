/*
Si scriva una funzione in SQL DINAMICO che riceve in
ingresso una stringa di parole chiave separate dal carattere +. La funzione restituisce la
stringa di doi degli articoli a cui sono associate TUTTE le parole chiave nella stringa
 */

 CREATE FUNCTION r.funzione1(input VARCHAR(500)) RETURNS VARCHAR(500) AS
$$
DECLARE
    parola_attuale r.parolechiave.parola%TYPE;
    cursore CURSOR FOR (SELECT doi, parola FROM f.parolechiave NATURAL JOIN f.articolo
BEGIN

END;
$$