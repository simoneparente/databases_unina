/*
 Si scriva una funzione con parametro intero T out che per tutte le
transazioni T1 che sono in attesa per una risorsa per un tempo superiore a T out (differenza tra
il tempo di registrazione della richiesta e il tempo corrente) controlli se ci sia un deadlock (cio`e
se esiste un’altra transazione T2 che occupa la risorsa richiesta e la transazione T2 richiede
una risorsa assegnata alla transazione T1). La funzione restituisce una stringa coi codici delle
transazioni T1 in deadlock cosi trovate
 */

CREATE OR REPLACE PROCEDURE l.funzione2(IN Tout INTEGER) AS
$$
    DECLARE
        tattuale INTEGER=5; --sono le 5
        T1_n_transazioni INTEGER:=(SELECT count(codtransazione) FROM l.richieste WHERE (tattuale-tempo)>Tout);  --le richieste sono state fatte alle 2
        T1_c_transazioni_risorse CURSOR FOR                                                          --
            SELECT codtransazione, ris.codrisorsa
            FROM l.richieste ric JOIN l.risorsa ris ON ris.codrisorsa = ric.codrisorsa
            WHERE (tattuale-ric.tempo)>Tout AND ris.stato<>'UNLOCK'; --T1
        T1_transazione l.richieste.codtransazione%TYPE;
        T1_risorsa l.richieste.codrisorsa%TYPE;

        T2_n_transazioni INTEGER:=(SELECT COUNT(*) FROM l.assegnazione);
        T2_c_transazioni_risorse CURSOR FOR SELECT codtransazione, codrisorsa FROM l.assegnazione;
        T2_transazione l.richieste.codtransazione%TYPE;
        T2_risorsa l.richieste.codrisorsa%TYPE;

        --temporegistrazione INTEGER;
        --tempo_corrente INTEGER:=5;
            --tempoattesa INTEGER:=temporegistrazione-tempo_corrente;
        output VARCHAR(500):='';
    BEGIN
        OPEN T1_c_transazioni_risorse;                      --T1 APERTO
        for i IN 1..T1_n_transazioni LOOP
            RAISE NOTICE 'i(%)', i;
            FETCH T1_c_transazioni_risorse INTO T1_transazione, T1_risorsa;
            OPEN T2_c_transazioni_risorse;                                      --T2 APERTO
            FOR j IN 1..T2_n_transazioni LOOP
                RAISE NOTICE 'j(%)', j;
                FETCH T2_c_transazioni_risorse INTO T2_transazione, T2_risorsa;
                raise notice 'T1:(%), T2:(%)', T1_risorsa, T2_risorsa;
                if(T1_risorsa=T2_risorsa) THEN
                    RAISE NOTICE 'siamo uguali';
                output=output || ' ' || T1_transazione;
                end if;
                end loop;

            CLOSE T2_c_transazioni_risorse;                                     --T2 CHIUSO
            end loop;
        CLOSE T1_c_transazioni_risorse;                         --T1 chiuso
RAISE NOTICE 'output:{%}', output;
    end
$$
LANGUAGE plpgsql;

CALL l.funzione2(2); --le richieste aspettano per massimo TOUT ore

