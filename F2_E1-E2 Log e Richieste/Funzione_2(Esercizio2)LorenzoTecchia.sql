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
--     cursore_t1 cursor for (select r.tempo
--                            from richieste r);
    tempo_attuale   integer := 5;
    tempo_t1        l.richieste.tempo%TYPE;
    variabile_1     l.richieste.codrisorsa%TYPE;
    variabile_2     l.richieste.codrisorsa%TYPE;
    output_funzione varchar(100);
--     cursore_risorse cursor for (select r2.codrisorsa
--                                 from assegnazione a
--                                          join richieste r2
--                                               on r2.codrisorsa = a.codrisorsa
--                                 where r2.tempo = tempo_t1);

begin
--     open cursore_t1;
--     open cursore_risorse;
    for tempo_t1 in (select r.tempo
                     from L.richieste r)
        loop
            if ((tempo_t1 - tempo_attuale) > Tout) then
                for variabile_1 in (select ri.codrisorsa
                                    from L.risorsa ri
                                    where stato = 'w-lock'
                                       or stato = 'r-lock')
                    loop
                        for variabile_2 in (select r2.codrisorsa
                                            from L.assegnazione a
                                                     join L.richieste r2
                                                          on r2.codrisorsa = a.codrisorsa
                                            where r2.tempo = tempo_t1)
                            loop
                                if (variabile_2 is not null && variabile_2 = variabile_1)
                                then
                                    output_funzione = output_funzione || variabile_2;
                                end if;
                            end loop;
                    end loop;
            end if;
        end loop;
--     close cursore_t1;
--     close cursore_risorse;
    RETURN output_funzione;
end
$$
    language plpgsql;


SELECT l.function_2(2);