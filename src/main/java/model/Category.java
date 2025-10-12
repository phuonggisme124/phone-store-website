/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 * The Category class maps to the Category table in the database.
 * Represents a product category with its name and optional description.
 *
 * This class follows the camelCase naming convention for attributes.
 * Example: "cat_id" in the database is mapped to "categoryId" in Java.
 *
 * @author Group 2
 */
public class Category {

    // --- Fields ---
    private int categoryId;       // int, NOT NULL (Primary Key)
    private String categoryName;  // nvarchar(100), NOT NULL
    private String description;   // nvarchar(MAX), Allow Nulls

    /**
     * Full constructor including all fields.
     * @param categoryId The unique ID of the category.
     * @param categoryName The name of the category.
     * @param description The description of the category (nullable).
     */
    public Category(int categoryId, String categoryName, String description) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description; // May be null
    }

    /**
     * Minimal constructor for required (NOT NULL) fields.
     * @param categoryId The unique ID of the category.
     * @param categoryName The name of the category.
     */
    public Category(int categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = null; // Default value for optional field
    }

    /**
     * Default no-argument constructor.
     */
    public Category() {
    }

    // --- Getters and Setters ---
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
