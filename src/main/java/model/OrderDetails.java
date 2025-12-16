/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 * Represents the details of an order, including product variant, quantity, unit
 * price, and installment information.
 *
 * @author USER
 */
public class OrderDetails {

    private int orderID;            
    private int variantID;          
    private int quantity;           
    private double unitPrice;       
    private Variants variant;
   

    

    public OrderDetails() {
    }

    // Constructor for non-installment purchases
    public OrderDetails(int orderID, int variantID, int quantity, double unitPrice) {
        this.orderID = orderID;
        this.variantID = variantID;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public OrderDetails(int orderID, int quantity, double unitPrice, Variants variant) {
        this.orderID = orderID;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
      
        this.variant = variant;
    }


    // GETTER - SETTER

    public Variants getVariant() {
        return variant;
    }

    public void setVariant(Variants variant) {
        this.variant = variant;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getVariantID() {
        return variantID;
    }

    public void setVariantID(int variantID) {
        this.variantID = variantID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    @Override
    public String toString() {
        return "OrderDetails{"
                + "orderID=" + orderID
                + ", VariantID=" + variantID
                + ", quantity=" + quantity
                + ", unitPrice=" + unitPrice
                + '}';
    }
}
