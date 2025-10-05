/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal; // Cần import BigDecimal cho kiểu decimal
import java.time.LocalDateTime; // Cần import LocalDateTime cho kiểu datetime
// Giả sử Category đã được định nghĩa ở đâu đó

/**
 * Lớp Product ánh xạ với cấu trúc bảng trong CSDL.
 *
 * @author DELL
 */
public class Product {

    private int productId; // int, NOT NULL (ProductID)
    private Integer categoryId; // int, Allow Nulls (CategoryID) - Sử dụng Integer để chấp nhận null
    private Integer supplierId; // int, Allow Nulls (SupplierID) - Sử dụng Integer để chấp nhận null
    private String name; // nvarchar(100), NOT NULL (Name)
    private String brand; // nvarchar(50), Allow Nulls (Brand)
    private BigDecimal price; // decimal(15, 2), NOT NULL (Price) - Sử dụng BigDecimal cho kiểu decimal/tiền tệ
    private BigDecimal discountPrice; // decimal(15, 2), Allow Nulls (DiscountPrice) - Sử dụng BigDecimal
    private Integer stock; // int, Allow Nulls (Stock) - Sử dụng Integer để chấp nhận null
    private Integer warrantyPeriod; // int, Allow Nulls (WarrantyPeriod) - Sử dụng Integer để chấp nhận null
    private String description; // nvarchar(MAX), Allow Nulls (Description)
    private String imageUrl; // nvarchar(255), Allow Nulls (ImageUrl)
    private LocalDateTime createdAt; // datetime, Allow Nulls (CreatedAt) - Sử dụng LocalDateTime hoặc Date/Timestamp

    // Có thể thêm thuộc tính đối tượng Category nếu muốn ánh xạ mối quan hệ
    // private Category category;

    /**
     * Constructor đầy đủ, bao gồm tất cả các trường.
     * Lưu ý: Các trường 'Allow Nulls' có kiểu dữ liệu là đối tượng (Integer, BigDecimal, String, LocalDateTime)
     */
    public Product(int productId, Integer categoryId, Integer supplierId, String name, String brand, BigDecimal price, BigDecimal discountPrice, Integer stock, Integer warrantyPeriod, String description, String imageUrl, LocalDateTime createdAt) {
        this.productId = productId;
        this.categoryId = categoryId;
        this.supplierId = supplierId;
        this.name = name;
        this.brand = brand;
        this.price = price;
        this.discountPrice = discountPrice;
        this.stock = stock;
        this.warrantyPeriod = warrantyPeriod;
        this.description = description;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    /**
     * Constructor tối thiểu cho các trường NOT NULL.
     */
    public Product(int productId, String name, BigDecimal price) {
        this.productId = productId;
        this.name = name;
        this.price = price;
        // Các trường còn lại sẽ là null hoặc giá trị mặc định của đối tượng
    }

    // Constructor mặc định (cần thiết cho một số framework)
    public Product() {
    }

    // --- Getters và Setters ---

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(BigDecimal discountPrice) {
        this.discountPrice = discountPrice;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public Integer getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public void setWarrantyPeriod(Integer warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // --- Override toString() ---

    @Override
    public String toString() {
        return "Product{" +
                "productId=" + productId +
                ", categoryId=" + categoryId +
                ", supplierId=" + supplierId +
                ", name='" + name + '\'' +
                ", brand='" + brand + '\'' +
                ", price=" + price +
                ", discountPrice=" + discountPrice +
                ", stock=" + stock +
                ", warrantyPeriod=" + warrantyPeriod +
                ", description='" + description + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}