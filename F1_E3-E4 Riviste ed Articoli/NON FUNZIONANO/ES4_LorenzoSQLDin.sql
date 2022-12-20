create or replace function r.function_2(in stringa varchar) returns varchar
as
$$
declare
    sql_query  varchar(1000);
    appoggio   varchar(100);
    appoggio_1 varchar(100);
    appoggio_2  varchar(100);
    n_parole integer := regexp_count(stringa, '\+') + 1;

begin
    raise notice '(%)', n_parole;
    for index in 1..n_parole
        loop
            appoggio=split_part(stringa, '+', index);
            sql_query ='select d.doi from r.descrizione d where parola=' || '''' || appoggio || '''';
            RAISE NOTICE '{%}', sql_query;
            execute sql_query into appoggio_1;
            RAISE NOTICE 'appoggio1(%)',appoggio_1;
            if exists((select doi from r.descrizione where parola = appoggio and appoggio_1=doi))then
                appoggio_2 = concat(appoggio_2, appoggio_1);
            end if;
            index := index + 1;
            end loop;
            return appoggio_2;
end
$$
    language plpgsql;



--select split_part('abc+def+ghi', '+', 1);

select r.function_2('cazzo+parola+prova1')
;


