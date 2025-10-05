/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.MessageDigest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import model.Users;
import utils.DBContext;

/**
 * Data Access Object cho đối tượng Users, thực hiện các thao tác với bảng Users
 * trong cơ sở dữ liệu.
 *
 * @author Vo Hoang Tu - CE000000 - 20/05/2025
 */
public class UsersDAO extends DBContext {

    public UsersDAO() {
        super();
    }

    // --- Phương thức Hash MD5 (Giữ nguyên) ---
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

    // --- Phương thức Login (Đã sửa) ---
    public Users login(String email, String pass) {
        Users u = null;
        // Sửa: Thay username bằng Email, và tên cột (id -> UserID, username -> Email)
        String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashMD5(pass));
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // 1. Ánh xạ các trường NOT NULL
                    int userId = rs.getInt("UserID");
                    String fullName = rs.getString("FullName");
                    String userEmail = rs.getString("Email");
                    String password = rs.getString("Password");
                    
                    // 2. Ánh xạ các trường Allow Nulls
                    // Dùng rs.getString() cho các cột nvarchar(MAX)/nvarchar có thể null
                    String phone = rs.getString("Phone");
                    String address = rs.getString("Address");
                    String status = rs.getString("Status");
                    
                    // Dùng rs.getObject(..., Integer.class) cho int (Allow Nulls)
                    Integer role = rs.getObject("Role", Integer.class); 
                    
                    // Dùng rs.getTimestamp() cho datetime2
                    Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                    LocalDateTime createdAt = (createdAtTimestamp != null) 
                                            ? createdAtTimestamp.toLocalDateTime() 
                                            : null;
                    
                    // 3. Khởi tạo đối tượng Users với Constructor đầy đủ
                    u = new Users(userId, fullName, userEmail, phone, password, 
                                  role, address, createdAt, status);
                }
            }
        } catch (Exception e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
        }
        // Nếu không tìm thấy, u sẽ là null.
        return u;
    }

    public static void main(String[] args) {
        UsersDAO dao = new UsersDAO();
        
        // Cần thay đổi test case để phù hợp với CSDL thực tế (Email và Password)
        String testEmail = "vana@example.com"; 
        String testPass = "123456";
     // THÊM DÒNG NÀY ĐỂ DEBUG
    String hashedPass = dao.hashMD5(testPass);
    System.out.println("MD5 Hash generated: " + hashedPass);       
        Users loggedInUser = dao.login(testEmail, testPass);
        
        System.out.println("--- Test Login ---");
        if (loggedInUser != null) {
            System.out.println("Login SUCCESS!");
            System.out.println("UserID: " + loggedInUser.getUserId());
            System.out.println("FullName: " + loggedInUser.getFullName());
            System.out.println("Role: " + loggedInUser.getRole());
            System.out.println(loggedInUser);
        } else {
            System.out.println("Login FAILED for email: " + testEmail);
        }
    }
}