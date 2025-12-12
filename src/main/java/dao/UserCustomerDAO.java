/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Customer;
import dto.UserCustomerDTO;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import model.Users;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class UserCustomerDAO extends DBContext {

    public UserCustomerDAO() {
        super();
    }

    public UserCustomerDTO getCustomerInfo(int uID) {
        String sql = "SELECT u.UserID, u.Password, u.FullName, u.Role, u.Email, u.Phone, u.Address, u.CreatedAt, u.Status, c.CCCD, c.Point, c.YearOfBirth FROM Users u  \n"
                + "JOIN Customers c \n"
                + "ON  u.UserID = c.CustomerID  WHERE u.UserID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, uID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int uId = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String pass = rs.getString("Password");
                int role = rs.getInt("Role");
                String address = rs.getString("Address");
                String status = rs.getString("Status");
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null) ? createdAtTimestamp.toLocalDateTime() : null;
                Users u = new Users(uId, fullName, email, phone, pass, role, address, createdAt, status);

                String cCCD = rs.getString("CCCD");
                int point = rs.getInt("Point");
                Timestamp YOBTT = rs.getTimestamp("YearOfBirth");
                LocalDateTime YOB = (YOBTT != null) ? YOBTT.toLocalDateTime() : null;
                Customer c = new Customer(uId, cCCD, point, YOB);

                UserCustomerDTO uC = new UserCustomerDTO(u, c);
                return uC;
            }

        } catch (SQLException e) {
            return null;
        }
        return null;
    }

    public static void main(String[] args) {
        UserCustomerDAO dao = new UserCustomerDAO();

        // Nhập ID muốn test
        int testUserId = 22;

        UserCustomerDTO uC = dao.getCustomerInfo(testUserId);

        if (uC == null) {
            System.out.println("❌ Không tìm thấy user hoặc lỗi SQL");
            return;
        }

        Users u = uC.getUser();
        Customer c = uC.getCustomer();

        System.out.println("===== USER INFO =====");
        System.out.println("ID: " + u.getUserId());
        System.out.println("Name: " + u.getFullName());
        System.out.println("Email: " + u.getEmail());
        System.out.println("Phone: " + u.getPhone());
        System.out.println("Role: " + u.getRole());
        System.out.println("Address: " + u.getAddress());
        System.out.println("Status: " + u.getStatus());
        System.out.println("CreatedAt: " + u.getCreatedAt());

        System.out.println("\n===== CUSTOMER INFO =====");
        System.out.println("CCCD: " + c.getcCCD());
        System.out.println("Point: " + c.getPoint());
        System.out.println("YOB: " + c.getYOB());
    }

}
