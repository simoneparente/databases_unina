CREATE OR REPLACE FUNCTION f.try(in input text) RETURNS TEXT AS
    $$
    DECLARE
        query text;
        resultquery text;
        result text;
        refcur refcursor;
        n_parole int = regexp_count(input, '@')+1;
        paroleAr text[] := regexp_split_to_array(input, '@');
        output text = '';
        k int:=0;
    BEGIN
        query := '(SELECT uri FROM f.foto NATURAL JOIN f.tagfoto T WHERE T.parola = ';
        if n_parole = 1 then
            resultquery := query || ''''||paroleAr[1]||''''||')';
            OPEN refcur FOR EXECUTE resultquery ;
        else
            resultquery := query || ''''||paroleAr[1]||'''' || ' ) intersect ';
            for i in 2..n_parole loop
                resultquery := resultquery || query ||''''|| paroleAr[i] ||''''|| ' ) intersect ';
                raise notice 'Query: % alla %', resultquery,i;
            end loop;
            resultquery := rtrim(resultquery, ' intersect');
            raise notice 'Query finale: %', resultquery;
            OPEN refcur FOR EXECUTE resultquery;
        end if;
        LOOP
            FETCH refcur INTO result;
            EXIT WHEN NOT FOUND;
            output := output || result || '@';
        END LOOP;
        CLOSE refcur;
        output = rtrim(output,'@');
        RETURN output;
    END;
    $$language plpgsql;

select f.try('provatabelle1e3') as output;
