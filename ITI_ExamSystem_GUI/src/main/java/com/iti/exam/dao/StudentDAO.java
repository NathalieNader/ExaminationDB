package com.iti.exam.dao;

import com.iti.exam.model.Student;
import com.iti.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * StudentDAO — calls stored procedures:
 *   InsertStudent, UpdateStudent, DeleteStudent, AssignStudentToTrack
 */
public class StudentDAO {

    public List<Student> getAll() throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT StudentID, StudentName, Email, Phone FROM Student ORDER BY StudentName";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public Student getById(int id) throws SQLException {
        String sql = "SELECT StudentID, StudentName, Email, Phone FROM Student WHERE StudentID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public Student getByEmail(String email) throws SQLException {
        String sql = "SELECT StudentID, StudentName, Email, Phone FROM Student WHERE Email=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public int insert(String name, String email, String phone) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL InsertStudent(?,?,?)}")) {
            cs.setString(1, name);
            cs.setString(2, email);
            cs.setString(3, phone);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    public int update(int id, String name, String email, String phone) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL UpdateStudent(?,?,?,?,?)}")) {
            cs.setInt(1, id);
            if (name  != null) cs.setString(2, name);  else cs.setNull(2, Types.NVARCHAR);
            if (email != null) cs.setString(3, email); else cs.setNull(3, Types.NVARCHAR);
            if (phone != null) cs.setString(4, phone); else cs.setNull(4, Types.NVARCHAR);
            cs.registerOutParameter(5, Types.INTEGER);
            cs.execute();
            return cs.getInt(5);
        }
    }

    public int delete(int id) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL DeleteStudent(?,?)}")) {
            cs.setInt(1, id);
            cs.registerOutParameter(2, Types.INTEGER);
            cs.execute();
            return cs.getInt(2);
        }
    }

    public void assignToTrack(int studentId, int trackId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL AssignStudentToTrack(?,?)}")) {
            cs.setInt(1, studentId);
            cs.setInt(2, trackId);
            cs.execute();
        }
    }

    public List<Integer> getTrackIds(int studentId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT TrackID FROM Student_Track WHERE StudentID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ids.add(rs.getInt(1));
        }
        return ids;
    }

    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("StudentID"));
        s.setStudentName(rs.getString("StudentName"));
        s.setEmail(rs.getString("Email"));
        s.setPhone(rs.getString("Phone"));
        return s;
    }
}
