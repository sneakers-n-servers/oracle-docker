DROP TABLE enrolls;
DROP TABLE teaches;
DROP TABLE teacher; 
DROP TABLE course;
DROP TABLE student;

CREATE TABLE student(
  name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE course(
  name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE teacher (
  name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE teaches (
  semester INT NOT NULL,
  year INT NOT NULL,
  teacher_name VARCHAR(255) NOT NULL,
  course VARCHAR(255) NOT NULL,
  CONSTRAINT teaches_pk PRIMARY KEY(semester, year, course, teacher_name),
  CONSTRAINT teaches_fk FOREIGN KEY(teacher_name) REFERENCES teacher(name),
  CONSTRAINT course_teaches_fk FOREIGN KEY(course) REFERENCES course(name)
);

CREATE TABLE enrolls (
  grade VARCHAR(2) NOT NULL,
  semester INT NOT NULL,
  year INT NOT NULL,
  student_name VARCHAR(255) NOT NULL,
  course VARCHAR(255) NOT NULL,
  CONSTRAINT enrolls_pk PRIMARY KEY(semester, year, course, student_name), 
  CONSTRAINT enrolls_fk FOREIGN KEY(student_name) REFERENCES student(name),
  CONSTRAINT course_entrolls_fk FOREIGN KEY(course) REFERENCES course(name)
);

INSERT INTO student VALUES('joe');
INSERT INTO student VALUES('jeff');
INSERT INTO student VALUES('bob');
INSERT INTO student VALUES('steve');
INSERT INTO student VALUES('john');
INSERT INTO student VALUES('mike');
INSERT INTO student VALUES('dave');
INSERT INTO student VALUES('will');
INSERT INTO student VALUES('alex');
INSERT INTO student VALUES('matt');

INSERT INTO teacher VALUES('tori');
INSERT INTO teacher VALUES('bey');
INSERT INTO teacher VALUES('lany');
INSERT INTO teacher VALUES('macy');
INSERT INTO teacher VALUES('kristen');
INSERT INTO teacher VALUES('holly');
INSERT INTO teacher VALUES('lisa');
INSERT INTO teacher VALUES('amy');
INSERT INTO teacher VALUES('allison');
INSERT INTO teacher VALUES('ray');

INSERT INTO course VALUES('geography');
INSERT INTO course VALUES('finance');
INSERT INTO course VALUES('art');
INSERT INTO course VALUES('history');
INSERT INTO course VALUES('biology');
INSERT INTO course VALUES('astronomy');
INSERT INTO course VALUES('computers');
INSERT INTO course VALUES('literature');
INSERT INTO course VALUES('science');
INSERT INTO course VALUES('math');

INSERT INTO enrolls VALUES('A+', 1, 2021, 'joe', 'geography');  
INSERT INTO enrolls VALUES('B+', 1, 2021, 'joe', 'art');  
INSERT INTO enrolls VALUES('C+', 1, 2021, 'joe', 'math');  
INSERT INTO enrolls VALUES('D+', 1, 2021, 'joe', 'history');  

INSERT INTO enrolls VALUES('A+', 1, 2021, 'will', 'geography');  
INSERT INTO enrolls VALUES('B+', 1, 2021, 'will', 'art');  
INSERT INTO enrolls VALUES('C+', 1, 2021, 'will', 'math');  
INSERT INTO enrolls VALUES('D+', 1, 2021, 'will', 'history'); 

INSERT INTO teaches VALUES(1, 2021, 'tori', 'geography');  
INSERT INTO teaches VALUES(1, 2021, 'tori', 'art');  
INSERT INTO teaches VALUES(1, 2021, 'tori', 'math');  
INSERT INTO teaches VALUES(1, 2021, 'tori', 'history'); 

INSERT INTO teaches VALUES(1, 2021, 'lisa', 'geography');  
INSERT INTO teaches VALUES(1, 2021, 'lisa', 'art');  
INSERT INTO teaches VALUES(1, 2021, 'lisa', 'math');  
INSERT INTO teaches VALUES(1, 2021, 'lisa', 'history');


SELECT grade
FROM student NATURAL JOIN enrolls
WHERE student.name = 'joe';

SELECT grade
FROM student NATURAL JOIN enrolls
WHERE year = 2021 AND semester = 1;

SELECT grade
FROM student NATURAL JOIN enrolls
WHERE course = 'geography';

SELECT grade
FROM teacher NATURAL JOIN teaches NATURAL JOIN course NATURAL JOIN enrolls
WHERE teacher_name = 'tori';

 
