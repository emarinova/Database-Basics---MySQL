-- 1

USE soft_uni;

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
SELECT first_name, last_name
FROM employees
WHERE salary > 35000
ORDER BY first_name, last_name;
END $$

DELIMITER ;

CALL usp_get_employees_salary_above_35000();

-- 2

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(num DECIMAL(10,4))
BEGIN 
SELECT first_name, last_name
FROM employees
WHERE salary >= num
ORDER BY first_name, last_name, employee_id;
END $$

DELIMITER ;

CALL usp_get_employees_salary_above(48100);

-- 3

DELIMITER $$

CREATE PROCEDURE usp_get_towns_starting_with(str VARCHAR(20))
BEGIN
SELECT `name` AS town_name
FROM towns
WHERE `name` LIKE CONCAT(str, '%')
ORDER BY `name`;
END $$

DELIMITER ;

CALL usp_get_towns_starting_with('b');

-- 4

DELIMITER $$

CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(30))
BEGIN
SELECT e.first_name, e.last_name
FROM employees AS e
JOIN addresses AS a
ON e.address_id = a.address_id
JOIN towns AS t
ON a.town_id = t.town_id
WHERE t.name = town_name
ORDER BY e.first_name, e.last_name, e.employee_id;
END $$

DELIMITER ;

CALL usp_get_employees_from_town('Seattle');

-- 5

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(in_salary DECIMAL(10, 4))
RETURNS VARCHAR(20)
BEGIN
DECLARE `level` VARCHAR(20);
SET `level` = CASE 
WHEN in_salary  < 30000 THEN 'Low'
WHEN in_salary >= 30000 AND in_salary <=50000 THEN 'Average'
WHEN in_salary >50000 THEN 'High'
END;
RETURN `level`;
END $$

DELIMITER ;
SELECT ufn_get_salary_level(31000);

-- 6

DELIMITER $$

CREATE PROCEDURE usp_get_employees_by_salary_level(lvl VARCHAR(20))
BEGIN
SELECT first_name, last_name
FROM employees
WHERE CASE
WHEN LOWER(lvl) = 'low' THEN salary < 30000
WHEN LOWER(lvl) = 'average' THEN salary BETWEEN 30000 AND 50000
WHEN LOWER(lvl) = 'high' THEN salary > 50000
END
ORDER BY first_name DESC, last_name DESC;
END $$

DELIMITER ;

CALL usp_get_employees_by_salary_level('Low');

-- 7
DELIMITER $$

CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS BIT
BEGIN

	DECLARE ind INT;
    DECLARE length INT;
    DECLARE letter CHAR(1);
	SET ind = 1;
    SET length = CHAR_LENGTH(word);
    WHILE (ind <= length) DO
   
		SET letter = SUBSTRING(LOWER(word), ind, 1);
        IF ( LOCATE(letter, LOWER(set_of_letters)) > 0 )
        THEN SET ind := ind + 1;
        ELSE RETURN 0;
        END IF;
        
	END WHILE;
    
    RETURN 1;
    
END $$

-- 8 

DELIMITER $$

CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
SELECT concat(first_name, ' ', last_name) AS full_name
FROM account_holders
ORDER BY full_name, id;
END $$

-- 9

CREATE PROCEDURE usp_get_holders_with_balance_higher_than(num DECIMAL(19, 4))
BEGIN
SELECT ah.first_name, ah.last_name
FROM account_holders AS ah
JOIN accounts AS a
ON ah.id = a.account_holder_id
GROUP BY a.account_holder_id
HAVING SUM(a.balance) > num
ORDER BY a.id, ah.first_name, ah.last_name;
END $$

-- 10
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(I DECIMAL(19, 4), R DOUBLE, T INT)
RETURNS DECIMAL(19, 4)
BEGIN
	DECLARE output DECIMAL(19, 4);
    SET output := I * pow((1+R),T);
    RETURN output;
END $$

-- 11

DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(account_id INT, interest_rate DECIMAL(19, 4))
BEGIN
SELECT ac.id, ah.first_name, ah.last_name, ac.balance, ufn_calculate_future_value(ac.balance, interest_rate, 5)
FROM account_holders as ah
JOIN accounts AS ac
ON ah.id = ac.account_holder_id
WHERE ac.id = account_id;
END $$
CALL usp_calculate_future_value_for_account(1, 0.1);

-- 12

DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
START TRANSACTION;
IF (money_amount <= 0) THEN ROLLBACK;
ELSE UPDATE accounts as ac 
SET ac.balance = ac.balance + money_amount
WHERE ac.id = account_id;
END IF;
END $$

CALL usp_deposit_money(1, 10);

DELIMITER ;
SELECT id, account_holder_id, balance
FROM accounts
WHERE id IN (1, 2);

-- 13

DELIMITER $$

CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
START TRANSACTION;
IF (money_amount <= 0 OR money_amount > (SELECT ac.balance
											FROM accounts AS ac
											WHERE ac.id = account_id)) THEN ROLLBACK;
ELSE UPDATE accounts as ac 
SET ac.balance = ac.balance - money_amount
WHERE ac.id = account_id;
END IF;
END $$

-- 14

DELIMITER $$

CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, money_amount DECIMAL(19, 4))
BEGIN
START TRANSACTION;
IF ((money_amount <= 0 OR money_amount > (SELECT ac.balance
											FROM accounts AS ac
											WHERE ac.id = from_account_id)) 
OR (SELECT ac.id
	FROM accounts AS ac
    WHERE ac.id = from_account_id) IS NULL
    
OR (SELECT ac.id
	FROM accounts AS ac
	WHERE ac.id = to_account_id) IS NULL) THEN ROLLBACK;
    
ELSE UPDATE accounts AS ac
SET ac.balance = ac.balance - money_amount
WHERE ac.id = from_account_id;
UPDATE accounts AS ac
SET ac.balance = ac.balance + money_amount
WHERE ac.id = to_account_id;
END IF;
END $$

-- 15
DELIMITER ;

CREATE TABLE logs(
log_id INT PRIMARY KEY AUTO_INCREMENT,
account_id INT,
old_sum DECIMAL (19, 4),
new_sum DECIMAL (19, 4)
);

DELIMITER $$

CREATE TRIGGER tr_changed_balance
AFTER UPDATE
ON accounts
FOR EACH ROW 
BEGIN
INSERT INTO logs(account_id, old_sum, new_sum)
VALUES(OLD.id, OLD.balance, NEW.balance);
END $$

DELIMITER ;

CALL usp_transfer_money(2, 1, 20);

SELECT * FROM logs;

-- 16

CREATE TABLE notification_emails(
id INT PRIMARY KEY AUTO_INCREMENT,
recipient INT,
subject VARCHAR(100),
body VARCHAR(1000)
);

DELIMITER $$
CREATE TRIGGER tr_added_logs
AFTER INSERT
ON logs
FOR EACH ROW
BEGIN
INSERT INTO notification_emails(recipient, subject, body)
VALUES(NEW.account_id, concat('Balance change for account:', NEW.account_id), concat('On ', NOW(), ' your balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum));
END $$

SELECT * FROM notification_emails;