package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetails;
import model.Payments;
import model.Customer;
import model.Variants;
import utils.DBContext;

/**
 * OrderDAO Customers Staff: Admin (Role=4), Staff (Role=2), Shipper (Role=3)
 * OrderShippers:Orders và Staff (Shipper)
 */
public class OrderDAO extends DBContext {

    public OrderDAO() {
        super();
    }

    private Order mapResultSetToOrderWithCustomer(ResultSet rs) throws SQLException {
        Order order = new Order();

        String name = rs.getString("ReceiverName");
        String phone = rs.getString("ReceiverPhone");
        String address = rs.getString("ShippingAddress");

        order.setOrderID(rs.getInt("OrderID"));
        order.setTotalAmount(rs.getDouble("TotalAmount"));
        order.setUserID((Integer) rs.getObject("CustomerID"));

        Customer buyer = new Customer((Integer) rs.getObject("CustomerID"), name, phone);
        order.setStaffID((Integer) rs.getObject("StaffID"));

        Object isInstalmentObj = rs.getObject("IsInstalment");
        if (isInstalmentObj != null) {
            order.setIsInstalment((Boolean) isInstalmentObj);
        } else {
            order.setIsInstalment(null);
        }

        Timestamp ts = rs.getTimestamp("OrderDate");
        if (ts != null) {
            order.setOrderDate(ts.toLocalDateTime());
        }

        order.setStatus(rs.getString("Status"));
        order.setPaymentMethod(rs.getString("PaymentMethod"));
        order.setShippingAddress(rs.getString("ShippingAddress"));
        order.setReceiverName(rs.getString("ReceiverName"));
        order.setReceiverPhone(rs.getString("ReceiverPhone"));

        if (hasColumn(rs, "BuyerID") && rs.getObject("BuyerID") != null) {
            buyer = new Customer();
            buyer.setCustomerID(rs.getInt("BuyerID"));
            buyer.setFullName(rs.getString("BuyerName"));
            buyer.setPhone(rs.getString("BuyerPhone"));
            order.setBuyer(buyer);
        }

        if (hasColumn(rs, "ShipperID_Alias") && rs.getObject("ShipperID_Alias") != null) {
            Customer shipper = new Customer();
            shipper.setCustomerID(rs.getInt("ShipperID_Alias"));
            shipper.setFullName(rs.getString("ShipperName"));
            shipper.setPhone(rs.getString("ShipperPhone"));
            order.setShippers(shipper);
        }

        return order;
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, c.FullName AS BuyerName "
                + "FROM Orders o "
                + "LEFT JOIN Customers c ON o.CustomerID = c.CustomerID "
                + "WHERE o.OrderID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order o = new Order();
                o.setOrderID(rs.getInt("OrderID"));
                o.setUserID((Integer) rs.getObject("CustomerID"));
                o.setOrderDate(rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null);
                o.setStatus(rs.getString("Status"));
                o.setPaymentMethod(rs.getString("PaymentMethod"));
                o.setShippingAddress(rs.getString("ShippingAddress"));
                o.setTotalAmount(rs.getDouble("TotalAmount"));
                o.setIsInstalment((Boolean) rs.getObject("IsInstalment"));
                o.setReceiverName(rs.getString("ReceiverName"));
                o.setReceiverPhone(rs.getString("ReceiverPhone"));
                o.setStaffID((Integer) rs.getObject("StaffID"));

                if (o.getUserID() != null) {
                    Customer buyer = new Customer();
                    buyer.setCustomerID(o.getUserID());
                    buyer.setFullName(rs.getString("BuyerName"));
                    o.setBuyer(buyer);
                }

                return o;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrdersByShipperId(int shipperID) {
        List<Order> list = new ArrayList<>();

        String sql = "        SELECT \n"
                + "            o.*,\n"
                + "            c.FullName,\n"
                + "            c.Phone,\n"
                + "            c.Address\n"
                + "        FROM Orders o\n"
                + "        JOIN OrderShippers os ON o.OrderID = os.OrderID\n"
                + "        JOIN Customers c ON o.CustomerID = c.CustomerID\n"
                + "        WHERE os.ShipperID = ?\n"
                + "        ORDER BY o.OrderDate DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shipperID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();

                o.setOrderID(rs.getInt("OrderID"));
                o.setUserID(rs.getInt("CustomerID"));
                o.setOrderDate(rs.getTimestamp("OrderDate") != null
                        ? rs.getTimestamp("OrderDate").toLocalDateTime()
                        : null);
                o.setStatus(rs.getString("Status"));
                o.setPaymentMethod(rs.getString("PaymentMethod"));
                o.setShippingAddress(rs.getString("ShippingAddress"));
                o.setTotalAmount(rs.getDouble("TotalAmount"));
                o.setIsInstalment(rs.getBoolean("IsInstalment"));
                o.setReceiverName(rs.getString("ReceiverName"));
                o.setReceiverPhone(rs.getString("ReceiverPhone"));

                Customer buyer = new Customer();
                buyer.setCustomerID(rs.getInt("CustomerID"));
                buyer.setFullName(rs.getString("FullName"));
                buyer.setPhone(rs.getString("Phone"));
                buyer.setAddress(rs.getString("Address"));

                o.setBuyer(buyer);

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Order> getOrdersByShipperIdAndStatus(int shipperID, String status) {
        List<Order> list = new ArrayList<>();

        String sql = "SELECT \n"
                + "            o.*,\n"
                + "            c.FullName,\n"
                + "            c.Phone,\n"
                + "            c.Address\n"
                + "        FROM Orders o\n"
                + "        JOIN OrderShippers os ON o.OrderID = os.OrderID\n"
                + "        JOIN Customers c ON o.CustomerID = c.CustomerID\n"
                + "        WHERE os.ShipperID = ?\n"
                + "          AND o.Status = ?\n"
                + "        ORDER BY o.OrderDate DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shipperID);
            ps.setString(2, status);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();

                o.setOrderID(rs.getInt("OrderID"));
                o.setUserID(rs.getInt("CustomerID"));
                o.setOrderDate(rs.getTimestamp("OrderDate") != null
                        ? rs.getTimestamp("OrderDate").toLocalDateTime()
                        : null);
                o.setStatus(rs.getString("Status"));
                o.setPaymentMethod(rs.getString("PaymentMethod"));
                o.setShippingAddress(rs.getString("ShippingAddress"));
                o.setTotalAmount(rs.getDouble("TotalAmount"));
                o.setIsInstalment(rs.getBoolean("IsInstalment"));
                o.setReceiverName(rs.getString("ReceiverName"));
                o.setReceiverPhone(rs.getString("ReceiverPhone"));

                Customer buyer = new Customer();
                buyer.setCustomerID(rs.getInt("CustomerID"));
                buyer.setFullName(rs.getString("FullName"));
                buyer.setPhone(rs.getString("Phone"));
                buyer.setAddress(rs.getString("Address"));

                o.setBuyer(buyer);

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Order> getOrdersByPhone(String phone) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, "
                + "c.CustomerID AS BuyerID, c.FullName AS BuyerName, c.Phone AS BuyerPhone, "
                + "s.StaffID AS ShipperID_Alias, s.FullName AS ShipperName, s.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "LEFT JOIN Customers c ON o.CustomerID = c.CustomerID "
                + "LEFT JOIN OrderShippers os ON o.OrderID = os.OrderID "
                + "LEFT JOIN Staff s ON os.ShipperID = s.StaffID "
                + "WHERE o.ReceiverPhone LIKE ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + phone + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToOrderWithCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, "
                + "c.CustomerID AS BuyerID, c.FullName AS BuyerName, c.Phone AS BuyerPhone, "
                + "s.StaffID AS ShipperID_Alias, s.FullName AS ShipperName, s.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "LEFT JOIN Customers c ON o.CustomerID = c.CustomerID "
                + "LEFT JOIN OrderShippers os ON o.OrderID = os.OrderID "
                + "LEFT JOIN Staff s ON os.ShipperID = s.StaffID "
                + "WHERE o.CustomerID = ? "
                + "ORDER BY o.OrderDate DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrderWithCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

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

    public List<Order> getOrdersByStatus(int userID, String status) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.OrderID, o.CustomerID, o.OrderDate, o.Status, o.PaymentMethod, "
                + "o.ShippingAddress, o.TotalAmount, o.IsInstalment, o.ReceiverName, o.ReceiverPhone "
                + "FROM Orders o WHERE o.CustomerID = ? ");

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
                Order o = new Order();
                o.setUserID(userID);
                o.setOrderID(rs.getInt("OrderID"));
                o.setPaymentMethod(rs.getString("PaymentMethod"));
                o.setShippingAddress(rs.getString("ShippingAddress"));
                o.setTotalAmount(rs.getBigDecimal("TotalAmount").doubleValue());
                o.setStatus(rs.getString("Status"));
                o.setIsInstalment((Boolean) rs.getObject("IsInstalment"));

                Timestamp ts = rs.getTimestamp("OrderDate");
                if (ts != null) {
                    o.setOrderDate(ts.toLocalDateTime());
                }

                Customer receiver = new Customer();
                receiver.setFullName(rs.getString("ReceiverName"));
                receiver.setPhone(rs.getString("ReceiverPhone"));
                o.setBuyer(receiver);

                orders.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getAllOrder() {
        List<Order> list = new ArrayList<>();

        String sql = "SELECT o.*, os.ShipperID as RealShipperID "
                + "FROM Orders o "
                + "LEFT JOIN OrderShippers os ON o.OrderID = os.OrderID";

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("CustomerID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID"),
                        (Integer) rs.getObject("RealShipperID")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public void deleteOrderByID(int id) {
        String[] deleteStatements = {
            "DELETE FROM InstallmentDetail WHERE OrderID = ?",
            "DELETE FROM Notifications WHERE OrderID = ?",
            "DELETE FROM OrderShippers WHERE OrderID = ?",
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

    public int addNewOrder(Order o) {
        String sql = "INSERT INTO Orders (CustomerID, Status, PaymentMethod, ShippingAddress, "
                + "TotalAmount, IsInstalment, ReceiverName, ReceiverPhone) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setObject(1, o.getUserID());
            ps.setString(2, o.getStatus());
            ps.setString(3, o.getPaymentMethod());
            ps.setString(4, o.getShippingAddress());
            ps.setDouble(5, o.getTotalAmount());
            ps.setObject(6, o.getIsInstalment());
            ps.setString(7, o.getReceiverName());
            ps.setString(8, o.getReceiverPhone());
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

    public List<Order> getOrdersByPhoneAndStatus(String phone, String status) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.CustomerID, c.FullName AS BuyerName, c.Phone AS BuyerPhone, "
                + "o.ShippingAddress, o.TotalAmount, o.PaymentMethod, o.Status, o.OrderDate, "
                + "s.StaffID AS ShipperID, s.FullName AS ShipperName, s.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "JOIN Customers c ON o.CustomerID = c.CustomerID "
                + "LEFT JOIN OrderShippers os ON o.OrderID = os.OrderID "
                + "LEFT JOIN Staff s ON os.ShipperID = s.StaffID "
                + "WHERE c.Phone LIKE ? AND o.Status = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + phone + "%");
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer buyer = new Customer();
                    buyer.setFullName(rs.getString("BuyerName"));
                    buyer.setPhone(rs.getString("BuyerPhone"));

                    Customer shipper = null;
                    int shipperID = rs.getInt("ShipperID");
                    if (shipperID != 0) {
                        shipper = new Customer();
                        shipper.setCustomerID(shipperID);
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
        String sql = "SELECT DISTINCT ReceiverPhone FROM Orders WHERE ReceiverPhone IS NOT NULL";
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
        String sql = "SELECT * FROM Orders WHERE ReceiverPhone = ?";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("CustomerID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllOrderByPhoneAndStatus(String phone, String statusFilter) {
        String sql = "SELECT * FROM Orders WHERE ReceiverPhone = ? AND Status = ?";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, statusFilter);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("CustomerID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllOrderByStatus(String statusFilter) {
        String sql = "SELECT * FROM Orders WHERE Status = ?";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statusFilter);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("CustomerID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<String> getAllPhoneInstalment() {
        String sql = "SELECT DISTINCT ReceiverPhone FROM Orders "
                + "WHERE ReceiverPhone IS NOT NULL AND IsInstalment = 1";
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
        String sql = "SELECT * FROM Orders WHERE ReceiverPhone = ? AND IsInstalment = 1";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("CustomerID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllOrderInstalment() {
        String sql = "SELECT * FROM Orders WHERE IsInstalment = 1";
        List<Order> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("CustomerID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID")
                ));
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
            if (order.getReceiverPhone() != null && order.getReceiverPhone().equals(phone)) {
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
            if (order.getReceiverPhone() != null && order.getReceiverPhone().equals(phone)) {
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
        String sql = "SELECT o.OrderID, o.OrderDate FROM Orders o "
                + "WHERE o.IsInstalment = 1 AND o.CustomerID = ?";

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

    public boolean checkUserPurchase(int userID, int productID, String storage) {
        String sql = "SELECT COUNT(*) AS total "
                + "FROM Orders o "
                + "JOIN OrderDetails od ON o.OrderID = od.OrderID "
                + "JOIN Variants v ON od.VariantID = v.VariantID "
                + "WHERE o.CustomerID = ? AND v.ProductID = ? AND v.Storage = ? AND o.Status = 'Delivered'";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userID);
            ps.setInt(2, productID);
            ps.setString(3, storage);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int total = rs.getInt("total");
                return total > 0;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    /**
     * Assign shipper to order and insert into OrderShippers table Update order
     * status to 'In Transit' and reduce stock for variants
     *
     * @param orderID Order ID to assign
     * @param shipperID Shipper ID (from Staff table with Role = 3)
     * @param staffID Staff ID who is assigning the order
     * @return true if successful, false otherwise
     */
    public boolean assignShipperAndStaff(int orderID, int shipperID, int staffID) {
        try {
            conn.setAutoCommit(false);

            String updateOrderSQL = "UPDATE Orders SET StaffID = ?, Status = 'In Transit' "
                    + "WHERE OrderID = ? AND Status = 'Pending'";

            try (PreparedStatement stmt = conn.prepareStatement(updateOrderSQL)) {
                stmt.setInt(1, staffID);
                stmt.setInt(2, orderID);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    System.out.println("assignShipperAndStaff: Không thể cập nhật đơn hàng " + orderID);
                    conn.rollback();
                    return false;
                }
            }

            String insertShipperSQL = "INSERT INTO OrderShippers (OrderID, ShipperID) VALUES (?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(insertShipperSQL)) {
                stmt.setInt(1, orderID);
                stmt.setInt(2, shipperID);
                stmt.executeUpdate();
            }

            String reduceStockSQL = "UPDATE Variants SET Stock = Stock - od.Quantity "
                    + "FROM Variants v "
                    + "INNER JOIN OrderDetails od ON v.VariantID = od.VariantID "
                    + "WHERE od.OrderID = ?";

            try (PreparedStatement stmt = conn.prepareStatement(reduceStockSQL)) {
                stmt.setInt(1, orderID);
                stmt.executeUpdate();
            }

            conn.commit();
            System.out.println("assignShipperAndStaff: Thành công cho OrderID: " + orderID);
            return true;

        } catch (SQLException e) {
            System.err.println("assignShipperAndStaff SQL Error: " + e.getMessage());
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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
     * Assign shipper only (without staff parameter - for backward
     * compatibility)
     *
     * @param orderID Order ID to assign
     * @param shipperID Shipper ID for delivery
     * @return true if successful, false otherwise
     */
    public boolean assignShipperAndStaff(int orderID, int shipperID) {
        try {
            conn.setAutoCommit(false);

            // Bước 1: Cập nhật Status của đơn hàng (không cập nhật StaffID)
            String updateOrderSQL = "UPDATE Orders SET Status = 'In Transit' "
                    + "WHERE OrderID = ? AND Status = 'Pending'";

            try (PreparedStatement stmt = conn.prepareStatement(updateOrderSQL)) {
                stmt.setInt(1, orderID);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    System.out.println("assignShipperAndStaff: Không thể cập nhật đơn hàng " + orderID);
                    conn.rollback();
                    return false;
                }
            }

            String insertShipperSQL = "INSERT INTO OrderShippers (OrderID, ShipperID) VALUES (?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(insertShipperSQL)) {
                stmt.setInt(1, orderID);
                stmt.setInt(2, shipperID);
                stmt.executeUpdate();
            }

            String reduceStockSQL = "UPDATE Variants SET Stock = Stock - od.Quantity "
                    + "FROM Variants v "
                    + "INNER JOIN OrderDetails od ON v.VariantID = od.VariantID "
                    + "WHERE od.OrderID = ?";

            try (PreparedStatement stmt = conn.prepareStatement(reduceStockSQL)) {
                stmt.setInt(1, orderID);
                stmt.executeUpdate();
            }

            conn.commit();
            System.out.println("assignShipperAndStaff: Thành công cho OrderID: " + orderID);
            return true;

        } catch (SQLException e) {
            System.err.println("assignShipperAndStaff SQL Error: " + e.getMessage());
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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
     * Update order status by shipper (Delivered or Cancelled)
     *
     * @param orderID Order ID to update
     * @param shipperID Shipper ID updating the status
     * @param newStatus New status (must be 'Delivered' or 'Cancelled')
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatusByShipper(int orderID, int shipperID, String newStatus) {

        if (!newStatus.equals("Delivered") && !newStatus.equals("Cancelled")) {
            return false;
        }

        String sql = "    UPDATE Orders\n"
                + "        SET Status = ?\n"
                + "        WHERE OrderID = ?\n"
                + "          AND Status = 'In Transit'\n"
                + "          AND EXISTS (\n"
                + "              SELECT 1\n"
                + "              FROM OrderShippers os\n"
                + "              WHERE os.OrderID = Orders.OrderID\n"
                + "                AND os.ShipperID = ?\n"
                + "          )";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, orderID);
            stmt.setInt(3, shipperID);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check order status for debugging
     */
    private void checkOrderStatus(int orderID) {
        String sql = "SELECT o.OrderID, o.Status, o.StaffID, "
                + "(SELECT TOP 1 os.ShipperID FROM OrderShippers os WHERE os.OrderID = o.OrderID) AS ShipperID "
                + "FROM Orders o WHERE o.OrderID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("Order exists - OrderID: " + rs.getInt("OrderID")
                        + ", Status: [" + rs.getString("Status") + "]"
                        + ", StaffID: " + rs.getObject("StaffID")
                        + ", ShipperID: " + rs.getObject("ShipperID"));
            } else {
                System.out.println("Order not found - OrderID: " + orderID);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Get all orders for staff (Pending orders + orders assigned to this staff)
     *
     * @param staffID Staff ID
     * @return List of orders
     */
    public List<Order> getAllOrderForStaff(int staffID) {
        List<Order> orders = new ArrayList<>();

        String sql = "SELECT o.*, "
                + "c.CustomerID AS BuyerID, c.FullName AS BuyerName, c.Phone AS BuyerPhone, "
                + "s.StaffID AS ShipperID_Alias, s.FullName AS ShipperName, s.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "LEFT JOIN Customers c ON o.CustomerID = c.CustomerID "
                + "LEFT JOIN OrderShippers os ON o.OrderID = os.OrderID "
                + "LEFT JOIN Staff s ON os.ShipperID = s.StaffID "
                + "WHERE o.Status = 'Pending' OR o.StaffID = ? "
                + "ORDER BY o.OrderDate DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToOrderWithCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Get orders by status for staff
     *
     * @param staffID Staff ID
     * @param status Order status
     * @return List of orders
     */
    public List<Order> getOrdersByStatusForStaff(int staffID, String status) {
        List<Order> orders = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT o.*, "
                + "c.CustomerID AS BuyerID, c.FullName AS BuyerName, c.Phone AS BuyerPhone, "
                + "s.StaffID AS ShipperID_Alias, s.FullName AS ShipperName, s.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "LEFT JOIN Customers c ON o.CustomerID = c.CustomerID "
                + "LEFT JOIN OrderShippers os ON o.OrderID = os.OrderID "
                + "LEFT JOIN Staff s ON os.ShipperID = s.StaffID ");

        if (status.equalsIgnoreCase("Pending")) {
            sql.append("WHERE o.Status = 'Pending'");
        } else {
            sql.append("WHERE o.Status = ? AND o.StaffID = ?");
        }
        sql.append(" ORDER BY o.OrderDate DESC");

        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            if (!status.equalsIgnoreCase("Pending")) {
                stmt.setString(1, status);
                stmt.setInt(2, staffID);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrderWithCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Cancel order by staff Only works for Pending orders
     *
     * @param orderID Order ID to cancel
     * @param staffID Staff ID who is cancelling
     * @return true if successful, false otherwise
     */
    public boolean cancelOrderByStaff(int orderID, int staffID) {
        String sql = "UPDATE Orders SET StaffID = ?, Status = 'Cancelled' "
                + "WHERE OrderID = ? AND Status = 'Pending'";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffID);
            stmt.setInt(2, orderID);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected == 0) {
                System.out.println("cancelOrderByStaff: No rows affected for OrderID: " + orderID);
                checkOrderStatus(orderID);
            } else {
                System.out.println("cancelOrderByStaff: Successfully cancelled OrderID: " + orderID);
            }

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("cancelOrderByStaff SQL Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all buyer phones from Customers who have placed orders
     *
     * @return List of phone numbers
     */
    public List<String> getAllBuyerPhones() {
        String sql = "SELECT DISTINCT c.Phone "
                + "FROM Customers c "
                + "JOIN Orders o ON c.CustomerID = o.CustomerID "
                + "WHERE c.Phone IS NOT NULL";

        List<String> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String phone = rs.getString("Phone");
                list.add(phone);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }
}
