package model;

import java.time.LocalDateTime;

/**
 * The Order class maps to the Orders table in the database. It represents a
 * customer's purchase order, including buyer, shipper, payment details,
 * shipping address, and order status.
 *
 * @author thinh
 */
public class Order {

    // --- Required fields ---
    private int orderID;
    private int userID;
    private String paymentMethod;
    private String shippingAddress;
    private double totalAmount;
    private String status;
    private LocalDateTime orderDate;

    // --- Optional fields ---
    private boolean isInstalment;
    private Users buyer;
    private Users shippers;
    private String buyerName;
    private String buyerPhone;

    // Constructor 1: Basic order info
    public Order(int orderID, Users buyer, String shippingAddress, double totalAmount, String status, LocalDateTime orderDate) {
        this.orderID = orderID;
        this.buyer = buyer;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
    }

    // Constructor 2: For staff (has shipper info)
    public Order(int orderID, Users buyer, Users shippers, String shippingAddress, double totalAmount, LocalDateTime orderDate, String status) {
        this.orderID = orderID;
        this.buyer = buyer;
        this.shippers = shippers;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
    }

    // Constructor 3: Full data from database (used by DAO)
    public Order(int orderId, int userId, String buyerName, String buyerPhone, String buyerAddress, double totalAmount, String paymentMethod, String status, LocalDateTime orderDate) {
        this.orderID = orderId;
        this.userID = userId;
        this.buyerName = buyerName;
        this.buyerPhone = buyerPhone;
        this.shippingAddress = buyerAddress;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.orderDate = orderDate;
    }

    // Constructor 4: Create order with all DB fields
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

    public boolean isInstalment() {
        return isInstalment;
    }

    public void setInstalment(boolean isInstalment) {
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

    public String getBuyerName() {
        return buyerName;
    }

    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }

    public String getBuyerPhone() {
        return buyerPhone;
    }

    public void setBuyerPhone(String buyerPhone) {
        this.buyerPhone = buyerPhone;
    }
}
