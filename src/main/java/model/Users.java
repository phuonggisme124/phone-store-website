/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime; // Cần import LocalDateTime cho kiểu datetime2

/**
 * Lớp Users ánh xạ với cấu trúc bảng trong CSDL.
 *
 * @author (tên của bạn)
 */
public class Users {

    // Các trường bắt buộc (NOT NULL)
    private int userId;             // int, NOT NULL (UserID) - Key
    private String fullName;        // nvarchar(100), NOT NULL
    private String email;           // nvarchar(100), NOT NULL - Thường là UNIQUE
    private String password;        // nvarchar(255), NOT NULL

    // Các trường có thể NULL (Allow Nulls) - Sử dụng kiểu đối tượng cho int để có thể gán null
    private String phone;           // nvarchar(20), Allow Nulls
    private Integer role;           // int, Allow Nulls (Sử dụng Integer để chứa null)
    private String address;         // nvarchar(255), Allow Nulls
    private LocalDateTime createdAt;  // datetime2(7), Allow Nulls (Sử dụng LocalDateTime)
    private String status;          // nvarchar(20), Allow Nulls

    // Constructor mặc định
    public Users() {
    }
    public Users(String name, String phone) {
        this.fullName = name;
        this.phone = phone;
    }

    /**
     * Constructor đầy đủ, bao gồm tất cả các trường từ CSDL.
     * Lưu ý: Các trường 'Allow Nulls' sử dụng Integer, String, LocalDateTime.
     */
    public Users(int userId, String fullName, String email, String phone, String password, 
                 Integer role, String address, LocalDateTime createdAt, String status) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.role = role;
        this.address = address;
        this.createdAt = createdAt;
        this.status = status;
    }
    
    /**
     * Constructor tối thiểu cho các trường NOT NULL.
     */
    public Users(int userId, String fullName, String email, String password) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        
        // Gán null cho các trường Allow Nulls
        this.phone = null;
        this.role = null;
        this.address = null;
        this.createdAt = null;
        this.status = null;
    }


    // --- Getters và Setters ---

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Integer getRole() {
        return role;
    }

    public void setRole(Integer role) {
        this.role = role;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // --- Override toString() ---

    @Override
    public String toString() {
        return "Users{" +
                "userId=" + userId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", password='***'" + // Không nên hiển thị password
                ", role=" + role +
                ", address='" + address + '\'' +
                ", createdAt=" + createdAt +
                ", status='" + status + '\'' +
                '}';
    }
}