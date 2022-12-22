--Start
CREATE OR REPLACE FUNCTION l.f_1(IN tout INTEGER) RETURNS TEXT AS $$
    DECLARE
        tAttuale INTEGER = 5;
        cursorTransRIC CURSOR FOR SELECT DISTINCT ri.codtransazione FROM l.assegnazione as a, l.richieste as ri
                                  WHERE ri.codtransazione<>a.codtransazione AND ri.codrisorsa=a.codrisorsa AND tAttuale-ri.tempo>tout;
        numTransRIC INTEGER = (SELECT DISTINCT count(ri.codtransazione) FROM l.assegnazione as a, l.richieste as ri
                             WHERE ri.codtransazione<>a.codtransazione AND ri.codrisorsa=a.codrisorsa AND tAttuale-ri.tempo>tout);
        transRIC l.richieste.codtransazione%TYPE;
        output TEXT;
    BEGIN
        OPEN cursorTransRIC;
        FOR i in 1..numTransRIC LOOP
            FETCH cursorTransRIC INTO transRIC;
            IF EXISTS (SELECT DISTINCT a.codtransazione FROM l.assegnazione as a, l.richieste as ri
                      WHERE ri.codtransazione<>a.codtransazione AND ri.codrisorsa=a.codrisorsa
                            AND a.codtransazione = transRIC) THEN
                RAISE NOTICE 'DEADLOCK TRANS {%}', transRIC;
                output = concat(output, transRIC);
            end if;
        end loop;
        RETURN output;
    end;
$$ LANGUAGE plpgsql;

SELECT l.f_1(2);