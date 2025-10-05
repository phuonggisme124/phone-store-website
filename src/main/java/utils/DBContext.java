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
 * @author nguyen quoc thinh - 5/6/2025
 */
// class mô tả dữ liệu
public class DBContext {
    //kết nối database
    //protected thì class truy cập trực tiếp ko cân set get

    protected Connection conn = null;

    public DBContext() {

        try {
            // Nạp driver JDBC cho SQL Server.
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // Chuỗi kết nối đến database.
            String dbURL = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=PhoneStore;"
                    + "user=sa;"
                    + "password=123456;"
                    + "encrypt=true;trustServerCertificate=true;";
            // Tạo kết nối.
            conn = DriverManager.getConnection(dbURL);
//nếu knối tahnhf công
            if (conn != null) {
// Lấy metadata về kết nối (thông tin driver, database) và in ra màn hình.
                DatabaseMetaData dm = conn.getMetaData();
               
                System.out.println("Driver name: " + dm.getDriverName());

                System.out.println("Driver version: " + dm.getDriverVersion());

                System.out.println("Product name: "
                        + dm.getDatabaseProductName());

                System.out.println("Product version: "
                        + dm.getDatabaseProductVersion());

            }

        } catch (SQLException ex) {
//nếu sql lỗi thì ....
 Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
    ex.printStackTrace(); // IN LỖI RA CONSOLE
        } catch (ClassNotFoundException ex) {
//nếu driver lỗi thì ...
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);

        }

    }
     // main test file 
    public static void main(String[] args) {
        System.out.println("kiểm tra kết nối database");
        new DBContext(); 
    }
}
