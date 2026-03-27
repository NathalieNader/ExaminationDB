<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Report: Instructor Courses</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Map<String,Object>> rows        = (List<Map<String,Object>>) request.getAttribute("rows");
    List<Instructor>         instructors = (List<Instructor>)         request.getAttribute("instructors");
    Integer selInstrId = (Integer) request.getAttribute("selectedInstructorId");
    String  error      = (String)  request.getAttribute("error");
    boolean isInstructor = "instructor".equals(session.getAttribute("role"));
%>
<div class="main-content">
    <div class="page-title">Report: <span>Instructor Courses</span></div>

    <% if (!isInstructor) { %>
    <div class="card" style="max-width:500px;margin-bottom:20px;">
        <div class="card-header"><span class="card-title">🔍 Filter</span></div>
        <form method="get" action="${pageContext.request.contextPath}/reports"
              style="display:flex;gap:12px;align-items:flex-end;">
            <input type="hidden" name="type" value="instructor">
            <div class="form-group" style="margin:0;flex:1;">
                <label>Select Instructor</label>
                <select name="instructorId" class="form-control">
                    <option value="">— Select Instructor —</option>
                    <% if (instructors != null) { for (Instructor i : instructors) { %>
                    <option value="<%= i.getInstructorId() %>"
                        <%= selInstrId != null && selInstrId == i.getInstructorId() ? "selected" : "" %>>
                        <%= i.getInstructorName() %> (Dept <%= i.getDepartmentNo() %>)
                    </option>
                    <% } } %>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">📊 Run Report</button>
        </form>
    </div>
    <% } %>

    <% if (error != null) { %><div class="alert alert-danger">❌ <%= error %></div><% } %>

    <% if (rows != null) { %>
    <div class="card">
        <div class="card-header">
            <span class="card-title">👨‍🏫 Courses &amp; Student Counts (<%= rows.size() %> row(s))</span>
            <button onclick="printReport()" class="btn btn-outline btn-sm">🖨️ Print</button>
        </div>
        <% if (rows.isEmpty()) { %>
            <div class="alert alert-info">No courses assigned to this instructor.</div>
        <% } else { %>
        <div class="table-wrap" id="reportTable">
            <table>
                <thead>
                    <tr>
                        <% for (String col : rows.get(0).keySet()) { %>
                        <th><%= col %></th>
                        <% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String,Object> row : rows) { %>
                    <tr>
                        <% for (Map.Entry<String,Object> entry : row.entrySet()) {
                            boolean isCount = "StudentCount".equals(entry.getKey()); %>
                        <td>
                            <% if (isCount) { %>
                                <span style="font-weight:800;font-size:1.05rem;color:var(--iti-blue);">
                                    <%= entry.getValue() != null ? entry.getValue() : 0 %>
                                </span> students
                            <% } else { %>
                                <%= entry.getValue() != null ? entry.getValue() : "—" %>
                            <% } %>
                        </td>
                        <% } %>
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
    w.document.write('<html><head><title>Instructor Report</title><style>table{border-collapse:collapse;width:100%}th,td{border:1px solid #ccc;padding:8px}th{background:#003580;color:#fff}</style></head><body>');
    w.document.write('<h2>Instructor Courses Report</h2>');
    w.document.write(t.innerHTML);
    w.document.write('</body></html>');
    w.print();
}
</script>
</body>
</html>
