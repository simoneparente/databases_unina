--drop function l.checkdeadlock(Tout INTEGER);

CREATE OR REPLACE FUNCTION l.fdl(IN Tout INTEGER) RETURNS text AS
$$
    DECLARE
        tattuale INTEGER=5; --sono le 5
        rec record;
        output text:='';
    BEGIN
        for rec in (SELECT ri.codtransazione, ass.codtransazione as asct, ri.tempo
                    FROM l.assegnazione ass, l.richieste ri
                    WHERE ri.codrisorsa=ass.codrisorsa AND
                          ri.codtransazione<>ass.codtransazione )
        loop
            if (rec.asct in (SELECT ri.codtransazione
                             FROM l.assegnazione ass, l.richieste ri
                             WHERE ri.codrisorsa=ass.codrisorsa AND
                                   ri.codtransazione<>ass.codtransazione )) then
                raise notice 'ass.codT{%} è in deadlock', rec.asct;
                if (tout<tattuale-rec.tempo) then
                    output :=  output ||'+'|| rec.asct;
                    raise notice 'output{%}', output;
                end if;
            end if;
        end loop;
        output := ltrim(output, '+');
        return output;
    END;
    $$LANGUAGE plpgsql;

select l.fdl(1) as deadlock;