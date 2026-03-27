<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Add Question — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    String error = (String) request.getAttribute("error");
    if (courses == null) courses = new ArrayList<>();
%>
<div class="main-content">
    <div class="page-title">Add <span>Question</span></div>
    <% if (error != null) { %><div class="alert alert-danger">❌ <%= error %></div><% } %>

    <div class="card" style="max-width:720px;">
        <div class="card-header">
            <span class="card-title">➕ New Question</span>
            <a href="${pageContext.request.contextPath}/instructor/questions" class="btn btn-outline btn-sm">← Back</a>
        </div>

        <form action="${pageContext.request.contextPath}/instructor/questions" method="post" id="qForm">
            <input type="hidden" name="action" value="insert">

            <div class="form-row">
                <div class="form-group">
                    <label>Course *</label>
                    <select name="courseId" class="form-control" required>
                        <option value="">— Select Course —</option>
                        <% for (Course c : courses) { %>
                        <option value="<%= c.getCourseId() %>"><%= c.getCourseName() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Question Type *</label>
                    <select name="questionType" id="questionType" class="form-control" onchange="toggleOptions()" required>
                        <option value="MCQ">MCQ (Multiple Choice)</option>
                        <option value="TF">True / False</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Question Text *</label>
                <textarea name="questionText" class="form-control" rows="3"
                          placeholder="Enter the question here..." required></textarea>
            </div>

            <div class="form-group">
                <label>Points *</label>
                <input type="number" name="points" class="form-control" value="5" min="1" style="max-width:120px;" required>
            </div>

            <!-- MCQ Options -->
            <div id="mcqOptions">
                <div style="font-weight:700;color:var(--iti-blue);margin-bottom:10px;">Answer Options</div>
                <div style="background:#f8fafc;padding:16px;border-radius:10px;border:1.5px solid var(--border);">
                    <% for (int i = 1; i <= 4; i++) { %>
                    <div style="display:flex;align-items:center;gap:10px;margin-bottom:10px;">
                        <input type="radio" name="correctOption" value="<%= i-1 %>" <%= i==1 ? "required" : "" %> id="opt<%= i %>">
                        <label for="opt<%= i %>" style="font-weight:600;min-width:24px;color:var(--iti-blue);">
                            <%= (char)('A' + i - 1) %>
                        </label>
                        <input type="text" name="option<%= i %>" class="form-control"
                               placeholder="Option <%= (char)('A' + i - 1) %>...">
                    </div>
                    <% } %>
                    <div class="alert alert-info" style="margin-top:6px;padding:8px 12px;">
                        🔘 Select the radio button next to the <strong>correct answer</strong>.
                    </div>
                </div>
            </div>

            <!-- TF Options (hidden by default) -->
            <div id="tfOptions" style="display:none;">
                <div style="font-weight:700;color:var(--iti-blue);margin-bottom:10px;">Correct Answer</div>
                <div style="background:#f8fafc;padding:16px;border-radius:10px;border:1.5px solid var(--border);">
                    <label style="display:flex;align-items:center;gap:10px;margin-bottom:10px;cursor:pointer;">
                        <input type="radio" name="correctOption" value="0"> ✅ <strong>True</strong>
                    </label>
                    <label style="display:flex;align-items:center;gap:10px;cursor:pointer;">
                        <input type="radio" name="correctOption" value="1"> ❌ <strong>False</strong>
                    </label>
                </div>
            </div>

            <div style="margin-top:20px;display:flex;gap:10px;">
                <button type="submit" class="btn btn-primary">💾 Save Question</button>
                <a href="${pageContext.request.contextPath}/instructor/questions" class="btn btn-outline">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
function toggleOptions() {
    const type = document.getElementById('questionType').value;
    document.getElementById('mcqOptions').style.display = type === 'MCQ' ? '' : 'none';
    document.getElementById('tfOptions').style.display  = type === 'TF'  ? '' : 'none';
    // Require MCQ text inputs only for MCQ
    document.querySelectorAll('[name^="option"]').forEach(el => el.required = type === 'MCQ');
}
// Validate on submit
document.getElementById('qForm').addEventListener('submit', function(e) {
    const type = document.getElementById('questionType').value;
    if (type === 'MCQ') {
        const filled = ['option1','option2','option3','option4'].every(n => document.querySelector('[name='+n+']').value.trim());
        if (!filled) { e.preventDefault(); alert('Please fill all 4 MCQ options.'); return; }
    }
    const checked = document.querySelector('input[name=correctOption]:checked');
    if (!checked) { e.preventDefault(); alert('Please select the correct answer.'); }
});
</script>
</body>
</html>
