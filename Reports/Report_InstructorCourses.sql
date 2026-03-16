-- Purpose : Report all courses taught by a given instructor
--           and the number of students in the related tracks
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

    SELECT
        c.CourseName,
        t.TrackName,
        COUNT(st.StudentID) AS StudentCount
    FROM Instructor_Course ic
    JOIN Course c ON ic.CourseID = c.CourseID
    JOIN Track_Course tc ON c.CourseID = tc.CourseID
    JOIN Track t ON tc.TrackID = t.TrackID
    LEFT JOIN Student_Track st ON t.TrackID = st.TrackID
    WHERE ic.InstructorID = @InstructorID
    GROUP BY c.CourseName, t.TrackName
    ORDER BY c.CourseName, t.TrackName;
END;
GO