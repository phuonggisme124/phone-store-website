/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import utils.DBContext;

/**
 * This class provides data access methods for managing sales records.
 * It connects to the database using the inherited DBContext connection.
 */
public class SalesDAO extends DBContext {

    /**
     * 
     * @author admin
     * 
     * Default constructor that initializes the database connection.
     */
    public SalesDAO() {
        super();
    }

    /**
     * Assigns a shipper and a staff member to a specific sales order.
     *
     * @param orderId The ID of the sales order to update.
     * @param staffId The ID of the staff member responsible for the order.
     * @param shipperId The ID of the shipper assigned to deliver the order.
     */
    public void assignShipperForOrder(int orderId, int staffId, int shipperId) {
        String sql = "UPDATE Sales "
                + "SET ShipperID = ?, StaffID = ? "
                + "WHERE SaleID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            // Assign the shipper to the order
            ps.setInt(1, shipperId);

            // Assign the staff member to the order
            ps.setInt(2, staffId);

            // Specify which order to update
            ps.setInt(3, orderId);

            // Execute the update operation
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println("Error in assignShipperForOrder: " + e.getMessage());
        }
    }
}
