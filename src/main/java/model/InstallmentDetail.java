/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

/**
 * The Payments class maps to the Payments table in the database.  
 * Stores information about payments, transaction details, and installment progress.
 * 
 * @author Hoa Hong Nhung
 */
public class InstallmentDetail {

    private int InstallmentDetailID;              // int, NOT NULL (Primary Key)
    private Integer orderID;            // int, Allow Nulls — reference to the related Order
    private double amount;              // decimal(15,2), Allow Nulls — payment amount
    private LocalDateTime paymentDate;  // datetime, Allow Nulls — date and time of the payment
    private String paymentStatus;       // nvarchar(20), Allow Nulls — payment state (e.g., "Paid", "Pending")
    private int totalMonth;             // total number of months for installment payments
    private int currentMonth;           // current month in the installment plan
    private int expriedDay;
    // --- Default constructor ---
    public InstallmentDetail() {
    }

    public int getExpriedDay() {
            return (int) ChronoUnit.DAYS.between(this.paymentDate, LocalDateTime.now());

    }

    public void setExpriedDay(int expriedDay) {
        this.expriedDay = expriedDay;
    }


    public InstallmentDetail(int InstallmentDetailID, Integer orderID, double amount, LocalDateTime paymentDate, String paymentStatus) {
        this.InstallmentDetailID = InstallmentDetailID;
        this.orderID = orderID;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentStatus = paymentStatus;
    }

  
    public InstallmentDetail(int InstallmentDetailID) {
        this.InstallmentDetailID = InstallmentDetailID;
        this.orderID = null;
        this.amount = 0;
        this.paymentDate = null;
        this.paymentStatus = null;
    }

    // --- Extended constructor including installment fields ---
    public InstallmentDetail(int InstallmentDetailID, Integer orderID, double amount, LocalDateTime paymentDate, String paymentStatus, int totalMonth, int currentMonth, int expriedDay) {
        this.InstallmentDetailID = InstallmentDetailID;
        this.orderID = orderID;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentStatus = paymentStatus;
        this.totalMonth = totalMonth;
        this.currentMonth = currentMonth;
        this.expriedDay = expriedDay;
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

    public int getInstallmentDetailID() {
        return InstallmentDetailID;
    }

    public void setInstallmentDetailID(int InstallmentDetailID) {
        this.InstallmentDetailID = InstallmentDetailID;
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

}
