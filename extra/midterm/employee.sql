DROP TABLE employee_manager;
DROP TABLE employee;

CREATE TABLE employee(
  first_name   VARCHAR2(100) NOT NULL,
  last_name    VARCHAR2(100) NOT NULL,
  email        VARCHAR2(100) PRIMARY KEY,
  position     VARCHAR(100) NOT NULL,
  salary       DECIMAL NOT NULL,
  CONSTRAINT employee_email_format CHECK(email LIKE '%@%.%' AND email NOT LIKE '@%' AND email NOT LIKE '%@%@%'),
  CONSTRAINT positive_salary CHECK(salary > 0)
);

CREATE TABLE employee_manager (
  employee VARCHAR2(100) NOT NULL,
  manager VARCHAR2(100) NOT NULL,
  CONSTRAINT fk_employee FOREIGN KEY(employee) REFERENCES employee(email),
  CONSTRAINT fk_manager FOREIGN KEY(manager) REFERENCES employee(email)
);

INSERT INTO employee (first_name, last_name, email, position, salary) 
VALUES ('Alex', 'Nelson', 'alex.nelson@gwu.edu', 'Engineer', 50000.00);

INSERT INTO employee (first_name, last_name, email, position, salary) 
VALUES ('Brianna', 'Dunlap', 'brianna.dunlap@gwu.edu', 'Project Lead', 100000.00);

INSERT INTO employee (first_name, last_name, email, position, salary) 
VALUES ('Judith', 'Kirby', 'judith.kirby@gwu.edu', 'Engineer', 200000.00);

INSERT INTO employee (first_name, last_name, email, position, salary) 
VALUES ('Sheryl', 'Thomas', 'sheryl.thomas@gwu.edu', 'Engineer', 125000.000);


INSERT INTO employee_manager (employee, manager) VALUES('alex.nelson@gwu.edu', 'brianna.dunlap@gwu.edu');
INSERT INTO employee_manager (employee, manager) VALUES('judith.kirby@gwu.edu', 'brianna.dunlap@gwu.edu');
INSERT INTO employee_manager (employee, manager) VALUES('sheryl.thomas@gwu.edu', 'brianna.dunlap@gwu.edu');


MERGE INTO employee e
USING (
  SELECT a.email AS employee_email, a.salary AS employee_salary, 
    c.email AS manager_email, c.salary AS manager_salary
  FROM employee a, employee_manager b, employee c
  WHERE a.email = b.employee
    AND b.manager = c.email
    AND a.salary > c.salary
) m 
ON (e.email = m.employee_email)
WHEN MATCHED THEN UPDATE
  SET salary = m.manager_salary - m.manager_salary/10;

SELECT email, salary
FROM employee;


