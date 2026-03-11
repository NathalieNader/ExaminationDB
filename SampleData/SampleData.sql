USE ITI_ExaminationDB;
GO

--------------------------------------------------
-- cleanup before inserting sample data
-- Run only if you want to start fresh
--------------------------------------------------
DELETE FROM Track_Course;
DELETE FROM Track;
DELETE FROM Course;
DELETE FROM Branch;
DBCC CHECKIDENT ('Track', RESEED, 0);
DBCC CHECKIDENT ('Course', RESEED, 0);
DBCC CHECKIDENT ('Branch', RESEED, 0);
GO


--------------------------------------------------
-- 1) Insert Branch sample data using CRUD procedure
--------------------------------------------------
EXEC InsertBranch @BranchName = 'Smart Village', @Location = 'Giza';
EXEC InsertBranch @BranchName = 'Alexandria',    @Location = 'Alexandria';
EXEC InsertBranch @BranchName = 'Assiut',        @Location = 'Upper Egypt';
EXEC InsertBranch @BranchName = 'New Capital',   @Location = 'Cairo';
EXEC InsertBranch @BranchName = 'Menofia',       @Location = 'Shebin El-Kom';
GO


--------------------------------------------------
-- 2) Insert Track sample data using CRUD procedure
-- Assumes Branch IDs are 1 to 5 after fresh insert
--------------------------------------------------
EXEC InsertTrack @TrackName = 'Software Testing',       @BranchID = 1, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'AI & Data Science',      @BranchID = 1, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Web Development',        @BranchID = 2, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Cloud Computing',        @BranchID = 2, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Cyber Security',         @BranchID = 3, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Embedded Systems',       @BranchID = 4, @DurationMonths = 9;
EXEC InsertTrack @TrackName = 'UI/UX Design',           @BranchID = 5, @DurationMonths = 4;
EXEC InsertTrack @TrackName = 'Full Stack Development', @BranchID = 5, @DurationMonths = 4;
GO


--------------------------------------------------
-- 3) Insert Course sample data using CRUD procedure
--------------------------------------------------
EXEC InsertCourse @CourseName = 'Manual Testing',         @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Automation Testing',     @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'SQL Server',             @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Database Fundamentals',  @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Python Programming',     @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Machine Learning',       @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'HTML & CSS',             @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'JavaScript',             @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Cloud Fundamentals',     @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'Cyber Security Basics',  @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'UI/UX Principles',       @MinDegree = 50, @MaxDegree = 100;
EXEC InsertCourse @CourseName = 'OOP using C#',           @MinDegree = 50, @MaxDegree = 100;
GO


--------------------------------------------------
-- 4) Map Tracks to Courses
-- Direct insert because no CRUD procedure was provided
--------------------------------------------------
INSERT INTO Track_Course (TrackID, CourseID)
VALUES
-- Software Testing
(1,1),
(1,2),
(1,3),
(1,4),

-- AI & Data Science
(2,4),
(2,5),
(2,6),

-- Web Development
(3,7),
(3,8),
(3,4),

-- Cloud Computing
(4,9),
(4,4),

-- Cyber Security
(5,10),
(5,3),

-- Embedded Systems
(6,12),

-- UI/UX Design
(7,11),

-- Full Stack Development
(8,7),
(8,8),
(8,4),
(8,12);
GO

