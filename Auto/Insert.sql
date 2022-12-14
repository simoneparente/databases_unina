
INSERT INTO v.AUTO(targa, codfis, categoria) values (1, 1, 1),
                                                    (2, 2, 2);


INSERT INTO v.PCHECK(puntocheck, velocitamax) values ('prova', 10);
INSERT INTO v.PCHECK(puntocheck, velocitamax) values ('prova1', 10);

INSERT INTO v.TARIFFE(ingresso, uscita, km, categoria, costo) values ('ingresso1_cat1','uscita1_cat1', 10, 1, 10),
                                                                     ('ingresso1_cat2','uscita1_cat2', 10, 2, 20),
                                                                     ('ingresso2_cat1','uscita2_cat1', 20, 1, 11),
                                                                     ('ingresso2_cat2','uscita2_cat2', 20, 2, 22);




INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo) VALUES ('prova', 1, 9, '2001-01-01', '00:30');
INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo) VALUES ('prova1', 1, 11, '2001-01-01', '00:45');

INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo)
    VALUES  ('prova', '2', 11,'2007-07-07','00:45'),
            ('prova1', '2', 9,'2007-07-07','00:40'),
            ('prova1', '2', 11,'2007-12-07','01:50');

INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo)
values ('prova', '1', 9, '2001-01-01', '00:00:00'); -- non infrangono

INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo)
values ('prova', '1', 110, '2001-01-01', '00:00:10'); -- infrangono

INSERT INTO v.VIAGGIO(CODICEVIAGGIO, TARGA, DATAI, ORAI, INGRESSO)
(
    values (1, 1, '2001-01-01','01:01', 'ingresso1_cat1'),
           (2, 1, '2001-01-01', '11:11', 'ingresso2_cat1'),
           (3, 2, '2012-12-12', '12:12', 'ingresso1_cat2'),
           (4, 2, '2022-12-22', '22:22', 'ingresso2_cat2')
);

UPDATE v.viaggio
SET    uscita='uscita1_cat1'
WHERE codiceviaggio='1';

UPDATE v.viaggio
SET    uscita='uscita2_cat1'
WHERE  codiceviaggio='2';

UPDATE v.viaggio
SET    uscita='uscita1_cat2'
WHERE codiceviaggio='3';

UPDATE v.viaggio
SET    uscita='uscita2_cat2'
WHERE codiceviaggio='4';