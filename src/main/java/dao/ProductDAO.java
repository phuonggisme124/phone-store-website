package dao;

import model.Product;
import model.Category; // Vẫn giữ lại nếu cần dùng Category
import utils.DBContext;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Products;
import model.Users;

/**
 * Lớp DAO cho Product, được cập nhật để phù hợp với lớp Product.java mới.
 */
public class ProductDAO extends DBContext {

    // Helper method để chuyển đổi ResultSet thành đối tượng Product
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        // Lấy các trường NOT NULL
        int productId = rs.getInt("ProductID");
        String name = rs.getString("Name");
        BigDecimal price = rs.getBigDecimal("Price");

        // Lấy các trường Allow Nulls
        Integer categoryId = rs.getObject("CategoryID", Integer.class);
        Integer supplierId = rs.getObject("SupplierID", Integer.class);
        String brand = rs.getString("Brand");
        BigDecimal discountPrice = rs.getBigDecimal("DiscountPrice");
        Integer stock = rs.getObject("Stock", Integer.class);
        Integer warrantyPeriod = rs.getObject("WarrantyPeriod", Integer.class);
        String description = rs.getString("Description");
        String imageUrl = rs.getString("ImageURL");

        // Lấy LocalDateTime. Sử dụng getTimestamp và chuyển đổi
        Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
        LocalDateTime createdAt = (createdAtTimestamp != null) 
                                ? createdAtTimestamp.toLocalDateTime() 
                                : null;

        // Tạo đối tượng Product
        return new Product(
                productId, categoryId, supplierId, name, brand, price,
                discountPrice, stock, warrantyPeriod, description, imageUrl, createdAt
        );
    }

    // --- Phương thức GetAllProducts ---
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        // Chọn tất cả các cột trong bảng Product
        String sql = "SELECT * FROM Product"; 

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    // --- Phương thức GetProductById ---
    public Product getProductById(int productId) {
        Product product = null;
        String sql = "SELECT * FROM Product WHERE ProductID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    product = mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching product by ID " + productId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return product;
    }

    // --- Phương thức CreateProduct ---
    public boolean createProduct(Product product) {
        // Giả định ProductID là Identity (tự tăng) trong CSDL, nên ta không cần getMaxProId() nữa
        // Nếu không tự tăng, bạn cần phải giữ lại getMaxProId và thiết lập cho product
        
        // Liệt kê tất cả các cột trừ ProductID (vì giả định nó là IDENTITY)
        String sql = "INSERT INTO Product ("
                + "CategoryID, SupplierID, Name, Brand, Price, DiscountPrice, Stock, "
                + "WarrantyPeriod, Description, ImageURL, CreatedAt"
                + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Thiết lập tham số theo thứ tự SQL
            stmt.setObject(1, product.getCategoryId());         // Integer
            stmt.setObject(2, product.getSupplierId());         // Integer
            stmt.setString(3, product.getName());               // String (NOT NULL)
            stmt.setString(4, product.getBrand());              // String
            stmt.setBigDecimal(5, product.getPrice());          // BigDecimal (NOT NULL)
            stmt.setBigDecimal(6, product.getDiscountPrice());  // BigDecimal
            stmt.setObject(7, product.getStock());              // Integer
            stmt.setObject(8, product.getWarrantyPeriod());     // Integer
            stmt.setString(9, product.getDescription());        // String
            stmt.setString(10, product.getImageUrl());          // String
            
            // Chuyển LocalDateTime sang Timestamp để set vào CSDL
            if (product.getCreatedAt() != null) {
                stmt.setTimestamp(11, Timestamp.valueOf(product.getCreatedAt()));
            } else {
                stmt.setNull(11, Types.TIMESTAMP);
            }
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error creating product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // --- Phương thức UpdateProduct ---
    public boolean updateProduct(Product product) {
        String sql = "UPDATE Product SET "
                + "CategoryID = ?, SupplierID = ?, Name = ?, Brand = ?, Price = ?, DiscountPrice = ?, Stock = ?, "
                + "WarrantyPeriod = ?, Description = ?, ImageURL = ?, CreatedAt = ? "
                + "WHERE ProductID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Thiết lập tham số theo thứ tự SQL
            stmt.setObject(1, product.getCategoryId());
            stmt.setObject(2, product.getSupplierId());
            stmt.setString(3, product.getName());
            stmt.setString(4, product.getBrand());
            stmt.setBigDecimal(5, product.getPrice());
            stmt.setBigDecimal(6, product.getDiscountPrice());
            stmt.setObject(7, product.getStock());
            stmt.setObject(8, product.getWarrantyPeriod());
            stmt.setString(9, product.getDescription());
            stmt.setString(10, product.getImageUrl());
            
            if (product.getCreatedAt() != null) {
                stmt.setTimestamp(11, Timestamp.valueOf(product.getCreatedAt()));
            } else {
                stmt.setNull(11, Types.TIMESTAMP);
            }
            
            stmt.setInt(12, product.getProductId()); // WHERE clause
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating product with ID " + product.getProductId() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // --- Phương thức DeleteProduct ---
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Product WHERE ProductID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting product with ID " + productId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // --- Phương thức main (Test) ---
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        System.out.println("--- All Products ---");
        List<Product> list = dao.getAllProducts();
        if (list.isEmpty()) {
            System.out.println("No data.");
        } else {
            for (Product p : list) {
                System.out.println(p);
            }
        }
        // Thêm test case cho getProductById nếu cần
        // System.out.println("\n--- Product by ID 1 ---");
        // Product p = dao.getProductById(1);
        // System.out.println(p != null ? p : "Product not found.");
    }

    public List<Products> getAllProduct() {
        String sql = "Select * from Products";
        List<Products> list = new ArrayList<>();
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("ProductID");
                int cateID = rs.getInt("CategoryID");
                int supplierID = rs.getInt("SupplierID");
                String name = rs.getString("Name");
                String brand = rs.getString("Brand");
                int warrantyPeriod = rs.getInt("WarrantyPeriod");
                
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null)
                        ? createdAtTimestamp.toLocalDateTime()
                        : null;
                
                list.add(new Products(id, cateID, supplierID, name, brand, warrantyPeriod, createdAt));
            }
            
        }catch(Exception e){
            System.out.println(e.getMessage());
        }
        
        return list;
    }
}