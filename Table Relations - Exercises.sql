-- 1

CREATE DATABASE test;
USE test;

CREATE TABLE persons(
person_id INT NOT NULL,
first_name VARCHAR(30) NOT NULL,
salary DECIMAL(7,2) NOT NULL,
passport_id INT NOT NULL
);

CREATE TABLE passports(
passport_id INT NOT NULL,
passport_number VARCHAR(20) NOT NULL
);

INSERT INTO persons
VALUES(1, 'Roberto', 43300, 102),
(2, 'Tom', 56100, 103),
(3, 'Yana', 60200, 101);

INSERT INTO passports
Values(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

ALTER TABLE persons
ADD CONSTRAINT PK_persons PRIMARY KEY (person_id);

ALTER TABLE passports
ADD CONSTRAINT PK_passports PRIMARY KEY (passport_id);

ALTER TABLE persons
ADD CONSTRAINT FK_persons FOREIGN KEY (passport_id) REFERENCES passports(passport_id);

ALTER TABLE persons
ADD UNIQUE (passport_id);

-- 2

CREATE TABLE manufacturers(
manufacturer_id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL,
established_on DATE NOT NULL
);

CREATE TABLE models(
model_id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL,
manufacturer_id INT,
FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);

ALTER TABLE models
AUTO_INCREMENT = 101;

INSERT INTO manufacturers(`name`, established_on)
VALUES('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

INSERT INTO models(`name`, manufacturer_id)
VALUES('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3);

-- 3

CREATE TABLE students(
student_id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
);

CREATE TABLE exams(
exam_id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
);

ALTER TABLE exams
AUTO_INCREMENT = 101;

CREATE TABLE students_exams(
student_id INT,
exam_id INT,
PRIMARY KEY (student_id, exam_id),
FOREIGN KEY (student_id) REFERENCES students (student_id),
FOREIGN KEY (exam_id) REFERENCES exams (exam_id)
);

INSERT INTO students(`name`)
VALUES('Mila'),
('Toni'),
('Ron');

INSERT INTO exams(`name`)
VALUES('Spring MVC'),
('Neo4j'),
('Oracle 11g');

INSERT INTO students_exams
VALUES(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);

-- 4

CREATE TABLE teachers(
teacher_id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL,
manager_id INT,
FOREIGN KEY (manager_id) REFERENCES teachers(teacher_id)
);

ALTER TABLE teachers
AUTO_INCREMENT = 101;

INSERT INTO teachers(`name`)
VALUES('John'),
('Maya'),
('Silvia'),
('Ted'),
('Mark'),
('Greta');

UPDATE teachers
SET manager_id = 106
WHERE teacher_id = 102 OR teacher_id = 103;

UPDATE teachers
SET manager_id = 105
WHERE teacher_id = 104;

UPDATE teachers
SET manager_id = 101
WHERE teacher_id = 105 OR teacher_id = 106;

-- 5

CREATE DATABASE test2;
USE test2;

CREATE TABLE item_types(
item_type_id INT(11) PRIMARY KEY,
`name` VARCHAR(50)
);

CREATE TABLE items(
item_id INT(11) PRIMARY KEY,
`name` VARCHAR(50),
item_type_id INT(11),
FOREIGN KEY (item_type_id) REFERENCES item_types(item_type_id)
);

CREATE TABLE cities(
city_id INT(11) PRIMARY KEY,
`name` VARCHAR(50)
);

CREATE TABLE customers(
customer_id INT(11) PRIMARY KEY,
`name` VARCHAR(50),
birthday DATE,
city_id INT(11),
FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

CREATE TABLE orders(
order_id INT(11) PRIMARY KEY,
customer_id INT(11),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items(
order_id INT(11),
item_id INT(11),
PRIMARY KEY (order_id, item_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- 	6

CREATE DATABASE test3;
USE test3;

CREATE TABLE subjects(
subject_id INT(11) PRIMARY KEY,
subject_name VARCHAR(50)
);

CREATE TABLE majors(
major_id INT(11) PRIMARY KEY,
`name` VARCHAR(50)
);

CREATE TABLE students(
student_id INT(11) PRIMARY KEY,
student_number VARCHAR(12),
student_name VARCHAR(50),
major_id INT(11),
FOREIGN KEY (major_id) REFERENCES majors(major_id)
);

CREATE TABLE agenda(
student_id INT(11),
subject_id INT(11),
PRIMARY KEY(student_id, subject_id),
FOREIGN KEY(student_id) REFERENCES students(student_id),
FOREIGN KEY(subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE payments(
payment_id INT(11) PRIMARY KEY,
payment_date DATE,
payment_amount DECIMAL(8, 2),
student_id INT(11),
FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- 9

USE geography;

SELECT m.mountain_range, p.peak_name, p.elevation as peak_elevation
FROM mountains as m JOIN peaks as p 
ON m.id = p.mountain_id
WHERE m.mountain_range = 'Rila'
ORDER BY peak_elevation DESC;