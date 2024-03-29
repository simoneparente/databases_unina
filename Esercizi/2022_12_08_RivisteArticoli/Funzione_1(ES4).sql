/*
Si scriva una funzione in SQL DINAMICO che riceve iningresso una stringa di parole chiave 
separate dal carattere +. La funzione restituisce la stringadi doi degli articoli a cui 
sono associate TUTTE le parole chiave nella stringa.
*/

--QUESTO ESERCIZIO NON È IN SQL DINAMICO PER FARLO IN SQL DINAMICO VEDI ES 6 DI 2022_12_08_HashtagFoto

CREATE OR REPLACE FUNCTION r.pro(string VARCHAR(500)) RETURNS VARCHAR(500) AS $$
    DECLARE
        numParoleSTR INTEGER;
        parolaSTR r.descrizione.parola%TYPE;
        numDOI INTEGER;
        cursDOI CURSOR FOR SELECT doi FROM r.articolo;
        currentDOI r.descrizione.doi%TYPE;
        match INTEGER;
        output VARCHAR(500);
    BEGIN
        string=replace(string, '+', '@');
        numParoleSTR = regexp_count(string, '@') + 1;
        numDOI = (SELECT Count(doi) FROM r.articolo);
        OPEN cursDOI;

        FOR i in 1..numDOI LOOP
            FETCH cursDOI INTO currentDOI;
            match=0;

            FOR j in 1..numParoleSTR LOOP
                parolaSTR = split_part(string, '@', j);

                IF EXISTS (SELECT * FROM r.descrizione as d
                           WHERE d.doi=currentDOI AND d.parola=parolaSTR) THEN
                match = match +1;
                end if;
                IF match = numParoleSTR THEN
                    output=CONCAT(output, currentDOI);
                end if;
            end loop;
        end loop;
        RETURN output;
    END;
$$ LANGUAGE plpgsql;

SELECT r.pro('prova2');