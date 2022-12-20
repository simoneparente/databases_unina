--START
CREATE OR REPLACE PROCEDURE l.f_2(tOUT l.richieste.tempo%TYPE) AS $$
    DECLARE
        tCorrente l.richieste.tempo%TYPE = 5;
        tRegistrazione l.richieste.tempo%TYPE;
        tAttesa l.richieste.tempo%TYPE;
        cursTrans CURSOR FOR (SELECT DISTINCT codTransazione FROM l.richieste);
        currentTrans l.richieste.codtransazione%TYPE;
        numTrans INTEGER = (SELECT DISTINCT COUNT(codTransazione) FROM l.richieste);
        currentRisorsa l.richieste.codrisorsa%TYPE;
    BEGIN
        open cursTrans;
        FOR i in 1..numTrans LOOP
            FETCH cursTrans INTO currentTrans;
            RAISE NOTICE 'CurrentTrans {%}', currentTrans;
            IF EXISTS (SELECT * FROM l.richieste as re NATURAL JOIN l.risorsa as ra
                       WHERE re.codtransazione<>currentTrans AND ra.stato <> 'UNLOCK') THEN
                --controlla attesa di quel cod trans e vedi che cazzo succese calcola tempo attesa
                FOR currentRisorsa IN (SELECT * FROM l.richieste as re NATURAL JOIN l.risorsa as ra
                                       WHERE re.codtransazione<>currentTrans AND ra.stato <> 'UNLOCK') LOOP
                    RAISE NOTICE 'CurrentRisorsa {%}', currentRisorsa;
                    IF EXISTS (SELECT * FROM l.richieste
                               WHERE codtransazione=currentTrans AND codrisorsa=currentRisorsa) THEN
                        --calcolo tempo attesa
                        tRegistrazione = (SELECT tempo FROM l.richieste WHERE codrisorsa=currentRisorsa AND codtransazione=currentTrans);
                        tAttesa = tCorrente - tRegistrazione;
                        RAISE NOTICE 'tAttesa {%}', tAttesa;
                        RAISE NOTICE 'tRegistrazione {%}', tRegistrazione;
                        if tAttesa < tOUT THEN
                            RAISE NOTICE 'DEADLOCK';
                        end if;
                    end if;
                end loop;
            end if;
        end loop;
    end;
$$ LANGUAGE plpgsql;

CALL l.f_2(1)