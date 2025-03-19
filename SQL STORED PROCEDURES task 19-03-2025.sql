-- 1. GET EMPLOYEES IN A DEPARTMENT - 3

DELIMITER $$

CREATE PROCEDURE GetEmp(IN dept_id_param INT)
BEGIN
	SELECT * FROM employees WHERE dept_id = dept_id_param;
END $$

DELIMITER ;

CALL GetEmp(3);

-- 2. Count Employees Per Department

DELIMITER $$

CREATE PROCEDURE CountEmp()
BEGIN
	SELECT d.dept_name,count(e.emp_id) FROM employees e 
    JOIN departments d on e.dept_id = d.dept_id
    GROUP BY dept_name;
END $$

DELIMITER ;

CALL CountEmp();

-- 3. Find Employees with Salary Above Average

DELIMITER $$

CREATE PROCEDURE EmpSalAboveAvg()
BEGIN
	SELECT * FROM employees 
    WHERE salary > (SELECT AVG(salary) FROM employees);
END $$

DELIMITER ;

CALL EmpSalAboveAvg();

