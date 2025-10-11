/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.OrderDetails;
import model.Payments;
import utils.DBContext;

/**
 * Data Access Object for handling payment-related database operations.
 * This class connects to the database and retrieves payment information
 * associated with specific orders.
 *
 * Author: duynu
 */
public class PaymentsDAO extends DBContext {

    public PaymentsDAO() {
        super();
    }

    /**
     * Retrieves all payment records associated with a specific order ID.
     *
     * @param oid The ID of the order to retrieve payments for.
     * @return A list of Payments objects representing all payments linked to the order.
     */
    public List<Payments> getPaymentByOrderID(int oid) {
        String sql = "SELECT * FROM Payments WHERE OrderID = ?";
        List<Payments> list = new ArrayList<>();

        try {
            // Prepare SQL statement
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, oid);

            // Execute the query
            ResultSet rs = ps.executeQuery();

            // Iterate through the result set
            while (rs.next()) {
                int payID = rs.getInt("paymentID");
                int orderID = rs.getInt("OrderID");
                double amount = rs.getDouble("Amount");

                // Convert SQL Timestamp to LocalDateTime
                Timestamp paymentDateTimestamp = rs.getTimestamp("PaymentDate");
                LocalDateTime paymentDate = (paymentDateTimestamp != null)
                        ? paymentDateTimestamp.toLocalDateTime()
                        : null;

                String paymentStatus = rs.getString("PaymentStatus");
                int totalMonth = rs.getInt("TotalMonths");
                int currentMonth = rs.getInt("CurrentMonth");

                // Create a Payments object and add it to the list
                list.add(new Payments(payID, orderID, amount, paymentDate, paymentStatus, totalMonth, currentMonth));
            }

        } catch (Exception e) {
            // Print the error message to console for debugging
            System.out.println(e.getMessage());
        }

        // Return the list of payments
        return list;
    }
}
