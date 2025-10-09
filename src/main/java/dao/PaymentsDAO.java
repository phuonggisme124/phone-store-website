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
 *
 * @author duynu
 */
public class PaymentsDAO extends DBContext{

    public PaymentsDAO() {
        super();
    }

    public List<Payments> getPaymentByOrderID(int oid) {
        String sql = "Select * from Payments where OrderID = ?";
        List<Payments> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, oid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int payID = rs.getInt("paymentID");
                int orderID = rs.getInt("OrderID");
                double amount = rs.getDouble("Amount");
                Timestamp paymentDateTimestamp = rs.getTimestamp("PaymentDate");
                LocalDateTime paymentDate = (paymentDateTimestamp != null)
                        ? paymentDateTimestamp.toLocalDateTime()
                        : null;
                
                String paymentStatus = rs.getString("PaymentStatus");
                int totalMonth = rs.getInt("TotalMonths");              
                int currentMonth = rs.getInt("CurrentMonth");              
             
                list.add(new Payments(payID, orderID, amount, paymentDate, paymentStatus, totalMonth, currentMonth));
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }
    
    
}
