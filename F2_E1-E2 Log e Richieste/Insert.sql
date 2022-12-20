INSERT INTO l.risorsa(codrisorsa, valore, stato)
values (1, '1risorsa52', 'w-lock'),
       (2, '2risorsa', 'w-lock'),
       (3, '3risorsa', 'w-lock'),
       (4, '4risorsa', 'w-lock'),
       (5, '5risorsa', 'w-lock');

INSERT INTO l.assegnazione(codtransazione, tempo, codrisorsa)
VALUES (52, 1, 1),
       (52, 1, 2),
       (53, 1, 3),
       (53, 1, 4),
       (51, 1, 5);

INSERT INTO l.log(cod, operazione, codrisorsa, valoreprima, valoredopo, codtransazione, timestamp)
VALUES (21, 'MODIFICA', 1, null, 'valoredopo1', 51, 1),
       (22, 'MODIFICA', 2, null, 'valoredopo2', 51, 2),
       (231, 'CANCELLA', 1, 'valoredopo1', null, 52, 2),
       (222, 'MODIFICA', 2, 'valoredopo2', 'valoredopodopo2', 52, 2),
       (23, 'MODIFICA', 3, 'valore3', 'valoredopo3', 53, 3);

INSERT INTO l.richieste(codtransazione, tempo, tipoaccesso, codrisorsa)
VALUES (51, 2, 'accesso1',1),
       (52, 2, 'accesso2',5);
