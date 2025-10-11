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
 * Data Access Object (DAO) for the Users entity.
 *
 * Responsibilities:
 * - Provide methods to query and modify the Users table.
 * - Convert ResultSet rows into Users domain objects.
 * - Offer auxiliary methods related to Users (login, registration, shippers list, sales list).
 *
 * Note:
 * - This class uses the JDBC connection provided by DBContext (inherited).
 * - Methods generally use PreparedStatement to prevent SQL injection.
 *
 * @author Admin
 */
public class UsersDAO extends DBContext {

    /**
     * Default constructor to initialize DBContext.
     */
    public UsersDAO() {
        super();
    }

    /**
     * Retrieve all users from the database.
     *
     * @return a List of Users representing all user records
     */
    public List<Users> getAllUsers() {
        String sql = "SELECT * FROM users";
        List<Users> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            // Iterate the result set and build Users objects
            while (rs.next()) {
                int id = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String pass = rs.getString("Password");
                int role = rs.getInt("Role");
                String address = rs.getString("Address");

                // Convert SQL Timestamp to LocalDateTime (may be null)
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null)
                        ? createdAtTimestamp.toLocalDateTime()
                        : null;

                String status = rs.getString("Status");

                // Add constructed Users object to the list
                list.add(new Users(id, fullName, email, phone, pass, role, address, createdAt, status));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    /**
     * Hash a plaintext password using MD5.
     *
     * Note: MD5 is used here to match existing application behavior.
     * For improved security consider using a stronger algorithm (e.g., SHA-256) and salt.
     *
     * @param pass plaintext password
     * @return hexadecimal MD5 hash of the password
     */
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

    /**
     * Authenticate a user by email and password.
     *
     * Workflow:
     * 1. Hash the provided password.
     * 2. Query the Users table for a matching email and hashed password.
     * 3. If a user is found, construct and return a Users object; otherwise return null.
     *
     * @param email login email
     * @param pass  plaintext password (will be hashed inside the method)
     * @return Users object if authentication succeeds; null otherwise
     */
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

                    // Convert timestamp to LocalDateTime (may be null)
                    Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                    LocalDateTime createdAt = (createdAtTimestamp != null)
                            ? createdAtTimestamp.toLocalDateTime()
                            : null;

                    // Build and return the authenticated Users object
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

    /**
     * Register a new user and return the created user object.
     *
     * Workflow:
     * 1. Insert a new row into Users with hashed password, default role = 1, and status = 'active'.
     * 2. After successful insert, call login(email, password) to return the persisted Users object.
     *
     * Note: This method throws SQLException to let the caller handle DB constraint errors
     * (for example duplicate email).
     *
     * @param name     full name
     * @param email    email address
     * @param numberPhone phone number
     * @param address  address
     * @param password plaintext password (will be hashed before storing)
     * @return Users object for the newly created user
     * @throws SQLException when DB insert fails
     */
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

        // Return the logged-in Users object for convenience (auto-login behavior)
        return login(email, password);
    }

    /**
     * Retrieve a user by ID.
     *
     * @param id user ID
     * @return Users object if found; null otherwise
     */
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

                // Convert timestamp to LocalDateTime (may be null)
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

    /**
     * Update an existing user's data.
     *
     * @param userId  ID of the user to update
     * @param name    new full name
     * @param email   new email
     * @param phone   new phone
     * @param address new address
     * @param role    new role integer
     * @param status  new status string
     */
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

    /**
     * Insert a new user with a specified role (used by admin create operations).
     *
     * @param name     full name
     * @param email    email address
     * @param phone    phone number
     * @param address  address
     * @param password plaintext password (will be hashed)
     * @param role     integer role value
     */
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

    /**
     * Delete a user by ID.
     *
     * @param userId ID of the user to delete
     */
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

    /**
     * Retrieve all records from the Sales table.
     *
     * @return list of Sale objects
     */
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

                // Convert timestamp to LocalDateTime (may be null)
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

    /**
     * Retrieve all users who have role = 3 (shippers).
     *
     * @return List of Users objects representing shippers
     */
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

                // Minimal Users object for shipper listing
                list.add(new Users(id, fullName, phone));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    /**
     * Test method for quick manual verification.
     * Prints out all shippers to console.
     */
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
            System.out.println("No shippers found!");
        }
    }
}
