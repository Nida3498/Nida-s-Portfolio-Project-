CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Create the Books table with the following columns:
-- book_id: unique identifier for each book, auto-incremented, primary key
-- title: the title of the book, cannot be null
-- author: the author of the book, cannot be null
-- genre: optional genre of the book
-- published_year: year the book was published
-- is_available: status if the book is available, defaults to TRUE (available)
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    published_year YEAR,
    is_available BOOLEAN DEFAULT TRUE
);

-- Create the Members table with the following columns:
-- member_id: unique identifier for each member, auto-incremented, primary key
-- name: member's full name, cannot be null
-- email: optional email address
-- phone_number: optional contact number
-- join_date: the date the member joined, defaults to the current date
CREATE TABLE Members (
    member_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(15),
    join_date DATE DEFAULT (CURRENT_DATE)
);

-- Create the Librarians table with the following columns:
-- librarian_id: unique identifier for each librarian, auto-incremented, primary key
-- name: librarian's full name, cannot be null
-- email: optional email address
-- phone_number: optional contact number
-- hire_date: the date the librarian was hired, defaults to the current date
CREATE TABLE Librarians (
    librarian_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(15),
    hire_date DATE DEFAULT (CURRENT_DATE)
);


-- Create the Borrowing table to manage borrowing transactions:
-- loan_id: unique identifier for each loan, auto-incremented, primary key
-- book_id: foreign key referencing the Books table
-- member_id: foreign key referencing the Members table
-- borrow_date: the date the book was borrowed, defaults to current date
-- return_date: the date the book was returned (can be NULL if not returned yet)
-- librarian_id: foreign key referencing the Librarians table
CREATE TABLE Borrowing (
    loan_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    return_date DATE,
    librarian_id INT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (librarian_id) REFERENCES Librarians(librarian_id)
);

-- Insert book records into the Books table
INSERT INTO Books (title, author, genre, published_year) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925),
('1984', 'George Orwell', 'Dystopian', 1949),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 1960);


-- Insert member records into the Members table
INSERT INTO Members (name, email, phone_number) VALUES
('Alen King', 'alenking@example.com', '1234567890'),
('Alece Hofman', 'alecehofman@example.com', '9876543210');


-- Insert librarian records into the Librarians table
INSERT INTO Librarians (name, email, phone_number) VALUES 
('Nail Horn', 'nail@example.com', '4567891230'), 
('Garden McGraw', 'garden@example.com', '7894561230');


-- Insert a new record into the Borrowing table
INSERT INTO Borrowing (book_id, member_id, librarian_id, borrow_date)
-- Specify the values for book_id, member_id, librarian_id, and the current borrow date
VALUES (1, 1, 1, CURRENT_DATE);


-- Update the Books table to mark book 1 as unavailable
UPDATE Books
-- Set the is_available field to FALSE (unavailable)
SET is_available = FALSE
-- Specify the book with book_id 1 to update
WHERE book_id = 1;


-- Update the Borrowing table to record the return date for loan 1
UPDATE Borrowing
-- Set the return_date field to the current date (indicating the book has been returned)
SET return_date = CURRENT_DATE
-- Specify the loan with loan_id 1 to update
WHERE loan_id = 1;


-- Update the Books table to mark book 1 as available
UPDATE Books
-- Set the is_available field to TRUE (indicating the book is available again)
SET is_available = TRUE
-- Specify the book with book_id 1 to update
WHERE book_id = 1;


-- Select all columns from the Books table for books that are available
SELECT * FROM Books
-- Filter the results to only include books where is_available is TRUE
WHERE is_available = TRUE;


-- Select member name, book title, borrow date, and return date for member 1
SELECT m.name, b.title, br.borrow_date, br.return_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get member information
JOIN Members m ON br.member_id = m.member_id
-- Join the Books table to get book titles
JOIN Books b ON br.book_id = b.book_id
-- Filter the results to show borrowing history for member 1
WHERE m.member_id = 1;


-- Select member name, book title, and borrow date for overdue books
SELECT m.name, b.title, br.borrow_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get member information
JOIN Members m ON br.member_id = m.member_id
-- Join the Books table to get book titles
JOIN Books b ON br.book_id = b.book_id
-- Filter for books that have not been returned (return_date is NULL)
WHERE br.return_date IS NULL
-- Further filter for books borrowed more than 14 days ago (overdue)
AND br.borrow_date < CURRENT_DATE - INTERVAL 14 DAY;


-- Select the title, genre, and published year of books
SELECT title, genre, published_year
-- From the Books table
FROM Books
-- Filter the results to include only books written by 'George Orwell'
WHERE author = 'George Orwell';


-- Select the title, author, and published year of books
SELECT title, author, published_year
-- From the Books table
FROM Books
-- Filter the results to include only books published after the year 2000
WHERE published_year > 2000;


-- Count the total number of books in the Books table
SELECT COUNT(*) AS total_books
-- From the Books table
FROM Books;


-- Select member name, borrow date, and return date for members who borrowed the book '1984'
SELECT m.name, br.borrow_date, br.return_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get member information
JOIN Members m ON br.member_id = m.member_id
-- Join the Books table to get book information, including the title
JOIN Books b ON br.book_id = b.book_id
-- Filter the results to show records for the book titled '1984'
WHERE b.title = '1984';


-- Select the book title, borrow date, and return date for the borrowing history of member 1
SELECT b.title, br.borrow_date, br.return_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Books table to get the book titles
JOIN Books b ON br.book_id = b.book_id
-- Filter the results to show the borrowing history for member 1
WHERE br.member_id = 1;


-- Select the title, author, and published year of available Fiction books
SELECT title, author, published_year
-- From the Books table
FROM Books
-- Filter the results to include only books in the Fiction genre
WHERE genre = 'Fiction'
-- Further filter the results to include only books that are available
AND is_available = TRUE;


-- Select the member name and count of books borrowed by each member
SELECT m.name, COUNT(br.loan_id) AS total_books_borrowed
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get member information
JOIN Members m ON br.member_id = m.member_id
-- Group the results by member name to get the count of borrowed books per member
GROUP BY m.name;


-- Select the member name, book title, and borrow date for overdue books that have not been returned
SELECT m.name, b.title, br.borrow_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get member information
JOIN Members m ON br.member_id = m.member_id
-- Join the Books table to get book titles
JOIN Books b ON br.book_id = b.book_id
-- Filter for records where the book has not been returned (return_date is NULL)
WHERE br.return_date IS NULL
-- Further filter for books borrowed more than 30 days ago (overdue)
AND br.borrow_date < CURRENT_DATE - INTERVAL 30 DAY;


-- Select the librarian name and count of borrowings they processed
SELECT l.name, COUNT(br.loan_id) AS total_borrowings
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Librarians table to get librarian information
JOIN Librarians l ON br.librarian_id = l.librarian_id
-- Group the results by librarian name to count their total borrowings
GROUP BY l.name
-- Order the results by total borrowings in descending order
ORDER BY total_borrowings DESC;


-- Select the member name, book title, and borrow date for books that have not been returned
SELECT m.name, b.title, br.borrow_date
-- From the Borrowing table with alias br
FROM Borrowing br
-- Join the Members table to get information about the member who borrowed the book
JOIN Members m ON br.member_id = m.member_id
-- Join the Books table to get the titles of the borrowed books
JOIN Books b ON br.book_id = b.book_id
-- Filter the results to include only records where the book has not been returned (return_date is NULL)
WHERE br.return_date IS NULL;





