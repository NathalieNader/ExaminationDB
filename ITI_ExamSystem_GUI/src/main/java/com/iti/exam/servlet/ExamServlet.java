package com.iti.exam.servlet;

import com.iti.exam.dao.*;
import com.iti.exam.model.Exam;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;

@WebServlet("/exam")
public class ExamServlet extends HttpServlet {

    private final ExamDAO        examDAO    = new ExamDAO();
    private final CourseDAO      courseDAO  = new CourseDAO();
    private final StudentExamDAO seDAO      = new StudentExamDAO();
    private final QuestionDAO    qDAO       = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        HttpSession session = req.getSession(false);

        try {
            switch (action) {

                /* ── Instructor: show generate exam form ─────────────── */
                case "generate_form": {
                    requireRole(session, resp, "instructor");
                    req.setAttribute("courses", courseDAO.getAll());
                    req.getRequestDispatcher("/pages/instructor/generate_exam.jsp").forward(req, resp);
                    break;
                }

                /* ── Admin/Instructor: list all exams ─────────────────── */
                case "list": {
                    req.setAttribute("exams", examDAO.getAll());
                    String page = isRole(session, "instructor")
                        ? "/pages/instructor/exams.jsp"
                        : "/pages/admin/exams.jsp";
                    req.getRequestDispatcher(page).forward(req, resp);
                    break;
                }

                /* ── Student: list available exams to take ────────────── */
                case "available": {
                    requireRole(session, resp, "student");
                    int studentId = (int) session.getAttribute("studentId");
                    req.setAttribute("exams", examDAO.getAvailableForStudent(studentId));
                    req.getRequestDispatcher("/pages/student/available_exams.jsp").forward(req, resp);
                    break;
                }

                /* ── Student: take an exam ───────────────────────────── */
                case "take": {
                    requireRole(session, resp, "student");
                    int studentId = (int) session.getAttribute("studentId");
                    int examId    = Integer.parseInt(req.getParameter("examId"));
                    if (seDAO.hasAttempted(studentId, examId)) {
                        resp.sendRedirect(req.getContextPath() + "/exam?action=available&error=already_taken");
                        return;
                    }
                    Exam exam = examDAO.getById(examId);
                    req.setAttribute("exam", exam);
                    req.setAttribute("startTime", System.currentTimeMillis());
                    req.getRequestDispatcher("/pages/student/take_exam.jsp").forward(req, resp);
                    break;
                }

                default:
                    resp.sendRedirect(req.getContextPath() + "/exam?action=list");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession(false);

        try {
            /* ── Instructor: generate exam ─────────────────────────── */
            if ("generate".equals(action)) {
                requireRole(session, resp, "instructor");
                int    courseId = Integer.parseInt(req.getParameter("courseId"));
                String examName = req.getParameter("examName");
                int    numMCQ   = Integer.parseInt(req.getParameter("numMCQ"));
                int    numTF    = Integer.parseInt(req.getParameter("numTF"));
                int    newId    = examDAO.generateExam(courseId, examName, numMCQ, numTF);
                resp.sendRedirect(req.getContextPath() + "/exam?action=list&success=Exam+'" + examName + "'+created+with+ID+" + newId);

            /* ── Student: submit exam answers ──────────────────────── */
            } else if ("submit".equals(action)) {
                requireRole(session, resp, "student");
                int studentId = (int) session.getAttribute("studentId");
                int examId    = Integer.parseInt(req.getParameter("examId"));
                long startMs  = Long.parseLong(req.getParameter("startTime"));

                // Build answers map
                Map<Integer, Integer> answers = new LinkedHashMap<>();
                Exam exam = examDAO.getById(examId);
                for (var q : exam.getQuestions()) {
                    String val = req.getParameter("q_" + q.getQuestionId());
                    answers.put(q.getQuestionId(), (val != null && !val.isEmpty()) ? Integer.parseInt(val) : null);
                }

                Timestamp start = new Timestamp(startMs);
                Timestamp end   = new Timestamp(System.currentTimeMillis());
                int seId = seDAO.submitExam(studentId, examId, start, end, answers);
                resp.sendRedirect(req.getContextPath() + "/student/results?seId=" + seId);

            } else {
                resp.sendRedirect(req.getContextPath() + "/exam?action=list");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }

    private void requireRole(HttpSession s, HttpServletResponse resp, String role) throws IOException {
        if (s == null || !role.equals(s.getAttribute("role")))
            resp.sendRedirect("login");
    }

    private boolean isRole(HttpSession s, String role) {
        return s != null && role.equals(s.getAttribute("role"));
    }
}
