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
    private Carts cartID;
    private int productID;
    private int quality;

    public CartItems(int cartItemsID, Carts cartID, int productID, int quality) {
        this.cartItemsID = cartItemsID;
        this.cartID = cartID;
        this.productID = productID;
        this.quality = quality;
    }

    public int getCartItemsID() {
        return cartItemsID;
    }

    public void setCartItemsID(int cartItemsID) {
        this.cartItemsID = cartItemsID;
    }

    public Carts getCartID() {
        return cartID;
    }

    public void setCartID(Carts cartID) {
        this.cartID = cartID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getQuality() {
        return quality;
    }

    public void setQuality(int quality) {
        this.quality = quality;
    }

    @Override
    public String toString() {
        return "CartItems{" + "cartItemsID=" + cartItemsID + ", cartID=" + cartID + ", productID=" + productID + ", quality=" + quality + '}';
    }
    
}
