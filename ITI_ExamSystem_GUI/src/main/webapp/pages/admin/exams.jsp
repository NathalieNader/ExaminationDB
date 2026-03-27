<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Exams — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Exam> exams = new ExamDAO().getAll();
    String success = request.getParameter("success");
%>
<div class="main-content">
    <div class="page-title">All <span>Exams</span></div>
    <% if (success != null) { %><div class="alert alert-success">✅ <%= success %></div><% } %>
    <div class="card">
        <div class="card-header">
            <span class="card-title">📝 Exams (<%= exams.size() %>)</span>
            <input type="text" id="sb" class="form-control" style="max-width:240px;" placeholder="🔍 Search..." onkeyup="filterTable()">
        </div>
        <div class="table-wrap">
            <table id="examTable">
                <thead><tr><th>#</th><th>Exam Name</th><th>Course</th><th>Total Questions</th><th>Created</th></tr></thead>
                <tbody>
                    <% for (Exam e : exams) { %>
                    <tr>
                        <td><%= e.getExamId() %></td>
                        <td><strong><%= e.getExamName() %></strong></td>
                        <td><span class="badge badge-mcq"><%= e.getCourseName() %></span></td>
                        <td><%= e.getTotalQuestions() %></td>
                        <td><%= e.getCreatedDate() %></td>
                    </tr>
                    <% } %>
                    <% if (exams.isEmpty()) { %><tr><td colspan="5" style="text-align:center;padding:30px;color:#6b7280;">No exams generated yet.</td></tr><% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
function filterTable() {
    const q = document.getElementById('sb').value.toLowerCase();
    document.querySelectorAll('#examTable tbody tr').forEach(r => r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none');
}
</script>
</body></html>
