/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.CustomerDAO;
import dao.StaffDAO;
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
import model.Staff;

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

        String email = request.getParameter("username");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        CustomerDAO customerDAO = new CustomerDAO();
        CartDAO cartDAO = new CartDAO();
        StaffDAO staffDAO = new StaffDAO();

        // Validate input
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Email and password cannot be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // ===============================
        // 1. CUSTOMER LOGIN
        // ===============================
        Customer customer = customerDAO.login(email, password);

        if (customer != null) {

            // Check block
            if ("block".equalsIgnoreCase(customer.getStatus())) {
                request.setAttribute("error", "Your account has been locked.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            session.setAttribute("user", customer);
            session.setAttribute("role", customer.getRole());
            session.setAttribute("attempts", 0);

            // Customer ALWAYS has role = 1
            int role = 1;

            // Handle redirect if exists
            if (redirect != null && !redirect.isEmpty()) {
                String decoded = URLDecoder.decode(redirect, StandardCharsets.UTF_8);
                List<Carts> carts = cartDAO.getCartByCustomerID(customer.getCustomerID());
                session.setAttribute("cart", carts);
                response.sendRedirect(decoded);
                return;
            }

            // Default redirect for customer
            List<Carts> carts = cartDAO.getCartByCustomerID(customer.getCustomerID());
            session.setAttribute("cart", carts);
            response.sendRedirect("homepage");
            return;
        }

        // ===============================
        // 2. STAFF / ADMIN / SHIPPER LOGIN
        // ===============================
        Staff staff = staffDAO.login(email, password);

        if (staff != null) {
            session.setAttribute("user", staff);  // login object
            session.setAttribute("attempts", 0);

            int role = staff.getRole();

            switch (role) {
                case 4: // Admin
                    session.setAttribute("admin", staff);
                    session.setAttribute("role", staff.getRole());
                    response.sendRedirect("admin");
                    return;

                case 3: // Shipper
                    session.setAttribute("shipper", staff);
                    session.setAttribute("role", staff.getRole());
                    response.sendRedirect("order");
                    return;

                case 2: // Staff
                    session.setAttribute("C", staff);
                    session.setAttribute("role", staff.getRole());
                    response.sendRedirect("product");
                    return;

                default:
                    request.setAttribute("error", "Invalid staff role configuration.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
            }
        }

        // ===============================
        // 3. LOGIN FAILED
        // ===============================
        if (customerDAO.emailExists(email)) {
            int attempts = (int) session.getAttribute("attempts");

            if (attempts < 5) {
                attempts++;
                session.setAttribute("attempts", attempts);
                request.setAttribute("error", "Invalid password. Attempt: " + attempts + "/5");
            } else {
                customerDAO.updateCustomerStatus("block", email);
                request.setAttribute("error", "Account locked due to too many failed attempts.");
            }
        } else {
            request.setAttribute("error", "Invalid email or password.");
        }

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling customer login and logout.";
    }
}



