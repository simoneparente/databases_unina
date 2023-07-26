CREATE OR REPLACE FUNCTION r.funz2(input VARCHAR(500)) RETURNS VARCHAR(1000) AS
$$
    DECLARE
        n_parole_input INTEGER;
        match INTEGER;
        parola_attuale_input r.descrizione.parola%TYPE;
        n_doi INTEGER:=(SELECT COUNT (doi) FROM (SELECT DISTINCT doi FROM R.descrizione) AS Q);
        doi_attuale r.descrizione.doi%TYPE;
        scorri_doi CURSOR FOR SELECT DISTINCT DOI FROM r.descrizione;
        count_out INTEGER:=0;

        variabileinutile r.descrizione.parola%TYPE;
        outputfinale VARCHAR(1000):='';
        outputbase VARCHAR(1000):='SELECT DISTINCT doi FROM r.descrizione WHERE doi=';
        output2 VARCHAR(1000);
    BEGIN
        OPEN scorri_doi;
        input=replace(input, '+', '@');                --sostituisco i + con gli @
        n_parole_input=regexp_count(input, '@')+1;
                for i IN 1..n_doi LOOP
            match=0;
            FETCH scorri_doi INTO doi_attuale;
            FOR j IN 1..n_parole_input LOOP
                 parola_attuale_input=split_part(input, '@', j);
                 IF EXISTS(SELECT * FROM r.descrizione WHERE parola=parola_attuale_input and doi=doi_attuale) THEN
                     match=match+1;
                 end if;
                 RAISE NOTICE 'MATCH(%)', match;
                if(match=n_parole_input) THEN
                    IF(count_out=0) THEN
                        output2=outputbase || '' || doi_attuale || '';
                        count_out=count_out+1;
                        ELSE
                        output2=output2 || ' OR ' || 'doi=' || '' || doi_attuale || '';
                    end if;
                    end if;
                    end loop;
            end loop;
        RAISE NOTICE 'output{%}', output2;
        FOR variabileinutile IN (SELECT DISTINCT doi FROM r.descrizione WHERE doi='doi1' OR doi='doi2') LOOP
            RAISE NOTICE '%', variabileinutile;
            outputfinale=outputfinale || variabileinutile || ' ';
            end loop;
        RETURN outputfinale;
    end
$$
LANGUAGE plpgsql;

select r.funz2('perfavore1e2');
