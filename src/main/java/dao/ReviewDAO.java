package dao;

import model.Review;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO extends DBContext {

    public ReviewDAO() {
        super();
    }

    // Lấy tất cả review
    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        // Join với Users và Products để lấy tên người dùng và tên sản phẩm
        String sql = "SELECT r.*, u.FullName AS UserName, p.Name AS ProductName " +
                     "FROM Reviews r " +
                     "LEFT JOIN Users u ON r.UserID = u.UserID " +
                     "LEFT JOIN Products p ON r.ProductID = p.ProductID " +
                     "ORDER BY r.ReviewDate DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int reviewID = rs.getInt("ReviewID");
                int userID = rs.getInt("UserID");
                int productID = rs.getInt("ProductID");
                int rating = rs.getInt("Rating");
                String comment = rs.getString("Comment");
                Timestamp reviewDateTs = rs.getTimestamp("ReviewDate");
                java.util.Date reviewDate = reviewDateTs != null ? new java.util.Date(reviewDateTs.getTime()) : null;
                String image = rs.getString("Image");
                String reply = rs.getString("Reply");
                String userName = rs.getString("UserName");
                String productName = rs.getString("ProductName");

                Review r = new Review(reviewID, userID, productID, rating, comment, reviewDate, image, reply);
                r.setUserName(userName);
                r.setProductName(productName);
                list.add(r);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm reply cho review
    public void replyToReview(int reviewID, String reply) {
        String sql = "UPDATE Reviews SET Reply = ? WHERE ReviewID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, reply);
            ps.setInt(2, reviewID);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy ProductID từ ReviewID (dùng để redirect)
    public int getProductIDByReview(int reviewID) {
        String sql = "SELECT ProductID FROM Reviews WHERE ReviewID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int productID = rs.getInt("ProductID");
                rs.close();
                ps.close();
                return productID;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Lấy tất cả review của 1 sản phẩm (cũ, nếu cần vẫn dùng được)
    public List<Review> getReviewsByProductID(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.FullName AS UserName " +
                     "FROM Reviews r " +
                     "LEFT JOIN Users u ON r.UserID = u.UserID " +
                     "WHERE r.ProductID = ? " +
                     "ORDER BY r.ReviewDate DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int reviewID = rs.getInt("ReviewID");
                int userID = rs.getInt("UserID");
                int productID = rs.getInt("ProductID");
                int rating = rs.getInt("Rating");
                String comment = rs.getString("Comment");
                Timestamp reviewDateTs = rs.getTimestamp("ReviewDate");
                java.util.Date reviewDate = reviewDateTs != null ? new java.util.Date(reviewDateTs.getTime()) : null;
                String image = rs.getString("Image");
                String reply = rs.getString("Reply");
                String userName = rs.getString("UserName");

                Review r = new Review(reviewID, userID, productID, rating, comment, reviewDate, image, reply);
                r.setUserName(userName);
                list.add(r);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
