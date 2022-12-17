--START

CREATE OR REPLACE PROCEDURE r.pro(string VARCHAR(500)) AS $$
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
        RAISE NOTICE 'String con @ {%}', string;
        RAISE NOTICE 'Numero ParoleSTR: {%}', numParoleSTR;
        RAISE NOTICE 'Numero DOI: {%}', numDOI;
        OPEN cursDOI;
        FOR i in 1..numDOI LOOP
            FETCH cursDOI INTO currentDOI;
            RAISE NOTICE '----------------';
            RAISE NOTICE 'DOI Attuale: {%}', currentDOI;
            match=0;
            FOR j in 1..numParoleSTR LOOP
                parolaSTR = split_part(string, '@', j);
                RAISE NOTICE 'Parola Attuale Stringa: {%}', parolaSTR;
                RAISE NOTICE 'j: {%}', j;
                IF EXISTS (SELECT *
                           FROM r.descrizione as d
                           WHERE d.doi=currentDOI AND d.parola=parolaSTR) THEN
                match = match +1;
                RAISE NOTICE 'Match: {%}', match;
                end if;
                IF match = numParoleSTR THEN
                    output=CONCAT(output, currentDOI);
                    RAISE NOTICE 'DOI giusto: {%}', currentDOI;
                end if;
            end loop;
        end loop;
        RAISE NOTICE '----------------';
        RAISE NOTICE 'Output: {%}', output;
    END;
$$ LANGUAGE plpgsql;

CALL r.pro('silvio1');