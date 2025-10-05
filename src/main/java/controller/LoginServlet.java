/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UsersDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;

/**
 * Servlet xử lý đăng nhập và đăng xuất người dùng.
 *
 * @author nguyen quoc thinh - CE000000 - 05/10/2025
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    /**
     * Phương thức GET được sử dụng để xử lý Đăng xuất (Logout) bằng cách xóa cookie.
     */
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        
        // --- Logic Đăng xuất bằng Cookie: Xóa cookie 'email' và 'role' ---
        
        // 1. Tìm và xóa cookie "email"
        Cookie cookieEmail = new Cookie("email", ""); 
        cookieEmail.setMaxAge(0); // Đặt thời gian sống về 0 để xóa cookie ngay lập tức
        response.addCookie(cookieEmail);

        // 2. Tìm và xóa cookie "role"
        Cookie cookieRole = new Cookie("role", "");
        cookieRole.setMaxAge(0); // Đặt thời gian sống về 0
        response.addCookie(cookieRole);
        
        // 3. Chuyển hướng về trang login
        response.sendRedirect("login.jsp");
    }

    /**
     * Phương thức POST được sử dụng để xử lý Đăng nhập (Login).
     */
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        
        // Bước 1, 2, 3: (Giữ nguyên logic lấy dữ liệu, xác thực, và kiểm tra kết quả đăng nhập)
        String email = request.getParameter("username"); 
        String password = request.getParameter("password");
        
        // Kiểm tra tính hợp lệ cơ bản
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Email and password cannot be empty.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        UsersDAO dao = new UsersDAO();
        Users u = dao.login(email, password); 

        // Bước 3: Kiểm tra kết quả đăng nhập
        if (u != null) { // Đăng nhập thành công
            
            // A. Gán User vào Session
            request.getSession().setAttribute("user", u);
            
            // B. Gán cookie
            // Lưu EMAIL vào cookie
            Cookie cookieEmail = new Cookie("email", u.getEmail()); 
            cookieEmail.setMaxAge(60 * 60); 
            response.addCookie(cookieEmail);

            // Gán Role vào cookie 
            String roleValue = (u.getRole() != null) ? u.getRole().toString() : "1"; // Mặc định role là 1 nếu null
            Cookie cookieRole = new Cookie("role", roleValue);
            cookieRole.setMaxAge(60 * 60); 
            response.addCookie(cookieRole);
            
            
            // =========================================================
            // BƯỚC 4: THÊM LOGIC CHUYỂN HƯỚNG THEO ROLE (ĐÃ SỬA) 🚀
            // =========================================================
            if (roleValue.equals("4") ) {
                // Nếu role là 4, chuyển hướng đến dashboard.jsp
                response.sendRedirect("dashboard_admin.jsp"); 
            } 
            else if (roleValue.equals("3") ) {
                // Nếu role là 4, chuyển hướng đến dashboard.jsp
                response.sendRedirect("dashboard_shipper.jsp"); 
            }
            else if (roleValue.equals("2") ) {
                // Nếu role là 4, chuyển hướng đến dashboard.jsp
                response.sendRedirect("dashboard_staff.jsp"); 
            }else if (roleValue.equals("1") ){
                // Các role khác (hoặc role mặc định) chuyển hướng đến homepage.jsp
                response.sendRedirect("homepage.jsp");
            }
            // =========================================================

        } else {
            // Đăng nhập thất bại
            request.setAttribute("error", "Invalid email or password.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for handling user login and logout.";
    }
}