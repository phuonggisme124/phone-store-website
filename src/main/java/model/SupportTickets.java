/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.time.LocalDateTime;

/**
 *
 * @author USER
 */
public class SupportTickets {

    private int ticketID;
    private Users userID;
    private String subject;
    private String message;
    private Date createdAt;
    private String status;         // "Open", "Closed", ...
    private int assignedStaffID;

    public SupportTickets() {
    }

    public SupportTickets(int ticketID, Users userID, String subject, String message, Date createdAt, String status, int assignedStaffID) {
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

    public Users getUserID() {
        return userID;
    }

    public void setUserID(Users userID) {
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
