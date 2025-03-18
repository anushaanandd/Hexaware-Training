CREATE DATABASE school_db;

USE school_db;

CREATE TABLE students (
	id int auto_increment primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(100) unique not null,
    age int not null,
    grade varchar(50) not null,
    enrollment_date date not null
);

INSERT INTO students (first_name, last_name, email, age, grade, enrollment_date)
values
('Anusha','Anand','anusha@example.com',16, 'A','2023-12-21'),
('Aditya','Kannan','aditya@example.com',15, 'O','2024-07-07'),
('Abinaya','Sri','abinaya@example.com',17, 'B+','2022-12-03'),
('Nithin','Raj','nitin@example.com',15,'A+','2024-05-07'),
('Nilesh','Krishna','nilesh@example.com',18,'C', '2023-07-07');

select * from students;

select first_name, last_name, age
from students
where age > 15;

update students
set grade = 'A+'
where id = 3;

delete from students
where id = 5;

# update students set enrollment_date = '2025-02-02' where id = 1 

select first_name, last_name
from students
where enrollment_date >= curdate() - interval 6 month;

select *
from students
order by grade desc 
