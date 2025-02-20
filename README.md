# PL/SQL Supply Chain Inventory & Order Management System

## 📌 Overview
This project is a PL/SQL-based inventory and order management system designed for a manufacturing workflow. It automates order fulfillment, inventory tracking, product assembly, and procurement processes using triggers and stored procedures.

## 🏗 Database Schema
The system includes multiple tables to manage components, modules, products, inventory, and orders:
- **Components**: Stores purchased components used in manufacturing.
- **Com_mod**: Maps components to the modules they help create.
- **Modules**: Defines module types and their stock.
- **Types**: Represents different product models.
- **MiPad**: Tracks individual manufactured products.
- **Inventory**: Monitors available stock for sale.
- **Orders**: Manages incoming customer orders.

## ⚡ Features
- **Automated Order Processing**: Orders automatically update inventory and trigger manufacturing if needed.
- **Inventory Tracking**: Ensures stock levels are monitored and updated dynamically.
- **Product Assembly**: Assembles products based on available components and modules.
- **Procurement System**: Orders components when stock is low.
- **Stored Procedures & Triggers**: Automates business logic to streamline operations.

## 🚀 Getting Started
### 1️⃣ Prerequisites
- Oracle Database or an equivalent PL/SQL-supported database system.
- SQL Developer or another SQL client.

### 2️⃣ Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/PLSQL-Inventory-Management.git
   ```
2. Run the scripts in `sql_scripts/` in the order.

### 3️⃣ Running the Project
- Open an SQL client and execute the scripts.
- Use `SELECT * FROM Orders;` to check inserted test data.

## 📊 Database Schema Diagram
![Schema Diagram](docs/schema_diagram.png)

## 📝 License
This project is licensed under the MIT License.
