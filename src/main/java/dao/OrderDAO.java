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
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetails;
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

    // Map ResultSet data to Order object
    private Order mapResultSetToProduct(ResultSet rs) throws SQLException {
        int orderID = rs.getInt("OrderID");

        // Buyer information
        String name = rs.getString("FullName");
        String phone = rs.getString("Phone");
        Users buyer = new Users(name, phone);

        // Order details
        Timestamp orderDate = rs.getTimestamp("OrderDate");
        String address = rs.getString("ShippingAddress");
        BigDecimal total = rs.getBigDecimal("TotalAmount");
        String status = rs.getString("Status");

        // Create an Order object using constructor
        Order order = new Order(
                orderID,
                buyer,
                address,
                total.doubleValue(),
                status,
                orderDate.toLocalDateTime()
        );

        // Optional: handle ShipperID if setter is available
        return order;
    }

    // Get all orders
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

    // Get all orders for staff (including buyer and optional shipper info)
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

                // Shipper may be null if not yet assigned
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
                    Order o = new Order(rs.getInt("OrderID"), buyer, shipper, address, total.doubleValue(), orderDate.toLocalDateTime(), status);
                    orders.add(o);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    // Get list of orders assigned to a specific shipper
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

    // Delete order by ID (including related records)
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

    // Update order status
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

    // Get orders by shipper and status
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

    // Test main method
    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();
        List<Order> list = dao.getAllOrderForStaff();

        if (list.isEmpty()) {
            System.out.println("No orders found in the database!");
        } else {
            System.out.println("===== ORDER LIST (FOR STAFF) =====");
            for (Order o : list) {
                System.out.println("Order ID: " + o.getOrderID());

                if (o.getBuyer() != null) {
                    System.out.println("Buyer: " + o.getBuyer().getFullName()
                            + " | Phone: " + o.getBuyer().getPhone());
                } else {
                    System.out.println("Buyer: (null)");
                }

                if (o.getShippers() != null) {
                    System.out.println("Shipper: " + o.getShippers().getFullName()
                            + " | Phone: " + o.getShippers().getPhone());
                } else {
                    System.out.println("Shipper: (not assigned)");
                }

                System.out.println("Address: " + o.getShippingAddress());
                System.out.println("Total Amount: " + o.getTotalAmount());
                System.out.println("Order Date: " + o.getOrderDate());
                System.out.println("Status: " + o.getStatus());
                System.out.println("--------------------------------------------");
            }
        }
    }

    // Get all order details by OrderID
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
}
