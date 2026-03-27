<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.model.*,java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Edit Student — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>

<%
    Student student = (Student) request.getAttribute("student");
    List<Track> tracks = (List<Track>) request.getAttribute("tracks");
    List<Integer> assignedTrackIds = (List<Integer>) request.getAttribute("assignedTrackIds");
    if (student == null) { response.sendRedirect(request.getContextPath() + "/admin/students"); return; }
%>

<div class="main-content">
    <div class="page-title">Edit <span>Student</span></div>

    <div class="card" style="max-width:700px;">
        <div class="card-header">
            <span class="card-title">✏️ Editing: <%= student.getStudentName() %></span>
            <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline btn-sm">← Back</a>
        </div>

        <form action="${pageContext.request.contextPath}/admin/students" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="studentId" value="<%= student.getStudentId() %>">

            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="studentName" class="form-control"
                       value="<%= student.getStudentName() %>" required>
            </div>
            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" class="form-control"
                       value="<%= student.getEmail() %>" required>
            </div>
            <div class="form-group">
                <label>Phone *</label>
                <input type="text" name="phone" class="form-control"
                       value="<%= student.getPhone() %>" required>
            </div>

            <div style="display:flex;gap:10px;margin-top:8px;">
                <button type="submit" class="btn btn-primary">💾 Save Changes</button>
                <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
