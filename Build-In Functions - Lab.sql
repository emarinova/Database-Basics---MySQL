USE book_library;

-- 1 

select title
from books
where substring(title, 1, 3) = 'The'
order by id;

-- 2 

select replace(title, 'The', '***') as `title`
from books
where substring(title, 1, 3) = 'The'
order by id;

-- 3 

select round(sum(cost),2)
from books;

-- 4 

select concat(first_name, ' ', last_name) as 'Full Name', timestampdiff(day, born, died) as 'Days Lived'
from authors
where died is not null
order by id;

-- 5 

select title 
from books
where title like 'Harry Potter%'
order by id;