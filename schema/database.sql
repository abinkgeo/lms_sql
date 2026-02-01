CREATE DATABASE lms;


USE lms;

CREATE SCHEMA lms;




CREATE TABLE lms.users (
    user_id INT  PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(150) NOT NULL UNIQUE,
    user_password VARCHAR(255) NOT NULL
);



BULK INSERT lms.users
FROM '/var/opt/mssql/data/lms_csv/users.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

---------------------------------------------------------------------------

CREATE TABLE lms.courses (
    course_id INT  PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_duration INT NOT NULL
);

BULK INSERT lms.courses
FROM '/var/opt/mssql/data/lms_csv/courses.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

------------------------------------------------------------------


CREATE TABLE lms.lessons(
    lesson_id INT  PRIMARY KEY,
    lesson_name VARCHAR(150) NOT NULL,
    course_id INT NOT NULL,
    CONSTRAINT fk_lessons_course FOREIGN KEY (course_id)
        REFERENCES lms.courses(course_id)
);



BULK INSERT lms.lessons
FROM '/var/opt/mssql/data/lms_csv/lessons.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

--------------------------------------------------------------------------------------------------------------------

CREATE TABLE lms.enrollments (
    enroll_id INT  PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL ,
    CONSTRAINT fk_enrollments_user FOREIGN KEY (user_id)
        REFERENCES lms.users(user_id),
    CONSTRAINT fk_enrollments_course FOREIGN KEY (course_id)
        REFERENCES lms.courses(course_id)
);


BULK INSERT lms.enrollments
FROM '/var/opt/mssql/data/lms_csv/enrollments.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
-------------------------------------------------------------------------------------


CREATE TABLE lms.assessments (
    assign_id INT  PRIMARY KEY,
    assign_name VARCHAR(150) NOT NULL,
    lesson_id INT NOT NULL,
    max_score INT NOT NULL ,
    CONSTRAINT fk_assessments_lesson FOREIGN KEY (lesson_id)
        REFERENCES lms.lessons(lesson_id),
);



BULK INSERT lms.assessments
FROM '/var/opt/mssql/data/lms_csv/assessments.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
--------------------------------------------------------------------------

CREATE TABLE lms.assessment_submission (
    submission_id INT  PRIMARY KEY,
    assign_id INT NOT NULL,
    user_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    submitted_date DATETIME NOT NULL,
    assign_status VARCHAR(20) ,
    CONSTRAINT fk_submission_assessment FOREIGN KEY (assign_id)
        REFERENCES lms.assessments(assign_id),
    CONSTRAINT fk_submission_user FOREIGN KEY (user_id)
        REFERENCES lms.users(user_id)
);



BULK INSERT lms.assessment_submission
FROM '/var/opt/mssql/data/lms_csv/assessment_submission.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE lms.user_activity (
    activity_id INT PRIMARY KEY,
    user_id INT,
    activity_status VARCHAR(50),
    lesson_id INT,
    activity_date DATE,
    CONSTRAINT fk_activity_user
        FOREIGN KEY (user_id)
        REFERENCES lms.users(user_id),
    CONSTRAINT fk_activity_lesson
        FOREIGN KEY (lesson_id)
        REFERENCES lms.lessons(lesson_id)
);

BULK INSERT lms.user_activity
FROM '/var/opt/mssql/data/lms_csv/user_activity.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);















