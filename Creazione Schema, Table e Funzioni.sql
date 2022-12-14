--MARIO PENNA E SIMONE PARENTE MARTONE

CREATE SCHEMA e;



CREATE TABLE e.Nodo
(
    CodA  INTEGER,  --FK
    CodN  INTEGER, --PK
    Label INTEGER,

    CONSTRAINT Nodo_PK PRIMARY KEY (CodN)
);

CREATE TABLE e.Albero
(
    CodA INTEGER,
    root INTEGER,

    CONSTRAINT Albero_PK PRIMARY KEY (CodA),
    CONSTRAINT Nodo_PK FOREIGN KEY (root) REFERENCES e.Nodo(CodN)
);

CREATE TABLE e.Arco
(
    CodA    INTEGER, --FK
    CodArco INTEGER, --PK
    Padre   INTEGER, --FK
    Figlio  INTEGER, --FK

    CONSTRAINT Arco_PK PRIMARY KEY (CodArco),
    CONSTRAINT Albero_FK FOREIGN KEY (CodA) REFERENCES e.Albero(CodA),
    CONSTRAINT Padre_FK FOREIGN KEY (Padre) REFERENCES e.Nodo(CodN),
    CONSTRAINT Figlio_FK FOREIGN KEY (Figlio) REFERENCES e.Nodo(CodN)
);

ALTER TABLE e.Nodo
ADD CONSTRAINT  Albero_FK FOREIGN KEY (CodA) REFERENCES e.Albero(CodA);

INSERT INTO e.Albero(coda)
(
        values (1),
               (2),
               (3)
);

INSERT INTO e.Nodo(codn, coda, label) --nel disegno i numeri dei nodi corrispondono ai label
(           --albero 1
    values (11,1,1),
           (12,1,2),
           (13,1,3),
           (14,1,4),
           (15,1,5),
           (16,1,6),
           (17,1,7),
            --albero 2
           (210,2,10),
           (211,2,11),
           (212,2,12),
           (23,2,3),
           (26,2,6),
           (27,2,7),
           (214,2,14),
           (215,2,15),
           (216,2,16),
            --albero 3
           (321,3,21),
           (312,3,12),
           (315,3,15),
           (316,3,16),
           (323,3,23),
           (327,3,27),
           (328,3,28)
);

UPDATE e.Albero
SET root=11
WHERE coda=1;

UPDATE e.albero
SET root=210
WHERE coda=2;

UPDATE e.albero
SET root=321
WHERE coda=3;

INSERT INTO e.Arco(coda, codarco, padre, figlio)
( --ALBERO 1
        values (1, 112, 11, 12),
               (1, 113, 11, 13),
               (1, 124, 12, 14),
               (1, 125, 12, 15),
               (1, 136, 13, 16),
               (1, 137, 13, 17),
               --ALBERO 2
               (2, 21011, 210, 211),
               (2, 21012, 210, 212),
               (2, 2113, 211, 23),
               (2, 21114, 211, 214),
               (2, 21215, 212, 215),
               (2, 21216, 212, 216),
               (2, 236, 23, 26),
               (2, 237, 23, 27),
               --ALBERO 3
               (3, 32112, 321, 312),
               (3, 32123, 321, 323),
               (3, 31215, 312, 315),
               (3, 31216, 312, 316),
               (3, 32327, 323, 327),
               (3, 32328, 323, 328)
);

CREATE OR REPLACE FUNCTION e.somma_nodi(albero e.Albero.CodA%TYPE, nodo_input e.Nodo.CodN%TYPE)
    RETURNS INT
AS
  $$
    DECLARE
        somma_nodi INTEGER:=0;
        root_a e.Albero.root%TYPE;
        padre e.Arco.padre%TYPE;
        cursore e.Arco.figlio%TYPE:=nodo_input;
        labelv e.Nodo.label%TYPE:=0; --variabile label
        BEGIN
            SELECT root, N.label  --trovo radice dell'albero e relativo label
                into root_a, labelv --e lo salvo in due variabili distinte
                FROM e.Albero AS A NATURAL JOIN e.Nodo AS N
                WHERE albero=A.coda;
            somma_nodi=somma_nodi+labelv;  --sommo il label della radice

            WHILE cursore!=root_a LOOP      --salgo di nodo in nodo fino a raggiungere la radice precedentemente trovata
                SELECT A.padre
                    INTO padre
                    FROM e.Nodo AS N NATURAL JOIN e.Arco AS A
                    WHERE figlio=cursore;
                SELECT N.label
                    INTO labelv
                    FROM e.Nodo AS N
                    WHERE cursore=N.codn;
                somma_nodi:=somma_nodi+labelv; --sommo i label dei nodi
                cursore=padre;
            END LOOP;

            RETURN somma_nodi;
        END
$$

LANGUAGE plpgsql;

SELECT e.somma_nodi(2,27);


CREATE or REPLACE FUNCTION e.max_cammino (cod_albero e.albero.codA%TYPE)
RETURNS INT
AS
    $$
    DECLARE
    foglia e.Nodo.CodN%TYPE; --variabile in cui conserviamo il CodN di una foglia
    max INTEGER := 0;          --max valore del percorso dalla foglia alla radice
    i   INTEGER := 0;            --indice per loop
    n   INTEGER := (
        SELECT COUNT(*)     --numero di foglie dell'albero
            FROM (SELECT N.CodN
                    FROM e.Nodo AS N
                    WHERE coda = cod_albero
                    EXCEPT
                    SELECT A.padre
                        FROM e.Arco AS A
                  )     AS Q
        );            --numero di foglie dell'albero (da usare come max del loop)
    cursore CURSOR FOR       --cursore che scorre tutti i nodi senza figli(foglie)
        (
            SELECT N.CodN           --tutti i nodi
                FROM e.Nodo AS N
                WHERE coda=cod_albero
            EXCEPT                  --meno
            SELECT A.padre          --nodi con figli
                FROM e.Arco AS A
        );

BEGIN;

        OPEN cursore;

        WHILE i<n LOOP
            FETCH cursore INTO foglia;
            IF(max < e.somma_nodi(cod_albero, foglia)) THEN
                max = e.somma_nodi(cod_albero, foglia);
            END IF;
            i:=i+1;
        END LOOP;

        CLOSE cursore;
        RETURN max;
    END;

$$
LANGUAGE plpgsql;

SELECT e.max_cammino(1);