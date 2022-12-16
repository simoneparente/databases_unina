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
values  ('silvio'),
        ('barra'),
        ('sei'),
        ('un'),
        ('grande'),
        ('dio'),
        ('porco');

INSERT INTO f.tagalbum(coda, parola)
values (1,'silvio'),
       (1,'grande'),
       (11,'dio'),
       (12,'dio'),
       (13,'silvio'),
       --ALBERO 2
       (2,'dio'),
       (21,'grande'),
       (22,'silvio'),
       (22,'porco');

CREATE TABLE f.temp(coda INTEGER PRIMARY KEY);
INSERT INTO f.temp(coda)
VALUES (1),
       (11),
       (12),
       (13);




