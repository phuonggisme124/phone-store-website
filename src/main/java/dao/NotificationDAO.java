package dao;

import java.sql.*;
import java.util.*;
import model.Notification;

/**
 * 
 * @author Nhung Hoa
 */

public class NotificationDAO {

    private Connection conn;

    public NotificationDAO(Connection conn) {
        this.conn = conn;
    }

    public void addNotification(int customerId, int orderId, String content) throws SQLException {
        // SỬA LỖI TẠI ĐÂY: UserID -> CustomerID
        String sql = "INSERT INTO Notifications (CustomerID, OrderID, Content, Date, isView) VALUES (?, ?, ?, GETDATE(), 0)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, customerId);
        ps.setInt(2, orderId);
        ps.setString(3, content);
        ps.executeUpdate();
    }


    public List<Notification> getNotificationsByUser(int customerId) throws SQLException {
        List<Notification> list = new ArrayList<>();

        String sql = "SELECT * FROM Notifications WHERE CustomerID = ? ORDER BY Date DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Notification n = new Notification();
            n.setNotificationID(rs.getInt("NotificationID"));
            n.setUserID(rs.getInt("CustomerID")); 
            n.setOrderID(rs.getInt("OrderID"));
            n.setContent(rs.getString("Content"));
            n.setDate(rs.getTimestamp("Date"));
            n.setView(rs.getBoolean("isView"));
            list.add(n);
        }
        return list;
    }


    public int countUnread(int customerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE CustomerID = ? AND isView = 0";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
    }

    public void markAllAsRead(int customerId) throws Exception {
        String sql = "UPDATE Notifications SET isView = 1 WHERE CustomerID = ? AND isView = 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.executeUpdate();
        }
    }

    public void markAsRead(int notificationID) throws SQLException {
        String sql = "UPDATE Notifications SET isView = 1 WHERE NotificationID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationID);
            ps.executeUpdate();
        }
    }
}