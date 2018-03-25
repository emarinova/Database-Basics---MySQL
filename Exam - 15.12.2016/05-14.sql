-- 5

SELECT nickname, gender, age
FROM users
WHERE age BETWEEN 22 AND 37;

-- 6

SELECT content, sent_on
FROM messages
WHERE sent_on > '2014-05-12'
AND content LIKE '%just%'
ORDER BY id DESC;

-- 7

SELECT title, is_active
FROM chats
WHERE (is_active = 0 AND char_length(title) < 5) 
OR title REGEXP '.{2}tl.*'
ORDER BY title DESC;

-- 8

SELECT ch.id, ch.title, m.id
FROM chats AS ch JOIN messages AS m ON ch.id = m.chat_id
WHERE m.sent_on < '2012-03-26'
AND ch.title LIKE '%x'
ORDER BY ch.id, m.id;

-- 9

SELECT ch.id, COUNT(m.id) AS total_messages
FROM chats AS ch RIGHT JOIN messages AS m ON ch.id = m.chat_id
WHERE m.id < 90 
GROUP BY ch.id
ORDER BY total_messages DESC, ch.id
LIMIT 5;

-- 10

SELECT u.nickname, c.email, c.password
FROM credentials AS c JOIN users AS u ON c.id = u.credential_id
WHERE c.email LIKE '%co.uk'
ORDER BY c.email;

-- 11 

SELECT id, nickname, age
FROM users
WHERE location_id IS NULL ;

-- 12


SELECT m.id, m.chat_id, m.user_id
FROM messages AS m JOIN users_chats AS uc ON m.chat_id = uc.chat_id AND m.user_id != uc.user_id
WHERE uc.user_id IS NOT NULL
AND m.chat_id = 17
ORDER BY m.id DESC;

-- 13

SELECT u.nickname, ch.title, l.latitude, l.longitude
FROM users AS u JOIN locations AS l ON u.location_id = l.id
JOIN users_chats AS uc ON uc.user_id = u.id
JOIN chats AS ch ON ch.id = uc.chat_id
WHERE l.latitude BETWEEN 41.44 AND 44.13
AND l.longitude BETWEEN 22.21 AND 28.36
ORDER BY ch.title;

-- 14

SELECT ch.title, m.content
FROM chats AS ch LEFT JOIN messages AS m ON ch.id = m.chat_id
WHERE ch.start_date = ( SELECT MAX(start_date) 
						FROM chats );