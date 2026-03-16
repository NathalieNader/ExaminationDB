USE ITI_ExaminationDB
GO

-- ------------------------------------------------------------
-- Purpose : Insert a new Student
-- Inputs  : @StudentName  NVARCHAR(100),		
--           @Email        NVARCHAR(255),
--           @Phone  NVARCHAR(20)
-- Output  : NewStudentID via SCOPE_IDENTITY()
-- ============================================================
 
CREATE PROCEDURE InsertStudent
    @StudentName  NVARCHAR(100),
    @Email        NVARCHAR(255),
    @Phone        NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
 
    -- ── NULL Validation ──────────────────────────────────────
    IF @StudentName IS NULL
        THROW 50020, 'InsertStudent: @StudentName cannot be NULL.', 1;
 
    IF @Email IS NULL
        THROW 50021, 'InsertStudent: @Email cannot be NULL.', 1;
 
    IF @Phone IS NULL
        THROW 50022, 'InsertStudent: @Phone cannot be NULL.', 1;
 
    -- ── Duplicate Email Check ────────────────────────────────
    IF EXISTS (SELECT 1 FROM Student WHERE Email = @Email)
        THROW 50023, 'InsertStudent: A student with this email already exists.', 1;
 
    -- ── Insert ───────────────────────────────────────────────
    BEGIN TRY
        BEGIN TRANSACTION
 
            INSERT INTO Student (StudentName, Email, Phone)
            VALUES (@StudentName, @Email, @Phone);
 
            SELECT SCOPE_IDENTITY() AS NewStudentID;
 
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


-- ============================================================
-- UpdateStudent
-- ------------------------------------------------------------
-- Purpose : Updates one or more fields for an existing student.
--           Only fields passed as non-NULL will be updated —
--           any NULL parameter keeps the existing value.
-- Inputs  : @StudentID    INT           - PK of the student to update (required)
--           @StudentName  NVARCHAR(100) - New name          (optional)
--           @Email        NVARCHAR(255) - New email         (optional)
--           @Phone        NVARCHAR(20)  - New phone number  (optional)
-- Outputs : @RowsAffected INT OUTPUT   - 1 if updated, 0 if student not found
-- ============================================================
CREATE PROCEDURE UpdateStudent
    @StudentID    INT,
    @StudentName  NVARCHAR(100) = NULL,
    @Email        NVARCHAR(255) = NULL,
    @Phone        NVARCHAR(20)  = NULL,
    @RowsAffected INT OUTPUT
AS
BEGIN
    IF @StudentID IS NULL
        THROW 50206, 'UpdateStudent: @StudentID cannot be NULL.', 1;

    IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
    BEGIN
        SET @RowsAffected = 0;
        RETURN;
    END

    BEGIN TRY
        BEGIN TRAN;

            UPDATE Student
            SET
                StudentName = ISNULL(@StudentName, StudentName),
                Email       = ISNULL(@Email, Email),
                Phone       = ISNULL(@Phone, Phone)
            WHERE StudentID = @StudentID;

            SET @RowsAffected = @@ROWCOUNT;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO

-- ============================================================
-- DeleteStudent
-- ------------------------------------------------------------
-- Purpose : Deletes a student from the Student table.
--           Cascades to Student_Track automatically.
--           StudentExam records are kept (NO ACTION FK) for
--           historical grade preservation.
-- Inputs  : @StudentID    INT         - PK of the student to delete (required)
-- Outputs : @RowsAffected INT OUTPUT  - 1 if deleted, 0 if student not found
-- ============================================================
CREATE PROCEDURE DeleteStudent
    @StudentID    INT,
    @RowsAffected INT OUTPUT
AS
BEGIN

    IF @StudentID IS NULL
        THROW 50300, 'DeleteStudent: @StudentID cannot be NULL.', 1;


    IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
    BEGIN
        SET @RowsAffected = 0;
        RETURN;
    END

    BEGIN TRY
        BEGIN TRAN;

            DELETE FROM Student
            WHERE StudentID = @StudentID;
            SET @RowsAffected = @@ROWCOUNT;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO