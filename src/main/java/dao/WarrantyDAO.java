package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Warranty;
import utils.DBContext;

public class WarrantyDAO extends DBContext {

    /**
     * Get all warranties of a customer
     */
    public List<Warranty> getWarrantyByCustomer(int customerID) {
        List<Warranty> list = new ArrayList<>();
        // JOIN qua Variants để tới Products lấy cột [Name]
        String sql = "SELECT w.*, p.Name AS ProductName "
                + "FROM Warranty w "
                + "JOIN Variants v ON w.VariantID = v.VariantID "
                + "JOIN Products p ON v.ProductID = p.ProductID "
                + "WHERE w.CustomerID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warranty w = new Warranty();
                w.setWarrantyID(rs.getInt("WarrantyID"));
                w.setOrderID(rs.getInt("orderID"));
                w.setProductName(rs.getString("ProductName")); // Lấy cột Name của bảng Products
                w.setSoldDay(rs.getDate("SoldDay"));
                w.setExpiryDate(rs.getDate("ExpiryDate"));
                w.setStatus(rs.getString("Status"));
                list.add(w);
            }
        } catch (Exception e) {
            System.out.println("Lỗi SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Check warranty still valid
     */
    public boolean isWarrantyValid(int warrantyID) {
        String sql = "SELECT 1 FROM Warranty "
                + "WHERE WarrantyID = ? "
                + "AND ExpiryDate >= GETDATE() "
                + "AND Status = 'active'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, warrantyID);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void createWarranty(Warranty w) {
        String sql = "INSERT INTO Warranty (CustomerID, VariantID, SoldDay, ExpiryDate, Status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, w.getCustomerID());
            ps.setInt(2, w.getVariantID());
            ps.setDate(3, w.getSoldDay());
            ps.setDate(4, w.getExpiryDate());
            ps.setString(5, w.getStatus());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean addWarranty(Warranty w) {
        String sql = "INSERT INTO Warranty (customerID, variantID, soldDay, expiryDate, status, orderID) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().conn; PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, w.getCustomerID());
            ps.setInt(2, w.getVariantID());
            ps.setDate(3, w.getSoldDay());
            ps.setDate(4, w.getExpiryDate());
            ps.setString(5, w.getStatus());
            ps.setInt(6, w.getOrderID());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Warranty getWarrantyByID(int id) {
        String sql = "SELECT w.*, p.Name AS ProductName "
                + "FROM Warranty w "
                + "JOIN Variants v ON w.VariantID = v.VariantID "
                + "JOIN Products p ON v.ProductID = p.ProductID "
                + "WHERE w.WarrantyID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Warranty w = new Warranty();
                w.setWarrantyID(rs.getInt("WarrantyID"));
                w.setOrderID(rs.getInt("OrderID"));
                w.setVariantID(rs.getInt("VariantID"));
                w.setProductName(rs.getString("ProductName")); // Thêm luôn ProductName để hiển thị ở trang claim
                w.setSoldDay(rs.getDate("SoldDay"));
                w.setExpiryDate(rs.getDate("ExpiryDate"));
                w.setStatus(rs.getString("Status"));
                return w;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getWarrantyByID: " + e.getMessage());
        }
        return null;
    }

}
