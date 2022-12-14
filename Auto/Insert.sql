

INSERT INTO v.AUTO(targa, codfis, categoria) values (1, 1, 1),
                                                    (2, 2, 2);


INSERT INTO v.PCHECK(puntocheck, velocitamax) values ('prova', 10);
INSERT INTO v.PCHECK(puntocheck, velocitamax) values ('prova1', 10);

INSERT INTO v.TARIFFE(ingresso, uscita, km, categoria, costo) values ('prova','uscita', 10, 1, 10);
INSERT INTO v.TARIFFE(ingresso, uscita, km, categoria, costo) values ('prova1','uscita', 10, 1, 10);

INSERT INTO v.VIAGGIO(km, tariffa, codiceviaggio, ingresso, datai, targa, orai) values (null, null, 1, 'prova', '2001-01-01', 1, '00:00');


INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo) VALUES ('prova', 1, 9, '2001-01-01', '00:30');
INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo) VALUES ('prova1', 1, 11, '2001-01-01', '00:45');

INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo)
    VALUES  ('prova', '2', 11,'2007-07-07','00:45'),
            ('prova1', '2', 9,'2007-07-07','00:40');

INSERT INTO v.CHECK(puntocheck, targa, velocita, data, tempo)
    VALUES  ('prova1', '2', 11,'2007-12-07','01:50');