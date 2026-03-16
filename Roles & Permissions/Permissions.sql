-- ============================================================
-- NOTE: Run Roles.sql first before running this file
-- ============================================================

USE ITI_ExaminationDB;
GO

-- ============================================================
-- STEP 1: ADMIN PERMISSIONS
-- db_owner covers everything — no extra grants needed
-- ============================================================

ALTER ROLE db_owner ADD MEMBER AdminRole;
GO


-- ============================================================
-- STEP 2: INSTRUCTOR PERMISSIONS
-- SRS: Generate exams, manage questions, view reports
-- ============================================================

-- Read access on all tables
ALTER ROLE db_datareader ADD MEMBER InstructorRole;
GO

-- Write access on exam and question related tables only
GRANT INSERT, UPDATE, DELETE ON Question      TO InstructorRole;
GRANT INSERT, UPDATE, DELETE ON [Option]      TO InstructorRole;
GRANT INSERT, UPDATE, DELETE ON ModelAnswer   TO InstructorRole;
GRANT INSERT, UPDATE, DELETE ON Exam          TO InstructorRole;
GRANT INSERT, UPDATE, DELETE ON Exam_Question TO InstructorRole;
GO

-- Execute permissions on instructor SPs
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
-- SRS: Take exams, view own grades only (db_datareader)
-- ============================================================

-- Read-only access on all tables
ALTER ROLE db_datareader ADD MEMBER StudentRole;
GO

-- Execute permissions on student SPs only
GRANT EXECUTE ON dbo.SubmitExamAnswers    TO StudentRole;
GRANT EXECUTE ON dbo.Report_StudentGrades TO StudentRole;
GO


-- ============================================================
-- STEP 4: DENY SENSITIVE ACCESS (NFR-05)
-- DENY always overrides GRANT — must come after all GRANTs
-- ============================================================

-- Block students from ModelAnswer entirely
DENY SELECT, INSERT, UPDATE, DELETE ON ModelAnswer TO StudentRole;
GO
