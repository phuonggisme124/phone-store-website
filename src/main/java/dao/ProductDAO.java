package dao;

import model.Category;
import utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.InterestRate;
import model.Products;
import model.Variants;

/**
 *
 * @author ADMIN
 *
 * DAO class for managing Product data. Provides CRUD operations and data
 * retrieval for Products and Categories.
 */
public class ProductDAO extends DBContext {

    public ProductDAO() {
        super();
    }

    /**
     * Retrieve all products from the database.
     *
     * @return List of all Products.
     */
    public List<Products> getAllProduct() {
        String sql = "Select * from Products";
        List<Products> list = new ArrayList<>();
        try {
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

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    /**
     * Retrieve the 5 newest products, ordered by creation date (descending).
     *
     * @return List of the newest Products.
     */
    public List<Products> getNewestProduct() {
        String sql = "SELECT TOP 5 * FROM Products ORDER BY CreatedAt DESC";
        List<Products> newListProduct = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            VariantsDAO variantsDAO;
            while (rs.next()) {
                int id = rs.getInt("ProductID");
                String name = rs.getString("Name");
                variantsDAO = new VariantsDAO();
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

    /**
     * Retrieve all products ordered by creation date (descending).
     *
     * @return List of Products.
     */
    public List<Products> getProduct() {
        String sql = "SELECT * FROM Products ORDER BY CreatedAt DESC";
        List<Products> newListProduct = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            VariantsDAO variantsDAO;
            while (rs.next()) {
                int id = rs.getInt("ProductID");
                String name = rs.getString("Name");
                variantsDAO = new VariantsDAO();
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

    /**
     * Retrieve a product by its ID.
     *
     * @param pid Product ID.
     * @return Product object or null if not found.
     */
    public Products getProductByID(int pid) {
        String sql = "SELECT * FROM Products where ProductID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
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

                return (new Products(id, cateID, supplierID, name, brand, warrantyPeriod, createdAt));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Update product information by product ID.
     */
    public void updateProduct(int pID, int supplierID, String pName, String brand, int warrantyPeriod) {
        String sql = "UPDATE Products\n"
                + "SET SupplierID = ?,\n"
                + "    Name = ?,\n"
                + "    Brand = ?,\n"
                + "	WarrantyPeriod = ?\n"
                + "WHERE ProductID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, supplierID);
            ps.setString(2, pName);
            ps.setString(3, brand);
            ps.setInt(4, warrantyPeriod);
            ps.setInt(5, pID);
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Create a new product in the database.
     */
    public void createProduct(int categoryID, int supplierID, String pName, String brand, int warrantyPeriod) {
        String sql = "INSERT INTO Products (CategoryID, SupplierID, Name, Brand, WarrantyPeriod) "
                + "VALUES (?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryID);
            ps.setInt(2, supplierID);
            ps.setString(3, pName);
            ps.setString(4, brand);
            ps.setInt(5, warrantyPeriod);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Delete a product by its ID.
     */
    public void deleteProductByProductID(int pid) {
        String sql = "DELETE FROM Products\n"
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

    /**
     * Retrieve product name by product ID.
     */
    public String getNameByID(int productID) {
        String sql = "SELECT Name FROM Products where ProductID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String name = rs.getString("Name");
                return name;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Retrieve all categories from the database.
     *
     * @return List of Categories.
     */
    public List<Category> getAllCategory() {
        String sql = "Select * from Categories";
        List<Category> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int cateID = rs.getInt("CategoryID");
                String categoryName = rs.getString("CategoryName");
                String description = rs.getString("Description");
                list.add(new Category(cateID, categoryName, description));
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    /**
     * Retrieve all products by category ID. Each product includes its list of
     * variants.
     */
    public List<Products> getAllProductByCategory(int cID) {
        String sql = "SELECT Products.*\n"
                + "FROM   Products\n"
                + "WHERE (CategoryID = ?)";
        List<Products> list = new ArrayList<>();
        VariantsDAO vdao = new VariantsDAO();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cID);
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

                List<Variants> listVariant = vdao.getAllVariantByProductID(id);
                list.add(new Products(id, cateID, supplierID, name, brand, warrantyPeriod, createdAt, listVariant));
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    // Search theo tên sản phẩm
    public List<Products> getProductsByName(String name) {
        String sql = "SELECT * FROM Products WHERE Name LIKE ?";
        List<Products> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            VariantsDAO vdao = new VariantsDAO();
            while (rs.next()) {
                int id = rs.getInt("ProductID");
                int cateID = rs.getInt("CategoryID");
                int supplierID = rs.getInt("SupplierID");
                String pname = rs.getString("Name");
                String brand = rs.getString("Brand");
                int warrantyPeriod = rs.getInt("WarrantyPeriod");
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null) ? createdAtTimestamp.toLocalDateTime() : null;
                List<Variants> listVariant = vdao.getAllVariantByProductID(id);
                list.add(new Products(id, cateID, supplierID, pname, brand, warrantyPeriod, createdAt, listVariant));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

// Filter theo hãng (supplier)
    public List<Products> getProductsBySupplier(int supplierID) {
        String sql = "SELECT * FROM Products WHERE SupplierID = ?";
        List<Products> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, supplierID);
            ResultSet rs = ps.executeQuery();
            VariantsDAO vdao = new VariantsDAO();
            while (rs.next()) {
                int id = rs.getInt("ProductID");
                int cateID = rs.getInt("CategoryID");
                int sID = rs.getInt("SupplierID");
                String pname = rs.getString("Name");
                String brand = rs.getString("Brand");
                int warrantyPeriod = rs.getInt("WarrantyPeriod");
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null) ? createdAtTimestamp.toLocalDateTime() : null;
                List<Variants> listVariant = vdao.getAllVariantByProductID(id);
                list.add(new Products(id, cateID, sID, pname, brand, warrantyPeriod, createdAt, listVariant));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

// Filter theo cả tên sản phẩm + hãng
    public List<Products> getProductsByNameAndSupplier(String name, int supplierID) {
        String sql = "SELECT * FROM Products WHERE Name LIKE ? AND SupplierID = ?";
        List<Products> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            ps.setInt(2, supplierID);
            ResultSet rs = ps.executeQuery();
            VariantsDAO vdao = new VariantsDAO();
            while (rs.next()) {
                int id = rs.getInt("ProductID");
                int cateID = rs.getInt("CategoryID");
                int sID = rs.getInt("SupplierID");
                String pname = rs.getString("Name");
                String brand = rs.getString("Brand");
                int warrantyPeriod = rs.getInt("WarrantyPeriod");
                Timestamp createdAtTimestamp = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = (createdAtTimestamp != null) ? createdAtTimestamp.toLocalDateTime() : null;
                List<Variants> listVariant = vdao.getAllVariantByProductID(id);
                list.add(new Products(id, cateID, sID, pname, brand, warrantyPeriod, createdAt, listVariant));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public int getCurrentProductID() {
        String sql = "SELECT MAX(ProductID) AS ProductID \n"
                + "FROM Products;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("ProductID");
                return id;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public void createSpecification(int currentProductID, String os, String cpu, String gpu, String ram, int batteryCapacity, String touchscreen) {
        String sql = "INSERT INTO Specifications (ProductID, OS, CPU, GPU, RAM, BatteryCapacity, Touchscreen) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, currentProductID);
            ps.setString(2, os);
            ps.setString(3, cpu);
            ps.setString(4, gpu);
            ps.setString(5, ram);
            ps.setInt(6, batteryCapacity);
            ps.setString(7, touchscreen);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public List<InterestRate> getAllInterestRate() {
        String sql = "Select * from InterestRates";
        List<InterestRate> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("InterestRateID");
                int instalmentPeriod = rs.getInt("InstalmentPeriod");
                int percent = rs.getInt("Percent");
                

                

                list.add(new InterestRate(id, percent, instalmentPeriod));
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

   
    
}
