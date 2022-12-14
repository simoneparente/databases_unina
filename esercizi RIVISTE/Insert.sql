INSERT INTO r.rivista(ISNN)
values ('rivista1'),
       ('rivista2');

INSERT INTO r.fascicolo(isnn, codf)
values ('rivista1','fascicolo1'),
        ('rivista2','fascicolo2');

INSERT INTO r.parolechiave(isnn, parola)
values ('rivista1', 'silvio1'),
       ('rivista1', 'salernitana1'),
       ('rivista2', 'barra2');

INSERT INTO r.articolo(doi, codf, sommario)
values ('doi1', 'fascicolo1', 'silvio1 barra2 salernitana1 ');

