package dao;

import utils.DBContext;
import java.sql.PreparedStatement;

/**
 * DAO for Warranty Claims
 */
public class WarrantyClaimDAO extends DBContext {

    public void createClaim(int warrantyID, String reason) {
        String sql = "INSERT INTO WarrantyClaims "
                   + "(WarrantyID, Reason, RequestDate, Status) "
                   + "VALUES (?, ?, GETDATE(), 'Pending')";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, warrantyID);
            ps.setString(2, reason);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
