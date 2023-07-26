--Start

CREATE OR REPLACE PROCEDURE l.funzione2(Tout INTEGER) AS
$$
DECLARE
    tattuale                  INTEGER=5; --sono le 5
    T1_n_transazioni          INTEGER := (SELECT count(codtransazione)
                                          FROM l.richieste
                                          WHERE (tattuale - tempo) > Tout); --le richieste sono state fatte alle 2
    T1_c_transazioni_risorse CURSOR FOR SELECT codtransazione, ris.codrisorsa
                                        FROM l.richieste ric
                                                 JOIN l.risorsa ris ON ris.codrisorsa = ric.codrisorsa
                                        WHERE (tattuale - ric.tempo) > Tout
                                          AND ris.stato <> 'UNLOCK'; --T1
    T1_transazione            l.richieste.codtransazione%TYPE;
    T1_risorsa                l.richieste.codrisorsa%TYPE;
    T2_n_transazioni          INTEGER := (SELECT COUNT(*)
                                          FROM l.assegnazione);
    T2_c_transazioni_risorse CURSOR FOR SELECT codtransazione, codrisorsa
                                        FROM l.assegnazione;
    T2_transazione            l.richieste.codtransazione%TYPE;
    T2_risorsa                l.richieste.codrisorsa%TYPE;
    transazioniBloccate       VARCHAR(500) := '';
    numeroTransazioniBloccate INTEGER;
    transazioneBloccata1      l.richieste.codtransazione%TYPE;
    transazioneBloccata2      l.richieste.codtransazione%TYPE;
BEGIN
    OPEN T1_c_transazioni_risorse;
    for i IN 1..T1_n_transazioni
        LOOP
            RAISE NOTICE 'i(%)', i;
            FETCH T1_c_transazioni_risorse INTO T1_transazione, T1_risorsa;
            OPEN T2_c_transazioni_risorse;
            FOR j IN 1..T2_n_transazioni
                LOOP
                    RAISE NOTICE 'j(%)', j;
                    FETCH T2_c_transazioni_risorse INTO T2_transazione, T2_risorsa;
                    raise notice 'T1:(%), T2:(%)', T1_risorsa, T2_risorsa;
                    if (T1_risorsa = T2_risorsa) THEN
                        RAISE NOTICE 'siamo uguali';
                        transazioniBloccate = transazioniBloccate || '@' || T1_transazione;
                    end if;
                end loop;
            CLOSE T2_c_transazioni_risorse;
        end loop;
    CLOSE T1_c_transazioni_risorse;
    RAISE NOTICE 'output:{%}', transazioniBloccate;
    numeroTransazioniBloccate = regexp_count(transazioniBloccate, '@');
    for x in 1..numeroTransazioniBloccate
        LOOP
            transazioneBloccata1 = split_part(transazioniBloccate, '@', x);
            for y in 1..numeroTransazioniBloccate
                LOOP
                    transazioneBloccata2 = split_part(transazioniBloccate, '@', x);
                    if EXISTS()
                    end loop;
                end loop;

            --loop sulle parole output
            --controllo la singola parola output con tutte le altre e vedo se le risorse l'ha l'altro
            --se si le segno altrimenti fattelo in mano merda
        end
$$ LANGUAGE plpgsql;

CALL l.funzione2(2); --le richieste aspettano per massimo TOUT ore