-- 5
    
SELECT id, username, email
FROM users
ORDER BY id;
    
-- 6

SELECT id, name
FROM categories
WHERE parent_id IS NULL
ORDER BY id;

-- 7

SELECT id, name, tests
FROM problems
WHERE tests > points
AND LOCATE(' ', name) > 0
ORDER BY id DESC;

-- 8

SELECT p.id, concat(cat.name, ' - ', con.name, ' - ', p.name) AS full_path
FROM problems AS p
JOIN contests AS con
ON p.contest_id = con.id
JOIN categories AS cat
ON con.category_id = cat.id
ORDER BY p.id;

-- 9

SELECT c2.id, c2.name
FROM categories AS c1
RIGHT JOIN categories AS c2
ON c1.parent_id = c2.id
WHERE c1.parent_id IS NULL
ORDER BY c2.name, c2.id;

-- 10

SELECT u1.id, u1.username, u1.password 
FROM users AS u1
WHERE password IN (
					SELECT u2.password 
                    FROM users AS u2
                    WHERE u2.id != u1.id
                    )
ORDER BY username, id;

-- 11
SELECT *
FROM
		(SELECT c.id, c.name, COUNT(uc.user_id) AS contestants
		FROM contests AS c
		LEFT JOIN users_contests AS uc
		ON c.id = uc.contest_id
		GROUP BY uc.contest_id
		ORDER BY contestants DESC
		LIMIT 5) AS temp
ORDER BY temp.contestants, temp.id
LIMIT 5;

-- 12

SELECT s.id, u.username, p.name, concat(s.passed_tests, ' / ', p.tests) AS result

FROM submissions AS s 
JOIN users AS u
ON s.user_id = u.id

JOIN problems AS p
ON s.problem_id = p.id

JOIN ( SELECT uc.user_id
FROM users_contests AS uc
GROUP BY uc.user_id
ORDER BY COUNT(uc.contest_id) DESC
LIMIT 1 ) AS temp
ON s.user_id = temp.user_id

ORDER BY s.id DESC;
)ORDER BY s.id DESC;

-- 13

SELECT c.id, c.name, SUM(p.points) AS maximum_points

FROM contests AS c
JOIN problems AS p
ON c.id = p.contest_id

GROUP BY p.contest_id
ORDER BY maximum_points DESC, c.id;

-- 14

SELECT c.id, c.name, COUNT(c.id) AS `submissions`
FROM `contests` AS c
	INNER JOIN `problems` AS p ON p.contest_id = c.id
	INNER JOIN `submissions` AS s ON s.problem_id = p.id
WHERE s.user_id IN (
	SELECT uc.user_id 
	FROM `users_contests` AS uc
	WHERE uc.contest_id = c.id)
GROUP BY c.id, c.name
ORDER BY `submissions` DESC, c.id ASC;