INSERT INTO F.album(coda, titolo, inalbum)
    values (1, 'padre1', null),
           (11, 'padre1-figlio1', 1),
           (12, 'padre1-figlio2', 1),
           (13, 'padre1-figlio3', 1),
           --ALBUM 11
           (111, 'padre11-figlio1', 11),
           (112, 'padre11-figlio2', 11),
           (113, 'padre11-figlio3', 11),
           --ALBUM 113
           (1131, 'padre113-figlio1', 113),
           --ALBUM 13
            (131, 'padre13-figlio1', 13),
            (132, 'padre13-figlio2', 13),
           --ALBUM 2
            (2, 'padre2', null),
           (21, 'padre2-figlio1', 2),
           (22, 'padre2-figlio2', 2);


INSERT INTO f.hashtag(parola)
values  ('caso'),
        ('prova'),
        ('sei'),
        ('un'),
        ('grande'),
        ('bionda'),
        ('luigi');

INSERT INTO f.tagalbum(coda, parola)
values (1,'caso'),
       (1,'grande'),
       (11,'bionda'),
       (12,'bionda'),
       (13,'caso'),
       --ALBERO 2
       (2,'bionda'),
       (21,'grande'),
       (22,'caso'),
       (22,'luigi');

INSERT INTO f.foto(codf, uri)
values (1, 'uri1'),
       (2,'uri2'),
       (3,'uri3'),
       (4,'uri4');

INSERT INTO f.hashtag(parola)
values ('prova11'),
       ('prova12'),
       ('prova13'),
       ('prova21'),
       ('prova22'),
       ('prova23'),
       ('prova31'),
       ('prova32');

INSERT INTO f.tagfoto(codf, parola)
values (1,'prova11'),
       (1,'prova12'),
       (1,'prova13'),
       --foto 2
       (2,'prova21'),
       (2,'prova22'),
       (2,'prova23'),
       --foto 3
       (3,'prova31'),
       (3,'prova32');

INSERT INTO f.hashtag(parola) values ('provatabelle1e3');

INSERT INTO f.tagfoto(codf, parola) VALUES
                                        (1,'provatabelle1e3'),
                                        (3,'provatabelle1e3');