<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Courses — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>

<%
    CourseDAO courseDAO = new CourseDAO();
    TrackDAO  trackDAO  = new TrackDAO();
    String actionParam  = request.getParameter("action");
    String msg = null; String msgType = "success";

    if ("delete".equals(actionParam)) {
        try { courseDAO.delete(Integer.parseInt(request.getParameter("id"))); msg = "Course deleted."; }
        catch (Exception ex) { msg = ex.getMessage(); msgType = "danger"; }
    }
    if ("POST".equals(request.getMethod())) {
        String pa = request.getParameter("action");
        try {
            if ("insert".equals(pa)) {
                int cId = courseDAO.insert(request.getParameter("courseName"),
                    Integer.parseInt(request.getParameter("minDegree")),
                    Integer.parseInt(request.getParameter("maxDegree")));
                // Assign to selected tracks
                String[] trackIds = request.getParameterValues("trackIds");
                if (trackIds != null)
                    for (String tid : trackIds) courseDAO.assignToTrack(Integer.parseInt(tid), cId);
                msg = "Course created.";
            } else if ("update".equals(pa)) {
                courseDAO.update(Integer.parseInt(request.getParameter("courseId")),
                    request.getParameter("courseName"),
                    Integer.parseInt(request.getParameter("minDegree")),
                    Integer.parseInt(request.getParameter("maxDegree")));
                msg = "Course updated.";
            }
        } catch (Exception ex) { msg = ex.getMessage(); msgType = "danger"; }
    }

    List<Course> courses = courseDAO.getAll();
    List<Track>  tracks  = trackDAO.getAll();
    Course editing = null;
    if ("edit".equals(actionParam) && request.getParameter("id") != null)
        editing = courseDAO.getById(Integer.parseInt(request.getParameter("id")));
%>

<div class="main-content">
    <div class="page-title">Manage <span>Courses</span></div>
    <% if (msg != null) { %><div class="alert alert-<%= msgType %>"><%= msg %></div><% } %>

    <div style="display:grid;grid-template-columns:400px 1fr;gap:20px;align-items:start;">
        <div class="card">
            <% if (editing != null) { %>
                <div class="card-header"><span class="card-title">✏️ Edit Course</span></div>
                <form method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="courseId" value="<%= editing.getCourseId() %>">
                    <div class="form-group"><label>Course Name *</label>
                        <input type="text" name="courseName" class="form-control" value="<%= editing.getCourseName() %>" required></div>
                    <div class="form-row">
                        <div class="form-group"><label>Min Degree</label>
                            <input type="number" name="minDegree" class="form-control" value="<%= editing.getMinDegree() %>"></div>
                        <div class="form-group"><label>Max Degree</label>
                            <input type="number" name="maxDegree" class="form-control" value="<%= editing.getMaxDegree() %>"></div>
                    </div>
                    <div style="display:flex;gap:8px;">
                        <button type="submit" class="btn btn-primary">💾 Update</button>
                        <a href="courses.jsp" class="btn btn-outline">Cancel</a>
                    </div>
                </form>
            <% } else { %>
                <div class="card-header"><span class="card-title">➕ Add Course</span></div>
                <form method="post">
                    <input type="hidden" name="action" value="insert">
                    <div class="form-group"><label>Course Name *</label>
                        <input type="text" name="courseName" class="form-control" placeholder="e.g. Java Programming" required></div>
                    <div class="form-row">
                        <div class="form-group"><label>Min Degree</label>
                            <input type="number" name="minDegree" class="form-control" placeholder="0" min="0"></div>
                        <div class="form-group"><label>Max Degree</label>
                            <input type="number" name="maxDegree" class="form-control" placeholder="100" min="1"></div>
                    </div>
                    <div class="form-group"><label>Assign to Track(s)</label>
                        <div style="max-height:140px;overflow-y:auto;border:1.5px solid var(--border);border-radius:7px;padding:8px;">
                        <% for (Track t : tracks) { %>
                            <label style="display:flex;align-items:center;gap:6px;padding:3px 0;font-weight:normal;">
                                <input type="checkbox" name="trackIds" value="<%= t.getTrackId() %>">
                                <%= t.getTrackName() %> — <%= t.getBranchName() %>
                            </label>
                        <% } %>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">✅ Add Course</button>
                </form>
            <% } %>
        </div>

        <div class="card">
            <div class="card-header">
                <span class="card-title">📖 All Courses (<%= courses.size() %>)</span>
                <input type="text" id="searchBox" class="form-control" style="max-width:220px;"
                       placeholder="🔍 Search..." onkeyup="filterTable()">
            </div>
            <div class="table-wrap">
                <table id="coursesTable">
                    <thead><tr><th>#</th><th>Course Name</th><th>Min</th><th>Max</th><th>Actions</th></tr></thead>
                    <tbody>
                        <% for (Course c : courses) { %>
                        <tr>
                            <td><%= c.getCourseId() %></td>
                            <td><strong><%= c.getCourseName() %></strong></td>
                            <td><%= c.getMinDegree() %></td>
                            <td><strong><%= c.getMaxDegree() %></strong></td>
                            <td>
                                <a href="courses.jsp?action=edit&id=<%= c.getCourseId() %>" class="btn btn-outline btn-sm">✏️</a>
                                <a href="courses.jsp?action=delete&id=<%= c.getCourseId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete course?')">🗑️</a>
                            </td>
                        </tr>
                        <% } %>
                        <% if (courses.isEmpty()) { %><tr><td colspan="5" style="text-align:center;padding:30px;color:#6b7280;">No courses yet.</td></tr><% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script>
function filterTable() {
    const q = document.getElementById('searchBox').value.toLowerCase();
    document.querySelectorAll('#coursesTable tbody tr').forEach(r => r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none');
}
</script>
</body>
</html>
