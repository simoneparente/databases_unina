CREATE OR REPLACE PROCEDURE get_tags_by_album (p_CodA INTEGER)
AS
$$
DECLARE
  -- variabile per memorizzare i tag trovati
  l_tags TEXT;
BEGIN
  -- inizializza la variabile
  l_tags := '';

  -- seleziona i tag dell'album specificato
  SELECT DISTINCT parola
  INTO l_tags
  FROM TAGALBUM
  WHERE CodA = p_CodA;

  -- seleziona i tag degli album contenuti nell'album specificato
  FOR rec IN (SELECT DISTINCT CodA
              FROM INALBUM
              WHERE CodP = p_CodA)
  LOOP
    -- richiama la procedura ricorsivamente per ogni album contenuto
    l_tags := l_tags || ' ' || get_tags_by_album(rec.CodA);
  END LOOP;

END;
$$
LANGUAGE plpgsql;