package com.iti.exam.servlet;

import com.iti.exam.dao.*;
import com.iti.exam.model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/instructor/questions")
public class QuestionServlet extends HttpServlet {

    private final QuestionDAO qDAO     = new QuestionDAO();
    private final CourseDAO   courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        requireInstructor(req, resp);
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add_form": {
                    req.setAttribute("courses", courseDAO.getAll());
                    req.getRequestDispatcher("/pages/instructor/question_form.jsp").forward(req, resp);
                    break;
                }
                case "edit": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Question q = qDAO.getById(id);
                    req.setAttribute("question", q);
                    req.setAttribute("courses", courseDAO.getAll());
                    req.getRequestDispatcher("/pages/instructor/question_edit.jsp").forward(req, resp);
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    qDAO.delete(id);
                    resp.sendRedirect(req.getContextPath() + "/instructor/questions?success=deleted");
                    break;
                }
                default: {
                    String courseFilter = req.getParameter("courseId");
                    List<Question> questions;
                    if (courseFilter != null && !courseFilter.isEmpty())
                        questions = qDAO.getByCourse(Integer.parseInt(courseFilter));
                    else
                        questions = qDAO.getAll();
                    req.setAttribute("questions", questions);
                    req.setAttribute("courses", courseDAO.getAll());
                    req.setAttribute("selectedCourseId", courseFilter);
                    req.getRequestDispatcher("/pages/instructor/questions.jsp").forward(req, resp);
                }
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/pages/instructor/questions.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        requireInstructor(req, resp);
        String action = req.getParameter("action");

        try {
            if ("insert".equals(action)) {
                int    courseId      = Integer.parseInt(req.getParameter("courseId"));
                String questionText  = req.getParameter("questionText");
                String questionType  = req.getParameter("questionType");
                int    points        = Integer.parseInt(req.getParameter("points"));
                int    correctIdx    = Integer.parseInt(req.getParameter("correctOption"));

                List<String> options = new ArrayList<>();
                if ("MCQ".equals(questionType)) {
                    for (int i = 1; i <= 4; i++) options.add(req.getParameter("option" + i));
                } else {
                    options.add("True"); options.add("False");
                }
                qDAO.insert(courseId, questionText, questionType, points, options, correctIdx);
                resp.sendRedirect(req.getContextPath() + "/instructor/questions?success=created");

            } else if ("update".equals(action)) {
                int    id    = Integer.parseInt(req.getParameter("questionId"));
                String text  = req.getParameter("questionText");
                String type  = req.getParameter("questionType");
                int    pts   = Integer.parseInt(req.getParameter("points"));
                qDAO.update(id, text, type, pts);
                resp.sendRedirect(req.getContextPath() + "/instructor/questions?success=updated");

            } else {
                resp.sendRedirect(req.getContextPath() + "/instructor/questions");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("courses", courseDAO.getAll());
            req.getRequestDispatcher("/pages/instructor/question_form.jsp").forward(req, resp);
        }
    }

    private void requireInstructor(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || !"instructor".equals(s.getAttribute("role")))
            resp.sendRedirect(req.getContextPath() + "/login");
    }
}
