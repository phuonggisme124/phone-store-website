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
import model.Carts;
import model.Products;
import model.Variants;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */
public class CartDAO extends DBContext {

    public List<Carts> getItemIntoCartByUserID(int userID) {
        String sql = "SELECT c.UserID, c.VariantID, c.Quantity,v.ProductID, v.Color, v.Storage, v.DiscountPrice, v.Price, v.Stock, v.ImageURL\n"
                + "FROM Carts c JOIN Variants v \n"
                + "ON c.VariantID = v.VariantID\n"
                + "WHERE c.UserID = ?";

        Carts cart;
        List<Carts> carts = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
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
                    cart = new Carts(userID, variant, quantity);
                    cart.setCartID(userID);
                    carts.add(cart);

                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching cart items for user " + userID + ": " + e.getMessage());
            e.printStackTrace();
        }
        return carts;
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
        String sql = "INSERT INTO Carts (UserID, VariantID, Quantity) VALUES (?, ?, ?)";

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
        String sql = "DELETE FROM Carts \n"
                + "WHERE Carts.UserID = ? AND Carts.VariantID= ?";
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
        String sql = "SELECT * FROM Carts WHERE Carts.UserID = ? AND Carts.VariantID = ?";
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
        String sql = "UPDATE Carts SET Quantity = ? WHERE UserID = ? AND VariantID = ?";
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
        String sql = "UPDATE Carts SET Quantity = Quantity + ? WHERE UserID = ? AND VariantID = ?";
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
        String sql = "DELETE FROM Carts WHERE UserID = ? AND VariantID = ?";
        // thực thi PreparedStatement với change, cartID, variantID
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            stmt.setInt(2, variantID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void ensureCartExists(int userID) {
        String check = "SELECT UserID FROM Carts WHERE UserID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(check)) {
            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();
            if (!rs.next()) {
                String insert = "INSERT INTO Carts (UserID, CreatedAt) VALUES (?, GETDATE())";
                try (PreparedStatement insertStmt = conn.prepareStatement(insert)) {
                    insertStmt.setInt(1, userID);
                    insertStmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        CartDAO dao = new CartDAO(); // hoặc tên class thật chứa phương thức của bạn
        int userID = 1; // thay bằng ID thực trong DB

        List<Carts> carts = dao.getItemIntoCartByUserID(userID);

        if (carts.isEmpty()) {
            System.out.println("Cart is empty for user ID: " + userID);
        } else {
            for (Carts cart : carts) {
                System.out.println("User ID: " + cart.getUserID());
                System.out.println("Variant ID: " + cart.getVariant().getVariantID());
                System.out.println("Product ID: " + cart.getVariant().getProductID());
                System.out.println("Color: " + cart.getVariant().getColor());
                System.out.println("Storage: " + cart.getVariant().getStorage());
                System.out.println("Price: " + cart.getVariant().getPrice());
                System.out.println("Discount Price: " + cart.getVariant().getDiscountPrice());
                System.out.println("Stock: " + cart.getVariant().getStock());
                System.out.println("Image URL: " + cart.getVariant().getImageUrl());
                System.out.println("Quantity: " + cart.getQuantity());
                System.out.println("---------------------------");
            }
        }
    }

}
