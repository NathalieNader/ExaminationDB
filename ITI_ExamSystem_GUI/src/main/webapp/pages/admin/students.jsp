<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,com.iti.exam.model.*,java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Students — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>

<%
    List<Student> students = new StudentDAO().getAll();
    String success = request.getParameter("success");
    String error   = (String) request.getAttribute("error");
%>

<div class="main-content">
    <div class="page-title">Manage <span>Students</span></div>

    <% if (success != null) { %>
        <div class="alert alert-success">✅ Student <%= success %> successfully.</div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-danger">❌ <%= error %></div>
    <% } %>

    <!-- Add Student Form -->
    <div class="card" id="addForm">
        <div class="card-header">
            <span class="card-title">➕ Add New Student</span>
        </div>
        <form action="${pageContext.request.contextPath}/admin/students" method="post">
            <input type="hidden" name="action" value="insert">
            <div class="form-row three">
                <div class="form-group">
                    <label>Full Name *</label>
                    <input type="text" name="studentName" class="form-control" placeholder="Ahmed Mohamed" required>
                </div>
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email" class="form-control" placeholder="ahmed@example.com" required>
                </div>
                <div class="form-group">
                    <label>Phone *</label>
                    <input type="text" name="phone" class="form-control" placeholder="01012345678" required>
                </div>
            </div>
            <div class="form-group">
                <label>Assign to Track(s)</label>
                <%
                    List<Track> tracks = new TrackDAO().getAll();
                    for (Track t : tracks) {
                %>
                    <label style="display:inline-flex;align-items:center;gap:6px;margin-right:14px;font-weight:normal;">
                        <input type="checkbox" name="trackIds" value="<%= t.getTrackId() %>">
                        <%= t.getTrackName() %> (<%= t.getBranchName() %>)
                    </label>
                <% } %>
            </div>
            <button type="submit" class="btn btn-primary">Save Student</button>
        </form>
    </div>

    <!-- Students Table -->
    <div class="card">
        <div class="card-header">
            <span class="card-title">👥 All Students (<%= students.size() %>)</span>
            <input type="text" id="searchBox" class="form-control" style="max-width:240px;"
                   placeholder="🔍 Search students..." onkeyup="filterTable()">
        </div>
        <div class="table-wrap">
            <table id="studentsTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Student s : students) { %>
                    <tr>
                        <td><%= s.getStudentId() %></td>
                        <td><strong><%= s.getStudentName() %></strong></td>
                        <td><%= s.getEmail() %></td>
                        <td><%= s.getPhone() %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/students?action=edit&id=<%= s.getStudentId() %>"
                               class="btn btn-outline btn-sm">✏️ Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/students?action=delete&id=<%= s.getStudentId() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Delete student <%= s.getStudentName() %>?')">🗑️ Delete</a>
                        </td>
                    </tr>
                    <% } %>
                    <% if (students.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align:center;color:#6b7280;padding:30px;">No students found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function filterTable() {
    const q = document.getElementById('searchBox').value.toLowerCase();
    document.querySelectorAll('#studentsTable tbody tr').forEach(row => {
        row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
