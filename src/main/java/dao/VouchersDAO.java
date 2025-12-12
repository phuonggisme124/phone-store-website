/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import model.Vouchers;
import utils.DBContext;

/**
 *
 * @author USER
 */
public class VouchersDAO extends DBContext {

    public void createVoucher(Vouchers v) {
        String sql = "INSERT INTO Vouchers (Code, PercentDiscount, StartDay, EndDay, Quantity, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, v.getCode());
            ps.setInt(2, v.getPercentDiscount());
            ps.setDate(3, v.getStartDay());
            ps.setDate(4, v.getEndDay());
            ps.setInt(5, v.getQuantity());
            ps.setString(6, v.getStatus());
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println("Error at createVoucher: " + e.getMessage());
        }
    }
}
