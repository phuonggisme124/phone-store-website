/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author USER
 */
public class OrderDetails {
    private int orderID;
    private int procductID;
    private int quanlity;
    private double unitPrice;

    public OrderDetails(int orderID, int procductID, int quanlity, double unitPrice) {
        this.orderID = orderID;
        this.procductID = procductID;
        this.quanlity = quanlity;
        this.unitPrice = unitPrice;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getProcductID() {
        return procductID;
    }

    public void setProcductID(int procductID) {
        this.procductID = procductID;
    }

    public int getQuanlity() {
        return quanlity;
    }

    public void setQuanlity(int quanlity) {
        this.quanlity = quanlity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    @Override
    public String toString() {
        return "OrderDetails{" + "orderID=" + orderID + ", procductID=" + procductID + ", quanlity=" + quanlity + ", unitPrice=" + unitPrice + '}';
    }
    
    
}
