/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author ADMIN
 */
public class Sale {
     private int saleID;
    private Order order;
    private Users shipper;  
    private int shipperID;
    private int staffID;
    private int orderID;
    private LocalDateTime createAt;
    public Sale(int saleID, Order order, Users shipper) {
        this.saleID = saleID;
        this.order = order;
        this.shipper = shipper;
    }

    public Sale(int saleID, int shipperID, int staffID, int orderID, LocalDateTime createAt) {
        this.saleID = saleID;
        this.shipperID = shipperID;
        this.staffID = staffID;
        this.orderID = orderID;
        this.createAt = createAt;
    }
    
    

    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }

    

    public LocalDateTime getCreateAt() {
        return createAt;
    }

    public void setCreateAt(LocalDateTime createAt) {
        this.createAt = createAt;
    }
    
    
    
    public int getShipperID() {
        return shipperID;
    }

    public void setShipperID(int shipperID) {
        this.shipperID = shipperID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }
    
    
    
    
    public int getSaleID() {
        return saleID;
    }

    public void setSaleID(int saleID) {
        this.saleID = saleID;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Users getShipper() {
        return shipper;
    }

    public void setShipper(Users shipper) {
        this.shipper = shipper;
    }
}
