package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Import;
import model.ImportDetail;
import utils.DBContext;

public class ImportDAO extends DBContext {

    // --- HÀM PUBLIC: Chỉ quản lý luồng Transaction ---
    public boolean insertImportTransaction(Import imp, List<ImportDetail> listDetails) {
        Connection conn = this.conn;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn.setAutoCommit(false); // Bắt đầu Transaction

            
            String sql = "INSERT INTO Imports(staffID, supplierID, importDate, totalCost, note, Status) VALUES(?,?,GETDATE(),?,?,0)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, imp.getStaffID());
            ps.setInt(2, imp.getSupplierID());
            ps.setDouble(3, imp.getTotalCost());
            ps.setString(4, imp.getNote());
            ps.executeUpdate();

            // Lấy ID vừa tạo
            rs = ps.getGeneratedKeys();
            int importID = 0;
            if (rs.next()) {
                importID = rs.getInt(1);
            }

            // 2. Insert chi tiết phiếu nhập
            String sqlDetail = "INSERT INTO ImportDetails(importID, variantID, quantity, costPrice) VALUES(?,?,?,?)";
            PreparedStatement psDetail = conn.prepareStatement(sqlDetail);

            for (ImportDetail detail : listDetails) {
                psDetail.setInt(1, importID);
                psDetail.setInt(2, detail.getVariantID());
                psDetail.setInt(3, detail.getQuality());
                psDetail.setDouble(4, detail.getCostPrice());
                
                // Lưu ý: SellingPrice (giá bán) không lưu vào ImportDetails vì DB không có cột này.
                // Nó sẽ được dùng khi Admin duyệt đơn để update vào bảng Variants/Profits sau.

                psDetail.addBatch();
            }
            psDetail.executeBatch();
            conn.commit();
            return true;
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
            }
            e.printStackTrace();
        }
        return false;
    }

    // --- CÁC HÀM LẤY DỮ LIỆU ---

    public List<Import> getAllImports() {
        List<Import> list = new ArrayList<>();

        // SỬA: JOIN với bảng Staff thay vì Users
        String sql = "SELECT i.importID, st.FullName as staffName, i.totalCost, i.importDate, i.note, i.status, \n"
                + "  s.name AS SupplierName \n"
                + "\n"
                + "  FROM Imports i \n"
                + "  JOIN Suppliers s ON i.supplierID = s.supplierID \n"
                + "  JOIN Staff st ON i.staffID = st.StaffID \n" // Sửa Users -> Staff
                + "  ORDER BY i.importID DESC";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Import imp = new Import();
                imp.setImportID(rs.getInt("importID"));
                imp.setStaffName(rs.getString("staffName"));
                imp.setTotalCost(rs.getDouble("totalCost"));

                // Xử lý ngày tháng
                java.sql.Timestamp ts = rs.getTimestamp("importDate");
                if (ts != null) {
                    imp.setImportDate(ts.toLocalDateTime());
                }

                imp.setNote(rs.getString("note"));
                imp.setStatus(rs.getInt("status"));
                imp.setSupplierName(rs.getString("SupplierName"));

                list.add(imp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ImportDetail> getDetailsByImportID(int importID) {
        List<ImportDetail> list = new ArrayList<>();
        // SQL: Lấy chi tiết nhập + Nối bảng Variants + Nối bảng Products để lấy tên
        String sql = "SELECT d.variantID, d.quantity, d.costPrice, "
                + "       p.Name AS ProductName, "
                + "       v.Color, v.Storage "
                + "FROM ImportDetails d "
                + "JOIN Variants v ON d.variantID = v.variantID "
                + "JOIN Products p ON v.productID = p.productID "
                + "WHERE d.importID = ?";

        try {

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, importID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ImportDetail d = new ImportDetail();
                // Lấy dữ liệu gốc
                d.setVariantID(rs.getInt("variantID"));
                d.setQuality(rs.getInt("quantity")); 
                d.setCostPrice(rs.getDouble("costPrice"));

                // Lấy dữ liệu hiển thị
                d.setProductName(rs.getString("ProductName"));
                d.setColor(rs.getString("Color"));
                d.setStorage(rs.getString("Storage"));

                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    
    public boolean approveImport(int importID) {
        Connection conn = this.conn;
        PreparedStatement ps = null;
        ResultSet rs = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psStatus = null;

        List<ImportDetail> listTemp = new ArrayList<>();

        try {
            conn.setAutoCommit(false);

            // 1. ĐỌC DỮ LIỆU CHI TIẾT PHIẾU NHẬP
            // Lấy thêm SellingPrice hiện tại từ bảng Variants để đưa vào Profits (vì ImportDetails ko có)
            String sqlGetDetails = "SELECT d.variantID, d.quantity, d.costPrice, v.Price as CurrentSellingPrice "
                    + "FROM ImportDetails d "
                    + "JOIN Variants v ON d.variantID = v.variantID "
                    + "WHERE d.importID = ?";
            ps = conn.prepareStatement(sqlGetDetails);
            ps.setInt(1, importID);
            rs = ps.executeQuery();

            while (rs.next()) {
                ImportDetail d = new ImportDetail();
                d.setVariantID(rs.getInt("variantID"));
                d.setQuality(rs.getInt("quantity"));
                d.setCostPrice(rs.getDouble("costPrice"));
                d.setSellingPrice(rs.getDouble("CurrentSellingPrice")); // Lấy giá bán hiện tại

                listTemp.add(d);
            }
            rs.close();
            ps.close();

            // 2. CẬP NHẬT KHO (Batch Update)
            if (!listTemp.isEmpty()) {
                String sqlUpdateVariant = "UPDATE Variants SET Stock = Stock + ? WHERE VariantID = ?";
                psUpdate = conn.prepareStatement(sqlUpdateVariant);

                for (ImportDetail d : listTemp) {
                    psUpdate.setInt(1, d.getQuality()); 
                    psUpdate.setInt(2, d.getVariantID());
                    psUpdate.addBatch();
                }
                psUpdate.executeBatch();
                
                // 3. GHI LOG LỢI NHUẬN (Profits)
                insertProfits(conn, listTemp);
            }

            // 4. ĐỔI TRẠNG THÁI PHIẾU NHẬP -> 1 (Completed)
            String sqlUpdateStatus = "UPDATE Imports SET Status = 1 WHERE importID = ?";
            psStatus = conn.prepareStatement(sqlUpdateStatus);
            psStatus.setInt(1, importID);
            int rowEffected = psStatus.executeUpdate();

            conn.commit();
            return rowEffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {}
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
                if (psUpdate != null) psUpdate.close();
                if (psStatus != null) psStatus.close();
            } catch (Exception e) {}
        }
        return false;
    }

    private void insertProfits(Connection conn, List<ImportDetail> details) throws SQLException {
        
        
        String sql = "INSERT INTO Profits (VariantID, Quantity, SellingPrice, CalculatedDate) VALUES (?, ?, ?, GETDATE())";
        
        PreparedStatement ps = conn.prepareStatement(sql);

        for (ImportDetail d : details) {
            ps.setInt(1, d.getVariantID());
            ps.setInt(2, d.getQuality()); // Số lượng nhập vào (hoặc bán ra tùy logic bảng Profits của bạn)
            ps.setDouble(3, d.getSellingPrice());
            ps.addBatch();
        }

        ps.executeBatch();
        ps.close();
    }

    public boolean cancelImport(int importID) {
        Connection conn = this.conn;
        String sql = "UPDATE Imports SET Status = 2 WHERE importID = ? AND Status = 0";
        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, importID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
            } catch (Exception e) {}
        }
        return false;
    }
}