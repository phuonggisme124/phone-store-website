/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author USER
 */
public class Import {

    private int importID;
    private int accountID;
    private int supplierID;
    private LocalDateTime importDate;
    private double totalCost;
    private String note;
    private String supplierName;

    public Import() {
    }

    public Import(int importID, int accountID, int supplierID, LocalDateTime importDate, double totalCost, String note) {
        this.importID = importID;
        this.accountID = accountID;
        this.supplierID = supplierID;
        this.importDate = importDate;
        this.totalCost = totalCost;
        this.note = note;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public int getImportID() {
        return importID;
    }

    public void setImportID(int importID) {
        this.importID = importID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public LocalDateTime getImportDate() {
        return importDate;
    }

    public void setImportDate(LocalDateTime importDate) {
        this.importDate = importDate;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getFormattedDate() {
        if (this.importDate == null) {
            return "";
        }
        // Định dạng ngày tháng năm giờ phút
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return this.importDate.format(formatter);
    }
}
