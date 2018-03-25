CREATE DATABASE buhtig;

USE buhtig;

-- 1

CREATE TABLE users(
id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) UNIQUE NOT NULL,
password VARCHAR(30) NOT NULL,
email VARCHAR(50) NOT NULL
);

CREATE TABLE repositories(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE repositories_contributors(
repository_id INT,
contributor_id INT,
FOREIGN KEY(repository_id) REFERENCES repositories(id),
FOREIGN KEY(contributor_id) REFERENCES users(id)
);

CREATE TABLE issues(
id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(255) NOT NULL,
issue_status VARCHAR(6) NOT NULL,
repository_id INT NOT NULL,
assignee_id INT NOT NULL,
FOREIGN KEY(repository_id) REFERENCES repositories(id),
FOREIGN KEY(assignee_id) REFERENCES users(id)
);

CREATE TABLE commits(
id INT PRIMARY KEY AUTO_INCREMENT,
message VARCHAR(255) NOT NULL,
issue_id INT,
repository_id INT NOT NULL,
contributor_id INT NOT NULL,
FOREIGN KEY(issue_id) REFERENCES issues(id),
FOREIGN KEY(repository_id) REFERENCES repositories(id),
FOREIGN KEY(contributor_id) REFERENCES users(id)
);

CREATE TABLE files(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
size DECIMAL(10,2) NOT NULL,
parent_id INT,
commit_id INT NOT NULL,
FOREIGN KEY(parent_id) REFERENCES files(id),
FOREIGN KEY(commit_id) REFERENCES commits(id)
);

-- 2

INSERT INTO issues(title, issue_status, repository_id, assignee_id)
SELECT CONCAT('Critical Problem With ', f.name, '!'), 'open', CEIL((f.id * 2)/3), c.contributor_id
FROM files AS f JOIN commits AS c ON f.commit_id = c.id
WHERE f.id BETWEEN 46 AND 50;

-- 3

UPDATE repositories_contributors 
SET repository_id = ( SELECT MIN(temp.r_id) FROM (SELECT rc.contributor_id AS cnt_id, rc.repository_id AS rep_id, r.id AS r_id
			FROM repositories_contributors AS rc RIGHT JOIN repositories AS r ON r.id = rc.repository_id) AS temp WHERE temp.rep_id IS NULL) 
WHERE repository_id = contributor_id;

-- 4

DELETE FROM repositories 
WHERE id NOT IN (SELECT repository_id FROM issues);

-- 5

SELECT id, username
FROM users
ORDER BY id;

-- 6

SELECT repository_id, contributor_id
FROM repositories_contributors
WHERE repository_id = contributor_id
ORDER BY repository_id;

-- 7

SELECT id, name, size
FROM files
WHERE size > 1000
AND name LIKE '%html%'
ORDER BY size DESC;

-- 8

SELECT i.id, CONCAT(u.username, ' : ', i.title) AS issue_assigned
FROM issues AS i JOIN users AS u ON i.assignee_id = u.id
ORDER BY i.id DESC;

-- 9 

SELECT id, name, CONCAT(size, 'KB') AS size
FROM files
WHERE id NOT IN (SELECT DISTINCT parent_id FROM files WHERE parent_id IS NOT NULL)
ORDER BY id;

-- 10

SELECT r.id, r.name, COUNT(i.id) AS issues 
FROM repositories AS r LEFT JOIN issues AS i ON r.id = i.repository_id
GROUP BY r.id
ORDER BY issues DESC, r.id
LIMIT 5;

-- 11

SELECT temp.id, temp.name, count(c.id) AS commits, temp.contributors AS contributors
FROM
(SELECT r.id, r.name, count(rc.contributor_id) AS contributors
FROM repositories AS r 
JOIN repositories_contributors AS rc ON rc.repository_id = r.id
GROUP BY r.id)  AS temp
LEFT JOIN commits AS c ON temp.id = c.repository_id
GROUP BY temp.id
ORDER BY contributors DESC, temp.id
LIMIT 1;

-- 12

SELECT u.id, u.username, COUNT(c.id) AS commits
FROM users AS u LEFT JOIN issues AS i ON u.id = i.assignee_id 
LEFT JOIN commits AS c ON (c.issue_id = i.id AND c.contributor_id = i.assignee_id)
GROUP BY u.id
ORDER BY commits DESC, u.id;

-- 13

SELECT SUBSTRING(f.name, 1, LOCATE('.', f.name)-1) AS name, (SELECT COUNT(c.message) FROM commits AS c WHERE c.message IS NOT NULL AND LOCATE(f.name, c.message) > 0) AS recursive_count
FROM files AS f 
INNER JOIN files AS f2 ON (f.parent_id = f2.id AND f.id = f2.parent_id AND f.id != f.parent_id)
ORDER BY f.name;

-- 14

SELECT r.id, r.name, COUNT(DISTINCT c.contributor_id) AS users
FROM repositories AS r LEFT JOIN commits AS c ON r.id = c.repository_id
GROUP BY r.id
ORDER BY users DESC, r.id;

-- 15

DELIMITER $$

CREATE PROCEDURE udp_commit(username VARCHAR(30), password VARCHAR(30), message VARCHAR(255), issue_id INT)
BEGIN
START TRANSACTION;
IF username NOT IN (SELECT username FROM users)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No such user!';
ROLLBACK;
ELSEIF password != (SELECT u.password FROM users AS u WHERE u.username = username)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password is incorrect!';
ROLLBACK;
ELSEIF issue_id NOT IN (SELECT id FROM issues)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The issue does not exist!';
ROLLBACK;
ELSE INSERT INTO commits(message, issue_id, repository_id, contributor_id)
VALUES(message, issue_id, (SELECT repository_id FROM issues WHERE id = issue_id),(SELECT u.id FROM users AS u WHERE u.username = username));
COMMIT;
END IF;
END $$

-- 16
DELIMITER $$
CREATE PROCEDURE udp_findbyextension(extension VARCHAR(10))
BEGIN
SELECT f.id, f.name, CONCAT(f.size, 'KB') AS size
FROM files AS f
WHERE f.name LIKE CONCAT('%', extension)
ORDER BY f.id;
END $$

CALL udp_findbyextension('html');