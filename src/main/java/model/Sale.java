/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class Sale {
     private int saleID;
    private Order order;
    private Users shipper;  

    public Sale(int saleID, Order order, Users shipper) {
        this.saleID = saleID;
        this.order = order;
        this.shipper = shipper;
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
