<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Taking Exam — ITI</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: var(--body-bg); }
        .exam-header {
            background: linear-gradient(135deg, var(--iti-dark), var(--iti-blue));
            color: #fff; padding: 16px 28px;
            display: flex; justify-content: space-between; align-items: center;
            position: sticky; top: 0; z-index: 100;
            box-shadow: 0 2px 12px rgba(0,0,0,.3);
        }
        .exam-header h2 { font-size: 1.1rem; margin: 0; }
        .exam-header .meta { font-size: .85rem; opacity: .8; }
        #timerBox {
            background: var(--iti-gold); color: var(--iti-dark);
            padding: 8px 20px; border-radius: 8px;
            font-weight: 800; font-size: 1.1rem; min-width: 80px; text-align: center;
        }
        .q-option-label {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 14px; border-radius: 8px;
            border: 2px solid var(--border); margin-bottom: 8px;
            cursor: pointer; transition: all .15s; font-size: .92rem;
        }
        .q-option-label:hover { border-color: var(--iti-blue); background: #f0f7ff; }
        .q-option-label input[type=radio] { width: 16px; height: 16px; accent-color: var(--iti-blue); }
        .q-option-label.selected { border-color: var(--iti-blue); background: #e7f0ff; font-weight: 600; }
        .progress-float {
            position: fixed; bottom: 24px; right: 24px;
            background: var(--iti-blue); color: #fff; border-radius: 12px;
            padding: 12px 18px; box-shadow: 0 4px 16px rgba(0,0,0,.2);
            font-size: .85rem; min-width: 160px;
        }
    </style>
</head>
<body>
<%
    Exam   exam      = (Exam)   request.getAttribute("exam");
    Long   startTime = (Long)   request.getAttribute("startTime");
    if (exam == null) { response.sendRedirect(request.getContextPath() + "/exam?action=available"); return; }
    List<Question> questions = exam.getQuestions();
    if (questions == null) questions = new ArrayList<>();
%>

<!-- Sticky exam header (no sidebar) -->
<div class="exam-header">
    <div>
        <h2>📝 <%= exam.getExamName() %></h2>
        <div class="meta">📖 <%= exam.getCourseName() %> &nbsp;|&nbsp; ❓ <%= questions.size() %> questions</div>
    </div>
    <div id="timerBox">00:00</div>
</div>

<div style="max-width:820px;margin:28px auto;padding:0 20px;">

    <form action="${pageContext.request.contextPath}/exam" method="post" id="examForm">
        <input type="hidden" name="action" value="submit">
        <input type="hidden" name="examId" value="<%= exam.getExamId() %>">
        <input type="hidden" name="startTime" value="<%= startTime != null ? startTime : System.currentTimeMillis() %>">

        <% int qNum = 0; for (Question q : questions) { qNum++; %>
        <div class="q-card" id="qcard-<%= q.getQuestionId() %>">
            <div class="q-header">
                <span style="font-weight:700;color:var(--iti-blue);">Q<%= qNum %> / <%= questions.size() %></span>
                <div style="display:flex;gap:6px;">
                    <span class="badge <%= "MCQ".equals(q.getQuestionType()) ? "badge-mcq" : "badge-tf" %>"><%= q.getQuestionType() %></span>
                    <span class="badge" style="background:#f0fdf4;color:#0a6640;"><%= q.getPoints() %> pt<%= q.getPoints()>1?"s":"" %></span>
                </div>
            </div>
            <div class="q-text"><%= q.getQuestionText() %></div>
            <div class="options">
                <% if (q.getOptions() != null) { for (Option o : q.getOptions()) { %>
                <label class="q-option-label" id="lbl_<%= q.getQuestionId() %>_<%= o.getOptionId() %>">
                    <input type="radio" name="q_<%= q.getQuestionId() %>"
                           value="<%= o.getOptionId() %>"
                           onchange="markSelected(<%= q.getQuestionId() %>, <%= o.getOptionId() %>)">
                    <span><%= o.getOptionText() %></span>
                </label>
                <% } } %>
                <div style="font-size:.8rem;color:var(--text-muted);margin-top:4px;">⤷ Leave unselected to skip (scores 0)</div>
            </div>
        </div>
        <% } %>

        <div style="display:flex;justify-content:center;margin:30px 0;">
            <button type="button" onclick="submitExam()" class="btn btn-gold"
                    style="font-size:1.05rem;padding:13px 40px;">
                ✅ Submit Exam
            </button>
        </div>
    </form>
</div>

<!-- Floating progress tracker -->
<div class="progress-float" id="progressBox">
    <div style="font-weight:700;margin-bottom:6px;">📊 Progress</div>
    <div style="margin-bottom:4px;">Answered: <strong id="answeredCount">0</strong> / <%= questions.size() %></div>
    <div class="progress-bar-wrap">
        <div class="progress-bar-fill" id="progressFill" style="width:0%"></div>
    </div>
</div>

<script>
const totalQ = <%= questions.size() %>;
let answeredSet = new Set();
let seconds = 0;

// Timer
setInterval(() => {
    seconds++;
    const m = String(Math.floor(seconds/60)).padStart(2,'0');
    const s = String(seconds%60).padStart(2,'0');
    document.getElementById('timerBox').textContent = m + ':' + s;
}, 1000);

function markSelected(qId, optId) {
    // Remove selected class from all options of this question
    document.querySelectorAll('[id^="lbl_' + qId + '_"]').forEach(el => el.classList.remove('selected'));
    document.getElementById('lbl_' + qId + '_' + optId).classList.add('selected');
    answeredSet.add(qId);
    const pct = Math.round(answeredSet.size / totalQ * 100);
    document.getElementById('answeredCount').textContent = answeredSet.size;
    document.getElementById('progressFill').style.width = pct + '%';
}

function submitExam() {
    const unanswered = totalQ - answeredSet.size;
    let msg = unanswered > 0
        ? `You have ${unanswered} unanswered question(s). Skipped questions score 0.\n\nSubmit anyway?`
        : 'Submit your exam now?';
    if (confirm(msg)) document.getElementById('examForm').submit();
}

// Warn before leaving
window.onbeforeunload = () => 'Your exam is in progress. Are you sure you want to leave?';
document.getElementById('examForm').addEventListener('submit', () => { window.onbeforeunload = null; });
</script>
</body>
</html>
