# Library Management Database System

A MySQL database project for managing a library's book catalog, members, and borrowing history. It demonstrates relational schema design, integrity constraints, SQL operations, and circulation reports. This is a database-only project; it does not include an application or user interface.

## Features

- Store member details and a catalog of book titles and copies.
- Record book issues and returns while preserving transaction history.
- Track available inventory, active loans, and overdue loans.
- View borrowing history by member or book and run basic catalog statistics.
- Enforce primary keys, unique email/ISBN values, foreign keys, and copy-count/status checks.

## Schema

The `library_management` database contains three tables:

| Table | Purpose |
| --- | --- |
| `users` | Library member contact and membership information |
| `books` | Book catalog details and total/available copy counts |
| `borrow_transactions` | Issue/return records linking members and books |

Each transaction references one member and one book. A member or book referenced by transaction history cannot be deleted (`ON DELETE RESTRICT`); updates to referenced IDs cascade. The schema includes `CHECK` constraints for inventory counts and transaction status.

## Requirements

- MySQL Server 5.7+ or MariaDB 10.3+ (MySQL 8.0+ recommended)
- MySQL command-line client or a SQL client such as MySQL Workbench

## Quick start

Run these commands from the project directory. The first command creates the database and recreates its tables; **it drops existing project tables**, so back up any data you need first.

```sh
mysql -u root -p < database.sql
mysql -u root -p < sample_data.sql
```

To connect interactively and inspect the database:

```sh
mysql -u root -p library_management
```

Then try a read-only report from `queries.sql`, such as the currently issued or overdue books query. You can also open that file in MySQL Workbench and execute selected statements.

## Project files

| File | Description |
| --- | --- |
| [`database.sql`](database.sql) | Creates the database and tables, including keys and constraints |
| [`sample_data.sql`](sample_data.sql) | Inserts example members, books, and borrowing records |
| [`queries.sql`](queries.sql) | CRUD examples, issue/return workflows, tracking, and reports |
| [`setup_guide.txt`](setup_guide.txt) | Extended schema notes, setup instructions, and learning objectives |

## Working with the queries

`queries.sql` includes examples for:

- Adding and viewing members and books
- Recording an issue and adjusting available inventory
- Marking a transaction returned and restoring inventory
- Listing available books, active loans, overdue books, and borrowing history
- Counting titles, members, loans, and copies by category

The file contains **example write operations** (including inserts, updates, and deletes) as well as reports. Review and run only the statements you intend to use; sample IDs and records may differ after changes to the database. For a real application, issue and return changes should be performed atomically in a database transaction so the transaction record and inventory count cannot get out of sync.

## Notes

- `sample_data.sql` is intended for a newly initialized database and should not be run repeatedly without clearing/recreating the tables, because duplicate unique values will fail.
- Enforcement of `CHECK` constraints depends on the database version; use a modern MySQL or MariaDB release.
- This project does not implement authentication, a web/API layer, fines, or notifications.
