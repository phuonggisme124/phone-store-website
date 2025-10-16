/*
 * The Users class represents a record in the Users table.
 * It is used to store user information such as name, email, password, role, status, etc.
 */
package model;

import java.time.LocalDateTime; // Used to map with datetime2 in SQL Server

/**
 * The Users class maps to the structure of the database table.
 */
public class Users {

    // =========================================================
    //  NOT NULL fields in the database (required)
    // =========================================================
    private int userId;        // int (PK) - User ID
    private String fullName;   // nvarchar(100) - Full name
    private String email;      // nvarchar(100) - Email (usually UNIQUE)
    private String password;   // nvarchar(255) - Password (encrypted)

    // =========================================================
    //  ALLOW NULL fields (optional)
    //  Use Wrapper types (Integer) or String to handle null values
    // =========================================================
    private String phone;            // nvarchar(20) - Phone number
    private Integer role;            // int - Role (e.g., 1=Admin, 2=Staff,...)
    private String address;          // nvarchar(255) - Address
    private LocalDateTime createdAt; // datetime2 - Account creation date
    private String status;           // nvarchar(20) - Status (Active/Inactive/Locked)

    // =========================================================
    //  Default constructor - Used when creating an empty object
    //  and setting fields manually
    // =========================================================
    public Users() {
    }

    // =========================================================
    //  Custom constructor (Thịnh uses this to retrieve only name + phone)
    //  Usually used when only basic user info is needed
    // =========================================================
    public Users(String name, String phone) {
        this.fullName = name;
        this.phone = phone;
    }

    // =========================================================
    //  Full constructor with all database fields
    //  Used when retrieving complete data from DB (SELECT *)
    // =========================================================
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

    // =========================================================
    //  Constructor with only NOT NULL fields
    //  Used when creating a new user (other fields can be added later)
    // =========================================================
    public Users(int userId, String fullName, String email, String password) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;

        // Set optional fields to null
        this.phone = null;
        this.role = null;
        this.address = null;
        this.createdAt = null;
        this.status = null;
    }

    // =========================================================
    //  Thịnh's constructor: Get list of all shippers
    //  -> Only need userId, fullName, and phone to display shipper options
    // =========================================================
    public Users(int userId, String fullName, String phone) {
        this.userId = userId;
        this.fullName = fullName;

        // NOTE: email is not set → remains null
        this.phone = phone;
        // Other fields remain null by default
    }

    // =========================================================
    //  GETTERS & SETTERS - Used to access / update data
    // =========================================================
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

    // =========================================================
    //  toString() - Convert Object to String (useful for debugging/logging)
    //  NOTE: DO NOT display real password for security reasons
    // =========================================================
    @Override
    public String toString() {
        return "Users{"
                + "userId=" + userId
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", phone='" + phone + '\''
                + ", password='***'"
                + // Hide password
                ", role=" + role
                + ", address='" + address + '\''
                + ", createdAt=" + createdAt
                + ", status='" + status + '\''
                + '}';
    }
}
