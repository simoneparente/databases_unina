create function u.funtion_1() returns varchar
as
$$
declare
    output_finale        text;
    data_corrente        u.prestiti.sollecito%TYPE;
    risultato_query      record;
    cursore_2 cursor for (select *
                          from prestiti);
    query_utente_nome    varchar(1000);
    query_utente_cognome varchar(1000);
    query_libro_titolo   varchar(1000);
    nome_utente          u.utente.nome%TYPE;
    cognome_utente       u.utente.cognome%TYPE;
    titolo_libro         u.libro.titolo%TYPE;


begin
    open cursore_2;
        loop
            fetch cursore_2 into risultato_query;
            exit when not found;
            if (risultato_query.scadenza > data_corrente) then
                update u.prestiti set sollecito=True where codprestito=risultato_query.codprestito;
                query_utente_nome = 'select ut.nome' ||
                                    'from u.presito p join u.utente ut on ut.cf='
                                        || '''' || risultato_query.utente || '''';
                execute query_utente_nome into nome_utente;
                query_utente_cognome = 'select ut.cognome' ||
                                       'from u.presito p join u.utente ut on u.cf='
                                           || '''' || risultato_query.utente || '''';
                execute query_utente_cognome into cognome_utente;
                query_libro_titolo = 'select l.titolo' ||
                                     'from (u.presito p join u.esemplare e on p.codbarre=' ||
                                     'e.codbarre) join u.libro l on e.isbn = l.isbn' ||
                                     'where p.codprestito=' || '''' || risultato_query.codprestito || '''';
                execute query_libro_titolo into titolo_libro;
                output_finale = risultato_query.utente || nome_utente ||
                                cognome_utente || titolo_libro;

            end if;
        end loop;
end
$$
    language plpgsql;