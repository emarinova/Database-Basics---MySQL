USE soft_uni;

-- 1

SELECT * 
FROM departments
ORDER BY department_id;

-- 2

SELECT distinct `name`
FROM departments
ORDER BY department_id;

-- 3

SELECT first_name, last_name, salary
FROM employees
ORDER BY employee_id;

-- 4

SELECT first_name, middle_name, last_name
FROM employees
order by employee_id;

-- 5

SELECT concat(first_name, '.', last_name, '@softuni.bg') AS `full_email_address`
FROM employees;

-- 6

SELECT distinct salary
FROM employees
order by employee_id;

-- 7

select *
from employees
where job_title = 'Sales Representative';

-- 8 

select first_name, last_name, job_title
from employees
where salary between 20000 and 30000
order by employee_id;

-- 9 

select concat(first_name, ' ', middle_name, ' ', last_name) AS full_name
from employees
where salary in (25000, 14000, 12500, 23600);

-- 10

select first_name, last_name
from employees
where manager_id is NULL;

-- 11

select first_name, last_name, salary
from employees
where salary > 50000
order by salary desc;

-- 12

select first_name, last_name
from employees
order by salary desc
limit 5;

-- 13

select first_name, last_name
from employees
where department_id <> 4;

-- 14

select *
from employees
order by salary desc, first_name, last_name desc, middle_name, employee_id;

-- 15

create view v_employees_salaries as

select first_name, last_name, salary
from employees;

-- 16

create view v_employees_job_titles as

select concat(first_name, ' ', ifnull(middle_name, ''), ' ', last_name) as full_name, job_title
from employees;

-- 17

select distinct job_title
from employees
order by job_title;

-- 18

select * 
from projects
order by start_date, name, project_id
limit 10;

-- 19 

select first_name, last_name, hire_date
from employees
order by hire_date desc
limit 7;

-- 20

update employees
set salary = salary * 1.12
where department_id in (1, 2, 4, 11);

select salary
from employees;

-- 21

use geography;

select peak_name
from peaks
order by peak_name;

-- 22

select country_name, population
from countries
where continent_code = 'EU'
order by population desc, country_name
limit 30;

-- 23

select country_name, country_code, 
case 
when currency_code = 'EUR' then 'Euro'
else 'Not Euro'
end as currency
from countries
where currency_code is not NULL
order by country_name;

-- 24

use diablo;

select `name`
from characters
order by `name`;
