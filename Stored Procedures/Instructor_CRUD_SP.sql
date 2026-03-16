USE ITI_ExaminationDB;
GO

-- -------------------------------------------------------
-- Purpose : Insert a new instructor
-- Inputs  : @InstructorName NVARCHAR(100),
--           @Email          NVARCHAR(150),
--           @DepartmentNo   INT
-- Output  : New InstructorID via SCOPE_IDENTITY()
-- -------------------------------------------------------
CREATE PROCEDURE InsertInstructor
    @InstructorName NVARCHAR(100),
    @Email          NVARCHAR(150),
    @DepartmentNo   INT
AS
BEGIN
    SET NOCOUNT ON;

    -- ── Validation ───────────────────────────────────────────
    IF @InstructorName IS NULL OR LTRIM(RTRIM(@InstructorName)) = ''
        THROW 50070, 'InsertInstructor: @InstructorName cannot be empty.', 1;

    IF @Email IS NULL OR LTRIM(RTRIM(@Email)) = ''
        THROW 50071, 'InsertInstructor: @Email cannot be empty.', 1;

    IF @DepartmentNo IS NULL
        THROW 50072, 'InsertInstructor: @DepartmentNo cannot be null.', 1;

    -- ── Check duplicate email ─────────────────────────────────
    IF EXISTS (SELECT 1 FROM Instructor WHERE Email = @Email)
        THROW 50073, 'InsertInstructor: An instructor with this email already exists.', 1;

    BEGIN TRY
        BEGIN TRANSACTION

            INSERT INTO Instructor (InstructorName, Email, DepartmentNo)
            VALUES (@InstructorName, @Email, @DepartmentNo);

            SELECT SCOPE_IDENTITY() AS NewInstructorID;

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- -------------------------------------------------------
-- Purpose : Update an existing instructor's details
-- Inputs  : @InstructorID   INT,
--           @InstructorName NVARCHAR(100),
--           @Email          NVARCHAR(150),
--           @DepartmentNo   INT
-- Output  : Success / error message
-- -------------------------------------------------------
CREATE PROCEDURE UpdateInstructor
    @InstructorID   INT,
    @InstructorName NVARCHAR(100),
    @Email          NVARCHAR(150),
    @DepartmentNo   INT
AS
BEGIN
    SET NOCOUNT ON;

    -- ── Validation ───────────────────────────────────────────
    IF @InstructorID IS NULL
        THROW 50074, 'UpdateInstructor: @InstructorID cannot be null.', 1;

    IF @InstructorName IS NULL OR LTRIM(RTRIM(@InstructorName)) = ''
        THROW 50075, 'UpdateInstructor: @InstructorName cannot be empty.', 1;

    IF @Email IS NULL OR LTRIM(RTRIM(@Email)) = ''
        THROW 50076, 'UpdateInstructor: @Email cannot be empty.', 1;

    IF @DepartmentNo IS NULL
        THROW 50077, 'UpdateInstructor: @DepartmentNo cannot be null.', 1;

    -- ── Check instructor exists ───────────────────────────────
    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE InstructorID = @InstructorID)
        THROW 50078, 'UpdateInstructor: Instructor not found.', 1;

    -- ── Check new email not taken by another instructor ───────
    IF EXISTS (
        SELECT 1 FROM Instructor
        WHERE  Email        = @Email
          AND  InstructorID <> @InstructorID
    )
        THROW 50079, 'UpdateInstructor: This email is already used by another instructor.', 1;

    BEGIN TRY
        BEGIN TRANSACTION

            UPDATE Instructor
            SET InstructorName = @InstructorName,
                Email          = @Email,
                DepartmentNo   = @DepartmentNo
            WHERE InstructorID = @InstructorID;

            PRINT 'Instructor updated successfully.';

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
