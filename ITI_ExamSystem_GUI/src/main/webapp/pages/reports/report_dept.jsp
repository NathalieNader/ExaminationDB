<%@ page contentType="text/html;charset=UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Report: Students by Department</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Map<String,Object>> rows = (List<Map<String,Object>>) request.getAttribute("rows");
    Integer deptNo = (Integer) request.getAttribute("deptNo");
    String error   = (String) request.getAttribute("error");
%>
<div class="main-content">
    <div class="page-title">Report: <span>Students by Department</span></div>

    <div class="card" style="max-width:500px;margin-bottom:20px;">
        <div class="card-header"><span class="card-title">🔍 Filter</span></div>
        <form method="get" action="${pageContext.request.contextPath}/reports"
              style="display:flex;gap:12px;align-items:flex-end;">
            <input type="hidden" name="type" value="dept">
            <div class="form-group" style="margin:0;flex:1;">
                <label>Department Number</label>
                <input type="number" name="dept" class="form-control"
                       placeholder="e.g. 101" min="1"
                       value="<%= deptNo != null ? deptNo : "" %>">
            </div>
            <button type="submit" class="btn btn-primary">📊 Run Report</button>
        </form>
    </div>

    <% if (error != null) { %><div class="alert alert-danger">❌ <%= error %></div><% } %>

    <% if (rows != null) { %>
    <div class="card">
        <div class="card-header">
            <span class="card-title">
                Department <%= deptNo %> — <%= rows.size() %> student(s)
            </span>
            <button onclick="printReport()" class="btn btn-outline btn-sm">🖨️ Print</button>
        </div>
        <% if (rows.isEmpty()) { %>
            <div class="alert alert-info">No students found for Department <%= deptNo %>.</div>
        <% } else { %>
        <div class="table-wrap" id="reportTable">
            <table>
                <thead>
                    <tr>
                        <% Map<String,Object> first = rows.get(0);
                           for (String col : first.keySet()) { %>
                        <th><%= col %></th>
                        <% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String,Object> row : rows) { %>
                    <tr>
                        <% for (Object val : row.values()) { %>
                        <td><%= val != null ? val : "—" %></td>
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
    w.document.write('<html><head><title>ITI Report</title><style>table{border-collapse:collapse;width:100%}th,td{border:1px solid #ccc;padding:8px}th{background:#003580;color:#fff}</style></head><body>');
    w.document.write('<h2>Students by Department ' + <%= deptNo %> + '</h2>');
    w.document.write(t.innerHTML);
    w.document.write('</body></html>');
    w.print();
}
</script>
</body>
</html>
