-- 1

USE soft_uni;

select first_name, last_name
from employees
where substring(first_name, 1, 2) = 'Sa'
order by employee_id;

-- 2 

select first_name, last_name
from employees
where last_name like '%ie%'
order by employee_id;

-- 3 

select first_name
from employees
where department_id in (3, 10)
and year(hire_date) between 1995 and 2005
order by employee_id;

-- 4 

select first_name, last_name
from employees
where job_title not like'%engineer%'
order by employee_id;

-- 5 

SELECT `name`
FROM towns
WHERE char_length(`name`) in (5, 6)
ORDER BY `name`;

-- 6

SELECT town_id, `name`
FROM towns
WHERE LEFT(`name`,1) in ('m', 'k', 'b', 'e')
ORDER BY `name`;

-- 7

SELECT town_id, `name`
FROM towns
WHERE LEFT(`name`,1) not in ('r', 'b', 'd')
ORDER BY `name`;

-- 8

CREATE VIEW v_employees_hired_after_2000 AS

SELECT first_name, last_name
FROM employees
WHERE YEAR(hire_date) > 2000
ORDER BY employee_id;

-- 9

SELECT first_name, last_name
FROM employees
WHERE char_length(last_name) = 5
ORDER BY employee_id;

-- 10

USE geography;

SELECT country_name, iso_code
FROM countries
WHERE country_name like '%a%a%a%'
ORDER BY iso_code;

-- 11

SELECT p.peak_name, r.river_name, lower(concat(p.peak_name, RIGHT(r.river_name,char_length(r.river_name)-1))) AS mix
FROM peaks AS p JOIN rivers AS r
WHERE RIGHT(p.peak_name, 1) = LEFT(r.river_name, 1)
ORDER BY mix;

-- 12

USE diablo;

SELECT `name`, DATE_FORMAT(`start`,'%Y-%m-%d') AS `start`
FROM games
WHERE YEAR(`start`) in (2011, 2012)
ORDER BY `start`, `name`
LIMIT 50;

-- 13

SELECT user_name, RIGHT(`email`, char_length(`email`)-locate('@',`email`)) AS `Email Provider`
FROM users
ORDER BY `Email Provider`, user_name;

-- 14

SELECT user_name, ip_address
FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;

-- 15

SELECT `name` AS `game`, 
CASE
WHEN HOUR(`start`)>=0 AND HOUR(`start`)<12 THEN 'Morning'
WHEN HOUR(`start`)>=12 AND HOUR(`start`)<18 THEN 'Afternoon'
WHEN HOUR(`start`)>=18 AND HOUR(`start`)<24 THEN 'Evening'
END AS `Part of the Day`,
CASE
WHEN `duration`<=3 THEN 'Extra Short'
WHEN `duration`>3 AND `duration`<=6 THEN 'Short'
WHEN `duration`>6 AND `duration`<=10 THEN 'Long'
ELSE 'Extra Long'
END AS `Duration`
FROM games
ORDER BY `name`,`Part of the Day`;

-- 16 

USE orders;

SELECT product_name, order_date, DATE_ADD(order_date, INTERVAL 3 DAY) AS `pay_due`, DATE_ADD(order_date, INTERVAL 1 MONTH) AS `order_due`
FROM orders;