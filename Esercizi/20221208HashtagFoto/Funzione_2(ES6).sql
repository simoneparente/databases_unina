/*
  Usando SQL DINAMICO si scriva una funzione che riceve in ingresso
una lista di tag separati dal carattere @ e che restituisce una stringa degli
uri delle foto (separati da @) a cui sono associati tutti i tag passati per parametro
 */

CREATE OR REPLACE PROCEDURE f.prova1(input VARCHAR(500)) AS
$$
DECLARE
    Comando VARCHAR(500):='SELECT uri FROM f.foto WHERE';
    cursore CURSOR FOR SELECT parola, uri FROM f.foto NATURAL JOIN f.tagfoto;
    uri_attuale f.foto.uri%TYPE;
    uri_prev f.foto.uri%TYPE;
    i_parola f.hashtag.parola%TYPE;
    t_parola f.hashtag.parola%TYPE;
    n_paroleinput INTEGER:=regexp_count(input, '@')+1;
    n_paroleTable INTEGER:= (SELECT count(*) FROM f.foto NATURAL JOIN f.tagfoto);
    match INTEGER:=0;
    varend VARCHAR(8):=' AND ';
    BEGIN
        OPEN cursore;
        FOR i IN 1..n_paroleTable LOOP
            FETCH cursore INTO t_parola, uri_attuale;
            RAISE NOTICE 'uriattuale{%}, uriprev{%}', uri_attuale, uri_prev;
            if(uri_attuale<>uri_prev) THEN match=0; END IF;
            FOR j IN 1..n_paroleinput LOOP
                i_parola=split_part(input, '@', j);
                if(i_parola=t_parola) THEN
                    RAISE NOTICE 'parolatable{%} parolainput{%}', t_parola, i_parola;
                    match=match+1;
                end if;
                if(n_paroleinput=match) THEN
                    RAISE NOTICE 'n_parole(%), match(%)', n_paroleinput, match;
                    Comando= Comando || 'uri=' || '''' ||uri_attuale || '''';
                    EXIT;
                end if;
                end loop;
            uri_prev=uri_attuale;

            END LOOP;
        CLOSE cursore;

        RAISE NOTICE '%', Comando;
        END

    $$
language plpgsql;

CALL f.prova1('prova11@prova12');

SELECT uri FROM f.foto WHERE uri='uri1' AND uri='uri1' AND uri='uri2'