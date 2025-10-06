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
import jakarta.servlet.http.HttpSession;
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
        
//        // Cookie
//        
//        // 1. Tìm và xóa cookie "email"
//        Cookie cookieEmail = new Cookie("email", ""); 
//        cookieEmail.setMaxAge(0); // Đặt thời gian sống về 0 để xóa cookie ngay lập tức
//        response.addCookie(cookieEmail);
//
//        // 2. Tìm và xóa cookie "role"
//        Cookie cookieRole = new Cookie("role", "");
//        cookieRole.setMaxAge(0); // Đặt thời gian sống về 0
//        response.addCookie(cookieRole);
//        
//        // 3. Chuyển hướng về trang login
//        response.sendRedirect("login.jsp");



    // --- Logic Đăng xuất bằng Session: Hủy bỏ các thuộc tính 'email' và 'role' hoặc toàn bộ Session ---

    // 1. Lấy ra đối tượng Session hiện tại (hoặc null nếu chưa có)
    // 'false' nghĩa là không tạo Session mới nếu chưa có
    HttpSession session = request.getSession(false); 

    if (session != null) {
        // cách 1 Xóa từng thuộc tính (attributes) đã lưu trong Session
       
        
//        session.removeAttribute("email");
//        session.removeAttribute("role");
        
        // --- HOẶC ---
        
        // cách 2 Hủy toàn bộ Session (invalidate)
       
        
         session.invalidate(); 
    }

    // 2. Chuyển hướng về trang login
    response.sendRedirect("login.jsp");

    }

    /**
     * Phương thức POST được sử dụng để xử lý Đăng nhập (Login).
     */
@Override
protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

    // Bước 1, 2: Lấy dữ liệu, xác thực cơ bản, và kiểm tra đăng nhập
    String email = request.getParameter("username");
    String password = request.getParameter("password");

<<<<<<< Updated upstream
    // Kiểm tra tính hợp lệ cơ bản
    if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
        request.setAttribute("error", "Email and password cannot be empty.");
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
        return;
=======
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
                response.sendRedirect("admin"); 
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
>>>>>>> Stashed changes
    }

    // Giả định UsersDAO và Users class có các phương thức cần thiết
    UsersDAO dao = new UsersDAO(); 
    Users u = dao.login(email, password);

    // Bước 3: Kiểm tra kết quả đăng nhập
    if (u != null) { // Đăng nhập thành công

       
        HttpSession session = request.getSession(); // Lấy hoặc tạo mới Session

        // Lưu toàn bộ User object vào Session 
        session.setAttribute("user", u); 

//        // HOẶC (Lưu riêng lẻ)
//        session.setAttribute("email", u.getEmail());
//        // Giả sử Users class có phương thức getId()
//        session.setAttribute("id_user", u.getUserId()); 
//
        String roleValue = (u.getRole() != null) ? u.getRole().toString() : "1";
//        session.setAttribute("role", roleValue); // Lưu Role vào Session

        
        
        
        if (roleValue.equals("4")) {
            // Role Admin
            response.sendRedirect("dashboard_admin.jsp");
        } else if (roleValue.equals("3")) {
            // Role Shipper
            response.sendRedirect("order");
        } else if (roleValue.equals("2")) {
            // Role Staff
            response.sendRedirect("dashboard_staff.jsp");
        } else if (roleValue.equals("1")) {
            // Role User/Khách hàng
            response.sendRedirect("homepage.jsp");
        } else {
            // Trường hợp Role không xác định
            response.sendRedirect("homepage.jsp");
        }

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