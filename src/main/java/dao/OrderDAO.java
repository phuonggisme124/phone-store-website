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
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.Users;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class OrderDAO extends DBContext {

    //P viet
    private Order mapResultSetToProduct(ResultSet rs) throws SQLException {

        int OrderID = rs.getInt("OrderID");
        String name = rs.getString("FullName");
        String phone = rs.getString("Phone");
        Users u = new Users(name, phone);
        Timestamp orderDate = rs.getTimestamp("OrderDate");
        String address = rs.getString("ShippingAddress");
        BigDecimal total = rs.getBigDecimal("TotalAmount");
        String status = rs.getString("Status");

        return new Order(
                OrderID, u, address, total.floatValue(), status, orderDate.toLocalDateTime().toLocalDate()
        );
    }

    // --- Phương thức GetAllProducts --- P viet
    public List<Order> getAllOders() {
        List<Order> orders = new ArrayList<>();
        // Chọn tất cả các cột trong bảng Product
        String sql = "SELECT \n"
                + "    o.OrderID,\n"
                + "    buyer.FullName,\n"
                + "    buyer.Phone,\n"
                + "    o.OrderDate,\n"
                + "    o.ShippingAddress,\n"
                + "    o.TotalAmount,\n"
                + "    o.Status\n"
                + "FROM Orders o\n"
                + "JOIN Users buyer ON buyer.UserID = o.UserID\n"
                + "JOIN Sales s ON o.OrderID = s.OrderID       \n"
                + "JOIN Users shippers ON s.ShipperID = shippers.UserID      \n"
                + "WHERE shippers.Role = 3;    ";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                orders.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all products: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

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

    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();
        List<Order> list = dao.getAllOders();

        if (list.isEmpty()) {
            System.out.println("Không có đơn hàng nào trong cơ sở dữ liệu!");
        } else {
            System.out.println("===== DANH SÁCH ĐƠN HÀNG =====");
            for (Order o : list) {
                System.out.println("Mã đơn: " + o.getOrderID());
                System.out.println("Người mua: " + o.getBuyer());
                System.out.println("Địa chỉ giao: " + o.getShippingAddress());
                System.out.println("Ngày đặt: " + o.getOrderDate());
                System.out.println("Tổng tiền: " + o.getTotalAmount());
                System.out.println("Trạng thái: " + o.getStatus());
                System.out.println("-------------------------------");
            }
        }
    }
}
