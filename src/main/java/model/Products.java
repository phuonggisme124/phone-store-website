    /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;
import java.util.List;

/**
 * The Products class maps to the Products table in the database.
 * Contains information about products, their category, supplier, and details.
 *
 * @author Hoa Hong Nhung
 */
public class Products {

    // --- Required fields (NOT NULL) ---
    private int productID;         // int, NOT NULL (Primary Key)
    private String name;           // nvarchar(100), NOT NULL
    private String brand;          // nvarchar(50), NOT NULL

    // --- Optional fields (Allow Nulls) ---
    private Integer categoryID;    // int, Allow Nulls
    private Integer supplierID;    // int, Allow Nulls
    private Integer warrantyPeriod;// int, Allow Nulls
    private LocalDateTime createdAt; // datetime, Allow Nulls
    private List<Variants> variants;
    // --- Default constructor ---
    public Products() {
    }

    /**
     * Full constructor including all fields.
     */
    public Products(int productID, Integer categoryID, Integer supplierID, String name,
                    String brand, Integer warrantyPeriod, LocalDateTime createdAt) {
        this.productID = productID;
        this.categoryID = categoryID;
        this.supplierID = supplierID;
        this.name = name;
        this.brand = brand;
        this.warrantyPeriod = warrantyPeriod;
        this.createdAt = createdAt;
    }

    public Products(int productID, String name, LocalDateTime createdAt, List<Variants> variants) {
        this.productID = productID;
        this.name = name;
        this.createdAt = createdAt;
        this.variants = variants;
    }
    
    public Products(int productID, String name) {
        this.productID = productID;
        this.name = name;
    }

    public List<Variants> getVariants() {
        return variants;
    }

    public void setVariants(List<Variants> variants) {
        this.variants = variants;
    }

    /**
     * Minimal constructor for required fields only.
     */
    public Products(int productID, String name, String brand) {
        this.productID = productID;
        this.name = name;
        this.brand = brand;
        this.categoryID = null;
        this.supplierID = null;
        this.warrantyPeriod = null;
        this.createdAt = null;
    }

    // --- Getters and Setters ---
    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public Integer getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(Integer categoryID) {
        this.categoryID = categoryID;
    }

    public Integer getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(Integer supplierID) {
        this.supplierID = supplierID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public Integer getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public void setWarrantyPeriod(Integer warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // --- Override toString() ---
    @Override
    public String toString() {
        return "Products{" +
                "productID=" + productID +
                ", categoryID=" + categoryID +
                ", supplierID=" + supplierID +
                ", name='" + name + '\'' +
                ", brand='" + brand + '\'' +
                ", warrantyPeriod=" + warrantyPeriod +
                ", createdAt=" + createdAt +
                '}';
    }
}
