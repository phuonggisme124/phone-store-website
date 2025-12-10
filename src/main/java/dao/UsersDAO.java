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
 * @author Admin
 */
public class UsersDAO extends DBContext {

    public UsersDAO() {
        super();
    }

    /**
     * Centralized helper method to map a ResultSet row to a Users object.
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
     */
    public List<Users> getAllUsers() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Hash a plaintext password using MD5. Note: MD5 is weak; prefer
     * bcrypt/Argon2 for new apps.
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
     */
    public Users login(String email, String pass) {
        String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashMD5(pass));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Login by email only (no password check) - useful for OAuth / session
     * creation flows.
     */
    public Users loginWithEmail(String email) {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieve a user by ID.
     */
    public Users getUserByID(int id) {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
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
    public boolean register(String name, String email, String numberPhone, String address, String password, int role) {
        String sqlToCheck = "SELECT * FROM Users WHERE Email = ?";
        try (PreparedStatement psCheck = conn.prepareStatement(sqlToCheck)) {
            psCheck.setString(1, email);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (!rs.next()) {
                    String sql = "INSERT INTO Users (FullName, Email, Phone, Password, Role, Address, CreatedAt, Status) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement psInsert = conn.prepareStatement(sql)) {
                        psInsert.setString(1, name);
                        psInsert.setString(2, email);
                        psInsert.setString(3, numberPhone);
                        psInsert.setString(4, hashMD5(password));
                        psInsert.setInt(5, role);
                        psInsert.setString(6, address);
                        psInsert.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
                        psInsert.setString(8, "active");

                        int affectedRows = psInsert.executeUpdate();
                        return affectedRows > 0;
                    }
                } else {
                    System.out.println("Email already exists!");
                    return false;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean registerForLoginWithGoogle(String name, String email, int role) {
        String sqlToCheck = "SELECT * FROM Users WHERE Email = ?";
        try (PreparedStatement psCheck = conn.prepareStatement(sqlToCheck)) {
            psCheck.setString(1, email);
            try (ResultSet rs = psCheck.executeQuery()) {
                // Email exists -> consider OK
                if (rs.next()) {
                    return true;
                }
            }

            String sql = "INSERT INTO Users (FullName, Email, Role, CreatedAt, Status) "
                    + "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement psInsert = conn.prepareStatement(sql)) {
                psInsert.setString(1, name);
                psInsert.setString(2, email);
                psInsert.setInt(3, role);
                psInsert.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                psInsert.setString(5, "active");

                return psInsert.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete a user by ID.
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
     * Retrieves all sales records with staff and shipper info in a single
     * query.
     */
    public List<Sale> getAllSales() {
        List<Sale> list = new ArrayList<>();
        String sql = "SELECT "
                + "s.SaleID, s.OrderID, s.CreatedAt, "
                + "staff.UserID AS StaffID, staff.FullName AS StaffName, staff.Phone as StaffPhone, "
                + "shipper.UserID AS ShipperID, shipper.FullName AS ShipperName, shipper.Phone as ShipperPhone "
                + "FROM Sales s "
                + "LEFT JOIN Users staff ON s.StaffID = staff.UserID "
                + "LEFT JOIN Users shipper ON s.ShipperID = shipper.UserID";

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
     */
    public List<Users> getAllShippers() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role = 3";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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

    /**
     * Update password directly.
     */
    public void updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET Password = ? WHERE UserID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashMD5(newPassword));
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Check whether the provided old password matches the stored one.
     */
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

    /**
     * Lấy tất cả số điện thoại khách hàng đã đặt hàng.
     */
    public List<String> getAllBuyerPhones() {
        List<String> phones = new ArrayList<>();
        String sql = "SELECT DISTINCT u.Phone FROM Orders o JOIN Users u ON o.UserID = u.UserID WHERE u.Phone IS NOT NULL AND u.Phone <> ''";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                phones.add(rs.getString("Phone"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return phones;
    }

    /**
     * Test method.
     */
    public static void main(String[] args) {

        UsersDAO dao = new UsersDAO();

        String name = "Google User Test";
        String email = "googleTest123@gmail.com";

        System.out.println("Testing registerForLoginWithGoogle...");
        boolean result = dao.registerForLoginWithGoogle(name, email, 1);

        if (result) {
            System.out.println("✔ REGISTER SUCCESS OR EMAIL ALREADY EXISTS");
        } else {
            System.out.println("❌ REGISTER FAILED");
        }
    }

    /**
     * Check if a user exists by email. Returns true if user exists, false
     * otherwise.
     */
    public boolean getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    /**
     * Get max UserID (or -1 if none / error).
     */
    public int getMaxUserID() {
        String sql = "SELECT MAX(UserID) AS MaxUserID FROM Users";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("MaxUserID");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return -1;
    }

    /**
     * Create role-specific entry (Staffs / Shippers / Customers) for a new
     * user.
     */
    public void createRole(int newUserID, int role) {
        String sql = null;
        if (role == 2) {
            sql = "INSERT INTO Staffs (StaffID, Rate, Experience) VALUES (?, ?, ?)";
            double rate = 1.0;
            int experience = 0;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, newUserID);
                ps.setDouble(2, rate);
                ps.setInt(3, experience);
                ps.executeUpdate();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }

        } else if (role == 3) {
            sql = "INSERT INTO Shippers (ShipperID, Rate, Commision) VALUES (?, ?, ?)";
            double rate = 1.0;
            double commision = 1.0;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, newUserID);
                ps.setDouble(2, rate);
                ps.setDouble(3, commision);
                ps.executeUpdate();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        } else if (role == 1) {
            sql = "INSERT INTO Customers (CustomerID) VALUES (?)";
        }

    }

    /**
     * Update user role: insert into new role table, then delete old role
     * record.
     */
    public void updateUserByRole(int userId, int role, int oldRole) {
        // Insert into new role table
        createRole(userId, role);
        // Remove old role entry
        deleteByRole(userId, oldRole);
    }

    /**
     * Delete role-specific entry.
     */
    public void deleteByRole(int userId, int oldRole) {
        String sql = null;
        if (oldRole == 2) {
            sql = "DELETE FROM Staffs WHERE StaffID = ?";
        } else if (oldRole == 3) {
            sql = "DELETE FROM Shippers WHERE ShipperID = ?";
        } else if (oldRole == 1) {
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

    /**
     * Retrieve all users who have a specific role.
     */
    public List<Users> getUsersByRole(int role) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieve a user by email AND phone (used for verification/reset flows).
     */
    public Users getUserByEmailAndPhone(String email, String phone) {
        String sql = "SELECT * FROM Users WHERE Email = ? AND Phone = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Update user's status by email.
     */
    public boolean updateUserStatus(String status, String email) {
        String sql = "UPDATE Users SET Status = ? WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

public void insertPhone(int userID, String phone) {
    String sql = "UPDATE Users SET Phone = ? WHERE UserID = ?";
    
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, phone);  
        ps.setInt(2, userID);    
        
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public void insertAddress(int userID, String address) {
    String sql = "UPDATE Users SET Address = ? WHERE UserID = ?";
    
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, address);  
        ps.setInt(2, userID);    
        
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
}
