-- assignment.sql
-- Project: Database Design & Programming with SQL for BookStore
-- Objective: Build a MySQL database to manage bookstore operations, including books, authors, customers, orders, and more.
-- Tools: MySQL for database management, Draw.io for schema visualization (ERD to be created separately).
-- Date: April 12, 2025

-- --------------------------------------
-- Step 1: Create a New Database
-- --------------------------------------
-- Create a database named 'bookstore' to store all data.

CREATE DATABASE IF NOT EXISTS bookstore;
USE bookstore;

-- --------------------------------------
-- Step 2: Determine the Table Schema and Data Types
-- --------------------------------------
-- Design tables with appropriate data types and relationships to store bookstore data efficiently.
-- Tables include: country, address, address_status, customer, customer_address, publisher,
-- book_language, author, book, book_author, order_status, shipping_method, cust_order,
-- order_line, order_history.
-- Notes:
-- - Primary keys use AUTO_INCREMENT for unique IDs.
-- - Foreign keys enforce referential integrity.
-- - Data types: VARCHAR for names/titles, INT for IDs, DECIMAL(10,2) for prices, DATE for dates.
-- - UNIQUE constraints on customer.email and book.isbn to prevent duplicates.

-- Table: country
-- Stores countries for addresses.
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Table: address
-- Stores address details, linked to country.
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Table: address_status
-- Defines address statuses (e.g., Current, Old).
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Table: customer
-- Stores customer information.
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

-- Table: customer_address
-- Links customers to addresses with status (many-to-many relationship).
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Table: publisher
-- Stores publisher information.
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL
);

-- Table: book_language
-- Stores possible book languages.
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);

-- Table: author
-- Stores author information.
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

-- Table: book
-- Stores book details, linked to publisher and language.
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    publication_year INT,
    price DECIMAL(10, 2) NOT NULL,
    publisher_id INT,
    language_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

-- Table: book_author
-- Manages many-to-many relationship between books and authors.
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Table: order_status
-- Defines order statuses (e.g., Pending, Shipped).
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Table: shipping_method
-- Stores shipping methods and costs.
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL
);

-- Table: cust_order
-- Stores customer orders, linked to customer, shipping method, address, and status.
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    shipping_method_id INT,
    address_id INT,
    status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Table: order_line
-- Stores books in each order with quantity and price.
CREATE TABLE order_line (
    order_id INT,
    book_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Table: order_history
-- Tracks order status changes over time.
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    status_date DATE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- --------------------------------------
-- Step 3: Write SQL Commands to Create Tables
-- --------------------------------------
-- The CREATE TABLE commands above are ordered to satisfy foreign key dependencies
-- (e.g., country before address, customer before cust_order).

-- --------------------------------------
-- Step 4: Set Up User Groups and Roles
-- --------------------------------------
-- Create roles and users to control database access securely.
-- Roles:
-- - admin: Full access to all tables.
-- - manager: Read/write on most tables, no user management.
-- - clerk: Read books/customers, read/write orders.
-- - customer_role: Read books and own orders.
-- Security Note: Replace 'secure_passwordX' with strong passwords in production.

-- Create roles
CREATE ROLE admin, manager, clerk, customer_role;

-- Assign privileges to roles
-- Admin: Full access
GRANT ALL ON bookstore.* TO admin;

-- Manager: Read/write on operational tables
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.book TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.author TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.publisher TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.cust_order TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.order_line TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.customer TO manager;
GRANT SELECT ON bookstore.country TO manager;
GRANT SELECT ON bookstore.book_language TO manager;
GRANT SELECT ON bookstore.order_status TO manager;
GRANT SELECT ON bookstore.shipping_method TO manager;

-- Clerk: Limited read/write access
GRANT SELECT ON bookstore.book TO clerk;
GRANT SELECT ON bookstore.customer TO clerk;
GRANT SELECT, INSERT, UPDATE ON bookstore.cust_order TO clerk;
GRANT SELECT, INSERT, UPDATE ON bookstore.order_line TO clerk;
GRANT SELECT ON bookstore.shipping_method TO clerk;
GRANT SELECT ON bookstore.order_status TO clerk;

-- Customer: View books and orders
GRANT SELECT ON bookstore.book TO customer_role;
GRANT SELECT ON bookstore.cust_order TO customer_role;
GRANT SELECT ON bookstore.order_line TO customer_role;

-- Create users
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'secure_password1';
CREATE USER 'manager_user'@'localhost' IDENTIFIED BY 'secure_password2';
CREATE USER 'clerk_user'@'localhost' IDENTIFIED BY 'secure_password3';
CREATE USER 'customer_user'@'localhost' IDENTIFIED BY 'secure_password4';

-- Assign roles to users
GRANT admin TO 'admin_user'@'localhost';
GRANT manager TO 'manager_user'@'localhost';
GRANT clerk TO 'clerk_user'@'localhost';
GRANT customer_role TO 'customer_user'@'localhost';

-- Apply privileges
FLUSH PRIVILEGES;

-- Optional: Create a view for customers to see only their orders (enhances security)
-- Note: This is a basic view; adjust based on user identification in production.
CREATE VIEW customer_orders AS
SELECT * FROM cust_order
WHERE customer_id = (SELECT customer_id FROM customer WHERE email = CURRENT_USER());

-- --------------------------------------
-- Step 5: Test the Database with Queries
-- --------------------------------------
-- Insert sample data to test the database and run queries to verify functionality.
-- The queries will demonstrate data retrieval and analysis.

-- Insert sample data
INSERT INTO country (country_name) VALUES ('USA'), ('Canada');
INSERT INTO address (street, city, state, postal_code, country_id)
VALUES ('123 Main St', 'New York', 'NY', '10001', 1);
INSERT INTO address_status (status_name) VALUES ('Current'), ('Old');
INSERT INTO customer (first_name, last_name, email, phone)
VALUES ('John', 'Doe', 'john.doe@email.com', '555-1234');
INSERT INTO customer_address (customer_id, address_id, status_id)
VALUES (1, 1, 1);
INSERT INTO publisher (publisher_name) VALUES ('Penguin Books');
INSERT INTO book_language (language_name) VALUES ('English');
INSERT INTO author (first_name, last_name) VALUES ('Jane', 'Austen');
INSERT INTO book (title, isbn, publication_year, price, publisher_id, language_id)
VALUES ('Pride and Prejudice', '9780141439518', 1813, 9.99, 1, 1);
INSERT INTO book_author (book_id, author_id) VALUES (1, 1);
INSERT INTO order_status (status_name) VALUES ('Pending'), ('Shipped');
INSERT INTO shipping_method (method_name, cost) VALUES ('Standard', 5.00);
INSERT INTO cust_order (customer_id, order_date, shipping_method_id, address_id, status_id)
VALUES (1, '2025-04-12', 1, 1, 1);
INSERT INTO order_line (order_id, book_id, quantity, price)
VALUES (1, 1, 2, 9.99);
INSERT INTO order_history (order_id, status_id, status_date)
VALUES (1, 1, '2025-04-12');

-- Test Query 1: List all books with their authors
SELECT b.title, a.first_name, a.last_name
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;

-- Test Query 2: Find orders for a specific customer
SELECT co.order_id, co.order_date, b.title, ol.quantity
FROM cust_order co
JOIN order_line ol ON co.order_id = ol.order_id
JOIN book b ON ol.book_id = b.book_id
WHERE co.customer_id = 1;

-- Test Query 3: Calculate total sales by book
SELECT b.title, SUM(ol.quantity * ol.price) AS total_sales
FROM book b
JOIN order_line ol ON b.book_id = ol.book_id
GROUP BY b.title;

-- --------------------------------------
-- Additional Notes
-- --------------------------------------
-- - Schema Visualization: Use Draw.io to create an ERD.
--   - Entities: book, author, customer, cust_order, etc.
--   - Relationships: Many-to-many (book_author, customer_address), one-to-many (customer to cust_order).
--   - Include primary/foreign keys and attributes.
-- - Scalability: Design supports adding more books, customers, orders.
-- - Security: Roles restrict access; consider row-level security for customers in production.
-- - Optimization: Add indexes (e.g., CREATE INDEX idx_book_isbn ON book(isbn)) for frequent queries if needed.
-- - Expected Outcomes:
--   - Designed a relational database for bookstore operations.
--   - Created tables with optimal schemas and data types.
--   - Managed access with user roles.
--   - Queried data for insights (e.g., sales, customer orders).
