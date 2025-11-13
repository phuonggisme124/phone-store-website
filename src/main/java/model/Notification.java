    package model;

    import java.sql.Timestamp;

    public class Notification {
        private int notificationID;
        private int userID;
        private int orderID;
        private String title;
        private String content;
        private Timestamp createdAt; // dùng cho getCreatedAt()
        private boolean view; // true = đã đọc

        // Getter & Setter
        public int getNotificationID() { return notificationID; }
        public void setNotificationID(int notificationID) { this.notificationID = notificationID; }

        public int getUserID() { return userID; }
        public void setUserID(int userID) { this.userID = userID; }

        public int getOrderID() { return orderID; }
        public void setOrderID(int orderID) { this.orderID = orderID; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }

        public Timestamp getCreatedAt() { return createdAt; }

        // **Thêm setter để DAO có thể gọi**
        public void setDate(Timestamp date) { this.createdAt = date; }

        public boolean isView() { return view; }
        public void setView(boolean view) { this.view = view; }

        // helper cho JSP
        public boolean isRead() { return view; }
    }
