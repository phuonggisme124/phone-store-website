package model;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

/**
 * Maps to InstallmentDetail table.
 * Stores installment payment information.
 *
 * @author Hoa Hong Nhung
 */
public class InstallmentDetail {

    private int installmentDetailID;     // PK
    private Integer orderID;              // FK -> Order
    private double amount;
    private LocalDateTime paymentDate;
    private String paymentStatus;
    private int totalMonth;
    private int currentMonth;
    private int expriedDay;

    // --- Default constructor ---
    public InstallmentDetail() {
    }

    // --- Basic constructor ---
    public InstallmentDetail(int installmentDetailID, Integer orderID,
                             double amount, LocalDateTime paymentDate,
                             String paymentStatus) {
        this.installmentDetailID = installmentDetailID;
        this.orderID = orderID;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentStatus = paymentStatus;
    }

    // --- Minimal constructor ---
    public InstallmentDetail(int installmentDetailID) {
        this.installmentDetailID = installmentDetailID;
    }

    // --- Full constructor ---
    public InstallmentDetail(int installmentDetailID, Integer orderID,
                             double amount, LocalDateTime paymentDate,
                             String paymentStatus, int totalMonth,
                             int currentMonth, int expriedDay) {
        this.installmentDetailID = installmentDetailID;
        this.orderID = orderID;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentStatus = paymentStatus;
        this.totalMonth = totalMonth;
        this.currentMonth = currentMonth;
        this.expriedDay = expriedDay;
    }

    /* ================= BUSINESS LOGIC ================= */

    /**
     * Days from paymentDate to now.
     * >0 : overdue
     * =0 : today
     * <0 : not due yet
     */
    public int getExpriedDay() {
        if (paymentDate == null) return 0;
        return (int) ChronoUnit.DAYS.between(paymentDate, LocalDateTime.now());
    }

    /* ================= GETTERS & SETTERS ================= */

    public int getInstallmentDetailID() {
        return installmentDetailID;
    }

    public void setInstallmentDetailID(int installmentDetailID) {
        this.installmentDetailID = installmentDetailID;
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

    public void setExpriedDay(int expriedDay) {
        this.expriedDay = expriedDay;
    }
}
