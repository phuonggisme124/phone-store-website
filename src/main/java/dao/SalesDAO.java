package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBContext;

/**
 * This class provides data access methods for managing sales records.
 * It connects to the database using the inherited DBContext connection.
 */
public class SalesDAO extends DBContext {

    /**
     * Default constructor that initializes the database connection.
     */
    public SalesDAO() {
        super();
    }

    /**
     * Assigns a shipper and a staff member to a specific order.
     * If the order already exists in Sales -> UPDATE
     * If not -> INSERT
     * Then update Order status to 'In Transit'
     *
     * @param orderId  ID của đơn hàng
     * @param staffId  Nhân viên xử lý
     * @param shipperId Shipper giao hàng
     */
    public void assignShipperForOrder(int orderId, int staffId, int shipperId) {

        String sql = "UPDATE Sales "
                + "SET ShipperID = ?, StaffID = ? "
                + "WHERE OrderID = ?;";


        try {
            // 1) Kiểm tra xem order đã tồn tại trong bảng Sales chưa
            String checkSql = "SELECT SaleID FROM Sales WHERE OrderID = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, orderId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // 2) Nếu đã có thì UPDATE
                String updateSql = "UPDATE Sales SET ShipperID=?, StaffID=?, SaleDate=GETDATE() WHERE OrderID=?";
                PreparedStatement ps = conn.prepareStatement(updateSql);
                ps.setInt(1, shipperId);
                ps.setInt(2, staffId);
                ps.setInt(3, orderId);
                ps.executeUpdate();
            } else {
                // 3) Nếu chưa có thì INSERT
                String insertSql = "INSERT INTO Sales (OrderID, StaffID, SaleDate, ShipperID) VALUES (?, ?, GETDATE(), ?)";
                PreparedStatement ps = conn.prepareStatement(insertSql);
                ps.setInt(1, orderId);
                ps.setInt(2, staffId);
                ps.setInt(3, shipperId);
                ps.executeUpdate();
            }

            // 4) Cập nhật trạng thái đơn hàng
            String updateOrderSql = "UPDATE Orders SET Status = 'In Transit' WHERE OrderID = ?";
            PreparedStatement ps2 = conn.prepareStatement(updateOrderSql);
            ps2.setInt(1, orderId);
            ps2.executeUpdate();

        } catch (Exception e) {
            System.out.println("Error assignShipperForOrder: " + e.getMessage());
        }
    }
}
