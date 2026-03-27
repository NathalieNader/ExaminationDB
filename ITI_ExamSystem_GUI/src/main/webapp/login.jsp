<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ITI — Exam System Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-page">
    <div class="login-box">
        <div class="login-logo">
            <div class="logo-big">ITI</div>
            <h2>Examination System</h2>
            <p>Information Technology Institute</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">${error}</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <!-- Role selector -->
            <div class="role-tabs" style="margin-bottom:20px;">
                <input type="radio" name="role" id="r-admin" value="admin">
                <label for="r-admin">&#128737; Admin</label>
                <input type="radio" name="role" id="r-instructor" value="instructor" checked>
                <label for="r-instructor">&#128203; Instructor</label>
                <input type="radio" name="role" id="r-student" value="student">
                <label for="r-student">&#127891; Student</label>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="your@email.com" required>
            </div>

            <div class="form-group" id="passGroup">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control"
                       placeholder="Password" required>
            </div>

            <div class="alert alert-info" id="loginHint" style="font-size:.82rem;">
                <strong>Instructor:</strong> password = DepartmentNo &nbsp;|&nbsp;
                <strong>Student:</strong> password = Phone number &nbsp;|&nbsp;
                <strong>Admin:</strong> admin@iti.eg / admin123
            </div>

            <button type="submit" class="btn btn-primary" style="width:100%;padding:11px;font-size:1rem;">
                Sign In →
            </button>
        </form>
    </div>
</div>
</body>
</html>
