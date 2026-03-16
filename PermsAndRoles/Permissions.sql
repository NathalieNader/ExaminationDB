-- ============================================================
-- NOTE: Run Roles.sql first before running this file
-- ============================================================

USE ITI_ExaminationDB;
GO


-- ============================================================
-- STEP 1: ADMIN PERMISSIONS
-- Admins get full control of the database
-- ============================================================

ALTER ROLE db_owner ADD MEMBER AdminRole;
GO


-- ============================================================
-- STEP 2: INSTRUCTOR PERMISSIONS
-- Instructors generate exams, manage questions, view reports
-- ============================================================

-- Read access to database tables
ALTER ROLE db_datareader ADD MEMBER InstructorRole;
GO

-- Write access on exam & question related tables
GRANT INSERT, UPDATE, DELETE ON Question      TO InstructorRole;
GRANT INSERT, UPDATE, DELETE ON [Option]      TO InstructorRole;
GRANT INSERT, UPDATE, DELETE ON ModelAnswer   TO InstructorRole;
GRANT INSERT, UPDATE, DELETE ON Exam          TO InstructorRole;
GRANT INSERT, UPDATE, DELETE ON Exam_Question TO InstructorRole;
GO

-- Execute permissions on instructor stored procedures
GRANT EXECUTE ON dbo.InsertQuestion              TO InstructorRole;
GRANT EXECUTE ON dbo.UpdateQuestion              TO InstructorRole;
GRANT EXECUTE ON dbo.DeleteQuestion              TO InstructorRole;
GRANT EXECUTE ON dbo.InsertOption                TO InstructorRole;
GRANT EXECUTE ON dbo.SetModelAnswer              TO InstructorRole;
GRANT EXECUTE ON dbo.GenerateExam                TO InstructorRole;
GRANT EXECUTE ON dbo.CorrectExam                 TO InstructorRole;
GRANT EXECUTE ON dbo.Report_StudentsByDepartment TO InstructorRole;
GRANT EXECUTE ON dbo.Report_StudentGrades        TO InstructorRole;
GRANT EXECUTE ON dbo.Report_InstructorCourses    TO InstructorRole;
GO


-- ============================================================
-- STEP 3: STUDENT PERMISSIONS
-- Students can ONLY:
--   • Submit exam answers
--   • View their grades through procedures
-- ============================================================

-- DO NOT give db_datareader to students

GRANT EXECUTE ON dbo.SubmitExamAnswers    TO StudentRole;
GRANT EXECUTE ON dbo.Report_StudentGrades TO StudentRole;
GO


-- ============================================================
-- STEP 4: DENY SENSITIVE ACCESS (NFR-04, NFR-05)
-- Students must not access exam answers or model answers
-- ============================================================

-- Block students from ModelAnswer entirely
DENY SELECT, INSERT, UPDATE, DELETE ON ModelAnswer TO StudentRole;

-- Prevent students from seeing exam questions directly
DENY SELECT ON Question TO StudentRole;
DENY SELECT ON [Option] TO StudentRole;

-- Prevent students from seeing other students' data
DENY SELECT ON Student TO StudentRole;
DENY SELECT ON StudentExam TO StudentRole;
DENY SELECT ON StudentAnswer TO StudentRole;

-- Prevent access to instructor-related tables
DENY SELECT ON Instructor TO StudentRole;
DENY SELECT ON Instructor_Course TO StudentRole;

GO