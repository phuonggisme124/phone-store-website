/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 * The Order class maps to the Orders table in the database.
 * It represents a customer's purchase order, including buyer, shipper,
 * payment details, shipping address, and order status.
 *
 * @author ADMIN
 */
public class Order {

    // --- Required fields (NOT NULL) ---
    private int orderID;                // int, NOT NULL (Primary Key)
    private int userID;                 // int, NOT NULL (Foreign Key to Users)
    private String paymentMethod;       // nvarchar(50), NOT NULL
    private String shippingAddress;     // nvarchar(255), NOT NULL
    private double totalAmount;         // decimal, NOT NULL
    private String status;              // nvarchar(50), NOT NULL
    private LocalDateTime orderDate;    // datetime, NOT NULL

    // --- Optional fields (Allow Nulls) ---
    private boolean isInstalment;       // bit, Allow Nulls
    private Users buyer;                // Object reference to the buyer (Users)
    private Users shippers;             // Object reference to the shipper (Users)

    /**
     * Constructor for creating an order with buyer details.
     *
     * @param orderID Order ID
     * @param buyer Buyer information (Users object)
     * @param shippingAddress Shipping address
     * @param totalAmount Total price of the order
     * @param status Order status
     * @param orderDate Date and time when the order was created
     */
    public Order(int orderID, Users buyer, String shippingAddress, double totalAmount, String status, LocalDateTime orderDate) {
        this.orderID = orderID;
        this.buyer = buyer;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
    }

    /**
     * Constructor for staff viewing both buyer and shipper information.
     *
     * @param orderID Order ID
     * @param buyer Buyer information (Users object)
     * @param shippers Shipper information (Users object)
     * @param shippingAddress Shipping address
     * @param totalAmount Total price of the order
     * @param orderDate Date and time when the order was created
     * @param status Order status
     */
    public Order(int orderID, Users buyer, Users shippers, String shippingAddress, double totalAmount, LocalDateTime orderDate, String status) {
        this.orderID = orderID;
        this.buyer = buyer;
        this.shippers = shippers;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
    }

    /**
     * Constructor for order creation including all database fields.
     *
     * @param orderID Order ID
     * @param userID Buyer ID
     * @param paymentMethod Payment method
     * @param shippingAddress Shipping address
     * @param totalAmount Total price of the order
     * @param status Order status
     * @param orderDate Order creation date and time
     * @param isInstalment Whether the order is paid in instalments
     */
    public Order(int orderID, int userID, String paymentMethod, String shippingAddress, double totalAmount, String status, LocalDateTime orderDate, boolean isInstalment) {
        this.orderID = orderID;
        this.userID = userID;
        this.paymentMethod = paymentMethod;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
        this.isInstalment = isInstalment;
    }

    // --- Getters and Setters ---
    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public boolean isIsInstallment() {
        return isInstalment;
    }

    public void setIsInstallment(boolean isInstalment) {
        this.isInstalment = isInstalment;
    }

    public Users getBuyer() {
        return buyer;
    }

    public void setBuyer(Users buyer) {
        this.buyer = buyer;
    }

    public Users getShippers() {
        return shippers;
    }

    public void setShippers(Users shippers) {
        this.shippers = shippers;
    }
}
