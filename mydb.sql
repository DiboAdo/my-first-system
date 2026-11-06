CREATE TABLE "Books" (
	"ID"	INTEGER NOT NULL,
	"Title"	TEXT NOT NULL,
	"Author"	TEXT NOT NULL,
	"Available"	INTEGER NOT NULL,
	PRIMARY KEY("ID")
);
INSERT INTO Books (ID, Title, Author,Available) VALUES (101,'Clean Code', 'Robert Martin',1);
INSERT INTO Books (ID, Title, Author,Available) VALUES (102,'The Pragmatic Programmer', 'Andrew Hunt',1);
INSERT INTO Books (ID, Title, Author,Available) VALUES (103,'Atomic Habits', 'James Clear',1);
UPDATE books SET available = 1 WHERE id = 102;
DELETE FROM books WHERE id = 103;
SELECT * FROM books;
CREATE TABLE members (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT
);

INSERT INTO members (name, phone) VALUES ('Abebe', '0911000001');
INSERT INTO members (name, phone) VALUES ('Sara', '0911000002');
CREATE TABLE loans (
  id INTEGER PRIMARY KEY,
  book_id INTEGER NOT NULL,
  member_id INTEGER NOT NULL,
  loan_date TEXT NOT NULL,
  return_date TEXT,
  FOREIGN KEY (book_id) REFERENCES books(id),
  FOREIGN KEY (member_id) REFERENCES members(id)
);

INSERT INTO loans (book_id, member_id, loan_date) VALUES (101, 1, '2026-11-01');
INSERT INTO loans (book_id, member_id, loan_date) VALUES (102, 2, '2026-11-03');

-- Queries
SELECT books.title, members.name, loans.loan_date
FROM loans
JOIN books ON loans.book_id = books.id
JOIN members ON loans.member_id = members.id;

SELECT books.title, members.name
FROM loans
JOIN books ON loans.book_id = books.id
JOIN members ON loans.member_id = members.id
WHERE loans.return_date IS NULL;

SELECT books.title, loans.loan_date
FROM loans
JOIN books ON loans.book_id = books.id
JOIN members ON loans.member_id = members.id
WHERE members.name = 'Abebe';

UPDATE loans SET return_date = '2026-11-06' WHERE id = 1;

SELECT members.name, COUNT(loans.id) AS total_loans
FROM members
LEFT JOIN loans ON loans.member_id = members.id
GROUP BY members.name;