package dao;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import model.Sale;
import utils.DBContext;

public class CustomerDAO extends DBContext {

    // Helper: Map ResultSet to Customer Object
    // Giúp code ngắn gọn hơn, không phải viết lại việc get dữ liệu ở mỗi hàm
    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        return new Customer(
            rs.getInt("CustomerID"),
            rs.getString("FullName"),
            rs.getString("Email"),
            rs.getString("Phone"),
            rs.getString("Password"),
            rs.getString("Address"),
            rs.getTimestamp("CreatedAt"),
            rs.getString("Status"),
            rs.getString("CCCD"),
            rs.getDate("YOB"),
            rs.getInt("Point")
        );
    }

    // Helper: MD5 Hashing
    public String hashMD5(String pass) {
        try {
            MessageDigest mes = MessageDigest.getInstance("MD5");
            byte[] mesMD5 = mes.digest(pass.getBytes());
            StringBuilder str = new StringBuilder();
            for (byte b : mesMD5) {
                str.append(String.format("%02x", b));
            }
            return str.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return "";
        }
    }

    // 1. Get All Customers
    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Login (Email & Password)
    public Customer login(String email, String pass) {
        String sql = "SELECT * FROM Customer WHERE Email = ? AND Password = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashMD5(pass));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Login with Google (Email only)
    public Customer loginWithEmail(String email) {
        String sql = "SELECT * FROM Customer WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 4. Get Customer by ID
    public Customer getCustomerByID(int id) {
        String sql = "SELECT * FROM Customer WHERE CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 5. Update Customer (Admin side - Full update including Role/Status)
    public void updateCustomer(int userId, String name, String email, String phone, String address, int role, String status, String cccd, Date yob) {
        // Lưu ý: Cập nhật cả CCCD và YOB nếu cần
        String sql = "UPDATE Customer SET FullName = ?, Email = ?, Phone = ?, Role = ?, Address = ?, Status = ?, CCCD = ?, YOB = ? WHERE CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setInt(4, role); // Giữ Role trong DB dù Model không có
            ps.setString(5, address);
            ps.setString(6, status);
            ps.setString(7, cccd);
            ps.setDate(8, yob);
            ps.setInt(9, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 6. Register (Classic)
    public boolean register(String name, String email, String numberPhone, String address, String password, int role) {
        if (checkEmailExists(email)) {
            System.out.println("Email already exists!");
            return false;
        }

        String sql = "INSERT INTO Customer (FullName, Email, Phone, Password, Role, Address, CreatedAt, Status, Point, CCCD, YOB) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, NULL, NULL)"; // Mặc định Point=0, CCCD=null, YOB=null khi đăng ký nhanh

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, numberPhone);
            ps.setString(4, hashMD5(password));
            ps.setInt(5, role);
            ps.setString(6, address);
            ps.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(8, "active");
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 7. Register for Google Login
    public boolean registerForLoginWithGoogle(String name, String email, int role) {
        if (checkEmailExists(email)) {
            return true; // Đã tồn tại coi như thành công để login
        }

        String sql = "INSERT INTO Customer (FullName, Email, Role, CreatedAt, Status, Point, Password) VALUES (?, ?, ?, ?, ?, 0, '')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setInt(3, role);
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(5, "active");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 8. Delete Customer
    public void deleteCustomer(int userId) {
        String sql = "DELETE FROM Customer WHERE CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 9. Get All Sales (Join logic)
    public List<Sale> getAllSales() {
        List<Sale> list = new ArrayList<>();
        String sql = "SELECT s.SaleID, s.OrderID, s.CreatedAt, "
                   + "staff.CustomerID AS StaffID, staff.FullName AS StaffName, staff.Phone AS StaffPhone, "
                   + "shipper.CustomerID AS ShipperID, shipper.FullName AS ShipperName, shipper.Phone AS ShipperPhone "
                   + "FROM Sales s "
                   + "LEFT JOIN Customer staff ON s.StaffID = staff.CustomerID "
                   + "LEFT JOIN Customer shipper ON s.ShipperID = shipper.CustomerID";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Constructor Customer(id, name, phone)
                Customer staff = new Customer(rs.getInt("StaffID"), rs.getString("StaffName"), rs.getString("StaffPhone"));
                Customer shipper = new Customer(rs.getInt("ShipperID"), rs.getString("ShipperName"), rs.getString("ShipperPhone"));
                
                Timestamp ts = rs.getTimestamp("CreatedAt");
                LocalDateTime created = (ts != null) ? ts.toLocalDateTime() : null;

                list.add(new Sale(rs.getInt("SaleID"), shipper, staff, rs.getInt("OrderID"), created));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 10. Get All Shippers (Role = 3)
    public List<Customer> getAllShippers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer WHERE Role = 3";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 11. Update Customer Profile (User side - Update personal info)
    public void updateCustomerProfile(Customer customer) {
        StringBuilder sql = new StringBuilder("UPDATE Customer SET FullName = ?, Email = ?, Phone = ?, Address = ?, CCCD = ?, YOB = ?");
        boolean hasPassword = customer.getPassword() != null && !customer.getPassword().trim().isEmpty();

        if (hasPassword) {
            sql.append(", Password = ?");
        }
        sql.append(" WHERE CustomerID = ?");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhone());
            ps.setString(4, customer.getAddress());
            ps.setString(5, customer.getCccd());
            ps.setDate(6, customer.getYob());

            int index = 7;
            if (hasPassword) {
                ps.setString(index++, hashMD5(customer.getPassword()));
            }
            ps.setInt(index, customer.getCustomerID());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 12. Update Password
    public void updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Customer SET Password = ? WHERE CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashMD5(newPassword));
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 13. Check Old Password
    public boolean checkOldPassword(int userId, String oldPassword) {
        String sql = "SELECT Password FROM Customer WHERE CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String currentHash = rs.getString("Password");
                    // Kiểm tra null để tránh NullPointerException
                    return currentHash != null && currentHash.equals(hashMD5(oldPassword));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 14. Get All Buyer Phones
    public List<String> getAllBuyerPhones() {
        List<String> phones = new ArrayList<>();
        String sql = "SELECT DISTINCT u.Phone FROM Orders o JOIN Customer u ON o.CustomerID = u.CustomerID WHERE u.Phone IS NOT NULL AND u.Phone <> ''";
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

    // 15. Check Email Exists (Helper method)
    public boolean checkEmailExists(String email) {
        String sql = "SELECT 1 FROM Customer WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 16. Get Max Customer ID
    public int getMaxCustomerID() {
        String sql = "SELECT MAX(CustomerID) AS MaxCustomerID FROM Customer";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("MaxCustomerID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // 17. Create Role Details (Insert into Staffs/Shippers tables)
    public void createRole(int newCustomerID, int role) {
        String sql = null;
        try {
            if (role == 2) { // Staff
                sql = "INSERT INTO Staffs (StaffID, Rate, Experience) VALUES (?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, newCustomerID);
                    ps.setDouble(2, 1.0); // Default Rate
                    ps.setInt(3, 0);      // Default Exp
                    ps.executeUpdate();
                }
            } else if (role == 3) { // Shipper
                sql = "INSERT INTO Shippers (ShipperID, Rate, Commision) VALUES (?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, newCustomerID);
                    ps.setDouble(2, 1.0); // Default Rate
                    ps.setDouble(3, 1.0); // Default Commission
                    ps.executeUpdate();
                }
            } else if (role == 1) { // Customer specific table if exists
                sql = "INSERT INTO Customers (CustomerID) VALUES (?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                     ps.setInt(1, newCustomerID);
                     ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 18. Update Customer Role (Change role logic)
    public void updateCustomerByRole(int userId, int role, int oldRole) {
        deleteByRole(userId, oldRole);
        createRole(userId, role);
    }

    // 19. Delete Role Details
    public void deleteByRole(int userId, int oldRole) {
        String sql = null;
        if (oldRole == 2) sql = "DELETE FROM Staffs WHERE StaffID = ?";
        else if (oldRole == 3) sql = "DELETE FROM Shippers WHERE ShipperID = ?";
        else if (oldRole == 1) sql = "DELETE FROM Customers WHERE CustomerID = ?";

        if (sql != null) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 20. Get Customers by Role
    public List<Customer> getCustomersByRole(int role) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer WHERE Role = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 21. Get Customer by Email and Phone
    public Customer getCustomerByEmailAndPhone(String email, String phone) {
        String sql = "SELECT * FROM Customer WHERE Email = ? AND Phone = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 22. Update Status Only
    public boolean updateCustomerStatus(String status, String email) {
        String sql = "UPDATE Customer SET Status = ? WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 23. Update Phone Only
    public void insertPhone(int userID, String phone) {
        String sql = "UPDATE Customer SET Phone = ? WHERE CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setInt(2, userID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 24. Update Address Only
    public void insertAddress(int userID, String address) {
        String sql = "UPDATE Customer SET Address = ? WHERE CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, address);
            ps.setInt(2, userID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // 25. Update Point
    public void updatePoint(int userID, int point) {
        String sql = "UPDATE Customer SET Point = ? WHERE CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, point);
            ps.setInt(2, userID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // 26. Get Customer by Email (Boolean check) - Reused checkEmailExists logic but for object retrieval logic
    public boolean getCustomerByEmail(String email) {
        return checkEmailExists(email);
    }
}