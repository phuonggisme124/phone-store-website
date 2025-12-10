/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.InterestRate;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class InterestRateDAO extends DBContext {

    public List<InterestRate> getInInterestRate() {
        String sql = "SELECT * FROM InterestRates";
        List<InterestRate> iRList = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int percent = rs.getInt("Percent");
                int instalmentPeriod = rs.getInt("InstalmentPeriod");
                InterestRate ir = new InterestRate(percent, instalmentPeriod);
                iRList.add(ir);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
        return iRList;
    }

    public InterestRate getInterestRatePercentByIstalmentPeriod(int instalmentPeriod) {
        String sql = "SELECT * FROM InterestRates WHERE InstalmentPeriod = ?";
        InterestRate ir = null;

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, instalmentPeriod);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("InterestRateID");  
                int percent = rs.getInt("Percent");
                ir = new InterestRate(id, percent, instalmentPeriod); 
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return ir;
    }

}
