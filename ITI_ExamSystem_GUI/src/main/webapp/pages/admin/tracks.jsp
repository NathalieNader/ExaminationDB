<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,com.iti.exam.model.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Tracks — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>

<%
    TrackDAO  trackDAO  = new TrackDAO();
    BranchDAO branchDAO = new BranchDAO();
    String actionParam  = request.getParameter("action");
    String msg = null; String msgType = "success";

    if ("delete".equals(actionParam)) {
        try { trackDAO.delete(Integer.parseInt(request.getParameter("id"))); msg = "Track deleted."; }
        catch (Exception ex) { msg = ex.getMessage(); msgType = "danger"; }
    }
    if ("POST".equals(request.getMethod())) {
        String pa = request.getParameter("action");
        try {
            if ("insert".equals(pa)) {
                trackDAO.insert(request.getParameter("trackName"),
                    Integer.parseInt(request.getParameter("branchId")),
                    Integer.parseInt(request.getParameter("durationMonths")));
                msg = "Track created successfully.";
            } else if ("update".equals(pa)) {
                trackDAO.update(Integer.parseInt(request.getParameter("trackId")),
                    request.getParameter("trackName"),
                    Integer.parseInt(request.getParameter("branchId")),
                    Integer.parseInt(request.getParameter("durationMonths")));
                msg = "Track updated.";
            }
        } catch (Exception ex) { msg = ex.getMessage(); msgType = "danger"; }
    }

    List<Track>  tracks   = trackDAO.getAll();
    List<Branch> branches = branchDAO.getAll();
    Track editing = null;
    if ("edit".equals(actionParam) && request.getParameter("id") != null)
        editing = trackDAO.getByBranch(0).stream()
            .filter(t -> t.getTrackId() == Integer.parseInt(request.getParameter("id")))
            .findFirst().orElse(null);
    // better: just get all tracks and find
    if (editing == null && "edit".equals(actionParam) && request.getParameter("id") != null) {
        int tid = Integer.parseInt(request.getParameter("id"));
        editing = tracks.stream().filter(t -> t.getTrackId() == tid).findFirst().orElse(null);
    }
%>

<div class="main-content">
    <div class="page-title">Manage <span>Tracks</span></div>
    <% if (msg != null) { %><div class="alert alert-<%= msgType %>"><%= msg %></div><% } %>

    <div style="display:grid;grid-template-columns:380px 1fr;gap:20px;align-items:start;">
        <div class="card">
            <% if (editing != null) { %>
                <div class="card-header"><span class="card-title">✏️ Edit Track</span></div>
                <form method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="trackId" value="<%= editing.getTrackId() %>">
                    <div class="form-group"><label>Track Name *</label>
                        <input type="text" name="trackName" class="form-control" value="<%= editing.getTrackName() %>" required></div>
                    <div class="form-group"><label>Branch *</label>
                        <select name="branchId" class="form-control">
                            <% for (Branch b : branches) { %>
                            <option value="<%= b.getBranchId() %>" <%= b.getBranchId() == editing.getBranchId() ? "selected" : "" %>><%= b.getBranchName() %></option>
                            <% } %>
                        </select></div>
                    <div class="form-group"><label>Duration (months)</label>
                        <input type="number" name="durationMonths" class="form-control" value="<%= editing.getDurationMonths() %>" min="1"></div>
                    <div style="display:flex;gap:8px;">
                        <button type="submit" class="btn btn-primary">💾 Update</button>
                        <a href="tracks.jsp" class="btn btn-outline">Cancel</a>
                    </div>
                </form>
            <% } else { %>
                <div class="card-header"><span class="card-title">➕ Add Track</span></div>
                <form method="post">
                    <input type="hidden" name="action" value="insert">
                    <div class="form-group"><label>Track Name *</label>
                        <input type="text" name="trackName" class="form-control" placeholder="e.g. Web Development" required></div>
                    <div class="form-group"><label>Branch *</label>
                        <select name="branchId" class="form-control">
                            <option value="">-- Select Branch --</option>
                            <% for (Branch b : branches) { %>
                            <option value="<%= b.getBranchId() %>"><%= b.getBranchName() %></option>
                            <% } %>
                        </select></div>
                    <div class="form-group"><label>Duration (months)</label>
                        <input type="number" name="durationMonths" class="form-control" placeholder="9" min="1"></div>
                    <button type="submit" class="btn btn-primary">✅ Add Track</button>
                </form>
            <% } %>
        </div>

        <div class="card">
            <div class="card-header"><span class="card-title">📚 All Tracks (<%= tracks.size() %>)</span></div>
            <div class="table-wrap">
                <table>
                    <thead><tr><th>#</th><th>Track Name</th><th>Branch</th><th>Duration</th><th>Actions</th></tr></thead>
                    <tbody>
                        <% for (Track t : tracks) { %>
                        <tr>
                            <td><%= t.getTrackId() %></td>
                            <td><strong><%= t.getTrackName() %></strong></td>
                            <td><%= t.getBranchName() %></td>
                            <td><%= t.getDurationMonths() %> months</td>
                            <td>
                                <a href="tracks.jsp?action=edit&id=<%= t.getTrackId() %>" class="btn btn-outline btn-sm">✏️</a>
                                <a href="tracks.jsp?action=delete&id=<%= t.getTrackId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete this track?')">🗑️</a>
                            </td>
                        </tr>
                        <% } %>
                        <% if (tracks.isEmpty()) { %><tr><td colspan="5" style="text-align:center;padding:30px;color:#6b7280;">No tracks yet.</td></tr><% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
