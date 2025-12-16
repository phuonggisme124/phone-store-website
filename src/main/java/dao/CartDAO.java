package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Carts;
import model.Variants;
import utils.DBContext;

public class CartDAO extends DBContext {

    /* ===================== GET CART BY CUSTOMER ===================== */

    public List<Carts> getCartByCustomerID(int customerID) {

        String sql = "SELECT c.CustomerID, c.VariantID, c.Quantity, "
                + "v.ProductID, v.Color, v.Storage, v.DiscountPrice, v.Price, v.Stock, v.ImageURL "
                + "FROM Carts c JOIN Variants v ON c.VariantID = v.VariantID "
                + "WHERE c.CustomerID = ?";

        List<Carts> carts = new ArrayList<>();

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int variantID = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String imageURL = rs.getString("ImageURL");
                int quantity = rs.getInt("Quantity");

                Variants v = new Variants(
                        variantID,
                        productID,
                        color,
                        storage,
                        price,
                        discountPrice,
                        stock,
                        imageURL
                );

                Carts cart = new Carts(customerID, v, quantity);
                carts.add(cart);
            }

        } catch (SQLException e) {
            System.err.println("CartDAO.getCartByCustomerID ERROR: " + e.getMessage());
        }

        return carts;
    }

    /* ===================== ADD NEW ITEM ===================== */

    public void addItemToCart(int customerID, int variantID, int quantity) {

        String sql = "INSERT INTO Carts (CustomerID, VariantID, Quantity) VALUES (?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerID);
            stmt.setInt(2, variantID);
            stmt.setInt(3, quantity);
            stmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("CartDAO.addItemToCart ERROR: " + e.getMessage());
        }
    }

    /* ===================== REMOVE ITEM ===================== */

    public void removeItem(int customerID, int variantID) {
        String sql = "DELETE FROM Carts WHERE CustomerID = ? AND VariantID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerID);
            stmt.setInt(2, variantID);
            stmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("CartDAO.removeItem ERROR: " + e.getMessage());
        }
    }

    /* ===================== CHECK + UPDATE IF EXIST ===================== */

    public boolean isItemExists(int customerID, int variantID, int addQuantity) {

        String sql = "SELECT Quantity FROM Carts WHERE CustomerID = ? AND VariantID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerID);
            stmt.setInt(2, variantID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int oldQuantity = rs.getInt("Quantity");
                updateItemQuantity(customerID, variantID, oldQuantity + addQuantity);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("CartDAO.isItemExists ERROR: " + e.getMessage());
        }

        return false;
    }

    /* ===================== UPDATE QUANTITY ===================== */

    public void updateItemQuantity(int customerID, int variantID, int quantity) {

        String sql = "UPDATE Carts SET Quantity = ? WHERE CustomerID = ? AND VariantID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, customerID);
            stmt.setInt(3, variantID);
            stmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("CartDAO.updateItemQuantity ERROR: " + e.getMessage());
        }
    }

    public void changeItemQuantity(int customerID, int variantID, int delta) {

        String sql = "UPDATE Carts SET Quantity = Quantity + ? WHERE CustomerID = ? AND VariantID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, delta);
            stmt.setInt(2, customerID);
            stmt.setInt(3, variantID);
            stmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("CartDAO.changeItemQuantity ERROR: " + e.getMessage());
        }
    }

    /* ===================== MAIN TEST ===================== */
    public static void main(String[] args) {

        CartDAO dao = new CartDAO();
        int customerID = 1;

        dao.addItemToCart(1, 2, 1);
        
List<Carts> list = dao.getCartByCustomerID(customerID);
        if (list.isEmpty()) {
            System.out.println("Cart is empty for customerID: " + customerID);
        } else {
            for (Carts c : list) {
                System.out.println("CustomerID: " + c.getUserID());
                System.out.println("VariantID: " + c.getVariant().getVariantID());
                System.out.println("ProductID: " + c.getVariant().getProductID());
                System.out.println("Color: " + c.getVariant().getColor());
                System.out.println("Storage: " + c.getVariant().getStorage());
                System.out.println("Price: " + c.getVariant().getPrice());
                System.out.println("DiscountPrice: " + c.getVariant().getDiscountPrice());
                System.out.println("Stock: " + c.getVariant().getStock());
                System.out.println("ImageURL: " + c.getVariant().getImageUrl());
                System.out.println("Quantity: " + c.getQuantity());
                System.out.println("----------------------------");
            }
        }
    }
}



