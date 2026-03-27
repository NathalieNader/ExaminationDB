package com.iti.exam.servlet;

import com.iti.exam.dao.QuestionDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Returns JSON with available MCQ/TF count for a course.
 * Used by the Generate Exam form via AJAX.
 * GET /api/questionStats?courseId=X
 */
@WebServlet("/api/questionStats")
public class QuestionStatsServlet extends HttpServlet {

    private final QuestionDAO qDAO = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            resp.getWriter().write("{\"mcq\":0,\"tf\":0}");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            int mcq = qDAO.countAvailable(courseId, "MCQ");
            int tf  = qDAO.countAvailable(courseId, "TF");
            resp.getWriter().write("{\"mcq\":" + mcq + ",\"tf\":" + tf + "}");
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + e.getMessage().replace("\"","'") + "\"}");
        }
    }
}
