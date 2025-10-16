/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 *
 * @author thinh
 */
public class Order {
    private int orderID;
    private Users buyer;          
    private int userID;
    private String paymentMethod;
    private Users shippers;

    // Bổ sung các trường cần thiết để lưu thông tin người mua (từ bảng Orders trong DAO)
    private String buyerName;
    private String buyerPhone;

    
    public Order(int orderID, Users buyer, String shippingAddress, double totalAmount, String status, LocalDateTime orderDate) {

        this.orderID = orderID;
        this.buyer = buyer;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
    }
    
    //Constructor for staff can see buyer and shipper information
      public Order(int orderID, Users buyer, Users shippers, String shippingAddress, double totalAmount, LocalDateTime orderDate, String status) {
        this.orderID = orderID;
        this.buyer = buyer;
        this.shippers = shippers;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
    }

    // Constructor mới được triển khai để khớp với OrderDAO.getOrdersByPhoneForStaff
    public Order(int orderId, int userId, String buyerName, String buyerPhone, String buyerAddress, double totalAmount, String paymentMethod, String status, LocalDateTime orderDate) {
        this.orderID = orderId;
        this.userID = userId;
        this.buyerName = buyerName;
        this.buyerPhone = buyerPhone;
        this.shippingAddress = buyerAddress; // buyerAddress từ DB -> shippingAddress trong Model
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.orderDate = orderDate;
        this.buyer = null; // Buyer object chưa được fetch
        this.shippers = null; // Shipper object chưa được fetch
    }

    public Users getShippers() {
        return shippers;
    }

    public void setShippers(Users shippers) {
        this.shippers = shippers;
    }
    
    private String shippingAddress;
    private double totalAmount;
    private String status;
    private LocalDateTime orderDate;
    private boolean isInstalment;

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

    public boolean isIsInstallment() {
        return isInstalment;
    }

    public void setIsInstallment(boolean isInstalment) {
        this.isInstalment = isInstalment;
    }
    
    
    
    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }
    
    // Getters and Setters cho các trường mới (buyerName, buyerPhone)
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
    

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public Users getBuyer() {
        return buyer;
    }

    public void setBuyer(Users buyer) {
        this.buyer = buyer;
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
}
