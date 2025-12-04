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
    public boolean insertImportTransaction(Import imp, List<ImportDetail> details) {

        boolean isSuccess = false;
        String sqlProfit = "INSERT INTO [Profits] ([VariantID], [Quantity], [SellingPrice], [CostPrice], [CalculatedDate]) VALUES (?, ?, ?, ?, GETDATE())";
        try {

            conn.setAutoCommit(false); // 1. Bắt đầu Transaction

            // 2. Gọi hàm con thêm phiếu (trả về ID vừa tạo)
            int importID = insertHeader(conn, imp);

            // 3. Gọi hàm con thêm chi tiết (truyền ID vừa có vào)
            insertDetails(conn, importID, details);

            // 4. Gọi hàm con cập nhật kho
            updateStockAndPrice(conn, details);
            // 5 goi ham con chèn vào bảng profits
            insertProfits(conn, details);
            conn.commit();
            isSuccess = true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
            } // Lỗi -> Hủy
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
            }
        }
        return isSuccess;
    }

    // --- CÁC HÀM PRIVATE: Thực hiện SQL cụ thể ---
    // Hàm 1: Insert bảng Imports
    private int insertHeader(Connection conn, Import imp) throws SQLException {
        String sql = "INSERT INTO Imports (accountID, supplierID, totalCost, note) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, imp.getAccountID());
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

        // SQL rút gọn: Chỉ lấy thông tin phiếu + Tên nhà cung cấp
        String sql = "SELECT i.importID, i.totalCost, i.importDate, i.note, "
                + "       s.name AS SupplierName "
                + "FROM Imports i "
                + "JOIN Suppliers s ON i.supplierID = s.supplierID "
                + "ORDER BY i.importID DESC"; // Mới nhất lên đầu

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Import imp = new Import();
                imp.setImportID(rs.getInt("importID"));
                imp.setTotalCost(rs.getDouble("totalCost"));

                // Xử lý ngày tháng
                java.sql.Timestamp ts = rs.getTimestamp("importDate");
                if (ts != null) {
                    imp.setImportDate(ts.toLocalDateTime());
                }

                imp.setNote(rs.getString("note"));

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

    // Hàm này viết y chang cấu trúc insertDetails của bạn
    private void insertProfits(Connection conn, List<ImportDetail> details) throws SQLException {

        // Câu lệnh SQL chèn vào bảng Profits (có GETDATE() để lấy ngày hiện tại)
        String sql = "INSERT INTO Profits (VariantID, Quantity, SellingPrice, CostPrice, CalculatedDate) VALUES (?, ?, ?, ?, GETDATE())";

        // Tạo PreparedStatement từ Connection được truyền vào
        PreparedStatement ps = conn.prepareStatement(sql);
        for (ImportDetail d : details) {
            ps.setInt(1, d.getVariantID());
            ps.setInt(2, d.getQuality());
            ps.setDouble(3, d.getSellingPrice());
            ps.setDouble(4, d.getCostPrice());
            ps.addBatch();                        // Gom lệnh lại
        }

        // Thực thi một lần
        ps.executeBatch();
        ps.close();
    }
}
