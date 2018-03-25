-- 3

UPDATE reports
SET status_id = 2
WHERE status_id = 1
AND category_id = 4;

-- 4

DELETE FROM reports
WHERE status_id = 4;

-- 5

SELECT username, age
FROM users
ORDER BY age, username DESC;

-- 6

SELECT description, open_date
FROM reports
WHERE employee_id IS NULL
ORDER BY open_date, description;

-- 7

SELECT e.first_name, e.last_name, r.description, DATE_FORMAT(r.open_date, '%Y-%m-%d') AS open_date
FROM employees AS e
INNER JOIN reports AS r
ON e.id = r.employee_id
ORDER BY e.id, r.open_date, r.id;


-- 8

SELECT cat.name AS category_name, count(r.id) AS reports_number
FROM categories AS cat
JOIN reports AS r
ON cat.id = r.category_id
GROUP BY r.category_id
ORDER BY reports_number, category_name;