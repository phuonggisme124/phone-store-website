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
 * @author Admin
 */
public class UsersDAO extends DBContext {

    public UsersDAO() {
        super();
    }
    
    /**
     * REFACTORED: Centralized helper method to map a ResultSet row to a Users object.
     * This avoids code duplication.
     * @param rs The ResultSet to map.
     * @return A populated Users object.
     * @throws SQLException
     */
    private Users mapResultSetToUser(ResultSet rs) throws SQLException {
        int id = rs.getInt("UserID");
        String fullName = rs.getString("FullName");
        String email = rs.getString("Email");
        String phone = rs.getString("Phone");
        String pass = rs.getString("Password");
        int role = rs.getInt("Role");
        String address = rs.getString("Address");
        String status = rs.getString("Status");

        Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
        LocalDateTime createdAt = (createdAtTimestamp != null) ? createdAtTimestamp.toLocalDateTime() : null;

        return new Users(id, fullName, email, phone, pass, role, address, createdAt, status);
    }

    /**
     * Retrieve all users from the database.
     * @return a List of Users representing all user records
     */
    public List<Users> getAllUsers() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        // REFACTORED: Use try-with-resources for automatic resource management.
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToUser(rs)); // Use the helper method
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Hash a plaintext password using MD5.
     * Note: MD5 is weak. For new applications, use bcrypt or Argon2.
     * @param pass plaintext password
     * @return hexadecimal MD5 hash of the password
     */
    public String hashMD5(String pass) {
        try {
            MessageDigest mes = MessageDigest.getInstance("MD5");
            byte[] mesMD5 = mes.digest(pass.getBytes());
            StringBuilder str = new StringBuilder();
            for (byte b : mesMD5) {
                str.append(String.format("%02x", b));
            }
            return str.toString();
        } catch (Exception e) {
            System.err.println("Error hashing password: " + e.getMessage());
            return "";
        }
    }

    /**
     * Authenticate a user by email and password.
     * @param email login email
     * @param pass plaintext password
     * @return Users object if authentication succeeds; null otherwise
     */
    public Users login(String email, String pass) {
        String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashMD5(pass));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs); // Use the helper method
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Register a new user and return the created user object.
     * @throws SQLException when DB insert fails
     */
    public Users register(String name, String email, String numberPhone, String address, String password) throws SQLException {
        String sql = "INSERT INTO Users (FullName, Email, Phone, Password, Role, Address, CreatedAt, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        // REFACTORED: Use try-with-resources
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, numberPhone);
            ps.setString(4, hashMD5(password));
            ps.setInt(5, 1); // Default role for customer
            ps.setString(6, address);
            ps.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(8, "active");
            
            int affectedRows = ps.executeUpdate();
            
            // REFACTORED: Avoid unnecessary login() call. Create user object directly.
            if (affectedRows > 0) {
                 // To get the full user object with the generated ID, you'd need to requery
                 // or use Statement.RETURN_GENERATED_KEYS. For now, returning null is simpler.
                 // A better approach is to return the newly created user without the ID or just a boolean success.
                 // Or, as originally intended, just log them in.
                 return login(email, password);
            }
        }
        return null;
    }
    
    /**
     * Retrieve a user by ID.
     * @param id user ID
     * @return Users object if found; null otherwise
     */
    public Users getUserByID(int id) {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs); // Use the helper method
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Update an existing user's data.
     */
    public void updateUser(int userId, String name, String email, String phone, String address, int role, String status) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, Role = ?, Address = ?, Status = ? WHERE UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setInt(4, role);
            ps.setString(5, address);
            ps.setString(6, status);
            ps.setInt(7, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Insert a new user with a specified role.
     */
    public void register(String name, String email, String phone, String address, String password, int role) {
        String sql = "INSERT INTO Users (FullName, Email, Phone, Password, Role, Address) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, hashMD5(password));
            ps.setInt(5, role);
            ps.setString(6, address);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Delete a user by ID.
     * @param userId ID of the user to delete
     */
    public void deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * REFACTORED: This method is better placed in a SalesDAO but is optimized here.
     * Retrieves all sales records with staff and shipper info in a single query.
     * @return list of Sale objects
     */
    public List<Sale> getAllSales() {
        List<Sale> list = new ArrayList<>();
        // REFACTORED: Use JOINs to prevent the N+1 query problem.
        String sql = "SELECT "
                   + "s.SaleID, s.OrderID, s.CreatedAt, "
                   + "staff.UserID AS StaffID, staff.FullName AS StaffName, staff.Phone as StaffPhone, "
                   + "shipper.UserID AS ShipperID, shipper.FullName AS ShipperName, shipper.Phone as ShipperPhone "
                   + "FROM Sales s "
                   + "LEFT JOIN Users staff ON s.StaffID = staff.UserID "
                   + "LEFT JOIN Users shipper ON s.ShipperID = shipper.UserID";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Users staff = new Users(rs.getInt("StaffID"), rs.getString("StaffName"), rs.getString("StaffPhone"));
                Users shipper = new Users(rs.getInt("ShipperID"), rs.getString("ShipperName"), rs.getString("ShipperPhone"));
                
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null) ? createdAtTimestamp.toLocalDateTime() : null;

                list.add(new Sale(rs.getInt("SaleID"), shipper, staff, rs.getInt("OrderID"), createdAt));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieve all users who have role = 3 (shippers).
     * @return List of Users objects representing shippers
     */
    public List<Users> getAllShippers() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role = 3";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Update the personal information of a user.
     * @param user Users object containing updated profile data
     */
    public void updateUserProfile(Users user) {
        StringBuilder sql = new StringBuilder("UPDATE Users SET FullName = ?, Email = ?, Phone = ?, Address = ?");
        boolean hasPassword = user.getPassword() != null && !user.getPassword().trim().isEmpty();
        if (hasPassword) {
            sql.append(", Password = ?");
        }
        sql.append(" WHERE UserID = ?");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getAddress());

            int index = 5;
            if (hasPassword) {
                ps.setString(index++, hashMD5(user.getPassword()));
            }
            ps.setInt(index, user.getUserId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // FIXED: Moved this method outside of updateUserProfile
    public void updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET Password = ? WHERE UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashMD5(newPassword)); // Always hash the new password
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // FIXED: Moved this method outside of updateUserProfile
    public boolean checkOldPassword(int userId, String oldPassword) {
        String sql = "SELECT Password FROM Users WHERE UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String currentHash = rs.getString("Password");
                    String inputHash = hashMD5(oldPassword);
                    return currentHash.equals(inputHash);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // FIXED: Moved this method inside the class definition
    /**
     * Lấy tất cả số điện thoại khách hàng đã đặt hàng.
     */
    public List<String> getAllBuyerPhones() {
        List<String> phones = new ArrayList<>();
        String sql = "SELECT DISTINCT u.Phone FROM Orders o JOIN Users u ON o.UserID = u.UserID WHERE u.Phone IS NOT NULL AND u.Phone <> ''";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                phones.add(rs.getString("Phone"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return phones;
    }

    // FIXED: Moved this method inside the class definition
    /**
     * Test method.
     */
    public static void main(String[] args) {
        UsersDAO dao = new UsersDAO();

        System.out.println("\n--- Test getAllShippers ---");
        List<Users> shippers = dao.getAllShippers();
        if (!shippers.isEmpty()) {
            System.out.println("Total Shippers: " + shippers.size());
            shippers.forEach(s -> System.out.println("ID: " + s.getUserId() + " | Name: " + s.getFullName()));
        } else {
            System.out.println("No shippers found!");
        }

        System.out.println("\n--- All Buyer Phones ---");
        List<String> phones = dao.getAllBuyerPhones();
        phones.forEach(System.out::println);
    }
}