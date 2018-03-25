-- 2

INSERT INTO messages(content, sent_on, chat_id, user_id)
SELECT concat(u.age, '-', u.gender, '-', l.latitude, '-', l.longitude), NOW(), 
CASE
WHEN u.gender = 'F' THEN ceil(sqrt(u.age * 2))
WHEN u.gender = 'M' THEN ceil(power(u.age/18,3))
END AS chat_id, u.id
FROM users AS u JOIN locations AS l ON u.location_id = l.id
WHERE u.id BETWEEN 10 AND 20;

-- 3

UPDATE chats AS ch JOIN messages AS m ON ch.id = m.chat_id
SET ch.start_date = m.sent_on
WHERE m.sent_on < ch.start_date;

-- 4

DELETE FROM locations 
WHERE id NOT IN (SELECT DISTINCT location_id FROM users
					WHERE location_id IS NOT NULL);