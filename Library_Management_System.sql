-- Smart Library Management System Project

CREATE DATABASE SmartLibrary;
USE SmartLibrary;

-- ========================================================
-- 1. DATABASE SCHEMA & CREATION
-- ========================================================

-- Authors Table
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

-- Books Table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author_id INT,
    category VARCHAR(50),
    isbn VARCHAR(20),
    published_date DATE,
    price DECIMAL(8, 2),
    available_copies INT DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE SET NULL
);

-- Members Table
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    membership_date DATE
);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    fine_amount DECIMAL(6, 2) DEFAULT 0.00,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
);

-- ========================================================
-- DATA INSERTION (CRUD Operations Part 1)
-- ========================================================

INSERT INTO Authors (name, email) VALUES
('Stephen Hawking', 'hawking@email.com'),
('J.K. Rowling', 'rowling@email.com'),
('George Orwell', 'orwell@email.com'),
('Robert Martin', NULL),
('Yuval Noah Harari', 'harari@email.com');

INSERT INTO Books (title, author_id, category, isbn, published_date, price, available_copies) VALUES
('A Brief History of Time', 1, 'Science', '9780553380163', '1988-04-01', 450.00, 5),
('Harry Potter and the Philosophers Stone', 2, 'Fiction', '9780747532699', '1997-06-26', 650.00, 3),
('1984', 3, 'Fiction', '9780451524935', '1949-06-08', 300.00, 0),
('Clean Code', 4, 'Technology', '9780132350884', '2008-08-01', 850.00, 2),
('Sapiens', 5, 'History', '9780062316097', '2014-02-04', 490.00, 4),
('Brief Answers to the Big Questions', 1, 'Science', '9781984819192', '2018-10-16', 420.00, 1),
('Unpublished Work Draft', NULL, 'General', '0000000000', '2023-01-01', 150.00, 2);

INSERT INTO Members (name, email, phone_number, membership_date) VALUES
('Aarav Sharma', 'aarav@gmail.com', '9876543210', '2019-03-15'),
('Priya Patel', NULL, '9876543211', '2021-07-20'),
('Rohan Verma', 'rohan@gmail.com', '9876543212', '2023-01-10'),
('Ananya Sen', 'ananya@gmail.com', '9876543213', '2024-05-12'),
('Karan Mehta', NULL, '9876543214', '2018-11-05');

INSERT INTO Transactions (member_id, book_id, borrow_date, return_date, fine_amount) VALUES
(1, 1, '2026-03-01', '2026-03-10', 0.00),
(1, 2, '2026-04-01', '2026-04-20', 50.00),
(2, 4, '2026-05-10', '2026-05-15', 0.00),
(3, 5, '2026-08-01', NULL, 0.00),
(1, 6, '2026-08-15', '2026-08-25', 0.00),
(1, 4, '2026-09-01', NULL, 0.00);

-- ========================================================
-- 1. CRUD OPERATIONS (Continued)
-- ========================================================

-- Update book availability when borrowed/returned
UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = 4;
UPDATE Books SET available_copies = available_copies + 1 WHERE book_id = 1;

-- Temporarily disable safe updates mode for subquery DELETE operations
SET SQL_SAFE_UPDATES = 0;

-- Delete members who haven't borrowed any books in the last year
DELETE FROM Members 
WHERE member_id NOT IN (
    SELECT DISTINCT member_id 
    FROM Transactions 
    WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

-- Re-enable safe updates
SET SQL_SAFE_UPDATES = 1;

-- Retrieve all books with available copies
SELECT * FROM Books WHERE available_copies > 0;

-- ========================================================
-- 2. SQL CLAUSES (WHERE, HAVING, LIMIT)
-- ========================================================

-- Get books published after the year 2015
SELECT * FROM Books WHERE published_date > '2015-12-31';

-- Retrieve top 5 most expensive books
SELECT * FROM Books ORDER BY price DESC LIMIT 5;

-- Find members who joined before 2022
SELECT * FROM Members WHERE membership_date < '2022-01-01';

-- ========================================================
-- 3. SQL OPERATORS (AND, OR, NOT)
-- ========================================================

-- Science books under 500 price
SELECT * FROM Books WHERE category = 'Science' AND price < 500;

-- Books not available for borrowing
SELECT * FROM Books WHERE NOT available_copies > 0;

-- Members joined after 2020 OR borrowed > 3 books
SELECT m.member_id, m.name, m.membership_date 
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name, m.membership_date
HAVING m.membership_date > '2020-12-31' OR COUNT(t.transaction_id) > 3;

-- ========================================================
-- 4. SORTING & GROUPING DATA (ORDER BY, GROUP BY)
-- ========================================================

-- Alphabetical list of books
SELECT * FROM Books ORDER BY title ASC;

-- Number of books borrowed per member
SELECT member_id, COUNT(*) AS books_borrowed 
FROM Transactions 
GROUP BY member_id;

-- Total books by category
SELECT category, COUNT(*) AS total_books 
FROM Books 
GROUP BY category;

-- ========================================================
-- 5. AGGREGATE FUNCTIONS
-- ========================================================

-- Total number of books per category
SELECT category, COUNT(book_id) AS total_count FROM Books GROUP BY category;

-- Average price of books in the library
SELECT AVG(price) AS average_book_price FROM Books;

-- Most borrowed book
SELECT book_id, COUNT(*) AS times_borrowed 
FROM Transactions 
GROUP BY book_id 
ORDER BY times_borrowed DESC 
LIMIT 1;

-- Total fines collected
SELECT SUM(fine_amount) AS total_fines FROM Transactions;

-- ========================================================
-- 6 & 7. JOINS
-- ========================================================

-- INNER JOIN: Books with author names
SELECT b.book_id, b.title, a.name AS author_name 
FROM Books b
INNER JOIN Authors a ON b.author_id = a.author_id;

-- LEFT JOIN: Details of members who have borrowed books
SELECT DISTINCT m.member_id, m.name, m.email 
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
WHERE t.transaction_id IS NOT NULL;

-- RIGHT JOIN: Books that haven't been borrowed
SELECT b.book_id, b.title 
FROM Transactions t
RIGHT JOIN Books b ON t.book_id = b.book_id
WHERE t.transaction_id IS NULL;

-- FULL OUTER JOIN simulation: Members who have never borrowed a book
SELECT m.member_id, m.name
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
WHERE t.transaction_id IS NULL;

-- ========================================================
-- 8. SUBQUERIES
-- ========================================================

-- Books borrowed by members who registered after 2022
SELECT DISTINCT title FROM Books WHERE book_id IN (
    SELECT book_id FROM Transactions WHERE member_id IN (
        SELECT member_id FROM Members WHERE membership_date > '2022-12-31'
    )
);

-- Identify most borrowed book using a subquery
SELECT * FROM Books WHERE book_id = (
    SELECT book_id FROM Transactions 
    GROUP BY book_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- Members who have never borrowed a book
SELECT * FROM Members WHERE member_id NOT IN (
    SELECT DISTINCT member_id FROM Transactions WHERE member_id IS NOT NULL
);

-- ========================================================
-- 9. DATE & TIME FUNCTIONS
-- ========================================================

-- Extract publication year
SELECT title, YEAR(published_date) AS pub_year FROM Books;

-- Difference in days (late return fine calculation logic)
SELECT transaction_id, borrow_date, return_date, 
       DATEDIFF(return_date, borrow_date) AS days_kept 
FROM Transactions 
WHERE return_date IS NOT NULL;

-- Format borrow date as DD-MM-YYYY
SELECT transaction_id, DATE_FORMAT(borrow_date, '%d-%m-%Y') AS formatted_borrow_date 
FROM Transactions;

-- ========================================================
-- 10. STRING MANIPULATION FUNCTIONS
-- ========================================================

-- Uppercase titles
SELECT UPPER(title) AS uppercase_title FROM Books;

-- Trim whitespace from author names
SELECT TRIM(name) AS clean_name FROM Authors;

-- Replace missing emails with 'Not Provided'
SELECT name, IFNULL(email, 'Not Provided') AS email_status FROM Members;

-- ========================================================
-- 11. WINDOW FUNCTIONS
-- ========================================================

-- Rank books based on total times borrowed
SELECT book_id, COUNT(*) AS times_borrowed,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS borrow_rank
FROM Transactions
GROUP BY book_id;

-- Cumulative number of books borrowed per member
SELECT transaction_id, member_id, borrow_date,
       COUNT(*) OVER (PARTITION BY member_id ORDER BY borrow_date) AS cumulative_borrows
FROM Transactions;

-- Moving average of books borrowed over recent months
SELECT DATE_FORMAT(borrow_date, '%Y-%m') AS month,
       COUNT(*) AS monthly_borrows,
       AVG(COUNT(*)) OVER (ORDER BY DATE_FORMAT(borrow_date, '%Y-%m') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM Transactions
GROUP BY DATE_FORMAT(borrow_date, '%Y-%m');

-- ========================================================
-- 12. CASE EXPRESSIONS
-- ========================================================

-- Assign Membership_Status: 'Active' if borrowed in last 6 months, else 'Inactive'
SELECT m.member_id, m.name,
    CASE 
        WHEN MAX(t.borrow_date) >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) THEN 'Active'
        ELSE 'Inactive'
    END AS Membership_Status
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name;

-- Categorize books by publication date
SELECT title, published_date,
    CASE 
        WHEN YEAR(published_date) > 2020 THEN 'New Arrival'
        WHEN YEAR(published_date) < 2000 THEN 'Classic'
        ELSE 'Regular'
    END AS book_category
FROM Books;