SE ITI_ExaminationDB;
GO
 
-- ============================================================
-- AssignInstructorToCourse
-- ------------------------------------------------------------
-- Purpose : Assigns an instructor to a course by inserting a
--           row into the Instructor_Course junction table.
--           Prevents duplicate assignments silently.
-- Inputs  : @InstructorID  INT  - FK to Instructor table
--           @CourseID      INT  - FK to Course table
-- Outputs : PRINT success message
-- ============================================================
 
CREATE PROCEDURE AssignInstructorToCourse
    @InstructorID INT,
    @CourseID     INT
AS
BEGIN
    SET NOCOUNT ON;
 
    -- ── NULL Validation ──────────────────────────────────────
    IF @InstructorID IS NULL
        THROW 50030, 'AssignInstructorToCourse: @InstructorID cannot be NULL.', 1;
 
    IF @CourseID IS NULL
        THROW 50031, 'AssignInstructorToCourse: @CourseID cannot be NULL.', 1;
 
    -- ── Check Instructor exists ──────────────────────────────
    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE InstructorID = @InstructorID)
        THROW 50032, 'AssignInstructorToCourse: @InstructorID does not match any existing instructor.', 1;
 
    -- ── Check Course exists ──────────────────────────────────
    IF NOT EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
        THROW 50033, 'AssignInstructorToCourse: @CourseID does not match any existing course.', 1;
 
    -- ── Check not already assigned ───────────────────────────
    IF EXISTS (
        SELECT 1 FROM Instructor_Course
        WHERE InstructorID = @InstructorID AND CourseID = @CourseID
    )
        THROW 50034, 'AssignInstructorToCourse: This instructor is already assigned to this course.', 1;
 
    -- ── Insert into junction table ───────────────────────────
    BEGIN TRY
        BEGIN TRANSACTION
 
            INSERT INTO Instructor_Course (InstructorID, CourseID)
            VALUES (@InstructorID, @CourseID);
 
            PRINT 'Instructor successfully assigned to course.';
 
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO