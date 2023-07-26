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

-- insert into

