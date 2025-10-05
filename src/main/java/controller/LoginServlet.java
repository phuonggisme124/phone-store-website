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
 * @author Vo Hoang Tu - CE000000 - 20/05/2025
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
        
        // Bước 1: Lấy dữ liệu từ form
        // Form trong login.jsp dùng name="username" cho Email và name="password" cho Mật khẩu.
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
        // Bước 2: Gọi phương thức login để xác thực người dùng
        Users u = dao.login(email, password); 

        // Bước 3: Kiểm tra kết quả đăng nhập
        if (u != null) { // Đăng nhập thành công (UsersDAO.login trả về null nếu thất bại)
            
            // Đăng nhập thành công -> Tạo cookie và Session
            
            // A. Gán User vào Session (Tốt hơn là chỉ gán các thông tin cần thiết)
            // Lưu đối tượng User vào Session để truy cập dễ dàng hơn
            request.getSession().setAttribute("user", u);
            
            // B. Gán cookie (dành cho việc ghi nhớ đăng nhập hoặc kiểm tra nhanh)
            
            // Lưu EMAIL vào cookie
            Cookie cookieEmail = new Cookie("email", u.getEmail()); 
            cookieEmail.setMaxAge(60 * 60); // Tồn tại 1 tiếng
            response.addCookie(cookieEmail);

            // Gán Role vào cookie 
            String roleValue = (u.getRole() != null) ? u.getRole().toString() : "1"; // Mặc định role là 2 nếu null
            Cookie cookieRole = new Cookie("role", roleValue);
            cookieRole.setMaxAge(60 * 60); // Tồn tại 1 tiếng
            response.addCookie(cookieRole);

            // Bước 4: Chuyển hướng đến Product
            response.sendRedirect("homepage.jsp");

        } else {
            // Đăng nhập thất bại -> Gửi lại về trang login với thông báo lỗi
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