package dao;

import utils.DBContext;
import model.Staff;
import model.Shipper;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit; 
import java.util.ArrayList;
import java.util.List;

public class SalaryDAO extends DBContext {

    public SalaryDAO() {
        super();
    }


    private double calculateRate(LocalDateTime joinDate) {
        if (joinDate == null) return 1.0; // Mặc định nếu không có ngày vào

        LocalDateTime now = LocalDateTime.now();
        // Tính số tháng chênh lệch
        long months = ChronoUnit.MONTHS.between(joinDate, now);

        // Logic xếp loại
        if (months >= 12) {
            return 1.6;
        } else if (months >= 6) {
            return 1.4;
        } else if (months >= 3) {
            return 1.2;
        } else {
            return 1.0; // Dưới 3 tháng
        }
    }


    // HÀM LẤY STAFF (Kèm tính Rate luôn)
 
    public List<Staff> getStaffs() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.CreatedAt " +
                     "FROM Users u WHERE u.Role = '3'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                int id = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                
                
                Timestamp ts = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (ts != null) ? ts.toLocalDateTime() : null;

              
                double rate = calculateRate(createdAt);

                // Tạo đối tượng Staff với Rate đã tính
                //list.add(new Staff(id, fullName, createdAt, rate));
            }
        } catch (Exception e) {
            System.out.println("Error getStaffs: " + e.getMessage());
        }
        return list;
    }

    // HÀM LẤY SHIPPER 
 
    public List<Shipper> getShippers() {
        List<Shipper> list = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.CreatedAt, s.Commision " +
                     "FROM Users u " +
                     "JOIN Shippers s ON u.UserID = s.ShipperID " +
                     "WHERE u.Role = '2'";
                     
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                int id = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                
                Timestamp ts = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (ts != null) ? ts.toLocalDateTime() : null;
                
                double commission = rs.getDouble("Commision");

       
                double rate = calculateRate(createdAt);

                // Tạo đối tượng Shipper
                list.add(new Shipper(id, fullName, createdAt, commission, rate));
            }
        } catch (Exception e) {
            System.out.println("Error getShippers: " + e.getMessage());
        }
        return list;
    }
}