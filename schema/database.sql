-- CREATE DATABASE lms;


-- USE lms;

-- CREATE SCHEMA lms;

CREATE TABLE lms.users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(150) NOT NULL UNIQUE,
    user_password VARCHAR(255) NOT NULL
);

INSERT INTO lms.users (user_name, user_email, user_password)
VALUES
('Rahul Das',     'rahul.das@mail.com',     'hash_rahul'),
('Meera Nair',    'meera.nair@mail.com',    'hash_meera'),
('Suresh Rao',    'suresh.rao@mail.com',    'hash_suresh'),
('Kavya Menon',   'kavya.menon@mail.com',   'hash_kavya'),
('Amit Shah',    'amit.shah@mail.com',     'hash_amit'),
('Divya Joshi',   'divya.joshi@mail.com',   'hash_divya'),
('Nikhil Jain',   'nikhil.jain@mail.com',   'hash_nikhil'),
('Ritu Malhotra', 'ritu.m@mail.com',        'hash_ritu'),
('Santhosh P',    'santhosh.p@mail.com',    'hash_santhosh'),
('Isha Kapoor',   'isha.k@mail.com',        'hash_isha'),
('Arjun Verma', 'arjun.verma@mail.com', 'hash_arjun');

CREATE TABLE lms.courses (
    course_id INT IDENTITY(101,1) PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_duration INT NOT NULL
);

INSERT INTO lms.courses (course_name, course_duration) VALUES
('SQL',45),
('Java',70),
('Python',55),
('C',40),
('C++',60),
('.NET',75);
('Go Programming', 50);

CREATE TABLE lms.lessons (
    lesson_id INT IDENTITY(201,1) PRIMARY KEY,
    lesson_name VARCHAR(150) NOT NULL,
    course_id INT NOT NULL,
    CONSTRAINT fk_lessons_course FOREIGN KEY (course_id)
        REFERENCES lms.courses(course_id)
);

INSERT INTO lms.lessons (lesson_name, course_id) VALUES
('Intro to SQL',101),
('Advanced Joins',101),
('SQL Functions',101),
('Java Overview',102),
('Java OOP Deep Dive',102),
('Java Exceptions',102),
('Python Intro',103),
('Python Collections',103),
('Python Modules',103),
('C Basics',104),
('Pointers Explained',104),
('Memory in C',104),
('C++ Fundamentals',105),
('C++ OOP',105),
('STL Containers',105),
('.NET Basics',106),
('ASP.NET MVC',106),
('EF Core',106);


CREATE TABLE lms.enrollments (
    enroll_id INT IDENTITY(301,1) PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    CONSTRAINT fk_enrollments_user FOREIGN KEY (user_id)
        REFERENCES lms.users(user_id),
    CONSTRAINT fk_enrollments_course FOREIGN KEY (course_id)
        REFERENCES lms.courses(course_id)
);

INSERT INTO lms.enrollments (user_id, course_id, enrolled_date,status)
VALUES
(1, 101, 2025-02-20, active),
(1, 102, 2025-02-21, active),
(1, 103, 2025-02-01, inactive),
(1, 105, 2025-02-22, inactive),
(2, 101, 2025-02-03, inactive),
(2, 103, 2025-02-21, active),
(3, 102, 2025-02-05, inactive),
(3, 106, 2025-02-23, active),
(4, 104, 2025-02-07, active),
(5, 105, 2025-02-09, active),
(6, 106, 2025-02-11, active),
(7, 101, 2025-02-13, active),
(8, 103, 2025-02-15, active),
(8, 104, 2025-02-25, inactive),
(9, 105, 2025-02-17, active),
(10, 102, 2025-02-19, active),
(11, 101, 2026-03-01, inactive)


CREATE TABLE lms.assessments (
    assign_id INT IDENTITY(401,1) PRIMARY KEY,
    assign_name VARCHAR(150) NOT NULL,
    lesson_id INT NOT NULL,
    max_score INT NOT NULL ,
    CONSTRAINT fk_assessments_lesson FOREIGN KEY (lesson_id)
        REFERENCES lms.lessons(lesson_id),
    CONSTRAINT chk_assessment_max_score CHECK (max_score = 100)
);

INSERT INTO lms.assessments (assign_name, lesson_id)
VALUES
('SQL Basics Test',201),
('Join Mastery Quiz',202),
('SQL Functions Task',203),
('Java Intro Quiz',204),
('OOP Concepts Exam',205),
('Exception Handling Test',206),
('Python Intro Quiz',207),
('Collections Test',208),
('Modules Assignment',209),
('C Basics Quiz',210),
('Pointer Concepts Test',211),
('Memory Quiz',212),
('C++ Basics Test',213),
('OOP C++ Quiz',214),
('STL Practical',215),
('.NET Basics Quiz',216),
('ASP.NET MVC Test',217),
('EF Core Assignment',218);

CREATE TABLE lms.assessment_submission (
    submission_id INT IDENTITY(501,1) PRIMARY KEY,
    assign_id INT NOT NULL,
    user_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    submitted_date DATETIME NOT NULL,
    assign_status VARCHAR(20) NOT NULL DEFAULT 'not started',
    CONSTRAINT fk_submission_assessment FOREIGN KEY (assign_id)
        REFERENCES lms.assessments(assign_id),
    CONSTRAINT fk_submission_user FOREIGN KEY (user_id)
        REFERENCES lms.users(user_id)
);

INSERT INTO lms.assessment_submission
(assign_id, user_id, score, submitted_date, assign_status)
VALUES
(401,1,78.5,'2026-02-10 09:00:00','completed'),
(402,2,69.0,'2026-02-11 10:15:00','completed'),
(403,3,88.0,'2026-02-12 11:30:00','in progress'),
(404,4,91.5,'2026-02-13 12:45:00','completed'),
(405,5,74.0,'2026-02-14 14:00:00','completed'),
(406,6,85.5,'2026-02-15 15:30:00','in progress'),
(407,7,60.0,'2026-02-16 16:10:00','not started'),
(408,8,82.0,'2026-02-17 09:40:00','completed'),
(409,9,89.0,'2026-02-18 10:50:00','completed'),
(410,10,92.5,'2026-02-19 11:20:00','in progress');


CREATE TABLE lms.user_activity (
    activity_id INT IDENTITY(601,1) PRIMARY KEY,
    user_id INT NOT NULL,
    activity_status VARCHAR(20) NOT NULL DEFAULT 'notstarted',
    lesson_id INT NOT NULL,
    activity_datetime DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_UserActivity_User FOREIGN KEY (user_id)
        REFERENCES lms.users(user_id),
    CONSTRAINT FK_UserActivity_Lesson FOREIGN KEY (lesson_id)
        REFERENCES lms.lessons(lesson_id),
    CONSTRAINT CK_ActivityStatus
        CHECK (activity_status IN ('notstarted','started','completed'))
);

INSERT INTO lms.user_activity
(user_id, activity_status, lesson_id, activity_datetime)
VALUES
(1,'started',201,'2026-02-10 08:30:00'),
(2,'completed',202,'2026-02-10 09:15:00'),
(3,'started',203,'2026-02-11 10:45:00'),
(4,'completed',204,'2026-02-11 11:20:00'),
(5,'notstarted',205,'2026-02-12 12:30:00'),
(6,'completed',206,'2026-02-12 14:00:00'),
(7,'started',207,'2026-02-13 15:10:00'),
(8,'completed',208,'2026-02-13 16:40:00'),
(9,'started',209,'2026-02-14 09:50:00'),
(10,'notstarted',210,'2026-02-14 11:15:00')
(1, 'completed', 202, '2026-02-11 10:00:00'),
(1, 'completed', 203, '2026-02-12 18:30:00'),
(2, 'started', 203, '2026-02-11 12:45:00'),
(3, 'completed', 204, '2026-02-12 09:15:00'),
(3, 'completed', 205, '2026-02-13 20:10:00'),
(4, 'started', 205, '2026-02-12 14:40:00'),
(5, 'completed', 206, '2026-02-13 17:55:00'),
(6, 'completed', 207, '2026-02-14 08:30:00'),
(6, 'completed', 208, '2026-02-15 19:00:00');








