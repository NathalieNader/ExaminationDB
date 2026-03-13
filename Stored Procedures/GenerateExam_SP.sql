USE ITI_ExaminationDB;
GO

-- ============================================================
-- GenerateExam
-- Purpose : Creates a new exam and randomly selects questions
--           from the question bank for the given course.
--           MCQ and TF questions are selected separately,
--           each ordered randomly via NEWID().
-- Inputs  : @CourseID      INT              - FK to Course table
--           @ExamName      NVARCHAR(100)    - Name of the exam
--           @NumMCQ        INT              - Number of MCQ questions
--           @NumTF         INT              - Number of TF questions
-- Outputs : @NewExamID     INT OUTPUT       - PK of the created Exam row
-- Rules   : - Raises error if not enough MCQ or TF in the bank
--           - No duplicate questions per exam
--           - OrderNo is sequential (MCQ first, then TF)
--           - Full transaction: ROLLBACK on any error
-- ============================================================

CREATE PROCEDURE GenerateExam
    @CourseID   INT,
    @ExamName   NVARCHAR(100),
    @NumMCQ     INT,
    @NumTF      INT,
    @NewExamID  INT OUTPUT
AS
BEGIN
    -- ── NULL Validation ──────────────────────────────────────
    IF @CourseID IS NULL
        THROW 50020, 'GenerateExam: @CourseID cannot be NULL.', 1;

    IF @ExamName IS NULL OR LTRIM(RTRIM(@ExamName)) = ''
        THROW 50021, 'GenerateExam: @ExamName cannot be NULL or empty.', 1;

    IF @NumMCQ IS NULL OR @NumMCQ < 0
        THROW 50022, 'GenerateExam: @NumMCQ must be a non-negative number.', 1;

    IF @NumTF IS NULL OR @NumTF < 0
        THROW 50023, 'GenerateExam: @NumTF must be a non-negative number.', 1;

    IF @NumMCQ = 0 AND @NumTF = 0
        THROW 50024, 'GenerateExam: Exam must have at least 1 question.', 1;

    -- ── Check Course Exists ──────────────────────────────────
    IF NOT EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
        THROW 50025, 'GenerateExam: @CourseID does not match any existing course.', 1;

    -- ── Declare Variables ────────────────────────────────────
    DECLARE @AvailMCQ   INT;
    DECLARE @AvailTF    INT;
    DECLARE @Total      INT;

    BEGIN TRY
        BEGIN TRAN;

        -- ── Check enough MCQ questions exist ─────────────────
        SELECT @AvailMCQ = COUNT(*)
        FROM   Question
        WHERE  CourseID     = @CourseID
          AND  QuestionType = 'MCQ';

        IF @AvailMCQ < @NumMCQ
            THROW 50026, 'GenerateExam: Not enough MCQ questions in the bank for this course.', 1;

        -- ── Check enough TF questions exist ──────────────────
        SELECT @AvailTF = COUNT(*)
        FROM   Question
        WHERE  CourseID     = @CourseID
          AND  QuestionType = 'TF';

        IF @AvailTF < @NumTF
            THROW 50027, 'GenerateExam: Not enough TF questions in the bank for this course.', 1;

        -- ── Insert row into Exam table ────────────────────────
        SET @Total = @NumMCQ + @NumTF;

        INSERT INTO Exam (ExamName, CourseID, CreatedDate, TotalQuestions)
        VALUES (@ExamName, @CourseID, GETDATE(), @Total);

        SET @NewExamID = SCOPE_IDENTITY();

        -- ── Insert MCQ questions (random via NEWID()) ─────────
        -- OrderNo starts at 1
        INSERT INTO Exam_Question (ExamID, QuestionID, OrderNo)
        SELECT TOP (@NumMCQ)
            @NewExamID,
            QuestionID,
            ROW_NUMBER() OVER (ORDER BY NEWID())   -- sequential OrderNo
        FROM  Question
        WHERE CourseID     = @CourseID
          AND QuestionType = 'MCQ'
        ORDER BY NEWID();

        -- ── Insert TF questions (random via NEWID()) ──────────
        -- OrderNo continues after MCQ (e.g. MCQ=5 → TF starts at 6)
        INSERT INTO Exam_Question (ExamID, QuestionID, OrderNo)
        SELECT TOP (@NumTF)
            @NewExamID,
            QuestionID,
            @NumMCQ + ROW_NUMBER() OVER (ORDER BY NEWID())
        FROM  Question
        WHERE CourseID     = @CourseID
          AND QuestionType = 'TF'
          AND QuestionID NOT IN (             -- no duplicate questions
              SELECT QuestionID
              FROM   Exam_Question
              WHERE  ExamID = @NewExamID
          )
        ORDER BY NEWID();

        COMMIT TRAN;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;    -- re-raise the original error
    END CATCH;
END;
GO


-- ============================================================
-- TESTING — GenerateExam
-- ============================================================

-- ── Test 1: Valid inputs ─────────────────────────────────────
-- Expected: Exam row created + Exam_Question rows, no duplicates
DECLARE @EID INT;
EXEC GenerateExam
    @CourseID  = 1,
    @ExamName  = N'Manual Testing Midterm',
    @NumMCQ    = 3,
    @NumTF     = 2,
    @NewExamID = @EID OUTPUT;
PRINT 'New ExamID = ' + CAST(@EID AS NVARCHAR);

-- Verify rows created
SELECT * FROM Exam          WHERE ExamID = @EID;
SELECT * FROM Exam_Question WHERE ExamID = @EID ORDER BY OrderNo;
GO

-- ── Test 2: NumMCQ exceeds available ────────────────────────
-- Expected: error raised, zero rows inserted
DECLARE @EID INT;
BEGIN TRY
    EXEC GenerateExam
        @CourseID  = 1,
        @ExamName  = N'Impossible Exam',
        @NumMCQ    = 9999,
        @NumTF     = 0,
        @NewExamID = @EID OUTPUT;
END TRY
BEGIN CATCH
    PRINT 'ERROR (expected): ' + ERROR_MESSAGE();
END CATCH;
GO

-- ── Test 3: NULL CourseID ────────────────────────────────────
DECLARE @EID INT;
BEGIN TRY
    EXEC GenerateExam
        @CourseID  = NULL,
        @ExamName  = N'Bad Exam',
        @NumMCQ    = 2,
        @NumTF     = 1,
        @NewExamID = @EID OUTPUT;
END TRY
BEGIN CATCH
    PRINT 'ERROR (expected): ' + ERROR_MESSAGE();
END CATCH;
GO

-- ── Test 4: Empty ExamName ───────────────────────────────────
DECLARE @EID INT;
BEGIN TRY
    EXEC GenerateExam
        @CourseID  = 1,
        @ExamName  = N'   ',
        @NumMCQ    = 2,
        @NumTF     = 1,
        @NewExamID = @EID OUTPUT;
END TRY
BEGIN CATCH
    PRINT 'ERROR (expected): ' + ERROR_MESSAGE();
END CATCH;
GO

-- ── Test 5: Non-existent CourseID ───────────────────────────
DECLARE @EID INT;
BEGIN TRY
    EXEC GenerateExam
        @CourseID  = 9999,
        @ExamName  = N'Ghost Course Exam',
        @NumMCQ    = 2,
        @NumTF     = 1,
        @NewExamID = @EID OUTPUT;
END TRY
BEGIN CATCH
    PRINT 'ERROR (expected): ' + ERROR_MESSAGE();
END CATCH;
GO
