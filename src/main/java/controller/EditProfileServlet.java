/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
 /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Users;
import dao.UsersDAO;
import model.Categories;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "EditProfileServlet", urlPatterns = {"/editProfile"})
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Gửi user hiện tại qua JSP để hiển thị thông tin
        request.setAttribute("user", currentUser);

        // Chuyển tiếp đến trang editProfile.jsp
        request.getRequestDispatcher("editProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập encoding tránh lỗi tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy user đang đăng nhập
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        // Cập nhật dữ liệu vào object user
        currentUser.setFullName(fullName);
        currentUser.setEmail(email);
        currentUser.setPhone(phone);
        currentUser.setAddress(address);

        if (password != null && !password.trim().isEmpty()) {
            currentUser.setPassword(password);
        }

        // Gọi DAO để update database
        UsersDAO dao = new UsersDAO();
        try {
            dao.updateUser(
                    currentUser.getUserId(),
                    currentUser.getFullName(),
                    currentUser.getEmail(),
                    currentUser.getPhone(),
                    currentUser.getAddress(),
                    currentUser.getRole() != null ? currentUser.getRole() : 1, // mặc định 1 nếu null
                    currentUser.getStatus() != null ? currentUser.getStatus() : "active"
            );

            // Cập nhật lại session
            session.setAttribute("user", currentUser);
            request.setAttribute("message", "Cập nhật thông tin thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Cập nhật thất bại, vui lòng thử lại!");
        }

        // Quay lại trang profile.jsp
        RequestDispatcher rd = (RequestDispatcher) request.getRequestDispatcher("editProfile.jsp");
        rd.forward(request, response);
    }
}
