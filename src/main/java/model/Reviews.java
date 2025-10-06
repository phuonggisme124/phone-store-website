/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.time.LocalDateTime;

/**
 *
 * @author USER
 */
public class Reviews {

    private int reviewsID;
    private Users userID;
    private int productID;
    private int rating;
    private String comment;
    private Date reviewDate;

    public Reviews() {
    }

    public Reviews(int reviewsID, Users userID, int productID, int rating, String comment, Date reviewDate) {
        this.reviewsID = reviewsID;
        this.userID = userID;
        this.productID = productID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
    }

    public int getReviewsID() {
        return reviewsID;
    }

    public void setReviewsID(int reviewsID) {
        this.reviewsID = reviewsID;
    }

    public Users getUserID() {
        return userID;
    }

    public void setUserID(Users userID) {
        this.userID = userID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
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

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    @Override
    public String toString() {
        return "Reviews{" + "reviewsID=" + reviewsID + ", userID=" + userID + ", productID=" + productID + ", rating=" + rating + ", comment=" + comment + ", reviewDate=" + reviewDate + '}';
    }
}