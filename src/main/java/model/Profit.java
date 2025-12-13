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
    
    private LocalDateTime calculatedDate;
    private String productName;
    private String storage;
    private String color;
    private String variantImage;

    public Profit() {
    }

    public Profit(int profitID, int variantID, int quantity, double sellingPrice, LocalDateTime calculatedDate) {
        this.profitID = profitID;
        this.variantID = variantID;
        this.quantity = quantity;
        this.sellingPrice = sellingPrice;
        
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

    

    public LocalDateTime getCalculatedDate() {
        return calculatedDate;
    }

    public void setCalculatedDate(LocalDateTime calculatedDate) {
        this.calculatedDate = calculatedDate;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getStorage() {
        return storage;
    }

    public void setStorage(String storage) {
        this.storage = storage;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getVariantImage() {
        return variantImage;
    }

    public void setVariantImage(String variantImage) {
        this.variantImage = variantImage;
    }
    
    
}
