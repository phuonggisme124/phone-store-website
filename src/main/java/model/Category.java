/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 * Lớp Category ánh xạ với cấu trúc bảng trong CSDL.
 *
 * @author nhóm 2
 */
public class Category {
    // Tên thuộc tính đổi từ snake_case (cat_id) sang camelCase (categoryId)

    private int categoryId;             // int, NOT NULL (CategoryID)
    private String categoryName;        // nvarchar(100), NOT NULL (CategoryName)
    private String description;         // nvarchar(MAX), Allow Nulls (Description)

    /**
     * Constructor đầy đủ, bao gồm cả trường description có thể null.
     */
    public Category(int categoryId, String categoryName, String description) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description; // description có thể là null
    }

    /**
     * Constructor tối thiểu cho các trường NOT NULL.
     */
    public Category(int categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = null; // Gán mặc định là null cho trường Allow Nulls
    }

    // Constructor mặc định (nên có)
    public Category() {
    }

    // --- Getters và Setters ---
    
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // --- Override toString() ---

    @Override
    public String toString() {
        return "Category{" + 
                "categoryId=" + categoryId + 
                ", categoryName='" + categoryName + '\'' + 
                ", description='" + description + '\'' + 
                '}';
    }
}