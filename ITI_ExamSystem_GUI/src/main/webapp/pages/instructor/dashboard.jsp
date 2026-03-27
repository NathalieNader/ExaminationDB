<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Instructor Dashboard — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    int instructorId = (Integer) session.getAttribute("instructorId");
    int questionCount = new QuestionDAO().getAll().size();
    int examCount     = new ExamDAO().getAll().size();
    List<Integer> myCourseIds = new InstructorDAO().getCourseIds(instructorId);
    int myCourseCount = myCourseIds.size();
%>
<div class="main-content">
    <div class="page-title">Instructor <span>Dashboard</span></div>

    <div class="stats-grid" style="margin-bottom:24px;">
        <div class="stat-card"><div class="stat-num"><%= myCourseCount %></div><div class="stat-lbl">My Courses</div></div>
        <div class="stat-card gold"><div class="stat-num"><%= questionCount %></div><div class="stat-lbl">Questions in Bank</div></div>
        <div class="stat-card green"><div class="stat-num"><%= examCount %></div><div class="stat-lbl">Total Exams</div></div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <div class="card">
            <div class="card-header"><span class="card-title">⚡ Quick Actions</span></div>
            <div style="display:flex;flex-direction:column;gap:10px;">
                <a href="${pageContext.request.contextPath}/instructor/questions?action=add_form" class="btn btn-primary">➕ Add Question</a>
                <a href="${pageContext.request.contextPath}/exam?action=generate_form" class="btn btn-gold">⚡ Generate Exam</a>
                <a href="${pageContext.request.contextPath}/instructor/questions" class="btn btn-outline">📋 Question Bank</a>
            </div>
        </div>
        <div class="card">
            <div class="card-header"><span class="card-title">📊 Reports</span></div>
            <div style="display:flex;flex-direction:column;gap:10px;">
                <a href="${pageContext.request.contextPath}/reports?type=instructor&instructorId=<%= instructorId %>" class="btn btn-outline">👨‍🏫 My Course Report</a>
                <a href="${pageContext.request.contextPath}/reports?type=grades" class="btn btn-outline">📈 Student Grades</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
