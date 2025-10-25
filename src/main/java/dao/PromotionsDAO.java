/*
 * Data Access Object (DAO) class for handling database operations related to Promotions.
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Promotions;
import utils.DBContext;

/**
 *
 * @author duynu
 *
 * DAO class responsible for managing promotions data. Provides methods for
 * creating, reading, and updating promotion records.
 */
public class PromotionsDAO extends DBContext {

    public PromotionsDAO() {
        super();
    }

    /**
     * Retrieve all promotions from the database.
     *
     * @return A list of all promotion records.
     */
    public List<Promotions> getAllPromotion() {
        String sql = "Select * from Promotions";
        List<Promotions> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("PromotionID");
                int discountPercent = rs.getInt("DiscountPercent");

                // Convert SQL timestamps to LocalDateTime
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

                // Create and add promotion object to the list
                list.add(new Promotions(id, discountPercent, startDate, endDate, status, pid));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    /**
     * Retrieve a promotion associated with a specific product ID.
     *
     * @param id The product ID.
     * @return The promotion for the given product, or null if none found.
     */
    public Promotions getPromotionByProductID(int id) {
        String sql = "SELECT * FROM Promotions where ProductID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int pmtID = rs.getInt("PromotionID");
                int discountPercent = rs.getInt("DiscountPercent");

                // Convert timestamps
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

                // Return promotion object
                return (new Promotions(pmtID, discountPercent, startDate, endDate, status, pid));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Retrieve a promotion by its unique promotion ID.
     *
     * @param pmtID The promotion ID.
     * @return The promotion object, or null if not found.
     */
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

    /**
     * Update an existing promotion record.
     *
     * @param pmtID Promotion ID.
     * @param pID Product ID.
     * @param discountPercent Discount percentage applied to the promotion.
     * @param startDate Start date of the promotion.
     * @param endDate End date of the promotion.
     * @param status Current status of the promotion.
     */
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

    /**
     * Create a new promotion in the database.
     *
     * @param pID Product ID that this promotion applies to.
     * @param discountPercent Discount percentage.
     * @param startDate Start date of the promotion.
     * @param endDate End date of the promotion.
     * @param status Promotion status (e.g., Active, Expired).
     */
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

    public List<Promotions> getTheHighestPromotion() {
        String sql = "SELECT *\n"
                + "FROM Promotions\n"
                + "WHERE DiscountPercent = (SELECT MAX(DiscountPercent) FROM Promotions);";
        List<Promotions> promotionsList = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int pmtID = rs.getInt("PromotionID");
                int discountPercent = rs.getInt("DiscountPercent");

                // Convert timestamps
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

                // Return promotion object
                promotionsList.add(new Promotions(pmtID, discountPercent, startDate, endDate, status, pid));
            }
            return promotionsList;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public void deletePromotion(int pmtID) {
        String sql = "DELETE FROM Promotions WHERE PromotionID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pmtID);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
