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
public class Carts {

    private int cartID;          // CartID từ SQL
    private Users userID;          // UserID, nếu chỉ lưu ID
    private Date createdAt;  // CreatedAt

    public Carts() {
    }

    public Carts(int cartID, Users userID, Date createdAt) {
        this.cartID = cartID;
        this.userID = userID;
        this.createdAt = createdAt;
    }

  
    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public Users getUserID() {
        return userID;
    }

    public void setUserID(Users userID) {
        this.userID = userID;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

  

    @Override
    public String toString() {
        return "Carts{" + "cartID=" + cartID + ", userID=" + userID + ", createdAt=" + createdAt + '}';
    }

}
