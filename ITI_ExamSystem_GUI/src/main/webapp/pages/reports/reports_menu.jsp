<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Reports — ITI Exam System</title></head>
<body>
<%@ include file="/WEB-INF/header.jsp" %>
<div class="main-content">
    <div class="page-title">System <span>Reports</span></div>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:20px;max-width:900px;">

        <div class="card" style="border-top:4px solid var(--iti-blue);text-align:center;padding:32px 24px;">
            <div style="font-size:2.5rem;margin-bottom:12px;">📊</div>
            <div style="font-weight:700;font-size:1.1rem;color:var(--iti-blue);margin-bottom:8px;">Students by Department</div>
            <p style="color:var(--text-muted);font-size:.88rem;margin-bottom:16px;">
                View all students linked to a department number, with their tracks and branch names.
            </p>
            <a href="${pageContext.request.contextPath}/reports?type=dept" class="btn btn-primary" style="width:100%;justify-content:center;">
                Open Report →
            </a>
        </div>

        <div class="card" style="border-top:4px solid var(--iti-gold);text-align:center;padding:32px 24px;">
            <div style="font-size:2.5rem;margin-bottom:12px;">📈</div>
            <div style="font-weight:700;font-size:1.1rem;color:var(--iti-blue);margin-bottom:8px;">Student Grades</div>
            <p style="color:var(--text-muted);font-size:.88rem;margin-bottom:16px;">
                View all exam grades for a specific student with percentage and pass/fail status.
            </p>
            <a href="${pageContext.request.contextPath}/reports?type=grades" class="btn btn-gold" style="width:100%;justify-content:center;">
                Open Report →
            </a>
        </div>

        <div class="card" style="border-top:4px solid var(--success);text-align:center;padding:32px 24px;">
            <div style="font-size:2.5rem;margin-bottom:12px;">👨‍🏫</div>
            <div style="font-weight:700;font-size:1.1rem;color:var(--iti-blue);margin-bottom:8px;">Instructor Courses</div>
            <p style="color:var(--text-muted);font-size:.88rem;margin-bottom:16px;">
                View all courses an instructor teaches, along with the student count per track.
            </p>
            <a href="${pageContext.request.contextPath}/reports?type=instructor" class="btn btn-success" style="width:100%;justify-content:center;">
                Open Report →
            </a>
        </div>

    </div>
</div>
</body>
</html>
