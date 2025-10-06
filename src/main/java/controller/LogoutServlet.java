/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
// KHÔNG CẦN import jakarta.servlet.http.Cookie; nữa
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet xử lý Đăng xuất (Logout) bằng cách hủy Session.
 *
 * @author admin
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

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
        
        // BƯỚC 1: HỦY SESSION (Đây là bước quan trọng nhất để đăng xuất) 🚀
        HttpSession session = request.getSession(false); // Lấy session hiện tại, không tạo mới
        
        if (session != null) {
            // Hủy toàn bộ Session, xóa tất cả các thuộc tính đã lưu (user, email, role,...)
            session.invalidate(); 
        }

        // BƯỚC 2: Chuyển hướng người dùng về trang chủ (hoặc trang đăng nhập)
        // Khi Session bị hủy, mọi trang được bảo vệ sẽ tự động chuyển hướng về login.jsp.
        response.sendRedirect("homepage.jsp");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles user logout by invalidating the HttpSession.";
    }
}