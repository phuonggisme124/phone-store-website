package dao;

import model.Category;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho đối tượng Category, thực hiện các thao tác
 * với bảng Category trong cơ sở dữ liệu.
 */
public class CategoryDAO extends DBContext {

    // Helper method để ánh xạ ResultSet sang đối tượng Category
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        int id = rs.getInt("CategoryID");
        String name = rs.getString("CategoryName");
        String description = rs.getString("Description"); // Có thể là null

        // Description có thể null, rs.getString() tự động trả về null nếu giá trị CSDL là NULL
        return new Category(id, name, description);
    }

    // --- Phương thức 1: Lấy tất cả Categories ---
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName, Description FROM Categories";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    // --- Phương thức 2: Lấy Category theo ID ---
    public Category getCategoryById(int id) {
        Category category = null;
        String sql = "SELECT CategoryID, CategoryName, Description FROM Category WHERE CategoryID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
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

    // --- Phương thức 3: Thêm Category mới ---
    public boolean createCategory(Category category) {
        // Giả định CategoryID là IDENTITY (tự tăng) trong CSDL.
        // Nếu không, bạn cần thêm CategoryID vào câu lệnh SQL và setInt() cho nó.
        String sql = "INSERT INTO Category (CategoryName, Description) VALUES (?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getCategoryName());
            
            // Xử lý trường Description có thể null
            if (category.getDescription() != null) {
                stmt.setString(2, category.getDescription());
            } else {
                stmt.setNull(2, Types.NVARCHAR); // hoặc Types.VARCHAR tùy thuộc vào driver
            }
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error creating category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // --- Phương thức 4: Cập nhật Category hiện có ---
    public boolean updateCategory(Category category) {
        String sql = "UPDATE Category SET CategoryName = ?, Description = ? WHERE CategoryID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getCategoryName());
            
            // Xử lý trường Description có thể null
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

    // --- Phương thức 5: Xóa Category theo ID ---
    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM Category WHERE CategoryID = ?";
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
    
    // --- Main Method (Để kiểm tra) ---
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
}