-- Si scriva una funzione con parametro intero Tout che
-- per tutte le transazioni T1 che sono in attesa per una risorsa
-- per un tempo superiore a T out (differenza tra il tempo di registrazione della
-- richiesta e il tempo corrente) controlli se ci sia un deadlock
-- (cio`e se esiste un’altra transazione T2 che occupa la risorsa richiesta e
-- la transazione T2 richiede una risorsa asegnata alla transazione T1).
-- La funzione restituisce una stringa coi codici delle transazioni T1 in
-- deadlock cosi trovate.


create or replace function l.function_2(in Tout integer) returns varchar
as
$$
    declare
        temporichieste l.richieste.tempo%TYPE;
        codicerisorsa_1 l.richieste.codrisorsa%TYPE;
        codicerisorsa_2 l.richieste.codrisorsa%TYPE;

        stringa varchar;
        tempo_corrente integer := 1;

        richieste_risorse_1 cursor for
            (select r.tempo
             from l.richieste r);

        richieste_risorse_2 cursor for
            (select r.codrisorsa
             from l.richieste r join l.assegnazione a on r.codtransazione = a.codtransazione);
        intero integer;

    begin
        open richieste_risorse_1;
        open assegnazione_risorse_2;
        IF(intero=0) THEN
        fetch richieste_risorse_1 into temporichieste;
        intero=intero+1;
        ELSE
        fetch richieste_risorse_2 into codicerisorsa_1;
        END IF;
        while(temporichieste is not null) loop
            if ((tempo_corrente - temporichieste) > Tout) then
                raise notice 'tempo{%}',temporichieste;
                if (codicerisorsa_2 = codicerisorsa_1) then
                    stringa := stringa || codicerisorsa_1 ||;
                end if;
            end if;
            tempo_corrente := tempo_corrente + 1;
            end loop;
        close richieste_risorse_1;

        RETURN stringa;
    end
$$
language plpgsql;


SELECT l.function_2(1);