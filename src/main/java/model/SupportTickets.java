/*
 * This class represents a record in the SupportTickets table.
 * It is used to store support requests created by users, including
 * ticket details, status, assigned staff, etc.
 */
package model;

import java.sql.Date;

/**
 * The SupportTickets class maps to the structure of the support ticket entity.
 */
public class SupportTickets {

    private int ticketID;          // ID of the support ticket (Primary Key)
    private Customer userID;          // User who created the ticket (FK to Customer)
    private String subject;        // Short title or subject of the issue
    private String message;        // Detailed description of the issue
    private Date createdAt;        // Date when the ticket was created
    private String status;         // Ticket status: "Open", "Closed", etc.
    private int assignedStaffID;   // ID of the staff assigned to handle the ticket

    // Default constructor
    public SupportTickets() {
    }

    // Full-argument constructor
    public SupportTickets(int ticketID, Customer userID, String subject, String message, Date createdAt, String status, int assignedStaffID) {
        this.ticketID = ticketID;
        this.userID = userID;
        this.subject = subject;
        this.message = message;
        this.createdAt = createdAt;
        this.status = status;
        this.assignedStaffID = assignedStaffID;
    }

    public int getTicketID() {
        return ticketID;
    }

    public void setTicketID(int ticketID) {
        this.ticketID = ticketID;
    }

    public Customer getUserID() {
        return userID;
    }

    public void setUserID(Customer userID) {
        this.userID = userID;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getAssignedStaffID() {
        return assignedStaffID;
    }

    public void setAssignedStaffID(int assignedStaffID) {
        this.assignedStaffID = assignedStaffID;
    }

    @Override
    public String toString() {
        return "SupportTickets{" + "ticketID=" + ticketID + ", userID=" + userID + ", subject=" + subject + ", message=" + message + ", createdAt=" + createdAt + ", status=" + status + ", assignedStaffID=" + assignedStaffID + '}';
    }
}
