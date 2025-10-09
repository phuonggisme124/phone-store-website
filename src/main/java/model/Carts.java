/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author USER
 */
public class Carts {

    private int cartID;          // CartID từ SQL
    private int userID;          // UserID, nếu chỉ lưu ID
    private Date createdAt;  // CreatedAt
    private List<CartItems> listCartItems;
    public Carts() {
    }

    public Carts(int cartID, int userID, Date createdAt) {
        this.cartID = cartID;
        this.userID = userID;
        this.createdAt = createdAt;
    }
    
     public Carts(int cartID, int userID) {
        this.cartID = cartID;
        this.userID = userID;
        listCartItems = new ArrayList<>();
    }

    public List<CartItems> getListCartItems() {
        return this.listCartItems;
    }

    public void setListCartItems(CartItems item) {
        this.listCartItems.add(item);
    }
  
    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
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
