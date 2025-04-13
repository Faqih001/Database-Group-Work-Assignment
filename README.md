# Database-Group-Work-Assignment
Group Work Assignment with goal of building a relational database that stores information about the bookstore's operations, including books, authors, customers, orders, shipping, and more. We created a database that efficiently stores all necessary data and allows for quick retrieval and analysis.

# BookStore Database Project

## Overview

This project involves designing and implementing a MySQL relational database for a BookStore, as part of a hands-on exercise in **Database Design & Programming with SQL**. The database manages key bookstore operations, including books, authors, customers, orders, shipping, and addresses. The goal is to create an efficient, secure, and scalable database system that supports data storage, retrieval, and analysis.

The project includes:
- A MySQL database with 15 tables to store bookstore data.
- Role-based user access control for security.
- Sample data and test queries to verify functionality.
- Instructions for visualizing the schema using an Entity-Relationship Diagram (ERD).

## Tools and Technologies

- **MySQL**: For creating and managing the database.
- **Draw.io**: For visualizing the database schema (ERD).
- **MySQL Client**: MySQL Workbench, command-line client, or similar for running the SQL script.

## Prerequisites

To work with this project, you should have:
- Basic knowledge of MySQL (e.g., creating tables, writing queries).
- Familiarity with SQL data types and relationships (e.g., primary/foreign keys).
- A MySQL server installed and running (e.g., MySQL Community Server).
- (Optional) Draw.io or similar tool for ERD visualization.

## Project Structure

The project consists of a single SQL script that handles all database setup and testing:

- **assignment.sql**: The main script that:
  - Creates the `bookstore` database.
  - Defines 15 tables with appropriate schemas, data types, and relationships.
  - Sets up user roles (`admin`, `manager`, `clerk`, `customer_role`) and permissions.
  - Inserts sample data for testing.
  - Includes test queries to demonstrate data retrieval and analysis.

## Database Schema

The database includes the following tables:

1. **country**: Stores country names for addresses.
2. **address**: Stores address details (street, city, etc.).
3. **address_status**: Defines address statuses (e.g., Current, Old).
4. **customer**: Stores customer information (name, email, etc.).
5. **customer_address**: Links customers to addresses (many-to-many).
6. **publisher**: Stores publisher information.
7. **book_language**: Stores possible book languages.
8. **author**: Stores author information.
9. **book**: Stores book details (title, ISBN, price, etc.).
10. **book_author**: Manages many-to-many relationship between books and authors.
11. **order_status**: Defines order statuses (e.g., Pending, Shipped).
12. **shipping_method**: Stores shipping methods and costs.
13. **cust_order**: Stores customer orders.
14. **order_line**: Stores books in each order (quantity, price).
15. **order_history**: Tracks order status changes.

**Relationships**:
- **One-to-many**: `customer` to `cust_order`, `publisher` to `book`, `country` to `address`.
- **Many-to-many**: `book` to `author` (via `book_author`), `customer` to `address` (via `customer_address`).

## Setup Instructions

1. **Install MySQL**:
   - Ensure a MySQL server is installed and running (e.g., MySQL 8.0 or later).
   - Verify access using a MySQL client (e.g., MySQL Workbench, command line).

2. **Clone or Download**:
   - Download the `assignment.sql` file to your local machine.
   - Alternatively, clone this repository (if hosted on a platform like GitHub).

3. **Run the SQL Script**:
   - Open your MySQL client.
   - Log in with a user that has administrative privileges (e.g., `root`).
   - Run the script using one of these methods:
     ```bash
     mysql -u root -p < assignment.sql

## BookStore Database Entity Relation Diagram

![BookStore ERD](https://github.com/Faqih001/Database-Group-Work-Assignment/blob/main/BookStore%20Database.drawio.png)

## 👥 Contributors

<!-- readme: contributors -start -->
<table>
  <tbody>
    <tr>
      <td align="center">
        <a href="https://github.com/Faqih001" style="text-decoration: none;">
          <img src="https://avatars.githubusercontent.com/u/79513690?v=4" width="300;" alt="Faqih001"/>
          <br />
          <span style="font-size: 24px;"><b>Faqih001</b></span>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/Charmaine14-Bot" style="text-decoration: none;">
          <img src="https://avatars.githubusercontent.com/u/200607780?v=4" width="300;" alt="Charmaine14-Bot"/>
          <br />
          <span style="font-size: 24px;"><b>Charmaine14-Bot</b></span>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/munaa33" style="text-decoration: none;">
          <img src="https://avatars.githubusercontent.com/u/102806925?v=4" width="300;" alt="munaa33"/>
          <br />
          <span style="font-size: 24px;"><b>munaa33</b></span>
        </a>
      </td>
    </tr>
  </tbody>
</table>
<!-- readme: contributors -end -->



