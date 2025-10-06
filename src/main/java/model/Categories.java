/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 * The Categories class maps to the Categories table in the database.
 * Represents product categories and their descriptions.
 *
 * @author Hoa Hong Nhung
 */
public class Categories {

    // --- Required fields (NOT NULL) ---
    private int categoryID;        // int, NOT NULL (Primary Key)
    private String categoryName;   // nvarchar(100), NOT NULL

    // --- Optional fields (Allow Nulls) ---
    private String description;    // nvarchar(MAX), Allow Nulls

    // --- Default constructor ---
    public Categories() {
    }

    /**
     * Full constructor including all fields.
     */
    public Categories(int categoryID, String categoryName, String description) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.description = description;
    }

    /**
     * Minimal constructor for required fields only.
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
