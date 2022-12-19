create or replace function l.function_2(in Tout integer) returns varchar
as
$$
    declare
        temporichieste l.richieste.tempo%TYPE;
        stringa varchar;
        tempo_corrente integer := 1;

        richieste_risorse_1 cursor for
            (select r.tempo
             from l.richieste r join l.assegnazione a on r.codtransazione = a.codtransazione);

        richieste_risorse_2 cursor for
            (select *
             from l.richieste r join l.assegnazione a on r.codtransazione = a.codtransazione);

    begin
        open richieste_risorse_1;
--         open assegnazione_risorse_2;
        fetch richieste_risorse_1 into temporichieste;
        while(temporichieste is not null) loop
            if ((tempo_corrente - temporichieste) > Tout) then
                raise notice 'tempo{%}',temporichieste;
            end if;
            tempo_corrente := tempo_corrente + 1;
            end loop;
        close richieste_risorse_1;

        RETURN stringa;
    end
$$
language plpgsql;


SELECT l.funct  ion_2(1);