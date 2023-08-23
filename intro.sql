
-- ## Foreign Key Constraint And Data Integrity

-- Department Table [Each department has many employees]
CREATE TABLE Department(
    deptID SERIAL PRIMARY KEY,
    deptName VARCHAR(50)
);

-- Employee Table [Each employee belongs to a department]
CREATE TABLE Employee(
    empID SERIAL PRIMARY KEY,
    empName VARCHAR(50) NOT NULL,
    departmentID INT,
    CONSTRAINT fk_constraint_dept
        FOREIGN KEY (departmentID)
        REFERENCES Department(deptID)
);

CREATE TABLE courses(
    courseID SERIAL PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    published_date DATE
);

SELECT * from courses;

INSERT INTO courses(course_name, description, published_date)
VALUES ('Postgresql for Developers', 'A complete PostgreSQL for devs', '2023-08-08'),
    ('Postgresql Bootcamp', 'A complete PostgreSQL guide for begineers devs', '2023-07-07');

-- Highest salary
-- SELECT * FROM employees ORDER BY salary DESC LIMIT 1;

-- -- Third highest salary
-- SELECT * FROM employees ORDER BY salary DESC LIMIT 1 OFFSET 2;

-- IN, NOT IN, BETWEEN, LIKE
SELECT * from employees WHERE empId IN (2, 3, 5) -- IN() er vetor jai dea hobe setai output hishebe dibe

SELECT * from employees WHERE empId NOT IN (2, 3, 5) -- NOT IN() er vetor jai dea hobe setai bad diye output dibe

SELECT * from employees WHERE salary BETWEEN 10000 AND 15000;

-- LIKE
-- LIKE er por string('') er vetore jeta dibo seta case sensitive.
SELECT * from employees WHERE name LIKE '%a%'; -- ei query ta karo name er moddhe 'a' thaklei shei name return korbe

SELECT * from employees WHERE name LIKE 'a%'; -- ei query ta jader name er first word 'a' shei name gulo return korbe

SELECT * from employees WHERE name LIKE '%a'; -- ei query ta jader name er last word 'a' shei name gulo return korbe

-- Specific Position
SELECT * from employees WHERE name LIKE '_r%'; -- ei query ta bujhay, value ta ber koro jar 2nd position a 'r' ache. jotogulo character er por oi word ta ache bujhate chaile _ diye jete hbe. 3rd position chaile '__r' avabe hbe

-- NULL value diye filter
SELECT * from employees WHERE deptID IS NULL;


-- JOIN
-- Inner Join
-- Syntax
-- SELECT "column_name jegulo chai"
-- FROM "first_table/left_table"
-- INNER JOIN "second_table/right_table" ON "jei_column_chai-1st-table" = "jei_column_chai-2nd-table";
SELECT employee.full_name, employee.job_role, employee.department_name
FROM employee
INNER JOIN department ON department.department_id = employee.department_id

-- Left Join/Left Outer Join
-- The LEFT JOIN keyword returns all records from the left table (table1), and the matching records from the right table (table2).
-- syntax,
-- SELECT columns_from_both_tables
-- FROM table1
-- LEFT JOIN table2
-- ON table1.column1 = table2.column2
SELECT *
FROM employee
LEFT JOIN department ON department.department_id = employee.department_id


-- Right Join/Right Outer Join
-- The Right Join or Right Outer Join query in SQL returns all rows from the right table, even if there are no matches in the left table.
-- Syntax,
-- SELECT columns_from_both_tables
-- FROM table1
-- RIGHT JOIN table2
-- ON table1.column1 = table2.column2
SELECT *
FROM employee
RIGHT JOIN department ON department.department_id = employee.department_id


-- Full Join
-- The Full Join basically returns all records from the left table and also from the right table.
-- Syntax,
-- SELECT columns
-- FROM table1
-- FULL OUTER JOIN table2
-- ON table1.column1 = table2.column2;
SELECT *
FROM employee
FULL JOIN department ON department.department_id = employee.department_id


-- Natural Join
-- Natural Join in SQL combines records from two or more tables based on the common column between them.
-- Syntax,
-- SELECT * FROM table1 NATURAL JOIN table2
SELECT *
FROM employee
NATURAL JOIN department;


-- Aggregate Functions
SELECT AVG(salary) as AverageSalary from employee; -- Average
SELECT MIN(salary) as MinimumSalary from employee; -- Minimum
SELECT Max(salary) as MaximumSalary from employee; -- Maximum
SELECT Sum(salary) as TotalSalary from employee; -- Sum

SELECT deptID, AVG(salary) from employee GROUP BY deptID; -- Grouping kore ber kora

-- Example
SELECT d.name, AVG(e.salary), SUM(e.salary), MAX(e.salary) FROM employee e 
FULL JOIN departments e on e.deptID = d.deptID
GROUP BY d.name;

-- HAVING
SELECT d.name, AVG(e.salary), SUM(e.salary), MAX(e.salary) FROM employee e 
FULL JOIN departments e on e.deptID = d.deptID
GROUP BY d.name HAVING AVG(e.salary) > 60000;

-- Sub Query
SELECT * from employees WHERE salary = (
    SELECT MAX(salary) from employees
);

-- Stored Procedures and Functions
-- Stored Procedures
CREATE PROCEDURE deactivate_unpaid_accounts()
LANGUAGE SQL
AS $$
    UPDATE accounts SET account = false WHERE balance = 0;
$$;

CALL deactivate_unpaid_accounts();


-- Functions
CREATE FUNCTION account_type_count(account_type text) RETURNS INTEGER
LANGUAGE plpgsql
AS $$
    DECLARE account_count int;
    BEGIN
        SELECT COUNT(*) into account_count from accounts WHERE accounts.account_type = $1;
        RETURN account_count;
    END;
$$;


-- Triggers
-- Add product with 5% tax
CREATE TABLE products (
    id serial PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    base_price FLOAT NOT NULL,
    final_price FLOAT
)

CREATE Trigger add_tax_trigger
AFTER
insert on products
FOR each row 
EXECUTE FUNCTION update_final_price();

CREATE or REPLACE FUNCTION update_final_price()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    BEGIN
        -- NEW, OLD
        NEW.final_price := NEW.base_price * 1.05;
        RETURNS NEW;
    END;
$$;


-- Indexing and Optimization
explain analyze select * from employees;

explain analyze select empid, name, email from employees WHERE name = "Greta";

-- Syntax in postgresql
-- CREATE INDEX "index_name" on "table_name(column_name)" 
CREATE INDEX name_idx on employees(name); -- indexing kore avabe


