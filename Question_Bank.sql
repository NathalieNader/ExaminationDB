-- InsertQuestion
-- Purpose : Inserts a new question (MCQ or TF) into the
--           Question table.
-- Inputs  : @CourseID      INT            - FK to Course table
--           @QuestionText  NVARCHAR(MAX)  - Body of the question
--           @QuestionType  NVARCHAR(10)   - 'MCQ' or 'TF'
--           @Points        INT            - Mark value
-- Outputs : @NewQuestionID INT OUTPUT     - PK of the new row

CREATE PROCEDURE InsertQuestion
    @CourseID       INT,
    @QuestionText   NVARCHAR(MAX),
    @QuestionType   NVARCHAR(10),
    @Points         INT,
    @NewQuestionID  INT OUTPUT
AS
BEGIN
    IF @CourseID IS NULL
        THROW 50001, 'InsertQuestion: @CourseID cannot be NULL.', 1;
    IF @QuestionText IS NULL
        THROW 50002, 'InsertQuestion: @QuestionText cannot be NULL.', 1;
    IF @QuestionType IS NULL
        THROW 50003, 'InsertQuestion: @QuestionType cannot be NULL.', 1;
    IF @Points IS NULL
        THROW 50004, 'InsertQuestion: @Points cannot be NULL.', 1;
    IF @QuestionType NOT IN ('MCQ', 'TF')
        THROW 50005, 'InsertQuestion: @QuestionType must be ''MCQ'' or ''TF''.', 1;
 
    IF @Points < 0
        THROW 50006, 'InsertQuestion: @Points cannot be negative.', 1;
    BEGIN TRY
        BEGIN TRAN;
 
            INSERT INTO Question (CourseID, QuestionText, QuestionType, Points)
            VALUES (@CourseID, @QuestionText, @QuestionType, @Points);
 
            SET @NewQuestionID = SCOPE_IDENTITY();
 
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO
 

--InsertOption
-- ------------------------------------------------------------
-- Purpose : Inserts a single answer option for a question.
--           Enforces a maximum of 4 options for MCQ questions
--           and 2 options for TF questions.
-- Inputs  : @QuestionID   INT            - FK to Question table
--           @OptionText   NVARCHAR(MAX)  - Text of the option
--           @OptionOrder  INT            - Display order
--                                         (1–4 for MCQ, 1–2 for TF)
-- Outputs : @NewOptionID  INT OUTPUT     - PK of the new row
CREATE PROCEDURE InsertOption
	@QuestionID   INT          
	@OptionText   NVARCHAR(MAX)  
	@OptionOrder  INT
	@NewOptionID  INT OUTPUT
	
AS
BEGIN
	 IF @QuestionID IS NULL
        THROW 50007, 'InsertOption: @QuestionID cannot be NULL.', 1;
    IF @OptionText IS NULL
        THROW 50008, 'InsertOption: @OptionText cannot be NULL.', 1;
    IF @OptionOrder IS NULL
        THROW 50009, 'InsertOption: @OptionOrder cannot be NULL.', 1;


	DECLARE @QuestionType VARCHAR(10);
		SELECT  @QuestionType = QuestionType
		from Question	
	   	where Questionid = @QuestionID
	   	
	   	
	 IF @QuestionType IS NULL
        THROW 50010, 'InsertOption: @QuestionID does not match any existing question.', 1;
 	 DECLARE @ExistingCount INT;
	 SELECT @ExistingCount = COUNT(*)
	 FROM [Option] o 
	 WHERE QuestionID = @QuestionID
	   	  
	   	  
    IF @QuestionType = 'MCQ' 
    BEGIN 
    	IF @ExcistingCount >=4
    	  THROW 50011, 'InsertOption: MCQ questions cannot have more than 4 options.', 1;
    	IF @OptionOrder NOT BETWEEN 1 AND 4 
    	  THROW 50012, 'InsertOption: @OptionOrder for MCQ must be between 1 and 4.', 1;
    END
     IF @QuestionType = 'TF'
     Begin
     	IF @ExcistingCount >=2
    	  THROW 50011, 'InsertOption: TF questions cannot have more than 2 options.', 1;
    	IF @OptionOrder NOT BETWEEN 1 AND 2 
    	  THROW 50012, 'InsertOption: @OptionOrder for TF must be 1 OR 2.', 1;
     END
     
    
    
    
    
BEGIN TRY
        BEGIN TRAN;
 
            INSERT INTO [Option] (QuestionID, OptionText, OptionOrder)
            VALUES (@QuestionID, @OptionText, @OptionOrder);
 
            SET @NewOptionID = SCOPE_IDENTITY();
 
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
GO


