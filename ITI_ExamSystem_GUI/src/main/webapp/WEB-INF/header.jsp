<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Security guard — include this in every protected JSP
    if (session == null || session.getAttribute("role") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String role     = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<nav class="navbar">
    <div class="navbar-brand">
        <div class="logo-circle">ITI</div>
        Student Examination System
    </div>
    <div class="navbar-user">
        <span class="role-badge"><%= role %></span>
        <span>👤 <%= userName %></span>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Sign out →</a>
    </div>
</nav>

<div class="sidebar">
    <% if ("admin".equals(role)) { %>
        <div class="section-label">Administration</div>
        <a href="${pageContext.request.contextPath}/pages/admin/dashboard.jsp">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/students">👥 Students</a>
        <a href="${pageContext.request.contextPath}/pages/admin/instructors.jsp">🎓 Instructors</a>
        <a href="${pageContext.request.contextPath}/pages/admin/branches.jsp">🏢 Branches</a>
        <a href="${pageContext.request.contextPath}/pages/admin/tracks.jsp">📚 Tracks</a>
        <a href="${pageContext.request.contextPath}/pages/admin/courses.jsp">📖 Courses</a>
        <div class="section-label">Exams</div>
        <a href="${pageContext.request.contextPath}/exam?action=list">📝 All Exams</a>
        <div class="section-label">Reports</div>
        <a href="${pageContext.request.contextPath}/reports?type=dept">📊 By Department</a>
        <a href="${pageContext.request.contextPath}/reports?type=grades">📈 Student Grades</a>
        <a href="${pageContext.request.contextPath}/reports?type=instructor">👨‍🏫 Instructor Courses</a>

    <% } else if ("instructor".equals(role)) { %>
        <div class="section-label">Instructor Panel</div>
        <a href="${pageContext.request.contextPath}/pages/instructor/dashboard.jsp">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/instructor/questions">❓ Question Bank</a>
        <a href="${pageContext.request.contextPath}/exam?action=generate_form">⚡ Generate Exam</a>
        <a href="${pageContext.request.contextPath}/exam?action=list">📝 Exams</a>
        <div class="section-label">Reports</div>
        <a href="${pageContext.request.contextPath}/reports?type=instructor">📊 My Courses</a>
        <a href="${pageContext.request.contextPath}/reports?type=grades">📈 Student Grades</a>

    <% } else if ("student".equals(role)) { %>
        <div class="section-label">Student Panel</div>
        <a href="${pageContext.request.contextPath}/pages/student/dashboard.jsp">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/exam?action=available">📝 Available Exams</a>
        <a href="${pageContext.request.contextPath}/student/results">📊 My Results</a>
        <a href="${pageContext.request.contextPath}/reports?type=grades">📈 Grade Report</a>
    <% } %>
</div>
