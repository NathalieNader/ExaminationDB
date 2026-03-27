package com.iti.exam.dao;

import com.iti.exam.model.Instructor;
import com.iti.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * InstructorDAO — calls stored procedures:
 *   InsertInstructor, UpdateInstructor, AssignInstructorToCourse,
 *   RemoveInstructorFromCourse
 */
public class InstructorDAO {

    public List<Instructor> getAll() throws SQLException {
        List<Instructor> list = new ArrayList<>();
        String sql = "SELECT InstructorID, InstructorName, Email, DepartmentNo FROM Instructor ORDER BY InstructorName";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public Instructor getById(int id) throws SQLException {
        String sql = "SELECT InstructorID, InstructorName, Email, DepartmentNo FROM Instructor WHERE InstructorID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public int insert(String name, String email, int deptNo) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL InsertInstructor(?,?,?)}")) {
            cs.setString(1, name);
            cs.setString(2, email);
            cs.setInt(3, deptNo);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    public void update(int id, String name, String email, int deptNo) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL UpdateInstructor(?,?,?,?)}")) {
            cs.setInt(1, id);
            cs.setString(2, name);
            cs.setString(3, email);
            cs.setInt(4, deptNo);
            cs.execute();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM Instructor WHERE InstructorID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void assignToCourse(int instructorId, int courseId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL AssignInstructorToCourse(?,?)}")) {
            cs.setInt(1, instructorId);
            cs.setInt(2, courseId);
            cs.execute();
        }
    }

    public void removeFromCourse(int instructorId, int courseId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL RemoveInstructorFromCourse(?,?)}")) {
            cs.setInt(1, instructorId);
            cs.setInt(2, courseId);
            cs.execute();
        }
    }

    /** Get all courses assigned to this instructor */
    public List<Integer> getCourseIds(int instructorId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT CourseID FROM Instructor_Course WHERE InstructorID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ids.add(rs.getInt(1));
        }
        return ids;
    }

    private Instructor mapRow(ResultSet rs) throws SQLException {
        Instructor i = new Instructor();
        i.setInstructorId(rs.getInt("InstructorID"));
        i.setInstructorName(rs.getString("InstructorName"));
        i.setEmail(rs.getString("Email"));
        i.setDepartmentNo(rs.getInt("DepartmentNo"));
        return i;
    }
}
