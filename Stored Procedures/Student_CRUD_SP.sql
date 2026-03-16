USE ITI_ExaminationDB
GO

-- Purpose : Insert a new Student
-- Inputs  : @StudentID INT,
--			 @StudentName  NVARCHAR(100),		
--           @Email          NVARCHAR,
--           @Phone  NVARCHAR(20)
-- Output  : NewStudentID via SCOPE_IDENTITY()
CREATE StudentInsert 
@StudentID  INT,
@StudentName  NVARCHAR(100), 
@Email  NVARCHAR,
@Phone  NVARCHAR(20)
@NewStudentID  INT OUTPUT
AS
Begin 
	 IF @StudentID IS NULL
        THROW 500200, 'StudentInsert: @StudentID cannot be NULL.', 1;
     IF @StudentName IS NULL
        THROW 500201, 'InsertStudent: @StudentName cannot be NULL.', 1;
     IF @Email IS NULL
        THROW 500203, 'InsertStudent: @Email cannot be NULL.', 1;
     IF @Phone IS NULL
        THROW 500204, 'InsertStudent: @Phone cannot be NULL.', 1;

	IF EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
        THROW 500205, 'StudentInsert: An Student with this email already exists.', 1;

 	
BEGIN TRY
        BEGIN TRAN;
 
            INSERT INTO Student (StudentID, StudentName, Email,Phone)
            VALUES (@StudentID, @StudentName, @Email,@Phone);
            
            
            SET @NewStudentID = SCOPE_IDENTITY();
 
			           
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO



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

    DECLARE @RowsAffected INT;  

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








