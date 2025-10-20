/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author USER
 */
// Class representing items in the shopping cart
public class CartItems {

    private int cartID;       // ID of the cart that this item belongs to
    private int variantID;    // ID of the product variant
    private Variants variants; // Object representing detailed variant information
    private int quantity;     // Quantity of this item in the cart
    private double price;     // Unit price of the product variant

    // Constructor to view detailed information of an item in the cart
    public CartItems(int cartID, int quantity, Variants variants) {
        this.cartID = cartID;
        this.quantity = quantity;
        this.variants = variants;
    }

    // Constructor with basic product and cart information
    public CartItems(int cartID, int variantID, int quantity) {

        this.cartID = cartID;
        this.variantID = variantID;
        this.quantity = quantity;
    }
    
    //Constructor to display product information for payment
    public CartItems(Variants variants) {
        this.variants = variants;
    }
    public int getVariantID() {
        return variantID;
    }

    public void setVariantID(int variantID) {
        this.variantID = variantID;
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

    // Setter method (method name should be corrected to setQuantity)
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Variants getVariants() {
        return variants;
    }

    public void setVariants(Variants variants) {
        this.variants = variants;
    }

    // Calculate total price for this item (unit price * quantity)
    public double getTotalPrice() {
        return this.price * this.quantity;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
