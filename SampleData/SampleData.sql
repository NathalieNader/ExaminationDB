USE ITI_ExaminationDB;
GO

--------------------------------------------------
-- 1) Branch sample data
--------------------------------------------------
INSERT INTO Branch (BranchName, Location)
VALUES
('Smart Village', 'Giza'),
('Alexandria', 'Alexandria'),
('Assiut', 'Upper Egypt'),
('New Capital', 'Cairo'),
('Menofia', 'Shebin El-Kom');
GO

--------------------------------------------------
-- 2) Track sample data
-- Assumes Track has: TrackName, BranchID
--------------------------------------------------
INSERT INTO Track (TrackName, BranchID)
VALUES
('Software Testing', 1),
('AI & Data Science', 1),
('Web Development', 2),
('Cloud Computing', 2),
('Cyber Security', 3),
('Embedded Systems', 4),
('UI/UX Design', 5),
('Full Stack Development', 5);
GO

--------------------------------------------------
-- 3) Course sample data
-- Matches your actual columns:
-- CourseName, MinDegree, MaxDegree
--------------------------------------------------
INSERT INTO Course (CourseName, MinDegree, MaxDegree)
VALUES
('Manual Testing',        50, 100),
('Automation Testing',    50, 100),
('SQL Server',            50, 100),
('Database Fundamentals', 50, 100),
('Python Programming',    50, 100),
('Machine Learning',      50, 100),
('HTML & CSS',            50, 100),
('JavaScript',            50, 100),
('Cloud Fundamentals',    50, 100),
('Cyber Security Basics', 50, 100),
('UI/UX Principles',      50, 100),
('OOP using C#',          50, 100);
GO
/*Data mapping*/
INSERT INTO Track_Course (TrackID, CourseID)
VALUES
-- Software Testing
(1, 1),
(1, 2),
(1, 3),
(1, 4),

-- AI & Data Science
(2, 4),
(2, 5),
(2, 6),

-- Web Development
(3, 7),
(3, 8),
(3, 4),

-- Cloud Computing
(4, 9),
(4, 4),

-- Cyber Security
(5, 10),
(5, 3),

-- Embedded Systems
(6, 12),

-- UI/UX Design
(7, 11),

-- Full Stack Development
(8, 7),
(8, 8),
(8, 4),
(8, 12);
GO