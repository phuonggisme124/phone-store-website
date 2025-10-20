package dao;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
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

    /**
     * Maps ResultSet data to an Order object.
     * Note: This mapper is primarily used by simpler queries (like getAllOrders or getOrdersByShipperId)
     * which only fetch buyer name, phone, and order details, but not shipper details.
     * * @param rs The ResultSet containing order data.
     * @return A partially populated Order object.
     * @throws SQLException 
     */
    private Order mapResultSetToProduct(ResultSet rs) throws SQLException {
        int orderID = rs.getInt("OrderID");

        // Buyer information
        String name = rs.getString("FullName");
        String phone = rs.getString("Phone");
        // Shipping address is usually pulled from the Order table itself, not the Users table
        // But in some queries it might come from the Order table (aliased as 'o')
        // We'll rely on the specific query to provide 'ShippingAddress'
        String address = rs.getString("ShippingAddress"); 
        Users buyer = new Users(name, phone);

        // Order details
        Timestamp orderDate = rs.getTimestamp("OrderDate");
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

        // No shipper data is included in this map, as the SQL for this map 
        // usually doesn't select it, or the Order model constructor doesn't take it.
        return order;
    }

    // Get all orders (simple list for general overview)
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        // NOTE: The JOIN Sales s ON o.OrderID = s.OrderID here will only return 
        // orders that have an entry in the Sales table. Use LEFT JOIN for all orders.
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
                + "LEFT JOIN Sales s ON o.OrderID = s.OrderID"; // Changed to LEFT JOIN for completeness

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                orders.add(mapResultSetToProduct(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching all orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Get all orders for a specific staff member, including buyer and optional shipper info.
     * Orders are included if the staff member is assigned (s.StaffID = ?) or if 
     * the order hasn't been assigned to any staff (s.StaffID IS NULL), which is common 
     * for newly created orders.
     * * @param staffID The ID of the staff member (likely from the Sales table's StaffID)
     * @return List of Order objects with buyer and shipper details
     */
    public List<Order> getAllOrderForStaff(int staffID) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT "
                + "    o.OrderID, "
                + "    o.ShippingAddress, "
                + "    o.TotalAmount, "
                + "    o.OrderDate, "
                + "    o.Status, "
                + "    buyers.FullName, "
                + "    buyers.Phone, "
                + "    buyers.Address, "
                + "    shippers.UserID AS [ShipperID], "
                + "    shippers.FullName AS [ShipperName], "
                + "    shippers.Phone AS [ShipperPhone] "
                + "FROM Orders o "
                + "JOIN Users buyers ON o.UserID = buyers.UserID "
                + "LEFT JOIN Sales s ON o.OrderID = s.OrderID "
                + "LEFT JOIN Users shippers ON s.ShipperID = shippers.UserID "
                + "WHERE (s.StaffID = ? OR s.StaffID IS NULL)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                // Người mua
                Users buyer = new Users();
                buyer.setFullName(rs.getString("FullName"));
                buyer.setPhone(rs.getString("Phone"));
                buyer.setAddress(rs.getString("Address"));

                // Shipper (có thể null)
                Users shipper = null;
                int shipperID = rs.getInt("ShipperID");
                if (shipperID != 0) {
                    shipper = new Users();
                    shipper.setUserId(shipperID);
                    shipper.setFullName(rs.getString("ShipperName"));
                    shipper.setPhone(rs.getString("ShipperPhone"));
                }

                // Thông tin đơn hàng
                int orderID = rs.getInt("OrderID");
                // Use o.ShippingAddress, which is more reliable for the order
                String shippingAddress = rs.getString("ShippingAddress"); 
                BigDecimal total = rs.getBigDecimal("TotalAmount");
                Timestamp orderDateTs = rs.getTimestamp("OrderDate");
                String status = rs.getString("Status");
                
                // Convert to LocalDateTime
                LocalDateTime orderDate = orderDateTs != null ? orderDateTs.toLocalDateTime() : null;

                Order o = new Order(orderID, buyer, shipper,
                        shippingAddress,
                        total.doubleValue(),
                        orderDate,
                        status);

                orders.add(o);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    //--------------------------------------------

    /**
     * Get list of orders assigned to a specific staff member.
     * Note: This version's SQL specifically targets orders where the staff is assigned
     * AND the staff's Role is 2 (assuming 2 is the role for staff/sales).
     * * @param staffId ID of the staff member
     * @return List of Order objects
     */
    public List<Order> getOrdersByStaffID(int staffId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT "
                + "o.OrderID, buyer.FullName, buyer.Phone, "
                + "o.OrderDate, o.ShippingAddress, o.TotalAmount, o.Status "
                + "FROM Orders o "
                + "JOIN Users buyer ON buyer.UserID = o.UserID "
                + "JOIN Sales s ON o.OrderID = s.OrderID "
                + "JOIN Users staff ON s.StaffID = staff.UserID "
                + "WHERE staff.Role = 2 AND s.StaffID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToProduct(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    //--------------------------------------------

    /**
     * Get list of orders by status for a specific staff member.
     * Includes orders that belong to the staff or are unassigned, and match the status.
     * * @param staffID ID of the staff member
     * @param status The status to filter by
     * @return List of Order objects
     */
    public List<Order> getOrdersByStatusForStaff(int staffID, String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "    SELECT \n"
                + "            o.OrderID,\n"
                + "            o.TotalAmount,\n"
                + "            o.OrderDate,\n"
                + "            o.Status,\n"
                + "            o.ShippingAddress AS BuyerAddress, \n" // Using ShippingAddress from Order
                + "            u.FullName AS BuyerName,\n"
                + "            u.Phone AS BuyerPhone,\n"
                + "            s.ShipperID,\n"
                + "            ship.FullName AS ShipperName,\n"
                + "            ship.Phone AS ShipperPhone\n"
                + "        FROM Orders o\n"
                + "        JOIN Users u ON o.UserID = u.UserID\n"
                + "        LEFT JOIN Sales s ON o.OrderID = s.OrderID\n"
                + "        LEFT JOIN Users ship ON s.ShipperID = ship.UserID\n"
                + "        WHERE (s.StaffID = ? OR s.StaffID IS NULL)\n"
                + "          AND o.Status = ?\n"
                + "        ORDER BY o.OrderDate DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffID);
            stmt.setString(2, status);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                // Người mua
                Users buyer = new Users();
                buyer.setFullName(rs.getString("BuyerName"));
                buyer.setPhone(rs.getString("BuyerPhone"));
                buyer.setAddress(rs.getString("BuyerAddress")); // This should ideally be ShippingAddress

                // Shipper (có thể null)
                Users shipper = null;
                int shipperID = rs.getInt("ShipperID");
                if (shipperID != 0) {
                    shipper = new Users();
                    shipper.setUserId(shipperID);
                    shipper.setFullName(rs.getString("ShipperName"));
                    shipper.setPhone(rs.getString("ShipperPhone"));
                }

                // Thông tin đơn hàng
                int orderID = rs.getInt("OrderID");
                BigDecimal total = rs.getBigDecimal("TotalAmount");
                Timestamp ts = rs.getTimestamp("OrderDate");
                LocalDateTime orderDate = (ts != null) ? ts.toLocalDateTime() : null;
                String orderStatus = rs.getString("Status");

                Order o = new Order(
                        orderID,
                        buyer,
                        shipper,
                        buyer.getAddress(), // Assuming BuyerAddress is the shipping address
                        total != null ? total.doubleValue() : 0,
                        orderDate,
                        orderStatus
                );

                orders.add(o);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    //--------------------------------------------

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

    //--------------------------------------------

    // Delete order by ID (including related records)
    public void deleteOrderByID(int id) {
        String sql1 = "DELETE FROM Payments WHERE OrderID = ?";
        String sql2 = "DELETE FROM Sales WHERE OrderID = ?";
        String sql3 = "DELETE FROM OrderDetails WHERE OrderID = ?";
        String sql4 = "DELETE FROM Orders WHERE OrderID = ?";

        try (PreparedStatement stmt1 = conn.prepareStatement(sql1); 
             PreparedStatement stmt2 = conn.prepareStatement(sql2); 
             PreparedStatement stmt3 = conn.prepareStatement(sql3); 
             PreparedStatement stmt4 = conn.prepareStatement(sql4)) {

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

    //--------------------------------------------

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

    //--------------------------------------------

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


  
    // Add new order when payment successfully
// Add new order when payment successfully - UPDATED TO RETURN OrderID

    public int addNewOrder(Order o) {
        String sql = "INSERT INTO Orders (UserID, Status, PaymentMethod, ShippingAddress, TotalAmount, IsInstalment, ReceiverName, ReceiverPhone) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            // THAY ĐỔI: Thêm Statement.RETURN_GENERATED_KEYS
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, o.getUserID());
            ps.setString(2, o.getStatus());
            ps.setString(3, o.getPaymentMethod());
            ps.setString(4, o.getShippingAddress());
            ps.setDouble(5, o.getTotalAmount());
            ps.setByte(6, o.isIsInstallment());
            ps.setString(7, o.getBuyer().getFullName());
            ps.setString(8, o.getBuyer().getPhone());
            ps.executeUpdate();

            // LẤY OrderID vừa được tự động sinh
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int generatedOrderID = rs.getInt(1);
                return generatedOrderID;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu có lỗi
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


    //--------------------------------------------

    /**
     * Get all orders for a customer phone number, regardless of Staff or Shipper.
     * * @param phone Customer phone number (supports partial match with LIKE '%...%').
     * @return List of Order objects.
     */
    public List<Order> getOrdersByPhone(String phone) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.UserID, buyer.FullName AS BuyerName, buyer.Phone AS BuyerPhone, "
                + "o.ShippingAddress AS BuyerAddress, o.TotalAmount, o.PaymentMethod, o.Status, o.OrderDate, "
                + "shippers.UserID AS ShipperID, shippers.FullName AS ShipperName, shippers.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "JOIN Users buyer ON o.UserID = buyer.UserID "
                + "LEFT JOIN Sales s ON o.OrderID = s.OrderID "
                + "LEFT JOIN Users shippers ON s.ShipperID = shippers.UserID "
                + "WHERE buyer.Phone LIKE ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + phone + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Người mua
                    Users buyer = new Users();
                    buyer.setFullName(rs.getString("BuyerName"));
                    buyer.setPhone(rs.getString("BuyerPhone"));
                    buyer.setAddress(rs.getString("BuyerAddress")); // This is the ShippingAddress

                    // Shipper (có thể null)
                    Users shipper = null;
                    int shipperID = rs.getInt("ShipperID");
                    if (shipperID != 0) {
                        shipper = new Users();
                        shipper.setUserId(shipperID);
                        shipper.setFullName(rs.getString("ShipperName"));
                        shipper.setPhone(rs.getString("ShipperPhone"));
                    }

                    // Thông tin order
                    int orderID = rs.getInt("OrderID");
                    double total = rs.getBigDecimal("TotalAmount").doubleValue();
                    Timestamp orderDateTs = rs.getTimestamp("OrderDate");
                    LocalDateTime orderDate = orderDateTs != null ? orderDateTs.toLocalDateTime() : null;
                    String status = rs.getString("Status");
                    String paymentMethod = rs.getString("PaymentMethod");

                    Order o = new Order(orderID, buyer, shipper,
                            buyer.getAddress(), total, orderDate, status);
                    o.setPaymentMethod(paymentMethod);

                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    //--------------------------------------------
    
    /**
     * Get orders for a customer phone number filtered by status.
     * * @param phone Customer phone number (supports partial match with LIKE '%...%').
     * @param status The status to filter by.
     * @return List of Order objects.
     */
 public List<Order> getOrdersByPhoneAndStatus(String phone, String status) {
    List<Order> list = new ArrayList<>();
    String sql = "SELECT o.OrderID, o.UserID, buyer.FullName AS BuyerName, buyer.Phone AS BuyerPhone, "
            + "o.ShippingAddress AS BuyerAddress, o.TotalAmount, o.PaymentMethod, o.Status, o.OrderDate, "
            + "shippers.UserID AS ShipperID, shippers.FullName AS ShipperName, shippers.Phone AS ShipperPhone "
            + "FROM Orders o "
            + "JOIN Users buyer ON o.UserID = buyer.UserID "
            + "LEFT JOIN Sales s ON o.OrderID = s.OrderID "
            + "LEFT JOIN Users shippers ON s.ShipperID = shippers.UserID "
            + "WHERE buyer.Phone LIKE ? AND o.Status = ?";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, "%" + phone + "%");
        ps.setString(2, status);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // Người mua
                Users buyer = new Users();
                buyer.setFullName(rs.getString("BuyerName"));
                buyer.setPhone(rs.getString("BuyerPhone"));
                buyer.setAddress(rs.getString("BuyerAddress"));

                // Shipper (có thể null)
                Users shipper = null;
                int shipperID = rs.getInt("ShipperID");
                if (shipperID != 0) {
                    shipper = new Users();
                    shipper.setUserId(shipperID);
                    shipper.setFullName(rs.getString("ShipperName"));
                    shipper.setPhone(rs.getString("ShipperPhone"));
                }

                // Order
                int orderID = rs.getInt("OrderID");
                double total = rs.getBigDecimal("TotalAmount").doubleValue();
                Timestamp orderDateTs = rs.getTimestamp("OrderDate");
                LocalDateTime orderDate = orderDateTs != null ? orderDateTs.toLocalDateTime() : null;
                String orderStatus = rs.getString("Status");
                String paymentMethod = rs.getString("PaymentMethod");

                Order o = new Order(orderID, buyer, shipper,
                        buyer.getAddress(), total, orderDate, orderStatus);
                o.setPaymentMethod(paymentMethod);

                list.add(o);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;

}

    //--------------------------------------------

    // Test main method
    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();
        // Use a placeholder staff ID for testing (e.g., 1)
        List<Order> list = dao.getAllOrderForStaff(1); 

        if (list.isEmpty()) {
            System.out.println("No orders found for staff ID 1 or unassigned orders in the database!");
        } else {
            System.out.println("===== ORDER LIST (FOR STAFF ID 1) =====");
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
}