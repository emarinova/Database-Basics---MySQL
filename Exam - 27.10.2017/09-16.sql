-- 9

SELECT cat.name, count(e.id)
FROM categories AS cat
LEFT JOIN departments AS d
ON d.id = cat.department_id
JOIN employees AS e
ON e.department_id = d.id
GROUP BY cat.name
ORDER BY cat.name;

-- 10

SELECT DISTINCT c.name
FROM users AS u JOIN reports AS r ON u.id = r.user_id
JOIN categories AS c ON r.category_id = c.id
WHERE MONTH(r.open_date) = MONTH(u.birthdate)
AND DAY(r.open_date) = DAY(u.birthdate)
ORDER BY c.name;

-- 11

SELECT CONCAT(e.first_name, ' ', e.last_name) AS name, COUNT(r.id) AS users_count
FROM reports AS r
RIGHT JOIN employees AS e ON e.id = r.employee_id
GROUP BY e.id
ORDER BY users_count DESC, name;

-- 12

SELECT r.open_date, r.description, u.email AS reporter_email
FROM reports AS r JOIN users AS u ON r.user_id = u.id
JOIN categories AS c ON r.category_id = c.id
JOIN departments AS d ON c.department_id = d.id
WHERE r.close_date IS NULL
AND LOWER(r.description) LIKE '%str%'
AND CHAR_LENGTH(r.description) > 20
AND d.name IN ('Infrastructure', 'Emergency', 'Roads Maintenance')
ORDER BY r.open_date, reporter_email, r.id;

-- 13

SELECT DISTINCT u.username
FROM users AS u JOIN reports AS r ON u.id = r.user_id
JOIN categories AS c ON r.category_id = c.id
WHERE LEFT(u.username, 1) = c.id
OR RIGHT(u.username, 1) = c.id
ORDER BY u.username;

-- 14

SELECT CONCAT(e.first_name, ' ', e.last_name) AS name, CONCAT(CAST(COUNT(r.close_date) AS CHAR(10)), '/', CAST(COUNT(r.open_date) AS CHAR(10))) AS closed_open_reports
FROM reports AS r JOIN employees AS e ON r.employee_id = e.id
WHERE YEAR(r.open_date) = '2016' OR YEAR(r.close_date) = '2016'
GROUP BY r.employee_id
ORDER BY name;

-- 15

SELECT d.name, IFNULL(FLOOR(AVG(DATEDIFF(close_date, open_date))), 'no info') AS average_duration
FROM reports AS r JOIN categories AS c ON r.category_id = c.id
JOIN departments AS d ON d.id = c.department_id
GROUP BY d.name
ORDER BY d.name;

-- 16

SELECT d.name, c.name, ROUND((COUNT(r.id)/t2.t1)*100)
FROM departments AS d JOIN categories AS c ON d.id = c.department_id
JOIN reports AS r ON r.category_id = c.id
JOIN (SELECT d.name AS name, COUNT(r.id) t1
		FROM departments AS d JOIN categories AS c ON d.id = c.department_id
		JOIN reports AS r ON r.category_id = c.id 
		GROUP BY d.name) AS t2 ON d.name = t2.name
GROUP BY d.name, c.name;
