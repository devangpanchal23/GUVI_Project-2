-- ============================================================
-- LIBRARY MANAGEMENT DATABASE SYSTEM – PROJECT 2
-- File: database.sql
-- Description: Database initialization, schema definition, and integrity constraints
-- Technology: MySQL / Relational SQL
-- ============================================================

-- 1. Create Database
CREATE DATABASE IF NOT EXISTS library_management;
USE library_management;

-- 2. Drop Existing Tables in reverse dependency order to avoid FK errors
DROP TABLE IF EXISTS borrow_transactions;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS users;

-- 3. Users Table
-- Stores library member details
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    created_at DATE NOT NULL
);

-- 4. Books Table
-- Stores inventory and catalog information for each book title
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    isbn VARCHAR(20) NOT NULL UNIQUE,
    total_copies INT NOT NULL,
    available_copies INT NOT NULL,
    CONSTRAINT chk_total_copies CHECK (total_copies >= 0),
    CONSTRAINT chk_available_copies CHECK (available_copies >= 0),
    CONSTRAINT chk_copies_consistency CHECK (available_copies <= total_copies)
);

-- 5. Borrow Transactions Table
-- Tracks borrowing history, current checkouts, and returns
CREATE TABLE borrow_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Issued',
    CONSTRAINT fk_transaction_user FOREIGN KEY (user_id) 
        REFERENCES users(user_id) 
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
    CONSTRAINT fk_transaction_book FOREIGN KEY (book_id) 
        REFERENCES books(book_id) 
        ON UPDATE CASCADE 
        ON DELETE RESTRICT,
    CONSTRAINT chk_transaction_status CHECK (status IN ('Issued', 'Returned'))
);
