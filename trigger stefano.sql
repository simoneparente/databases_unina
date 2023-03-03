CREATE TRIGGER cancella_prenotazioni
    AFTER INSERT OR UPDATE
    ON prestito
    FOR EACH ROW
    WHEN (articolo.datapubblicazione IS NOT NULL)
EXECUTE FUNCTION b.prova;

CREATE FUNCTION b.prova() RETURNS TRIGGER AS
$$
DECLARE
    id_utente prestito.utente%TYPE=(SELECT UTENTE
                                    FROM PRESTITO
                                    WHERE codprestito = NEW.codprestito);
BEGIN
    DELETE FROM prenotazione p WHERE p.utente = id_utente;
end;
$$
    language plpgsql;



CREATE TRIGGER richieste_prestito
    AFTER INSERT
    ON prestito
    FOR EACH ROW
DECLARE
    v_ISBN libro.ISBN%TYPE = (SELECT ISBN
    FROM prestito p
    JOIN esemplare e
    WHERE p.codicebarre = e.codicebarre
    AND codprestito = NEW.codprestito);
BEGIN
DELETE
from PRENOTAZIONE
WHERE utente = NEW.utente
  AND ISBN = v_ISBN;
END;
$$