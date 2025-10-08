/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * The Promotions class maps to the Promotions table in the database.
 * Represents discount events and related product information.
 * 
 * @author Hoa Hong Nhung
 */
public class Promotions {

    // --- Required fields (NOT NULL) ---
    private int promotionID;       // int, NOT NULL (Primary Key)

    // --- Optional fields (Allow Nulls) ---
    private Integer discountPercent; // int, Allow Nulls
    private LocalDateTime startDate;     // date, Allow Nulls
    private LocalDateTime endDate;       // date, Allow Nulls
    private String status;           // nvarchar(20), Allow Nulls
    private Integer productID;       // int, Allow Nulls

    // --- Default constructor ---
    public Promotions() {
    }

    /**
     * Full constructor including all fields.
     */
    public Promotions(int promotionID, Integer discountPercent, LocalDateTime startDate,
                      LocalDateTime endDate, String status, Integer productID) {
        this.promotionID = promotionID;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.productID = productID;
    }

    /**
     * Minimal constructor for required fields only.
     */
    public Promotions(int promotionID) {
        this.promotionID = promotionID;
        this.discountPercent = null;
        this.startDate = null;
        this.endDate = null;
        this.status = null;
        this.productID = null;
    }

    // --- Getters and Setters ---
    public int getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(int promotionID) {
        this.promotionID = promotionID;
    }

    public Integer getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(Integer discountPercent) {
        this.discountPercent = discountPercent;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    // --- Override toString() ---
    @Override
    public String toString() {
        return "Promotions{" +
                "promotionID=" + promotionID +
                ", discountPercent=" + discountPercent +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", status='" + status + '\'' +
                ", productID=" + productID +
                '}';
    }

    
}
