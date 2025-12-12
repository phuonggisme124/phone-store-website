package controller;

import dao.CartDAO;
import dao.CustomerDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import model.Carts;
import model.Customer;

/**
 * Servlet that handles customer login and logout functionality.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    /**
     * Handles user logout by invalidating the current session.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Redirect về trang login, session mới sẽ được tạo khi cần
        response.sendRedirect("login.jsp");
    }

    /**
     * Handles user login functionality.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Khởi tạo attempt nếu chưa có
        if (session.getAttribute("attempts") == null) {
            session.setAttribute("attempts", 0);
        }

        String action = request.getParameter("action");
        CustomerDAO customerDAO = new CustomerDAO();
        CartDAO cartDAO = new CartDAO();

        // -----------------------------------------------------
        // 1. LOGIN WITH GOOGLE
        // -----------------------------------------------------
        if (action != null && action.equalsIgnoreCase("googleLogin")) {
            String email = request.getParameter("email");
            String name = request.getParameter("name");
            
            if (email != null && name != null) {
                // SỬA LỖI: Gọi phương thức registerForLoginWithGoogle CHỈ VỚI 2 THAM SỐ
                customerDAO.registerForLoginWithGoogle(name, email); 
                
                Customer customer = customerDAO.loginWithEmail(email);
                
                if (customer != null) {
                    session.setAttribute("user", customer);
                    // Lấy giỏ hàng
                    List<Carts> carts = cartDAO.getItemIntoCartByUserID(customer.getCustomerID());
                    session.setAttribute("cart", carts);
                    
                    response.sendRedirect("homepage");
                    return;
                }
            }
        }

        // -----------------------------------------------------
        // 2. NORMAL LOGIN
        // -----------------------------------------------------
        String email = request.getParameter("username"); // Form field name
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Email và mật khẩu không được để trống.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Check Login
        Customer customer = customerDAO.login(email, password);

        // Case A: Login Success but Account Blocked
        if (customer != null && "block".equalsIgnoreCase(customer.getStatus())) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Case B: Login Success
        else if (customer != null) {
            session.setAttribute("user", customer);
            session.setAttribute("attempts", 0); // Reset attempts

            // Lấy giỏ hàng cho tất cả các role có thể có giỏ hàng (khách hàng)
            // Cập nhật giỏ hàng ngay khi đăng nhập thành công
            List<Carts> carts = cartDAO.getItemIntoCartByUserID(customer.getCustomerID());
            session.setAttribute("cart", carts);
            
            // Xử lý Redirect URL (chỉ áp dụng cho Customer)
            if (customer.getRole() == 1 && redirect != null && !redirect.isEmpty()) {
                try {
                    String decodedURL = URLDecoder.decode(redirect, StandardCharsets.UTF_8.name());
                    response.sendRedirect(decodedURL);
                    return;
                } catch (Exception e) {
                    System.err.println("Error decoding redirect URL: " + e.getMessage());
                }
            }

            // Phân quyền chuyển hướng (Role Switching)
            int role = customer.getRole(); 

            switch (role) {
                case 4: // Admin
                    response.sendRedirect("admin");
                    break;
                case 3: // Shipper/Manager
                    response.sendRedirect("order");
                    break;
                case 2: // Staff
                    response.sendRedirect("product");
                    break;
                case 1: // Customer
                default:
                    response.sendRedirect("homepage");
                    break;
            }

        }
        // Case C: Login Failed (Wrong Password or Email not found)
        else {
            // SỬA LỖI: Thay thế getCustomerByEmail bằng emailExists
            if (customerDAO.emailExists(email)) {
                int attempts = (int) session.getAttribute("attempts");
                
                if (attempts < 5) {
                    int newAttempts = attempts + 1;
                    session.setAttribute("attempts", newAttempts);
                    request.setAttribute("error", "Mật khẩu không hợp lệ. Lần thử: " + newAttempts + "/5");
                } else {
                    request.setAttribute("error", "Bạn đã nhập sai mật khẩu quá 5 lần. Tài khoản của bạn đã bị khóa.");
                    // SỬA LỖI: Gọi phương thức updateStatus (giả định đã thêm vào DAO)
                    customerDAO.updateStatus("block", email); 
                    session.removeAttribute("attempts"); // Xóa attempts sau khi khóa
                }
            } else {
                // Email không tồn tại
                request.setAttribute("error", "Email hoặc mật khẩu không hợp lệ.");
            }
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling customer login and logout.";
    }
}