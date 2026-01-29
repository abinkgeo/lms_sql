-- 1. List all users who are enrolled in more than three courses.
SELECT user_name,u.user_id, count(course_id) as total_course_count 
FROM lms.users u LEFT JOIN lms.enrollments e 
on u.user_id = e.user_id 
group by u.user_id,user_name
having count(course_id)>3;


-- 2. Find courses that currently have no enrollments.

SELECT c.course_id,c.course_name from lms.courses c
LEFT JOIN  lms.enrollments e 
ON c.course_id=e.course_id
WHERE e.course_id IS NULL ;

-- 3. Display each course along with the total number of enrolled users.

SELECT c.course_id,c.course_name,COUNT(e.user_id) as total_users 
FROM lms.courses c 
LEFT JOIN lms.enrollments e 
ON c.course_id=e.course_id
GROUP BY c.course_id,c.course_name;

-- 4 Identify users who enrolled in a course but never accessed any lesson.

SELECT u.user_id,u.user_name
FROM lms.users u
JOIN lms.enrollments e
    ON u.user_id = e.user_id
LEFT JOIN lms.user_activity ua
    ON u.user_id = ua.user_id
WHERE ua.user_id IS NULL;

--5 Fetch lessons that have never been accessed by any user.

SELECT l.lesson_id,l.lesson_name FROM lms.lessons l
LEFT JOIN  lms.user_activity ua
ON l.lesson_id=ua.lesson_id
WHERE ua.lesson_id IS NULL;


-- 6 Show the last activity timestamp for each user.

SELECT u.user_id,u.user_name, MAX(ua.activity_datetime) AS last_activity_time
FROM lms.users u JOIN lms.user_activity ua
ON u.user_id =  ua.user_id
GROUP BY u.user_id,u.user_name;

--7 List users who submitted an assessment but scored less than 50 percent of the maximum score.

SELECT u.user_id,u.user_name
FROM lms.users u
JOIN lms.assessment_submission sub
ON u.user_id = sub.user_id
WHERE sub.score < 50;

-- 8. Find assessments that have not received any submissions.

SELECT a.assign_id,a.assign_name 
FROM lms.assessments a  LEFT JOIN lms.assessment_submission sub
ON a.assign_id = sub.assign_id
WHERE sub.assign_id IS NULL;

-- 9. Display the highest score achieved for each assessment.
SELECT a.assign_id,a.assign_name,MAX(sub.score) as highest_score
FROM lms.assessments a  LEFT JOIN  lms.assessment_submission sub 
ON a.assign_id=sub.assign_id 
GROUP BY a.assign_id,a.assign_name;s

--  10.Identify users who are enrolled in a course but have an inactive enrollment status.
SELECT u.user_id,u.user_name, e.status 
FROM lms.users u JOIN lms.enrollments e
ON u.user_id = e.user_id
WHERE e.status='inactive';