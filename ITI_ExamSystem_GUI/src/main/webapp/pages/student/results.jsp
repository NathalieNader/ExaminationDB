<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>My Results — ITI</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<StudentExam> results = (List<StudentExam>) request.getAttribute("results");
    Integer highlightId = (Integer) request.getAttribute("highlightId");
    if (results == null) results = new ArrayList<>();

    // Compute stats
    long   total    = results.stream().filter(r -> r.getTotalGrade() != null).count();
    double avgPct   = results.stream().filter(r -> r.getPercentage() != null)
                             .mapToDouble(StudentExam::getPercentage).average().orElse(0);
    long   passed   = results.stream().filter(r -> r.getTotalGrade() != null && r.getMaxDegree() != null
                             && r.getTotalGrade() >= r.getMaxDegree() * 0.5).count();
%>
<div class="main-content">
    <div class="page-title">My <span>Results</span></div>

    <% if (highlightId != null) { %>
        <div class="alert alert-success">🎉 Exam submitted and graded! Your result is highlighted below.</div>
    <% } %>

    <div class="stats-grid" style="margin-bottom:20px;">
        <div class="stat-card"><div class="stat-num"><%= results.size() %></div><div class="stat-lbl">Exams Taken</div></div>
        <div class="stat-card gold"><div class="stat-num"><%= String.format("%.1f", avgPct) %>%</div><div class="stat-lbl">Average Score</div></div>
        <div class="stat-card green"><div class="stat-num"><%= passed %></div><div class="stat-lbl">Passed</div></div>
    </div>

    <div class="card">
        <div class="card-header"><span class="card-title">📊 All Exam Results</span></div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr><th>Exam</th><th>Course</th><th>Score</th><th>Max</th><th>%</th><th>Status</th><th>Date</th></tr>
                </thead>
                <tbody>
                    <% for (StudentExam se : results) {
                        boolean pass = se.getTotalGrade() != null && se.getMaxDegree() != null
                                       && se.getTotalGrade() >= se.getMaxDegree() * 0.5;
                        boolean highlight = highlightId != null && highlightId.equals(se.getStudentExamId());
                    %>
                    <tr style="<%= highlight ? "background:#fffbeb;border-left:4px solid var(--iti-gold);" : "" %>">
                        <td><strong><%= se.getExamName() %></strong></td>
                        <td><%= se.getCourseName() %></td>
                        <td style="font-weight:800;font-size:1.1rem;color:<%= pass?"var(--success)":"var(--danger)" %>">
                            <%= se.getTotalGrade() != null ? se.getTotalGrade() : "—" %>
                        </td>
                        <td><%= se.getMaxDegree() != null ? se.getMaxDegree() : "—" %></td>
                        <td>
                            <% if (se.getPercentage() != null) { %>
                                <div style="display:flex;align-items:center;gap:8px;">
                                    <div class="progress-bar-wrap" style="width:70px;">
                                        <div class="progress-bar-fill" style="width:<%= Math.min(100,se.getPercentage().intValue()) %>%;
                                             background:<%= pass ? "var(--success)" : "var(--danger)" %>;"></div>
                                    </div>
                                    <%= String.format("%.1f", se.getPercentage()) %>%
                                </div>
                            <% } else { %>—<% } %>
                        </td>
                        <td>
                            <% if (se.getTotalGrade() != null) { %>
                                <span class="badge <%= pass ? "badge-pass" : "badge-fail" %>"><%= pass ? "✅ PASS" : "❌ FAIL" %></span>
                            <% } else { %>
                                <span class="badge badge-tf">⏳ Pending</span>
                            <% } %>
                        </td>
                        <td style="font-size:.82rem;color:var(--text-muted);">
                            <%= se.getStartTime() != null ? se.getStartTime().toString().substring(0,16) : "—" %>
                        </td>
                    </tr>
                    <% } %>
                    <% if (results.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align:center;padding:40px;color:#6b7280;">
                        You haven't taken any exams yet.
                        <a href="${pageContext.request.contextPath}/exam?action=available" style="color:var(--iti-blue);">Browse available exams →</a>
                    </td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
