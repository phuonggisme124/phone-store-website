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
    private int variantID;
    private int quanlity;
    private double unitPrice;
    
    private int instalmentPeriod;
    private double monthlyPayment;
    private double downPayment;
    private int interestRate;

    public OrderDetails(int orderID, int variantID, int quanlity, double unitPrice) {
        this.orderID = orderID;
        this.variantID = variantID;
        this.quanlity = quanlity;
        this.unitPrice = unitPrice;
    }

    public OrderDetails(int orderID, int variantID, int quanlity, double unitPrice, int instalmentPeriod, double monthlyPayment, double downPayment, int interestRate) {
        this.orderID = orderID;
        this.variantID = variantID;
        this.quanlity = quanlity;
        this.unitPrice = unitPrice;
        
        this.instalmentPeriod = instalmentPeriod;
        this.monthlyPayment = monthlyPayment;
        this.downPayment = downPayment;
        this.interestRate = interestRate;
    }

   

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
        return "OrderDetails{" + "orderID=" + orderID + ", VariantID=" + variantID + ", quanlity=" + quanlity + ", unitPrice=" + unitPrice + '}';
    }
    
    
}
