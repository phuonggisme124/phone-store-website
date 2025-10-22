/*
 * Represents a sale record related to an order.
 */
package model;

import java.time.LocalDateTime;

/**
 * The Sale class stores information about each sale transaction,
 * including order details, shipper, staff, and creation time.
 */
public class Sale {
    
    // Unique ID of the sale record (primary key)
    private int saleID;
    
    // The Order object associated with this sale
    private Order order;
    
    // The Users object representing the assigned shipper
    private Users shipper;  
    
    // The Users object representing the assigned shipper
    private Users staff;  
    
    // Shipper ID (foreign key)
    private int shipperID;
    
    // Staff ID (foreign key for the staff who handled the order)
    private int staffID;
    
    // Order ID (foreign key for the related order)
    private int orderID;
    
    // Timestamp when the sale record was created
    private LocalDateTime createAt;

    /**
     * Constructor using full objects (Order and Users).
     * Typically useful when loading joined data with objects.
     * 
     * @param saleID the sale record ID
     * @param order the order object
     * @param shipper the shipper (user) object
     */
    public Sale(int saleID, Order order, Users shipper) {
        this.saleID = saleID;
        this.order = order;
        this.shipper = shipper;
    }

    /**
     * Constructor using only IDs and created time.
     * Typically useful when working with database-level data.
     * 
     * @param saleID the sale record ID
     * @param shipperID the shipper ID
     * @param staffID the staff ID
     * @param orderID the order ID
     * @param createAt the creation time of this sale record
     */
    public Sale(int saleID, int shipperID, int staffID, int orderID, LocalDateTime createAt) {
        this.saleID = saleID;
        this.shipperID = shipperID;
        this.staffID = staffID;
        this.orderID = orderID;
        this.createAt = createAt;
    }

    public Sale(int saleID, Users shipper, Users staff, int orderID, LocalDateTime createAt) {
        this.saleID = saleID;
        this.shipper = shipper;
        this.staff = staff;
        this.orderID = orderID;
        this.createAt = createAt;
    }
    
    
    

    public Users getStaff() {
        return staff;
    }

    public void setStaff(Users staff) {
        this.staff = staff;
    }
    
    

    // Getter and Setter for staffID
    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }

    // Getter and Setter for createAt
    public LocalDateTime getCreateAt() {
        return createAt;
    }

    public void setCreateAt(LocalDateTime createAt) {
        this.createAt = createAt;
    }

    // Getter and Setter for shipperID
    public int getShipperID() {
        return shipperID;
    }

    public void setShipperID(int shipperID) {
        this.shipperID = shipperID;
    }

    // Getter and Setter for orderID
    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    // Getter and Setter for saleID
    public int getSaleID() {
        return saleID;
    }

    public void setSaleID(int saleID) {
        this.saleID = saleID;
    }

    // Getter and Setter for order object
    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    // Getter and Setter for shipper object
    public Users getShipper() {
        return shipper;
    }

    public void setShipper(Users shipper) {
        this.shipper = shipper;
    }
}
