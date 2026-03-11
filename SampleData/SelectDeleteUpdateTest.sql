USE ITI_ExaminationDB;
GO

/*====================================================
=                BRANCH PROCEDURES TEST              =
====================================================*/

-----------------------------
-- Select all branches
-----------------------------
EXEC SelectBranch;
GO

-----------------------------
-- Select one branch by ID
-----------------------------
EXEC SelectBranch @BranchID = 1;
GO

-----------------------------
-- Update branch
-----------------------------
EXEC UpdateBranch
    @BranchID = 1,
    @BranchName = 'Smart Village Updated',
    @Location = '6th October';
GO

-----------------------------
-- Verify branch update
-----------------------------
EXEC SelectBranch @BranchID = 1;
GO

-----------------------------
-- Delete branch
-- Use an ID that is safe to delete
-----------------------------
EXEC InsertBranch
    @BranchName = 'Temporary Branch',
    @Location = 'Temporary Location';
GO

-- Check inserted temporary branch
EXEC SelectBranch;
GO

-- Delete the temporary branch
-- Replace 6 with the actual ID if needed
EXEC DeleteBranch @BranchID = 6;
GO

-----------------------------
-- Verify delete
-----------------------------
EXEC SelectBranch;
GO


/*====================================================
=                 TRACK PROCEDURES TEST              =
====================================================*/

-----------------------------
-- Select all tracks
-----------------------------
EXEC SelectByBranch;
GO

-----------------------------
-- Select tracks by BranchID
-----------------------------
EXEC SelectByBranch @BranchID = 1;
GO

-----------------------------
-- Select one track by TrackID
-----------------------------
EXEC SelectByBranch @TrackID = 1;
GO

-----------------------------
-- Update track
-----------------------------
EXEC UpdateTrack
    @TrackID = 1,
    @TrackName = 'Software Testing Updated',
    @BranchID = 1,
    @DurationMonths = 6;
GO

-----------------------------
-- Verify track update
-----------------------------
EXEC SelectByBranch @TrackID = 1;
GO

-----------------------------
-- Delete track
-- First insert a temporary track
-----------------------------
EXEC InsertTrack
    @TrackName = 'Temporary Track',
    @BranchID = 1,
    @DurationMonths = 4;
GO

-- Check all tracks
EXEC SelectByBranch;
GO

-- Delete temporary track
-- Replace 9 with the actual ID if needed
EXEC DeleteTrack @TrackID = 9;
GO

-----------------------------
-- Verify delete
-----------------------------
EXEC SelectByBranch;
GO


/*====================================================
=                COURSE PROCEDURES TEST             =
====================================================*/

-----------------------------
-- Select all courses
-----------------------------
EXEC SelectByTrack;
GO

-----------------------------
-- Select one course by CourseID
-----------------------------
EXEC SelectByTrack @CourseID = 1;
GO

-----------------------------
-- Select courses by TrackID
-----------------------------
EXEC SelectByTrack @TrackID = 1;
GO

-----------------------------
-- Update course
-----------------------------
EXEC UpdateCourse
    @CourseID = 1,
    @CourseName = 'Manual Testing Updated',
    @MinDegree = 60,
    @MaxDegree = 100;
GO

-----------------------------
-- Verify course update
-----------------------------
EXEC SelectByTrack @CourseID = 1;
GO

-----------------------------
-- Delete course
-- First insert a temporary course
-----------------------------
EXEC InsertCourse
    @CourseName = 'Temporary Course',
    @MinDegree = 50,
    @MaxDegree = 100;
GO

-- Check all courses
EXEC SelectByTrack;
GO

-- Delete temporary course
-- Replace 13 with the actual ID if needed
EXEC DeleteCourse @CourseID = 13;
GO

-----------------------------
-- Verify delete
-----------------------------
EXEC SelectByTrack;
GO