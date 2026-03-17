USE ITI_ExaminationDB;
GO

/* =========================
   Branch Negative Tests
   ========================= */

EXEC DeleteBranch @BranchID = 9999;
GO

EXEC InsertBranch @BranchName = '', @Location = 'Cairo';
GO

EXEC InsertBranch @BranchName = '   ', @Location = 'Cairo';
GO

EXEC UpdateBranch @BranchID = 9999, @BranchName = 'Test Branch', @Location = 'Cairo';
GO

EXEC InsertBranch @BranchName = NULL, @Location = 'Cairo';
GO

EXEC UpdateBranch @BranchID = NULL, @BranchName = 'Test Branch', @Location = 'Cairo';
GO

EXEC DeleteBranch @BranchID = NULL;
GO


/* =========================
   Track Negative Tests
   ========================= */

EXEC DeleteTrack @TrackID = 9999;
GO

EXEC InsertTrack @TrackName = '', @BranchID = 1, @DurationMonths = 4;
GO

EXEC InsertTrack @TrackName = 'New Track', @BranchID = 9999, @DurationMonths = 4;
GO

EXEC UpdateTrack @TrackID = 9999, @TrackName = 'Updated Track', @BranchID = 1, @DurationMonths = 4;
GO

EXEC UpdateTrack @TrackID = 1, @TrackName = 'Updated Track', @BranchID = 9999, @DurationMonths = 4;
GO

EXEC UpdateTrack @TrackID = NULL, @TrackName = 'Updated Track', @BranchID = 1, @DurationMonths = 4;
GO

EXEC DeleteTrack @TrackID = NULL;
GO


/* =========================
   Course Negative Tests
   ========================= */

EXEC DeleteCourse @CourseID = 9999;
GO

EXEC InsertCourse @CourseName = '', @MinDegree = 50, @MaxDegree = 100;
GO

EXEC InsertCourse @CourseName = 'Invalid Course', @MinDegree = 100, @MaxDegree = 50;
GO

EXEC UpdateCourse @CourseID = 1, @CourseName = 'Invalid Update', @MinDegree = 100, @MaxDegree = 50;
GO

EXEC UpdateCourse @CourseID = NULL, @CourseName = 'SQL', @MinDegree = 50, @MaxDegree = 100;
GO

EXEC DeleteCourse @CourseID = NULL;
GO