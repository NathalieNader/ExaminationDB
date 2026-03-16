-- Purpose : Report all grades for a given student
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

    SELECT
        c.CourseName,
        e.ExamName,
        se.TotalGrade,
        c.MaxDegree,
        CAST(se.TotalGrade AS FLOAT) / c.MaxDegree * 100 AS Percentage
    FROM StudentExam se
    JOIN Exam e ON se.ExamID = e.ExamID
    JOIN Course c ON e.CourseID = c.CourseID
    WHERE se.StudentID = @StudentID
    ORDER BY c.CourseName, e.ExamName;
END;
GO