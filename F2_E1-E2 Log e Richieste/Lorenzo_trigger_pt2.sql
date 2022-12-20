create or replace function l.function_trigger() returns trigger
as
$$
declare
    controllo integer := 0;
    cursore_transazione cursor for (select codtransazione
                                    from log l join assegnazione a on l.codrisorsa = a.codrisorsa
                                    order by l.timestamp desc);
    count integer:=(select count(*) from l.log where codtransazione=new.codtransazione);
begin
    open cursore_transazione;
    for i in 1..count loop
        fetch cursore_transazione into controllo;
        update l.risorsa set valore=valoreprima, stato='Unlock' from l.log where risorsa.codrisorsa=controllo;
        end loop;
end
$$
language plpgsql;

create trigger trigger_1
    after insert or update
    on l.log
    for each row
    when ( new.operazione = 'abort' )
execute function l.function_trigger();