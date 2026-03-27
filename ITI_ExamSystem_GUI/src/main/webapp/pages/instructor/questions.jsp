<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Question Bank — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    List<Course>   courses   = (List<Course>)   request.getAttribute("courses");
    String selCourse = (String) request.getAttribute("selectedCourseId");
    String success = request.getParameter("success");
    String error   = (String) request.getAttribute("error");
    if (questions == null) questions = new ArrayList<>();
    if (courses   == null) courses   = new ArrayList<>();
%>
<div class="main-content">
    <div class="page-title">Question <span>Bank</span></div>

    <% if (success != null) { %><div class="alert alert-success">✅ Question <%= success %>.</div><% } %>
    <% if (error   != null) { %><div class="alert alert-danger">❌ <%= error %></div><% } %>

    <div class="card" style="margin-bottom:16px;">
        <form method="get" action="${pageContext.request.contextPath}/instructor/questions"
              style="display:flex;align-items:flex-end;gap:12px;flex-wrap:wrap;">
            <div class="form-group" style="margin:0;flex:1;min-width:220px;">
                <label>Filter by Course</label>
                <select name="courseId" class="form-control">
                    <option value="">— All Courses —</option>
                    <% for (Course c : courses) { %>
                    <option value="<%= c.getCourseId() %>"
                        <%= (selCourse != null && selCourse.equals(String.valueOf(c.getCourseId()))) ? "selected" : "" %>>
                        <%= c.getCourseName() %>
                    </option>
                    <% } %>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">🔍 Filter</button>
            <a href="${pageContext.request.contextPath}/instructor/questions?action=add_form" class="btn btn-gold">➕ Add Question</a>
        </form>
    </div>

    <div class="card">
        <div class="card-header">
            <span class="card-title">❓ Questions (<%= questions.size() %>)</span>
            <input type="text" id="sb" class="form-control" style="max-width:240px;"
                   placeholder="🔍 Search..." onkeyup="filterTable()">
        </div>
        <div class="table-wrap">
            <table id="qTable">
                <thead>
                    <tr><th>#</th><th>Question Text</th><th>Course</th><th>Type</th><th>Points</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <% for (Question q : questions) { %>
                    <tr>
                        <td><%= q.getQuestionId() %></td>
                        <td style="max-width:400px;">
                            <div style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="<%= q.getQuestionText() %>">
                                <%= q.getQuestionText() %>
                            </div>
                        </td>
                        <td><span class="badge badge-mcq"><%= q.getCourseName() %></span></td>
                        <td><span class="badge <%= "MCQ".equals(q.getQuestionType()) ? "badge-mcq" : "badge-tf" %>"><%= q.getQuestionType() %></span></td>
                        <td><strong><%= q.getPoints() %></strong></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/instructor/questions?action=edit&id=<%= q.getQuestionId() %>"
                               class="btn btn-outline btn-sm">✏️</a>
                            <a href="${pageContext.request.contextPath}/instructor/questions?action=delete&id=<%= q.getQuestionId() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Delete this question and its options?')">🗑️</a>
                        </td>
                    </tr>
                    <% } %>
                    <% if (questions.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align:center;padding:30px;color:#6b7280;">No questions found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
function filterTable() {
    const q = document.getElementById('sb').value.toLowerCase();
    document.querySelectorAll('#qTable tbody tr').forEach(r => r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none');
}
</script>
</body>
</html>
