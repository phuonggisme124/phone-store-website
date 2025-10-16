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
 *   GET  /user?action=view   -> show profile.jsp
 *   GET  /user?action=edit   -> show editProfile.jsp
 *   POST /user?action=update -> save profile updates
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {

    private final UsersDAO usersDAO = new UsersDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "view";

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
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (!"update".equals(action)) {
            response.sendRedirect("user?action=view");
            return;
        }

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("user");
            return;
        }

        // Get form data
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        // Update user object
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setPassword(password);

        // Update database
        usersDAO.updateUserProfile(user);

        // Save updated user back to session
        session.setAttribute("user", user);

        // ✅ Load lại category để header không mất khi reload trang
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> listCategory = categoryDAO.getAllCategories();
        request.setAttribute("listCategory", listCategory);

        // Send success message and reload page
        request.setAttribute("message", "Profile updated successfully!");
        request.setAttribute("user", user);
        request.getRequestDispatcher("editProfile.jsp").forward(request, response);
    }
}
