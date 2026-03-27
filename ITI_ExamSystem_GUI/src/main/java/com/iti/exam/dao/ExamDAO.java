package com.iti.exam.dao;

import com.iti.exam.model.Exam;
import com.iti.exam.model.Option;
import com.iti.exam.model.Question;
import com.iti.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ExamDAO — calls GenerateExam stored procedure and handles exam queries.
 */
public class ExamDAO {

    /**
     * Calls GenerateExam SP.
     * @return the new ExamID, or -1 on error
     */
    public int generateExam(int courseId, String examName, int numMCQ, int numTF) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL GenerateExam(?,?,?,?,?)}")) {
            cs.setInt(1, courseId);
            cs.setString(2, examName);
            cs.setInt(3, numMCQ);
            cs.setInt(4, numTF);
            cs.registerOutParameter(5, Types.INTEGER);
            cs.execute();
            return cs.getInt(5);
        }
    }

    public List<Exam> getAll() throws SQLException {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT e.ExamID, e.ExamName, e.CourseID, c.CourseName, e.CreatedDate, e.TotalQuestions " +
                     "FROM Exam e JOIN Course c ON e.CourseID = c.CourseID ORDER BY e.CreatedDate DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Exam> getByCourse(int courseId) throws SQLException {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT e.ExamID, e.ExamName, e.CourseID, c.CourseName, e.CreatedDate, e.TotalQuestions " +
                     "FROM Exam e JOIN Course c ON e.CourseID = c.CourseID " +
                     "WHERE e.CourseID = ? ORDER BY e.CreatedDate DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public Exam getById(int examId) throws SQLException {
        String sql = "SELECT e.ExamID, e.ExamName, e.CourseID, c.CourseName, e.CreatedDate, e.TotalQuestions " +
                     "FROM Exam e JOIN Course c ON e.CourseID = c.CourseID WHERE e.ExamID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Exam exam = mapRow(rs);
                exam.setQuestions(getExamQuestions(examId));
                return exam;
            }
        }
        return null;
    }

    /** Load all questions (with options) for an exam — used when student takes it */
    public List<Question> getExamQuestions(int examId) throws SQLException {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.QuestionID, q.CourseID, c.CourseName, q.QuestionText, q.QuestionType, " +
                     "q.Points, eq.OrderNo, ISNULL(ma.OptionID,0) AS ModelAnswerOptionID " +
                     "FROM Exam_Question eq " +
                     "JOIN Question q ON eq.QuestionID = q.QuestionID " +
                     "JOIN Course c ON q.CourseID = c.CourseID " +
                     "LEFT JOIN ModelAnswer ma ON ma.QuestionID = q.QuestionID " +
                     "WHERE eq.ExamID = ? ORDER BY eq.OrderNo";
        QuestionDAO qDAO = new QuestionDAO();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("QuestionID"));
                q.setCourseId(rs.getInt("CourseID"));
                q.setCourseName(rs.getString("CourseName"));
                q.setQuestionText(rs.getString("QuestionText"));
                q.setQuestionType(rs.getString("QuestionType"));
                q.setPoints(rs.getInt("Points"));
                q.setModelAnswerOptionId(rs.getInt("ModelAnswerOptionID"));
                q.setOptions(qDAO.getOptions(q.getQuestionId()));
                questions.add(q);
            }
        }
        return questions;
    }

    /** Exams available to a student (not yet taken) */
    public List<Exam> getAvailableForStudent(int studentId) throws SQLException {
        List<Exam> list = new ArrayList<>();
        String sql =
            "SELECT e.ExamID, e.ExamName, e.CourseID, c.CourseName, e.CreatedDate, e.TotalQuestions " +
            "FROM Exam e " +
            "JOIN Course c ON e.CourseID = c.CourseID " +
            "JOIN Track_Course tc ON tc.CourseID = c.CourseID " +
            "JOIN Student_Track st ON st.TrackID = tc.TrackID " +
            "WHERE st.StudentID = ? " +
            "  AND e.ExamID NOT IN (" +
            "      SELECT ExamID FROM StudentExam WHERE StudentID = ?" +
            "  ) ORDER BY e.CreatedDate DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private Exam mapRow(ResultSet rs) throws SQLException {
        Exam e = new Exam();
        e.setExamId(rs.getInt("ExamID"));
        e.setExamName(rs.getString("ExamName"));
        e.setCourseId(rs.getInt("CourseID"));
        e.setCourseName(rs.getString("CourseName"));
        e.setCreatedDate(rs.getTimestamp("CreatedDate"));
        e.setTotalQuestions(rs.getInt("TotalQuestions"));
        return e;
    }
}
