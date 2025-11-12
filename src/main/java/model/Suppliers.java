/*
 * This class represents the Suppliers entity in the database.
 * It is used to store supplier-related information such as name, contact, and address.
 */
package model;

/**
 * The Suppliers class maps to the Suppliers table in the database.
 * Represents supplier information including name, contact details, and address.
 */
public class Suppliers {

    // =========================================================
    //  Required fields (NOT NULL in database)
    // =========================================================
    private int supplierID;     // int, Primary Key (NOT NULL)
    private String name;        // nvarchar(100), Supplier name (NOT NULL)

    // =========================================================
    //  Optional fields (Nullable in database)
    // =========================================================
    private String phone;       // nvarchar(20), Supplier phone number (nullable)
    private String email;       // nvarchar(100), Supplier email (nullable)
    private String address;     // nvarchar(255), Supplier address (nullable)

    // =========================================================
    //  Default constructor - used when creating an empty supplier object
    // =========================================================
    public Suppliers() {
    }

    /**
     * Full constructor including all fields.
     * Used when retrieving or inserting a complete supplier record.
     */
    public Suppliers(int supplierID, String name, String phone, String email, String address) {
        this.supplierID = supplierID;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.address = address;
    }

    /**
     * Constructor with only required fields.
     * Useful when optional data is not available or will be added later.
     */
    public Suppliers(int supplierID, String name) {
        this.supplierID = supplierID;
        this.name = name;

        // Set optional fields to null by default
        this.phone = null;
        this.email = null;
        this.address = null;
    }

    // =========================================================
    //  Getters and Setters - Accessor methods for each field
    // =========================================================
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

    // =========================================================
    //  toString() - Returns a readable string representation of the object
    // =========================================================
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
