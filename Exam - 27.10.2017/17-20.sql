-- 17
DELIMITER $$

CREATE FUNCTION udf_get_reports_count(employee_id INT, status_id INT)
RETURNS INT
BEGIN
DECLARE r_count INT;
SET r_count :=
 (SELECT COUNT(r.id)
		FROM reports AS r
		WHERE r. employee_id = employee_id 
		AND r.status_id = status_id);
RETURN r_count;
END $$

-- 18
DELIMITER $$

CREATE PROCEDURE usp_assign_employee_to_report(employee_id INT, report_id INT)
BEGIN
	START TRANSACTION;
		IF 
			(SELECT department_id FROM employees WHERE id = employee_id) 
			!= (SELECT c.department_id FROM categories AS c JOIN reports AS r ON r.category_id = c.id WHERE r.id = report_id) 
		THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee doesn\'t belong to the appropriate department!';
            ROLLBACK;
		ELSE 
			UPDATE reports 
            SET employee_id = employee_id
			WHERE id = report_id;
            COMMIT;
		END IF;
END $$

-- 19
DELIMITER $$

CREATE TRIGGER change_status
BEFORE UPDATE 
ON reports
FOR EACH ROW 
BEGIN
IF NEW.close_date IS NOT NULL
THEN SET NEW.status_id = 3;
END IF;
END $$

-- 20

DELIMITER ;

SELECT c.name, COUNT(r.id) AS reports_number, 
CASE
WHEN (SELECT count(r.id) FROM reports AS r WHERE r.status_id = 1 AND r.category_id = c.id) < (SELECT count(r.id) FROM reports AS r WHERE r.status_id = 2 AND r.category_id = c.id) 
THEN 'in progress'
WHEN (SELECT count(r.id) FROM reports AS r WHERE r.status_id = 1 AND r.category_id = c.id) > (SELECT count(r.id) FROM reports AS r WHERE r.status_id = 2 AND r.category_id = c.id)
THEN 'waiting'
WHEN (SELECT count(r.id) FROM reports AS r WHERE r.status_id = 1 AND r.category_id = c.id) = (SELECT count(r.id) FROM reports AS r WHERE r.status_id = 2 AND r.category_id = c.id) 
THEN 'equal'
END AS main_status
FROM categories AS c JOIN reports AS r ON c.id = r.category_id
WHERE status_id IN (1, 2)
GROUP BY c.name
ORDER BY c.name;

