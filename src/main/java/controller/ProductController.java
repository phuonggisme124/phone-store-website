package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal; // Cần thiết
import java.time.LocalDateTime; // Cần thiết
import java.util.List;
import model.Product;
import model.Users;
// import model.Category; // Không cần thiết nếu không dùng đối tượng Category

@WebServlet(name = "ProductController", urlPatterns = {"/Product"})
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // --- Logic kiểm tra đăng nhập (Giữ nguyên) ---
        String username = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    username = cookie.getValue();
                }
            }
        }
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // --- Kết thúc Logic kiểm tra đăng nhập ---

        ProductDAO dao = new ProductDAO();
        String action = request.getParameter("action");

        if (action == null) {
            action = "list"; // Default action
        }

        if (action.equalsIgnoreCase("list")) {
            List<Product> list = dao.getAllProducts();
            request.setAttribute("data", list);
            request.getRequestDispatcher("product.jsp").forward(request, response);
        } else if (action.equalsIgnoreCase("create")) {
            // Có thể thêm CategoryDAO để load danh sách Category
            request.getRequestDispatcher("create.jsp").forward(request, response);
        } else if (action.equalsIgnoreCase("update")) {
            String idRaw = request.getParameter("id");
            try {
                int id = Integer.parseInt(idRaw);
                Product product = dao.getProductById(id);
                request.setAttribute("product", product);
                request.getRequestDispatcher("update.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                 response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Product ID format.");
            }
        } else if (action.equalsIgnoreCase("delete")) {
             String idRaw = request.getParameter("id");
            try {
                int id = Integer.parseInt(idRaw);
                Product product = dao.getProductById(id); 
                request.setAttribute("product", product); 
                request.getRequestDispatcher("delete.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                 response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Product ID format.");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Thiết lập mã hóa để nhận dữ liệu Tiếng Việt (nếu cần)
        request.setCharacterEncoding("UTF-8"); 
        
        // --- Logic kiểm tra đăng nhập (Giữ nguyên) ---
        String username = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    username = cookie.getValue();
                }
            }
        }
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // --- Kết thúc Logic kiểm tra đăng nhập ---

        ProductDAO dao = new ProductDAO();
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("Product");
            return;
        }

        if (action.equalsIgnoreCase("create")) {
            handleCreate(request, response, dao);
        } else if (action.equalsIgnoreCase("update")) {
            handleUpdate(request, response, dao);
        } else if (action.equalsIgnoreCase("delete")) {
            handleDelete(request, response, dao);
        }
    }
    
    // --- Helper method để xử lý logic CREATE ---
    private void handleCreate(HttpServletRequest request, HttpServletResponse response, ProductDAO dao) 
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form (cập nhật tên tham số và kiểu dữ liệu)
            // Các trường NOT NULL
            String name = request.getParameter("name");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            
            // Các trường Allow Nulls
            Integer categoryId = parseIntegerOrNull(request.getParameter("categoryId"));
            Integer supplierId = parseIntegerOrNull(request.getParameter("supplierId"));
            String brand = request.getParameter("brand");
            BigDecimal discountPrice = parseBigDecimalOrNull(request.getParameter("discountPrice"));
            Integer stock = parseIntegerOrNull(request.getParameter("stock"));
            Integer warrantyPeriod = parseIntegerOrNull(request.getParameter("warrantyPeriod"));
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            // CreatedAt thường được CSDL tự động tạo, hoặc gán thủ công là LocalDateTime.now()
            LocalDateTime createdAt = LocalDateTime.now(); 
            
            // Tạo đối tượng Product bằng constructor đầy đủ (productId = 0 vì là ID tự tăng)
            Product product = new Product(
                    0, categoryId, supplierId, name, brand, price,
                    discountPrice, stock, warrantyPeriod, description, imageUrl, createdAt
            );

            boolean success = dao.createProduct(product);
            if (success) {
                response.sendRedirect("Product"); 
            } else {
                request.setAttribute("error", "Failed to create product. Check database constraints or required fields.");
                request.getRequestDispatcher("create.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid data format for Price, Category ID, Supplier ID, Stock or Warranty: " + e.getMessage());
            request.getRequestDispatcher("create.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error creating product: " + e.getMessage());
            e.printStackTrace();
            request.getRequestDispatcher("create.jsp").forward(request, response);
        }
    }
    
    // --- Helper method để xử lý logic UPDATE ---
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, ProductDAO dao) 
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId")); // Lấy ID cần update
            
            // Lấy dữ liệu mới từ form
            String name = request.getParameter("name");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            
            Integer categoryId = parseIntegerOrNull(request.getParameter("categoryId"));
            Integer supplierId = parseIntegerOrNull(request.getParameter("supplierId"));
            String brand = request.getParameter("brand");
            BigDecimal discountPrice = parseBigDecimalOrNull(request.getParameter("discountPrice"));
            Integer stock = parseIntegerOrNull(request.getParameter("stock"));
            Integer warrantyPeriod = parseIntegerOrNull(request.getParameter("warrantyPeriod"));
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");

            // Lấy CreatedAt cũ từ CSDL để tránh cập nhật nó nếu không cần thiết
            Product existingProduct = dao.getProductById(productId);
            LocalDateTime createdAt = (existingProduct != null) ? existingProduct.getCreatedAt() : LocalDateTime.now();
            
            // Tạo đối tượng Product để truyền vào DAO
            Product product = new Product(
                    productId, categoryId, supplierId, name, brand, price,
                    discountPrice, stock, warrantyPeriod, description, imageUrl, createdAt
            );
            
            boolean updated = dao.updateProduct(product);
            if (updated) {
                 response.sendRedirect("Product"); // Redirect to product list after update
            } else {
                request.setAttribute("product", product);
                request.setAttribute("error", "Failed to update product. Product ID might be incorrect.");
                request.getRequestDispatcher("update.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid data format: " + e.getMessage());
            request.getRequestDispatcher("update.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error updating product: " + e.getMessage());
            e.printStackTrace();
            request.getRequestDispatcher("update.jsp").forward(request, response);
        }
    }
    
    // --- Helper method để xử lý logic DELETE ---
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, ProductDAO dao) 
            throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("productId"); // Đổi tên tham số từ pro_id -> productId
            if (idRaw == null || idRaw.trim().isEmpty()) {
                throw new Exception("Product ID is missing");
            }
            int id = Integer.parseInt(idRaw);
            boolean deleted = dao.deleteProduct(id); 

            if (deleted) {
                response.sendRedirect("Product"); 
            } else {
                Product product = dao.getProductById(id);
                request.setAttribute("product", product);
                request.setAttribute("error", "Failed to delete product. It might be referenced elsewhere or does not exist.");
                request.getRequestDispatcher("delete.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            int productId = -1;
            try {
                productId = Integer.parseInt(request.getParameter("productId"));
            } catch(NumberFormatException ex) { /* ignore */ }
            
            request.setAttribute("product", (productId != -1) ? dao.getProductById(productId) : null);
            request.setAttribute("error", "Invalid product ID or server error: " + e.getMessage());
            request.getRequestDispatcher("delete.jsp").forward(request, response);
        }
    }
    
    // --- Helper function for parsing optional Integer fields (Allow Nulls) ---
    private Integer parseIntegerOrNull(String rawValue) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(rawValue);
        } catch (NumberFormatException e) {
            // Throw exception or handle error if the format is invalid but input is present
            throw new NumberFormatException("Invalid integer format for value: " + rawValue);
        }
    }
    
    // --- Helper function for parsing optional BigDecimal fields (Allow Nulls) ---
    private BigDecimal parseBigDecimalOrNull(String rawValue) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            return null;
        }
        try {
            return new BigDecimal(rawValue);
        } catch (NumberFormatException e) {
            throw new NumberFormatException("Invalid decimal format for value: " + rawValue);
        }
    }
}