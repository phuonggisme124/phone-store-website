package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DBContext;

/**
 * This class provides data access methods for managing sales records. It
 * connects to the database using the inherited DBContext connection.
 */
public class SalesDAO extends DBContext {

    /**
     * Default constructor that initializes the database connection.
     */
    public SalesDAO() {
        super();
    }

    /**
     * Assigns a shipper and a staff member to a specific order. If the order
     * already exists in Sales -> UPDATE If not -> INSERT Then update Order
     * status to 'In Transit'
     *
     * @param orderId ID của đơn hàng
     * @param staffId Nhân viên xử lý
     * @param shipperId Shipper giao hàng
     */
    public void assignShipperForOrder(int orderId, int staffId, int shipperId) {
        String checkSql = "SELECT SaleID FROM Sales WHERE OrderID = ?";
        String updateSql = "UPDATE Sales SET ShipperID=?, StaffID=?, CreatedAt=GETDATE() WHERE OrderID=?";
        String insertSql = "INSERT INTO Sales (OrderID, StaffID, CreatedAt, ShipperID) VALUES (?, ?, GETDATE(), ?)";
        String updateOrderSql = "UPDATE Orders SET Status = 'In Transit' WHERE OrderID = ?";

        try (
                PreparedStatement checkPs = conn.prepareStatement(checkSql); PreparedStatement updateOrderPs = conn.prepareStatement(updateOrderSql);) {
            checkPs.setInt(1, orderId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, shipperId);
                    ps.setInt(2, staffId);
                    ps.setInt(3, orderId);
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, staffId);
                    ps.setInt(3, shipperId);
                    ps.executeUpdate();
                }
            }

            updateOrderPs.setInt(1, orderId);
            updateOrderPs.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Error assignShipperForOrder: " + e.getMessage());
        }
    }

}
