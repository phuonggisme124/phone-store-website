package model;

import java.util.Date;

/**
 * Represents a product review made by a user.
 */
public class Review {

    private int reviewID;      // ID của review
    private int userID;        // ID người dùng
    private int productID;     // ID sản phẩm
    private int rating;        // Đánh giá (1-5)
    private String comment;    // Nội dung review
    private Date reviewDate;   // Ngày review
    private String image;      // Ảnh (nếu có)
    private String reply;      // Reply của staff

    // Thêm các trường phụ để hiển thị dễ dàng
    private String userName;    // Tên người dùng
    private String productName; // Tên sản phẩm

    // Constructors
    public Review() {}

    public Review(int reviewID, int userID, int productID, int rating, String comment, Date reviewDate, String image, String reply) {
        this.reviewID = reviewID;
        this.userID = userID;
        this.productID = productID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
        this.image = image;
        this.reply = reply;
    }

    // Getters & Setters
    public int getReviewID() { return reviewID; }
    public void setReviewID(int reviewID) { this.reviewID = reviewID; }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public int getProductID() { return productID; }
    public void setProductID(int productID) { this.productID = productID; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Date getReviewDate() { return reviewDate; }
    public void setReviewDate(Date reviewDate) { this.reviewDate = reviewDate; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
}
