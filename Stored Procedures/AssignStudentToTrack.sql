USE ITI_ExaminationDB;
GO

-- ============================================================
-- AssignStudentToTrack
-- ------------------------------------------------------------
-- Purpose : Assigns a student to a track by inserting a row
--           into the Student_Track junction table.
--           Prevents duplicate assignments.
-- Inputs  : @StudentID  INT  - FK to Student table
--           @TrackID    INT  - FK to Track table
-- Outputs : PRINT success message
-- ============================================================

CREATE PROCEDURE AssignStudentToTrack
    @StudentID INT,
    @TrackID   INT
AS
BEGIN
    SET NOCOUNT ON;

    -- ── NULL Validation ──────────────────────────────────────
    IF @StudentID IS NULL
        THROW 50108, 'AssignStudentToTrack: @StudentID cannot be NULL.', 1;

    IF @TrackID IS NULL
        THROW 50109, 'AssignStudentToTrack: @TrackID cannot be NULL.', 1;

    -- ── Check Student exists ─────────────────────────────────
    IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
        THROW 50110, 'AssignStudentToTrack: @StudentID does not match any existing student.', 1;

    -- ── Check Track exists ───────────────────────────────────
    IF NOT EXISTS (SELECT 1 FROM Track WHERE TrackID = @TrackID)
        THROW 50111, 'AssignStudentToTrack: @TrackID does not match any existing track.', 1;

    -- ── Check not already assigned ───────────────────────────
    IF EXISTS (
        SELECT 1 FROM Student_Track
        WHERE StudentID = @StudentID AND TrackID = @TrackID
    )
        THROW 50112, 'AssignStudentToTrack: This student is already assigned to this track.', 1;

    -- ── Insert into junction table ───────────────────────────
    BEGIN TRY
        BEGIN TRANSACTION

            INSERT INTO Student_Track (StudentID, TrackID)
            VALUES (@StudentID, @TrackID);

            PRINT 'Student successfully assigned to track.';

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
