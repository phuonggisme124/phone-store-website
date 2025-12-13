/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class InterestRate {
    private int interestRateID;
    private int percent;
    private int instalmentPeriod;

    public InterestRate(int percent, int instalmentPeriod) {
        this.percent = percent;
        this.instalmentPeriod = instalmentPeriod;
    }

    public InterestRate(int interestRateID, int percent, int instalmentPeriod) {
        this.interestRateID = interestRateID;
        this.percent = percent;
        this.instalmentPeriod = instalmentPeriod;
    }
    
    

    public int getInterestRateID() {
        return interestRateID;
    }

    public void setInterestRateID(int interestRateID) {
        this.interestRateID = interestRateID;
    }
    
    
    public int getPercent() {
        return percent;
    }

    public void setPercent(int percent) {
        this.percent = percent;
    }

    public int getInstalmentPeriod() {
        return instalmentPeriod;
    }

    public void setInstalmentPeriod(int instalmentPeriod) {
        this.instalmentPeriod = instalmentPeriod;
    }
    
    
}
