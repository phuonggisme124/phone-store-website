/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * The Carts class represents a shopping cart in the system.
 * Each cart belongs to a specific user and contains a list of CartItems.
 * 
 * @author USER
 */
public class Carts {

    private int cartID;          // Unique ID of the cart (from SQL database)
    private int userID;          // ID of the user who owns this cart
    private Date createdAt;      // Date when the cart was created
    private List<CartItems> listCartItems;  // List of items in the cart

    // Default constructor
    public Carts() {
    }

    // Full constructor with creation date
    public Carts(int cartID, int userID, Date createdAt) {
        this.cartID = cartID;
        this.userID = userID;
        this.createdAt = createdAt;
    }

    // Constructor initializing an empty list of items
    public Carts(int cartID, List<CartItems> listCartItems) {
        this.cartID = cartID;
        this.listCartItems = listCartItems;
    }

    public List<CartItems> getListCartItems() {
        return listCartItems;
    }

    public void setListCartItems(List<CartItems> listCartItems) {
        this.listCartItems = listCartItems;
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

    // Returns a string representation of the cart (for debugging)
    @Override
    public String toString() {
        return "Carts{" + "cartID=" + cartID + ", userID=" + userID + ", createdAt=" + createdAt + '}';
    }
}
