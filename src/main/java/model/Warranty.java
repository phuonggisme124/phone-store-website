package model;

import java.sql.Date;

/**
 * Warranty entity
 */
public class Warranty {

    private int warrantyID;
    private int customerID;
    private int variantID;
    private Date soldDay;
    private Date expiryDate;
    private String status;

    public Warranty() {
    }

    public int getWarrantyID() {
        return warrantyID;
    }

    public void setWarrantyID(int warrantyID) {
        this.warrantyID = warrantyID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getVariantID() {
        return variantID;
    }

    public void setVariantID(int variantID) {
        this.variantID = variantID;
    }

    public Date getSoldDay() {
        return soldDay;
    }

    public void setSoldDay(Date soldDay) {
        this.soldDay = soldDay;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
