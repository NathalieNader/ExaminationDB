package com.iti.exam.dao;

import com.iti.exam.model.Option;
import com.iti.exam.model.Question;
import com.iti.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * QuestionDAO — calls stored procedures:
 *   InsertQuestion, UpdateQuestion, DeleteQuestion,
 *   InsertOption, SetModelAnswer
 */
public class QuestionDAO {

    public List<Question> getByCourse(int courseId) throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.QuestionID, q.CourseID, c.CourseName, q.QuestionText, " +
                     "q.QuestionType, q.Points, ISNULL(ma.OptionID,0) AS ModelAnswerOptionID " +
                     "FROM Question q " +
                     "JOIN Course c ON q.CourseID = c.CourseID " +
                     "LEFT JOIN ModelAnswer ma ON ma.QuestionID = q.QuestionID " +
                     "WHERE q.CourseID = ? ORDER BY q.QuestionType, q.QuestionID";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = mapRow(rs);
                q.setOptions(getOptions(q.getQuestionId()));
                list.add(q);
            }
        }
        return list;
    }

    public List<Question> getAll() throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.QuestionID, q.CourseID, c.CourseName, q.QuestionText, " +
                     "q.QuestionType, q.Points, ISNULL(ma.OptionID,0) AS ModelAnswerOptionID " +
                     "FROM Question q " +
                     "JOIN Course c ON q.CourseID = c.CourseID " +
                     "LEFT JOIN ModelAnswer ma ON ma.QuestionID = q.QuestionID " +
                     "ORDER BY c.CourseName, q.QuestionType";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Question q = mapRow(rs);
                list.add(q);
            }
        }
        return list;
    }

    public Question getById(int questionId) throws SQLException {
        String sql = "SELECT q.QuestionID, q.CourseID, c.CourseName, q.QuestionText, " +
                     "q.QuestionType, q.Points, ISNULL(ma.OptionID,0) AS ModelAnswerOptionID " +
                     "FROM Question q " +
                     "JOIN Course c ON q.CourseID = c.CourseID " +
                     "LEFT JOIN ModelAnswer ma ON ma.QuestionID = q.QuestionID " +
                     "WHERE q.QuestionID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Question q = mapRow(rs);
                q.setOptions(getOptions(questionId));
                return q;
            }
        }
        return null;
    }

    /** Insert question, then options (list of texts), then model answer by index (0-based) */
    public int insert(int courseId, String questionText, String questionType,
                      int points, List<String> optionTexts, int correctOptionIndex) throws SQLException {
        int newQId;
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL InsertQuestion(?,?,?,?,?)}")) {
            cs.setInt(1, courseId);
            cs.setString(2, questionText);
            cs.setString(3, questionType);
            cs.setInt(4, points);
            cs.registerOutParameter(5, Types.INTEGER);
            cs.execute();
            newQId = cs.getInt(5);
        }

        int correctOptionId = -1;
        for (int i = 0; i < optionTexts.size(); i++) {
            int optId = insertOption(newQId, optionTexts.get(i), i + 1);
            if (i == correctOptionIndex) correctOptionId = optId;
        }

        if (correctOptionId > 0) setModelAnswer(newQId, correctOptionId);
        return newQId;
    }

    public int insertOption(int questionId, String optionText, int optionOrder) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL InsertOption(?,?,?,?)}")) {
            cs.setInt(1, questionId);
            cs.setString(2, optionText);
            cs.setInt(3, optionOrder);
            cs.registerOutParameter(4, Types.INTEGER);
            cs.execute();
            return cs.getInt(4);
        }
    }

    public void setModelAnswer(int questionId, int optionId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL SetModelAnswer(?,?,?)}")) {
            cs.setInt(1, questionId);
            cs.setInt(2, optionId);
            cs.registerOutParameter(3, Types.INTEGER);
            cs.execute();
        }
    }

    public int update(int questionId, String questionText, String questionType, int points) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL UpdateQuestion(?,?,?,?,?)}")) {
            cs.setInt(1, questionId);
            cs.setString(2, questionText);
            cs.setString(3, questionType);
            cs.setInt(4, points);
            cs.registerOutParameter(5, Types.INTEGER);
            cs.execute();
            return cs.getInt(5);
        }
    }

    public void delete(int questionId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL DeleteQuestion(?)}")) {
            cs.setInt(1, questionId);
            cs.execute();
        }
    }

    public List<Option> getOptions(int questionId) throws SQLException {
        List<Option> list = new ArrayList<>();
        String sql = "SELECT OptionID, QuestionID, OptionText, OptionOrder " +
                     "FROM [Option] WHERE QuestionID=? ORDER BY OptionOrder";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Option o = new Option();
                o.setOptionId(rs.getInt("OptionID"));
                o.setQuestionId(rs.getInt("QuestionID"));
                o.setOptionText(rs.getString("OptionText"));
                o.setOptionOrder(rs.getInt("OptionOrder"));
                list.add(o);
            }
        }
        return list;
    }

    /** Count available MCQ or TF questions for a course */
    public int countAvailable(int courseId, String type) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Question WHERE CourseID=? AND QuestionType=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    private Question mapRow(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setQuestionId(rs.getInt("QuestionID"));
        q.setCourseId(rs.getInt("CourseID"));
        q.setCourseName(rs.getString("CourseName"));
        q.setQuestionText(rs.getString("QuestionText"));
        q.setQuestionType(rs.getString("QuestionType"));
        q.setPoints(rs.getInt("Points"));
        q.setModelAnswerOptionId(rs.getInt("ModelAnswerOptionID"));
        return q;
    }
}
