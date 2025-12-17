package model;

import java.sql.Date;

/**
 * Warranty Claim entity
 */
public class WarrantyClaim {

    private int claimID;
    private int warrantyID;
    private String reason;
    private Date requestDate;
    private String status;
    private String adminNote;

    public WarrantyClaim() {
    }

    public WarrantyClaim(int claimID, int warrantyID, String reason,
                         Date requestDate, String status, String adminNote) {
        this.claimID = claimID;
        this.warrantyID = warrantyID;
        this.reason = reason;
        this.requestDate = requestDate;
        this.status = status;
        this.adminNote = adminNote;
    }

    public int getClaimID() {
        return claimID;
    }

    public void setClaimID(int claimID) {
        this.claimID = claimID;
    }

    public int getWarrantyID() {
        return warrantyID;
    }

    public void setWarrantyID(int warrantyID) {
        this.warrantyID = warrantyID;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminNote() {
        return adminNote;
    }

    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }
}
