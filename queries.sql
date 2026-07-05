/*=========================================================
  queries.sql
  University Database Management System
  Task 1.3 – Task 1.5
=========================================================*/

---------------------------------------------------------
-- Task 1.3(a)
-- Insert Data
---------------------------------------------------------

-- Advisors

INSERT INTO Advisors VALUES
(1,'Dr. Mehta','mehta@university.edu');

INSERT INTO Advisors VALUES
(2,'Dr. Sharma','sharma@university.edu');

---------------------------------------------------------

-- Instructors

INSERT INTO Instructors VALUES
(101,'Prof. Gupta','gupta@university.edu');

INSERT INTO Instructors VALUES
(102,'Prof. Patel','patel@university.edu');

---------------------------------------------------------

-- Courses

INSERT INTO Courses VALUES
('CS101','Database Management Systems',101);

INSERT INTO Courses VALUES
('CS202','Operating Systems',102);

INSERT INTO Courses VALUES
('CS303','Computer Networks',101);

INSERT INTO Courses VALUES
('CS404','Artificial Intelligence',102);

---------------------------------------------------------

-- Students

INSERT INTO Students VALUES
(1,'Rahul','Computer Science',1,2024);

INSERT INTO Students VALUES
(2,'Priya','Computer Science',2,2025);

INSERT INTO Students VALUES
(3,'Amit','Information Technology',1,2024);

---------------------------------------------------------

-- Enrollments

INSERT INTO Enrollments VALUES
(1,'CS101',82);

INSERT INTO Enrollments VALUES
(1,'CS202',75);

INSERT INTO Enrollments VALUES
(2,'CS101',68);

INSERT INTO Enrollments VALUES
(2,'CS303',92);

INSERT INTO Enrollments VALUES
(3,'CS202',30);

---------------------------------------------------------
-- Task 1.3(b)
-- Update Instructor Email
---------------------------------------------------------

UPDATE Instructors
SET instructor_email='newgupta@university.edu'
WHERE instructor_id=101;

---------------------------------------------------------
-- Task 1.3(c)
-- Delete Enrollment Records
-- Students scoring below 35
---------------------------------------------------------

DELETE FROM Enrollments
WHERE marks_obtained < 35;

---------------------------------------------------------
-- Task 1.3(d)
-- Delete all rows from old flat table
---------------------------------------------------------

/*
DELETE is preferred because it is transactional and can
be rolled back in all major databases.

TRUNCATE behaves differently across databases.
MySQL treats TRUNCATE as DDL and auto-commits,
whereas PostgreSQL allows rollback.

Therefore DELETE is the safest cross-database choice.
*/

DELETE FROM StudentRecords;

---------------------------------------------------------
-- Task 1.4(a)
-- IN Operator
---------------------------------------------------------

SELECT
s.student_name,
c.course_name
FROM Students s
JOIN Enrollments e
ON s.student_id=e.student_id
JOIN Courses c
ON e.course_code=c.course_code
WHERE c.course_code IN ('CS101','CS202','CS303');

---------------------------------------------------------
-- Task 1.4(b)
-- BETWEEN and IS NOT NULL
---------------------------------------------------------

SELECT
s.student_name,
e.marks_obtained,
a.advisor_email
FROM Students s
JOIN Advisors a
ON s.advisor_id=a.advisor_id
JOIN Enrollments e
ON s.student_id=e.student_id
WHERE e.marks_obtained BETWEEN 60 AND 85
AND a.advisor_email IS NOT NULL;

---------------------------------------------------------
-- Task 1.4(c)
-- GROUP BY and HAVING
---------------------------------------------------------

SELECT
s.department,
AVG(e.marks_obtained) AS AverageMarks,
MIN(e.marks_obtained) AS MinimumMarks,
MAX(e.marks_obtained) AS MaximumMarks
FROM Students s
JOIN Enrollments e
ON s.student_id=e.student_id
GROUP BY s.department
HAVING AVG(e.marks_obtained) > 55;

---------------------------------------------------------
-- Task 1.4(d)
-- INNER JOIN
---------------------------------------------------------

SELECT
s.student_name,
c.course_name,
e.marks_obtained
FROM Students s
INNER JOIN Enrollments e
ON s.student_id=e.student_id
INNER JOIN Courses c
ON e.course_code=c.course_code;

---------------------------------------------------------
-- LEFT JOIN
---------------------------------------------------------

SELECT
s.student_name,
c.course_name,
e.marks_obtained
FROM Students s
LEFT JOIN Enrollments e
ON s.student_id=e.student_id
LEFT JOIN Courses c
ON e.course_code=c.course_code;

---------------------------------------------------------
-- Task 1.4(e)
-- Correlated Subquery
---------------------------------------------------------

SELECT
s.student_name,
e.marks_obtained
FROM Students s
JOIN Enrollments e
ON s.student_id=e.student_id
WHERE e.marks_obtained >
(
SELECT AVG(e2.marks_obtained)
FROM Students s2
JOIN Enrollments e2
ON s2.student_id=e2.student_id
WHERE s2.department=s.department
);

---------------------------------------------------------
-- Task 1.4(f)
-- EXCEPT Operator
---------------------------------------------------------

SELECT student_id
FROM Students
WHERE enrollment_year=2024

EXCEPT

SELECT student_id
FROM Students
WHERE enrollment_year=2025;

---------------------------------------------------------
-- Task 1.4(g)
-- Second Highest Marks in each Department
---------------------------------------------------------

SELECT
s.student_name,
s.department,
e.marks_obtained
FROM Students s
JOIN Enrollments e
ON s.student_id=e.student_id
WHERE 1=
(
SELECT COUNT(DISTINCT e2.marks_obtained)
FROM Students s2
JOIN Enrollments e2
ON s2.student_id=e2.student_id
WHERE s2.department=s.department
AND e2.marks_obtained>e.marks_obtained
);

---------------------------------------------------------
-- Task 1.4(h)
-- Window Functions
---------------------------------------------------------

SELECT

s.student_name,

s.department,

e.marks_obtained,

ROW_NUMBER() OVER(
PARTITION BY s.department
ORDER BY e.marks_obtained DESC
) AS Row_Number,

RANK() OVER(
PARTITION BY s.department
ORDER BY e.marks_obtained DESC
) AS Rank_Value,

DENSE_RANK() OVER(
PARTITION BY s.department
ORDER BY e.marks_obtained DESC
) AS Dense_Rank

FROM Students s
JOIN Enrollments e
ON s.student_id=e.student_id;

---------------------------------------------------------
-- Task 1.5(a)
-- Transaction
---------------------------------------------------------

BEGIN;

DELETE FROM Enrollments
WHERE student_id=1
AND course_code='CS101';

INSERT INTO Enrollments
VALUES
(1,'CS404',0);

COMMIT;

/*
If the INSERT fails, execute:

ROLLBACK;

to undo the DELETE.
*/

---------------------------------------------------------
-- Task 1.5(b)
-- Non-Repeatable Read
---------------------------------------------------------

/*
Anomaly:
Non-Repeatable Read

Minimum Isolation Level:
REPEATABLE READ
*/

---------------------------------------------------------
-- Task 1.5(c)
-- Course Capacity Problem
---------------------------------------------------------

/*
Anomaly:
Write Skew / Lost Update

Isolation Level:
SERIALIZABLE
*/

---------------------------------------------------------
-- Task 1.5(d)
-- MVCC
---------------------------------------------------------

/*
With MVCC under REPEATABLE READ,
the reporting transaction continues
to read the original version of the row
even after another transaction commits
an update.

This happens because MVCC provides
a consistent snapshot of the database.

Trade-off:
More storage for row versions and
reduced concurrency compared to
READ COMMITTED.
*/

---------------------------------------------------------
-- End of queries.sql
---------------------------------------------------------
