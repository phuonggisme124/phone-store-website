/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.MessageDigest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Staff;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */

public class StaffDAO extends DBContext {


    public StaffDAO() {
        super();
    }

    // ==============================

    private Staff map(ResultSet rs) throws SQLException {
        return new Staff(
                rs.getInt("StaffID"),
                rs.getString("FullName"),
                rs.getString("Email"),
                rs.getString("Phone"),
                rs.getString("Password"),
                rs.getInt("Role"),
                rs.getString("Status"),
                rs.getTimestamp("CreatedAt")

        );
    }

    // ==============================
    // Password MD5
    public String md5(String pass) {
        try {
            MessageDigest m = MessageDigest.getInstance("MD5");
            byte[] digest = m.digest(pass.getBytes());
            StringBuilder sb = new StringBuilder();

            for (byte b : digest) sb.append(String.format("%02x", b));

            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }

    // ==============================
    // LOGIN STAFF (email + password)
    public Staff login(String email, String password) {

        String sql = "SELECT * FROM Staff WHERE Email = ? AND Password = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, md5(password));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null; // login failed
    }

    // ==============================
    // Lấy staff theo email
    public Staff getStaffByEmail(String email) {
        String sql = "SELECT * FROM Staff WHERE Email = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();


            if (rs.next()) return map(rs);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ==============================
    // Lấy staff theo ID
    public Staff getStaffByID(int id) {
        String sql = "SELECT * FROM Staff WHERE StaffID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();


            if (rs.next()) return map(rs);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    public List<Staff> getAllShippers() {
        String sql = "SELECT *\n"
                + "  FROM [PhoneStore].[dbo].[Staff]\n"
                + "  Where Role = 3";
        List<Staff> list = new ArrayList<>();

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int staffID = rs.getInt("StaffID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String password = rs.getString("Password");
                int role = rs.getInt("Role");
                String status = rs.getString("Status");
                Timestamp createAt = rs.getTimestamp("CreatedAt");
                list.add(new Staff(staffID, fullName, email, phone, password, role, status, createAt));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<Staff> getAllStaff() {
        String sql = "SELECT *\n"
                + "  FROM [PhoneStore].[dbo].[Staff]\n"
                + "  Where Role = 2";
        List<Staff> list = new ArrayList<>();

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int staffID = rs.getInt("StaffID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String password = rs.getString("Password");
                int role = rs.getInt("Role");
                String status = rs.getString("Status");
                Timestamp createAt = rs.getTimestamp("CreatedAt");
                list.add(new Staff(staffID, fullName, email, phone, password, role, status, createAt));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<Staff> getAllStaffs() {
        String sql = "SELECT *\n"
                + "  FROM [PhoneStore].[dbo].[Staff]\n";
        List<Staff> list = new ArrayList<>();

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int staffID = rs.getInt("StaffID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String password = rs.getString("Password");
                int role = rs.getInt("Role");
                String status = rs.getString("Status");
                Timestamp createAt = rs.getTimestamp("CreatedAt");
                list.add(new Staff(staffID, fullName, email, phone, password, role, status, createAt));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }
    
    public void updateStaff(int userId, String name, String email, String phone, int role, String status) {
        String sql = "UPDATE Staff SET FullName = ?, Email = ?, Phone = ?, Role = ?, Status = ? WHERE StaffID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setInt(4, role);
            
            ps.setString(5, status);
            ps.setInt(6, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    
    
    /**
     * Create role-specific entry (Staffs / Shippers / Customers) for a new user.
     */
    public void createRole(int newUserID, int role) {
        String sql = null;
        if (role == 2) {
            sql = "INSERT INTO Staffs (StaffID) VALUES (?)";
        } else if (role == 3) {
            sql = "INSERT INTO Shippers (ShipperID) VALUES (?)";
        } else if (role == 1) {
            sql = "INSERT INTO Customers (CustomerID) VALUES (?)";
        }

        if (sql != null) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, newUserID);
                ps.executeUpdate();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
    }
    
    public boolean register(String name, String email, String numberPhone, String password, int role) {
        CustomerDAO cdao = new CustomerDAO();
        String sqlToCheck = "SELECT * FROM Staff WHERE Email = ?";
        try (PreparedStatement psCheck = conn.prepareStatement(sqlToCheck)) {
            psCheck.setString(1, email);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (!rs.next()) {
                    String pass = cdao.md5(password);
                    System.out.println("pass: " + pass);
                    String sql = "INSERT INTO Staff (FullName, Email, Phone, Password, Role, Status) "
                            + "VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement psInsert = conn.prepareStatement(sql)) {
                        psInsert.setString(1, name);
                        psInsert.setString(2, email);
                        psInsert.setString(3, numberPhone);
                        psInsert.setString(4, pass);
                        psInsert.setInt(5, role);
                       
                        
                        psInsert.setString(6, "active");
                        psInsert.executeUpdate();
                        
                        return true;
                    }
                } else {
                    System.out.println("Email already exists!");
                    return false;
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
    
    
    /**
     * Delete role-specific entry.
     */
    public void deleteByRole(int userId, int role) {
        String sql = null;
        if (role >1) {
            sql = "DELETE FROM Staff WHERE StaffID = ?";
        } else {
            sql = "DELETE FROM Customers WHERE CustomerID = ?";
        }

        if (sql != null) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
    }
}



