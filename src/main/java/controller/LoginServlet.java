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
     * Xử lý Đăng xuất (Logout) bằng cách hủy session.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Hủy toàn bộ session
        }

        response.sendRedirect("login.jsp"); // Quay lại trang đăng nhập
    }

    /**
     * Xử lý Đăng nhập (Login)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("username");
        String password = request.getParameter("password");

        // Kiểm tra dữ liệu rỗng
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Email and password cannot be empty.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Gọi DAO kiểm tra đăng nhập
        UsersDAO dao = new UsersDAO();
        Users u = dao.login(email, password);

        if (u != null) { // Đăng nhập thành công
            HttpSession session = request.getSession();
            session.setAttribute("user", u); // Lưu user object vào session

            String roleValue = (u.getRole() != null) ? u.getRole().toString() : "1";

            // Chuyển hướng theo vai trò
            switch (roleValue) {
                case "4":
                    response.sendRedirect("dashboard_admin.jsp");
                    break;
                case "3":
                    response.sendRedirect("order");
                    break;
                case "2":
                    response.sendRedirect("dashboard_staff.jsp");
                    break;
                case "1":
                default:
                    response.sendRedirect("homepage.jsp");
                    break;
            }

        } else { // Sai email hoặc mật khẩu
            request.setAttribute("error", "Invalid email or password.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling user login and logout.";
    }
}
