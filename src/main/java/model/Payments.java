/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * The Payments class maps to the Payments table in the database.
 * Stores information about order payments and transaction details.
 * 
 * @author Hoa Hong Nhung
 */
public class Payments {

    // --- Required fields (NOT NULL) ---
    private int paymentID;        // int, NOT NULL (Primary Key)

    // --- Optional fields (Allow Nulls) ---
    private Integer orderID;      // int, Allow Nulls
    private double amount;    // decimal(15,2), Allow Nulls
    private LocalDateTime paymentDate; // datetime, Allow Nulls
    private String paymentStatus; // nvarchar(20), Allow Nulls
    private int totalMonth;
    private int currentMonth;
    // --- Default constructor ---
    public Payments() {
    }

    /**
     * Full constructor including all fields.
     */
    public Payments(int paymentID, Integer orderID, double amount, LocalDateTime paymentDate, String paymentStatus) {
        this.paymentID = paymentID;
        this.orderID = orderID;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentStatus = paymentStatus;
    }

    /**
     * Minimal constructor for required fields only.
     */
    public Payments(int paymentID) {
        this.paymentID = paymentID;
        this.orderID = null;
        this.amount = 0;
        this.paymentDate = null;
        this.paymentStatus = null;
    }

    public Payments(int paymentID, Integer orderID, double amount, LocalDateTime paymentDate, String paymentStatus, int totalMonth, int currentMonth) {
        this.paymentID = paymentID;
        this.orderID = orderID;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentStatus = paymentStatus;
        this.totalMonth = totalMonth;
        this.currentMonth = currentMonth;
    }
    
    

    public int getTotalMonth() {
        return totalMonth;
    }

    public void setTotalMonth(int totalMonth) {
        this.totalMonth = totalMonth;
    }

    public int getCurrentMonth() {
        return currentMonth;
    }

    public void setCurrentMonth(int currentMonth) {
        this.currentMonth = currentMonth;
    }
    
    
    
    // --- Getters and Setters ---
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    // --- Override toString() ---
    @Override
    public String toString() {
        return "Payments{" +
                "paymentID=" + paymentID +
                ", orderID=" + orderID +
                ", amount=" + amount +
                ", paymentDate=" + paymentDate +
                ", paymentStatus='" + paymentStatus + '\'' +
                '}';
    }
}
