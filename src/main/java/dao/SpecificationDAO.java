package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Specification;
import utils.DBContext;

/**
 *
 * @author Nhung Hoa
 */
public class SpecificationDAO extends DBContext {

    public Specification getSpecificationByProductID(int productID) {
        String sql = "SELECT * FROM dbo.Specifications WHERE ProductID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Specification(
                        rs.getInt("SpecificationID"),
                        rs.getInt("ProductID"),
                        rs.getString("OS"),
                        rs.getString("CPU"),
                        rs.getString("GPU"),
                        rs.getString("RAM"),
                        rs.getInt("BatteryCapacity"),
                        rs.getString("Touchscreen")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
