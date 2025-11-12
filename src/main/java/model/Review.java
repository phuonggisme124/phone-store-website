package model;

import java.time.LocalDateTime;
import java.util.Date;

/**
 * Represents a product review made by a user.
 */
public class Review {

    private int reviewID;      // ID của review
    private int userID;        // ID người dùng
    private int variantID;     // ID sản phẩm
    private int rating;        // Đánh giá (1-5)
    private String comment;    // Nội dung review
    private LocalDateTime reviewDate;   // Ngày review
    private String image;      // Ảnh (nếu có)
    private String reply;      // Reply của staff
    private Users user;
    private Variants variant;
    // Thêm các trường phụ để hiển thị dễ dàng
    private String userName;    // Tên người dùng
    private String productName; // Tên sản phẩm

    // Constructors
    public Review() {
    }

    public Review(int reviewID, int userID, int variantID, int rating, String comment, LocalDateTime reviewDate, String image, String reply) {
        this.reviewID = reviewID;
        this.userID = userID;
        this.variantID = variantID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
        this.image = image;
        this.reply = reply;
    }

    public Review(int reviewID, Users user, Variants variant, int rating, String comment, LocalDateTime reviewDate, String image, String reply) {
        this.reviewID = reviewID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
        this.image = image;
        this.reply = reply;
        this.user = user;
        this.variant = variant;
    }
    
    
    
    public Variants getVariant() {
        return variant;
    }

    // Getters & Setters
    public void setVariant(Variants variant) {
        this.variant = variant;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }
    
    
    
    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getVariantID() {
        return variantID;
    }

    public void setVariantID(int variantID) {
        this.variantID = variantID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(LocalDateTime reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
}
