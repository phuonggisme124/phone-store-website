/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

/**
 *
 * @author USER
 */
public class VoucherCustomer {

    private int voucherID;
    private int customerID;
    private Date assignedDate;
    private String status;

    public VoucherCustomer() {
    }

    public VoucherCustomer(int voucherID, int customerID, Date assignedDate, String status) {
        this.voucherID = voucherID;
        this.customerID = customerID;
        this.assignedDate = assignedDate;
        this.status = status;
    }

   

    public int getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(int voucherID) {
        this.voucherID = voucherID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public Date getAssignedDate() {
        return assignedDate;
    }

    public void setAssignedDate(Date assignedDate) {
        this.assignedDate = assignedDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    

}
