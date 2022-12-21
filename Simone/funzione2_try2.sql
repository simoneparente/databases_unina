CREATE OR REPLACE PROCEDURE l.funzione2(IN Tout INTEGER) AS
$$
    DECLARE
        tattuale INTEGER=5; --sono le 5

        T1_n_transazioni INTEGER:=(SELECT count(codtransazione) FROM l.richieste WHERE (tattuale-tempo)>Tout);  --le richieste sono state fatte alle 2
        /*T1_c_transazioni_risorse CURSOR FOR                                                          --
            SELECT ri.codtransazione, ass.codtransazione
            FROM l.assegnazione ass, l.richieste ri
            WHERE ri.codrisorsa=ass.codrisorsa AND
                  ri.codtransazione<>ass.codtransazione; --T1*/
        T1_ri_transazione l.richieste.codtransazione%TYPE;
        T1_ass_transazione l.assegnazione.codtransazione%TYPE;
        T1_risorsa l.richieste.codrisorsa%TYPE;

        T2_n_transazioni INTEGER:=(SELECT COUNT(*) FROM l.assegnazione);
        T2_c_transazioni_risorse CURSOR FOR SELECT codtransazione, codrisorsa FROM l.assegnazione;
        T2_transazione l.richieste.codtransazione%TYPE;
        T2_risorsa l.richieste.codrisorsa%TYPE;
        rec record;

        --temporegistrazione INTEGER;
            --tempoattesa INTEGER:=temporegistrazione-tempo_corrente;
        output VARCHAR(500):='';
    BEGIN
        for rec in (SELECT ri.codtransazione, ass.codtransazione as asct
                                  FROM l.assegnazione ass, l.richieste ri
                                  WHERE ri.codrisorsa=ass.codrisorsa AND
                                        ri.codtransazione<>ass.codtransazione )
        loop
            if (rec.asct in (SELECT ri.codtransazione
                                  FROM l.assegnazione ass, l.richieste ri
                                  WHERE ri.codrisorsa=ass.codrisorsa AND
                                        ri.codtransazione<>ass.codtransazione )) then
                raise notice 'ass.codT{%} è in deadlock', rec.asct;
            end if;
            end loop;


        --end loop;
--
--
--
        --raise notice 'T1:(%), T2:(%)', T1_risorsa, T2_risorsa;
--
--
        --        if(T1_risorsa=T2_risorsa) THEN
        --            RAISE NOTICE 'siamo uguali';
        --        output=output || ' ' || T1_transazione;
        --        end if;
--RAISE NOTICE 'output:{%}', output;
    end
$$
LANGUAGE plpgsql;

CALL l.funzione2(1); --le richieste aspettano per massimo TOUT ore

SELECT ri.codtransazione, ri.codrisorsa, ass.codrisorsa, ass.codtransazione
FROM l.assegnazione ass, l.richieste ri
WHERE ri.codrisorsa=ass.codrisorsa AND ri.codtransazione<>ass.codtransazione;



CREATE OR REPLACE PROCEDURE f.provawhile() AS $$
    DECLARE
        variabile f.hashtag.parola%TYPE;
        cursore CURSOR FOR SELECT parola FROM f.hashtag;
    BEGIN
        while((FETCH cursore INTO variabile)<0) LOOP

            end loop;

    end;
    $$