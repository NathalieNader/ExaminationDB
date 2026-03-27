package com.iti.exam.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection — singleton-style utility to obtain a JDBC connection
 * to the ITI_ExaminationDB SQL Server database.
 *
 * Configuration: update SERVER, DATABASE, USERNAME, PASSWORD to match
 * your environment, or switch to environment variables / JNDI.
 */
public class DBConnection {

    // ── Connection parameters ─────────────────────────────────────────────
    private static final String SERVER   = "MOHAMEDFADL";       // e.g. "DESKTOP-ABC\\SQLEXPRESS"
    private static final String PORT     = "1433";
    private static final String DATABASE = "ITI_ExaminationDB";
    private static final String USERNAME = "iti_admin";              // or your SQL login
    private static final String PASSWORD = "Admin@ITI2026"; // change this

    private static final String URL =
        "jdbc:sqlserver://" + SERVER + ":" + PORT
        + ";databaseName=" + DATABASE
        + ";encrypt=false"
        + ";trustServerCertificate=true";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("SQL Server JDBC Driver not found: " + e.getMessage());
        }
    }

    /** Returns a new connection from the driver manager. Callers must close it. */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    private DBConnection() {}
}
	