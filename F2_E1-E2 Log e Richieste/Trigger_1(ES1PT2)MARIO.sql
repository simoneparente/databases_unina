--ES1 PT2 Mario Penna
CREATE OR REPLACE FUNCTION l.funzione1() RETURNS TRIGGER AS $$
    DECLARE
        controllo integer:=0;
        count INTEGER:=(SELECT COUNT(*) FROM l.log WHERE codtransazione=NEW.codtransazione);
        operazioniprecedenti CURSOR FOR (SELECT codrisorsa FROM l.log WHERE codtransazione=NEW.codtransazione
                                         ORDER BY log.timestamp DESC);
    BEGIN
        OPEN operazioniprecedenti;
        FOR i IN 1..count LOOP
            FETCH operazioniprecedenti INTO controllo;
            RAISE NOTICE 'controllo{%}', controllo;
            UPDATE l.risorsa SET valore=valoreprima, stato='UNLOCK' FROM l.log WHERE risorsa.codrisorsa=controllo;
        END LOOP;
        RETURN NEW;
    end;
    $$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger1 BEFORE INSERT OR UPDATE ON l.log
FOR EACH ROW
WHEN (NEW.operazione='ABORT')
EXECUTE FUNCTION l.funzione1();