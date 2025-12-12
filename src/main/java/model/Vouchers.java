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
public class Vouchers {
    private int voucherID;
    private String code;
    private int percentDiscount;
    private Date startDay;
    private Date endDay;
    private int quantity;
    private String status;

    public Vouchers() {
    }

    public Vouchers(int voucherID, String code, int percentDiscount, Date startDay, Date endDay, int quantity, String status) {
        this.voucherID = voucherID;
        this.code = code;
        this.percentDiscount = percentDiscount;
        this.startDay = startDay;
        this.endDay = endDay;
        this.quantity = quantity;
        this.status = status;
    }
    
    public int getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(int voucherID) {
        this.voucherID = voucherID;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getPercentDiscount() {
        return percentDiscount;
    }

    public void setPercentDiscount(int percentDiscount) {
        this.percentDiscount = percentDiscount;
    }

    public Date getStartDay() {
        return startDay;
    }

    public void setStartDay(Date startDay) {
        this.startDay = startDay;
    }

    public Date getEndDay() {
        return endDay;
    }

    public void setEndDay(Date endDay) {
        this.endDay = endDay;
    }



    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    
}
