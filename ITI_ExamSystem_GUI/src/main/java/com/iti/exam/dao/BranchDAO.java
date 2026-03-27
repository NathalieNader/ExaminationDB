package com.iti.exam.dao;

import com.iti.exam.model.Branch;
import com.iti.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * BranchDAO — calls SQL Server stored procedures:
 *   InsertBranch, UpdateBranch, DeleteBranch, SelectBranch
 */
public class BranchDAO {

    public List<Branch> getAll() throws SQLException {
        List<Branch> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL SelectBranch(?)}")) {
            cs.setNull(1, Types.INTEGER);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                Branch b = new Branch();
                b.setBranchId(rs.getInt("BranchID"));
                b.setBranchName(rs.getString("BranchName"));
                b.setLocation(rs.getString("Location"));
                list.add(b);
            }
        }
        return list;
    }

    public Branch getById(int id) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL SelectBranch(?)}")) {
            cs.setInt(1, id);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                Branch b = new Branch();
                b.setBranchId(rs.getInt("BranchID"));
                b.setBranchName(rs.getString("BranchName"));
                b.setLocation(rs.getString("Location"));
                return b;
            }
        }
        return null;
    }

    public int insert(String name, String location) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL InsertBranch(?,?)}")) {
            cs.setString(1, name);
            if (location != null && !location.isEmpty())
                cs.setString(2, location);
            else
                cs.setNull(2, Types.NVARCHAR);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    public void update(int id, String name, String location) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL UpdateBranch(?,?,?)}")) {
            cs.setInt(1, id);
            cs.setString(2, name);
            if (location != null && !location.isEmpty())
                cs.setString(3, location);
            else
                cs.setNull(3, Types.NVARCHAR);
            cs.execute();
        }
    }

    public void delete(int id) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL DeleteBranch(?)}")) {
            cs.setInt(1, id);
            cs.execute();
        }
    }
}
