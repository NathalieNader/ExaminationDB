package com.iti.exam.dao;

import com.iti.exam.model.StudentExam;
import com.iti.exam.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * ReportDAO — calls the 3 report stored procedures:
 *   Report_StudentsByDepartment, Report_StudentGrades, Report_InstructorCourses
 */
public class ReportDAO {

    /** Report 1: Students by Department number */
    public List<Map<String, Object>> studentsByDepartment(int deptNo) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL Report_StudentsByDepartment(?)}")) {
            cs.setInt(1, deptNo);
            ResultSet rs = cs.executeQuery();
            ResultSetMetaData meta = rs.getMetaData();
            int cols = meta.getColumnCount();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= cols; i++)
                    row.put(meta.getColumnLabel(i), rs.getObject(i));
                list.add(row);
            }
        }
        return list;
    }

    /** Report 2: Student grades (calls Report_StudentGrades SP) */
    public List<StudentExam> studentGrades(int studentId) throws SQLException {
        List<StudentExam> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL Report_StudentGrades(?)}")) {
            cs.setInt(1, studentId);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                StudentExam se = new StudentExam();
                se.setCourseName(rs.getString("CourseName"));
                se.setExamName(rs.getString("ExamName"));
                se.setTotalGrade(rs.getInt("TotalGrade"));
                se.setMaxDegree(rs.getInt("MaxDegree"));
                double pct = rs.getDouble("Percentage");
                se.setPercentage(rs.wasNull() ? null : pct);
                list.add(se);
            }
        }
        return list;
    }

    /** Report 3: Instructor courses with student counts */
    public List<Map<String, Object>> instructorCourses(int instructorId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL Report_InstructorCourses(?)}")) {
            cs.setInt(1, instructorId);
            ResultSet rs = cs.executeQuery();
            ResultSetMetaData meta = rs.getMetaData();
            int cols = meta.getColumnCount();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= cols; i++)
                    row.put(meta.getColumnLabel(i), rs.getObject(i));
                list.add(row);
            }
        }
        return list;
    }
}
