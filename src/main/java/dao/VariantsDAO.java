package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Promotions;
import model.Variants;
import utils.DBContext;

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
                Double discountPrice = (rs.getObject("DiscountPrice") != null)
                        ? rs.getDouble("DiscountPrice")
                        : null;
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String imageUrl = rs.getString("ImageURL");

                list.add(new Variants(
                        variantID, productID, color, storage, price,
                        discountPrice, stock, description, imageUrl
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

                list.add(new Variants(
                        variantId, productID, color, storage,
                        price, discountPrice, stock, description, img
                ));
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
                list.add(new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getDouble("DiscountPrice"),
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                ));
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
                return new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getDouble("DiscountPrice"),
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                );
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public void updateVariant(int vID, String color, String storage, double price, int stock, String description) {
        String sql = "UPDATE Variants SET Color = ?, Storage = ?, Price = ?, Stock = ?, Description = ? WHERE VariantID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, color);
            ps.setString(2, storage);
            ps.setDouble(3, price);
            ps.setInt(4, stock);
            ps.setString(5, description);
            ps.setInt(6, vID);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void discountPrice(int variantID, double discountPrice) {
        String sql = "UPDATE Variants SET DiscountPrice = ? WHERE VariantID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDouble(1, discountPrice);
            ps.setInt(2, variantID);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void createVariant(int pID, String color, String storage, double price, int stock, String description) {
        String sql = "INSERT INTO Variants (ProductID, Color, Storage, Price, Stock, Description) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pID);
            ps.setString(2, color);
            ps.setString(3, storage);
            ps.setDouble(4, price);
            ps.setInt(5, stock);
            ps.setString(6, description);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void deleteVariantByID(int vID) {
        String sql = "DELETE FROM Variants WHERE VariantID = ?";
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
        String sql = "DELETE FROM Variants WHERE ProductID = ?";
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
        ProfitDAO pfdao = new ProfitDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();

        List<Promotions> listPromotions = pmtdao.getAllPromotion();
        List<Variants> listVariants = vdao.getAllVariant();

        for (Variants v : listVariants) {
            boolean hasPromotion = false;

            for (Promotions pmt : listPromotions) {
                if (v.getProductID() == pmt.getProductID()
                        && pmt.getStatus().equals("active")) {

                    double percent = pmt.getDiscountPercent() / 100.0;
                    double discountPrice = v.getPrice() - (v.getPrice() * percent);
                    discountPrice(v.getVariantID(), discountPrice);
                    hasPromotion = true;
                    break;
                }
            }

            if (!hasPromotion) {
                discountPrice(v.getVariantID(), v.getPrice());
            }
        }
    }

    public Variants getVariant(int pID, String storage, String color) {
        String sql = "SELECT * FROM Variants Where ProductID = ? And Storage = ? And Color = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pID);
            ps.setString(2, storage);
            ps.setString(3, color);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getDouble("DiscountPrice"),
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                );
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
                list.add(new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getDouble("DiscountPrice"),
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                ));
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
                list.add(new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getDouble("DiscountPrice"),
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<String> getAllStorage(int pID) {
        String sql = "SELECT DISTINCT Storage FROM Variants WHERE ProductID = ?";
        List<String> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("Storage"));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Variants> getAllVariantByCategory(int cID) {
        String sql = "SELECT v.VariantID, v.ProductID, v.Color, v.Storage, v.Price, v.DiscountPrice, "
                + "v.Stock, v.Description, v.ImageURL "
                + "FROM Products p "
                + "JOIN Categories c ON p.CategoryID = c.CategoryID "
                + "JOIN Variants v ON p.ProductID = v.ProductID "
                + "WHERE c.CategoryID = ?";
        List<Variants> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getDouble("DiscountPrice"),
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Variants> getAllVariantByCategoryAndOrderByPrice(int cID, String variation) {
        if (!"ASC".equalsIgnoreCase(variation) && !"DESC".equalsIgnoreCase(variation)) {
            variation = "ASC";
        }

        String sql = "SELECT v.VariantID, v.ProductID, v.Color, v.Storage, v.Price, v.DiscountPrice, "
                + "v.Stock, v.Description, v.ImageURL "
                + "FROM Products p "
                + "JOIN Categories c ON p.CategoryID = c.CategoryID "
                + "JOIN Variants v ON p.ProductID = v.ProductID "
                + "WHERE c.CategoryID = ? "
                + "ORDER BY v.Price " + variation;

        List<Variants> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getDouble("DiscountPrice"),
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public List<Variants> searchVariants(String color, String storage) {
        List<Variants> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Variants WHERE 1=1");

        if (color != null && !color.trim().isEmpty()) {
            sql.append(" AND LOWER(Color) LIKE ?");
        }

        if (storage != null && !storage.trim().isEmpty()) {
            sql.append(" AND Storage = ?");
        }

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (color != null && !color.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + color.toLowerCase() + "%");
            }

            if (storage != null && !storage.trim().isEmpty()) {
                ps.setString(paramIndex++, storage);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Double discountPrice = (rs.getObject("DiscountPrice") != null)
                        ? rs.getDouble("DiscountPrice")
                        : null;

                list.add(new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        discountPrice,
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                ));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<String> getAllColors() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT Color FROM Variants ORDER BY Color";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String color = rs.getString("Color");
                if (color != null && !color.trim().isEmpty()) {
                    list.add(color);
                }
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<String> getAllStorages() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT Storage FROM Variants ORDER BY Storage";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String storage = rs.getString("Storage");
                if (storage != null && !storage.trim().isEmpty()) {
                    list.add(storage);
                }
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<Variants> searchVariantsByProductId(int productId, String color, String storage) {
        List<Variants> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Variants WHERE ProductID = ?");

        if (color != null && !color.trim().isEmpty()) {
            sql.append(" AND LOWER(Color) LIKE ?");
        }

        if (storage != null && !storage.trim().isEmpty()) {
            sql.append(" AND Storage = ?");
        }

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            ps.setInt(paramIndex++, productId);

            if (color != null && !color.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + color.toLowerCase() + "%");
            }

            if (storage != null && !storage.trim().isEmpty()) {
                ps.setString(paramIndex++, storage);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Double discountPrice = (rs.getObject("DiscountPrice") != null)
                        ? rs.getDouble("DiscountPrice")
                        : null;

                list.add(new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        discountPrice,
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                ));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public int getCurrentVariantID() {
        String sql = "SELECT MAX(VariantID) AS VariantID FROM Variants";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("VariantID");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public void updateImageVariant(int currentVariantID, String img) {
        String sql = "UPDATE Variants SET ImageURL = ? Where VariantID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, img);
            ps.setInt(2, currentVariantID);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public List<String> getImages(String images) {
        List<String> list = new ArrayList<>();

        if (images != null && !images.isEmpty()) {
            String[] token = images.split("#");
            for (String t : token) {
                list.add(t);
            }
        }

        return list;
    }

    public boolean increaseQuantity(int variantID, int quantity) {
        String sql = "UPDATE Variants SET Stock = Stock + ? WHERE VariantID = ? AND Stock >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, variantID);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error decreasing quantity: " + e.getMessage());
            return false;
        }
    }

    public Variants getVariantByProductIDAndColor(int pID, String color) {
        String sql = "SELECT * FROM Variants Where ProductID = ? And Color = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pID);
            ps.setString(2, color);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getDouble("DiscountPrice"),
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                );
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public List<Variants> getVariantByProductID(int pID) {
        String sql = "SELECT * FROM Variants Where ProductID = ?";
        List<Variants> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getDouble("DiscountPrice"),
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public Variants getVariantByProductStorageColor(int productID, String storage, String color) throws SQLException {
        String sql = "SELECT * FROM Variants WHERE ProductID=? AND Storage=? AND Color=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productID);
            ps.setString(2, storage);
            ps.setString(3, color);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Variants v = new Variants();
                v.setVariantID(rs.getInt("VariantID"));
                v.setProductID(rs.getInt("ProductID"));
                v.setColor(rs.getString("Color"));
                v.setStorage(rs.getString("Storage"));
                v.setPrice(rs.getDouble("Price"));
                v.setDiscountPrice(rs.getDouble("DiscountPrice"));
                v.setStock(rs.getInt("Stock"));
                v.setDescription(rs.getString("Description"));
                v.setImageUrl(rs.getString("ImageUrl"));
                return v;
            }
        }
        return null;
    }

    public void updateStock(int variantID, int quantityToAdd) throws SQLException {
        String sql = "UPDATE Variants SET Stock = Stock + ? WHERE VariantID=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityToAdd);
            ps.setInt(2, variantID);
            ps.executeUpdate();
        }
    }

    public void updateVariantPriceAndStock(int variantID, int newStock, double newPrice) {
        String sql = "UPDATE Variants SET Stock = ?, Price = ?, DiscountPrice = ? WHERE VariantID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, newStock);
            ps.setDouble(2, newPrice);
            ps.setDouble(3, newPrice);
            ps.setInt(4, variantID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int createVariant(Variants v) {
        int generatedID = 0;
        String sql = "INSERT INTO Variants (ProductID, Color, Storage, Price, DiscountPrice, Stock, Description, ImageURL) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);

            ps.setInt(1, v.getProductID());
            ps.setString(2, v.getColor().toUpperCase());
            ps.setString(3, v.getStorage().toUpperCase());
            ps.setDouble(4, v.getPrice());
            ps.setDouble(5, v.getDiscountPrice() > 0 ? v.getDiscountPrice() : v.getPrice());
            ps.setInt(6, v.getStock());
            ps.setString(7, v.getDescription());
            ps.setString(8, (v.getImageUrl() != null && !v.getImageUrl().isEmpty()) ? v.getImageUrl() : "default.png");

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                generatedID = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedID;
    }

    public void reduceStock(int variantID, int quantity) {
        String sql = "UPDATE Variants SET Stock = Stock - ? WHERE VariantID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, variantID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateVariant(Variants variant) {
        String sql = "UPDATE Variants SET price = ?, stock = ?, description = ?, imageURL = ? WHERE variantID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDouble(1, variant.getPrice());
            ps.setInt(2, variant.getStock());
            ps.setString(3, variant.getDescription());
            ps.setString(4, variant.getImageUrl());
            ps.setInt(5, variant.getVariantID());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Variants> getAllVariantsWithProductName() {
        List<Variants> list = new ArrayList<>();
        String sql = "SELECT v.variantID, v.productID, v.color, v.storage, v.stock, v.price, v.discountPrice, "
                + "p.Name AS ProductName, p.CategoryID "
                + "FROM Variants v "
                + "INNER JOIN Products p ON v.productID = p.productID";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Variants v = new Variants();

                v.setVariantID(rs.getInt("variantID"));
                v.setProductID(rs.getInt("productID"));
                v.setColor(rs.getString("color"));
                v.setStorage(rs.getString("storage"));
                v.setStock(rs.getInt("stock"));
                v.setPrice(rs.getDouble("price"));
                v.setDiscountPrice(rs.getDouble("discountPrice"));
                v.setProductName(rs.getString("ProductName"));
                v.setCategoryID(rs.getInt("CategoryID"));

                list.add(v);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public List<Variants> getSuggestedVariantsByVariantID(int variantID) throws SQLException {
        Variants current = getVariantByID(variantID);
        if (current == null) {
            return new ArrayList<>();
        }

        String sql
                = "SELECT TOP 6 v.* "
                + "FROM Variants v "
                + "JOIN Products p ON v.ProductID = p.ProductID "
                + "WHERE v.VariantID <> ? "
                + "AND p.CategoryID = ("
                + "    SELECT p2.CategoryID "
                + "    FROM Products p2 "
                + "    JOIN Variants v2 ON p2.ProductID = v2.ProductID "
                + "    WHERE v2.VariantID = ?"
                + ") "
                + "AND ABS(CAST(ISNULL(v.DiscountPrice, v.Price) AS FLOAT) - ?) <= 5000000 "
                + "ORDER BY NEWID()";

        List<Variants> list = new ArrayList<>();

        double currentPrice = (current.getDiscountPrice() != null)
                ? current.getDiscountPrice()
                : current.getPrice();

        try (Connection conn = new utils.DBContext().conn;
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, variantID);
            ps.setInt(2, variantID);
            ps.setDouble(3, currentPrice);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Variants v = new Variants(
                        rs.getInt("VariantID"),
                        rs.getInt("ProductID"),
                        rs.getString("Color"),
                        rs.getString("Storage"),
                        rs.getDouble("Price"),
                        rs.getObject("DiscountPrice") != null ? rs.getDouble("DiscountPrice") : null,
                        rs.getInt("Stock"),
                        rs.getString("Description"),
                        rs.getString("ImageURL")
                );
                list.add(v);
            }
        }

        return list;
    }
}



