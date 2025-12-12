/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.time.LocalDateTime;

/**
 *
 * @author ADMIN
 */
public class Customer {
    private int customerID;
    private String cCCD;
    private int point;
    private LocalDateTime YOB;

    public Customer(int customerID, String cCCD, int point, LocalDateTime YOB) {
        this.customerID = customerID;
        this.cCCD = cCCD;
        this.point = point;
        this.YOB = YOB;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getcCCD() {
        return cCCD;
    }

    public void setcCCD(String cCCD) {
        this.cCCD = cCCD;
    }

    public int getPoint() {
        return point;
    }

    public void setPoint(int point) {
        this.point = point;
    }

    public LocalDateTime getYOB() {
        return YOB;
    }

    public void setYOB(LocalDateTime YOB) {
        this.YOB = YOB;
    }

    
}
