DROP TABLE employee;
DROP TABLE department;

CREATE TABLE department (
  name VARCHAR(100) PRIMARY KEY,
  headquarters VARCHAR(360)
);

CREATE TABLE employee(
  first_name   VARCHAR2(100) NOT NULL,
  last_name    VARCHAR2(100) NOT NULL,
  email        VARCHAR2(100) PRIMARY KEY,
  department   VARCHAR2(100) NOT NULL,
  CONSTRAINT employee_email_format CHECK(email LIKE '%@%.%' AND email NOT LIKE '@%' AND email NOT LIKE '%@%@%'),
  CONSTRAINT fk_department FOREIGN KEY(department) REFERENCES department(name)
);

INSERT INTO department (name, headquarters) VALUES('DEP10', 'Virginia');
INSERT INTO department (name, headquarters) VALUES('DEP20', 'Arizona');
INSERT INTO department (name, headquarters) VALUES('DEP30', 'Washington D.C.');

INSERT INTO employee (first_name, last_name, email, department) 
VALUES ('Alex', 'Nelson', 'alex.nelson@gwu.edu', 'DEP20');

INSERT INTO employee (first_name, last_name, email, department) 
VALUES ('Brianna', 'Dunlap', 'brianna.dunlap@gwu.edu', 'DEP20');

INSERT INTO employee (first_name, last_name, email, department) 
VALUES ('Judith', 'Kirby', 'judith.kirby@gwu.edu', 'DEP20');

INSERT INTO employee (first_name, last_name, email, department) 
VALUES ('Sheryl', 'Thomas', 'sheryl.thomas@gwu.edu', 'DEP20');

INSERT INTO employee (first_name, last_name, email, department) 
VALUES ('Mike', 'Frank', 'mike.frank@gwu.edu', 'DEP20');

CREATE VIEW dep20 AS
SELECT first_name, last_name, email, department, headquarters
FROM employee NATURAL JOIN department
WHERE department = 'DEP20';

CREATE MATERIALIZED VIEW dep20_mat AS
SELECT first_name, last_name, email, department, headquarters
FROM employee NATURAL JOIN department
WHERE department = 'DEP20';

SELECT first_name, department, headquarters
FROM dep20;

SELECT first_name, department, headquarters
FROM dep20_mat;
