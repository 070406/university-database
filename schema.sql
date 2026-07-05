/*=========================================================
  schema.sql
  University Database Management System
  BCNF Normalized Database Schema
=========================================================*/

-- Drop tables if they already exist (optional)
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Advisors;
DROP TABLE IF EXISTS Instructors;

---------------------------------------------------------
-- Advisors Table
---------------------------------------------------------

CREATE TABLE Advisors (
    advisor_id INT PRIMARY KEY,
    advisor_name VARCHAR(100) NOT NULL,
    advisor_email VARCHAR(100) UNIQUE NOT NULL
);

---------------------------------------------------------
-- Instructors Table
---------------------------------------------------------

CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY,
    instructor_name VARCHAR(100) NOT NULL,
    instructor_email VARCHAR(100) UNIQUE NOT NULL
);

---------------------------------------------------------
-- Courses Table
---------------------------------------------------------

CREATE TABLE Courses (
    course_code VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    instructor_id INT NOT NULL,

    FOREIGN KEY (instructor_id)
        REFERENCES Instructors(instructor_id)
);

---------------------------------------------------------
-- Students Table
---------------------------------------------------------

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    advisor_id INT NOT NULL,
    enrollment_year INT DEFAULT 2025,

    FOREIGN KEY (advisor_id)
        REFERENCES Advisors(advisor_id)
);

---------------------------------------------------------
-- Enrollments Table
---------------------------------------------------------

CREATE TABLE Enrollments (
    student_id INT,
    course_code VARCHAR(10),
    marks_obtained DECIMAL(5,2)
        CHECK (marks_obtained BETWEEN 0 AND 100),

    PRIMARY KEY (student_id, course_code),

    FOREIGN KEY (student_id)
        REFERENCES Students(student_id)
        ON DELETE CASCADE,

    FOREIGN KEY (course_code)
        REFERENCES Courses(course_code)
        ON DELETE CASCADE
);

---------------------------------------------------------
-- Optional Old Flat Table
-- (Used only for Task 1.3(d))
---------------------------------------------------------

CREATE TABLE StudentRecords (
    student_id INT,
    student_name VARCHAR(100),
    department VARCHAR(100),
    advisor_name VARCHAR(100),
    advisor_email VARCHAR(100),
    course_code VARCHAR(10),
    course_name VARCHAR(100),
    instructor_name VARCHAR(100),
    instructor_email VARCHAR(100),
    enrollment_year INT,
    marks_obtained DECIMAL(5,2)
);

---------------------------------------------------------
-- End of schema.sql
---------------------------------------------------------
