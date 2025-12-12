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

            // 1. Insert phiếu nhập với Status = 0 (Chờ duyệt)
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

    // --- CÁC HÀM PRIVATE: Thực hiện SQL cụ thể ---
    // Hàm 1: Insert bảng Imports
    private int insertHeader(Connection conn, Import imp) throws SQLException {
        String sql = "INSERT INTO Imports (staffID, supplierID, totalCost, note) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, imp.getStaffID());
        ps.setInt(2, imp.getSupplierID());
        ps.setDouble(3, imp.getTotalCost());
        ps.setString(4, imp.getNote());

        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1); // Trả về ID vừa sinh ra
        }
        throw new SQLException("Không lấy được ID phiếu nhập");
    }

    // Hàm 2: Insert bảng ImportDetails
    private void insertDetails(Connection conn, int importID, List<ImportDetail> details) throws SQLException {
        String sql = "INSERT INTO ImportDetails (importID, variantID, quantity, costPrice) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        for (ImportDetail d : details) {
            ps.setInt(1, importID);
            ps.setInt(2, d.getVariantID());
            ps.setInt(3, d.getQuality());
            ps.setDouble(4, d.getCostPrice());
            ps.addBatch();
        }
        ps.executeBatch();
    }

    // Hàm 3: Update bảng Variants
    // Hàm này giờ làm 2 việc: Cộng tồn kho & Cập nhật giá bán mới
    // Hàm này thực hiện 2 nhiệm vụ cùng lúc:
// 1. Cộng số lượng tồn kho (Stock)
// 2. Lấy giá bán bạn vừa nhập (SellingPrice) đè vào cột DiscountPrice và Price
    private void updateStockAndPrice(Connection conn, List<ImportDetail> details) throws SQLException {

        // SQL: Cập nhật Stock cộng dồn, và SET luôn Price/DiscountPrice bằng giá mới
        String sql = "UPDATE Variants SET Stock = Stock + ?, Price = ?, DiscountPrice = ? WHERE VariantID = ?";

        PreparedStatement ps = conn.prepareStatement(sql);

        for (ImportDetail d : details) {
            ps.setInt(1, d.getQuality());         // 1. Cộng thêm số lượng nhập

            // 2. Cập nhật GIÁ GỐC = Giá bán mới (để tránh bị ảo giá)
            ps.setDouble(2, d.getSellingPrice());

            // 3. Cập nhật GIÁ BÁN HIỆN TẠI (DiscountPrice) = Giá bán mới
            // => Đây chính là bước "Tự cập nhật" mà bạn cần.
            ps.setDouble(3, d.getSellingPrice());

            ps.setInt(4, d.getVariantID());       // 4. Tìm đúng ID sản phẩm

            ps.addBatch();
        }

        ps.executeBatch();
        ps.close();
    }

    public List<Import> getAllImports() {
        List<Import> list = new ArrayList<>();

        // 1. CẬP NHẬT SQL: Thêm i.status vào câu Select
        String sql = "SELECT i.importID, u.FullName as staffName , i.totalCost, i.importDate, i.note, i.status, \n"
                + "  s.name AS SupplierName \n"
                + "\n"
                + "  FROM Imports i \n"
                + "               JOIN Suppliers s ON i.supplierID = s.supplierID \n"
                + "			   join Users u On i.staffID = u.UserID\n"
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

                // Set tên nhà cung cấp để hiển thị
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
                d.setQuality(rs.getInt("quantity")); // Hoặc setQuantity tùy tên hàm bạn đặt
                d.setCostPrice(rs.getDouble("costPrice"));

                // Lấy dữ liệu hiển thị (Vừa thêm ở Bước 2)
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

    private void insertProfits(Connection conn, List<ImportDetail> details) throws SQLException {
        // Sửa logic MERGE: Thêm điều kiện so sánh giá vào phần ON
        String sql = "MERGE INTO Profits AS target "
                + "USING (VALUES (?, ?, ?, ?)) AS source (VarID, AddQty, NewSellPrice, NewCostPrice) "
                + "ON target.VariantID = source.VarID "
                + "   AND MONTH(target.CalculatedDate) = MONTH(GETDATE()) "
                + "   AND YEAR(target.CalculatedDate) = YEAR(GETDATE()) "
                // --- THÊM 2 DÒNG NÀY ---
                + "   AND target.CostPrice = source.NewCostPrice " // So sánh giá vốn
                + "   AND target.SellingPrice = source.NewSellPrice " // So sánh giá bán (nếu cần thiết)
                // ------------------------

                // Nếu khớp tất cả (bao gồm cả giá) -> Chỉ cộng dồn số lượng
                + "WHEN MATCHED THEN "
                + "   UPDATE SET "
                + "       target.Quantity = target.Quantity + source.AddQty, "
                + "       target.CalculatedDate = GETDATE() "
                // Lưu ý: Không cần update lại SellingPrice/CostPrice ở đây nữa vì nó đã giống nhau ở điều kiện ON rồi

                // Nếu không khớp (do khác giá hoặc chưa có trong tháng) -> Tạo dòng mới
                + "WHEN NOT MATCHED THEN "
                + "   INSERT (VariantID, Quantity, SellingPrice, CostPrice, CalculatedDate) "
                + "   VALUES (source.VarID, source.AddQty, source.NewSellPrice, source.NewCostPrice, GETDATE());";

        PreparedStatement ps = conn.prepareStatement(sql);

        for (ImportDetail d : details) {
            // Tham số 1: VariantID
            ps.setInt(1, d.getVariantID());

            // Tham số 2: Số lượng
            ps.setInt(2, d.getQuality());

            // Tham số 3: Giá bán
            ps.setDouble(3, d.getSellingPrice());

            // Tham số 4: Giá vốn
            ps.setDouble(4, d.getCostPrice());

            ps.addBatch();
        }

        ps.executeBatch();
        ps.close();
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

            // ĐỌC DỮ LIỆU VÀO LIST
            // Sửa lại câu lệnh SQL ở Bước 1
            String sqlGetDetails = "SELECT d.variantID, d.quantity, d.costPrice, v.Price SellingPrice "
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
                d.setSellingPrice(rs.getDouble("SellingPrice"));

                listTemp.add(d);
            }
            // Đóng ngay ResultSet và PreparedStatement đọc để giải phóng kết nối
            rs.close();
            ps.close();

            // -CẬP NHẬT KHO VÀ GIÁ (Batch Update)
            if (!listTemp.isEmpty()) {
                // Chỉ cộng Stock, không sửa giá bán (Price) vì phiếu nhập không có giá bán mới
                String sqlUpdateVariant = "UPDATE Variants SET stock = stock + ? WHERE variantID = ?";
                psUpdate = conn.prepareStatement(sqlUpdateVariant);

                for (ImportDetail d : listTemp) {
                    psUpdate.setInt(1, d.getQuality()); // Chỉ cộng số lượng
                    psUpdate.setInt(2, d.getVariantID());
                    psUpdate.addBatch();
                }
// Chạy update kho
                psUpdate.executeBatch();

// Sau đó mới chạy insertProfits
                insertProfits(conn, listTemp);
            }

            //  ĐỔI TRẠNG THÁI PHIẾU NHẬP 
            String sqlUpdateStatus = "UPDATE Imports SET Status = 1 WHERE importID = ?";
            psStatus = conn.prepareStatement(sqlUpdateStatus);
            psStatus.setInt(1, importID);
            int rowEffected = psStatus.executeUpdate();

            conn.commit();

            // Trả về true nếu update status thành công
            return rowEffected > 0;

        } catch (Exception e) {
            e.printStackTrace(); // Nhớ xem log này trong Console của NetBeans/Server
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
            }
        } finally {
            // Đóng sạch sẽ các resource
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (psUpdate != null) {
                    psUpdate.close();
                }
                if (psStatus != null) {
                    psStatus.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true); // Trả lại trạng thái cũ cho connection dùng chung
                }
            } catch (Exception e) {
            }
        }
        return false;
    }

    // Hàm hủy phiếu nhập (Dành cho Admin từ chối hoặc Staff hủy đơn chưa duyệt)
    public boolean cancelImport(int importID) {
        Connection conn = this.conn;
        String sql = "UPDATE Imports SET Status = 2 WHERE importID = ? AND Status = 0";
        // Giải thích SQL:
        // Status = 2: Set thành trạng thái "Đã hủy"
        // AND Status = 0: Điều kiện an toàn, chỉ cho hủy đơn đang "Chờ duyệt". 
        // Nếu đơn đã duyệt (1) thì lệnh này sẽ không chạy (an toàn cho kho).

        PreparedStatement ps = null;

        try {
            ps = conn.prepareStatement(sql);

            ps.setInt(1, importID);

            int rowsAffected = ps.executeUpdate();

            // Nếu update thành công ít nhất 1 dòng -> Trả về True
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Đóng kết nối để tránh tràn bộ nhớ
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
