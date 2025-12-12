package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Products;
import model.Variants;
import utils.DBContext;

public class WishlistDAO extends DBContext {

    public void addToWishlist(int customerID, int productId, int variantId) {
        String sql = "INSERT INTO Wishlist (CustomerID, productID, variantID, createdAt) VALUES (?, ?, ?, GETDATE())";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setInt(2, productId);
            ps.setInt(3, variantId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void removeFromWishlist(int customerID, int productId, int variantId) {

        String sql = "DELETE FROM Wishlist WHERE CustomerID = ? AND ProductID = ? AND VariantID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setInt(2, productId);
            ps.setInt(3, variantId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isExist(int customerID, int productId, int variantId) {
        String sql = "SELECT 1 FROM Wishlist WHERE CustomerID = ? AND ProductID = ? AND VariantID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setInt(2, productId);
            ps.setInt(3, variantId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Products> getWishlistByCustomer(int customerID) {
        List<Products> list = new ArrayList<>();

        String sql
                = "SELECT p.ProductID, p.Name, "
                + "w.VariantID, v.Color, v.Storage, v.ImageURL, v.Price, v.DiscountPrice "
                + "FROM Wishlist w "
                + "JOIN Products p ON w.ProductID = p.ProductID "
                + "LEFT JOIN Variants v ON w.VariantID = v.VariantID "
                + "WHERE w.CustomerID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Products p = new Products();
                p.setProductID(rs.getInt("ProductID"));
                p.setName(rs.getString("Name"));

                Variants v = new Variants();
                v.setVariantID(rs.getInt("VariantID"));

                if (rs.getInt("VariantID") != 0) {
                    v.setColor(rs.getString("Color"));
                    v.setStorage(rs.getString("Storage"));
                    v.setImageUrl(rs.getString("ImageURL"));
                    v.setPrice(rs.getDouble("Price"));
                    if (rs.getObject("DiscountPrice") != null) {
                        v.setDiscountPrice(rs.getDouble("DiscountPrice"));
                    }
                }

                List<Variants> variants = new ArrayList<>();
                variants.add(v);
                p.setVariants(variants);

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
