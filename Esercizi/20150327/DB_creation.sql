drop schema u;
create schema u;

create table u.libro(
    isbn    varchar(10)
        primary key,
    titolo  varchar(20),
    editore varchar(20),
    anno    varchar(4)
);

create table u.esemplare(
    ISBN          varchar(10),
    codicebarre   varchar(20)
        primary key,
    collocazione  varchar(10),
    prestito      boolean,
    consultazione boolean,
    constraint fk_libro foreign key (ISBN) references u.libro(isbn)
);


create table u.profilo(
    codprofilo  varchar(5)
        primary key,
    maxdurata   int,
    maxprestito int
);

create table u.utente(
    cf         varchar(10) primary key ,
    codprofilo varchar(5),
    nome       varchar(15),
    cognome    varchar(15),
    data      date,

    constraint fk_profilo foreign key (codprofilo) references u.profilo(codprofilo)
);
create table u.prestiti(
    codprestito  serial primary key,
    codbarre     varchar(20),
    utente       varchar(10),
    data         date,
    scadenza     date,
    restituzione date,
    sollecito    date,

    constraint fk_esemplare foreign key (codbarre) references u.esemplare(codicebarre),
    constraint fk_utente foreign key (utente) references u.utente(cf)
);
create table u.prenotazione(
    codprenotazione serial,
    isbn            varchar(10),
    utente          varchar(10),
    data            date,
    constraint fk_libro foreign key (isbn) references u.libro(isbn),
    constraint fk_utente foreign key (utente) references u.utente(cf)
);

insert into u.libro (isbn, titolo, editore, anno)
VALUES ('978-88-17-00000-0', 'Il Signore degli Anelli', 'Mondadori', '1954');

insert into u.esemplare(isbn, codicebarre, collocazione, prestito, consultazione)
VALUES ('978-88-17-00000-0', '9788817000000', 'A1', false, false);

insert into u.profilo(codprofilo, maxdurata, maxprestito)
VALUES ('A', 30, 3);

insert into u.utente(cf, codprofilo, nome, cognome, data)
VALUES ('RSSMRA80A01F205X', 'A', 'Mario', 'Rossi', '1980-01-01');

insert into u.prestiti(codbarre, utente, data, scadenza, restituzione, sollecito)
VALUES ('9788817000000', 'RSSMRA80A01F205X', '2018-01-01', '2018-01-31', null, false);