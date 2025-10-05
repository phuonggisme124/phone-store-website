/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet xử lý Đăng xuất (Logout) bằng cách xóa Cookie.
 *
 * @author admin
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    // (Bỏ qua processRequest và các methods không cần thiết)

    /**
     * Handles the HTTP <code>GET</code> method (Thường dùng cho Logout).
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    // BƯỚC 1: HỦY SESSION (Điều này xóa thuộc tính "user" khỏi Session)
    // Đây là bước quan trọng nhất để đăng xuất
    HttpSession session = request.getSession(false); // Lấy session hiện tại, không tạo mới
    if (session != null) {
        session.invalidate(); // Hủy toàn bộ session
    }

    // BƯỚC 2: Xóa Cookie (dành cho trường hợp Remember Me hoặc kiểm tra nhanh)
    
    // 2.1. Xóa cookie "email"
    Cookie cookieEmail = new Cookie("email", ""); 
    cookieEmail.setMaxAge(0); // Đặt MaxAge = 0 để xóa ngay lập tức
    response.addCookie(cookieEmail);
    
    // 2.2. Xóa cookie "role"
    Cookie cookieRole = new Cookie("role", ""); 
    cookieRole.setMaxAge(0); 
    response.addCookie(cookieRole);
    
    // (Bỏ phần xóa cookie "username" bị lỗi và dư thừa)

    // BƯỚC 3: Chuyển hướng người dùng về trang chủ (hoặc trang đăng nhập)
    // Nếu chuyển về homepage.jsp, homepage.jsp sẽ thấy Session đã bị hủy và hiển thị "Hello Guest"
    response.sendRedirect("homepage.jsp");
}

    /**
     * Handles the HTTP <code>POST</code> method.
     * (Thường không dùng cho logout, giữ nguyên gọi processRequest hoặc loại bỏ)
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể gọi lại doGet() hoặc chỉ chuyển hướng người dùng
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles user logout by deleting authentication cookies.";
    }
}