<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Student Dashboard — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    int studentId = (Integer) session.getAttribute("studentId");
    List<Exam> available = new ExamDAO().getAvailableForStudent(studentId);
    List<StudentExam> results = new StudentExamDAO().getByStudent(studentId);
    long graded = results.stream().filter(r -> r.getTotalGrade() != null).count();
%>
<div class="main-content">
    <div class="page-title">Student <span>Dashboard</span></div>

    <div class="stats-grid" style="margin-bottom:24px;">
        <div class="stat-card">
            <div class="stat-num"><%= available.size() %></div>
            <div class="stat-lbl">Exams Available</div>
        </div>
        <div class="stat-card gold">
            <div class="stat-num"><%= results.size() %></div>
            <div class="stat-lbl">Exams Taken</div>
        </div>
        <div class="stat-card green">
            <div class="stat-num"><%= graded %></div>
            <div class="stat-lbl">Results Ready</div>
        </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <div class="card">
            <div class="card-header"><span class="card-title">📝 Available Exams</span>
                <a href="${pageContext.request.contextPath}/exam?action=available" class="btn btn-outline btn-sm">View All</a>
            </div>
            <% if (available.isEmpty()) { %>
                <p style="color:var(--text-muted);text-align:center;padding:20px;">No exams available right now.</p>
            <% } else {
                int shown = 0;
                for (Exam e : available) {
                    if (shown++ >= 4) break; %>
                <div style="display:flex;justify-content:space-between;align-items:center;
                            padding:10px 0;border-bottom:1px solid var(--border);">
                    <div>
                        <div style="font-weight:600;"><%= e.getExamName() %></div>
                        <div style="font-size:.82rem;color:var(--text-muted);"><%= e.getCourseName() %> — <%= e.getTotalQuestions() %> questions</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/exam?action=take&examId=<%= e.getExamId() %>"
                       class="btn btn-primary btn-sm">Start →</a>
                </div>
            <% } } %>
        </div>

        <div class="card">
            <div class="card-header"><span class="card-title">📊 Recent Results</span>
                <a href="${pageContext.request.contextPath}/student/results" class="btn btn-outline btn-sm">View All</a>
            </div>
            <% if (results.isEmpty()) { %>
                <p style="color:var(--text-muted);text-align:center;padding:20px;">No results yet.</p>
            <% } else {
                int shown = 0;
                for (StudentExam se : results) {
                    if (shown++ >= 4) break;
                    boolean pass = se.getTotalGrade() != null && se.getMaxDegree() != null
                                   && se.getTotalGrade() >= (se.getMaxDegree() * 0.5);
            %>
                <div style="display:flex;justify-content:space-between;align-items:center;
                            padding:10px 0;border-bottom:1px solid var(--border);">
                    <div>
                        <div style="font-weight:600;"><%= se.getExamName() %></div>
                        <div style="font-size:.82rem;color:var(--text-muted);"><%= se.getCourseName() %></div>
                    </div>
                    <div style="text-align:right;">
                        <% if (se.getTotalGrade() != null) { %>
                        <div style="font-weight:800;font-size:1.1rem;color:<%= pass ? "var(--success)" : "var(--danger)" %>">
                            <%= se.getTotalGrade() %>/<%= se.getMaxDegree() %>
                        </div>
                        <span class="badge <%= pass ? "badge-pass" : "badge-fail" %>"><%= pass ? "PASS" : "FAIL" %></span>
                        <% } else { %><span class="badge badge-tf">Pending</span><% } %>
                    </div>
                </div>
            <% } } %>
        </div>
    </div>
</div>
</body>
</html>
