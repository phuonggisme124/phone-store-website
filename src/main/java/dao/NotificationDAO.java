package dao;

import java.sql.*;
import java.util.*;
import model.Notification;

public class NotificationDAO {

    private Connection conn;

    public NotificationDAO(Connection conn) {
        this.conn = conn;
    }

    // Thêm thông báo mới
    public void addNotification(int userId, int orderId, String content) throws SQLException {
        String sql = "INSERT INTO Notifications (UserID, OrderID, Content, Date, isView) VALUES (?, ?, ?, NOW(), 0)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setInt(2, orderId);
        ps.setString(3, content);
        ps.executeUpdate();
    }

    // Lấy danh sách thông báo của 1 user
    public List<Notification> getNotificationsByUser(int userId) throws SQLException {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE UserID = ? ORDER BY Date DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Notification n = new Notification();
            n.setNotificationID(rs.getInt("NotificationID"));
            n.setUserID(rs.getInt("UserID"));
            n.setOrderID(rs.getInt("OrderID"));
            n.setContent(rs.getString("Content"));
            n.setDate(rs.getTimestamp("Date"));
            n.setView(rs.getBoolean("isView"));
            list.add(n);
        }
        return list;
    }

    // Đếm số thông báo chưa đọc
    public int countUnread(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE UserID = ? AND isView = 0";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
    }

    // Đánh dấu đã đọc
    public void markAllAsRead(int userId) throws SQLException {
        String sql = "UPDATE Notifications SET isView = 1 WHERE UserID = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.executeUpdate();
    }

    public void markAsRead(int notificationID) throws SQLException {
        String sql = "UPDATE Notifications SET isView = 1 WHERE NotificationID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationID);
            ps.executeUpdate();
        }
    }
    

}
