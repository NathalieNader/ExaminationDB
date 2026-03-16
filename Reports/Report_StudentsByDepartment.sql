USE ITI_ExaminationDB;
GO

-- Purpose : Report all students associated with a given department number
--           A student is linked to a department through:
--           Instructor → Instructor_Course → Course → Track_Course → Track → Student_Track → Student
-- Inputs  : @DepartmentNo INT
-- Output  : StudentID, StudentName, Email, Phone, TrackName, BranchName
CREATE PROCEDURE Report_StudentsByDepartment
    @DepartmentNo INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @DepartmentNo IS NULL
    BEGIN
        RAISERROR('DepartmentNo cannot be null.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE DepartmentNo = @DepartmentNo)
    BEGIN
        RAISERROR('No instructors found for this department.', 16, 1);
        RETURN;
    END

    SELECT DISTINCT
        s.StudentID,
        s.StudentName  AS Name,
        s.Email,
        s.Phone,
        t.TrackName,
        b.BranchName
    FROM Instructor i
    JOIN Instructor_Course ic ON i.InstructorID  = ic.InstructorID
    JOIN Track_Course      tc ON ic.CourseID      = tc.CourseID
    JOIN Track              t  ON tc.TrackID       = t.TrackID
    JOIN Student_Track     st  ON t.TrackID        = st.TrackID
    JOIN Student            s  ON st.StudentID     = s.StudentID
    JOIN Branch             b  ON t.BranchID       = b.BranchID
    WHERE i.DepartmentNo = @DepartmentNo
    ORDER BY s.StudentName;

END;
GO