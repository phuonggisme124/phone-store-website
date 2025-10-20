/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CartItems;
import model.Carts;
import model.Products;
import model.Variants;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class CartDAO extends DBContext {

    public List<CartItems> getItemIntoCartByUserID(int userID) {
        String sql = "SELECT ci.CartID, ci.VariantID, ci.Quantity,\n"
                + "               v.ProductID, v.Color, v.Storage, v.DiscountPrice, v.Price,  \n"
                + "               v.Stock, v.ImageURL\n"
                + "        FROM CartItems ci\n"
                + "        JOIN Variants v ON ci.VariantID = v.VariantID\n"
                + "        WHERE ci.CartID = ?";

        List<CartItems> cItems = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int cartID = rs.getInt("CartID");
                    int quantity = rs.getInt("Quantity");
                    int variantID = rs.getInt("VariantID");
                    int productID = rs.getInt("ProductID");
                    String color = rs.getString("Color");
                    String storage = rs.getString("Storage");
                    double price = rs.getDouble("Price");
                    double disPrice = rs.getDouble("DiscountPrice");
                    int stock = rs.getInt("Stock");
                    String imgURL = rs.getString("ImageURL");

                    Variants variant = new Variants(variantID, productID, color, storage, price, disPrice, stock, imgURL);
                    CartItems cartItems = new CartItems(cartID, quantity, variant);

                    cItems.add(cartItems);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching cart items for user " + userID + ": " + e.getMessage());
            e.printStackTrace();
        }
        return cItems;
    }

    /**
     * Inserts a new product variant into the user's shopping cart.
     *
     * @param userID The ID of the user (also used as CartID)
     * @param variantID The ID of the product variant being added
     * @param quantity The number of units to be added
     */
    public void addNewProductToCart(int userID, int variantID, int quantity) {
        // SQL command to insert a new item into the CartItems table
        String sql = "INSERT INTO CartItems (CartID, VariantID, Quantity) VALUES (?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Bind parameters to the SQL statement
            stmt.setInt(1, userID);    // In this design, CartID = userID
            stmt.setInt(2, variantID);
            stmt.setInt(3, quantity);

            // Execute the SQL command
            int rows = stmt.executeUpdate();

            // Print success or failure message
            if (rows > 0) {
                System.out.println("Added product " + variantID + " to cart of user " + userID);
            } else {
                System.out.println("Failed to add product to cart.");
            }
        } catch (SQLException e) {
            // Log error if something goes wrong during the database operation
            System.err.println("Error adding product to cart: " + e.getMessage());
        }
    }

    public void removeItemFromCart(int cartID, int variantID) {
        String sql = "DELETE FROM CartItems \n"
                + "WHERE CartItems.CartID = ? AND CartItems.VariantID= ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Bind parameters to the SQL statement
            stmt.setInt(1, cartID);
            stmt.setInt(2, variantID);
            stmt.executeUpdate();

        } catch (SQLException e) {
            // Log error if something goes wrong during the database operation
            System.err.println("Error adding product to cart: " + e.getMessage());
        }

    }

    public boolean isAddedInCart(int userID, int variantID) {
        String sql = "SELECT * FROM CartItems WHERE CartItems.CartID = ? AND CartItems.VariantID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Bind parameters to the SQL statement
            stmt.setInt(1, userID);    // In this design, CartID = userID
            stmt.setInt(2, variantID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int quantity = rs.getInt("Quantity");
                this.updateQuantityExistedItemInCart(userID, variantID, quantity);
                return true;
            }

        } catch (SQLException e) {
            // Log error if something goes wrong during the database operation
            System.err.println("Error adding product to cart: " + e.getMessage());
        }
        return false;

    }

    public void updateQuantityExistedItemInCart(int cartID, int variantID, int quantity) {
        String sql = "UPDATE CartItems SET Quantity = ? WHERE CartID = ? AND VariantID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity + 1);
            stmt.setInt(2, cartID);
            stmt.setInt(3, variantID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void updateQuantityByChange(int cartID, int variantID, int change) {
    String sql = "UPDATE CartItems SET quantity = quantity + ? WHERE cartID = ? AND variantID = ?";
    // thực thi PreparedStatement với change, cartID, variantID
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, change);
            stmt.setInt(2, cartID);
            stmt.setInt(3, variantID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
}

    public void removeCartItem(int userID, int variantID) {
            String sql = "DELETE FROM CartItems WHERE CartID = ? AND VariantID = ?";
    // thực thi PreparedStatement với change, cartID, variantID
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            stmt.setInt(2, variantID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

  

}
