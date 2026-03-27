package com.iti.exam.dao;

import com.iti.exam.model.Course;
import com.iti.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CourseDAO — calls stored procedures:
 *   InsertCourse, UpdateCourse, DeleteCourse, SelectByTrack
 */
public class CourseDAO {

    public List<Course> getAll() throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT CourseID, CourseName, MinDegree, MaxDegree FROM Course ORDER BY CourseName";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Course> getByTrack(int trackId) throws SQLException {
        List<Course> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL SelectByTrack(?)}")) {
            cs.setInt(1, trackId);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public Course getById(int courseId) throws SQLException {
        String sql = "SELECT CourseID, CourseName, MinDegree, MaxDegree FROM Course WHERE CourseID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public int insert(String name, int minDegree, int maxDegree) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL InsertCourse(?,?,?)}")) {
            cs.setString(1, name);
            cs.setInt(2, minDegree);
            cs.setInt(3, maxDegree);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    public void update(int id, String name, int minDegree, int maxDegree) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL UpdateCourse(?,?,?,?)}")) {
            cs.setInt(1, id);
            cs.setString(2, name);
            cs.setInt(3, minDegree);
            cs.setInt(4, maxDegree);
            cs.execute();
        }
    }

    public void delete(int id) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL DeleteCourse(?)}")) {
            cs.setInt(1, id);
            cs.execute();
        }
    }

    /** Assign a course to a track */
    public void assignToTrack(int trackId, int courseId) throws SQLException {
        String sql = "IF NOT EXISTS (SELECT 1 FROM Track_Course WHERE TrackID=? AND CourseID=?) " +
                     "INSERT INTO Track_Course(TrackID,CourseID) VALUES(?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, trackId); ps.setInt(2, courseId);
            ps.setInt(3, trackId); ps.setInt(4, courseId);
            ps.executeUpdate();
        }
    }

    private Course mapRow(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setCourseId(rs.getInt("CourseID"));
        c.setCourseName(rs.getString("CourseName"));
        c.setMinDegree(rs.getInt("MinDegree"));
        c.setMaxDegree(rs.getInt("MaxDegree"));
        return c;
    }
}
