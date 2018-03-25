-- 16

DELIMITER $$

CREATE PROCEDURE udp_evaluate(id INT)
BEGIN
	START TRANSACTION;
		IF 
			id NOT IN (SELECT s.id FROM submissions AS s)
		THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Submission does not exist!';
            ROLLBACK;
		ELSE
			INSERT INTO evaluated_submissions(id, problem, user, result)
            SELECT s.id, p.name, u.username, (p.points / p.tests * s.passed_tests) AS result
            FROM submissions AS s
            INNER JOIN problems AS p
            ON s.problem_id = p.id
            INNER JOIN users AS u
            ON s.user_id = u.id
            WHERE s.id = id;
            COMMIT;
		END IF;
END $$