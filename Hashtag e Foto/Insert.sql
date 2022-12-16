INSERT INTO F.album(coda, titolo, inalbum)
    values (1, 'padre1', null),
           (11, 'figlio11', 1),
           (12, 'figlio12', 1),
           (13, 'figlio13', 1),
           --ALBUM 2
            (2, 'padre2', null),
           (21, 'figlio21', 2),
           (22, 'figlio22', 2);

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

INSERT INTO f.temp(coda)
VALUES (1),
       (11),
       (12),
       (13);




