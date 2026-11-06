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