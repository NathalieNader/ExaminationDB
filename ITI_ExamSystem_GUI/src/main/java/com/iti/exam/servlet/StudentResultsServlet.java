package com.iti.exam.servlet;

import com.iti.exam.dao.StudentExamDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/student/results")
public class StudentResultsServlet extends HttpServlet {

    private final StudentExamDAO seDAO = new StudentExamDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int studentId = (int) session.getAttribute("studentId");

        try {
            String seIdStr = req.getParameter("seId");
            if (seIdStr != null) {
                // Show specific result after exam submission
                req.setAttribute("results", seDAO.getByStudent(studentId));
                req.setAttribute("highlightId", Integer.parseInt(seIdStr));
            } else {
                req.setAttribute("results", seDAO.getByStudent(studentId));
            }
            req.getRequestDispatcher("/pages/student/results.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/pages/student/results.jsp").forward(req, resp);
        }
    }
}
