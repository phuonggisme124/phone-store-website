/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author USER
 */


import java.sql.Date;

public class Promotions {

    private int promotionID;
    private double discountPercent;
    private Date startDate;
    private Date endDate;
    private String status;
    private Integer productID; // dùng Integer để cho phép null

    public Promotions() {
    }

    public Promotions(int promotionID, double discountPercent, Date startDate, Date endDate, String status, Integer productID) {
        this.promotionID = promotionID;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.productID = productID;
    }

    public int getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(int promotionID) {
        this.promotionID = promotionID;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
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

    @Override
    public String toString() {
        return "Promotion{"
                + "promotionID=" + promotionID
                + ", discountPercent=" + discountPercent
                + ", startDate=" + startDate
                + ", endDate=" + endDate
                + ", status='" + status + '\''
                + ", productID=" + productID
                + '}';
    }
}
