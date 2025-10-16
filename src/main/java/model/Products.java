/*
 * Represents a product in the system.
 * Maps to the Products table in the database.
 */
package model;

import java.time.LocalDateTime;
import java.util.List;

/**
 * The Products class stores information about products, including
 * their category, supplier, brand, warranty, creation date, and variants.
 */
public class Products {

    // =========================================================
    //  Required fields (NOT NULL in database)
    // =========================================================
    private int productID;         // Unique ID of the product (Primary Key)
    private String name;           // Product name (NOT NULL)
    private String brand;          // Product brand (NOT NULL)

    // =========================================================
    //  Optional fields (Nullable in database)
    // =========================================================
    private Integer categoryID;    // Category ID of the product (nullable)
    private Integer supplierID;    // Supplier ID of the product (nullable)
    private Integer warrantyPeriod;// Warranty period in months (nullable)
    private LocalDateTime createdAt; // Creation date of the product record (nullable)
    private List<Variants> variants; // List of variants for this product (nullable)

    // =========================================================
    //  Default constructor - creates an empty product object
    // =========================================================
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

    /**
     * Constructor with selected fields including variants.
     */
    public Products(int productID, String name, LocalDateTime createdAt, List<Variants> variants) {
        this.productID = productID;
        this.name = name;
        this.createdAt = createdAt;
        this.variants = variants;
    }

    /**
     * Constructor with only ID and name.
     */
    public Products(int productID, String name) {
        this.productID = productID;
        this.name = name;
    }

    /**
     * Full constructor including variants.
     */
    public Products(int productID, int categoryID, int supplierID, String name, String brand,
                    int warrantyPeriod, LocalDateTime createdAt, List<Variants> variants) {
        this.productID = productID;
        this.categoryID = categoryID;
        this.supplierID = supplierID;
        this.name = name;
        this.brand = brand;
        this.warrantyPeriod = warrantyPeriod;
        this.createdAt = createdAt;
        this.variants = variants;
    }

    // Getter and Setter for variants
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

    // =========================================================
    //  Getters and Setters for all fields
    // =========================================================
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

    // =========================================================
    //  toString() - Returns a string representation of the product
    // =========================================================
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
