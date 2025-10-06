/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 * The Suppliers class maps to the Suppliers table in the database.
 * Represents supplier information such as name, contact, and address.
 *
 * @author Hoa Hong Nhung
 */
public class Suppliers {

    // --- Required fields (NOT NULL) ---
    private int supplierID;     // int, NOT NULL (Primary Key)
    private String name;        // nvarchar(100), NOT NULL

    // --- Optional fields (Allow Nulls) ---
    private String phone;       // nvarchar(20), Allow Nulls
    private String email;       // nvarchar(100), Allow Nulls
    private String address;     // nvarchar(255), Allow Nulls

    // --- Default constructor ---
    public Suppliers() {
    }

    /**
     * Full constructor including all fields.
     */
    public Suppliers(int supplierID, String name, String phone, String email, String address) {
        this.supplierID = supplierID;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.address = address;
    }

    /**
     * Minimal constructor for required fields only.
     */
    public Suppliers(int supplierID, String name) {
        this.supplierID = supplierID;
        this.name = name;
        this.phone = null;
        this.email = null;
        this.address = null;
    }

    // --- Getters and Setters ---
    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    // --- Override toString() ---
    @Override
    public String toString() {
        return "Suppliers{" +
                "supplierID=" + supplierID +
                ", name='" + name + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", address='" + address + '\'' +
                '}';
    }
}
