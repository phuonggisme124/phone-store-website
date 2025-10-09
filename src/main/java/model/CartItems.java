/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author USER
 */
public class CartItems {
    private int cartItemsID;
    private int cartID;
    private Products products;
    private int quantity;
    private double price;
    //Contructor to see information of items into cart
    public CartItems(int cartItemsID, int cartID, int quantity, Products products) {
        this.cartItemsID = cartItemsID;
        this.cartID = cartID;
        this.quantity = quantity;
        this.products = products;
    }

    public int getCartItemsID() {
        return cartItemsID;
    }

    public void setCartItemsID(int cartItemsID) {
        this.cartItemsID = cartItemsID;
    }

    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuality(int quantity) {
        this.quantity = quantity;
    }

    public Products getProducts() {
        return products;
    }

    public void setProducts(Products products) {
        this.products = products;
    }
    
    public double getTotalPrice() {
        return this.price * this.quantity;
    }
    public void setPrice(double price) {
    this.price = price;
}
  
}
