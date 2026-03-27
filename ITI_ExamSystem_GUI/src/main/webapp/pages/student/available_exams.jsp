<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Available Exams — ITI</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Exam> exams = (List<Exam>) request.getAttribute("exams");
    String error = request.getParameter("error");
    if (exams == null) exams = new ArrayList<>();
%>
<div class="main-content">
    <div class="page-title">Available <span>Exams</span></div>
    <% if ("already_taken".equals(error)) { %>
        <div class="alert alert-danger">❌ You have already taken this exam.</div>
    <% } %>

    <% if (exams.isEmpty()) { %>
        <div class="card" style="text-align:center;padding:50px;">
            <div style="font-size:3rem;">📭</div>
            <div style="font-size:1.2rem;font-weight:700;margin-top:12px;color:var(--text-muted);">No exams available right now.</div>
            <p style="color:var(--text-muted);margin-top:8px;">Check back later or contact your instructor.</p>
        </div>
    <% } else { %>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:16px;">
            <% for (Exam e : exams) { %>
            <div class="card" style="border-top:4px solid var(--iti-blue);">
                <div style="font-size:1.1rem;font-weight:700;margin-bottom:6px;"><%= e.getExamName() %></div>
                <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:14px;">
                    <span class="badge badge-mcq">📖 <%= e.getCourseName() %></span>
                    <span class="badge badge-tf">❓ <%= e.getTotalQuestions() %> questions</span>
                </div>
                <div style="font-size:.82rem;color:var(--text-muted);margin-bottom:14px;">
                    Created: <%= e.getCreatedDate() != null ? e.getCreatedDate().toString().substring(0,10) : "—" %>
                </div>
                <a href="${pageContext.request.contextPath}/exam?action=take&examId=<%= e.getExamId() %>"
                   class="btn btn-primary" style="width:100%;justify-content:center;">
                    🚀 Start Exam
                </a>
            </div>
            <% } %>
        </div>
    <% } %>
</div>
</body>
</html>
