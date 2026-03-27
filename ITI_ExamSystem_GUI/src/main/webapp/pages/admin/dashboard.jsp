<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Admin Dashboard — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>

<%
    int studentCount    = new StudentDAO().getAll().size();
    int instructorCount = new InstructorDAO().getAll().size();
    int courseCount     = new CourseDAO().getAll().size();
    int examCount       = new ExamDAO().getAll().size();
    int branchCount     = new BranchDAO().getAll().size();
    int trackCount      = new TrackDAO().getAll().size();
%>

<div class="main-content">
    <div class="page-title">Admin <span>Dashboard</span></div>

    <div class="stats-grid" style="margin-bottom:24px;">
        <div class="stat-card">
            <div class="stat-num"><%= studentCount %></div>
            <div class="stat-lbl">Students</div>
        </div>
        <div class="stat-card gold">
            <div class="stat-num"><%= instructorCount %></div>
            <div class="stat-lbl">Instructors</div>
        </div>
        <div class="stat-card green">
            <div class="stat-num"><%= courseCount %></div>
            <div class="stat-lbl">Courses</div>
        </div>
        <div class="stat-card">
            <div class="stat-num"><%= examCount %></div>
            <div class="stat-lbl">Exams</div>
        </div>
        <div class="stat-card gold">
            <div class="stat-num"><%= branchCount %></div>
            <div class="stat-lbl">Branches</div>
        </div>
        <div class="stat-card green">
            <div class="stat-num"><%= trackCount %></div>
            <div class="stat-lbl">Tracks</div>
        </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <div class="card">
            <div class="card-header"><span class="card-title">Quick Actions</span></div>
            <div style="display:flex;flex-direction:column;gap:10px;">
                <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-primary">➕ Add Student</a>
                <a href="${pageContext.request.contextPath}/pages/admin/instructors.jsp?action=add" class="btn btn-gold">➕ Add Instructor</a>
                <a href="${pageContext.request.contextPath}/pages/admin/courses.jsp?action=add" class="btn btn-outline">➕ Add Course</a>
                <a href="${pageContext.request.contextPath}/pages/admin/branches.jsp?action=add" class="btn btn-outline">➕ Add Branch</a>
            </div>
        </div>
        <div class="card">
            <div class="card-header"><span class="card-title">Reports</span></div>
            <div style="display:flex;flex-direction:column;gap:10px;">
                <a href="${pageContext.request.contextPath}/reports?type=dept" class="btn btn-outline">📊 Students by Department</a>
                <a href="${pageContext.request.contextPath}/reports?type=grades" class="btn btn-outline">📈 Student Grades</a>
                <a href="${pageContext.request.contextPath}/reports?type=instructor" class="btn btn-outline">👨‍🏫 Instructor Courses</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
