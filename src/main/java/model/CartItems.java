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
    private int variantID;
    private Variants variants;
    private int quantity;
    private double price;

    //Contructor to see information of items into cart
    public CartItems(int cartItemsID, int cartID, int quantity, Variants variants) {
        this.cartItemsID = cartItemsID;
        this.cartID = cartID;
        this.quantity = quantity;
        this.variants = variants;
    }

    public CartItems(int cartItemsID, int cartID, int variantID, int quantity) {
        this.cartItemsID = cartItemsID;
        this.cartID = cartID;
        this.variantID = variantID;
        this.quantity = quantity;
    }
    
    
    

    public int getVariantID() {
        return variantID;
    }

    public void setVariantID(int variantID) {
        this.variantID = variantID;
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

    public Variants getVariants() {
        return variants;
    }

    public void setVariants(Variants variants) {
        this.variants = variants;
    }

    public double getTotalPrice() {
        return this.price * this.quantity;
    }

    public void setPrice(double price) {
        this.price = price;
    }

}
