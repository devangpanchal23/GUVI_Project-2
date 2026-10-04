-- ============================================================
-- LIBRARY MANAGEMENT DATABASE SYSTEM – PROJECT 2
-- File: queries.sql
-- Description: Core SQL queries including CRUD, transactions, tracking, and reporting
-- Technology: MySQL / Relational SQL
-- ============================================================

USE library_management;

-- ============================================================
-- 1. BASIC CRUD OPERATIONS
-- ============================================================

-- [CREATE] Add a new user
INSERT INTO users (name, email, phone, created_at)
VALUES ('Vikram Malhotra', 'vikram.m@example.com', '+91-9876543215', CURDATE());

-- [CREATE] Add a new book
INSERT INTO books (title, author, category, isbn, total_copies, available_copies)
VALUES ('Designing Data-Intensive Applications', 'Martin Kleppmann', 'Database Systems', '978-1449373320', 3, 3);

-- [READ] View all users
SELECT 
    user_id,
    name,
    email,
    phone,
    created_at
FROM users;

-- [READ] View all books
SELECT 
    book_id,
    title,
    author,
    category,
    isbn,
    total_copies,
    available_copies
FROM books;

-- [READ] View all transactions
SELECT 
    transaction_id,
    user_id,
    book_id,
    issue_date,
    due_date,
    return_date,
    status
FROM borrow_transactions;

-- [UPDATE] Update user contact information
UPDATE users
SET phone = '+91-9876500000',
    email = 'rahul.updated@example.com'
WHERE user_id = 1;

-- [UPDATE] Update book catalog information
UPDATE books
SET category = 'Algorithms & Data Structures'
WHERE book_id = 3;

-- [DELETE] Safely delete a record with no referencing foreign keys
-- Note: Attempting to delete a user or book with active borrow transactions
-- will be prevented by FOREIGN KEY constraints (ON DELETE RESTRICT).
DELETE FROM users
WHERE user_id = 6;

DELETE FROM books
WHERE book_id = 9;


-- ============================================================
-- 2. ISSUE BOOK OPERATION WORKFLOW
-- ============================================================

-- Step A: Check if the book has available copies (e.g., Book ID 3: Introduction to Algorithms)
SELECT 
    book_id,
    title,
    available_copies
FROM books
WHERE book_id = 3;

-- Step B: If available_copies > 0, record the new borrow transaction
-- Sets issue_date to today and due_date to 14 days from today
INSERT INTO borrow_transactions (user_id, book_id, issue_date, due_date, status)
VALUES (1, 3, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'Issued');

-- Step C: Decrement the available_copies for the issued book
UPDATE books
SET available_copies = available_copies - 1
WHERE book_id = 3 
  AND available_copies > 0;


-- ============================================================
-- 3. RETURN BOOK OPERATION WORKFLOW
-- ============================================================

-- Step A: Mark the active transaction as 'Returned' and record today's return date
-- Only updates if the transaction is currently in 'Issued' status to prevent double-returns
UPDATE borrow_transactions
SET return_date = CURDATE(),
    status = 'Returned'
WHERE transaction_id = 1
  AND status = 'Issued';

-- Step B: Increment the available_copies of the returned book
-- Guard condition ensures available_copies never exceeds total_copies
UPDATE books
SET available_copies = available_copies + 1
WHERE book_id = 1
  AND available_copies < total_copies;


-- ============================================================
-- 4. TRACKING QUERIES
-- ============================================================

-- 4.1 Track all currently available books (inventory ready to lend)
SELECT 
    book_id,
    title,
    author,
    category,
    isbn,
    available_copies,
    total_copies
FROM books
WHERE available_copies > 0
ORDER BY title ASC;

-- 4.2 Track all currently issued books (active loans)
SELECT 
    bt.transaction_id,
    u.name AS user_name,
    u.email AS user_email,
    b.title AS book_title,
    bt.issue_date,
    bt.due_date,
    bt.status
FROM borrow_transactions bt
JOIN users u 
    ON bt.user_id = u.user_id
JOIN books b 
    ON bt.book_id = b.book_id
WHERE bt.status = 'Issued'
ORDER BY bt.due_date ASC;

-- 4.3 Complete borrowing history (all historical and active transactions)
SELECT 
    bt.transaction_id,
    u.name AS user_name,
    b.title AS book_title,
    bt.issue_date,
    bt.due_date,
    bt.return_date,
    bt.status
FROM borrow_transactions bt
JOIN users u 
    ON bt.user_id = u.user_id
JOIN books b 
    ON bt.book_id = b.book_id
ORDER BY bt.transaction_id ASC;

-- 4.4 User-specific borrowing history (e.g., for User ID 1: Rahul Patel)
SELECT 
    u.name AS user_name,
    b.title AS book_title,
    bt.issue_date,
    bt.due_date,
    bt.return_date,
    bt.status
FROM borrow_transactions bt
JOIN users u 
    ON bt.user_id = u.user_id
JOIN books b 
    ON bt.book_id = b.book_id
WHERE u.user_id = 1
ORDER BY bt.issue_date DESC;

-- 4.5 Book-specific borrowing history (e.g., for Book ID 1: Clean Code)
SELECT 
    b.title AS book_title,
    u.name AS user_name,
    bt.issue_date,
    bt.due_date,
    bt.return_date,
    bt.status
FROM borrow_transactions bt
JOIN users u 
    ON bt.user_id = u.user_id
JOIN books b 
    ON bt.book_id = b.book_id
WHERE b.book_id = 1
ORDER BY bt.issue_date DESC;

-- 4.6 Track currently overdue books (issued books where due_date has passed)
SELECT 
    bt.transaction_id,
    u.name AS user_name,
    u.phone AS user_phone,
    b.title AS book_title,
    bt.issue_date,
    bt.due_date,
    DATEDIFF(CURDATE(), bt.due_date) AS days_overdue
FROM borrow_transactions bt
JOIN users u 
    ON bt.user_id = u.user_id
JOIN books b 
    ON bt.book_id = b.book_id
WHERE bt.status = 'Issued'
  AND bt.due_date < CURDATE()
ORDER BY bt.due_date ASC;


-- ============================================================
-- 5. BASIC AGGREGATE / STATISTICAL QUERIES
-- ============================================================

-- Total number of distinct book titles in catalog
SELECT COUNT(*) AS total_book_titles 
FROM books;

-- Total registered library users
SELECT COUNT(*) AS total_registered_users 
FROM users;

-- Total active issued transactions
SELECT COUNT(*) AS total_currently_issued 
FROM borrow_transactions
WHERE status = 'Issued';

-- Total physical copies currently available on shelves
SELECT SUM(available_copies) AS total_available_copies 
FROM books;

-- Total physical copies owned across the entire library
SELECT SUM(total_copies) AS total_physical_copies 
FROM books;

-- Count of book titles grouped by category
SELECT 
    category,
    COUNT(*) AS title_count,
    SUM(total_copies) AS total_copies_in_category
FROM books
GROUP BY category
ORDER BY title_count DESC;
