<%@ page contentType="text/html;charset=UTF-8" import="com.iti.exam.dao.*,com.iti.exam.model.*,java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Branches — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>

<%
    BranchDAO branchDAO = new BranchDAO();
    String actionParam = request.getParameter("action");
    String msg = null;
    String msgType = "success";

    // Handle POST-like actions via GET params for simplicity
    if ("delete".equals(actionParam)) {
        try {
            branchDAO.delete(Integer.parseInt(request.getParameter("id")));
            msg = "Branch deleted successfully.";
        } catch (Exception ex) { msg = ex.getMessage(); msgType = "danger"; }
    }

    // Handle form POST
    if ("POST".equals(request.getMethod())) {
        String postAction = request.getParameter("action");
        try {
            if ("insert".equals(postAction)) {
                branchDAO.insert(request.getParameter("branchName"), request.getParameter("location"));
                msg = "Branch created successfully.";
            } else if ("update".equals(postAction)) {
                branchDAO.update(Integer.parseInt(request.getParameter("branchId")),
                    request.getParameter("branchName"), request.getParameter("location"));
                msg = "Branch updated successfully.";
            }
        } catch (Exception ex) { msg = ex.getMessage(); msgType = "danger"; }
    }

    List<Branch> branches = branchDAO.getAll();

    // For edit mode
    Branch editing = null;
    if ("edit".equals(actionParam) && request.getParameter("id") != null) {
        editing = branchDAO.getById(Integer.parseInt(request.getParameter("id")));
    }
%>

<div class="main-content">
    <div class="page-title">Manage <span>Branches</span></div>

    <% if (msg != null) { %>
        <div class="alert alert-<%= msgType %>"><%= msgType.equals("success") ? "✅" : "❌" %> <%= msg %></div>
    <% } %>

    <div style="display:grid;grid-template-columns:380px 1fr;gap:20px;align-items:start;">

        <!-- Form Panel -->
        <div class="card">
            <% if (editing != null) { %>
                <div class="card-header"><span class="card-title">✏️ Edit Branch</span></div>
                <form method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="branchId" value="<%= editing.getBranchId() %>">
                    <div class="form-group">
                        <label>Branch Name *</label>
                        <input type="text" name="branchName" class="form-control"
                               value="<%= editing.getBranchName() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Location</label>
                        <input type="text" name="location" class="form-control"
                               value="<%= editing.getLocation() != null ? editing.getLocation() : "" %>">
                    </div>
                    <div style="display:flex;gap:8px;">
                        <button type="submit" class="btn btn-primary">💾 Update</button>
                        <a href="branches.jsp" class="btn btn-outline">Cancel</a>
                    </div>
                </form>
            <% } else { %>
                <div class="card-header"><span class="card-title">➕ Add Branch</span></div>
                <form method="post">
                    <input type="hidden" name="action" value="insert">
                    <div class="form-group">
                        <label>Branch Name *</label>
                        <input type="text" name="branchName" class="form-control" placeholder="e.g. Cairo Branch" required>
                    </div>
                    <div class="form-group">
                        <label>Location</label>
                        <input type="text" name="location" class="form-control" placeholder="e.g. Smart Village, Giza">
                    </div>
                    <button type="submit" class="btn btn-primary">✅ Add Branch</button>
                </form>
            <% } %>
        </div>

        <!-- Branches Table -->
        <div class="card">
            <div class="card-header">
                <span class="card-title">🏢 All Branches (<%= branches.size() %>)</span>
            </div>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr><th>#</th><th>Branch Name</th><th>Location</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <% for (Branch b : branches) { %>
                        <tr>
                            <td><%= b.getBranchId() %></td>
                            <td><strong><%= b.getBranchName() %></strong></td>
                            <td><%= b.getLocation() != null ? b.getLocation() : "—" %></td>
                            <td>
                                <a href="branches.jsp?action=edit&id=<%= b.getBranchId() %>"
                                   class="btn btn-outline btn-sm">✏️</a>
                                <a href="branches.jsp?action=delete&id=<%= b.getBranchId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete branch?')">🗑️</a>
                            </td>
                        </tr>
                        <% } %>
                        <% if (branches.isEmpty()) { %>
                        <tr><td colspan="4" style="text-align:center;color:#6b7280;padding:30px;">No branches yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
