create database library_db;
use library_db;

create table books(
book_id int auto_increment primary key,
title varchar(50) not null,
author varchar(50) not null,
published_year int not null,
genre varchar(50) not null,
price decimal(10,2) not null);

INSERT INTO books (title, author, published_year, genre, price) VALUES
('It ends with us', 'Hoover', 2021, 'Romance',450),
('Normal People', 'Rooney', 2020, 'Comedy',475),
('Verity', 'Hoover', 2023, 'Thriller',550),
('Intermezzo', 'Rooney', 2022, 'Thriller',390),
('Almond', 'Rooney', 2025, 'Sad',870);

select title, price 
from books
where genre = 'Thriller';

update books
set genre = 'Suspence'
where title = 'Intermezzo';

delete from books
where price > 600;

select * from books;