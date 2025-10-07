package dao;

import model.Category; // Vẫn giữ lại nếu cần dùng Category
import utils.DBContext;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Products;
import model.Users;
import model.Variants;

/**
 * Lớp DAO cho Product, được cập nhật để phù hợp với lớp Product.java mới.
 */
public class ProductDAO extends DBContext {

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
    public List<Products> getNewestProduct() {
        String sql = "SELECT TOP 5 * FROM Products ORDER BY CreatedAt DESC";
        List<Products> newListProduct = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            VariantsDAO variantsDAO ;
            while (rs.next()) {
                int id = rs.getInt("ProductID");
                String name = rs.getString("Name");
                variantsDAO = new VariantsDAO(conn);
                List<Variants> variants = variantsDAO.getAllVariantByProductID(id);

                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null)
                        ? createdAtTimestamp.toLocalDateTime()
                        : null;

                newListProduct.add(new Products(id, name, createdAt, variants));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newListProduct;
    }

    // 👇 thêm hàm main để test
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        List<Products> list = dao.getNewestProduct();

        for (Products p : list) {
            System.out.println("ProductID: " + p.getProductID());
            System.out.println("Name: " + p.getName());
            System.out.println("CreatedAt: " + p.getCreatedAt());
            if (p.getVariants() != null) {
                for (Variants v : p.getVariants()) {
                    System.out.println("  - VariantID: " + v.getVariantID() +
                            ", Color: " + v.getColor() +
                            ", Storage: " + v.getStorage() +
                            ", Price: " + v.getPrice());
                }
            } else {
                System.out.println("  No variants found.");
            }
            System.out.println("--------------------");
        }
    }
}