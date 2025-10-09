/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import utils.DBContext;

/**
 *
 * @author admin
 */
public class SalesDAO extends DBContext{

    public SalesDAO() {
    }
public void assignShipperForOrder(int orderId, int staffId, int shipperId) {
    String sql = "UPDATE Sales " +
                 "SET ShipperID = ?, StaffID = ? " +
                 "WHERE SaleID = ?;";

    try {
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, shipperId); // gán Shipper
        ps.setInt(2, staffId);   // gán Staff
        ps.setInt(3, orderId);   // xác định đơn hàng
        ps.executeUpdate();

    } catch (Exception e) {
        System.out.println("Error assignShipperForOrder: " + e.getMessage());
    }
}

}
