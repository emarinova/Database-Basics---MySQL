-- 15
DELIMITER $$

CREATE FUNCTION udf_get_radians(degrees FLOAT)
RETURNS FLOAT
BEGIN
DECLARE radians FLOAT;
SET radians := degrees * pi() / 180;
RETURN radians;
END $$

-- 16

DELIMITER $$

CREATE PROCEDURE udp_change_password(email VARCHAR(30), new_password VARCHAR(20))
BEGIN
START TRANSACTION;
IF email NOT IN (SELECT email FROM credentials)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The email does\'t exist!';
ROLLBACK;
ELSE UPDATE credentials
SET password = new_password
WHERE email = email;
COMMIT;
END IF;
END $$

-- 17

CREATE PROCEDURE udp_send_message(user_id INT, chat_id INT, content_msg VARCHAR(200))
BEGIN
START transaction;
IF user_id NOT IN (SELECT user_id FROM users_chats WHERE chat_id = chat_id)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'There is no chat with that user!';
ROLLBACK;
ELSE INSERT INTO messages(content, sent_on, chat_id, user_id)
		VALUES(content_msg, NOW(), chat_id, user_id);
        COMMIT;
END IF;
END $$

-- 18

CREATE TABLE messages_log (
id INT PRIMARY KEY,
content VARCHAR(200),
sent_on DATE,
chat_id INT,
user_id INT
)

DELIMITER $$

CREATE TRIGGER log_msgs
AFTER DELETE
ON messages
FOR EACH ROW
BEGIN
INSERT INTO messages_log(id, content, sent_on, chat_id, user_id)
VALUES(OLD.id, OLD.content, OLD.sent_on, OLD.chat_id, OLD.user_id);
END $$

-- 19

CREATE TRIGGER delete_from_users
BEFORE DELETE 
ON users
FOR EACH ROW
BEGIN
DELETE FROM messages
WHERE user_id = OLD.id;
DELETE FROM users_chats
WHERE user_id = OLD.id;
END $$