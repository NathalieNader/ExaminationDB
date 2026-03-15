USE ITI_ExaminationDB 
GO




--Purpose : Records a student's exam attempt by

-- Inputs  : @StudentID   INT            - FK to Student table
--           @ExamID      INT            - FK to Exam table
--           @StartTime   DATETIME       - When the attempt began
--           @EndTime     DATETIME       - When the attempt ended
--           @AnswersXML  XML            - Answer payload, e.g.:
--             <Answers>
--               <Answer>
--                 <QuestionID>1</QuestionID>
--                 <ChosenOptionID>4</ChosenOptionID>
--               </Answer>
--               <Answer>
--                 <QuestionID>2</QuestionID>
--                 <ChosenOptionID></ChosenOptionID>  <!-- skipped -->
--               </Answer>
--             </Answers>
-- Outputs : @StudentExamID INT OUTPUT   - PK of the new
--                                         StudentExam row
CREATE PROCEDURE SubmitExamAnswers
    @StudentID  INT,
    @ExamID     INT,
    @StartTime  DATETIME,
    @EndTime    DATETIME,
    @Answers    XML
AS
BEGIN
 
    IF @StudentID IS NULL  
   		THROW 50100, 'SubmitExamAnswers: @StudentID cannot be NULL.', 1;
    IF @ExamID IS NULL  
  		THROW 50101, 'SubmitExamAnswers: @ExamID cannot be NULL.', 1;
    IF @StartTime IS NULL 
   		THROW 50102, 'SubmitExamAnswers: @StartTime cannot be NULL.', 1;
    IF @EndTime IS NULL    
   		THROW 50103, 'SubmitExamAnswers: @EndTime cannot be NULL.', 1;
    IF @Answers IS NULL    
   		THROW 50104, 'SubmitExamAnswers: @Answers cannot be NULL.', 1;

    
    IF @EndTime < @StartTime
        THROW 50105, 'SubmitExamAnswers: @EndTime cannot be earlier than @StartTime.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.Student WHERE StudentID = @StudentID)
        THROW 50106, 'SubmitExamAnswers: @StudentID does not exist.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.Exam WHERE ExamID = @ExamID)
        THROW 50107, 'SubmitExamAnswers: @ExamID does not exist.', 1;

    DECLARE @StudentExamID INT; 

    BEGIN TRY
        BEGIN TRANSACTION;

            INSERT INTO StudentExam (StudentID, ExamID, StartTime, EndTime)
            VALUES (@StudentID, @ExamID, @StartTime, @EndTime);

            SET @StudentExamID = SCOPE_IDENTITY();

            INSERT INTO StudentAnswer (StudentExamID, QuestionID, ChosenOptionID)
            SELECT
                @StudentExamID,
                T.Item.value('(QuestionID)[1]', 'INT'),
                T.Item.value('(ChosenOptionID)[1]', 'INT')
            FROM @Answers.nodes('/Answers/Answer') AS T(Item)
            WHERE T.Item.value('(ChosenOptionID)[1]', 'INT') IS NOT NULL;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;  
    END CATCH
END;