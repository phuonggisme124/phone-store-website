/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
        // Tạo session mới để tránh null pointer khi login lại ngay lập tức
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("attempts", 0);
        response.sendRedirect("login.jsp");
    }

    /**
     * Handles user login functionality.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
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
                // Role 1 mặc định cho khách hàng Google
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
            request.setAttribute("error", "Email and password cannot be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Check Login
        Customer customer = customerDAO.login(email, password);

        // Case A: Login Success but Account Blocked
        if (customer != null && "block".equalsIgnoreCase(customer.getStatus())) {
            request.setAttribute("error", "Your account has been locked.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        } 
        
        // Case B: Login Success
        else if (customer != null) {
            session.setAttribute("user", customer);
            session.setAttribute("attempts", 0); // Reset attempts

            // Xử lý Redirect URL (nếu user đang xem dở sản phẩm mà bị bắt login)
            // Chỉ áp dụng cho Customer (Role 1)
            if (customer.getRole() == 1) {
                if (redirect != null && !redirect.isEmpty()) {
                    try {
                        String decodedURL = URLDecoder.decode(redirect, StandardCharsets.UTF_8);
                        List<Carts> carts = cartDAO.getItemIntoCartByUserID(customer.getCustomerID());
                        session.setAttribute("cart", carts);
                        response.sendRedirect(decodedURL);
                        return;
                    } catch (Exception e) {
                        System.err.println("Error decoding redirect URL: " + e.getMessage());
                    }
                }
            }

            // Phân quyền chuyển hướng (Role Switching)
            // Lưu ý: Cần đảm bảo model Customer có phương thức getRole()
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
                    List<Carts> carts = cartDAO.getItemIntoCartByUserID(customer.getCustomerID());
                    session.setAttribute("cart", carts);
                    response.sendRedirect("homepage");
                    break;
            }

        } 
        // Case C: Login Failed (Wrong Password or Email not found)
        else {
            // Kiểm tra xem Email có tồn tại không để tính số lần sai
            if (customerDAO.emailExists(email)) {
                int attempts = (int) session.getAttribute("attempts");
                
                if (attempts < 5) {
                    int newAttempts = attempts + 1;
                    session.setAttribute("attempts", newAttempts);
                    request.setAttribute("error", "Invalid password. Attempt: " + newAttempts + "/5");
                } else {
                    request.setAttribute("error", "You have entered the wrong password more than 5 times. Your account has been locked.");
                    // Khóa tài khoản
                    customerDAO.updateCustomerStatus("block", email);
                }
            } else {
                // Email không tồn tại
                request.setAttribute("error", "Invalid email or password.");
            }
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling customer login and logout.";
    }
}