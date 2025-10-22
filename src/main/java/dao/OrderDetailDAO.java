/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import model.OrderDetails;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class OrderDetailDAO extends DBContext {

    public void insertNewOrderDetail(OrderDetails oD, byte isInstalment) {
        if (isInstalment == 0) {
            String sql = "INSERT INTO OrderDetails (OrderID, VariantID, Quantity, UnitPrice) "
                    + "VALUES (?, ?, ?, ?)";
            try {
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, oD.getOrderID());
                ps.setInt(2, oD.getVariantID());
                ps.setInt(3, oD.getQuantity());
                ps.setDouble(4, oD.getUnitPrice());
                ps.executeUpdate();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        } else {
            String sql = "INSERT INTO OrderDetails (OrderID, VariantID, Quantity, UnitPrice, "
                    + "InterestRateID, MonthlyPayment, DownPayment, InterestRate) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try {
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, oD.getOrderID());
                ps.setInt(2, oD.getVariantID());
                ps.setInt(3, oD.getQuantity());
                ps.setDouble(4, oD.getUnitPrice());
                ps.setInt(5, oD.getInterestRate());
                ps.setDouble(6, oD.getMonthlyPayment());
                ps.setDouble(7, oD.getDownPayment());
                ps.setInt(8, oD.getInterestRate());
                ps.executeUpdate();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
    }

}
