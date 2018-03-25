CREATE DATABASE closed_judge_system;

USE closed_judge_system;

CREATE TABLE users(
id INT(11),
username VARCHAR(30) UNIQUE NOT NULL,
password VARCHAR(30) NOT NULL,
email VARCHAR(50),
PRIMARY KEY(id)
);

CREATE TABLE categories(
id INT(11),
name VARCHAR(50) NOT NULL,
parent_id INT(11),
PRIMARY KEY(id),
FOREIGN KEY(parent_id) REFERENCES categories(id)
);

CREATE TABLE contests(
id INT(11),
name VARCHAR(50) NOT NULL,
category_id INT(11),
PRIMARY KEY(id),
FOREIGN KEY(category_id) REFERENCES categories(id)
);

CREATE TABLE problems(
id INT(11),
name VARCHAR(100) NOT NULL,
points INT(11) NOT NULL,
tests INT(11) DEFAULT 0,
contest_id int(11),
PRIMARY KEY(id),
FOREIGN KEY(contest_id) REFERENCES contests(id)
);



CREATE TABLE submissions(
id INT(11) AUTO_INCREMENT,
passed_tests INT(11) NOT NULL,
problem_id INT(11),
user_id INT(11),
PRIMARY KEY (id),
FOREIGN KEY(problem_id) REFERENCES problems(id),
FOREIGN KEY(user_id) REFERENCES users(id)
);


CREATE TABLE users_contests(
user_id INT(11),
contest_id INT(11),
CONSTRAINT pk_kfsfsj PRIMARY KEY(user_id, contest_id),
CONSTRAINT fk_fhshfsj FOREIGN KEY(user_id) REFERENCES users(id),
CONSTRAINT fk_ffhfh FOREIGN KEY(contest_id) REFERENCES contests(id)
);

