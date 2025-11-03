/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBContext class is responsible for establishing a connection
 * to the SQL Server database "PhoneStore".
 *
 * @author Nguyen Quoc Thinh
 * @since 2025-06-05
 */

public class DBContext {

    /**
     * The Connection object represents the connection to the database.
     * It is public so that other classes can access the connection directly.
     */

    public Connection conn = null;

    /**
     * Default constructor for DBContext.
     */
    public DBContext() {
        try {

            // Load JDBC driver for SQL Server
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Connection URL to the database

            String dbURL = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=PhoneStore;"
                    + "user=sa;"

                    + "password=6789;"

                    + "encrypt=true;trustServerCertificate=true;";


            // Establish the connection
            conn = DriverManager.getConnection(dbURL);

            // If connection is successful, print metadata
            if (conn != null) {

                DatabaseMetaData dm = conn.getMetaData();
                System.out.println("Driver name: " + dm.getDriverName());
                System.out.println("Driver version: " + dm.getDriverVersion());
                System.out.println("Product name: " + dm.getDatabaseProductName());
                System.out.println("Product version: " + dm.getDatabaseProductVersion());
            }

        } catch (SQLException ex) {

            // Handle SQL exceptions
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            ex.printStackTrace();
        } catch (ClassNotFoundException ex) {
            // Handle driver class not found exceptions

            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }



    /**
     * Main method to test the database connection.
     */


    public static void main(String[] args) {
        System.out.println("Checking database connection...");
        new DBContext();
    }
}
