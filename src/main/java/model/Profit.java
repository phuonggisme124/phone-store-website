/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author 
 */
public class Profit {
    private int profitID;
    private int variantID;
    private int quantity;
    private double sellingPrice;
    private double costPrice;
    private LocalDateTime calculatedDate;

    public Profit() {
    }

    public Profit(int profitID, int variantID, int quantity, double sellingPrice, double costPrice, LocalDateTime calculatedDate) {
        this.profitID = profitID;
        this.variantID = variantID;
        this.quantity = quantity;
        this.sellingPrice = sellingPrice;
        this.costPrice = costPrice;
        this.calculatedDate = calculatedDate;
    }

    public int getProfitID() {
        return profitID;
    }

    public void setProfitID(int profitID) {
        this.profitID = profitID;
    }

    public int getVariantID() {
        return variantID;
    }

    public void setVariantID(int variantID) {
        this.variantID = variantID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public double getCostPrice() {
        return costPrice;
    }

    public void setCostPrice(double costPrice) {
        this.costPrice = costPrice;
    }

    public LocalDateTime getCalculatedDate() {
        return calculatedDate;
    }

    public void setCalculatedDate(LocalDateTime calculatedDate) {
        this.calculatedDate = calculatedDate;
    }
    
    
}
