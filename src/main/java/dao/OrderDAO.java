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
import model.Payments;
import model.Users;
import model.Variants;
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
     * Maps ResultSet data to an Order object. Note: This mapper is primarily
     * used by simpler queries (like getAllOrders or getOrdersByShipperId) which
     * only fetch buyer name, phone, and order details, but not shipper details.
     *
     * * @param rs The ResultSet containing order data.
     * @return A partially populated Order object.
     * @throws SQLException
     */
    private Order mapResultSetToProduct(ResultSet rs) throws SQLException {
        int orderID = rs.getInt("OrderID");

        // Buyer information
        String name = rs.getString("FullName");
        String phone = rs.getString("Phone");
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

        return order;
    }

    // Get all orders (simple list for general overview)
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
                + "LEFT JOIN Sales s ON o.OrderID = s.OrderID";

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
     * Get all orders for a specific staff member, including buyer and optional
     * shipper info.
     *
     * @param staffID The ID of the staff member.
     * @return List of Order objects with buyer and shipper details
     */
    public List<Order> getAllOrderForStaff(int staffID) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT "
                + "o.OrderID, o.ShippingAddress, o.TotalAmount, o.OrderDate, o.Status, "
                + "buyers.FullName, buyers.Phone, buyers.Address, "
                + "shippers.UserID AS [ShipperID], shippers.FullName AS [ShipperName], shippers.Phone AS [ShipperPhone] "
                + "FROM Orders o "
                + "JOIN Users buyers ON o.UserID = buyers.UserID "
                + "LEFT JOIN Sales s ON o.OrderID = s.OrderID "
                + "LEFT JOIN Users shippers ON s.ShipperID = shippers.UserID "
                + "WHERE (s.StaffID = ? OR s.StaffID IS NULL)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Users buyer = new Users();
                buyer.setFullName(rs.getString("FullName"));
                buyer.setPhone(rs.getString("Phone"));
                buyer.setAddress(rs.getString("Address"));

                Users shipper = null;
                int shipperID = rs.getInt("ShipperID");
                if (shipperID != 0) {
                    shipper = new Users();
                    shipper.setUserId(shipperID);
                    shipper.setFullName(rs.getString("ShipperName"));
                    shipper.setPhone(rs.getString("ShipperPhone"));
                }

                int orderID = rs.getInt("OrderID");
                String shippingAddress = rs.getString("ShippingAddress");
                BigDecimal total = rs.getBigDecimal("TotalAmount");
                Timestamp orderDateTs = rs.getTimestamp("OrderDate");
                String status = rs.getString("Status");
                LocalDateTime orderDate = orderDateTs != null ? orderDateTs.toLocalDateTime() : null;

                Order o = new Order(orderID, buyer, shipper, shippingAddress, total.doubleValue(), orderDate, status);
                orders.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Get list of orders assigned to a specific staff member.
     *
     * @param staffId ID of the staff member
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

    /**
     * Get list of orders by status for a specific staff member.
     *
     * @param staffID ID of the staff member
     * @param status The status to filter by
     * @return List of Order objects
     */
    public List<Order> getOrdersByStatusForStaff(int staffID, String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.TotalAmount, o.OrderDate, o.Status, "
                + "o.ShippingAddress AS BuyerAddress, u.FullName AS BuyerName, u.Phone AS BuyerPhone, "
                + "s.ShipperID, ship.FullName AS ShipperName, ship.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "JOIN Users u ON o.UserID = u.UserID "
                + "LEFT JOIN Sales s ON o.OrderID = s.OrderID "
                + "LEFT JOIN Users ship ON s.ShipperID = ship.UserID "
                + "WHERE (s.StaffID = ? OR s.StaffID IS NULL) AND o.Status = ? "
                + "ORDER BY o.OrderDate DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffID);
            stmt.setString(2, status);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Users buyer = new Users();
                buyer.setFullName(rs.getString("BuyerName"));
                buyer.setPhone(rs.getString("BuyerPhone"));
                buyer.setAddress(rs.getString("BuyerAddress"));

                Users shipper = null;
                int shipperID = rs.getInt("ShipperID");
                if (shipperID != 0) {
                    shipper = new Users();
                    shipper.setUserId(shipperID);
                    shipper.setFullName(rs.getString("ShipperName"));
                    shipper.setPhone(rs.getString("ShipperPhone"));
                }

                int orderID = rs.getInt("OrderID");
                BigDecimal total = rs.getBigDecimal("TotalAmount");
                Timestamp ts = rs.getTimestamp("OrderDate");
                LocalDateTime orderDate = (ts != null) ? ts.toLocalDateTime() : null;
                String orderStatus = rs.getString("Status");

                Order o = new Order(orderID, buyer, shipper, buyer.getAddress(), total != null ? total.doubleValue() : 0, orderDate, orderStatus);
                orders.add(o);
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
        String[] deleteStatements = {
            "DELETE FROM Payments WHERE OrderID = ?",
            "DELETE FROM Sales WHERE OrderID = ?",
            "DELETE FROM OrderDetails WHERE OrderID = ?",
            "DELETE FROM Orders WHERE OrderID = ?"
        };
        try {
            conn.setAutoCommit(false);
            for (String sql : deleteStatements) {
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
            }
            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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

    // Add new order when payment successfully
    public int addNewOrder(Order o) {
        String sql = "INSERT INTO Orders (UserID, Status, PaymentMethod, ShippingAddress, TotalAmount, IsInstalment, ReceiverName, ReceiverPhone) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, o.getUserID());
            ps.setString(2, o.getStatus());
            ps.setString(3, o.getPaymentMethod());
            ps.setString(4, o.getShippingAddress());
            ps.setDouble(5, o.getTotalAmount());
            ps.setByte(6, o.isIsInstallment());
            ps.setString(7, o.getBuyer().getFullName());
            ps.setString(8, o.getBuyer().getPhone());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Get all order details by OrderID
    public List<OrderDetails> getAllOrderDetailByOrderID(int oid) {
        VariantsDAO vdao = new VariantsDAO();
        String sql = "SELECT * FROM OrderDetails WHERE OrderID = ?";
        List<OrderDetails> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, oid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantID = rs.getInt("VariantID");
                Variants variant = vdao.getVariantByID(variantID);
                list.add(new OrderDetails(
                        rs.getInt("OrderID"),
                        rs.getInt("Quantity"),
                        rs.getDouble("UnitPrice"),
                        rs.getInt("InterestRateID"),
                        rs.getDouble("MonthlyPayment"),
                        rs.getDouble("DownPayment"),
                        rs.getInt("InterestRate"),
                        variant));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    /**
     * Get all orders for a customer phone number.
     *
     * @param phone Customer phone number (supports partial match).
     * @return List of Order objects.
     */
    public List<Order> getOrdersByPhone(String phone) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.UserID, buyer.FullName AS BuyerName, buyer.Phone AS BuyerPhone, "
                + "o.ShippingAddress, o.TotalAmount, o.PaymentMethod, o.Status, o.OrderDate, "
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
                    Users buyer = new Users();
                    buyer.setFullName(rs.getString("BuyerName"));
                    buyer.setPhone(rs.getString("BuyerPhone"));

                    Users shipper = null;
                    int shipperID = rs.getInt("ShipperID");
                    if (shipperID != 0) {
                        shipper = new Users();
                        shipper.setUserId(shipperID);
                        shipper.setFullName(rs.getString("ShipperName"));
                        shipper.setPhone(rs.getString("ShipperPhone"));
                    }

                    Order o = new Order(
                            rs.getInt("OrderID"),
                            buyer, shipper,
                            rs.getString("ShippingAddress"),
                            rs.getBigDecimal("TotalAmount").doubleValue(),
                            rs.getTimestamp("OrderDate").toLocalDateTime(),
                            rs.getString("Status"));
                    o.setPaymentMethod(rs.getString("PaymentMethod"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get orders for a customer phone number filtered by status.
     *
     * @param phone Customer phone number (supports partial match).
     * @param status The status to filter by.
     * @return List of Order objects.
     */
    public List<Order> getOrdersByPhoneAndStatus(String phone, String status) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.UserID, buyer.FullName AS BuyerName, buyer.Phone AS BuyerPhone, "
                + "o.ShippingAddress, o.TotalAmount, o.PaymentMethod, o.Status, o.OrderDate, "
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
                    Users buyer = new Users();
                    buyer.setFullName(rs.getString("BuyerName"));
                    buyer.setPhone(rs.getString("BuyerPhone"));

                    Users shipper = null;
                    int shipperID = rs.getInt("ShipperID");
                    if (shipperID != 0) {
                        shipper = new Users();
                        shipper.setUserId(shipperID);
                        shipper.setFullName(rs.getString("ShipperName"));
                        shipper.setPhone(rs.getString("ShipperPhone"));
                    }

                    Order o = new Order(
                            rs.getInt("OrderID"),
                            buyer, shipper,
                            rs.getString("ShippingAddress"),
                            rs.getBigDecimal("TotalAmount").doubleValue(),
                            rs.getTimestamp("OrderDate").toLocalDateTime(),
                            rs.getString("Status"));
                    o.setPaymentMethod(rs.getString("PaymentMethod"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersByStatus(int userID, String status) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT o.OrderID, o.UserID, o.OrderDate, o.Status, o.PaymentMethod, o.ShippingAddress, "
                + "o.TotalAmount, o.IsInstalment, o.ReceiverName, o.ReceiverPhone FROM [Orders] o WHERE o.UserID = ? ");

        if (status.equalsIgnoreCase("All")) {
            sql.append("AND o.Status IN ('In Transit', 'Delivered', 'Cancelled', 'Pending')");
        } else {
            sql.append("AND o.Status = ?");
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            stmt.setInt(1, userID);
            if (!status.equalsIgnoreCase("All")) {
                stmt.setString(2, status);
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Users receiver = new Users();
                receiver.setFullName(rs.getString("ReceiverName"));
                receiver.setPhone(rs.getString("ReceiverPhone"));

                Order o = new Order(
                        userID, rs.getInt("OrderID"), rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"), rs.getBigDecimal("TotalAmount").doubleValue(),
                        rs.getString("Status"), rs.getByte("IsInstalment"),
                        rs.getTimestamp("OrderDate").toLocalDateTime(), receiver
                );
                orders.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getAllOrder() {
        List<Order> list = new ArrayList<>();
        String sql = "Select * from Orders";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"), rs.getInt("UserID"), rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"), rs.getDouble("TotalAmount"), rs.getString("Status"),
                        rs.getTimestamp("orderDate").toLocalDateTime(), rs.getByte("IsInstalment"),
                        rs.getString("ReceiverName"), rs.getString("ReceiverPhone")));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    // --- START OF MERGED CODE ---
    public List<Order> getAllPendingInstalment(List<Order> listInstalment) {
        PaymentsDAO pmdao = new PaymentsDAO();
        List<Order> list = new ArrayList<>();
        for (Order order : listInstalment) {
            List<Payments> listPayment = pmdao.getPaymentByOrderID(order.getOrderID());
            if (listPayment != null && !listPayment.isEmpty()) {
                for (Payments payment : listPayment) {
                    if (payment.getPaymentStatus().equals("Pending")) {
                        list.add(order);
                        break;
                    }
                }
            }
        }
        return list;
    }

    public List<Order> getAllCompletedInstalment(List<Order> listInstalment) {
        PaymentsDAO pmdao = new PaymentsDAO();
        List<Order> list = new ArrayList<>();
        for (Order order : listInstalment) {
            boolean checkPending = false;
            List<Payments> listPayment = pmdao.getPaymentByOrderID(order.getOrderID());
            if (listPayment != null && !listPayment.isEmpty()) {
                for (Payments payment : listPayment) {
                    if (payment.getPaymentStatus().equals("Pending")) {
                        checkPending = true;
                        break;
                    }
                }
            }
            if (!checkPending) {
                list.add(order);
            }
        }
        return list;
    }

    public List<String> getAllPhone() {
        String sql = "SELECT DISTINCT ReceiverPhone FROM Orders WHERE ReceiverPhone IS NOT NULL;";
        List<String> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("ReceiverPhone"));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllOrderByPhone(String phone) {
        String sql = "Select * from Orders Where ReceiverPhone = ?";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"), rs.getInt("UserID"), rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"), rs.getDouble("TotalAmount"), rs.getString("Status"),
                        rs.getTimestamp("orderDate").toLocalDateTime(), rs.getByte("IsInstalment"),
                        rs.getString("ReceiverName"), rs.getString("ReceiverPhone")));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllOrderByPhoneAndStatus(String phone, String statusFilter) {
        String sql = "Select * from Orders Where ReceiverPhone = ? And Status = ?";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, statusFilter);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"), rs.getInt("UserID"), rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"), rs.getDouble("TotalAmount"), rs.getString("Status"),
                        rs.getTimestamp("orderDate").toLocalDateTime(), rs.getByte("IsInstalment"),
                        rs.getString("ReceiverName"), rs.getString("ReceiverPhone")));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllOrderByStatus(String statusFilter) {
        String sql = "Select * from Orders Where Status = ?";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statusFilter);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"), rs.getInt("UserID"), rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"), rs.getDouble("TotalAmount"), rs.getString("Status"),
                        rs.getTimestamp("orderDate").toLocalDateTime(), rs.getByte("IsInstalment"),
                        rs.getString("ReceiverName"), rs.getString("ReceiverPhone")));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    // Get all orders belonging to a specific user (buyer)
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT "
                + "o.OrderID, o.OrderDate, o.ShippingAddress, o.TotalAmount, o.Status, "
                + "s.ShipperID, shipper.FullName AS ShipperName, shipper.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "LEFT JOIN Sales s ON o.OrderID = s.OrderID "
                + "LEFT JOIN Users shipper ON s.ShipperID = shipper.UserID "
                + "WHERE o.UserID = ? "
                + "ORDER BY o.OrderDate DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Users buyer = new Users();
                buyer.setUserId(userId);

                Users shipper = null;
                int shipperID = rs.getInt("ShipperID");
                if (shipperID > 0) {
                    shipper = new Users();
                    shipper.setUserId(shipperID);
                    shipper.setFullName(rs.getString("ShipperName"));
                    shipper.setPhone(rs.getString("ShipperPhone"));
                }

                int orderID = rs.getInt("OrderID");
                String address = rs.getString("ShippingAddress");
                double total = rs.getBigDecimal("TotalAmount").doubleValue();
                String status = rs.getString("Status");
                Timestamp date = rs.getTimestamp("OrderDate");

                Order o = new Order(orderID, buyer, shipper, address, total, date.toLocalDateTime(), status);
                orders.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.OrderID, o.UserID, o.PaymentMethod, o.ShippingAddress, o.TotalAmount, "
                + "o.Status, o.OrderDate, o.IsInstalment, u.FullName AS BuyerName "
                + "FROM [Orders] o "
                + "JOIN Users u ON o.UserID = u.UserID "
                + "WHERE o.OrderID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Users buyer = new Users();
                buyer.setUserId(rs.getInt("UserID"));
                buyer.setFullName(rs.getString("BuyerName"));
                return new Order(
                        rs.getInt("OrderID"),
                        buyer,
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        rs.getString("Status"),
                        rs.getTimestamp("OrderDate").toLocalDateTime()
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<String> getAllPhoneInstalment() {
        String sql = "SELECT DISTINCT ReceiverPhone FROM Orders WHERE ReceiverPhone IS NOT NULL AND isInstalment = 1;";
        List<String> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("ReceiverPhone"));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllOrderInstalmentByPhone(String phone) {
        String sql = "Select * from Orders Where ReceiverPhone = ? AND IsInstalment = 1";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"), rs.getInt("UserID"), rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"), rs.getDouble("TotalAmount"), rs.getString("Status"),
                        rs.getTimestamp("orderDate").toLocalDateTime(), rs.getByte("IsInstalment"),
                        rs.getString("ReceiverName"), rs.getString("ReceiverPhone")));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllOrderInstalment() {
        String sql = "Select * from Orders Where IsInstalment = 1";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"), rs.getInt("UserID"), rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"), rs.getDouble("TotalAmount"), rs.getString("Status"),
                        rs.getTimestamp("orderDate").toLocalDateTime(), rs.getByte("IsInstalment"),
                        rs.getString("ReceiverName"), rs.getString("ReceiverPhone")));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllPendingInstalmentAndPhone(List<Order> listInstalment, String phone) {
        PaymentsDAO pmdao = new PaymentsDAO();
        List<Order> list = new ArrayList<>();
        for (Order order : listInstalment) {
            if (order.getBuyerPhone() != null && order.getBuyerPhone().equals(phone)) {
                List<Payments> listPayment = pmdao.getPaymentByOrderID(order.getOrderID());
                if (listPayment != null && !listPayment.isEmpty()) {
                    for (Payments payment : listPayment) {
                        if (payment.getPaymentStatus().equals("Pending")) {
                            list.add(order);
                            break;
                        }
                    }
                }
            }
        }
        return list;
    }

    public List<Order> getAllCompletedInstalmentAndPhone(List<Order> listInstalment, String phone) {
        PaymentsDAO pmdao = new PaymentsDAO();
        List<Order> list = new ArrayList<>();
        for (Order order : listInstalment) {
            if (order.getBuyerPhone() != null && order.getBuyerPhone().equals(phone)) {
                boolean checkPending = false;
                List<Payments> listPayment = pmdao.getPaymentByOrderID(order.getOrderID());
                if (listPayment != null && !listPayment.isEmpty()) {
                    for (Payments payment : listPayment) {
                        if (payment.getPaymentStatus().equals("Pending")) {
                            checkPending = true;
                            break;
                        }
                    }
                }
                if (!checkPending) {
                    list.add(order);
                }
            }
        }
        return list;
    }

    public List<Order> getInstalmentOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.OrderDate FROM Orders o WHERE o.IsInstalment = 1 AND o.UserID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setOrderDate(rs.getTimestamp("orderDate").toLocalDateTime());
                orders.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

}
