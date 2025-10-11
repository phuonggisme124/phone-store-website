/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import model.CartItems;
import model.Carts;
import model.Products;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class CartDAO extends DBContext {

//    public List<CartItems> getItemIntoCartByUserID(int userID) {
//        String sql = "SELECT ci.CartID, ci.CartItemID,ci.ProductID, p.Name as [ProductName], v.Price as [TotalPrice], ci.Quantity FROM CartItems ci\n"
//                + "JOIN Carts c ON c.CartID = ci.CartID\n"
//                + "JOIN Products p ON ci.ProductID = ci.ProductID\n"
//                + "JOIN Variants v ON v.ProductID = p.ProductID\n"
//                + "WHERE ci.CartID = ?";
//        Carts cart = null;
//        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setInt(1, userID);
//            try (ResultSet rs = stmt.executeQuery()) {
//                if (rs.next()) {
//
//                    int cartID = rs.getInt("CartID");
//                    int cartItemID = rs.getInt("CartItemID");
//                    int quantity = rs.getInt("Quantity");
//                    Products product = new Products(rs.getInt("ProductID"), rs.getString("ProductName"));
//                    CartItems cartItems = new CartItems(cartItemID, cartID, quantity, product);
//                    cartItems.setPrice(rs.getDouble("TotalPrice"));
//                    cart = new Carts(cartID, userID);
//                    cart.setListCartItems(cartItems);
//
//                }
//            }
//        } catch (SQLException e) {
//            System.err.println("Error fetching category by ID " + userID + ": " + e.getMessage());
//            e.printStackTrace();
//        }
//        return cart.getListCartItems();
//    }
    public void addNewProductToCart(int userID, int variantID, int quantity) {
        String sql = "INSERT INTO CartItems (CartID, VariantID, Quantity) VALUES (?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);    // vì CartID = userID
            stmt.setInt(2, variantID);
            stmt.setInt(3, quantity);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                System.out.println("Added product " + variantID + " to cart of user " + userID);
            } else {
                System.out.println("Failed to add product to cart.");
            }
        } catch (SQLException e) {
            System.err.println("Error adding product to cart: " + e.getMessage());
        }
    }

}
