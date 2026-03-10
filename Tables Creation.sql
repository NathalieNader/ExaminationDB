CREATE DATABASE Examination;

USE Examination;

CREATE TABLE Branch (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(200)
);

CREATE TABLE Track (
    TrackID INT PRIMARY KEY IDENTITY(1,1),
    TrackName NVARCHAR(100) NOT NULL,
    BranchID INT FOREIGN KEY REFERENCES Branch(BranchID),
    DurationMonths INT
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(100) NOT NULL,
    MinDegree INT,
    MaxDegree INT
);

CREATE TABLE Track_Course (
    TrackID INT FOREIGN KEY REFERENCES Track(TrackID),
    CourseID INT FOREIGN KEY REFERENCES Course(CourseID),
    CONSTRAINT PK_TrackCourse PRIMARY KEY (TrackID, CourseID)
);

CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY IDENTITY(1,1),
    InstructorName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) UNIQUE,
    DepartmentNo INT 
);

CREATE TABLE Instructor_Course (
    InstructorID INT FOREIGN KEY REFERENCES Instructor(InstructorID),
    CourseID INT FOREIGN KEY REFERENCES Course(CourseID),
    CONSTRAINT PK_InstructorCourse PRIMARY KEY (InstructorID, CourseID) 
);

CREATE TABLE Student (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    StudentName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) UNIQUE,
    Phone NVARCHAR(20) 
);

CREATE TABLE Student_Track (
    StudentID INT FOREIGN KEY REFERENCES Student(StudentID),
    TrackID INT FOREIGN KEY REFERENCES Track(TrackID),
    CONSTRAINT PK_StudentTrack PRIMARY KEY (StudentID, TrackID) 
);

CREATE TABLE Question (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    CourseID INT FOREIGN KEY REFERENCES Course(CourseID),
    QuestionText NVARCHAR(MAX) NOT NULL,
    QuestionType NVARCHAR(10) CHECK (QuestionType IN ('MCQ', 'TF')),
    Points INT 
);

CREATE TABLE [Option] (
    OptionID INT PRIMARY KEY IDENTITY(1,1),
    QuestionID INT FOREIGN KEY REFERENCES Question(QuestionID) ON DELETE CASCADE,
    OptionText NVARCHAR(MAX) NOT NULL,
    OptionOrder INT
);

CREATE TABLE ModelAnswer (
    ModelAnswerID INT PRIMARY KEY IDENTITY(1,1),
    QuestionID INT UNIQUE FOREIGN KEY REFERENCES Question(QuestionID),
    OptionID INT FOREIGN KEY REFERENCES [Option](OptionID)
);

CREATE TABLE Exam (
    ExamID INT PRIMARY KEY IDENTITY(1,1),
    ExamName NVARCHAR(150),
    CourseID INT FOREIGN KEY REFERENCES Course(CourseID),
    CreatedDate DATETIME DEFAULT GETDATE(),
    TotalQuestions INT 
);

CREATE TABLE Exam_Question (
    ExamID INT FOREIGN KEY REFERENCES Exam(ExamID),
    QuestionID INT FOREIGN KEY REFERENCES Question(QuestionID),
    OrderNo INT,
    CONSTRAINT PK_ExamQuestion PRIMARY KEY (ExamID, QuestionID) 
);

CREATE TABLE StudentExam (
    StudentExamID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN KEY REFERENCES Student(StudentID),
    ExamID INT FOREIGN KEY REFERENCES Exam(ExamID),
    StartTime DATETIME,
    EndTime DATETIME,
    TotalGrade INT 
);

CREATE TABLE StudentAnswer (
    StudentAnswerID INT PRIMARY KEY IDENTITY(1,1),
    StudentExamID INT FOREIGN KEY REFERENCES StudentExam(StudentExamID),
    QuestionID INT FOREIGN KEY REFERENCES Question(QuestionID),
    ChosenOptionID INT FOREIGN KEY REFERENCES [Option](OptionID) 
);