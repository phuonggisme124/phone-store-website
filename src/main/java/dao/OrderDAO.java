/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetails;
import model.Products;
import model.Users;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class OrderDAO extends DBContext {

    public OrderDAO() {
        super();
    }
    
    

    // Ánh xạ dữ liệu từ ResultSet sang đối tượng Order
    private Order mapResultSetToProduct(ResultSet rs) throws SQLException {
        int orderID = rs.getInt("OrderID");

        // Người mua
        String name = rs.getString("FullName");
        String phone = rs.getString("Phone");
        Users buyer = new Users(name, phone);

        // Thông tin đơn hàng
        Timestamp orderDate = rs.getTimestamp("OrderDate");
        String address = rs.getString("ShippingAddress");
        BigDecimal total = rs.getBigDecimal("TotalAmount");
        String status = rs.getString("Status");

        // ✅ Tạo Order theo constructor hiện tại
        Order order = new Order(
                orderID,
                buyer,
                address,
                total.doubleValue(),
                status,
                orderDate.toLocalDateTime()
        );

        // ✅ Nếu muốn vẫn lưu ShipperID tạm thì có thể set bằng 1 phương thức khác (nếu bạn thêm sau này)
        // int shipperID = rs.getInt("ShipperID");
        // order.setShipperID(shipperID); // chỉ dùng nếu bạn thêm setter sau này
        return order;
    }
    
    public List<Order> getAllOrders(){
        String sql = "Select * from Orders";
        List<Order> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int oid = rs.getInt("OrderID");
                int uid = rs.getInt("UserID");
                Timestamp orderDateTimestamp = rs.getTimestamp("OrderDate");
                LocalDateTime orderDate = (orderDateTimestamp != null)
                        ? orderDateTimestamp.toLocalDateTime()
                        : null;
                String status = rs.getString("Status");
                String paymentMethod = rs.getString("PaymentMethod");
                String address = rs.getString("ShippingAddress");
                double totalAmount = rs.getDouble("TotalAmount");               
                boolean isInstalment = rs.getBoolean("IsInstalment");
                list.add(new Order(oid, uid, paymentMethod, address, totalAmount, status, orderDate, isInstalment));
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }
    
    // Lấy tất cả đơn hàng
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT "
                + "o.OrderID, "
                + "buyer.FullName, "
                + "buyer.Phone, "
                + "o.OrderDate, "
                + "o.ShippingAddress, "
                + "o.TotalAmount, "
                + "o.Status, "
                + "s.ShipperID "
                + "FROM Orders o "
                + "JOIN Users buyer ON buyer.UserID = o.UserID "
                + "JOIN Sales s ON o.OrderID = s.OrderID";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                orders.add(mapResultSetToProduct(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    //của thịnh
    // Lấy danh sách đơn hàng theo Shipper ID
    public List<Order> getAllOrderForStaff() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT \n"
                + "    o.OrderID,\n"
                + "    buyers.FullName, \n"
                + "    buyers.Phone, \n"
                + "    buyers.Address, \n"
                + "    o.TotalAmount, \n"
                + "    o.OrderDate, \n"
                + "    o.Status,\n"
                + "    shippers.UserID AS [ShipperID],\n"
                + "    shippers.FullName AS [ShipperName],\n"
                + "    shippers.Phone AS [ShipperPhone]\n"
                + "FROM Orders o\n"
                + "JOIN Users buyers ON o.UserID = buyers.UserID\n"
                + "LEFT JOIN Sales s ON o.OrderID = s.OrderID\n"
                + "LEFT JOIN Users shippers ON s.ShipperID = shippers.UserID;";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Users buyer = null;
                String buyerName = rs.getString("FullName");
                if (buyerName != null) {
                    buyer = new Users();
                    buyer.setFullName(buyerName);
                    buyer.setPhone(rs.getString("Phone"));
                    buyer.setAddress(rs.getString("Address"));

                }
                //Không cần kiểm tra null vì shipper có thể null do đơn hàng chưa gán đc ai giao
                Users shipper = null;
                int shipperID = rs.getInt("ShipperID");
                shipper = new Users();
                shipper.setUserId(shipperID);
                shipper.setFullName(rs.getString("ShipperName"));
                shipper.setPhone(rs.getString("ShipperPhone"));

                int orderID = rs.getInt("OrderID");
                if (orderID > 0) {
                    String address = rs.getString("Address");
                    BigDecimal total = rs.getBigDecimal("TotalAmount");
                    Timestamp orderDate = rs.getTimestamp("OrderDate");
                    String status = rs.getString("Status");
                    Order o = new Order(rs.getInt("OrderID"), buyer, shipper, address, total.doubleValue(), orderDate.toLocalDateTime().toLocalDate(), status);
                    orders.add(o);
                }

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

//hết của thịnh
    // Lấy danh sách đơn hàng theo Shipper ID
    public List<Order> getOrdersByShipperId(int shipperId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT "
                + "o.OrderID, buyer.FullName, buyer.Phone, "
                + "o.OrderDate, o.ShippingAddress, o.TotalAmount, o.Status "
                + "FROM Orders o "
                + "JOIN Users buyer ON buyer.UserID = o.UserID "
                + "JOIN Sales s ON o.OrderID = s.OrderID "
                + "JOIN Users shippers ON s.ShipperID = shippers.UserID "
                + "WHERE shippers.Role = 3 AND s.ShipperID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shipperId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToProduct(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    // Xóa đơn hàng theo ID
    public void deleteOrderByID(int id) {
        String sql1 = "DELETE FROM Payments WHERE OrderID = ?";
        String sql2 = "DELETE FROM Sales WHERE OrderID = ?";
        String sql3 = "DELETE FROM OrderDetails WHERE OrderID = ?";
        String sql4 = "DELETE FROM Orders WHERE OrderID = ?";

        try (PreparedStatement stmt1 = conn.prepareStatement(sql1); PreparedStatement stmt2 = conn.prepareStatement(sql2); PreparedStatement stmt3 = conn.prepareStatement(sql3); PreparedStatement stmt4 = conn.prepareStatement(sql4)) {

            stmt1.setInt(1, id);
            stmt1.executeUpdate();

            stmt2.setInt(1, id);
            stmt2.executeUpdate();

            stmt3.setInt(1, id);
            stmt3.executeUpdate();

            stmt4.setInt(1, id);
            stmt4.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Cập nhật trạng thái đơn hàng
    public void updateOrderStatus(int id, String status) {
        String sql = "UPDATE Orders SET Status = ? WHERE OrderID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Order> getOrdersByShipperIdAndStatus(int shipperId, String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT "
                + "o.OrderID, buyer.FullName, buyer.Phone, "
                + "o.OrderDate, o.ShippingAddress, o.TotalAmount, o.Status "
                + "FROM Orders o "
                + "JOIN Users buyer ON buyer.UserID = o.UserID "
                + "JOIN Sales s ON o.OrderID = s.OrderID "
                + "JOIN Users shippers ON s.ShipperID = shippers.UserID "
                + "WHERE shippers.Role = 3 AND s.ShipperID = ? AND o.Status = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shipperId);
            stmt.setString(2, status);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToProduct(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    // Kiểm tra nhanh
    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();
        List<Order> list = dao.getAllOrderForStaff();

        if (list.isEmpty()) {
            System.out.println("❌ Không có đơn hàng nào trong cơ sở dữ liệu!");
        } else {
            System.out.println("===== 📦 DANH SÁCH ĐƠN HÀNG (CHO STAFF) =====");
            for (Order o : list) {
                System.out.println("🆔 Mã đơn: " + o.getOrderID());

                if (o.getBuyer() != null) {
                    System.out.println("👤 Người mua: " + o.getBuyer().getFullName()
                            + " | SĐT: " + o.getBuyer().getPhone());
                } else {
                    System.out.println("👤 Người mua: (null)");
                }

                if (o.getShippers() != null) {
                    System.out.println("🚚 Shipper: " + o.getShippers().getFullName()
                            + " | SĐT: " + o.getShippers().getPhone());
                } else {
                    System.out.println("🚚 Shipper: (chưa gán)");
                }

                System.out.println("🏠 Địa chỉ: " + o.getShippingAddress());
                System.out.println("💰 Tổng tiền: " + o.getTotalAmount());
                System.out.println("📅 Ngày đặt: " + o.getOrderDate());
                System.out.println("📦 Trạng thái: " + o.getStatus());
                System.out.println("--------------------------------------------");
            }
        }
    }

<<<<<<< Updated upstream
    public List<OrderDetails> getAllOrderDetailByOrderID(int oid) {
        String sql = "Select * from OrderDetails where OrderID = ?";
        List<OrderDetails> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, oid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int orderID = rs.getInt("OrderID");
                int variantID = rs.getInt("VariantID");
                int quantity = rs.getInt("Quantity");
                double price = rs.getDouble("UnitPrice");
                
                int instalmentPeriod = rs.getInt("InstalmentPeriod");
                double monthlyPayment = rs.getDouble("MonthlyPayment");
                double downPayment = rs.getDouble("DownPayment");
                int interestRate = rs.getInt("InterestRate");
                              
             
                list.add(new OrderDetails(orderID, variantID, quantity, price, instalmentPeriod, monthlyPayment, downPayment, interestRate));
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }
=======
>>>>>>> Stashed changes
}
