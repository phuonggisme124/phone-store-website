/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.OrderDetails;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class OrderDetailDAO extends DBContext {

    public void insertNewOrderDetail(OrderDetails oD) {
        

            String sql = "INSERT INTO OrderDetails (OrderID, VariantID, Quantity, UnitPrice) "
                    + "VALUES (?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, oD.getOrderID());
                ps.setInt(2, oD.getVariantID());
                ps.setInt(3, oD.getQuantity());
                ps.setDouble(4, oD.getUnitPrice());
                ps.executeUpdate();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }

    }



    public List<OrderDetails> getOrderDetailByOrderID(int orderID) {
        String sql = "SELECT od.OrderID, od.VariantID, od.UnitPrice, od.Quantity\n"
                + "FROM OrderDetails od\n"
                + "WHERE od.OrderID = ?";
        List<OrderDetails> oDList = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantID = rs.getInt("VariantID");
                double unitPrice = rs.getDouble("UnitPrice");

 
                int quantity = rs.getInt("Quantity");
                OrderDetails od = new OrderDetails();
                od.setOrderID(orderID);

                od.setQuantity(quantity);
                od.setUnitPrice(unitPrice);
                od.setVariantID(variantID);
                oDList.add(od);

            }
            return oDList;

        } catch (Exception e) {
            System.out.println(e.getMessage());

        }
        return null;
    }

}
