-- Purpose : Return all grades for a specific student
-- Inputs  : @StudentID INT
-- Output  : CourseName, ExamName, TotalGrade, MaxDegree, Percentage
CREATE PROCEDURE Report_StudentGrades
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @StudentID IS NULL
    BEGIN
        RAISERROR('StudentID cannot be null.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
    BEGIN
        RAISERROR('Student not found.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION

            SELECT
                C.CourseName,
                E.ExamName,
                SE.TotalGrade,
                C.MaxDegree,
                CAST(SE.TotalGrade AS FLOAT) / C.MaxDegree * 100 AS Percentage
            FROM StudentExam SE
            INNER JOIN Exam E
                ON SE.ExamID = E.ExamID
            INNER JOIN Course C
                ON E.CourseID = C.CourseID
            WHERE SE.StudentID = @StudentID
            ORDER BY C.CourseName, E.ExamName;

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO