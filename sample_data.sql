-- ============================================================
-- LIBRARY MANAGEMENT DATABASE SYSTEM – PROJECT 2
-- File: sample_data.sql
-- Description: Realistic sample dataset for users, books, and transactions
-- Technology: MySQL / Relational SQL
-- ============================================================

USE library_management;

-- 1. Insert Sample Users (5 Members)
INSERT INTO users (name, email, phone, created_at) VALUES
('Rahul Patel', 'rahul.patel@example.com', '+91-9876543210', '2024-01-10'),
('Priya Shah', 'priya.shah@example.com', '+91-9876543211', '2024-01-12'),
('Amit Kumar', 'amit.kumar@example.com', '+91-9876543212', '2024-01-15'),
('Neha Joshi', 'neha.joshi@example.com', '+91-9876543213', '2024-01-18'),
('Rohan Mehta', 'rohan.mehta@example.com', '+91-9876543214', '2024-01-20');

-- 2. Insert Sample Books (8 Titles across various technical categories)
-- Total copies and available copies strictly align with borrow transaction states below
INSERT INTO books (title, author, category, isbn, total_copies, available_copies) VALUES
('Clean Code', 'Robert C. Martin', 'Software Engineering', '978-0132350884', 5, 3),
('The Pragmatic Programmer', 'Andrew Hunt & David Thomas', 'Software Engineering', '978-0201616224', 4, 3),
('Introduction to Algorithms', 'Thomas H. Cormen', 'Computer Science', '978-0262033848', 3, 3),
('Database System Concepts', 'Abraham Silberschatz', 'Database Systems', '978-0078022159', 4, 3),
('Head First Java', 'Kathy Sierra & Bert Bates', 'Programming', '978-0596009205', 3, 2),
('Computer Networks', 'Andrew S. Tanenbaum', 'Networking', '978-0132126953', 3, 3),
('Operating System Concepts', 'Abraham Silberschatz', 'Operating Systems', '978-1118063330', 2, 0),
('Learning SQL', 'Alan Beaulieu', 'Database Systems', '978-0596520830', 5, 5);

-- 3. Insert Sample Borrow Transactions (8 Transactions)
-- Uses dynamic date intervals so overdue and active statuses remain valid on any test date:
-- - 5 active on-time issues
-- - 1 active overdue issue (Book 5, User 5)
-- - 2 returned historical records (Book 6, User 1; Book 8, User 4)
INSERT INTO borrow_transactions (user_id, book_id, issue_date, due_date, return_date, status) VALUES
(1, 1, DATE_SUB(CURDATE(), INTERVAL 7 DAY), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, 'Issued'),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 9 DAY), NULL, 'Issued'),
(3, 2, DATE_SUB(CURDATE(), INTERVAL 3 DAY), DATE_ADD(CURDATE(), INTERVAL 11 DAY), NULL, 'Issued'),
(4, 4, DATE_SUB(CURDATE(), INTERVAL 2 DAY), DATE_ADD(CURDATE(), INTERVAL 12 DAY), NULL, 'Issued'),
(5, 5, DATE_SUB(CURDATE(), INTERVAL 25 DAY), DATE_SUB(CURDATE(), INTERVAL 11 DAY), NULL, 'Issued'),
(1, 6, DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_SUB(CURDATE(), INTERVAL 16 DAY), DATE_SUB(CURDATE(), INTERVAL 18 DAY), 'Returned'),
(2, 7, DATE_SUB(CURDATE(), INTERVAL 6 DAY), DATE_ADD(CURDATE(), INTERVAL 8 DAY), NULL, 'Issued'),
(3, 7, DATE_SUB(CURDATE(), INTERVAL 4 DAY), DATE_ADD(CURDATE(), INTERVAL 10 DAY), NULL, 'Issued');
