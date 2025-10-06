/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author USER
 */
public class Variants {
     private int variantID;        // ID biến thể
    private int productID;        // ID sản phẩm
    private String color;         // Màu sắc
    private int stock;            // Kho (số lượng tồn)
    private double price;         // Giá gốc
    private Double discountPrice; // Giá chiết khấu (có thể null)
    private String size;          // Cỡ hoặc cổ phần (tùy nghĩa "Cổ phần" Đạt muốn là size)
    private String description;   // Sự miêu tả
    private String imageUrl;      // URL hình ảnh

    public Variants() {
    }

    public Variants(int variantID, int productID, String color, int stock, double price, Double discountPrice, String size, String description, String imageUrl) {
        this.variantID = variantID;
        this.productID = productID;
        this.color = color;
        this.stock = stock;
        this.price = price;
        this.discountPrice = discountPrice;
        this.size = size;
        this.description = description;
        this.imageUrl = imageUrl;
    }
    
    

    public int getVariantID() {
        return variantID;
    }

    public void setVariantID(int variantID) {
        this.variantID = variantID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Double getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(Double discountPrice) {
        this.discountPrice = discountPrice;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "Variants{" + "variantID=" + variantID + ", productID=" + productID + ", color=" + color + ", stock=" + stock + ", price=" + price + ", discountPrice=" + discountPrice + ", size=" + size + ", description=" + description + ", imageUrl=" + imageUrl + '}';
    }
    
    
}
