CREATE DATABASE company_db;
USE company_db;

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


INSERT INTO departments (dept_name) VALUES 
('HR'),
('Finance'),
('IT'),
('Marketing'),
('Operations');


INSERT INTO employees (first_name, last_name, email, salary, dept_id, join_date) VALUES
('Amit', 'Sharma', 'amit.sharma@example.com', 75000, 1, '2023-06-15'),
('Priya', 'Verma', 'priya.verma@example.com', 88000, 2, '2021-09-20'),
('Rajesh', 'Gupta', 'rajesh.gupta@example.com', 96000, 3, '2022-12-05'),
('Neha', 'Reddy', 'neha.reddy@example.com', 73000, 4, '2020-08-10'),
('Vikram', 'Patel', 'vikram.patel@example.com', 99000, 5, '2021-11-25'),
('Kiran', 'Joshi', 'kiran.joshi@example.com', 81000, 3, '2023-04-12'),
('Arjun', 'Singh', 'arjun.singh@example.com', 89000, 4, '2019-05-18');

# SUBQUERY TASKS

# 1. Find employees who earn more than the average salary in their department.

select first_name, last_name, salary 
from employees 
where salary > (select avg(salary) from employees);

# 2. Find employees who work in the same department as 'Rajesh Gupta'.

select first_name, last_name
from employees
where dept_id = (select dept_id from employees where first_name = 'Rajesh' and last_name = 'Gupta');

# 3. Find employees who joined after the earliest jin date in the IT department.

select first_name, last_name,salary
from employees e1
join departments d1 on e1.dept_id = d1.dept_id
where e1.join_date > (select min(join_date) from employees e join departments d on e.dept_id = d.dept_id where d.dept_name = 'IT');

# 4. Find the department with the highest average salary.

select d.dept_name, avg(e.salary) as avg_salary
from employees e 
join departments d on e.dept_id = d.dept_id
group by d.dept_name 
order by avg_salary desc
limit 1;
 
 # 5. Retrieve the employee(s) with the second-highest salary.

select first_name, last_name, salary
from employees
ORDER BY salary DESC 
LIMIT 1 OFFSET 1 ;

# INLINE QUERY TAKS

# 6. Get a list of employees along with their department names.

select e.first_name, e.last_name, d.dept_name
from employees e
join departments d on e.dept_id = d.dept_id ;

# 7. Display each employee's salary and show whether it is above or below the company's average salary.

select first_name, last_name, salary,
case
when salary > (select avg(salary) from employees) then 'Above Average'
when salary < (select avg(salary) from employees) then 'Below Average'
else 'Average'
end as salary_status
from employees;


# 8. Show employee details along with the count of employees in their department.

select e.first_name, e.last_name, e.email,
(select count(*) from employees e1 where e.dept_id = e1.dept_id) as dept_emp_count
from employees e;

# 9. Retrieve employees sorted by their department's total salary expenditure.

select e.first_name, e.last_name, e.email, e.dept_id,
(select sum(salary) from employees e1 where e.dept_id = e1.dept_id) as expenditure
from employees e 
order by expenditure asc;

# 10. Find the top 3 highest-paid employees in each department.

SELECT *
FROM employees e
WHERE (SELECT COUNT(*) 
       FROM employees e2
       WHERE e2.dept_id = e.dept_id AND e2.salary > e.salary) < 3
ORDER BY e.dept_id, e.salary DESC;




