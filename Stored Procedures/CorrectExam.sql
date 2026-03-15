
uSE ITI_ExaminationDB;
GO
-- ============================================================
-- CorrectExam
-- ------------------------------------------------------------
-- Purpose : Grades a student exam by comparing each submitted
--           answer against the ModelAnswer table.
--           Skipped questions (no row in StudentAnswer) score 0.
--           Updates TotalGrade in StudentExam when done.
-- Inputs  : @StudentExamID  INT            - PK of StudentExam row
-- Outputs : @TotalGrade     INT OUTPUT     - Final computed grade
-- Rules   : - Full transaction: ROLLBACK on any error
--           - Skipped questions earn 0 points automatically
--           - Uses LEFT JOIN so unanswered questions are included
-- ============================================================
 
CREATE PROCEDURE CorrectExam
    @StudentExamID  INT,
    @TotalGrade     INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
 
    -- ── NULL Validation ──────────────────────────────────────
    IF @StudentExamID IS NULL
        THROW 50040, 'CorrectExam: @StudentExamID cannot be NULL.', 1;
 
    -- ── Check StudentExam row exists ─────────────────────────
    IF NOT EXISTS (SELECT 1 FROM StudentExam WHERE StudentExamID = @StudentExamID)
        THROW 50041, 'CorrectExam: @StudentExamID does not match any existing student exam.', 1;
 
    -- ── Check exam has not already been graded ────────────────
    IF EXISTS (
        SELECT 1 FROM StudentExam
        WHERE  StudentExamID = @StudentExamID
          AND  TotalGrade    IS NOT NULL
    )
        THROW 50042, 'CorrectExam: This exam has already been graded.', 1;
 
    BEGIN TRY
        BEGIN TRANSACTION
 
            -- ── Grading Logic ─────────────────────────────────
            -- For every question in the exam:
            --   • If the student answered correctly  → add q.Points
            --   • If the student answered wrongly    → add 0
            --   • If the student skipped (LEFT JOIN gives NULL) → add 0
            SELECT @TotalGrade = ISNULL(SUM(
                CASE
                    WHEN sa.ChosenOptionID = ma.OptionID THEN q.Points
                    ELSE 0
                END
            ), 0)
            FROM  StudentExam     se
            JOIN  Exam_Question   eq  ON eq.ExamID      = se.ExamID
            JOIN  Question        q   ON q.QuestionID   = eq.QuestionID
            JOIN  ModelAnswer     ma  ON ma.QuestionID  = q.QuestionID
            LEFT JOIN StudentAnswer sa
                                  ON  sa.StudentExamID  = se.StudentExamID
                                  AND sa.QuestionID     = q.QuestionID
            WHERE se.StudentExamID = @StudentExamID;
 
            -- ── Write TotalGrade back to StudentExam ──────────
            UPDATE StudentExam
            SET    TotalGrade = @TotalGrade
            WHERE  StudentExamID = @StudentExamID;
 
            PRINT 'Exam graded successfully. TotalGrade = ' + CAST(@TotalGrade AS NVARCHAR);
 
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO