
CREATE OR REPLACE PROCEDURE f.f1(input varchar)
    AS $$
        DECLARE
        MyParola f.tagalbum.parola%TYPE;
        n INT := regexp_count(input,'@');
        BEGIN
            CREATE TABLE f.NotMatch(
                CodF  INTEGER PRIMARY KEY
            );
            CREATE TABLE f.Match(
                CodF INTEGER PRIMARY KEY
            );
            FOR i IN 1..n+1 LOOP
                MyParola= split_part(input,'@',i);
                INSERT INTO f.NotMatch(SELECT CodF
                                       FROM f.tagfoto
                                       EXCEPT(SELECT CodF
                                              FROM f.tagfoto
                                              WHERE EXISTS (SELECT CodF
                                                           FROM f.tagfoto
                                                           WHERE tagfoto.Parola=MyParola
                                                           )
                                             )
                                       );
                INSERT INTO f.Match(SELECT uri
                                       FROM f.tagfoto NATURAL  JOIN f.foto
                                       EXCEPT (SELECT uri
                                       FROM f.NotMatch NATURAL JOIN f.foto
                                              ));
            END LOOP;

        END;


        $$LANGUAGE plpgsql;

CALL f.f1('prova31@prova32@provatabelle1e3')