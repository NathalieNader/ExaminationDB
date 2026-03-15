USE ITI_ExaminationDB;
GO

-- ============================================================
-- RemoveInstructorFromCourse
-- ------------------------------------------------------------
-- Purpose : Removes an instructor-course assignment from the
--           Instructor_Course junction table.
-- Inputs  : @InstructorID  INT  - FK to Instructor table
--           @CourseID      INT  - FK to Course table
-- Outputs : PRINT success message
-- ============================================================
 
CREATE PROCEDURE RemoveInstructorFromCourse
    @InstructorID INT,
    @CourseID     INT
AS
BEGIN
    SET NOCOUNT ON;
 
    -- ── NULL Validation ──────────────────────────────────────
    IF @InstructorID IS NULL
        THROW 50035, 'RemoveInstructorFromCourse: @InstructorID cannot be NULL.', 1;
 
    IF @CourseID IS NULL
        THROW 50036, 'RemoveInstructorFromCourse: @CourseID cannot be NULL.', 1;
 
    -- ── Check assignment exists before deleting ───────────────
    IF NOT EXISTS (
        SELECT 1 FROM Instructor_Course
        WHERE InstructorID = @InstructorID AND CourseID = @CourseID
    )
        THROW 50037, 'RemoveInstructorFromCourse: No assignment found for this instructor and course.', 1;
 
    -- ── Delete from junction table ───────────────────────────
    BEGIN TRY
        BEGIN TRANSACTION
 
            DELETE FROM Instructor_Course
            WHERE InstructorID = @InstructorID AND CourseID = @CourseID;
 
            PRINT 'Instructor successfully removed from course.';
 
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
