<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Report: Student Grades</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<StudentExam>  grades   = (List<StudentExam>)  request.getAttribute("grades");
    List<Student>      students = (List<Student>)       request.getAttribute("students");
    Integer selStudentId = (Integer) request.getAttribute("selectedStudentId");
    String error = (String) request.getAttribute("error");
    boolean isStudent = "student".equals(session.getAttribute("role"));

    double avgPct = grades != null
        ? grades.stream().filter(g -> g.getPercentage() != null)
                .mapToDouble(StudentExam::getPercentage).average().orElse(0)
        : 0;
%>
<div class="main-content">
    <div class="page-title">Report: <span>Student Grades</span></div>

    <% if (!isStudent) { %>
    <div class="card" style="max-width:500px;margin-bottom:20px;">
        <div class="card-header"><span class="card-title">🔍 Filter</span></div>
        <form method="get" action="${pageContext.request.contextPath}/reports"
              style="display:flex;gap:12px;align-items:flex-end;">
            <input type="hidden" name="type" value="grades">
            <div class="form-group" style="margin:0;flex:1;">
                <label>Select Student</label>
                <select name="studentId" class="form-control">
                    <option value="">— Select Student —</option>
                    <% if (students != null) { for (Student s : students) { %>
                    <option value="<%= s.getStudentId() %>"
                        <%= selStudentId != null && selStudentId == s.getStudentId() ? "selected" : "" %>>
                        #<%= s.getStudentId() %> — <%= s.getStudentName() %>
                    </option>
                    <% } } %>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">📈 Run Report</button>
        </form>
    </div>
    <% } %>

    <% if (error != null) { %><div class="alert alert-danger">❌ <%= error %></div><% } %>

    <% if (grades != null) { %>
    <div class="stats-grid" style="margin-bottom:20px;">
        <div class="stat-card"><div class="stat-num"><%= grades.size() %></div><div class="stat-lbl">Exams Taken</div></div>
        <div class="stat-card gold"><div class="stat-num"><%= String.format("%.1f",avgPct) %>%</div><div class="stat-lbl">Average Score</div></div>
        <div class="stat-card green">
            <div class="stat-num">
                <%= grades.stream().filter(g -> g.getPercentage() != null && g.getPercentage() >= 50).count() %>
            </div>
            <div class="stat-lbl">Passed</div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <span class="card-title">📈 Grade Report</span>
            <button onclick="printReport()" class="btn btn-outline btn-sm">🖨️ Print</button>
        </div>
        <% if (grades.isEmpty()) { %>
            <div class="alert alert-info">No grades found for this student.</div>
        <% } else { %>
        <div class="table-wrap" id="reportTable">
            <table>
                <thead>
                    <tr><th>Course</th><th>Exam Name</th><th>Score</th><th>Max</th><th>Percentage</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <% for (StudentExam g : grades) {
                        boolean pass = g.getPercentage() != null && g.getPercentage() >= 50; %>
                    <tr>
                        <td><strong><%= g.getCourseName() %></strong></td>
                        <td><%= g.getExamName() %></td>
                        <td style="font-weight:800;color:<%= pass?"var(--success)":"var(--danger)" %>"><%= g.getTotalGrade() %></td>
                        <td><%= g.getMaxDegree() %></td>
                        <td>
                            <div style="display:flex;align-items:center;gap:8px;">
                                <div class="progress-bar-wrap" style="width:80px;">
                                    <div class="progress-bar-fill"
                                         style="width:<%= g.getPercentage()!=null?Math.min(100,g.getPercentage().intValue()):0 %>%;
                                                background:<%= pass?"var(--success)":"var(--danger)" %>;"></div>
                                </div>
                                <strong><%= g.getPercentage()!=null ? String.format("%.1f%%",g.getPercentage()) : "—" %></strong>
                            </div>
                        </td>
                        <td><span class="badge <%= pass?"badge-pass":"badge-fail" %>"><%= pass?"✅ PASS":"❌ FAIL" %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
<script>
function printReport() {
    const t = document.getElementById('reportTable');
    if (!t) return;
    const w = window.open('','_blank');
    w.document.write('<html><head><title>Grades Report</title><style>table{border-collapse:collapse;width:100%}th,td{border:1px solid #ccc;padding:8px}th{background:#003580;color:#fff}</style></head><body>');
    w.document.write('<h2>Student Grade Report</h2>');
    w.document.write(t.innerHTML);
    w.document.write('</body></html>');
    w.print();
}
</script>
</body>
</html>
