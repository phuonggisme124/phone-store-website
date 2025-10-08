/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Products;
import model.Promotions;
import utils.DBContext;

/**
 *
 * @author duynu
 */
public class PromotionsDAO extends DBContext{

    public PromotionsDAO() {
        super();
    }

    public List<Promotions> getAllPromotion() {
        String sql = "Select * from Promotions";
        List<Promotions> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("PromotionID");
                int discountPercent = rs.getInt("DiscountPercent");
                Timestamp startDateTimestamp = rs.getTimestamp("StartDate");
                LocalDateTime startDate = (startDateTimestamp != null)
                        ? startDateTimestamp.toLocalDateTime()
                        : null;

                Timestamp endDateTimestamp = rs.getTimestamp("EndDate");
                LocalDateTime endDate = (endDateTimestamp != null)
                        ? endDateTimestamp.toLocalDateTime()
                        : null;
                String status = rs.getString("Status");
                int pid = rs.getInt("ProductID");
                list.add(new Promotions(id, discountPercent, startDate, endDate, status, pid));
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public Promotions getPromotionByProductID(int id) {
        String sql = "SELECT * FROM Promotions where ProductID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int pmtID = rs.getInt("PromotionID");
                int discountPercent = rs.getInt("DiscountPercent");
                Timestamp startDateTimestamp = rs.getTimestamp("StartDate");
                LocalDateTime startDate = (startDateTimestamp != null)
                        ? startDateTimestamp.toLocalDateTime()
                        : null;

                Timestamp endDateTimestamp = rs.getTimestamp("EndDate");
                LocalDateTime endDate = (endDateTimestamp != null)
                        ? endDateTimestamp.toLocalDateTime()
                        : null;
                String status = rs.getString("Status");
                int pid = rs.getInt("ProductID");

                return (new Promotions(pmtID, discountPercent, startDate, endDate, status, pid));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public Promotions getPromotionByID(int pmtID) {
        String sql = "SELECT * FROM Promotions where PromotionID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pmtID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("PromotionID");
                int discountPercent = rs.getInt("DiscountPercent");
                Timestamp startDateTimestamp = rs.getTimestamp("StartDate");
                LocalDateTime startDate = (startDateTimestamp != null)
                        ? startDateTimestamp.toLocalDateTime()
                        : null;

                Timestamp endDateTimestamp = rs.getTimestamp("EndDate");
                LocalDateTime endDate = (endDateTimestamp != null)
                        ? endDateTimestamp.toLocalDateTime()
                        : null;
                String status = rs.getString("Status");
                int pid = rs.getInt("ProductID");

                return (new Promotions(id, discountPercent, startDate, endDate, status, pid));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public void updatePromotion(int pmtID, int pID, int discountPercent, LocalDateTime startDate, LocalDateTime endDate, String status) {
        String sql = "UPDATE Promotions\n"
                + "SET DiscountPercent = ?,\n"
                + "    StartDate = ?,\n"
                + "    EndDate = ?,\n"
                + "    Status = ?,\n"
                + "	ProductID = ?\n"
                + "WHERE PromotionID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, discountPercent);
            ps.setTimestamp(2, Timestamp.valueOf(startDate));
            ps.setTimestamp(3, Timestamp.valueOf(endDate));
           
          
            ps.setString(4, status);

            ps.setInt(5, pID);
            ps.setInt(6, pmtID);
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void createPromotion(int pID, int discountPercent, LocalDateTime startDate, LocalDateTime endDate, String status) {
        String sql = "INSERT INTO Promotions (ProductID, DiscountPercent, StartDate, EndDate, Status) "
                + "VALUES (?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, pID);
            ps.setInt(2, discountPercent);            
            ps.setTimestamp(3, Timestamp.valueOf(startDate));
            ps.setTimestamp(4, Timestamp.valueOf(endDate));           
            ps.setString(5, status);

            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    
}
