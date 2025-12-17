package dao;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Vouchers;
import utils.DBContext;

public class VouchersDAO extends DBContext {

    //  CREATE (Tạo mới) 
    public int createVoucher(Vouchers v) {
        int generatedId = -1; // Giá trị mặc định nếu thất bại
        String sql = "INSERT INTO Vouchers (Code, PercentDiscount, StartDay, EndDay, Quantity, Status) VALUES (?, ?, ?, ?, ?, ?)";

        // Thêm Statement.RETURN_GENERATED_KEYS
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, v.getCode());
            ps.setInt(2, v.getPercentDiscount());
            ps.setDate(3, v.getStartDay());
            ps.setDate(4, v.getEndDay());
            ps.setInt(5, v.getQuantity());
            ps.setString(6, v.getStatus());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // Lấy key (ID) vừa được sinh ra
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1); // Lấy ID của voucher mới
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error at createVoucher: " + e.getMessage());
        }
        return generatedId; // Trả về ID (ví dụ: 101) hoặc -1 nếu lỗi
    }

    //  READ 
    public List<Vouchers> getAllVouchers() {
        List<Vouchers> list = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers";

        // Lấy ngày hiện tại để so sánh hạn sử dụng
        java.sql.Date today = java.sql.Date.valueOf(java.time.LocalDate.now());

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Vouchers v = new Vouchers(
                        rs.getInt("VoucherID"),
                        rs.getString("Code"),
                        rs.getInt("PercentDiscount"),
                        rs.getDate("StartDay"),
                        rs.getDate("EndDay"),
                        rs.getInt("Quantity"),
                        rs.getString("Status") // Trạng thái gốc trong DB (VD: Active)
                );

                //  LOGIC XỬ LÝ TRẠNG THÁI HIỂN THỊ 
                // 1. Nếu hạn sử dụng < ngày hiện tại -> Hết hạn (Expired)
                if (v.getEndDay().compareTo(today) < 0) {
                    v.setStatus("Expired");
                } // 2. Nếu số lượng = 0 và trạng thái đang Active -> Hết hàng (coi như Expired/SoldOut)
                else if (v.getQuantity() <= 0 && "Active".equalsIgnoreCase(v.getStatus())) {
                    v.setStatus("Expired");
                }

                list.add(v);
            }
        } catch (SQLException e) {
            System.out.println("Error at getAllVouchers: " + e.getMessage());
        }
        return list;
    }

    // 2. Lấy Voucher theo ID (Dùng khi bấm nút "Edit" để load thông tin cũ lên form)
    public Vouchers getVoucherByID(int id) {
        String sql = "SELECT * FROM Vouchers WHERE VoucherID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Vouchers(
                            rs.getInt("VoucherID"),
                            rs.getString("Code"),
                            rs.getInt("PercentDiscount"),
                            rs.getDate("StartDay"),
                            rs.getDate("EndDay"),
                            rs.getInt("Quantity"),
                            rs.getString("Status")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error at getVoucherByID: " + e.getMessage());
        }
        return null;
    }

    // 3. (Phụ trợ) Check xem Code đã tồn tại chưa khi tạo mới
    public boolean isCodeExist(String code) {
        String sql = "SELECT 1 FROM Vouchers WHERE Code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu đã có code này
            }
        } catch (SQLException e) {
            System.out.println("Error at isCodeExist: " + e.getMessage());
        }
        return false;
    }

    public void updateVoucher(Vouchers v) {
        String sql = "UPDATE Vouchers SET Code=?, PercentDiscount=?, StartDay=?, EndDay=?, Quantity=?, Status=? WHERE VoucherID=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setInt(2, v.getPercentDiscount());
            ps.setDate(3, v.getStartDay());
            ps.setDate(4, v.getEndDay());
            ps.setInt(5, v.getQuantity());
            ps.setString(6, v.getStatus());
            ps.setInt(7, v.getVoucherID()); // WHERE VoucherID = ?

            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error at updateVoucher: " + e.getMessage());
        }
    }

    public void deleteVoucher(int id) {
        // Thay đổi câu lệnh SQL thành DELETE
        String sql = "DELETE FROM Vouchers WHERE VoucherID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);

            // Thực thi lệnh xóa
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("Đã xóa thành công voucher ID: " + id);
            } else {
                System.out.println("Không tìm thấy voucher để xóa.");
            }

        } catch (SQLException e) {

            e.printStackTrace(); // Bật dòng này nếu muốn xem chi tiết lỗi
        }
    }

    public Vouchers getVoucherByCode(String code) {
        String sql = "SELECT * FROM Vouchers WHERE Code = ? AND Status = 'Active'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Vouchers(
                            rs.getInt("VoucherID"),
                            rs.getString("Code"),
                            rs.getInt("PercentDiscount"),
                            rs.getDate("StartDay"),
                            rs.getDate("EndDay"),
                            rs.getInt("Quantity"),
                            rs.getString("Status")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error at getVoucherByCode: " + e.getMessage());
        }
        return null; // Không tìm thấy hoặc voucher bị Inactive
    }

// Dùng khi khách ấn "Đặt hàng" thành công
    public void decreaseQuantity(String code) {
        String sql = "UPDATE Vouchers SET Quantity = Quantity - 1 WHERE Code = ? AND Quantity > 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Decreased quantity for voucher: " + code);
            } else {
                System.out.println("Voucher quantity is already 0 or code not found.");
            }
        } catch (SQLException e) {
            System.out.println("Error at decreaseQuantity: " + e.getMessage());
        }
    }

    // Trong file VouchersDAO.java
// Hàm kiểm tra trùng Mã (trả về true nếu đã tồn tại, false nếu chưa)
    public boolean checkVoucherCodeExist(String code) {
        String sql = "SELECT Code FROM Vouchers WHERE Code = ?";

        try {
            // Biến 'connection' được kế thừa từ DBContext
            PreparedStatement st = conn.prepareStatement(sql);

            st.setString(1, code);
            ResultSet rs = st.executeQuery();

            // Nếu rs.next() trả về true -> Có tìm thấy bản ghi -> Trùng mã
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi checkVoucherCodeExist: " + e.getMessage());
        }

        // Không tìm thấy hoặc có lỗi -> Trả về false (Cho phép tạo)
        return false;
    }

    public boolean saveVoucherForCustomer(int voucherID, int customerID) {
        // Kiểm tra xem đã lưu chưa để tránh trùng
        if (isVoucherSaved(voucherID, customerID)) {
            return false;
        }

        String sql = "INSERT INTO VoucherCustomers (VoucherID, CustomerID, AssignedDate, Status) VALUES (?, ?, GETDATE(), 'Active')";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherID);
            ps.setInt(2, customerID);

            int row = ps.executeUpdate();
            return row > 0;
        } catch (SQLException e) {
            System.out.println("Error at saveVoucherForCustomer: " + e.getMessage());
        }
        return false;
    }

    public boolean isVoucherSaved(int voucherID, int customerID) {
        String sql = "SELECT 1 FROM VoucherCustomers WHERE VoucherID = ? AND CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherID);
            ps.setInt(2, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Vouchers> getVouchersByCustomerID(int customerID) {
        List<Vouchers> list = new ArrayList<>();
        // Join bảng Vouchers gốc để lấy thông tin chi tiết và số lượng tồn kho (Quantity)
        String sql = "SELECT v.*, vc.Status as UserStatus, vc.AssignedDate "
                + "FROM VoucherCustomers vc "
                + "JOIN Vouchers v ON vc.VoucherID = v.VoucherID "
                + "WHERE vc.CustomerID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Vouchers v = new Vouchers(
                            rs.getInt("VoucherID"),
                            rs.getString("Code"),
                            rs.getInt("PercentDiscount"),
                            rs.getDate("StartDay"),
                            rs.getDate("EndDay"),
                            rs.getInt("Quantity"), // Số lượng chung toàn hệ thống
                            rs.getString("Status") // Status gốc của voucher
                    );

                    // --- LOGIC HIỂN THỊ TRẠNG THÁI CHO KHÁCH ---
                    String userStatus = rs.getString("UserStatus"); // Status trong bảng VoucherCustomers (Active/Used)
                    int globalQuantity = rs.getInt("Quantity");     // Số lượng còn lại thực tế

                    // Nếu khách chưa dùng (Active), NHƯNG số lượng tổng đã hết (0) -> Coi như Expired
                    if ("Active".equalsIgnoreCase(userStatus) && globalQuantity <= 0) {
                        // Gán tạm status là "SoldOut" hoặc "Expired" để hiển thị ra JSP
                        // (Không cần update vào DB, chỉ cần hiển thị cho khách biết là không dùng được nữa)
                        v.setStatus("SoldOut");
                    } else {
                        // Nếu còn hàng hoặc đã dùng rồi thì giữ nguyên status
                        v.setStatus(userStatus);
                    }

                    list.add(v);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error at getVouchersByCustomerID: " + e.getMessage());
        }
        return list;
    }

    public boolean useVoucher(int voucherID, int customerID) {
        // 1. Trừ số lượng tồn kho
        String sqlUpdateQuantity = "UPDATE Vouchers SET Quantity = Quantity - 1 WHERE VoucherID = ? AND Quantity > 0 ";

        // 2. Cập nhật trạng thái người dùng hiện tại thành 'Used'
        String sqlUpdateStatusUsed = "UPDATE VoucherCustomers SET Status = 'Used' WHERE VoucherID = ? AND CustomerID = ?";

        // 3. Kiểm tra số lượng còn lại
        String sqlCheckQuantity = "SELECT Quantity FROM Vouchers WHERE VoucherID = ?";

        // 4. Nếu hết hàng (Quantity = 0), cập nhật tất cả người khác thành 'Expired'
        String sqlExpireOthers = "UPDATE VoucherCustomers SET Status = 'Expired' WHERE VoucherID = ? AND Status = 'Active'";

        String sqlUpdateStatus = "UPDATE Vouchers SET Status = 'Expired' WHERE VoucherID = ? AND Quantity = 0 ";
        try {
            conn.setAutoCommit(false); // Bắt đầu Transaction

            //  BƯỚC 1: Trừ số lượng 
            try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdateQuantity)) {
                ps1.setInt(1, voucherID);
                int row1 = ps1.executeUpdate();

                if (row1 == 0) {
                    conn.rollback();
                    return false; // Hết voucher
                }
            }

            // BƯỚC 2: Set 'Used' cho người đang mua 
            try (PreparedStatement ps2 = conn.prepareStatement(sqlUpdateStatusUsed)) {
                ps2.setInt(1, voucherID);
                ps2.setInt(2, customerID);
                ps2.executeUpdate();
            }

            //  BƯỚC 3 & 4: Xử lý logic hết hàng cho người khác
            // Kiểm tra xem sau khi trừ, số lượng còn bao nhiêu?
            int currentQuantity = -1;
            try (PreparedStatement ps3 = conn.prepareStatement(sqlCheckQuantity)) {
                ps3.setInt(1, voucherID);
                try (ResultSet rs = ps3.executeQuery()) {
                    if (rs.next()) {
                        currentQuantity = rs.getInt("Quantity");
                    }
                }
            }

            // Nếu số lượng về 0 -> Voucher này đã hết sạch -> Hủy quyền của những người còn lại
            if (currentQuantity == 0) {
                try (PreparedStatement ps4 = conn.prepareStatement(sqlExpireOthers)) {
                    ps4.setInt(1, voucherID);
                    int rowsExpired = ps4.executeUpdate();
                    System.out.println("Đã chuyển " + rowsExpired + " người dùng khác sang trạng thái Expired vì hết voucher.");
                }
                try (PreparedStatement ps5 = conn.prepareStatement(sqlUpdateStatus)) {
                    ps5.setInt(1, voucherID);
                    ps5.executeUpdate();

                }

            }

            conn.commit(); // Thành công tất cả
            return true;

        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    /**
     * Lấy trạng thái voucher của khách hàng (null = chưa lưu, Active = chưa
     * dùng, Used = đã dùng)
     */
    public String getUserVoucherStatus(int voucherID, int customerID) {
        String sql = "SELECT Status FROM VoucherCustomers WHERE VoucherID = ? AND CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherID);
            ps.setInt(2, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Status"); // Trả về "Active" hoặc "Used"
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Chưa lưu
    }
    // 1. Lấy danh sách voucher để hiển thị trang chủ (Chỉ lấy cái Active và còn Hạn/Số lượng)

    public List<Vouchers> getAvailableVouchers() {
        List<Vouchers> list = new ArrayList<>();

        // SỬA CÂU SQL NÀY:
        // Dùng CAST(GETDATE() AS DATE) để lấy đúng ngày hôm nay mà không tính giờ
        String sql = "SELECT * FROM Vouchers "
                + "WHERE Status = 'Active' "
                + "AND Quantity > 0 "
                + "AND StartDay <= CAST(GETDATE() AS DATE) "
                + // Đã bắt đầu (quan trọng)
                "AND EndDay >= CAST(GETDATE() AS DATE)";     // Chưa kết thúc

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Vouchers(
                        rs.getInt("VoucherID"),
                        rs.getString("Code"),
                        rs.getInt("PercentDiscount"),
                        rs.getDate("StartDay"),
                        rs.getDate("EndDay"),
                        rs.getInt("Quantity"),
                        rs.getString("Status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

// 2. Lấy danh sách ID các voucher mà khách ĐÃ LƯU (để so sánh bên JSP)
    public List<Integer> getSavedVoucherIDsByCustomer(int customerID) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT VoucherID FROM VoucherCustomers WHERE CustomerID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("VoucherID"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}