USE ITI_ExaminationDB;
GO

CREATE OR ALTER PROCEDURE DeleteCourse
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @CourseID IS NULL
    BEGIN
        RAISERROR('CourseID cannot be null.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
    BEGIN
        RAISERROR('Course not found.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Question WHERE CourseID = @CourseID)
    BEGIN
        RAISERROR('Cannot delete course: questions are linked to it.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Exam WHERE CourseID = @CourseID)
    BEGIN
        RAISERROR('Cannot delete course: existing exams are linked to it.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION

            DELETE FROM Course
            WHERE CourseID = @CourseID;

            PRINT 'Course deleted successfully.';

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO