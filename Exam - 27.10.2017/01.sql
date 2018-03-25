CREATE DATABASE report_service;

USE report_service;

CREATE TABLE users(
id INT(11) UNSIGNED,
username VARCHAR(30) NOT NULL,
password VARCHAR(50) NOT NULL,
name VARCHAR(50),
gender VARCHAR(1),
birthdate DATETIME,
age INT(11) UNSIGNED,
email VARCHAR(50) NOT NULL,
PRIMARY KEY (id),
UNIQUE (username)
);

CREATE TABLE departments(
id INT(11) UNSIGNED,
name VARCHAR(50) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE employees(
id INT(11) UNSIGNED,
first_name VARCHAR(25),
last_name VARCHAR(25),
gender VARCHAR(1),
birthdate DATETIME,
age INT(11) UNSIGNED,
department_id INT(11) UNSIGNED,
PRIMARY KEY (id),
FOREIGN KEY (department_id) REFERENCES departments (id)
);

CREATE TABLE categories(
id INT(11) UNSIGNED,
name VARCHAR(50) NOT NULL,
department_id INT(11) UNSIGNED,
PRIMARY KEY (id),
FOREIGN KEY (department_id) REFERENCES departments (id)
);

CREATE TABLE status(
id INT(11) UNSIGNED,
label VARCHAR(30) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE reports(
id INT(11) UNSIGNED,
category_id INT(11) UNSIGNED,
status_id INT(11) UNSIGNED,
open_date DATETIME,
close_date DATETIME,
description VARCHAR(200),
user_id INT(11) UNSIGNED,
employee_id INT(11) UNSIGNED,
PRIMARY KEY (id),
FOREIGN KEY (category_id) REFERENCES categories (id),
FOREIGN KEY (status_id) REFERENCES status (id),
FOREIGN KEY (user_id) REFERENCES users (id),
FOREIGN KEY (employee_id) REFERENCES employees (id)
);

