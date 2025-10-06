/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author USER
 */
public class Payment {
    private int paymentID;
    private int orderID;
    private double amount;
    private Timestamp paymentDate;
    private String paymentStatus;

    public Payment() {
    }
    
    

    public Payment(int paymentID, int orderID, double amount, Timestamp paymentDate, String paymentStatus) {
        this.paymentID = paymentID;
        this.orderID = orderID;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentStatus = paymentStatus;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    @Override
    public String toString() {
        return "Payment{" + "paymentID=" + paymentID + ", orderID=" + orderID + ", amount=" + amount + ", paymentDate=" + paymentDate + ", paymentStatus=" + paymentStatus + '}';
    }
  
}
