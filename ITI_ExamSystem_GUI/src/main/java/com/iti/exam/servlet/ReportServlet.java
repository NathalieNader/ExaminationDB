package com.iti.exam.servlet;

import com.iti.exam.dao.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private final ReportDAO      reportDAO  = new ReportDAO();
    private final InstructorDAO  instrDAO   = new InstructorDAO();
    private final StudentDAO     studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String type = req.getParameter("type");
        if (type == null) type = "menu";

        try {
            switch (type) {

                case "dept": {
                    String deptStr = req.getParameter("dept");
                    if (deptStr != null && !deptStr.isEmpty()) {
                        int deptNo = Integer.parseInt(deptStr);
                        req.setAttribute("rows", reportDAO.studentsByDepartment(deptNo));
                        req.setAttribute("deptNo", deptNo);
                    }
                    req.getRequestDispatcher("/pages/reports/report_dept.jsp").forward(req, resp);
                    break;
                }

                case "grades": {
                    String sidStr = req.getParameter("studentId");
                    // Students can only see their own grades
                    if ("student".equals(session.getAttribute("role"))) {
                        sidStr = String.valueOf(session.getAttribute("studentId"));
                    }
                    if (sidStr != null && !sidStr.isEmpty()) {
                        int sid = Integer.parseInt(sidStr);
                        req.setAttribute("grades", reportDAO.studentGrades(sid));
                        req.setAttribute("students", studentDAO.getAll());
                        req.setAttribute("selectedStudentId", sid);
                    } else {
                        req.setAttribute("students", studentDAO.getAll());
                    }
                    req.getRequestDispatcher("/pages/reports/report_grades.jsp").forward(req, resp);
                    break;
                }

                case "instructor": {
                    String iidStr = req.getParameter("instructorId");
                    // Instructors see their own report
                    if ("instructor".equals(session.getAttribute("role"))) {
                        iidStr = String.valueOf(session.getAttribute("instructorId"));
                    }
                    if (iidStr != null && !iidStr.isEmpty()) {
                        int iid = Integer.parseInt(iidStr);
                        req.setAttribute("rows", reportDAO.instructorCourses(iid));
                        req.setAttribute("instructors", instrDAO.getAll());
                        req.setAttribute("selectedInstructorId", iid);
                    } else {
                        req.setAttribute("instructors", instrDAO.getAll());
                    }
                    req.getRequestDispatcher("/pages/reports/report_instructor.jsp").forward(req, resp);
                    break;
                }

                default:
                    req.getRequestDispatcher("/pages/reports/reports_menu.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/pages/reports/reports_menu.jsp").forward(req, resp);
        }
    }
}
