/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 * The Categories class maps to the Categories table in the database.
 * This class represents product categories and their related information.
 * Each category has an ID, a name, and an optional description.
 * 
 * Used to organize products into meaningful groups.
 * 
 * @author Hoa Hong Nhung
 */
public class Categories {

    // --- Required fields (NOT NULL) ---
    private int categoryID;        // Unique ID of the category (Primary Key)
    private String categoryName;   // Name of the category (cannot be null)

    // --- Optional fields (Allow Nulls) ---
    private String description;    // Description of the category (can be null)

    // --- Default constructor ---
    public Categories() {
    }

    /**
     * Full constructor including all fields.
     * @param categoryID The unique ID of the category.
     * @param categoryName The name of the category.
     * @param description The description of the category.
     */
    public Categories(int categoryID, String categoryName, String description) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.description = description;
    }

    /**
     * Minimal constructor for required fields only.
     * @param categoryID The unique ID of the category.
     * @param categoryName The name of the category.
     */
    public Categories(int categoryID, String categoryName) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.description = null;
    }

    // --- Getters and Setters ---
    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
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
        return "Categories{" +
                "categoryID=" + categoryID +
                ", categoryName='" + categoryName + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
