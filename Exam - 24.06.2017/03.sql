UPDATE problems AS p
JOIN contests AS con ON p.contest_id = con.id
JOIN categories AS cat ON con.category_id = cat.id
JOIN submissions AS s ON s.problem_id = p.id
SET  p.tests = 
CASE p.id % 3
WHEN 0 THEN  CHAR_LENGTH(cat.name)
WHEN 1 THEN ( SELECT SUM(s.id)
				FROM submissions AS s	
				GROUP BY s.problem_id
				HAVING s.problem_id = p.id
				)
WHEN 2 THEN CHAR_LENGTH(con.name)
END
WHERE p.tests = 0;