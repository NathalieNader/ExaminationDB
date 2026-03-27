<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Generate Exam — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    String error = (String) request.getAttribute("error");
    if (courses == null) courses = new ArrayList<>();
%>
<div class="main-content">
    <div class="page-title">Generate <span>Exam</span></div>
    <% if (error != null) { %><div class="alert alert-danger">❌ <%= error %></div><% } %>

    <div class="card" style="max-width:600px;">
        <div class="card-header"><span class="card-title">⚡ New Exam</span></div>
        <form action="${pageContext.request.contextPath}/exam" method="post" id="genForm">
            <input type="hidden" name="action" value="generate">

            <div class="form-group">
                <label>Exam Name *</label>
                <input type="text" name="examName" class="form-control"
                       placeholder="e.g. Java Midterm Exam 2025" required>
            </div>

            <div class="form-group">
                <label>Course *</label>
                <select name="courseId" id="courseSelect" class="form-control" onchange="loadStats()" required>
                    <option value="">— Select Course —</option>
                    <% for (Course c : courses) { %>
                    <option value="<%= c.getCourseId() %>"><%= c.getCourseName() %></option>
                    <% } %>
                </select>
            </div>

            <!-- Available question counts per course (loaded via AJAX) -->
            <div id="qStats" style="display:none;" class="alert alert-info" style="margin-bottom:14px;">
                Available: <strong id="mcqCount">?</strong> MCQ &nbsp;|&nbsp; <strong id="tfCount">?</strong> True/False
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Number of MCQ Questions</label>
                    <input type="number" name="numMCQ" id="numMCQ" class="form-control" value="5" min="0">
                </div>
                <div class="form-group">
                    <label>Number of True/False Questions</label>
                    <input type="number" name="numTF" id="numTF" class="form-control" value="3" min="0">
                </div>
            </div>

            <div class="alert alert-info">
                📋 Total questions: <strong id="totalQ">8</strong>
            </div>

            <button type="submit" class="btn btn-gold" style="font-size:1rem;padding:11px 24px;">
                ⚡ Generate Exam
            </button>
        </form>
    </div>
</div>

<script>
// Live total counter
['numMCQ','numTF'].forEach(id => {
    document.getElementById(id).addEventListener('input', () => {
        const m = parseInt(document.getElementById('numMCQ').value)||0;
        const t = parseInt(document.getElementById('numTF').value)||0;
        document.getElementById('totalQ').textContent = m + t;
    });
});

function loadStats() {
    const courseId = document.getElementById('courseSelect').value;
    if (!courseId) { document.getElementById('qStats').style.display='none'; return; }
    fetch('${pageContext.request.contextPath}/api/questionStats?courseId=' + courseId)
        .then(r => r.json())
        .then(d => {
            document.getElementById('mcqCount').textContent = d.mcq;
            document.getElementById('tfCount').textContent  = d.tf;
            document.getElementById('qStats').style.display = '';
            document.getElementById('numMCQ').max = d.mcq;
            document.getElementById('numTF').max  = d.tf;
        }).catch(() => document.getElementById('qStats').style.display='none');
}

document.getElementById('genForm').addEventListener('submit', function(e) {
    const m = parseInt(document.getElementById('numMCQ').value)||0;
    const t = parseInt(document.getElementById('numTF').value)||0;
    if (m + t < 1) { e.preventDefault(); alert('Exam must have at least 1 question.'); }
});
</script>
</body>
</html>
