package dao;

import java.security.MessageDigest;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import utils.DBContext;

public class CustomerDAO extends DBContext {

    // ============================================================
    // Helper: Convert ResultSet → Customer
    private Customer map(ResultSet rs) throws SQLException {
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

    // MD5 hashing
    public String md5(String pass) {
        try {
            MessageDigest m = MessageDigest.getInstance("MD5");
            byte[] digest = m.digest(pass.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }

    // ============================================================
    // GET ALL
    public List<Customer> getAllCustomers() {
        String sql = "SELECT * FROM Customers";
        List<Customer> list = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ============================================================
    // LOGIN email + password
    public Customer login(String email, String pass) {
        String sql = "SELECT * FROM Customers WHERE Email = ? AND Password = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, md5(pass));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ============================================================
    // LOGIN Google
    public Customer loginWithEmail(String email) {
        String sql = "SELECT * FROM Customers WHERE Email = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ============================================================
    // REGISTER → return new CustomerID
    public int register(String name, String email, String phone, String address, String password) {

        if (emailExists(email)) {
            return -1;
        }

        String sql
                = "INSERT INTO Customers (FullName, Email, Phone, Password, Address, CreatedAt, Status, Point) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), 'active', 0)";

        try (PreparedStatement ps
                = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, md5(password));
            ps.setString(5, address);

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    // REGISTER Google
    public boolean registerForLoginWithGoogle(String name, String email) {

        if (emailExists(email)) {
            return true;
        }

        String sql
                = "INSERT INTO Customers (FullName, Email, CreatedAt, Status, Point, Password) "
                + "VALUES (?, ?, GETDATE(), 'active', 0, '')";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ============================================================
    // CHECK email exists
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM Customers WHERE Email = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

// UPDATE PROFILE 
    public void updateProfile(Customer c) {

        String sql = "UPDATE Customers SET FullName=?, Email=?, Phone=?, Address=?, CCCD=?, YOB=? WHERE CustomerID=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getAddress());
            ps.setString(5, c.getCccd());
            ps.setDate(6, c.getYob());
            ps.setInt(7, c.getCustomerID());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ============================================================
    // UPDATE PASSWORD
    public void updatePassword(int id, String pass) {
        String sql = "UPDATE Customers SET Password = ? WHERE CustomerID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, md5(pass));
            ps.setInt(2, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean checkOldPassword(int id, String oldPass) {
        String sql = "SELECT Password FROM Customers WHERE CustomerID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString(1).equals(md5(oldPass));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ============================================================
    // UPDATE fields
    public void updatePhone(int id, String phone) {
        exec("UPDATE Customers SET Phone=? WHERE CustomerID=?", phone, id);
    }

    public void updateAddress(int id, String address) {
        exec("UPDATE Customers SET Address=? WHERE CustomerID=?", address, id);
    }

    public void updatePoint(int id, int point) {
        exec("UPDATE Customers SET Point=? WHERE CustomerID=?", point, id);
    }

    private void exec(String sql, Object v1, Object v2) {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, v1);
            ps.setObject(2, v2);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateCustomerStatus(String status, String email) {
        String sql = "UPDATE Customers SET Status = ? WHERE Email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
public Customer getCustomerById(int id) {
        // SQL lấy từ bảng Customers
        String sql = "SELECT * FROM Customers WHERE CustomerID = ?";


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

// Hàm map dữ liệu từ SQL sang Customer Model
    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        // Lấy dữ liệu từ các cột trong Database
        // Đảm bảo tên cột trong "..." khớp với Database của bạn
        int customerID = rs.getInt("CustomerID");
        String fullName = rs.getString("FullName");
        String email = rs.getString("Email");
        String phone = rs.getString("Phone");
        String password = rs.getString("Password");
        String address = rs.getString("Address");

        // Model Customer dùng java.sql.Timestamp nên lấy trực tiếp
        Timestamp createdAt = rs.getTimestamp("CreatedAt");

        // Model Customer khai báo Status là String
        String status = rs.getString("Status");

        String cccd = rs.getString("CCCD");
        Date yob = rs.getDate("YOB");
        int point = rs.getInt("Point");

        // Gọi Full Constructor của Customer
        return new Customer(customerID, fullName, email, phone, password,
                address, createdAt, status, cccd, yob, point);
    }

}
