/*
 * Represents a promotion or discount event for products.
 */
package model;

import java.time.LocalDateTime;

/**
 * The Promotions class maps to the Promotions table in the database.
 * Stores information about discount events, including discount percent,
 * duration, status, and related product.
 */
public class Promotions {

    // =========================================================
    //  Required fields (NOT NULL in database)
    // =========================================================
    private int promotionID;       // int, Primary Key (NOT NULL)

    // =========================================================
    //  Optional fields (Nullable in database)
    // =========================================================
    private Integer discountPercent; // Discount percentage (nullable)
    private LocalDateTime startDate; // Start date and time of the promotion (nullable)
    private LocalDateTime endDate;   // End date and time of the promotion (nullable)
    private String status;           // Status of promotion, e.g., "Active", "Expired" (nullable)
    private Integer productID;       // Related product ID (nullable)

    // =========================================================
    //  Default constructor - creates an empty Promotions object
    // =========================================================
    public Promotions() {
    }

    /**
     * Full constructor including all fields.
     * Useful when retrieving or inserting complete promotion data.
     *
     * @param promotionID unique ID of the promotion
     * @param discountPercent discount percentage
     * @param startDate start date and time of the promotion
     * @param endDate end date and time of the promotion
     * @param status current status of the promotion
     * @param productID ID of the product associated with the promotion
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
     * Useful when only the ID is known or other fields will be set later.
     *
     * @param promotionID unique ID of the promotion
     */
    public Promotions(int promotionID) {
        this.promotionID = promotionID;
        this.discountPercent = null;
        this.startDate = null;
        this.endDate = null;
        this.status = null;
        this.productID = null;
    }

    // =========================================================
    //  Getters and Setters - Accessor methods for each field
    // =========================================================
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

    // =========================================================
    //  toString() - Returns a string representation of the Promotions object
    // =========================================================
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
