<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error — ITI Exam System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div style="min-height:100vh;display:flex;align-items:center;justify-content:center;background:var(--body-bg);">
    <div class="card" style="max-width:480px;text-align:center;padding:48px 32px;">
        <div style="font-size:4rem;margin-bottom:16px;">⚠️</div>
        <h2 style="color:var(--danger);margin-bottom:12px;">Something Went Wrong</h2>
        <% String err = (String) request.getAttribute("error");
           if (err != null && !err.isEmpty()) { %>
            <div class="alert alert-danger"><%= err %></div>
        <% } else if (exception != null) { %>
            <div class="alert alert-danger"><%= exception.getMessage() %></div>
        <% } else { %>
            <div class="alert alert-danger">An unexpected error occurred.</div>
        <% } %>
        <div style="display:flex;gap:10px;justify-content:center;margin-top:20px;">
            <a href="javascript:history.back()" class="btn btn-outline">← Go Back</a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">🏠 Home</a>
        </div>
    </div>
</div>
</body>
</html>
