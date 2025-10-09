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
import model.Sale;
import model.Users;
import utils.DBContext;

/**
 * Data Access Object cho đối tượng Users, thực hiện các thao tác với bảng Users
 * trong cơ sở dữ liệu.
 *
 * @author Vo Hoang Tu
 */
public class UsersDAO extends DBContext {

    public UsersDAO() {
        super();
    }

    public List<Users> getAllUsers() {
        String sql = "SELECT * FROM users";
        List<Users> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String pass = rs.getString("Password");
                int role = rs.getInt("Role");
                String address = rs.getString("Address");
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null)
                        ? createdAtTimestamp.toLocalDateTime()
                        : null;
                String status = rs.getString("Status");
                list.add(new Users(id, fullName, email, phone, pass, role, address, createdAt, status));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public String hashMD5(String pass) {
        try {
            MessageDigest mes = MessageDigest.getInstance("MD5");
            byte[] mesMD5 = mes.digest(pass.getBytes());
            StringBuilder str = new StringBuilder();
            for (byte b : mesMD5) {
                String ch = String.format("%02x", b);
                str.append(ch);
            }
            return str.toString();
        } catch (Exception e) {
            System.err.println("Error hashing password: " + e.getMessage());
        }
        return "";
    }

    public Users login(String email, String pass) {
        Users u = null;
        String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashMD5(pass));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("UserID");
                    String fullName = rs.getString("FullName");
                    String userEmail = rs.getString("Email");
                    String password = rs.getString("Password");
                    String phone = rs.getString("Phone");
                    String address = rs.getString("Address");
                    String status = rs.getString("Status");
                    Integer role = rs.getObject("Role", Integer.class);
                    Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                    LocalDateTime createdAt = (createdAtTimestamp != null)
                            ? createdAtTimestamp.toLocalDateTime()
                            : null;
                    u = new Users(userId, fullName, userEmail, phone, password,
                            role, address, createdAt, status);
                }
            }
        } catch (Exception e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
        }
        return u;
    }

    public Users register(String name, String email, String numberPhone, String address, String password) throws SQLException {
        String sql = "INSERT INTO Users (FullName, Email, Phone, Password, Role, Address, CreatedAt, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String status = "active";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, numberPhone);
        ps.setString(4, hashMD5(password));
        ps.setInt(5, 1);
        ps.setString(6, address);
        ps.setTimestamp(7, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
        ps.setString(8, status);
        ps.executeUpdate();
        ps.close();
        return login(email, password);
    }

    public Users getUserByID(int id) {
        String sql = "SELECT * FROM users where UserID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String pass = rs.getString("Password");
                int role = rs.getInt("Role");
                String address = rs.getString("Address");
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null)
                        ? createdAtTimestamp.toLocalDateTime()
                        : null;
                String status = rs.getString("Status");
                return new Users(userId, fullName, email, phone, pass, role, address, createdAt, status);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public void updateUser(int userId, String name, String email, String phone, String address, int role, String status) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, Role = ?, Address = ?, Status = ? WHERE UserID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setInt(4, role);
            ps.setString(5, address);
            ps.setString(6, status);
            ps.setInt(7, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void register(String name, String email, String phone, String address, String password, int role) {
        String sql = "INSERT INTO Users (FullName, Email, Phone, Password, Role, Address) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, hashMD5(password));
            ps.setInt(5, role);
            ps.setString(6, address);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    // --- Giữ lại từ upstream: Lấy tất cả Sales ---
    public List<Sale> getAllSales() {
        String sql = "SELECT * FROM Sales";
        List<Sale> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int saleID = rs.getInt("SaleID");
                int orderID = rs.getInt("OrderID");
                int staffID = rs.getInt("StaffID");
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null)
                        ? createdAtTimestamp.toLocalDateTime()
                        : null;
                int shipperID = rs.getInt("ShipperID");
                list.add(new Sale(saleID, shipperID, staffID, orderID, createdAt));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    // --- Của Thịnh: Lấy tất cả shipper ---
    public List<Users> getAllShippers() {
        String sql = "SELECT * FROM Users WHERE Role = 3";
        List<Users> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                String phone = rs.getString("Phone");
                list.add(new Users(id, fullName, phone));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    // --- Test ---
    public static void main(String[] args) {
        UsersDAO dao = new UsersDAO();
        System.out.println("\n--- Test getAllShippers ---");
        List<Users> shippers = dao.getAllShippers();

        if (shippers != null && !shippers.isEmpty()) {
            System.out.println("Total Shippers: " + shippers.size());
            for (Users s : shippers) {
                System.out.println("ID: " + s.getUserId() + " | Name: " + s.getFullName() + " | Phone: " + s.getPhone());
            }
        } else {
            System.out.println("❌ No shippers found!");
        }
    }
}
