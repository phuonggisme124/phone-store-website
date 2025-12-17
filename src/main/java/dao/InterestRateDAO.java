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
                float percentExpried = rs.getFloat("PercentExpried");
                ir = new InterestRate(id, percent, instalmentPeriod, percentExpried); 
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return ir;
    }

    public List<InterestRate> getAllInterestRate() {
        String sql = "SELECT * FROM InterestRates";
        List<InterestRate> iRList = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("InterestRateID");
                int percent = rs.getInt("Percent");
                int instalmentPeriod = rs.getInt("InstalmentPeriod");
                float percentExpried = rs.getFloat("percentExpried");
                InterestRate ir = new InterestRate(id, percent, instalmentPeriod, percentExpried);
                iRList.add(ir);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
        return iRList;
    }

    public InterestRate getAllInterestRateByID(int id) {
        String sql = "SELECT * FROM InterestRates Where InterestRateID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int irID = rs.getInt("InterestRateID");
                int percent = rs.getInt("Percent");
                int instalmentPeriod = rs.getInt("InstalmentPeriod");
                float percentExpried = rs.getFloat("percentExpried");
                InterestRate ir = new InterestRate(irID, percent, instalmentPeriod, percentExpried);
                return ir;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
        return null;
    }

    public void updateInterestRate(int id, int period, int rateValue, float rateExpired) {
        String sql = "UPDATE InterestRates SET instalmentPeriod = ?,"
                + " [percent] = ?,"
                + " PercentExpried = ?"
                + " WHERE InterestRateID = ?";
        
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, period);
            ps.setInt(2, rateValue);
            ps.setFloat(3, rateExpired);
            ps.setInt(4, id);
            ps.executeUpdate();
        }catch(Exception e){
            System.out.println(e.getMessage());
        }
    }

    public void createInterestRate(int period, int rateValue, float rateExpired) {
        String sql = "INSERT INTO InterestRates (instalmentPeriod, [Percent], PercentExpried) "
                + "VALUES (?, ?, ?)";
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, period);
            ps.setInt(2, rateValue);
            ps.setFloat(3, rateExpired);
            
            ps.executeUpdate();
        }catch(Exception e){
            System.out.println(e.getMessage());
        }
    }

    public void deleteInterestRate(int id) {
        String sql = "DELETE FROM InterestRates WHERE InterestRateID = ?";
        
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        }catch(Exception e){
            System.out.println(e.getMessage());
        }
    }

}
