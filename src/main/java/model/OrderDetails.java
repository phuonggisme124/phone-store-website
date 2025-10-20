/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 * Represents the details of an order, including product variant,
 * quantity, unit price, and installment information.
 * 
 * @author USER
 */
public class OrderDetails {
    private int orderID;            // Unique ID of the order
    private int variantID;          // ID of the product variant in this order
    private int quantity;           // Quantity of the product variant ordered
    private double unitPrice;       // Price per unit of the product variant
    private int instalmentPeriod;   // Installment period (number of months)
    private double monthlyPayment;  // Monthly payment amount for the installment
    private double downPayment;     // Down payment made at the beginning
    private int interestRate;       // Interest rate applied to the installment

    // Constructor for non-installment purchases
    public OrderDetails(int orderID, int variantID, int quantity, double unitPrice) {
        this.orderID = orderID;
        this.variantID = variantID;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    // Constructor for installment purchases
    public OrderDetails(int orderID, int variantID, int quantity, double unitPrice, int instalmentPeriod, double monthlyPayment, double downPayment, int interestRate) {
        this.orderID = orderID;
        this.variantID = variantID;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.instalmentPeriod = instalmentPeriod;
        this.monthlyPayment = monthlyPayment;
        this.downPayment = downPayment;
        this.interestRate = interestRate;
    }

    public int getInstalmentPeriod() {
        return instalmentPeriod;
    }

    public void setInstalmentPeriod(int instalmentPeriod) {
        this.instalmentPeriod = instalmentPeriod;
    }
    // GETTER - SETTER
    public int getIntallmentPeriod() {
        return instalmentPeriod;
    }

    public void setIntallmentPeriod(int instalmentPeriod) {
        this.instalmentPeriod = instalmentPeriod;
    }

    public double getMonthlyPayment() {
        return monthlyPayment;
    }

    public void setMonthlyPayment(double monthlyPayment) {
        this.monthlyPayment = monthlyPayment;
    }

    public double getDownPayment() {
        return downPayment;
    }

    public void setDownPayment(double downPayment) {
        this.downPayment = downPayment;
    }

    public int getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(int interestRate) {
        this.interestRate = interestRate;
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
        return "OrderDetails{" + 
               "orderID=" + orderID + 
               ", VariantID=" + variantID + 
               ", quantity=" + quantity + 
               ", unitPrice=" + unitPrice + 
               '}';
    }
}
