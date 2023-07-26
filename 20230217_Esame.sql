Esercizio 3
1) ALTER TABLE COMPORDINE
    ADD CONSTRAINT UQ_ArticoloOrdine UNIQUE (CodO, CodA);

2) ALTER TABLE LISTINO
ADD CONSTRAINT CK_PrezziQuantita CHECK
(quantita1>quantita2)


SE QUANTITA1>QUANTITA2
ALLORA QUANTITA1/PREZZO1<QUANTITA2/PREZZO2



COMPORDINE (CODO, CODA, QUANTITA, PREZZO)
LISTINO (CODA, QUANTITA, PREZZO)

3)CREATE ASSERTION vincolo3
CHECK ((SELECT prezzo FROM CompOrdine c WHERE CodA=QualcheCodA)<=(SELECT prezzo FROM Listino l WHERE coda=coda AND c.quantita=l.quantita) )



ESERCIZIO 5 commentato


CREATE OR REPLACE FUNCTION es5 RETURNS TRIGGER AS
$$
DECLARE
cursore_ArticoliQuantita CURSOR FOR (SELECT CodA, Quantita
									 FROM CompOrdine
									 WHERE CodO=NEW.CodO); --cursore per scorrere i codici degli articoli dell'ordine
Quantita_Art_Attuale Magazzino.Quantita%TYPE;
CodA_Attuale Magazzino.CodA%TYPE; 
n_articoli_ordine INTEGER:=(SELECT COUNT(*) FROM CompOrdine WHERE CodO=NEW.CodO); --numero di articoli dell'ordine

n_articoli_check INTEGER:=0; --numero di articoli di cui è presente almeno la quantità richiesta
BEGIN
OPEN cursore_ArticoliQuantita;
FOR i IN 1..n_articoli_ordine LOOP
	FETCH cursore_ArticoliQuantita INTO CodA_Attuale, Quantita_Art_Attuale;
	IF EXISTS(SELECT *
			  FROM Magazzino
			  WHERE CodA=CodA_Attuale 
			  AND Quantita>=Quantita_Art_Attuale) THEN
			  n_articoli_check=n_articoli_check+1;
	END IF;
END LOOP;

IF(n_articoli_ordine<>n_articoli_check)
	UPDATE Ordine SET Completo='N' WHERE CodO=NEW.CodO;
ELSE IF
MOVE ABSOLUTE 0 FROM cursore_ArticoliQuantita;
FOR i IN 1..n_articoli LOOP
	FETCH cursore_ArticoliQuantita INTO CodA_Attuale, Quantita_Art_Attuale;
	UPDATE Magazzino SET Quantita=Quantita-Quantita_Art_Attuale WHERE CodA=CodA_Attuale;
END LOOP;
CLOSE cursore_ArticoliQuantita;
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;


CREATE TRIGGER trig_es5 
BEFORE UPDATE ON b.Ordine
WHEN (Completo='S')
EXECUTE FUNCTION es5;


ESERCIZIO 5 non commentato


CREATE OR REPLACE FUNCTION es5 RETURNS TRIGGER AS
$$
DECLARE
cursore_ArticoliQuantita CURSOR FOR (SELECT CodA, Quantita
									 FROM CompOrdine
									 WHERE CodO=NEW.CodO);
Quantita_Art_Attuale Magazzino.Quantita%TYPE;
CodA_Attuale Magazzino.CodA%TYPE; 
n_articoli_ordine INTEGER:=(SELECT COUNT(*) FROM CompOrdine WHERE CodO=NEW.CodO);

n_articoli_check INTEGER:=0; 
BEGIN
OPEN cursore_ArticoliQuantita;
FOR i IN 1..n_articoli_ordine LOOP
	FETCH cursore_ArticoliQuantita INTO CodA_Attuale, Quantita_Art_Attuale;
	IF EXISTS(SELECT *
			  FROM Magazzino
			  WHERE CodA=CodA_Attuale 
			  AND Quantita>=Quantita_Art_Attuale) THEN
			  n_articoli_check=n_articoli_check+1;
	END IF;
END LOOP;

IF(n_articoli_ordine<>n_articoli_check)
	UPDATE Ordine SET Completo='N' WHERE CodO=NEW.CodO;
ELSE IF
MOVE ABSOLUTE 0 FROM cursore_ArticoliQuantita;
FOR i IN 1..n_articoli LOOP
	FETCH cursore_ArticoliQuantita INTO CodA_Attuale, Quantita_Art_Attuale;
	UPDATE Magazzino SET Quantita=Quantita-Quantita_Art_Attuale WHERE CodA=CodA_Attuale;
END LOOP;
CLOSE cursore_ArticoliQuantita;
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;


CREATE TRIGGER trig_es5 
BEFORE UPDATE ON b.Ordine
WHEN (Completo='S')
EXECUTE FUNCTION es5;

TUTTI GLI ARTICOLI CHE HANNO SCORTA 
SUFFICIENTE IN MAGAZZINO  (R1) <- select di CodA, CodO(CompOrdine c JOIN Magazzino m ON m.Coda=c.CodA
											WHERE m.quantita>=c.quantita)

RESULT <-SELECT CodA (R1 JOIN Ordine o ON r1.codO=o.CodO) WHERE Completo='N';