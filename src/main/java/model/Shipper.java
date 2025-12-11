package model;

import java.sql.Date;
import java.time.LocalDateTime;

public class Shipper {

    private int id;
    private String fullName;
    private LocalDateTime createdAt;
    private double commission; 
    private double rate;     
    private double totalSalary;
    

    public Shipper(int id, String fullName, LocalDateTime createdAt, double commission, double rate) {
        this.id = id;
        this.fullName = fullName;
        this.createdAt = createdAt;
        this.commission = commission;
        this.rate = rate;
        this.totalSalary = 4000000 * rate * commission;
    }

   
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

   

    public double getCommission() {
        return commission;
    }

    public void setCommission(double commission) {
        this.commission = commission;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public double getTotalSalary() {
        return totalSalary;
    }

    public void setTotalSalary(double totalSalary) {
        this.totalSalary = totalSalary;
    }
    

}
