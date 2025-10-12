/*
 * Represents a product review made by a user.
 */
package model;

import java.sql.Date;

/**
 * The Reviews class maps to the Reviews table in the database.
 * Stores information about user reviews, including rating, comment, and review date.
 */
public class Reviews {

    // Unique ID of the review (primary key)
    private int reviewsID;
    
    // The user who created the review (foreign key to Users)
    private Users userID;
    
    // The product being reviewed (foreign key to Product)
    private int productID;
    
    // Rating given by the user (e.g., 1-5)
    private int rating;
    
    // Review comment or feedback
    private String comment;
    
    // Date when the review was created
    private Date reviewDate;

    // Default constructor
    public Reviews() {
    }

    /**
     * Full constructor including all fields.
     * 
     * @param reviewsID unique ID of the review
     * @param userID user who wrote the review
     * @param productID product being reviewed
     * @param rating rating given by the user
     * @param comment textual comment of the review
     * @param reviewDate date the review was created
     */
    public Reviews(int reviewsID, Users userID, int productID, int rating, String comment, Date reviewDate) {
        this.reviewsID = reviewsID;
        this.userID = userID;
        this.productID = productID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
    }

    // Getter and Setter for reviewsID
    public int getReviewsID() {
        return reviewsID;
    }

    public void setReviewsID(int reviewsID) {
        this.reviewsID = reviewsID;
    }

    // Getter and Setter for userID
    public Users getUserID() {
        return userID;
    }

    public void setUserID(Users userID) {
        this.userID = userID;
    }

    // Getter and Setter for productID
    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    // Getter and Setter for rating
    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    // Getter and Setter for comment
    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    // Getter and Setter for reviewDate
    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    // Returns a string representation of the review object
    @Override
    public String toString() {
        return "Reviews{" +
                "reviewsID=" + reviewsID +
                ", userID=" + userID +
                ", productID=" + productID +
                ", rating=" + rating +
                ", comment=" + comment +
                ", reviewDate=" + reviewDate +
                '}';
    }
}
