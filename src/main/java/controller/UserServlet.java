/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UsersDAO;
import dao.CategoryDAO; // ✅ thêm import này
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Users;
import model.Category;

/**
 * Servlet Controller to handle user profile actions.
 *
 * Handles:
 * - Viewing profile (profile.jsp)
 * - Editing profile (editProfile.jsp)
 * - Updating profile (POST)
 *
 * URL patterns:
 * GET /user?action=view -> show profile.jsp
 * GET /user?action=edit -> show editProfile.jsp
 * POST /user?action=update -> save profile updates
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {

    private final UsersDAO usersDAO = new UsersDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ Load listCategory để hiển thị trên header
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> listCategory = categoryDAO.getAllCategories();
        request.setAttribute("listCategory", listCategory);

        switch (action) {
            case "edit":
                request.setAttribute("user", user);
                request.getRequestDispatcher("editProfile.jsp").forward(request, response);
                break;

            case "view":
            default:
                request.setAttribute("user", user);
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                break;
            case "changePassword":
                request.getRequestDispatcher("changePassword.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ Load category cho header
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> listCategory = categoryDAO.getAllCategories();
        request.setAttribute("listCategory", listCategory);

        // ✅ Phân biệt 2 hành động: cập nhật profile và đổi mật khẩu
        if ("update".equals(action)) {
            // ---------- Cập nhật hồ sơ ----------
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String password = request.getParameter("password");

            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setPassword(password);

            usersDAO.updateUserProfile(user);
            session.setAttribute("user", user);

            request.setAttribute("message", "Cập nhật hồ sơ thành công!");
            request.setAttribute("user", user);
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);

        } else if ("updatePassword".equals(action)) {
            // ---------- Đổi mật khẩu ----------
            String oldPass = request.getParameter("oldPassword");
            String newPass = request.getParameter("newPassword");
            String confirmPass = request.getParameter("confirmPassword");

            if (oldPass == null || newPass == null || confirmPass == null
                    || oldPass.isEmpty() || newPass.isEmpty() || confirmPass.isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            } else if (!user.getPassword().equals(oldPass)) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            } else if (!newPass.equals(confirmPass)) {
                request.setAttribute("error", "Mật khẩu xác nhận không trùng khớp!");
            } else {
                usersDAO.updatePassword(user.getUserId(), newPass);
                user.setPassword(newPass); // cập nhật lại session
                session.setAttribute("user", user);
                request.setAttribute("message", "Đổi mật khẩu thành công!");
            }

            request.getRequestDispatcher("changePassword.jsp").forward(request, response);

        } else {
            // Không có action hợp lệ
            response.sendRedirect("user?action=view");
        }
    }
}
