package com.iti.exam.servlet;

import com.iti.exam.dao.StudentDAO;
import com.iti.exam.dao.TrackDAO;
import com.iti.exam.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/students")
public class StudentServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final TrackDAO   trackDAO   = new TrackDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        requireAdmin(req, resp);
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "edit": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("student", studentDAO.getById(id));
                    req.setAttribute("tracks",  trackDAO.getAll());
                    req.setAttribute("assignedTrackIds", studentDAO.getTrackIds(id));
                    req.getRequestDispatcher("/pages/admin/student_form.jsp").forward(req, resp);
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    studentDAO.delete(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/students?success=deleted");
                    break;
                }
                default: {
                    req.setAttribute("students", studentDAO.getAll());
                    req.getRequestDispatcher("/pages/admin/students.jsp").forward(req, resp);
                }
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/pages/admin/students.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        requireAdmin(req, resp);
        String action = req.getParameter("action");

        try {
            if ("insert".equals(action)) {
                String name  = req.getParameter("studentName");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                int newId = studentDAO.insert(name, email, phone);

                // Assign to selected tracks
                String[] trackIds = req.getParameterValues("trackIds");
                if (trackIds != null) {
                    for (String tid : trackIds)
                        studentDAO.assignToTrack(newId, Integer.parseInt(tid));
                }
                resp.sendRedirect(req.getContextPath() + "/admin/students?success=created");

            } else if ("update".equals(action)) {
                int id    = Integer.parseInt(req.getParameter("studentId"));
                String name  = req.getParameter("studentName");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                studentDAO.update(id, name, email, phone);
                resp.sendRedirect(req.getContextPath() + "/admin/students?success=updated");

            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/students");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            try {
                req.setAttribute("students", studentDAO.getAll());
            } catch (Exception ignored) {}
            req.getRequestDispatcher("/pages/admin/students.jsp").forward(req, resp);
        }
    }

    private void requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || !"admin".equals(s.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
}
