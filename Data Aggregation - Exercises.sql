USE gringotts;

-- 1 

SELECT COUNT(*)
FROM wizzard_deposits;

-- 2

SELECT MAX(magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits;

-- 3

SELECT deposit_group, MAX(magic_wand_size) AS `longest_magic_wand`
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY `longest_magic_wand`, deposit_group;

-- 4

SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY AVG(magic_wand_size)
LIMIT 1;

-- 5

SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY total_sum;

-- 6

SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
ORDER BY deposit_group;

-- 7

SELECT deposit_group, SUM(deposit_amount) AS total_sum
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC;

-- 8

SELECT deposit_group, magic_wand_creator, MIN(deposit_charge)
FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group;

-- 9

SELECT 
CASE
WHEN age BETWEEN 0 AND 10 THEN '[0-10]'
WHEN age BETWEEN 11 AND 20 THEN '[11-20]'
WHEN age BETWEEN 21 AND 30 THEN '[21-30]'
WHEN age BETWEEN 31 AND 40 THEN '[31-40]'
WHEN age BETWEEN 41 AND 50 THEN '[41-50]'
WHEN age BETWEEN 51 AND 60 THEN '[51-60]'
WHEN age > 60 THEN '[61+]'
END AS age_group, 
COUNT(id) AS wizzard_count
FROM wizzard_deposits
GROUP BY age_group
ORDER BY wizzard_count;

-- 10

SELECT LEFT(first_name, 1) AS first_letter
FROM wizzard_deposits
WHERE deposit_group = 'Troll Chest'
GROUP BY first_letter
ORDER BY first_letter; 

-- 11

SELECT deposit_group, is_deposit_expired, AVG(deposit_interest) AS average_interest
FROM wizzard_deposits
WHERE deposit_start_date > '1985-01-01'
GROUP BY is_deposit_expired, deposit_group
ORDER BY deposit_group DESC, is_deposit_expired ASC;

-- 12

CREATE VIEW vieww AS

SELECT wd1.first_name AS host_wizzard, wd1.deposit_amount AS host_wizzard_deposit, 
		wd2.first_name AS guest_wizzard, wd2.deposit_amount AS guest_wizzard_deposit, wd1.deposit_amount - wd2.deposit_amount AS difference
FROM wizzard_deposits as wd1
INNER JOIN wizzard_deposits as wd2 ON wd1.id + 1 = wd2.id;

SELECT SUM(difference)
FROM vieww;

-- 13

USE soft_uni;

SELECT department_id, MIN(salary)
FROM employees
WHERE hire_date > '2000-01-01'
GROUP BY department_id
HAVING department_id IN (2, 5, 7)
ORDER BY department_id ASC;

-- 14

CREATE TABLE high_paid_employess AS

SELECT * 
FROM employees
WHERE salary > 30000;

DELETE FROM high_paid_employess
WHERE manager_id = 42;

UPDATE high_paid_employess
SET salary = salary + 5000
WHERE department_id = 1;

SELECT department_id, AVG(salary) AS avg_salary
FROM high_paid_employess
GROUP BY department_id
ORDER BY department_id;

-- 15

SELECT department_id, MAX(salary) AS max_salary
FROM employees
GROUP BY department_id
HAVING max_salary NOT BETWEEN 30000 AND 70000
ORDER BY department_id;

-- 16

SELECT COUNT(salary)
FROM employees
WHERE manager_id IS NULL;

-- 17

SELECT e.department_id, MAX(e.salary) AS third_max_salary
FROM employees as e JOIN (SELECT e.department_id, MAX(e.salary) AS second_max_salary
							FROM employees as e JOIN (SELECT e.department_id, MAX(e.salary) AS max_salary
														FROM employees AS e
														GROUP BY e.department_id
														ORDER BY e.department_id) as m
							WHERE e.department_id = m.department_id AND e.salary < m.max_salary
							GROUP BY e.department_id
							ORDER BY e.department_id) as k
WHERE e.department_id = k.department_id AND e.salary < k.second_max_salary
GROUP BY e.department_id
ORDER BY e.department_id;

-- 18

SELECT e.first_name, e.last_name, e.department_id
FROM employees as e
WHERE e.salary > (	SELECT AVG(e2.salary)
					FROM employees AS e2
					GROUP BY e2.department_id
					HAVING e2.department_id = e.department_id)
ORDER BY e.department_id, e.employee_id
LIMIT 10;

-- 19

SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;