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
import model.Promotions;
import model.Variants;
import utils.DBContext;

/**
 * Data Access Object (DAO) class responsible for handling database operations
 * related to Variants table. This class provides CRUD operations and utility
 * methods to fetch, insert, update, or delete variant data.
 */
public class VariantsDAO extends DBContext {

    /**
     * Default constructor that calls the superclass constructor.
     */
    public VariantsDAO() {
        super();
    }

    /**
     * Retrieves all variants from the database.
     *
     * @return List of all Variants.
     * @throws SQLException if any SQL error occurs.
     */
    public List<Variants> getAllVariants() throws SQLException {
        List<Variants> list = new ArrayList<>();
        String sql = "SELECT * FROM variants";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            // Iterate through each record in the result set
            while (rs.next()) {
                int variantID = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");

                // Handle possible null value in DiscountPrice column
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

    /**
     * Retrieves all variants.
     *
     * @return List of Variants objects.
     */
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

    /**
     * Retrieves all variants that belong to a specific product.
     *
     * @param id Product ID.
     * @return List of Variants belonging to that product.
     */
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

    /**
     * Retrieves a single variant by its ID.
     *
     * @param id Variant ID.
     * @return Variant object if found, otherwise null.
     */
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
                return new Variants(variantId, productID, color, storage, price, discountPrice, stock, description, img);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Updates a variant's details.
     *
     * @param vID Variant ID.
     * @param color Color value.
     * @param storage Storage value.
     * @param price Price value.
     * @param stock Stock quantity.
     * @param description Description text.
     * @param img Image URL.
     */
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

    /**
     * Updates the discount price for a variant.
     *
     * @param variantID Variant ID.
     * @param discountPrice Discounted price value.
     */
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

    /**
     * Inserts a new variant record into the database.
     *
     * @param pID Product ID.
     * @param color Color value.
     * @param storage Storage value.
     * @param price Price value.
     * @param stock Stock quantity.
     * @param description Description text.
     */
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

    /**
     * Deletes a variant record by its ID.
     *
     * @param vID Variant ID.
     */
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

    /**
     * Deletes all variants related to a specific product.
     *
     * @param pid Product ID.
     */
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

    /**
     * Updates the discount price for all variants based on active promotions.
     * If a product has no active promotion, its discount price equals its
     * original price.
     */
    public void updateDiscountPrice() {
        VariantsDAO vdao = new VariantsDAO();
        ProfitDAO pfdao = new ProfitDAO();
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

            // Reset discount price if no active promotion found
            if (!hasPromotion) {
                double price = v.getPrice();
                discountPrice(v.getVariantID(), price);
            }
        }
    }

    /**
     * Retrieves a variant by product ID, storage, and color.
     *
     * @param pID Product ID.
     * @param storage Storage value.
     * @param color Color value.
     * @return Variant if found, otherwise null.
     */
    public Variants getVariant(int pID, String storage, String color) {
        String sql = "SELECT * FROM Variants Where ProductID = ? And Storage = ? And Color = ?";
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
                return new Variants(variantId, productID, colorV, storageV, price, discountPrice, stock, description, img);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves all variants of a specific product filtered by color.
     *
     * @param pID Product ID.
     * @param color Color filter.
     * @return List of Variants matching the filter.
     */
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

    /**
     * Retrieves all variants of a product filtered by storage.
     *
     * @param pID Product ID.
     * @param storage Storage filter.
     * @return List of Variants matching the storage value.
     */
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

    /**
     * Retrieves all distinct storage options for a specific product.
     *
     * @param pID Product ID.
     * @return List of unique storage strings.
     */
    public List<String> getAllStorage(int pID) {
        String sql = "SELECT DISTINCT Storage FROM Variants WHERE ProductID = ?";
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

    // (ĐÃ RÚT GỌN PHẦN ĐẦU - GIỮ NGUYÊN NHƯ BẠN GỬI)
    public List<Variants> getAllVariantByCategory(int cID) {
        String sql = "SELECT v.VariantID, v.ProductID, v.Color, v.Storage, v.Price, v.DiscountPrice, v.Stock, v.Description, v.ImageURL "
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

    //Get Variants by CID and order by Price
    public List<Variants> getAllVariantByCategoryAndOrderByPrice(int cID, String variation) {
        // Chỉ chấp nhận ASC hoặc DESC để tránh SQL Injection
        if (!"ASC".equalsIgnoreCase(variation) && !"DESC".equalsIgnoreCase(variation)) {
            variation = "ASC";
        }

        String sql = "SELECT v.VariantID, v.ProductID, v.Color, v.Storage, v.Price, v.DiscountPrice, v.Stock, v.Description, v.ImageURL "
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

    // ================== PHẦN MỚI THÊM ==================
    // Phương thức lọc variants theo color và storage (hỗ trợ tìm kiếm một phần)
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
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String colorV = rs.getString("Color");
                String storageV = rs.getString("Storage");
                double price = rs.getDouble("Price");

                Double discountPrice = (rs.getObject("DiscountPrice") != null)
                        ? rs.getDouble("DiscountPrice")
                        : null;

                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");

                list.add(new Variants(variantId, productID, colorV, storageV,
                        price, discountPrice, stock, description, img));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    // Phương thức lấy danh sách tất cả màu sắc (không trùng lặp)
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

    // Phương thức lấy danh sách tất cả storage (không trùng lặp)
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

    // Phương thức tìm kiếm variants theo ProductID, color và storage
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
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String colorV = rs.getString("Color");
                String storageV = rs.getString("Storage");
                double price = rs.getDouble("Price");

                Double discountPrice = (rs.getObject("DiscountPrice") != null)
                        ? rs.getDouble("DiscountPrice")
                        : null;

                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");

                list.add(new Variants(variantId, productID, colorV, storageV,
                        price, discountPrice, stock, description, img));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public int getCurrentVariantID() {
        String sql = "SELECT MAX(VariantID) AS VariantID\n"
                + "FROM Variants;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("VariantID");
                return id;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public void updateImageVariant(int currentVariantID, String img) {
        String sql = "UPDATE Variants\n"
                + "SET ImageURL = ?\n"
                + "Where VariantID = ?;";

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

    public boolean decreaseQuantity(int variantID, int quantityToSubtract) {
        String sql = "UPDATE Variants SET Stock = Stock - ? WHERE VariantID = ? AND Stock >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityToSubtract);
            ps.setInt(2, variantID);
            ps.setInt(3, quantityToSubtract); // tránh âm số lượng
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
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
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String colorV = rs.getString("Color");
                String storageV = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");
                return new Variants(variantId, productID, colorV, storageV, price, discountPrice, stock, description, img);
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
    //importproduct
    // Lấy variant theo ProductID + Storage + Color

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

    // Cập nhật stock
    public void updateStock(int variantID, int quantityToAdd) throws SQLException {
        String sql = "UPDATE Variants SET Stock = Stock + ? WHERE VariantID=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityToAdd);
            ps.setInt(2, variantID);
            ps.executeUpdate();
        }
    }

    //dùng để cập nhập giá 
    public void updateVariantPriceAndStock(int variantID, int newStock, double newPrice) {
        String sql = "UPDATE Variants SET Stock = ?, Price = ?, DiscountPrice = ? WHERE VariantID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, newStock);
            ps.setDouble(2, newPrice);
            ps.setDouble(3, newPrice); // Mặc định Discount = Price gốc khi nhập mới
            ps.setInt(4, variantID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //  THÊM VÀO ĐỂ DÙNG CHO IMPORT
    // Nhận vào object Variants và TRẢ VỀ ID (int) để lưu Profit

    public int createVariant(Variants v) {
        int generatedID = 0;
        // SQL cập nhật thêm cột DiscountPrice (nếu bảng có) để đồng bộ
        String sql = "INSERT INTO Variants (ProductID, Color, Storage, Price, DiscountPrice, Stock, Description, ImageURL) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)"; 
        try {
            // Quan trọng: RETURN_GENERATED_KEYS để lấy ID
            PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            
            ps.setInt(1, v.getProductID());
            ps.setString(2, v.getColor());
            ps.setString(3, v.getStorage());
            ps.setDouble(4, v.getPrice());
            
            // Nếu discount price chưa set thì lấy bằng price
            ps.setDouble(5, v.getDiscountPrice() > 0 ? v.getDiscountPrice() : v.getPrice());
            
            ps.setInt(6, v.getStock());
            ps.setString(7, v.getDescription());
            
            // Xử lý ảnh mặc định nếu null
            ps.setString(8, (v.getImageUrl() != null && !v.getImageUrl().isEmpty()) ? v.getImageUrl() : "default.png");

            ps.executeUpdate();
            
            // Lấy ID vừa sinh ra
            java.sql.ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                generatedID = rs.getInt(1);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedID;
    }

}