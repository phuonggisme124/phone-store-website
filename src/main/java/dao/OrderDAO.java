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
import model.InstallmentDetail;
import model.Customer;
import model.InstallmentDetail;
import model.Variants;
import utils.DBContext;

/**
 *
 * @author thịnh assignShipperAndStaff
 */
public class OrderDAO extends DBContext {

    public OrderDAO() {
        super();
    }

    private Order mapResultSetToOrderWithCustomer(ResultSet rs) throws SQLException {

        Order order = new Order();
        // Buyer information
        String name = rs.getString("ReceiverName");
        String phone = rs.getString("ReceiverPhone");
        String address = rs.getString("ShippingAddress");

        order.setOrderID(rs.getInt("OrderID"));
        order.setTotalAmount(rs.getDouble("TotalAmount"));
        order.setUserID((Integer) rs.getObject("UserID"));
        Customer buyer = new Customer((Integer) rs.getObject("UserID"), name, phone);
        order.setStaffID((Integer) rs.getObject("StaffID"));
        order.setShipperID((Integer) rs.getObject("ShipperID"));

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
        String sql = "SELECT o.*, u.FullName AS BuyerName "
                + "FROM [Orders] o "
                + "LEFT JOIN Customer u ON o.UserID = u.UserID "
                + "WHERE o.OrderID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                Order o = new Order();
                o.setOrderID(rs.getInt("OrderID"));
                o.setUserID((Integer) rs.getObject("UserID"));
                o.setOrderDate(rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null);
                o.setStatus(rs.getString("Status"));
                o.setPaymentMethod(rs.getString("PaymentMethod"));
                o.setShippingAddress(rs.getString("ShippingAddress"));
                o.setTotalAmount(rs.getDouble("TotalAmount"));
                o.setIsInstalment((Boolean) rs.getObject("IsInstalment"));
                o.setReceiverName(rs.getString("ReceiverName"));
                o.setReceiverPhone(rs.getString("ReceiverPhone"));
                o.setStaffID((Integer) rs.getObject("StaffID"));
                o.setShipperID((Integer) rs.getObject("ShipperID"));

                if (o.getUserID() != null) {
                    Customer buyer = new Customer();
                    buyer.setCustomerID(orderId);
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
                + "b.UserID AS BuyerID, b.FullName AS BuyerName, b.Phone AS BuyerPhone, "
                + "s.UserID AS ShipperID_Alias, s.FullName AS ShipperName, s.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "LEFT JOIN Customer b ON o.UserID = b.UserID "
                + "LEFT JOIN Customer s ON o.ShipperID = s.UserID "
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
                + "b.UserID AS BuyerID, b.FullName AS BuyerName, b.Phone AS BuyerPhone, "
                + "s.UserID AS ShipperID_Alias, s.FullName AS ShipperName, s.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "LEFT JOIN Customer b ON o.UserID = b.UserID "
                + "LEFT JOIN Customer s ON o.ShipperID = s.UserID "
                + "WHERE o.UserID = ? "
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
        String sql = "Select * from Orders";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("UserID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID"),
                        (Integer) rs.getObject("ShipperID")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public void deleteOrderByID(int id) {
        String[] deleteStatements = {
            "DELETE FROM Payments WHERE OrderID = ?",
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
        String sql = "INSERT INTO Orders (CustomerID, Status, PaymentMethod, ShippingAddress, TotalAmount, IsInstalment, ReceiverName, ReceiverPhone) "
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
                        variant));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getOrdersByPhoneAndStatus(String phone, String status) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.UserID, buyer.FullName AS BuyerName, buyer.Phone AS BuyerPhone, "
                + "o.ShippingAddress, o.TotalAmount, o.PaymentMethod, o.Status, o.OrderDate, "
                + "shippers.UserID AS ShipperID, shippers.FullName AS ShipperName, shippers.Phone AS ShipperPhone "
                + "FROM Orders o "
                + "JOIN Customer buyer ON o.UserID = buyer.UserID "
                + "LEFT JOIN Sales s ON o.OrderID = s.OrderID "
                + "LEFT JOIN Customer shippers ON s.ShipperID = shippers.UserID "
                + "WHERE buyer.Phone LIKE ? AND o.Status = ?";

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
        InstallmentDetailDAO pmdao = new InstallmentDetailDAO();
        List<Order> list = new ArrayList<>();
        for (Order order : listInstalment) {
            List<InstallmentDetail> listPayment = pmdao.getPaymentByOrderID(order.getOrderID());
            if (listPayment != null && !listPayment.isEmpty()) {
                for (InstallmentDetail payment : listPayment) {
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
        InstallmentDetailDAO pmdao = new InstallmentDetailDAO();
        List<Order> list = new ArrayList<>();
        for (Order order : listInstalment) {
            boolean checkPending = false;
            List<InstallmentDetail> listPayment = pmdao.getPaymentByOrderID(order.getOrderID());
            if (listPayment != null && !listPayment.isEmpty()) {
                for (InstallmentDetail payment : listPayment) {
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
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("UserID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID"),
                        (Integer) rs.getObject("ShipperID")
                ));
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
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("UserID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID"),
                        (Integer) rs.getObject("ShipperID")
                ));
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
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("UserID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID"),
                        (Integer) rs.getObject("ShipperID")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<String> getAllPhoneInstalment() {
        String sql = "SELECT DISTINCT ReceiverPhone FROM Orders WHERE ReceiverPhone IS NOT NULL AND IsInstalment = 1;";
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
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("UserID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID"),
                        (Integer) rs.getObject("ShipperID")
                ));
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
                        rs.getInt("OrderID"),
                        (Integer) rs.getObject("UserID"),
                        rs.getTimestamp("OrderDate") != null ? rs.getTimestamp("OrderDate").toLocalDateTime() : null,
                        rs.getString("Status"),
                        rs.getString("PaymentMethod"),
                        rs.getString("ShippingAddress"),
                        rs.getDouble("TotalAmount"),
                        (Boolean) rs.getObject("IsInstalment"),
                        rs.getString("ReceiverName"),
                        rs.getString("ReceiverPhone"),
                        (Integer) rs.getObject("StaffID"),
                        (Integer) rs.getObject("ShipperID")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Order> getAllPendingInstalmentAndPhone(List<Order> listInstalment, String phone) {
        InstallmentDetailDAO pmdao = new InstallmentDetailDAO();
        List<Order> list = new ArrayList<>();
        for (Order order : listInstalment) {
            if (order.getReceiverPhone() != null && order.getReceiverPhone().equals(phone)) {
                List<InstallmentDetail> listPayment = pmdao.getPaymentByOrderID(order.getOrderID());
                if (listPayment != null && !listPayment.isEmpty()) {
                    for (InstallmentDetail payment : listPayment) {
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
        InstallmentDetailDAO pmdao = new InstallmentDetailDAO();
        List<Order> list = new ArrayList<>();
        for (Order order : listInstalment) {
            if (order.getReceiverPhone() != null && order.getReceiverPhone().equals(phone)) {
                boolean checkPending = false;
                List<InstallmentDetail> listPayment = pmdao.getPaymentByOrderID(order.getOrderID());
                if (listPayment != null && !listPayment.isEmpty()) {
                    for (InstallmentDetail payment : listPayment) {
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

    public boolean checkUserPurchase(int userID, int productID, String storage) {
        String sql = "SELECT \n"
                + "    COUNT(*) AS total\n"
                + "FROM Orders o\n"
                + "JOIN OrderDetails od ON o.OrderID = od.OrderID\n"
                + "JOIN Variants v ON od.VariantID = v.VariantID\n"
                + "WHERE \n"
                + "    o.UserID = ?\n"
                + "    AND v.ProductID = ?\n"
                + "    AND v.Storage = ?\n"
                + "    AND o.Status = 'Delivered';";

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
     * Assign shipper and staff to order, update status to 'In Transit' AND
     * reduce stock for all variants in the order
     *
     * @param orderID Order ID to assign
     * @param staffID Staff ID assigning the order
     * @param shipperID Shipper ID for delivery
     * @return true if successful, false otherwise
     */
    public boolean assignShipperAndStaff(int orderID, int staffID, int shipperID) {
        try {
            conn.setAutoCommit(false);

            // Step 1: Update order status
            String updateOrderSQL = "UPDATE Orders SET StaffID = ?, ShipperID = ?, Status = 'In Transit' "
                    + "WHERE OrderID = ? AND Status = 'Pending'";

            try (PreparedStatement stmt = conn.prepareStatement(updateOrderSQL)) {
                stmt.setInt(1, staffID);
                stmt.setInt(2, shipperID);
                stmt.setInt(3, orderID);

                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected == 0) {
                    System.out.println("assignShipperAndStaff: No rows affected for OrderID: " + orderID);
                    checkOrderStatus(orderID);
                    conn.rollback();
                    return false;
                }
            }

            // Step 2: Reduce stock for each variant in order details
            String getOrderDetailsSQL = "SELECT VariantID, Quantity FROM OrderDetails WHERE OrderID = ?";
            String updateStockSQL = "UPDATE Variants SET Stock = Stock - ? WHERE VariantID = ?";

            try (PreparedStatement getDetails = conn.prepareStatement(getOrderDetailsSQL); PreparedStatement updateStock = conn.prepareStatement(updateStockSQL)) {

                getDetails.setInt(1, orderID);
                ResultSet rs = getDetails.executeQuery();

                while (rs.next()) {
                    int variantID = rs.getInt("VariantID");
                    int quantity = rs.getInt("Quantity");

                    updateStock.setInt(1, quantity);
                    updateStock.setInt(2, variantID);
                    updateStock.executeUpdate();

                    System.out.println("Reduced stock for VariantID: " + variantID + " by " + quantity + " units");
                }
            }

            conn.commit();
            System.out.println("assignShipperAndStaff: Successfully assigned OrderID: " + orderID + " and updated stock");
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

    private void checkOrderStatus(int orderID) {
        String sql = "SELECT OrderID, Status, StaffID, ShipperID FROM Orders WHERE OrderID = ?";
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

    public List<Order> getAllOrderForStaff(int staffID) {
        List<Order> orders = new ArrayList<>();

        String sql = "SELECT o.*, "
                + "b.UserID AS BuyerID, b.FullName AS BuyerName, b.Phone AS BuyerPhone, "
                + "s.UserID AS ShipperID_Alias, s.FullName AS ShipperName, s.Phone AS ShipperPhone "
                + "FROM [Orders] o "
                + "LEFT JOIN [Customer] b ON o.UserID = b.UserID "
                + "LEFT JOIN [Customer] s ON o.ShipperID = s.UserID "
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

    public List<Order> getOrdersByStatusForStaff(int staffID, String status) {
        List<Order> orders = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT o.*, "
                + "b.UserID AS BuyerID, b.FullName AS BuyerName, b.Phone AS BuyerPhone, "
                + "s.UserID AS ShipperID_Alias, s.FullName AS ShipperName, s.Phone AS ShipperPhone "
                + "FROM [Orders] o "
                + "LEFT JOIN [Customer] b ON o.UserID = b.UserID "
                + "LEFT JOIN [Customer] s ON o.ShipperID = s.UserID ");

        if (status.equalsIgnoreCase("Pending")) {
            sql.append("WHERE o.Status = 'Pending'");
        } else {
            sql.append("WHERE o.Status = ? AND o.StaffID = ?");
        }
        sql.append(" ORDER BY o.OrderDate DESC");

        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            if (status.equalsIgnoreCase("Pending")) {

            } else {
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

    public boolean cancelOrderByStaff(int orderID, int staffID) {
        String sql = "UPDATE Orders SET StaffID = ?, ShipperID = NULL, Status = 'Cancelled' "
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

    public static void main(String[] args) {

        OrderDAO dao = new OrderDAO();

        int shipperID = 3;                 // <-- đổi theo DB của bạn
        String statusFilter = "In Transit"; // hoặc: Delivered, Cancelled

        System.out.println("===== TEST SHIPPER: GET ALL ORDERS =====");
        List<Order> orders = dao.getOrdersByShipperId(shipperID);

        if (orders == null || orders.isEmpty()) {
            System.out.println("No orders found for shipperID = " + shipperID);
        } else {
            for (Order o : orders) {
                printOrderForShipper(o);
            }
        }

        System.out.println("\n===== TEST SHIPPER: GET ORDERS BY STATUS =====");
        List<Order> ordersByStatus = dao.getOrdersByShipperIdAndStatus(shipperID, statusFilter);

        if (ordersByStatus == null || ordersByStatus.isEmpty()) {
            System.out.println("No orders with status = " + statusFilter);
        } else {
            for (Order o : ordersByStatus) {
                printOrderForShipper(o);
            }
        }

        System.out.println("\n===== TEST SHIPPER: UPDATE STATUS =====");
        if (!orders.isEmpty()) {
            int testOrderID = orders.get(0).getOrderID();

            boolean updated = dao.updateOrderStatusByShipper(
                    testOrderID,
                    shipperID,
                    "Delivered" // hoặc Cancelled
            );

            System.out.println("Update orderID " + testOrderID + " -> Delivered : " + updated);
        }
    }

    private static void printOrderForShipper(Order o) {
        System.out.println("----------------------------------");
        System.out.println("OrderID   : " + o.getOrderID());
        System.out.println("Status    : " + o.getStatus());
        System.out.println("Total     : " + o.getTotalAmount());
        System.out.println("Receiver  : " + o.getReceiverName());
        System.out.println("Phone     : " + o.getReceiverPhone());
        System.out.println("Address   : " + o.getShippingAddress());

        if (o.getBuyer() != null) {
            System.out.println("Buyer     : " + o.getBuyer().getFullName()
                    + " | " + o.getBuyer().getPhone());
        } else {
            System.out.println("Buyer     : NULL ❌");
        }
    }

}
