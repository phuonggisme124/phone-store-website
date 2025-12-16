package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Warranty;
import utils.DBContext;

public class WarrantyDAO extends DBContext {

    /**
     * Get all warranties of a customer
     */
    public List<Warranty> getWarrantyByCustomer(int customerID) {
        List<Warranty> list = new ArrayList<>();
        String sql = "SELECT * FROM Warranty WHERE CustomerID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Warranty w = new Warranty();
                w.setWarrantyID(rs.getInt("WarrantyID"));
                w.setCustomerID(rs.getInt("CustomerID"));
                w.setVariantID(rs.getInt("VariantID"));
                w.setSoldDay(rs.getDate("SoldDay"));
                w.setExpiryDate(rs.getDate("ExpiryDate"));
                w.setStatus(rs.getString("Status"));
                list.add(w);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Check warranty still valid
     */
    public boolean isWarrantyValid(int warrantyID) {
        String sql = "SELECT 1 FROM Warranty "
                   + "WHERE WarrantyID = ? "
                   + "AND ExpiryDate >= GETDATE() "
                   + "AND Status = 'active'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, warrantyID);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
