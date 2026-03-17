-- ============================================================
-- Purpose : Test Scenarios for Section 7 of the SRS
-- Note    : Run Sample Data file first
-- ============================================================
USE ITI_ExaminationDB;
GO

/*============================================================
  Scenario 1: GenerateExam — valid inputs
  Expected:
    - One Exam row is created
    - Required Exam_Question rows are created
    - No duplicate questions inside the same exam
============================================================*/

DECLARE @NewExamID INT;

EXEC GenerateExam
     @CourseID  = 3,
     @ExamName  = N'SQL Server Exam 1',
     @NumMCQ    = 5,
     @NumTF     = 3,
     @NewExamID = @NewExamID OUTPUT;

SELECT @NewExamID AS GeneratedExamID;

-- Validation query:
 SELECT * FROM Exam WHERE ExamName = N'SQL Server Exam 1';
 SELECT * FROM Exam_Question
 WHERE ExamID = (SELECT ExamID FROM Exam WHERE ExamName = N'SQL Server Exam 1');

-- Check duplicate questions:
 SELECT QuestionID, COUNT(*) AS DuplicateCount
 FROM Exam_Question
 WHERE ExamID = (SELECT ExamID FROM Exam WHERE ExamName = N'SQL Server Exam 1')
 GROUP BY QuestionID
 HAVING COUNT(*) > 1;
GO

/*============================================================
  Scenario 2: GenerateExam — not enough questions
  Expected:
    - Procedure raises an error
    - No partial exam is created
============================================================*/

-- Example: request more questions than exist for a course
DECLARE @ImpossibleExamID INT;
 EXEC GenerateExam
      @CourseID = 3,
      @ExamName = N'SQL Server Impossible Exam',
      @NumMCQ   = 100,
      @NumTF    = 100,
      @NewExamID = @ImpossibleExamID OUTPUT;
-- Validation query:
 SELECT * FROM Exam WHERE ExamName = N'SQL Server Impossible Exam';
GO


/*============================================================
  Scenario 3: SubmitExamAnswers — all questions answered
  Expected:
    - One StudentExam row is inserted
    - Related StudentAnswer rows are inserted for all questions
============================================================*/
EXEC SubmitExamAnswers
    @StudentID = 1,
    @ExamID    = 1,
    @StartTime = '2026-03-17 10:00:00',
    @EndTime   = '2026-03-17 11:00:00',
    @Answers   = N'<Answers>
        <Answer><QuestionID>9</QuestionID><ChosenOptionID>33</ChosenOptionID></Answer>
        <Answer><QuestionID>16</QuestionID><ChosenOptionID>61</ChosenOptionID></Answer>
        <Answer><QuestionID>24</QuestionID><ChosenOptionID>93</ChosenOptionID></Answer>
        <Answer><QuestionID>25</QuestionID><ChosenOptionID>97</ChosenOptionID></Answer>
        <Answer><QuestionID>27</QuestionID><ChosenOptionID>105</ChosenOptionID></Answer>
        <Answer><QuestionID>62</QuestionID><ChosenOptionID>183</ChosenOptionID></Answer>
        <Answer><QuestionID>67</QuestionID><ChosenOptionID>193</ChosenOptionID></Answer>
        <Answer><QuestionID>69</QuestionID><ChosenOptionID>197</ChosenOptionID></Answer>
    </Answers>';

-- Validation query:
 SELECT * 
 FROM StudentExam
 WHERE StudentID = 1
   AND ExamID = 1;

 SELECT *
 FROM StudentAnswer
 WHERE StudentExamID = (
     SELECT StudentExamID
     FROM StudentExam
     WHERE StudentID = 1
       AND ExamID = 1
 );
GO

/*============================================================
  Scenario 4: SubmitExamAnswers — one question skipped
  Expected:
    - Procedure succeeds
    - StudentExam row is inserted
    - Missing answer is simply absent from StudentAnswer
============================================================*/
EXEC SubmitExamAnswers
    @StudentID = 2,
    @ExamID    = 1,
    @StartTime = '2026-03-17 10:00:00',
    @EndTime   = '2026-03-17 11:00:00',
    @Answers   = N'<Answers>
        <Answer><QuestionID>9</QuestionID><ChosenOptionID>33</ChosenOptionID></Answer>
        <Answer><QuestionID>16</QuestionID><ChosenOptionID>61</ChosenOptionID></Answer>
        <Answer><QuestionID>24</QuestionID><ChosenOptionID>93</ChosenOptionID></Answer>
        <Answer><QuestionID>25</QuestionID><ChosenOptionID>97</ChosenOptionID></Answer>
        <Answer><QuestionID>27</QuestionID><ChosenOptionID>105</ChosenOptionID></Answer>
        <Answer><QuestionID>62</QuestionID><ChosenOptionID>183</ChosenOptionID></Answer>
        <Answer><QuestionID>67</QuestionID><ChosenOptionID>193</ChosenOptionID></Answer>
    </Answers>';

-- Validation — should show exactly 7 rows, no row for QuestionID = 69
SELECT * FROM StudentAnswer WHERE StudentExamID = (
    SELECT StudentExamID FROM StudentExam WHERE StudentID = 2 AND ExamID = 1
);
GO


/*============================================================
  Scenario 5: CorrectExam — all answers correct
  Expected:
    - TotalGrade = MaxDegree
============================================================*/

DECLARE @StudentExamID1 INT;
DECLARE @TotalGrade1 INT;

SELECT @StudentExamID1 = StudentExamID 
FROM StudentExam 
WHERE StudentID = 1 AND ExamID = 1;

EXEC CorrectExam 
    @StudentExamID = @StudentExamID1,  
    @TotalGrade = @TotalGrade1 OUTPUT;

SELECT @TotalGrade1 AS TotalGrade;
SELECT SE.StudentExamID, SE.TotalGrade, SUM(Q.Points) AS MaxPossible
FROM StudentExam SE
JOIN Exam_Question EQ ON SE.ExamID = EQ.ExamID
JOIN Question Q ON EQ.QuestionID = Q.QuestionID
WHERE SE.StudentExamID = @StudentExamID1
GROUP BY SE.StudentExamID, SE.TotalGrade;
GO

/*============================================================
  Scenario 6: CorrectExam — all answers wrong
  Expected:
    - TotalGrade = 0
============================================================*/
EXEC SubmitExamAnswers
    @StudentID = 3,
    @ExamID    = 1,
    @StartTime = '2026-03-17 10:00:00',
    @EndTime   = '2026-03-17 11:00:00',
    @Answers   = N'<Answers>
        <Answer><QuestionID>9</QuestionID><ChosenOptionID>34</ChosenOptionID></Answer>
        <Answer><QuestionID>16</QuestionID><ChosenOptionID>62</ChosenOptionID></Answer>
        <Answer><QuestionID>24</QuestionID><ChosenOptionID>94</ChosenOptionID></Answer>
        <Answer><QuestionID>25</QuestionID><ChosenOptionID>98</ChosenOptionID></Answer>
        <Answer><QuestionID>27</QuestionID><ChosenOptionID>106</ChosenOptionID></Answer>
        <Answer><QuestionID>62</QuestionID><ChosenOptionID>184</ChosenOptionID></Answer>
        <Answer><QuestionID>67</QuestionID><ChosenOptionID>194</ChosenOptionID></Answer>
        <Answer><QuestionID>69</QuestionID><ChosenOptionID>198</ChosenOptionID></Answer>
    </Answers>';
GO

DECLARE @StudentExamID3 INT;
DECLARE @TotalGrade3 INT;

SELECT @StudentExamID3 = StudentExamID 
FROM StudentExam 
WHERE StudentID = 3 AND ExamID = 1;

EXEC CorrectExam 
    @StudentExamID = @StudentExamID3, 
    @TotalGrade = @TotalGrade3 OUTPUT;

SELECT @TotalGrade3 AS TotalGrade;

SELECT * 
FROM StudentExam 
WHERE StudentExamID = @StudentExamID3;
GO


/*============================================================
  Scenario 7: Run all 3 reports
  Expected:
    - Each report returns correct data matching SRS definition
============================================================*/
-- 7.1 Report_StudentsByDepartment
EXEC Report_StudentsByDepartment @DepartmentNo = 10;
GO

-- 7.2 Report_StudentGrades
EXEC Report_StudentGrades @StudentID = 1;
GO

-- 7.3 Report_InstructorCourses
EXEC Report_InstructorCourses @InstructorID = 1;
GO


/*============================================================
  Scenario 8: Delete Course with existing exams
  Expected:
    - FK constraint prevents deletion
    - Error is raised
============================================================*/

-- This should be tested only through the stored procedure
EXEC DeleteCourse @CourseID = 3;
GO