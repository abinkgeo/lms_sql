-- 1. List all users who are enrolled in more than three courses.
/* 
WHY LEFT JOIN:To include all users.
ASSUMPTIONS: course_id is counted because each record represents one course enrollment.
*/
SELECT user_name,u.user_id, count(course_id) as total_course_count 
FROM lms.users u LEFT JOIN lms.enrollments e 
on u.user_id = e.user_id 
group by u.user_id,user_name
having count(course_id)>3;


-- 2. Find courses that currently have no enrollments.
/* 
WHY LEFT JOIN: To include all courses.
ASSUMPTIONS:If course_id is NULL in enrollments, then no user has enrolled in that course.
*/
SELECT c.course_id,c.course_name from lms.courses c
LEFT JOIN  lms.enrollments e 
ON c.course_id=e.course_id
WHERE e.course_id IS NULL ;

-- 3. Display each course along with the total number of enrolled users.
/* 
WHY LEFT JOIN:To include all courses, even those with no enrollments.
ASSUMPTIONS:Each row in the enrollments table represents one user enrolled in a course, so counting user_id gives the total number of users per course.
*/
SELECT c.course_id,c.course_name,COUNT(e.user_id) as total_users 
FROM lms.courses c 
LEFT JOIN lms.enrollments e 
ON c.course_id=e.course_id
GROUP BY c.course_id,c.course_name;

-- 4 Identify users who enrolled in a course but never accessed any lesson.
/* 
WHY LEFT JOIN:To check whether the enrolled user has any activity or not.
ASSUMPTIONS: If user_id is NULL in user_activity,  then user never accessed any lesson.
*/
SELECT DISTINCT u.user_id,u.user_name
FROM lms.users u
JOIN lms.enrollments e
    ON u.user_id = e.user_id
LEFT JOIN lms.user_activity ua
    ON u.user_id = ua.user_id
WHERE ua.user_id IS NULL;

--5 Fetch lessons that have never been accessed by any user.
/* 
WHY LEFT JOIN: To include all lessons and find those without any user activity.
ASSUMPTIONS: If lesson_id is NULL in user_activity, then lesson has never been accessed.
*/
SELECT l.lesson_id,l.lesson_name FROM lms.lessons l
LEFT JOIN  lms.user_activity ua
ON l.lesson_id=ua.lesson_id
WHERE ua.lesson_id IS NULL;



-- 6 Show the last activity timestamp for each user.
/* 
WHY LEFT JOIN: To include all users, even those who have never performed any activity.
ASSUMPTIONS: activity_date stores the timestamp of user activity, and MAX gives the last active one.
*/
SELECT  u.user_id,u.user_name,MAX(ua.activity_date) AS last_activity_time
FROM lms.users u
LEFT JOIN lms.user_activity ua
ON u.user_id = ua.user_id
GROUP BY u.user_id, u.user_name;


--7 List users who submitted an assessment but scored less than 50 percent of the maximum score.
/* 
WHY INNER JOIN: Only users who submitted assessments and have assessment details are required.
ASSUMPTIONS: max_score represents the total possible score for an assessment.
*/
SELECT DISTINCT u.user_id, u.user_name
FROM lms.users u
JOIN lms.assessment_submission sub
ON u.user_id = sub.user_id
JOIN lms.assessments a
ON sub.assign_id = a.assign_id
WHERE sub.score < (a.max_score * 0.5);


-- 8. Find assessments that have not received any submissions.
/* 
WHY LEFT JOIN: To include all assessments, even those without submissions.
ASSUMPTIONS: If assign_id is NULL in assessment_submission, no user has submitted that assessment.
*/
SELECT a.assign_id,a.assign_name 
FROM lms.assessments a  LEFT JOIN lms.assessment_submission sub
ON a.assign_id = sub.assign_id
WHERE sub.assign_id IS NULL;

-- 9. Display the highest score achieved for each assessment.
/* 
WHY LEFT JOIN: To include all assessments, even if no one has attempted them.
ASSUMPTIONS: MAX(score) gives the highest score obtained for an assessment.
*/
SELECT a.assign_id,a.assign_name,MAX(sub.score) as highest_score
FROM lms.assessments a  LEFT JOIN  lms.assessment_submission sub 
ON a.assign_id=sub.assign_id 
GROUP BY a.assign_id,a.assign_name;

--  10.Identify users who are enrolled in a course but have an inactive enrollment status.
/* 
WHY INNER JOIN: Only users who are enrolled in courses are relevant.
ASSUMPTIONS: status column indicates whether the enrollment is active or inactive.
*/
SELECT DISTINCT u.user_id,u.user_name, e.status 
FROM lms.users u JOIN lms.enrollments e
ON u.user_id = e.user_id
WHERE e.status='inactive';



