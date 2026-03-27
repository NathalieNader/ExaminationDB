package com.iti.exam.dao;

import com.iti.exam.model.Track;
import com.iti.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * TrackDAO — calls stored procedures:
 *   InsertTrack, UpdateTrack, DeleteTrack, SelectByBranch
 */
public class TrackDAO {

    public List<Track> getAll() throws SQLException {
        List<Track> list = new ArrayList<>();
        String sql = "SELECT t.TrackID, t.TrackName, t.BranchID, b.BranchName, t.DurationMonths " +
                     "FROM Track t JOIN Branch b ON t.BranchID = b.BranchID ORDER BY t.TrackName";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Track tr = mapRow(rs);
                list.add(tr);
            }
        }
        return list;
    }

    public List<Track> getByBranch(int branchId) throws SQLException {
        List<Track> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL SelectByBranch(?)}")) {
            cs.setInt(1, branchId);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public int insert(String trackName, int branchId, int durationMonths) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL InsertTrack(?,?,?)}")) {
            cs.setString(1, trackName);
            cs.setInt(2, branchId);
            cs.setInt(3, durationMonths);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    public void update(int trackId, String trackName, int branchId, int durationMonths) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL UpdateTrack(?,?,?,?)}")) {
            cs.setInt(1, trackId);
            cs.setString(2, trackName);
            cs.setInt(3, branchId);
            cs.setInt(4, durationMonths);
            cs.execute();
        }
    }

    public void delete(int trackId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL DeleteTrack(?)}")) {
            cs.setInt(1, trackId);
            cs.execute();
        }
    }

    private Track mapRow(ResultSet rs) throws SQLException {
        Track tr = new Track();
        tr.setTrackId(rs.getInt("TrackID"));
        tr.setTrackName(rs.getString("TrackName"));
        tr.setBranchId(rs.getInt("BranchID"));
        try { tr.setBranchName(rs.getString("BranchName")); } catch (Exception ignored) {}
        tr.setDurationMonths(rs.getInt("DurationMonths"));
        return tr;
    }
}
