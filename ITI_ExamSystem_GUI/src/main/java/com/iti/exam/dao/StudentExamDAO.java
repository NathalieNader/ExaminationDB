package com.iti.exam.dao;

import com.iti.exam.model.StudentExam;
import com.iti.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * StudentExamDAO — calls:
 *   SubmitExamAnswers (XML-based), CorrectExam
 */
public class StudentExamDAO {

    /**
     * Calls SubmitExamAnswers SP.
     * @param answers  map of QuestionID → ChosenOptionID (null if skipped)
     */
    public int submitExam(int studentId, int examId,
                          Timestamp startTime, Timestamp endTime,
                          Map<Integer, Integer> answers) throws SQLException {

        // Build XML payload expected by the SP
        StringBuilder xml = new StringBuilder("<Answers>");
        for (Map.Entry<Integer, Integer> entry : answers.entrySet()) {
            xml.append("<Answer>")
               .append("<QuestionID>").append(entry.getKey()).append("</QuestionID>")
               .append("<ChosenOptionID>");
            if (entry.getValue() != null) xml.append(entry.getValue());
            xml.append("</ChosenOptionID>")
               .append("</Answer>");
        }
        xml.append("</Answers>");

        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL SubmitExamAnswers(?,?,?,?,?)}")) {
            cs.setInt(1, studentId);
            cs.setInt(2, examId);
            cs.setTimestamp(3, startTime);
            cs.setTimestamp(4, endTime);
            cs.setSQLXML(5, createXML(con, xml.toString()));
            cs.execute();

            // Retrieve the new StudentExamID
            int seId = getLatestStudentExamId(studentId, examId);
            // Auto-correct immediately
            correctExam(seId);
            return seId;
        }
    }

    /** Calls CorrectExam SP and returns TotalGrade */
    public int correctExam(int studentExamId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL CorrectExam(?,?)}")) {
            cs.setInt(1, studentExamId);
            cs.registerOutParameter(2, Types.INTEGER);
            cs.execute();
            return cs.getInt(2);
        }
    }

    public List<StudentExam> getByStudent(int studentId) throws SQLException {
        List<StudentExam> list = new ArrayList<>();
        String sql =
            "SELECT se.StudentExamID, se.StudentID, s.StudentName, se.ExamID, e.ExamName, " +
            "       se.StartTime, se.EndTime, se.TotalGrade, c.CourseName, c.MaxDegree " +
            "FROM StudentExam se " +
            "JOIN Student s ON se.StudentID = s.StudentID " +
            "JOIN Exam e ON se.ExamID = e.ExamID " +
            "JOIN Course c ON e.CourseID = c.CourseID " +
            "WHERE se.StudentID = ? ORDER BY se.StartTime DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<StudentExam> getAll() throws SQLException {
        List<StudentExam> list = new ArrayList<>();
        String sql =
            "SELECT se.StudentExamID, se.StudentID, s.StudentName, se.ExamID, e.ExamName, " +
            "       se.StartTime, se.EndTime, se.TotalGrade, c.CourseName, c.MaxDegree " +
            "FROM StudentExam se " +
            "JOIN Student s ON se.StudentID = s.StudentID " +
            "JOIN Exam e ON se.ExamID = e.ExamID " +
            "JOIN Course c ON e.CourseID = c.CourseID " +
            "ORDER BY se.StartTime DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Check if student has already taken an exam */
    public boolean hasAttempted(int studentId, int examId) throws SQLException {
        String sql = "SELECT 1 FROM StudentExam WHERE StudentID=? AND ExamID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, examId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    private int getLatestStudentExamId(int studentId, int examId) throws SQLException {
        String sql = "SELECT TOP 1 StudentExamID FROM StudentExam " +
                     "WHERE StudentID=? AND ExamID=? ORDER BY StudentExamID DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, examId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    private SQLXML createXML(Connection con, String xmlStr) throws SQLException {
        SQLXML xml = con.createSQLXML();
        xml.setString(xmlStr);
        return xml;
    }

    private StudentExam mapRow(ResultSet rs) throws SQLException {
        StudentExam se = new StudentExam();
        se.setStudentExamId(rs.getInt("StudentExamID"));
        se.setStudentId(rs.getInt("StudentID"));
        se.setStudentName(rs.getString("StudentName"));
        se.setExamId(rs.getInt("ExamID"));
        se.setExamName(rs.getString("ExamName"));
        se.setStartTime(rs.getTimestamp("StartTime"));
        se.setEndTime(rs.getTimestamp("EndTime"));
        int grade = rs.getInt("TotalGrade");
        se.setTotalGrade(rs.wasNull() ? null : grade);
        se.setCourseName(rs.getString("CourseName"));
        se.setMaxDegree(rs.getInt("MaxDegree"));
        if (se.getTotalGrade() != null && se.getMaxDegree() != null && se.getMaxDegree() > 0)
            se.setPercentage((double) se.getTotalGrade() / se.getMaxDegree() * 100);
        return se;
    }
}
