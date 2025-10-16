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
 *
 * @author Nguyen Quoc Thinh
 * @since 2025-06-05
 */
/**
 * DBContext class is responsible for establishing a connection
 * to the SQL Server database "PhoneStore".
 *
 * @author Nguyen Quoc Thinh
 * @since 2025-06-05
 */

// Class that describes the database context
public class DBContext {
    // Database connection
    // 'protected' allows direct access within subclasses without using getters/setters

    public Connection conn = null;

    /**
     *
     * Default constructor for DBContext.
     *
     */
    public DBContext() {
        try {

            // Load the JDBC driver for SQL Server
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // Connection string to the SQL Server database

            String dbURL = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=PhoneStore;"
                    + "user=sa;"
                    + "password=123456;"
                    + "encrypt=true;trustServerCertificate=true;";

            
            // Create the connection
            conn = DriverManager.getConnection(dbURL);

            // If connection is successful
            if (conn != null) {
                // Retrieve metadata about the connection (driver, database info) and print it

                DatabaseMetaData dm = conn.getMetaData();

                System.out.println("Driver name: " + dm.getDriverName());
                System.out.println("Driver version: " + dm.getDriverVersion());
                System.out.println("Product name: " + dm.getDatabaseProductName());
                System.out.println("Product version: " + dm.getDatabaseProductVersion());
            }

        } catch (SQLException ex) {

            // If a SQL error occurs, log it and print the stack trace
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            ex.printStackTrace(); // Print error to console
        } catch (ClassNotFoundException ex) {
            // If JDBC driver is not found, log the error

            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }


    /**
     * Main method to test the database connection.
     * It creates an instance of DBContext and prints
     * the connection metadata to the console.
     *
     * @param args command-line arguments (not used)
     */

    public static void main(String[] args) {
        System.out.println("Checking database connection...");
        new DBContext();
    }
}
