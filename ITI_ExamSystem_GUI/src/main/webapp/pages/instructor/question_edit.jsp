<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Edit Question — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    Question q = (Question) request.getAttribute("question");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    if (q == null) { response.sendRedirect(request.getContextPath() + "/instructor/questions"); return; }
%>
<div class="main-content">
    <div class="page-title">Edit <span>Question</span></div>
    <div class="card" style="max-width:720px;">
        <div class="card-header">
            <span class="card-title">✏️ Edit Question #<%= q.getQuestionId() %></span>
            <a href="${pageContext.request.contextPath}/instructor/questions" class="btn btn-outline btn-sm">← Back</a>
        </div>

        <form action="${pageContext.request.contextPath}/instructor/questions" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="questionId" value="<%= q.getQuestionId() %>">

            <div class="form-group">
                <label>Course</label>
                <input type="text" class="form-control" value="<%= q.getCourseName() %>" disabled>
            </div>
            <div class="form-group">
                <label>Type: <span class="badge <%= "MCQ".equals(q.getQuestionType()) ? "badge-mcq" : "badge-tf" %>"><%= q.getQuestionType() %></span></label>
                <input type="hidden" name="questionType" value="<%= q.getQuestionType() %>">
            </div>
            <div class="form-group">
                <label>Question Text *</label>
                <textarea name="questionText" class="form-control" rows="3" required><%= q.getQuestionText() %></textarea>
            </div>
            <div class="form-group">
                <label>Points *</label>
                <input type="number" name="points" class="form-control" value="<%= q.getPoints() %>" min="1" style="max-width:120px;" required>
            </div>

            <!-- Show current options read-only -->
            <% if (q.getOptions() != null && !q.getOptions().isEmpty()) { %>
            <div style="background:#f8fafc;padding:14px;border-radius:10px;border:1.5px solid var(--border);margin-bottom:14px;">
                <div style="font-weight:700;color:var(--iti-blue);margin-bottom:8px;">Current Options (read-only — delete & re-add to change)</div>
                <% for (Option o : q.getOptions()) { %>
                <div style="padding:5px 0;display:flex;align-items:center;gap:8px;">
                    <% if (o.getOptionId() == q.getModelAnswerOptionId()) { %>
                        <span style="color:var(--success);font-weight:700;">✅</span>
                    <% } else { %>
                        <span>○</span>
                    <% } %>
                    <span><%= o.getOptionText() %></span>
                </div>
                <% } %>
            </div>
            <% } %>

            <div style="display:flex;gap:10px;">
                <button type="submit" class="btn btn-primary">💾 Update Text & Points</button>
                <a href="${pageContext.request.contextPath}/instructor/questions" class="btn btn-outline">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
