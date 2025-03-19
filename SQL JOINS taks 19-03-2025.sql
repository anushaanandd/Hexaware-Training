CREATE DATABASE sales_db;
USE sales_db;

CREATE TABLE customers(
customer_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
city VARCHAR(50),
country VARCHAR(50)
);

CREATE TABLE orders (
order_id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT,
order_date DATE NOT NULL,
total_amount DECIMAL(10,2) NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

INSERT INTO customers (first_name, last_name, email, city, country) VALUES
('Amit', 'Sharma', 'amit.sharma@example.com', 'Delhi', 'India'),
('Priya', 'Verma', 'priya.verma@example.com', 'Mumbai', 'India'),
('Rajesh', 'Gupta', 'rajesh.gupta@example.com', 'Bangalore', 'India'),
('Neha', 'Reddy', 'neha.reddy@example.com', 'Hyderabad', 'India'),
('Vikram', 'Patel', 'vikram.patel@example.com', 'Pune', 'India'),
('Kiran', 'Joshi', 'kiran.joshi@example.com', 'Chennai', 'India'),
('Arjun', 'Singh', 'arjun.singh@example.com', 'Kolkata', 'India'),
(NULL, NULL, NULL, NULL, NULL),  -- Completely NULL customer
('Ravi', 'Mehta', 'ravi.mehta@example.com', 'Ahmedabad', 'India'); -- Customer with no orders


INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-03-01', 2500.00),
(1, '2024-03-15', 1800.00),
(2, '2024-02-20', 3200.00),
(3, '2024-02-25', 1500.00),
(4, '2024-01-10', 2700.00),
(5, '2024-01-20', 5000.00),
(6, '2024-03-05', 4300.00),
(7, '2024-02-28', 1200.00),
(NULL, '2024-03-10', 2200.00); -- Order with NULL customer_id

#INNER JOIN

SELECT c.first_name,c.last_name,o.customer_id, o.order_date FROM customers c 
INNER JOIN orders o
ON c.customer_id=o.customer_id;

#LEFT JOIN

SELECT c.first_name,c.last_name,o.customer_id, o.order_date FROM customers c 
LEFT JOIN orders o
ON c.customer_id=o.customer_id;

# RIGHT JOIN

SELECT c.first_name,c.last_name,o.customer_id, o.order_date FROM customers c 
RIGHT JOIN orders o
ON c.customer_id=o.customer_id;

# UNION

SELECT c.first_name,c.last_name, o.customer_id, o.order_date FROM customers c 
LEFT JOIN orders o
ON c.customer_id=o.customer_id

UNION

SELECT c.first_name,c.last_name,o.customer_id, o.order_date FROM customers c 
RIGHT JOIN orders o
ON c.customer_id=o.customer_id;

# CROSS JOIN

SELECT c.first_name,c.last_name,o.customer_id, o.order_date FROM customers c 
CROSS JOIN orders o

