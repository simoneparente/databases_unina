/*Si implementi il seguente trigger. Quando una transazione registra
una operazione di ABORT sul log, tutte le scritture fatte dalla transazione e riportate sul LOG
devono essere annullate in ordine inverso a quelle in cui sono state fatte. Per annullare le
scritture si deve consultare il log e si deve assegnare ad ogni risorsa scritta dalla transizione
il valore ValorePrima riportato nel LOG. Inoltre, le risorse assegnate alla transazione devono
tornare libere: si rimuovono le assegnazioni alla transazione e lo stato della risorsa assume
valore UNLOCK.*/
DELETE FROM l.log WHERE cod=99;

CREATE OR REPLACE FUNCTION l.funzione1() RETURNS TRIGGER
AS
    $$
    DECLARE
        controllo integer:=0;
    count INTEGER:=(SELECT COUNT(*)
                    FROM l.log
                    WHERE codtransazione=NEW.codtransazione);
    operazioniprecedenti CURSOR FOR (
        SELECT codrisorsa
        FROM l.log
        WHERE codtransazione=NEW.codtransazione
        ORDER BY log.timestamp DESC
    );
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
UPDATE l.risorsa SET valore=valoreprima FROM l.log WHERE risorsa.codrisorsa=1;

INSERT INTO l.log(cod, operazione, codrisorsa, valoreprima, valoredopo, codtransazione, timestamp)
values (99, 'ABORT', 4, NULL, NULL, 51, 8);