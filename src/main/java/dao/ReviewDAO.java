package dao;

import utils.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Review;
import model.Users;
import model.Variants;

public class ReviewDAO extends DBContext {

    public ReviewDAO() {
        super();
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
        String sql = "SELECT r.*, u.FullName AS UserName "
                + "FROM Reviews r "
                + "LEFT JOIN Users u ON r.UserID = u.UserID "
                + "WHERE r.ProductID = ? "
                + "ORDER BY r.ReviewDate DESC";
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
                Timestamp reviewDateTimestamp = rs.getTimestamp("ReviewDate");
                LocalDateTime reviewDate = (reviewDateTimestamp != null)
                        ? reviewDateTimestamp.toLocalDateTime()
                        : null;
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

    public List<Review> getAllReview() {
        UsersDAO udao = new UsersDAO();
        VariantsDAO vdao = new VariantsDAO();
        String sql = "Select * from Reviews";
        List<Review> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int rID = rs.getInt("ReviewID");
                int uID = rs.getInt("UserID");
                Users user = udao.getUserByID(uID);
                int variantID = rs.getInt("VariantID");
                Variants variant = vdao.getVariantByID(variantID);
                int rating = rs.getInt("Rating");
                String comment = rs.getString("Comment");

                Timestamp reviewDateTimestamp = rs.getTimestamp("ReviewDate");
                LocalDateTime reviewDate = (reviewDateTimestamp != null)
                        ? reviewDateTimestamp.toLocalDateTime()
                        : null;
                String image = rs.getString("Image");
                String reply = rs.getString("Reply");

                list.add(new Review(rID, user, variant, rating, comment, reviewDate, image, reply));
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public Review getReviewByID(int rID) {
        UsersDAO udao = new UsersDAO();
        VariantsDAO vdao = new VariantsDAO();
        String sql = "SELECT * FROM Reviews where ReviewID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, rID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("ReviewID");
                int uID = rs.getInt("UserID");
                Users user = udao.getUserByID(uID);
                int variantID = rs.getInt("VariantID");
                Variants variant = vdao.getVariantByID(variantID);
                int rating = rs.getInt("Rating");
                String comment = rs.getString("Comment");

                Timestamp reviewDateTimestamp = rs.getTimestamp("ReviewDate");
                LocalDateTime reviewDate = (reviewDateTimestamp != null)
                        ? reviewDateTimestamp.toLocalDateTime()
                        : null;
                String image = rs.getString("Image");
                String reply = rs.getString("Reply");

                return (new Review(id, user, variant, rating, comment, reviewDate, image, reply));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public void updateReview(int rID, String reply) {
        String sql = "UPDATE Reviews\n"
                + "SET Reply = ?\n"
                + "WHERE ReviewID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, reply);
            ps.setInt(2, rID);
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
