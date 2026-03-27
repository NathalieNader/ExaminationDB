<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Instructors — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>

<%
    InstructorDAO instrDAO = new InstructorDAO();
    CourseDAO     courseDAO = new CourseDAO();
    String actionParam = request.getParameter("action");
    String msg = null; String msgType = "success";

    if ("delete".equals(actionParam)) {
        try { instrDAO.delete(Integer.parseInt(request.getParameter("id"))); msg = "Instructor deleted."; }
        catch (Exception ex) { msg = ex.getMessage(); msgType = "danger"; }
    }
    if ("removeCourse".equals(actionParam)) {
        try {
            instrDAO.removeFromCourse(Integer.parseInt(request.getParameter("iid")),
                                      Integer.parseInt(request.getParameter("cid")));
            msg = "Course unassigned.";
        } catch (Exception ex) { msg = ex.getMessage(); msgType = "danger"; }
    }
    if ("POST".equals(request.getMethod())) {
        String pa = request.getParameter("action");
        try {
            if ("insert".equals(pa)) {
                int iId = instrDAO.insert(request.getParameter("instructorName"),
                    request.getParameter("email"),
                    Integer.parseInt(request.getParameter("departmentNo")));
                String[] courseIds = request.getParameterValues("courseIds");
                if (courseIds != null)
                    for (String cid : courseIds) instrDAO.assignToCourse(iId, Integer.parseInt(cid));
                msg = "Instructor created.";
            } else if ("update".equals(pa)) {
                instrDAO.update(Integer.parseInt(request.getParameter("instructorId")),
                    request.getParameter("instructorName"), request.getParameter("email"),
                    Integer.parseInt(request.getParameter("departmentNo")));
                msg = "Instructor updated.";
            } else if ("assignCourse".equals(pa)) {
                instrDAO.assignToCourse(Integer.parseInt(request.getParameter("instructorId")),
                    Integer.parseInt(request.getParameter("courseId")));
                msg = "Course assigned.";
            }
        } catch (Exception ex) { msg = ex.getMessage(); msgType = "danger"; }
    }

    List<Instructor> instructors = instrDAO.getAll();
    List<Course>     courses     = courseDAO.getAll();
    Instructor editing = null;
    if ("edit".equals(actionParam) && request.getParameter("id") != null)
        editing = instrDAO.getById(Integer.parseInt(request.getParameter("id")));
%>

<div class="main-content">
    <div class="page-title">Manage <span>Instructors</span></div>
    <% if (msg != null) { %><div class="alert alert-<%= msgType %>"><%= msg %></div><% } %>

    <div style="display:grid;grid-template-columns:400px 1fr;gap:20px;align-items:start;">
        <!-- Form -->
        <div class="card">
            <% if (editing != null) { %>
                <div class="card-header"><span class="card-title">✏️ Edit Instructor</span></div>
                <form method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="instructorId" value="<%= editing.getInstructorId() %>">
                    <div class="form-group"><label>Name *</label>
                        <input type="text" name="instructorName" class="form-control" value="<%= editing.getInstructorName() %>" required></div>
                    <div class="form-group"><label>Email *</label>
                        <input type="email" name="email" class="form-control" value="<%= editing.getEmail() %>" required></div>
                    <div class="form-group"><label>Department No *</label>
                        <input type="number" name="departmentNo" class="form-control" value="<%= editing.getDepartmentNo() %>" required></div>
                    <div style="display:flex;gap:8px;">
                        <button type="submit" class="btn btn-primary">💾 Update</button>
                        <a href="instructors.jsp" class="btn btn-outline">Cancel</a>
                    </div>
                </form>

                <!-- Assign course to this instructor -->
                <hr style="margin:16px 0;">
                <div style="font-weight:700;margin-bottom:8px;color:var(--iti-blue);">📚 Assign Course</div>
                <form method="post">
                    <input type="hidden" name="action" value="assignCourse">
                    <input type="hidden" name="instructorId" value="<%= editing.getInstructorId() %>">
                    <div style="display:flex;gap:8px;">
                        <select name="courseId" class="form-control">
                            <% for (Course c : courses) { %>
                            <option value="<%= c.getCourseId() %>"><%= c.getCourseName() %></option>
                            <% } %>
                        </select>
                        <button type="submit" class="btn btn-gold btn-sm">Assign</button>
                    </div>
                </form>
                <%
                    List<Integer> assignedIds = instrDAO.getCourseIds(editing.getInstructorId());
                    if (!assignedIds.isEmpty()) {
                %>
                <div style="margin-top:10px;">
                    <div style="font-size:.82rem;color:var(--text-muted);margin-bottom:4px;">Currently assigned:</div>
                    <% for (Course c : courses) {
                        if (assignedIds.contains(c.getCourseId())) { %>
                        <span style="display:inline-flex;align-items:center;gap:4px;background:#e7f0ff;color:var(--iti-blue);
                               border-radius:20px;padding:2px 10px;font-size:.8rem;margin:2px;">
                            <%= c.getCourseName() %>
                            <a href="instructors.jsp?action=removeCourse&iid=<%= editing.getInstructorId() %>&cid=<%= c.getCourseId() %>"
                               style="color:var(--danger);text-decoration:none;font-weight:700;" title="Remove">×</a>
                        </span>
                    <% } } %>
                </div>
                <% } %>
            <% } else { %>
                <div class="card-header"><span class="card-title">➕ Add Instructor</span></div>
                <form method="post">
                    <input type="hidden" name="action" value="insert">
                    <div class="form-group"><label>Name *</label>
                        <input type="text" name="instructorName" class="form-control" placeholder="Dr. Mohamed Ali" required></div>
                    <div class="form-group"><label>Email *</label>
                        <input type="email" name="email" class="form-control" placeholder="instructor@iti.eg" required></div>
                    <div class="form-group"><label>Department No *</label>
                        <input type="number" name="departmentNo" class="form-control" placeholder="101" required></div>
                    <div class="form-group"><label>Assign Courses</label>
                        <div style="max-height:130px;overflow-y:auto;border:1.5px solid var(--border);border-radius:7px;padding:8px;">
                        <% for (Course c : courses) { %>
                            <label style="display:flex;align-items:center;gap:6px;padding:2px 0;font-weight:normal;">
                                <input type="checkbox" name="courseIds" value="<%= c.getCourseId() %>">
                                <%= c.getCourseName() %>
                            </label>
                        <% } %>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">✅ Add Instructor</button>
                </form>
            <% } %>
        </div>

        <!-- Table -->
        <div class="card">
            <div class="card-header">
                <span class="card-title">🎓 All Instructors (<%= instructors.size() %>)</span>
                <input type="text" id="searchBox" class="form-control" style="max-width:220px;"
                       placeholder="🔍 Search..." onkeyup="filterTable()">
            </div>
            <div class="table-wrap">
                <table id="instrTable">
                    <thead><tr><th>#</th><th>Name</th><th>Email</th><th>Dept No</th><th>Actions</th></tr></thead>
                    <tbody>
                        <% for (Instructor i : instructors) { %>
                        <tr>
                            <td><%= i.getInstructorId() %></td>
                            <td><strong><%= i.getInstructorName() %></strong></td>
                            <td><%= i.getEmail() %></td>
                            <td><span class="badge badge-mcq">Dept <%= i.getDepartmentNo() %></span></td>
                            <td>
                                <a href="instructors.jsp?action=edit&id=<%= i.getInstructorId() %>" class="btn btn-outline btn-sm">✏️ Edit</a>
                                <a href="instructors.jsp?action=delete&id=<%= i.getInstructorId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete this instructor?')">🗑️</a>
                            </td>
                        </tr>
                        <% } %>
                        <% if (instructors.isEmpty()) { %><tr><td colspan="5" style="text-align:center;padding:30px;color:#6b7280;">No instructors yet.</td></tr><% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script>
function filterTable() {
    const q = document.getElementById('searchBox').value.toLowerCase();
    document.querySelectorAll('#instrTable tbody tr').forEach(r => r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none');
}
</script>
</body>
</html>
