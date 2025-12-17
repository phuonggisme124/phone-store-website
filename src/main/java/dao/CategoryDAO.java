package dao;

import model.Category;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.OrderDetails;
import model.Suppliers;
import model.Variants;

/**
 * Data Access Object (DAO) class for handling operations related to the
 * Category entity in the database.
 *
 * This class provides methods for performing CRUD (Create, Read, Update,
 * Delete) operations on the "Category" table using JDBC.
 *
 * Author: ADMIN
 */
public class CategoryDAO extends DBContext {

    // Default constructor that calls the superclass DBContext to initialize DB connection
    public CategoryDAO() {
        super();
    }

    /**
     * Helper method that maps a single ResultSet row to a Category object.
     *
     * @param rs The ResultSet returned from executing a SQL query
     * @return Category object created from the current ResultSet row
     * @throws SQLException if a database access error occurs
     */
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        int id = rs.getInt("CategoryID");
        String name = rs.getString("CategoryName");
        String description = rs.getString("Description"); // May be null if not provided

        // If the value in the database is NULL, rs.getString() automatically returns null
        return new Category(id, name, description);
    }

    // ==============================================================
    // Method 1: Retrieve all categories from the database
    // ==============================================================
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName, Description FROM Categories";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            // Iterate through the result set and map each row to a Category object
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    // ==============================================================
    // Method 2: Retrieve a category by its ID
    // ==============================================================
    public Category getCategoryById(int id) {
        Category category = null;
        String sql = "SELECT CategoryID, CategoryName, Description FROM Categories WHERE CategoryID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                // If the record exists, map it to a Category object
                if (rs.next()) {
                    category = mapResultSetToCategory(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching category by ID " + id + ": " + e.getMessage());
            e.printStackTrace();
        }
        return category;
    }

    // ==============================================================
    // Method 3: Create a new category in the database
    // ==============================================================
    public boolean createCategory(Category category) {
        // Assumes CategoryID is auto-increment (IDENTITY) in the database.
        // If not, add CategoryID to the SQL and set it manually.
        String sql = "INSERT INTO Categories (CategoryName, Description) VALUES (?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getCategoryName());

            // Handle null description value
            if (category.getDescription() != null) {
                stmt.setString(2, category.getDescription());
            } else {
                stmt.setNull(2, Types.NVARCHAR); // Or Types.VARCHAR depending on the DB driver
            }

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error creating category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Method 4: Update an existing category
    // ==============================================================
    public boolean updateCategory(Category category) {
        String sql = "UPDATE Categories SET CategoryName = ?, Description = ? WHERE CategoryID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getCategoryName());

            // Handle possible null description
            if (category.getDescription() != null) {
                stmt.setString(2, category.getDescription());
            } else {
                stmt.setNull(2, Types.NVARCHAR);
            }

            stmt.setInt(3, category.getCategoryId()); // WHERE clause

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating category with ID " + category.getCategoryId() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ==============================================================
    // Method 5: Delete a category by its ID
    // ==============================================================
    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM Categories WHERE CategoryID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting category with ID " + id + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ==============================================================
    // Main method for testing database functionality
    // ==============================================================
    public static void main(String[] args) {
        CategoryDAO dao = new CategoryDAO();
        System.out.println("--- All Categories ---");
        List<Category> list = dao.getAllCategories();

        if (list.isEmpty()) {
            System.out.println("No data.");
        } else {
            for (Category c : list) {
                System.out.println(c);
            }
        }
    }

    public Category getCategoryByCategoryID(int cateID) {

        String sql = "SELECT * FROM Categories WHERE CategoryID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cateID);
            ResultSet rs = ps.executeQuery();

            // If a record exists, build a supplier object
            if (rs.next()) {
                int id = rs.getInt("CategoryID");
                String name = rs.getString("CategoryName");
                String description = rs.getString("Description");

                return new Category(id, name, description);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;

    }

    public void editCategory(int cateID, String name, String description) {
        String sql = "UPDATE Categories SET CategoryName = ?, Description = ? WHERE CategoryID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setInt(3, cateID);
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void removeCategory(int cateID) {
        String sql = "DELETE FROM Categories\n"
                + "WHERE CategoryID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            // Set the supplier ID to delete
            ps.setInt(1, cateID);

            // Execute the delete operation
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void createCategory(String name, String description) {
        String sql = "INSERT INTO Categories (CategoryName, Description) "
                + "VALUES (?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            // Insert new supplier information
            ps.setString(1, name);
            ps.setString(2, description);
            

            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
