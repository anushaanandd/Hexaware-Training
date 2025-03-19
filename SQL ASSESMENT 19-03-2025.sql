-- MySQL Assignment: Tables, JOINS, Queries, and Stored Procedures

-- Step 1: Table Creation & Data Insertion

-- 1. Create a database named company db and switch to it.

CREATE DATABASE company_db;
USE company_db;

/* 2. Create three tables:
	• departments: Stores department details.
	• employees : Stores employee details and references departments.
	• salaries: Stores employee salaries over time and references employees.
*/

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dept_id INT,
    join_date DATE NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

CREATE TABLE salaries (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- 3. Insert at least 5 departments into the departments table.

INSERT INTO departments (dept_name) 
VALUES 
('HR'),
('Finance'),
('IT'),
('Marketing'),
('Operations');

/* 4. Insert at least 10 employees into the employees table, including:
• Employees with a department.
• Employees without a department ( dept id = NULL ).
*/

INSERT INTO employees (first_name, last_name, email, dept_id, join_date) 
VALUES
('John', 'Doe', 'john.doe@example.com', 1, '2021-05-15'),   -- HR
('Jane', 'Smith', 'jane.smith@example.com', 2, '2020-07-01'), -- Finance
('Alice', 'Johnson', 'alice.johnson@example.com', 3, '2022-01-20'), -- IT
('Bob', 'Brown', 'bob.brown@example.com', 4, '2021-09-10'), -- Marketing
('Charlie', 'Davis', 'charlie.davis@example.com', 2, '2023-02-10'), -- Finance
('David', 'Miller', 'david.miller@example.com', NULL, '2019-08-23'), -- No department
('Eve', 'Wilson', 'eve.wilson@example.com', 5, '2022-11-05'), -- Operations
('Grace', 'Lee', 'grace.lee@example.com', 1, '2020-03-17'), -- HR
('Michael', 'Green', 'michael.green@example.com', 3, '2021-04-11'), -- IT
('Sophia', 'Taylor', 'sophia.taylor@example.com', NULL, '2021-12-25'); -- No department

-- 5. Insert at least 10 salary records in the salaries table, ensuring that some employees have multiple salary entries.

INSERT INTO salaries (emp_id, salary, start_date, end_date) 
VALUES
(1, 50000.00, '2021-05-15', '2022-05-15'), 
(1, 52000.00, '2022-05-16', NULL),  -- Current salary
(2, 60000.00, '2020-07-01', '2021-07-01'),
(2, 62000.00, '2021-07-02', '2022-07-02'),
(3, 55000.00, '2022-01-20', NULL),  -- Current salary
(4, 70000.00, '2021-09-10', '2022-09-10'),
(4, 73000.00, '2022-09-11', NULL),  -- Current salary
(5, 65000.00, '2023-02-10', NULL),  -- Current salary
(6, 45000.00, '2019-08-23', '2020-08-23'),
(7, 75000.00, '2022-11-05', NULL);  -- Current salary


-- Step 2: JOINS & Queries

-- 6. Retrieve all employees with their department names (INNER JOIN) •

SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
INNER JOIN departments d on d.dept_id = e.dept_id;

-- 7. Retrieve all employees, including those without a department (LEFT JOIN) -

SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
LEFT JOIN departments d on d.dept_id = e.dept_id;

-- 8. Retrieve all departments, including those without employees (RIGHT JOIN)

SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
RIGHT JOIN departments d on d.dept_id = e.dept_id;

-- 9. Retrieve employees with their latest salary (Subquery).

SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.start_date = (
	SELECT MAX(start_date) FROM salaries WHERE emp_id = e.emp_id
);

-- 10. Find the department with the highest average salary (Aggregate Function & JOIN).

SELECT d.dept_name, AVG(salary) as Average_Salary FROM salaries s 
JOIN employees e ON e.emp_id = s.emp_id 
JOIN departments d ON d.dept_id = e.dept_id
GROUP BY dept_name
ORDER BY Average_Salary DESC
LIMIT 1;

-- 11. Find employees who joined before the average joining date (Subquery).

SELECT first_name, last_name, join_date
FROM employees WHERE join_date < (SELECT AVG(join_date) FROM employees);

-- 12. Find the highest-paid employee in each department (GROUP BY & JOIN).

SELECT e.first_name, e.last_name, d.dept_name, s.salary 
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
JOIN departments d ON e.dept_id = d.dept_id
WHERE s.salary = (
    SELECT MAX(s1.salary) FROM salaries s1
    JOIN employees e1 ON s1.emp_id = e1.emp_id
    WHERE e1.dept_id = e.dept_id
    GROUP BY d.dept_name
);

-- 13. Retrieve the top 3 highest-paid employees in the company (ORDER BY & LIMIT).

SELECT e.first_name, e.last_name, s.salary
FROM employees e 
JOIN salaries s ON e.emp_id = s.emp_id
ORDER BY salary DESC
LIMIT 3;


-- Step 3: Stored Procedures

-- 14. Create a stored procedure to get all employees in a given department (IN Parameter).

DELIMITER $$

CREATE PROCEDURE GetAllEmployees(IN dept_id_param INT)
BEGIN 
	SELECT * FROM employees WHERE dept_id = dept_id_param;
END $$

DELIMITER ;

CALL GetAllEmployees(1);

-- 15. Create a stored procedure to update an employee's salary by a given percentage.

DELIMITER $$

CREATE PROCEDURE UpdateEmpSalary(IN emp_id_param INT, IN percent DECIMAL(5,2))
BEGIN 
	UPDATE salaries
    SET salary = salary + (salary * percent/100)
    WHERE emp_id = emp_id_param;
END $$

DELIMITER ;

CALL UpdateEmpSalary(3,15);

-- 16. Create a stored procedure to retrieve employees earning above the average salary-

DELIMITER $$

CREATE PROCEDURE EmpSalaryAboveAvg()
BEGIN
	SELECT * FROM employees e 
    JOIN salaries s on e.emp_id = s.emp_id 
    WHERE s.salary > (SELECT AVG(salary) FROM salaries);
END $$

DELIMITER ;

CALL EmpSalaryAboveAvg();

-- 17. Create a stored procedure to insert a new employee along with their salary (Transaction Handling).

DELIMITER $$

CREATE PROCEDURE InsertEmp(
	IN fname VARCHAR(50),
    IN lname VARCHAR(50),
    IN email VARCHAR(100),
    IN dept INT,
    IN join_date DATE,
    IN sal DECIMAL(10,2))
BEGIN
	DECLARE new_emp_id INT;
    
	START TRANSACTION;
    
	INSERT INTO employees (first_name, last_name, email, dept_id, join_date)
	VALUES (fname, lname, email, dept, join_date);
    
    SET new_emp_id = LAST_INSERT_ID();
    
    INSERT INTO salaries (emp_id, salary, start_date, end_date) 
	VALUES (new_emp_id, sal, join_date, NULL);
    
    COMMIT;
END $$

DELIMITER ;
DROP PROCEDURE InsertEmp;

CALL InsertEmp('Anusha', 'Anand', 'anusha@example.com', 1, '2024-03-17', 50000.00);

-- 18. Create a stored procedure to delete an employee and their salary records(Cascade Deletion).

DELIMITER $$

CREATE PROCEDURE DeleteEmployee(IN emp_id_param INT)
BEGIN
	DELETE FROM employees 
    WHERE emp_id = emp_id_param ;
END $$

DELIMITER ;

CALL DeleteEmployee(4);

-- 19. Create a stored procedure to get the total salary expenditure for a department

DELIMITER $$

CREATE PROCEDURE TotalExpenditure(IN dept_id_param INT)
BEGIN
	SELECT d.dept_name ,SUM(s.salary) from salaries s 
    JOIN employees e ON e.emp_id = s.emp_id
    JOIN departments d ON d.dept_id = e.dept_id
    WHERE e.dept_id = dept_id_param
    GROUP BY d.dept_name; 
END $$

DELIMITER ;

CALL TotalExpenditure(1);