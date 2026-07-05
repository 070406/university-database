Part 1 — Relational Database Design and SQL Querying (30 marks)
The university's existing spreadsheet-based system stores student data in a single flat table:

StudentRecords(student_id, student_name, department, advisor_name, advisor_email,
               course_code, course_name, instructor_name, instructor_email,
               enrollment_year, marks_obtained)
This table suffers from data anomalies: updating an advisor's email requires changing multiple rows, deleting a student removes course information, and inserting a course requires a student to already exist.

Tasks
Task 1.1 — Normalization (6 marks)

a. Identify all partial dependencies and transitive dependencies present in the StudentRecords table. Assume the composite key is (student_id, course_code) and that advisor_name → advisor_email, instructor_name → instructor_email, and course_code → course_name, instructor_name, instructor_email.

b. Decompose StudentRecords into a set of tables that satisfies Boyce-Codd Normal Form (BCNF). For each table you produce, state its primary key, any foreign keys, and which dependency or anomaly it resolves.

c. Identify whether your final set of tables violates any of the four data integrity types (entity integrity, referential integrity, domain integrity, user-defined integrity). For each type, state whether it is satisfied or violated and why.

Task 1.2 — Schema Implementation (4 marks)

Write a complete SQL script (schema.sql) that:

Creates all tables from your BCNF decomposition using CREATE TABLE statements.
Declares primary keys and foreign keys explicitly.
Sets appropriate data types (use INT, VARCHAR, DECIMAL as needed).
Uses DEFAULT values where reasonable (e.g., enrollment_year defaulting to the current year is acceptable as a constant).
Task 1.3 — Data Manipulation (4 marks)

Write SQL DML statements (queries.sql) to:

a. Insert at least three students, two courses, and two advisors into your normalized tables.

b. Update the email address of one instructor using an UPDATE statement that targets exactly one row via its primary key.

c. Delete all enrollment records for students whose marks_obtained is below 35, without deleting the student or course records themselves.

d. Write a DELETE statement (without a WHERE clause) that removes all rows from the StudentRecords table (the old flat table, before normalization). In a code comment, explain why DELETE is safer for transaction-controlled bulk removal: it is a DML statement that respects BEGIN/ROLLBACK in all major databases, whereas TRUNCATE behaviour varies by engine — in MySQL, TRUNCATE is treated as DDL and implicitly commits any open transaction, making it non-rollback-safe; in PostgreSQL, TRUNCATE is transactional and can be rolled back. The safest cross-database choice for a bulk removal inside a transaction is DELETE.

Task 1.4 — Advanced Querying (11 marks)

Write the following SQL queries in queries.sql:

a. Retrieve the student_name and course_name of all students who are enrolled in courses with a course code in the set ('CS101', 'CS202', 'CS303'). Use the IN operator.

b. Retrieve all students whose marks_obtained is between 60 and 85 (inclusive) and whose advisor_email is not null. Use BETWEEN and IS NOT NULL.

c. For each department, compute the average, minimum, and maximum marks_obtained. Return only departments where the average marks exceed 55. Use GROUP BY and HAVING.

d. Using an INNER JOIN, retrieve the student_name, course_name, and marks_obtained for all enrolled students. Then write a second query using a LEFT JOIN from the students table to the enrollments table so that students with no enrolled courses also appear (their course_name should be NULL).

e. Write a correlated subquery that retrieves the student_name and marks_obtained for students who scored higher than the average marks in their own department.

f. Find all student_id values that appear in the 2024 enrollment records but not in the 2025 enrollment records. Use a set operation (EXCEPT).

g. Write a correlated subquery that, for each department, retrieves the student_name and marks_obtained of the student who scored the second-highest marks in that department — i.e., higher than all students in that department except the one with the top score. Departments with only one student should not appear in the result.

h. Using window functions, write a query that assigns each student a rank within their own department based on marks_obtained (highest first). Use ROW_NUMBER(), RANK(), and DENSE_RANK() in the same query and display all three values side by side so the difference between them is visible when two students in the same department have equal marks.

Task 1.5 — Transactions and Isolation (5 marks)

a. Write a transaction (using BEGIN, COMMIT, and ROLLBACK) that transfers a student from one course to another: it deletes the student's current enrollment in CS101 and inserts a new enrollment in CS404. The transaction must roll back if the insert fails.

b. A second transaction reads a student's marks_obtained, a third transaction then updates that value before the first transaction commits, and the first transaction reads the value again — getting a different result. Name this concurrency anomaly and state which isolation level, at minimum, prevents it.

c. Two concurrent transactions both read the same enrollment count for a course and both decide the course has room; both insert a new enrollment, exceeding the course capacity. Name this anomaly and state which isolation level prevents it.

d. The database uses Multi-Version Concurrency Control (MVCC). A reporting transaction begins and reads a student's marks_obtained. A concurrent write transaction then updates that student's marks and commits. Explain what value the reporting transaction sees if it re-reads the same row after the write commits — and why MVCC produces this result. Name the isolation level that guarantees the reporting transaction sees a consistent snapshot of the database throughout its lifetime, and state one trade-off of operating at that isolation level compared to a lower one.

Acceptance Criteria
schema.sql executes without errors on a standard SQL engine (PostgreSQL or MySQL syntax is acceptable).
All tables are in BCNF; the normalization walkthrough explicitly names each dependency resolved.
All queries in queries.sql are syntactically complete and logically correct for the stated scenario.
The transaction in Task 1.5a includes explicit BEGIN, COMMIT, and a ROLLBACK branch.
The concurrency anomalies in Tasks 1.5b and 1.5c are named correctly and matched to the right isolation levels.
The correlated subquery in Task 1.4g correctly identifies the second-highest scorer per department and excludes single-student departments.
Task 1.5d correctly explains the MVCC read behaviour, names the correct isolation level that provides a consistent snapshot, and states one trade-off of that level.
Submission
Submit a public GitHub repository link. The repository must contain:

schema.sql — all CREATE TABLE statements with constraints.
queries.sql — all DML and DQL statements from Tasks 1.2–1.5, and the correlated subquery + window-function queries from Tasks 1.4g–h and the concurrency proposal from Task 1.5d.
README.md — a written explanation of the normalization steps (Task 1.1), your design decisions for data types and constraints, and the transaction analysis from Task 1.5. The README must be plain text and not refer to any external lectures, discussions, or instructors.
