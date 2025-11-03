/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetails;
import model.Payments;
import utils.DBContext;

/**
 * Data Access Object for handling payment-related database operations. This
 * class connects to the database and retrieves payment information associated
 * with specific orders.
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
     * @return A list of Payments objects representing all payments linked to
     * the order.
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

    public void insertNewPayment(Order o, int instalmentPeriod) {
        String sql = "INSERT INTO Payments (OrderID, Amount, PaymentDate, PaymentStatus, TotalMonths, CurrentMonth) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            for (int i = 1; i <= instalmentPeriod; i++) {
                ps.setInt(1, o.getOrderID());
                ps.setDouble(2, o.getTotalAmount() / instalmentPeriod); // chia đều số tiền mỗi tháng
                ps.setDate(3, java.sql.Date.valueOf(o.getOrderDate().toLocalDate().plusMonths(i))); // cộng dồn tháng
                ps.setString(4, "Unpaid");
                ps.setInt(5, instalmentPeriod);
                ps.setInt(6, i);
                ps.addBatch(); // thêm vào batch
            }
            ps.executeBatch(); // thực thi toàn bộ cùng lúc
            ps.close();
        } catch (SQLException e) {
            System.out.println("insertNewPayment: " + e.getMessage());
        }
    }

    public void updatePaymentStatusToPaid(int paymentID) {
        // Câu lệnh SQL này cập nhật cả trạng thái VÀ ngày thanh toán
        String sql = "UPDATE Payments SET PaymentStatus = 'Paid' WHERE PaymentID = ?";

        try {
            // Tạo PreparedStatement
            PreparedStatement ps = conn.prepareStatement(sql);
            // Gán các giá trị vào tham số '?'
            ps.setInt(1, paymentID);  // Tham số 2: ID của thanh toán
            // Thực thi lệnh update
            ps.executeUpdate();
            // Đóng PreparedStatement
            ps.close();
        } catch (SQLException e) {
            System.out.println("updatePaymentStatusToPaid: " + e.getMessage());
        }
    }

}
