/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Variants;

import model.Products;
import model.Promotions;
import model.Users;

import model.Variants;
import utils.DBContext;

/**
 *
 * @author USER
 */
public class VariantsDAO extends DBContext {

    public VariantsDAO() {
        super();
    }

    public List<Variants> getAllVariants() throws SQLException {
        List<Variants> list = new ArrayList<>();
        String sql = "SELECT * FROM variants";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantID = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");

                // Kiểm tra DiscountPrice có null không
                Double discountPrice = (rs.getObject("DiscountPrice") != null)
                        ? rs.getDouble("DiscountPrice")
                        : null;

                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String imageUrl = rs.getString("ImageURL");

                list.add(new Variants(
                        variantID,
                        productID,
                        color,
                        storage,
                        price,
                        discountPrice,
                        stock,
                        description,
                        imageUrl
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Variants> getAllVariant() {
        String sql = "Select * from Variants";
        List<Variants> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");

                list.add(new Variants(variantId, productID, color, storage, price, discountPrice, stock, description, img));

            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<Variants> getAllVariantByProductID(int id) {

        String sql = "Select * from Variants where ProductID = ?";
        List<Variants> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");

                list.add(new Variants(variantId, productID, color, storage, price, discountPrice, stock, description, img));

            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public Variants getVariantByID(int id) {
        String sql = "SELECT * FROM Variants where VariantID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");
                return (new Variants(variantId, productID, color, storage, price, discountPrice, stock, description, img));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public void updateVariant(int vID, String color, String storage, double price, int stock, String description, String img) {
        String sql = "UPDATE Variants\n"
                + "SET Color = ?,\n"
                + "    Storage = ?,\n"
                + "    Price = ?,\n"
                + "	Stock = ?,\n"
                + "	Description = ?,\n"
                + "    ImageURL = ?\n"
                + "WHERE VariantID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, color);
            ps.setString(2, storage);
            ps.setDouble(3, price);
            ps.setInt(4, stock);
            ps.setString(5, description);
            ps.setString(6, img);
            ps.setInt(7, vID);
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void discountPrice(int variantID, double discountPrice) {
        String sql = "UPDATE Variants\n"
                + "SET DiscountPrice = ?\n"
                + "WHERE VariantID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setDouble(1, discountPrice);
            ps.setInt(2, variantID);
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void createVariant(int pID, String color, String storage, double price, int stock, String description, String img) {
        String sql = "INSERT INTO Variants (ProductID, Color, Storage, Price, Stock, Description, ImageURL) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, pID);
            ps.setString(2, color);
            ps.setString(3, storage);

            ps.setDouble(4, price);

            ps.setInt(5, stock);
            ps.setString(6, description);
            ps.setString(7, img);

            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void deleteVariantByID(int vID) {
        String sql = "DELETE FROM Variants\n"
                + "WHERE VariantID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, vID);

            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void deleteVariantByProductID(int pid) {
        String sql = "DELETE FROM Variants\n"
                + "WHERE ProductID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, pid);

            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void updateDiscountPrice() {
        VariantsDAO vdao = new VariantsDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();

        double discountPrice;
        double percent;
        List<Promotions> listPromotions = pmtdao.getAllPromotion();
        List<Variants> listVariants = vdao.getAllVariant();
        for (Variants v : listVariants) {
            boolean hasPromotion = false;
            for (Promotions pmt : listPromotions) {
                if (v.getProductID() == pmt.getProductID() && pmt.getStatus().equals("active")) {
                    double price = v.getPrice();
                    percent = pmt.getDiscountPercent() / 100.0;
                    discountPrice = price - (price * percent);
                    discountPrice(v.getVariantID(), discountPrice);
                    hasPromotion = true;
                    break;
                }
            }

            if (!hasPromotion) {
                double price = v.getPrice();
                percent = 0;
                discountPrice = price - (price * percent);
                discountPrice(v.getVariantID(), discountPrice);
            }
        }
    }

    public Variants getVariant(int pID, String storage, String color) {
        String sql = "SELECT * FROM Variants \n"
                + "Where ProductID = ? \n"
                + "And Storage = ?\n"
                + "And Color = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pID);
            ps.setString(2, storage);
            ps.setString(3, color);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String colorV = rs.getString("Color");
                String storageV = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");
                return (new Variants(variantId, productID, colorV, storageV, price, discountPrice, stock, description, img));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public List<Variants> getAllVariantByColor(int pID, String color) {
        String sql = "Select * from Variants where ProductID = ? And Color = ?";
        List<Variants> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, pID);
            ps.setString(2, color);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String colorV = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");

                list.add(new Variants(variantId, productID, colorV, storage, price, discountPrice, stock, description, img));

            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<Variants> getAllVariantByStorage(int pID, String storage) {
        String sql = "Select * from Variants where ProductID = ? And Storage = ?";
        List<Variants> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, pID);
            ps.setString(2, storage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String colorV = rs.getString("Color");
                String storageV = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");

                list.add(new Variants(variantId, productID, colorV, storageV, price, discountPrice, stock, description, img));

            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<String> getAllStorage(int pID) {
        String sql = "SELECT DISTINCT Storage\n"
                + "FROM Variants\n"
                + "WHERE ProductID = ?";
        List<String> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, pID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                
                String storage = rs.getString("Storage");

                list.add(storage);

            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<Variants> getAllVariantByCategory(int cID) {
        String sql = "SELECT \n"
                + "    v.VariantID,\n"
                + "    v.ProductID, \n"
                + "    v.Color,\n"
                + "    v.Storage,\n"
                + "    v.Price,\n"
                + "    v.DiscountPrice,\n"
                + "    v.Stock,\n"
                + "	v.Description,\n"
                + "    v.ImageURL\n"
                + "FROM Products p\n"
                + "JOIN Categories c ON p.CategoryID = c.CategoryID\n"
                + "JOIN Variants v ON p.ProductID = v.ProductID\n"
                + "WHERE c.CategoryID = ?;";
        List<Variants> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");

                list.add(new Variants(variantId, productID, color, storage, price, discountPrice, stock, description, img));

            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

}
