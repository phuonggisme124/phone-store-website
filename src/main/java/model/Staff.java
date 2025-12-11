package model;

import java.sql.Date;
import java.time.LocalDateTime;

public class Staff {

    private int id;
    private String fullName;
   private LocalDateTime createdAt;
    private double rate; 
    private double totalsalary;

    public Staff(int id, String fullName, LocalDateTime createdAt, double rate) {
        this.id = id;
        this.fullName = fullName;
        this.createdAt = createdAt;
        this.rate = rate;
        this.totalsalary  = 5000000 * rate;
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

    

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public double getTotalsalary() {
        return totalsalary;
    }

    public void setTotalsalary(double totalsalary) {
        this.totalsalary = totalsalary;
    }

}
