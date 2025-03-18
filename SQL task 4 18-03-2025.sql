CREATE DATABASE company_db2;
USE company_db2;

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    dept_id INT,
    join_date DATE NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

# Insert Data 

INSERT INTO departments (dept_name) 
VALUES 
('HR'),
('Finance'),
('IT'),
('Marketing'),
('Operations');

INSERT INTO employees (first_name, last_name, email, salary, dept_id, join_date) 
VALUES
('John', 'Doe', 'john.doe@example.com', 50000.00, 1, '2021-05-15'), -- HR
('Jane', 'Smith', 'jane.smith@example.com', 60000.00, 2, '2020-07-01'), -- Finance
('Alice', 'Johnson', 'alice.johnson@example.com', 55000.00, 3, '2022-01-20'), -- IT
('Bob', 'Brown', 'bob.brown@example.com', 70000.00, 4, '2021-09-10'), -- Marketing
('Charlie', 'Davis', 'charlie.davis@example.com', 65000.00, 2, '2023-02-10'), -- Finance
('David', 'Miller', 'david.miller@example.com', 45000.00, 1, '2019-08-23'), -- HR
('Eve', 'Wilson', 'eve.wilson@example.com', 75000.00, 5, '2022-11-05'); -- Operations

# Retrieve Data 

# Retrieve all employees' details.

SELECT * FROM employees;

# Retrieve all employees in the IT department.

SELECT * FROM employees e
JOIN departments d on e.dept_id = d.dept_id
WHERE d.dept_name = 'IT';

# Retrieve employees who earn more than 80,000.

SELECT * FROM employees
WHERE salary > 80000;

# Update Data

# Increase the salary of employees in Finance by 10%.

UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'Finance');

# Change the department of an employee whose email is 'rajesh.gupta@example.com' to IT.

UPDATE employees
SET dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'IT')
WHERE email = 'charlie.davis@example.com';

# Delete Data

# Delete an employee who joined before 2021.

DELETE from employees
WHERE year(join_date) < 2021;

# Delete a department that has no employees.

DELETE FROM departments
WHERE dept_id NOT IN (SELECT distinct dept_id FROM employees);

# Subquery Tasks

# Find employees who earn more than the average salary of all employees.

SELECT first_name, last_name
FROM employees
WHERE salary >  (SELECT AVG(salary) from employees);

# Find employees who work in the same department as ‘Neha Reddy’.

SELECT first_name, last_name
FROM employees
WHERE dept_id = (SELECT dept_id FROM employees WHERE first_name = 'Charlie' and last_name = 'Davis');

# Retrieve the department with the highest number of employees.

SELECT dept_name 
from departments 
where dept_id = (
	SELECT dept_id 
	FROM employees 
    group by dept_id
	ORDER BY count(*) desc
	LIMIT 1
);


