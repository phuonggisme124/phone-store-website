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
<<<<<<< Updated upstream
public class DBContext {

    /**
     * The Connection object represents the connection to the database.
     * It is public so that other classes can access the connection directly.
     */
=======
// Class that describes the database context
public class DBContext {
    // Database connection
    // 'protected' allows direct access within subclasses without using getters/setters
>>>>>>> Stashed changes
    public Connection conn = null;

    /**
     *
     * Default constructor for DBContext.
     *
     */
    public DBContext() {
        try {
<<<<<<< Updated upstream
            // Load JDBC driver for SQL Server
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Connection URL to the database
=======
            // Load the JDBC driver for SQL Server
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // Connection string to the SQL Server database
>>>>>>> Stashed changes
            String dbURL = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=PhoneStore;"
                    + "user=sa;"
                    + "password=6789;"
                    + "encrypt=true;trustServerCertificate=true;";
<<<<<<< Updated upstream

            // Establish the connection
            conn = DriverManager.getConnection(dbURL);

            // If connection is successful, print metadata
            if (conn != null) {
=======
            
            // Create the connection
            conn = DriverManager.getConnection(dbURL);

            // If connection is successful
            if (conn != null) {
                // Retrieve metadata about the connection (driver, database info) and print it
>>>>>>> Stashed changes
                DatabaseMetaData dm = conn.getMetaData();

                System.out.println("Driver name: " + dm.getDriverName());
                System.out.println("Driver version: " + dm.getDriverVersion());
                System.out.println("Product name: " + dm.getDatabaseProductName());
                System.out.println("Product version: " + dm.getDatabaseProductVersion());
            }

        } catch (SQLException ex) {
<<<<<<< Updated upstream
            // Handle SQL exceptions
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            ex.printStackTrace(); // print stack trace to console
        } catch (ClassNotFoundException ex) {
            // Handle driver class not found exceptions
=======
            // If a SQL error occurs, log it and print the stack trace
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            ex.printStackTrace(); // Print error to console
        } catch (ClassNotFoundException ex) {
            // If JDBC driver is not found, log the error
>>>>>>> Stashed changes
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

<<<<<<< Updated upstream
    /**
     * Main method to test the database connection.
     * It creates an instance of DBContext and prints
     * the connection metadata to the console.
     *
     * @param args command-line arguments (not used)
     */
=======
    // Main method for testing the database connection
>>>>>>> Stashed changes
    public static void main(String[] args) {
        System.out.println("Checking database connection...");
        new DBContext();
    }
}
