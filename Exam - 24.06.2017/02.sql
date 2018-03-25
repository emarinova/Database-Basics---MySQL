INSERT INTO submissions(passed_tests, problem_id, user_id)
SELECT CEIL(SQRT(POW(CHAR_LENGTH(name),3))-CHAR_LENGTH(name)), id, CEIL((id*3)/2)
		FROM problems
        WHERE id BETWEEN 1 AND 10
        ;
