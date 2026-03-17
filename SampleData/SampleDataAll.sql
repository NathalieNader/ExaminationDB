USE ITI_ExaminationDB;
GO

--------------------------------------------------
-- SAMPLE DATA FILE
--------------------------------------------------

--------------------------------------------------
-- CLEANUP BEFORE INSERTING SAMPLE DATA
-- Run only if you want to start fresh
--------------------------------------------------

DELETE FROM ModelAnswer;
DELETE FROM [Option];
DELETE FROM StudentAnswer;
DELETE FROM Exam_Question;
DELETE FROM StudentExam;
DELETE FROM Exam;
DELETE FROM Question;
DELETE FROM Student_Track;
DELETE FROM Instructor_Course;
DELETE FROM Track_Course;

DELETE FROM Student;
DELETE FROM Instructor;
DELETE FROM Track;
DELETE FROM Course;
DELETE FROM Branch;
GO

-- Reset identity seeds
DBCC CHECKIDENT ('Branch', RESEED, 0);
DBCC CHECKIDENT ('Course', RESEED, 0);
DBCC CHECKIDENT ('Track', RESEED, 0);
DBCC CHECKIDENT ('Instructor', RESEED, 0);
DBCC CHECKIDENT ('Question', RESEED, 0);
DBCC CHECKIDENT ('Option', RESEED, 0);
DBCC CHECKIDENT ('ModelAnswer', RESEED, 0);
DBCC CHECKIDENT ('Exam', RESEED, 0);
DBCC CHECKIDENT ('StudentExam', RESEED, 0);
DBCC CHECKIDENT ('StudentAnswer', RESEED, 0);
GO

--------------------------------------------------
-- 1) Insert Branch sample data
--------------------------------------------------
EXEC InsertBranch @BranchName = 'Smart Village', @Location = 'Giza';
EXEC InsertBranch @BranchName = 'Alexandria',    @Location = 'Alexandria';
EXEC InsertBranch @BranchName = 'Assiut',        @Location = 'Upper Egypt';
EXEC InsertBranch @BranchName = 'New Capital',   @Location = 'Cairo';
EXEC InsertBranch @BranchName = 'Menofia',       @Location = 'Shebin El-Kom';
GO

--------------------------------------------------
-- 2) Insert Track sample data
--------------------------------------------------
EXEC InsertTrack @TrackName = 'Software Testing',       @BranchID = 1, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'AI & Data Science',      @BranchID = 1, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Web Development',        @BranchID = 2, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Cloud Computing',        @BranchID = 2, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Cyber Security',         @BranchID = 3, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Embedded Systems',       @BranchID = 4, @DurationMonths = 9;
EXEC InsertTrack @TrackName = 'UI/UX Design',           @BranchID = 5, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Full Stack Development', @BranchID = 5, @DurationMonths = 4;
GO

--------------------------------------------------
-- 3) Insert Course sample data
--------------------------------------------------
EXEC InsertCourse @CourseName = 'Manual Testing',         @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Automation Testing',     @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'SQL Server',             @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Database Fundamentals',  @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Python Programming',     @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Machine Learning',       @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'HTML & CSS',             @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'JavaScript',             @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Cloud Fundamentals',     @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Cyber Security Basics',  @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'UI/UX Principles',       @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'OOP using C#',           @MinDegree = 50, @MaxDegree = 100;
GO

--------------------------------------------------
-- 4) Map Tracks to Courses
--------------------------------------------------
INSERT INTO Track_Course (TrackID, CourseID)
VALUES
(1,1),(1,2),(1,3),(1,4),
(2,4),(2,5),(2,6),
(3,7),(3,8),(3,4),
(4,9),(4,4),
(5,10),(5,3),
(6,12),
(7,11),
(8,7),(8,8),(8,4),(8,12);
GO

--------------------------------------------------
-- 5) Insert Instructor sample data
--------------------------------------------------
EXEC InsertInstructor @InstructorName = 'Ahmed Samir',   @Email = 'ahmed.samir@iti.gov.eg',  @DepartmentNo = 10;
EXEC InsertInstructor @InstructorName = 'Sara Adel',     @Email = 'sara.adel@iti.gov.eg',    @DepartmentNo = 20;
EXEC InsertInstructor @InstructorName = 'Mohamed Hany',  @Email = 'mohamed.hany@iti.gov.eg', @DepartmentNo = 30;
EXEC InsertInstructor @InstructorName = 'Nour Khaled',   @Email = 'nour.khaled@iti.gov.eg',  @DepartmentNo = 20;
GO

--------------------------------------------------
-- 6) Assign instructors to 2+ courses each
--------------------------------------------------
EXEC AssignInstructorToCourse @InstructorID = 1, @CourseID = 1;
EXEC AssignInstructorToCourse @InstructorID = 1, @CourseID = 2;

EXEC AssignInstructorToCourse @InstructorID = 2, @CourseID = 3;
EXEC AssignInstructorToCourse @InstructorID = 2, @CourseID = 4;

EXEC AssignInstructorToCourse @InstructorID = 3, @CourseID = 5;
EXEC AssignInstructorToCourse @InstructorID = 3, @CourseID = 6;

EXEC AssignInstructorToCourse @InstructorID = 4, @CourseID = 11;
EXEC AssignInstructorToCourse @InstructorID = 4, @CourseID = 7;
GO

--------------------------------------------------
-- 7) Insert 20 students
-- Uses InsertStudent procedure exactly as you shared
--------------------------------------------------
EXEC InsertStudent @StudentName = 'Ahmed Mohamed',  @Email = 'ahmed.mohamed@iti.com',  @Phone = '01000000001';
EXEC InsertStudent @StudentName = 'Sara Ali',        @Email = 'sara.ali@iti.com',        @Phone = '01000000002';
EXEC InsertStudent @StudentName = 'Mohamed Hassan',  @Email = 'mohamed.hassan@iti.com',  @Phone = '01000000003';
EXEC InsertStudent @StudentName = 'Nour Ibrahim',    @Email = 'nour.ibrahim@iti.com',    @Phone = '01000000004';
EXEC InsertStudent @StudentName = 'Omar Khaled',     @Email = 'omar.khaled@iti.com',     @Phone = '01000000005';
EXEC InsertStudent @StudentName = 'Yasmin Tarek',    @Email = 'yasmin.tarek@iti.com',    @Phone = '01000000006';
EXEC InsertStudent @StudentName = 'Karim Mahmoud',   @Email = 'karim.mahmoud@iti.com',   @Phone = '01000000007';
EXEC InsertStudent @StudentName = 'Dina Youssef',    @Email = 'dina.youssef@iti.com',    @Phone = '01000000008';
EXEC InsertStudent @StudentName = 'Tarek Samir',     @Email = 'tarek.samir@iti.com',     @Phone = '01000000009';
EXEC InsertStudent @StudentName = 'Rania Nasser',    @Email = 'rania.nasser@iti.com',    @Phone = '01000000010';
EXEC InsertStudent @StudentName = 'Mahmoud Adel',    @Email = 'mahmoud.adel@iti.com',    @Phone = '01000000011';
EXEC InsertStudent @StudentName = 'Hana Mostafa',    @Email = 'hana.mostafa@iti.com',    @Phone = '01000000012';
EXEC InsertStudent @StudentName = 'Youssef Ashraf',  @Email = 'youssef.ashraf@iti.com',  @Phone = '01000000013';
EXEC InsertStudent @StudentName = 'Mona Walid',      @Email = 'mona.walid@iti.com',      @Phone = '01000000014';
EXEC InsertStudent @StudentName = 'Amr Gamal',       @Email = 'amr.gamal@iti.com',       @Phone = '01000000015';
EXEC InsertStudent @StudentName = 'Layla Hesham',    @Email = 'layla.hesham@iti.com',    @Phone = '01000000016';
EXEC InsertStudent @StudentName = 'Hassan Ramadan',  @Email = 'hassan.ramadan@iti.com',  @Phone = '01000000017';
EXEC InsertStudent @StudentName = 'Salma Farouk',    @Email = 'salma.farouk@iti.com',    @Phone = '01000000018';
EXEC InsertStudent @StudentName = 'Bilal Sherif',    @Email = 'bilal.sherif@iti.com',    @Phone = '01000000019';
EXEC InsertStudent @StudentName = 'Noha Essam',      @Email = 'noha.essam@iti.com',      @Phone = '01000000020';
GO

--------------------------------------------------
-- 8) Assign students across tracks
--------------------------------------------------
EXEC AssignStudentToTrack @StudentID = 1,  @TrackID = 1;
EXEC AssignStudentToTrack @StudentID = 2,  @TrackID = 1;
EXEC AssignStudentToTrack @StudentID = 3,  @TrackID = 1;

EXEC AssignStudentToTrack @StudentID = 4,  @TrackID = 2;
EXEC AssignStudentToTrack @StudentID = 5,  @TrackID = 2;
EXEC AssignStudentToTrack @StudentID = 6,  @TrackID = 2;

EXEC AssignStudentToTrack @StudentID = 7,  @TrackID = 3;
EXEC AssignStudentToTrack @StudentID = 8,  @TrackID = 3;
EXEC AssignStudentToTrack @StudentID = 9,  @TrackID = 3;

EXEC AssignStudentToTrack @StudentID = 10, @TrackID = 4;
EXEC AssignStudentToTrack @StudentID = 11, @TrackID = 4;

EXEC AssignStudentToTrack @StudentID = 12, @TrackID = 5;
EXEC AssignStudentToTrack @StudentID = 13, @TrackID = 5;
EXEC AssignStudentToTrack @StudentID = 14, @TrackID = 5;

EXEC AssignStudentToTrack @StudentID = 15, @TrackID = 6;
EXEC AssignStudentToTrack @StudentID = 16, @TrackID = 6;

EXEC AssignStudentToTrack @StudentID = 17, @TrackID = 7;
EXEC AssignStudentToTrack @StudentID = 18, @TrackID = 7;

EXEC AssignStudentToTrack @StudentID = 19, @TrackID = 8;
EXEC AssignStudentToTrack @StudentID = 20, @TrackID = 8;
GO

--------------------------------------------------
-- 9) Insert 30 MCQ questions for CourseID = 3
--------------------------------------------------
DECLARE @i INT = 1;
DECLARE @NewQuestionID INT;
DECLARE @QText NVARCHAR(MAX);

WHILE @i <= 30
BEGIN
    SET @QText = N'MCQ Question ' + CAST(@i AS NVARCHAR(10)) + N' for SQL Server';
    EXEC InsertQuestion
        @CourseID = 3,
        @QuestionText = @QText,
        @QuestionType = N'MCQ',
        @Points = 2,
        @NewQuestionID = @NewQuestionID OUTPUT;

    SET @i = @i + 1;
END
GO

--------------------------------------------------
-- 10) Insert 4 options + model answer for each MCQ
--------------------------------------------------
DECLARE @MCQQuestionID INT;
DECLARE @MCQMaxQuestionID INT;
DECLARE @NewOptionID INT;
DECLARE @CorrectOptionID INT;
DECLARE @NewModelANID INT;

SELECT @MCQQuestionID = MIN(QuestionID)
FROM Question
WHERE CourseID = 3 AND QuestionType = 'MCQ';

SELECT @MCQMaxQuestionID = MAX(QuestionID)
FROM Question
WHERE CourseID = 3 AND QuestionType = 'MCQ';

WHILE @MCQQuestionID <= @MCQMaxQuestionID
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Question
        WHERE QuestionID = @MCQQuestionID
          AND CourseID = 3
          AND QuestionType = 'MCQ'
    )
    BEGIN
        EXEC InsertOption
            @QuestionID = @MCQQuestionID,
            @OptionText = N'Option A',
            @OptionOrder = 1,
            @NewOptionID = @NewOptionID OUTPUT;

        SET @CorrectOptionID = @NewOptionID;

        EXEC InsertOption
            @QuestionID = @MCQQuestionID,
            @OptionText = N'Option B',
            @OptionOrder = 2,
            @NewOptionID = @NewOptionID OUTPUT;

        EXEC InsertOption
            @QuestionID = @MCQQuestionID,
            @OptionText = N'Option C',
            @OptionOrder = 3,
            @NewOptionID = @NewOptionID OUTPUT;

        EXEC InsertOption
            @QuestionID = @MCQQuestionID,
            @OptionText = N'Option D',
            @OptionOrder = 4,
            @NewOptionID = @NewOptionID OUTPUT;

        EXEC SetModelAnswer
            @QuestionID = @MCQQuestionID,
            @OptionID = @CorrectOptionID,
            @NewModelANID = @NewModelANID OUTPUT;
    END

    SET @MCQQuestionID = @MCQQuestionID + 1;
END
GO

--------------------------------------------------
-- 11) Insert 20 TF questions for CourseID = 1
--------------------------------------------------
DECLARE @j INT = 1;
DECLARE @NewTFQuestionID INT;
DECLARE @QText NVARCHAR(MAX);

WHILE @j <= 20
BEGIN
    SET @QText = N'TF Question ' + CAST(@j AS NVARCHAR(10)) + N' for Manual Testing';
    EXEC InsertQuestion
        @CourseID = 1,
        @QuestionText = @QText,
        @QuestionType = N'TF',
        @Points = 1,
        @NewQuestionID = @NewTFQuestionID OUTPUT;

    SET @j = @j + 1;
END
GO

--------------------------------------------------
-- 12) Insert 20 TF questions for CourseID = 3
--------------------------------------------------
DECLARE @i INT = 1;
DECLARE @NewQuestionID INT;
DECLARE @QText NVARCHAR(MAX);

WHILE @i <= 20
BEGIN
    SET @QText = N'TF Question ' + CAST(@i AS NVARCHAR(10)) + N' for SQL Server';
    EXEC InsertQuestion 
        @CourseID = 3, 
        @QuestionText = @QText, 
        @QuestionType = N'TF', 
        @Points = 1, 
        @NewQuestionID = @NewQuestionID OUTPUT;
    SET @i = @i + 1;
END
GO

--------------------------------------------------
-- 13) Insert 2 options + model answer for each TF
--------------------------------------------------
DECLARE @TFQuestionID INT;
DECLARE @TFMaxQuestionID INT;
DECLARE @TFNewOptionID INT;
DECLARE @TFCorrectOptionID INT;
DECLARE @TFNewModelANID INT;

SELECT @TFQuestionID = MIN(QuestionID)
FROM Question
WHERE CourseID IN(1, 3) AND QuestionType = 'TF';

SELECT @TFMaxQuestionID = MAX(QuestionID)
FROM Question
WHERE CourseID IN (1, 3) AND QuestionType = 'TF';

WHILE @TFQuestionID <= @TFMaxQuestionID
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Question
        WHERE QuestionID = @TFQuestionID
          AND CourseID IN (1, 3)
          AND QuestionType = 'TF'
    )
    BEGIN
        EXEC InsertOption
            @QuestionID = @TFQuestionID,
            @OptionText = N'True',
            @OptionOrder = 1,
            @NewOptionID = @TFNewOptionID OUTPUT;

        SET @TFCorrectOptionID = @TFNewOptionID;

        EXEC InsertOption
            @QuestionID = @TFQuestionID,
            @OptionText = N'False',
            @OptionOrder = 2,
            @NewOptionID = @TFNewOptionID OUTPUT;

        EXEC SetModelAnswer
            @QuestionID = @TFQuestionID,
            @OptionID = @TFCorrectOptionID,
            @NewModelANID = @TFNewModelANID OUTPUT;
    END

    SET @TFQuestionID = @TFQuestionID + 1;
END
GO


