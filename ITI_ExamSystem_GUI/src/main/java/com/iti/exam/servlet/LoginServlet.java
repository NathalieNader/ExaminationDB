package com.iti.exam.servlet;

import com.iti.exam.dao.InstructorDAO;
import com.iti.exam.dao.StudentDAO;
import com.iti.exam.model.Instructor;
import com.iti.exam.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * LoginServlet — simple role-based login.
 * Admin: hardcoded credentials (admin / admin123)
 * Instructor: matched by email
 * Student: matched by email
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final String ADMIN_EMAIL = "admin@iti.eg";
    private static final String ADMIN_PASS  = "admin123";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");

        try {
            HttpSession session = req.getSession();

            if ("admin".equals(role)) {
                if (ADMIN_EMAIL.equals(email) && ADMIN_PASS.equals(password)) {
                    session.setAttribute("role", "admin");
                    session.setAttribute("userName", "Administrator");
                    resp.sendRedirect(req.getContextPath() + "/pages/admin/dashboard.jsp");
                } else {
                    req.setAttribute("error", "Invalid admin credentials.");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                }

            } else if ("instructor".equals(role)) {
                InstructorDAO dao = new InstructorDAO();
                // Find instructor by email; password = departmentNo as string (demo auth)
                var instructors = dao.getAll();
                Instructor found = instructors.stream()
                    .filter(i -> i.getEmail().equalsIgnoreCase(email))
                    .findFirst().orElse(null);
                if (found != null && String.valueOf(found.getDepartmentNo()).equals(password)) {
                    session.setAttribute("role", "instructor");
                    session.setAttribute("instructorId", found.getInstructorId());
                    session.setAttribute("userName", found.getInstructorName());
                    resp.sendRedirect(req.getContextPath() + "/pages/instructor/dashboard.jsp");
                } else {
                    req.setAttribute("error", "Instructor not found or wrong password (use DepartmentNo).");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                }

            } else if ("student".equals(role)) {
                StudentDAO dao = new StudentDAO();
                Student s = dao.getByEmail(email);
                // password = phone number (demo auth)
                if (s != null && s.getPhone().equals(password)) {
                    session.setAttribute("role", "student");
                    session.setAttribute("studentId", s.getStudentId());
                    session.setAttribute("userName", s.getStudentName());
                    resp.sendRedirect(req.getContextPath() + "/pages/student/dashboard.jsp");
                } else {
                    req.setAttribute("error", "Student not found or wrong password (use Phone number).");
                    req.getRequestDispatcher("/login.jsp").forward(req, resp);
                }

            } else {
                req.setAttribute("error", "Please select a role.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "System error: " + e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
