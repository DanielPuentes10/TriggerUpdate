# 🎸 SQL Server Trigger: Automated Price Update & Audit Log

A relational database project demonstrating automated auditing and price updates in **SQL Server** using **Triggers**, **Stored Procedures**, and **Audit Logs**. 

This repository implements a business logic scenario where updating a product's price (e.g., applying a 15% discount on guitars) automatically logs the user, timestamp, previous price, and new price into a dedicated audit table.

---

## 📌 Project Overview

When managing product pricing, tracking historical price changes and identifying who performed updates is critical for data integrity and auditing. 

This project demonstrates how to:
1. Create a core product inventory table (`guitarras`).
2. Build an audit log table (`Nuevo_Precio_Guitarra`) to track price modifications.
3. Use a **Stored Procedure** to calculate and apply a **15% discount**.
4. Implement a **SQL Server Trigger** (`AFTER UPDATE`) to automatically capture and record modification details into the audit log.

---

## 🗄️ Database Schema & Architecture

### 1. Primary Table: `guitarras`
Stores the main product inventory information.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `codigo` | `INT` / `VARCHAR` | Primary Key / Unique product ID |
| `nombre` | `VARCHAR(100)` | Name of the guitar |
| `precio` | `DECIMAL(10,2)` | Current selling price |

### 2. Audit Table: `Nuevo_Precio_Guitarra`
Logs historical price changes for auditing purposes whenever a record in `guitarras` is updated.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `usuario` | `VARCHAR(100)` | Database user who executed the update (`SYSTEM_USER` / `SUSER_SNAME()`) |
| `fecha` | `DATETIME` | Timestamp of the update (`GETDATE()`) |
| `codigo` | `INT` / `VARCHAR` | Product ID referenced |
| `precio_anterior` | `DECIMAL(10,2)` | Original price before modification |
| `precio_nuevo` | `DECIMAL(10,2)` | Updated price after discount |

---

## 🔄 Workflow & Execution Steps

1. **Table Creation**: Define the `guitarras` inventory table and the `Nuevo_Precio_Guitarra` audit table.
2. **Data Insertion**: Populate the `guitarras` table with initial sample records to test the routine.
3. **Trigger Implementation**: Create an `AFTER UPDATE` trigger on `guitarras` that reads from the `deleted` (old values) and `inserted` (new values) pseudo-tables to insert an entry into `Nuevo_Precio_Guitarra`.
4. **Stored Procedure**: Execute a procedure designed to update guitar prices by applying a 15% discount (`precio = precio * 0.85`).
5. **Verification**: Validate data consistency by querying both tables to confirm that:
   * The product price was updated correctly in `guitarras`.
   * The trigger automatically logged the change with the user, timestamp, previous price, and new price in `Nuevo_Precio_Guitarra`.

---

## ⚙️ SQL Script Overview

```sql
-- 1. Create Primary Table
CREATE TABLE guitarras (
    codigo INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

-- 2. Create Audit Table
CREATE TABLE Nuevo_Precio_Guitarra (
    usuario VARCHAR(100),
    fecha DATETIME,
    codigo INT,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2)
);

-- 3. Create Trigger for Auditing
CREATE TRIGGER trg_Audit_Precio_Guitarra
ON guitarras
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Nuevo_Precio_Guitarra (usuario, fecha, codigo, precio_anterior, precio_nuevo)
    SELECT 
        SYSTEM_USER,
        GETDATE(),
        i.codigo,
        d.precio AS precio_anterior,
        i.precio AS precio_nuevo
    FROM inserted i
    INNER JOIN deleted d ON i.codigo = d.codigo;
END;
GO

-- 4. Sample Data & Execution Procedure
INSERT INTO guitarras (codigo, nombre, precio) 
VALUES (1, 'Fender Stratocaster', 1000.00);

-- Apply 15% Discount Update
UPDATE guitarras
SET precio = precio * 0.85
WHERE codigo = 1;

-- 5. Audit Verification
SELECT * FROM guitarras;
SELECT * FROM Nuevo_Precio_Guitarra;
