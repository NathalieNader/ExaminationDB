-- Purpose : Return courses taught by a specific instructor,
--           with track name and number of students in each track
-- Inputs  : @InstructorID INT
-- Output  : CourseName, TrackName, StudentCount
CREATE PROCEDURE Report_InstructorCourses
    @InstructorID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @InstructorID IS NULL
    BEGIN
        RAISERROR('InstructorID cannot be null.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE InstructorID = @InstructorID)
    BEGIN
        RAISERROR('Instructor not found.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION

            SELECT
                C.CourseName,
                T.TrackName,
                COUNT(ST.StudentID) AS StudentCount
            FROM Instructor_Course IC
            INNER JOIN Course C
                ON IC.CourseID = C.CourseID
            INNER JOIN Track_Course TC
                ON C.CourseID = TC.CourseID
            INNER JOIN Track T
                ON TC.TrackID = T.TrackID
            LEFT JOIN Student_Track ST
                ON T.TrackID = ST.TrackID
            WHERE IC.InstructorID = @InstructorID
            GROUP BY C.CourseName, T.TrackName
            ORDER BY C.CourseName, T.TrackName;

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO