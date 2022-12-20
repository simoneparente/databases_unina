-- Si scriva una procedura PLSQL che riceve in ingresso l’identificativo
-- di un album e che restituisce una stringa contenete tutti i tag associati
-- all’album e agli album in esso contenuti (ad ogni livello di profondit`a)
-- senza ripetizioni. Si consiglia di avvalersi di una tabella TMP(CodA)
-- ( che si suppone gi`a definita) dove memorizzare preventivamente l’albero degli
-- album radicato nell’album passato come parametro.


create function f.function_1(in codAlbum integer) returns varchar
as
$$
declare
    string varchar;
    cursor_album_1 cursor for (select inalbum
                               from f.album
                               where codAlbum=coda);
begin
    if (not codAlbum) then
        raise error_in_assignment;
        return string;
    end if;


end;
$$;