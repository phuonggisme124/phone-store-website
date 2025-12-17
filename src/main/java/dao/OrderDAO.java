package dao;

import java.sql.*;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.Customer;
import model.InstallmentDetail;
import model.Order;
import model.OrderDetails;
import model.Variants;
import utils.DBContext;

public class OrderDAO extends DBContext {

    public OrderDAO() {
        super();
    }

    /* ======================== MAPPER ======================== */
    private Order mapResultSetToOrderWithCustomer(ResultSet rs) throws SQLException {
        Order order = new Order();

        order.setOrderID(rs.getInt("OrderID"));
        order.setUserID((Integer) rs.getObject("CustomerID"));
        order.setTotalAmount(rs.getDouble("TotalAmount"));
        order.setStatus(rs.getString("Status"));
        order.setPaymentMethod(rs.getString("PaymentMethod"));
        order.setShippingAddress(rs.getString("ShippingAddress"));
        order.setReceiverName(rs.getString("ReceiverName"));
        order.setReceiverPhone(rs.getString("ReceiverPhone"));
        order.setStaffID((Integer) rs.getObject("StaffID"));
        order.setIsInstalment((Boolean) rs.getObject("IsInstalment"));

        Timestamp ts = rs.getTimestamp("OrderDate");
        if (ts != null) {
            order.setOrderDate(ts.toLocalDateTime());
        }

        if (hasColumn(rs, "BuyerID") && rs.getObject("BuyerID") != null) {
            Customer buyer = new Customer();
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
        }

        return order;
    }

    private boolean hasColumn(ResultSet rs, String columnName) {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    /* ======================== BASIC ======================== */
    public int addNewOrder(Order o) {
        String sql = " INSERT INTO Orders\n"
                + "            (CustomerID, Status, PaymentMethod, ShippingAddress,\n"
                + "             TotalAmount, IsInstalment, ReceiverName, ReceiverPhone)\n"
                + "            VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

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

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, c.FullName AS BuyerName\n"
                + "            FROM Orders o\n"
                + "            LEFT JOIN Customers c ON o.CustomerID = c.CustomerID\n"
                + "            WHERE o.OrderID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToOrderWithCustomer(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ======================== SHIPPER ======================== */
    public List<Order> getOrdersByShipperId(int shipperID) {
        List<Order> list = new ArrayList<>();

        String sql = "SELECT o.*, c.FullName, c.Phone, c.Address\n"
                + "            FROM Orders o\n"
                + "            JOIN OrderShippers os ON o.OrderID = os.OrderID\n"
                + "            JOIN Customers c ON o.CustomerID = c.CustomerID\n"
                + "            WHERE os.ShipperID = ?\n"
                + "            ORDER BY o.OrderDate DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shipperID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = mapResultSetToOrderWithCustomer(rs);
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatusByShipper(int orderID, int shipperID, String newStatus) {
        if (!newStatus.equals("Delivered") && !newStatus.equals("Cancelled")) {
            return false;
        }

        String sql = "  UPDATE Orders\n"
                + "            SET Status = ?\n"
                + "            WHERE OrderID = ?\n"
                + "              AND Status = 'In Transit'\n"
                + "              AND EXISTS (\n"
                + "                  SELECT 1 FROM OrderShippers\n"
                + "                  WHERE OrderID = Orders.OrderID AND ShipperID = ?\n"
                + "              )";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderID);
            ps.setInt(3, shipperID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ======================== STAFF ======================== */
    public boolean assignShipperAndStaff(int orderID, int shipperID, int staffID) {
        try {
            conn.setAutoCommit(false);

            String updateOrder = "UPDATE Orders\n"
                    + "                            SET StaffID = ?, Status = 'In Transit'\n"
                    + "                            WHERE OrderID = ? AND Status = 'Pending'";

            try (PreparedStatement ps = conn.prepareStatement(updateOrder)) {
                ps.setInt(1, staffID);
                ps.setInt(2, orderID);
                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            String insertShipper = "INSERT INTO OrderShippers (OrderID, ShipperID) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertShipper)) {
                ps.setInt(1, orderID);
                ps.setInt(2, shipperID);
                ps.executeUpdate();
            }

            String reduceStock = " UPDATE Variants\n"
                    + "                SET Stock = Stock - od.Quantity\n"
                    + "                FROM Variants v\n"
                    + "                JOIN OrderDetails od ON v.VariantID = od.VariantID\n"
                    + "                WHERE od.OrderID = ?";

            try (PreparedStatement ps = conn.prepareStatement(reduceStock)) {
                ps.setInt(1, orderID);
                ps.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                conn.rollback();
            } catch (SQLException ignored) {
            }
            return false;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ignored) {
            }
        }
    }

    /* ======================== INSTALLMENT ======================== */
    public List<Order> getAllPendingInstalment(List<Order> orders) {
        InstallmentDetailDAO pmdao = new InstallmentDetailDAO();
        List<Order> list = new ArrayList<>();

        for (Order o : orders) {
            List<InstallmentDetail> payments = pmdao.getPaymentByOrderID(o.getOrderID());
            if (payments != null) {
                for (InstallmentDetail p : payments) {
                    if ("Pending".equals(p.getPaymentStatus())) {
                        list.add(o);
                        break;
                    }
                }
            }
        }
        return list;
    }

    public List<Order> getAllCompletedInstalment(List<Order> orders) {
        InstallmentDetailDAO pmdao = new InstallmentDetailDAO();
        List<Order> list = new ArrayList<>();

        for (Order o : orders) {
            boolean pending = false;
            List<InstallmentDetail> payments = pmdao.getPaymentByOrderID(o.getOrderID());
            if (payments != null) {
                for (InstallmentDetail p : payments) {
                    if ("Pending".equals(p.getPaymentStatus())) {
                        pending = true;
                        break;
                    }
                }
            }
            if (!pending) {
                list.add(o);
            }
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
