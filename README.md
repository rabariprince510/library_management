# 📚 Smart Library Management System

A **SQL-based Smart Library Management System** designed to manage books, authors, library members, and borrowing transactions.

This project demonstrates practical **MySQL database management and SQL querying concepts**, including CRUD operations, filtering, sorting, grouping, aggregate functions, joins, subqueries, date & time functions, string functions, window functions, and CASE expressions.

---

## 📌 Project Overview

The **Smart Library Management System** provides a structured relational database for managing a library's core operations.

The database contains four main entities:

* 👨‍💼 **Authors** — Stores author information.
* 📚 **Books** — Stores book details and availability.
* 👤 **Members** — Stores library member information.
* 🔄 **Transactions** — Records book borrowing and returning activities.

The project uses **MySQL** and demonstrates how SQL can be used to store, manipulate, retrieve, and analyze library data.

---

## 🎯 Objectives

The main objectives of this project are:

* Create and manage a relational database.
* Store author, book, member, and transaction information.
* Perform CRUD operations.
* Retrieve data using SQL clauses and operators.
* Sort and group library data.
* Perform calculations using aggregate functions.
* Understand and implement different types of SQL joins.
* Use subqueries for advanced data retrieval.
* Work with date and time functions.
* Perform string manipulation.
* Analyze data using window functions.
* Categorize records using CASE expressions.

---

## 🗄️ Database Structure

The project creates a database named:

```sql
SmartLibrary
```

### Database Tables

| Table          | Description                            |
| -------------- | -------------------------------------- |
| `Authors`      | Stores author details                  |
| `Books`        | Stores information about books         |
| `Members`      | Stores library member details          |
| `Transactions` | Stores borrowing and returning records |

---

## 🔗 Database Relationships

The database follows a relational structure.

```text
Authors
   │
   │ 1
   │
   └──────────< Books
                   │
                   │
                   │
Members ────────< Transactions >──────── Books
```

### Relationships

* One **Author** can have multiple **Books**.
* One **Member** can have multiple **Transactions**.
* One **Book** can appear in multiple **Transactions**.
* Foreign keys maintain relationships between the tables.

The `Books.author_id` foreign key uses `ON DELETE SET NULL`, while the transaction relationships use `ON DELETE CASCADE`.

---

## 🧱 Table Structure

### 👨‍💼 Authors

| Column      | Data Type    | Description  |
| ----------- | ------------ | ------------ |
| `author_id` | INT          | Primary key  |
| `name`      | VARCHAR(100) | Author name  |
| `email`     | VARCHAR(100) | Author email |

---

### 📚 Books

| Column             | Data Type    | Description                |
| ------------------ | ------------ | -------------------------- |
| `book_id`          | INT          | Primary key                |
| `title`            | VARCHAR(150) | Book title                 |
| `author_id`        | INT          | Foreign key                |
| `category`         | VARCHAR(50)  | Book category              |
| `isbn`             | VARCHAR(20)  | ISBN number                |
| `published_date`   | DATE         | Publication date           |
| `price`            | DECIMAL      | Book price                 |
| `available_copies` | INT          | Number of available copies |

---

### 👤 Members

| Column            | Data Type    | Description         |
| ----------------- | ------------ | ------------------- |
| `member_id`       | INT          | Primary key         |
| `name`            | VARCHAR(100) | Member name         |
| `email`           | VARCHAR(100) | Member email        |
| `phone_number`    | VARCHAR(15)  | Member phone number |
| `membership_date` | DATE         | Date of membership  |

---

### 🔄 Transactions

| Column           | Data Type | Description    |
| ---------------- | --------- | -------------- |
| `transaction_id` | INT       | Primary key    |
| `member_id`      | INT       | Foreign key    |
| `book_id`        | INT       | Foreign key    |
| `borrow_date`    | DATE      | Borrowing date |
| `return_date`    | DATE      | Returning date |
| `fine_amount`    | DECIMAL   | Fine amount    |

---

# 🛠️ SQL Concepts Demonstrated

## 1. CRUD Operations

The project demonstrates the fundamental **Create, Read, Update, and Delete** operations.

Examples include:

* Inserting authors, books, members, and transactions.
* Updating book availability.
* Deleting inactive members.
* Retrieving available books.

---

## 2. SQL Clauses

The project demonstrates:

* `WHERE`
* `HAVING`
* `LIMIT`
* `ORDER BY`
* `GROUP BY`

Example:

```sql
SELECT * 
FROM Books 
ORDER BY price DESC 
LIMIT 5;
```

This retrieves the five most expensive books.

---

## 3. SQL Operators

The project uses:

* `AND`
* `OR`
* `NOT`

Example:

```sql
SELECT * 
FROM Books 
WHERE category = 'Science' 
AND price < 500;
```

This retrieves Science books priced below 500.

---

## 4. Sorting & Grouping

The project uses `ORDER BY` and `GROUP BY` to organize and summarize data.

Examples:

* Alphabetically sorting books.
* Counting books borrowed by each member.
* Counting books by category.

---

## 5. Aggregate Functions

The project demonstrates important aggregate functions such as:

* `COUNT()`
* `AVG()`
* `SUM()`

Examples include:

* Total books per category.
* Average book price.
* Most borrowed book.
* Total fines collected.

---

## 6. SQL Joins

Different types of joins are demonstrated:

### INNER JOIN

Used to retrieve books along with their author names.

### LEFT JOIN

Used to retrieve members who have borrowed books.

### RIGHT JOIN

Used to identify books that have not been borrowed.

### FULL OUTER JOIN Simulation

A LEFT JOIN technique is used to identify members who have never borrowed a book.

---

## 7. Subqueries

Subqueries are used for more advanced data retrieval.

Examples include:

* Books borrowed by members registered after 2022.
* Identifying the most borrowed book.
* Finding members who have never borrowed a book.

---

## 8. Date & Time Functions

The project demonstrates:

* `YEAR()`
* `DATEDIFF()`
* `DATE_FORMAT()`

Example:

```sql
SELECT transaction_id, 
       borrow_date, 
       return_date,
       DATEDIFF(return_date, borrow_date) AS days_kept
FROM Transactions
WHERE return_date IS NOT NULL;
```

This calculates how many days a returned book was kept.

---

## 9. String Functions

The project demonstrates:

* `UPPER()`
* `TRIM()`
* `IFNULL()`

Example:

```sql
SELECT name, 
       IFNULL(email, 'Not Provided') AS email_status
FROM Members;
```

This replaces missing member emails with `"Not Provided"`.

---

## 10. Window Functions

Advanced SQL analysis is performed using:

* `DENSE_RANK()`
* `COUNT() OVER()`
* `AVG() OVER()`

Examples include:

* Ranking books according to borrowing frequency.
* Calculating cumulative borrowing counts per member.
* Calculating a moving average of monthly borrowing activity.

---

## 11. CASE Expressions

`CASE` expressions are used to categorize data.

### Membership Status

Members are classified as:

* `Active`
* `Inactive`

based on their recent borrowing activity.

### Book Category

Books are classified as:

* `New Arrival`
* `Classic`
* `Regular`

based on publication year.

---

# 📊 Sample Operations

### Find Available Books

```sql
SELECT * 
FROM Books 
WHERE available_copies > 0;
```

### Find Science Books Under 500

```sql
SELECT * 
FROM Books
WHERE category = 'Science'
AND price < 500;
```

### Find Average Book Price

```sql
SELECT AVG(price) AS average_book_price
FROM Books;
```

### Find the Most Borrowed Book

```sql
SELECT book_id, 
       COUNT(*) AS times_borrowed
FROM Transactions
GROUP BY book_id
ORDER BY times_borrowed DESC
LIMIT 1;
```

---

# 💾 Sample Data

The project includes sample records for:

* **5 authors**
* **7 books**
* **5 members**
* **6 transactions**

The sample data includes different book categories such as Science, Fiction, Technology, History, and General.

---

# 🧰 Technologies Used

| Technology              | Purpose                             |
| ----------------------- | ----------------------------------- |
| **MySQL**               | Database management                 |
| **SQL**                 | Data manipulation and analysis      |
| **Relational Database** | Data organization and relationships |

---

# 📁 Project Structure

```text
Smart-Library-Management-System/
│
├── Library_Management_System.sql
└── README.md
```

---

# ▶️ How to Run the Project

### Step 1 — Install MySQL

Install MySQL or use a MySQL-compatible environment such as MySQL Workbench.

### Step 2 — Open the SQL File

Open:

```text
Library_Management_System.sql
```

### Step 3 — Execute the Script

Run the SQL script in your MySQL environment.

The script will:

1. Create the `SmartLibrary` database.
2. Create the required tables.
3. Insert sample data.
4. Perform CRUD operations.
5. Execute SQL queries demonstrating different concepts.

The database is initialized with:

```sql
CREATE DATABASE SmartLibrary;
USE SmartLibrary;
```

---

# 🎓 Learning Outcomes

Through this project, the following SQL concepts are practiced:

```text
✓ Database Creation
✓ Table Creation
✓ Primary Keys
✓ Foreign Keys
✓ Constraints
✓ INSERT
✓ SELECT
✓ UPDATE
✓ DELETE
✓ WHERE
✓ HAVING
✓ LIMIT
✓ ORDER BY
✓ GROUP BY
✓ AND / OR / NOT
✓ Aggregate Functions
✓ INNER JOIN
✓ LEFT JOIN
✓ RIGHT JOIN
✓ FULL OUTER JOIN Simulation
✓ Subqueries
✓ Date & Time Functions
✓ String Functions
✓ Window Functions
✓ CASE Expressions
```

---

# 🚀 Future Improvements

The project can be extended with additional features such as:

* 📌 Stored procedures
* 📌 Triggers for automatic book availability updates
* 📌 User authentication
* 📌 Automated fine calculation
* 📌 Advanced reporting
* 📌 Library dashboard
* 📌 Book reservation system
* 📌 Due-date management
* 📌 Database indexes for performance optimization

---

# 👨‍💻 Author

**Prince Rabari**

> A SQL database project created to demonstrate practical MySQL concepts through a real-world Library Management System.

---

# ⭐ Project Highlights

This project combines **database design + data manipulation + analytical SQL** in one practical application.

It demonstrates not only basic SQL queries but also advanced concepts such as **joins, nested subqueries, window functions, moving averages, ranking, and CASE-based classification**.

---

## 📄 License

This project is created for **educational and academic purposes**.

# Screenshots of the project is given below:

<img width="1366" height="768" alt="Screenshot (228)" src="https://github.com/user-attachments/assets/813b61b9-ab29-47e9-99b0-abc406b6d130" />
<img width="1366" height="768" alt="Screenshot (229)" src="https://github.com/user-attachments/assets/3d36d92e-919d-4899-abf0-304b005fe25a" />
<img width="1366" height="768" alt="Screenshot (230)" src="https://github.com/user-attachments/assets/f78f293c-62e9-4c70-8f48-dcb70e9034a0" />
<img width="1366" height="768" alt="Screenshot (231)" src="https://github.com/user-attachments/assets/3121e427-812a-4380-a3bc-59c44c8327ec" />
<img width="1366" height="768" alt="Screenshot (232)" src="https://github.com/user-attachments/assets/b2b273c9-bacf-492a-abab-761e2bd8e7a0" />

