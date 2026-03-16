-- ============================================================
-- STEP 1: CREATE SERVER-LEVEL LOGINS
-- Must run in master context
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'iti_admin')
    CREATE LOGIN iti_admin WITH PASSWORD = 'Admin@ITI2026', CHECK_POLICY = ON;
GO

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'iti_instructor')
    CREATE LOGIN iti_instructor WITH PASSWORD = 'Instructor@ITI2026', CHECK_POLICY = ON;
GO

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'iti_student')
    CREATE LOGIN iti_student WITH PASSWORD = 'Student@ITI2026', CHECK_POLICY = ON;
GO


-- ============================================================
-- STEP 2: CREATE DATABASE-LEVEL USERS
-- ============================================================

USE ITI_ExaminationDB;
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'iti_admin')
    CREATE USER iti_admin FOR LOGIN iti_admin;
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'iti_instructor')
    CREATE USER iti_instructor FOR LOGIN iti_instructor;
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'iti_student')
    CREATE USER iti_student FOR LOGIN iti_student;
GO


-- ============================================================
-- STEP 3: CREATE DATABASE ROLES
-- ============================================================

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'AdminRole' AND type = 'R')
    CREATE ROLE AdminRole;
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'InstructorRole' AND type = 'R')
    CREATE ROLE InstructorRole;
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'StudentRole' AND type = 'R')
    CREATE ROLE StudentRole;
GO


-- ============================================================
-- STEP 4: ASSIGN USERS TO ROLES
-- ============================================================

ALTER ROLE AdminRole      ADD MEMBER iti_admin;
ALTER ROLE InstructorRole ADD MEMBER iti_instructor;
ALTER ROLE StudentRole    ADD MEMBER iti_student;
GO