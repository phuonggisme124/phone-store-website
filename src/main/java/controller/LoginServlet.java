/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
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
import java.util.List;
import model.Carts;
import model.Users;

/**
 * Servlet that handles user login and logout functionality.
 *
 * @author Nguyen Quoc Thinh - CE191376 - 05/10/2025
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    /**
     * Handles user logout by invalidating the current session.
     *
     * This method is triggered when a GET request is made to /login,
     * which is treated as a logout action in this context.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve the current session (if it exists)
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Destroy the current session to log out the user
        }

        // Redirect the user back to the login page after logout
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /**
     * Handles user login functionality.
     *
     * Workflow:
     * 1. Get login credentials (email & password) from the request.
     * 2. Validate that both fields are not empty.
     * 3. Use UsersDAO to verify user credentials.
     * 4. If valid → create a session and redirect based on the user role.
     * 5. If invalid → forward back to login.jsp with an error message.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user input from the login form
        String email = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate empty fields
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            // Set error message for empty credentials
            request.setAttribute("error", "Email and password cannot be empty.");
            // Forward back to login.jsp for the user to correct input
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Create a DAO instance to check login credentials in the database
        UsersDAO dao = new UsersDAO();
        Users u = dao.login(email, password); // Attempt to authenticate user

        if (u != null) { // Login successful
            // Create a new session for the logged-in user
            HttpSession session = request.getSession();
            session.setAttribute("user", u); // Store the user object in the session
            // Get the user's role (default to "1" if null)
            String roleValue = (u.getRole() != null) ? u.getRole().toString() : "1";

            // Redirect based on user role
            switch (roleValue) {
                case "4":
                    // Role 4: Admin → Redirect to admin dashboard
                    response.sendRedirect("admin");
                    break;
                case "3":
                    // Role 3: Possibly manager → Redirect to order page
                    response.sendRedirect("order");
                    break;
                case "2":
                    // Role 2: Staff → Redirect to staff page
                    response.sendRedirect("staff");
                    break;
                case "1":
                default:
                    // Role 1 or unknown → Redirect to homepage
                    CartDAO cDAO = new CartDAO();
                    List<Carts> carts = cDAO.getItemIntoCartByUserID(u.getUserId());
                    session.setAttribute("cart", carts);
                    response.sendRedirect("homepage");
                    break;
            }

        } else { // Login failed: invalid email or password
            // Set error message for invalid credentials
            request.setAttribute("error", "Invalid email or password.");
            // Forward back to login.jsp to show the error
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }

    /**
     * Provides a brief description of the servlet for documentation purposes.
     */
    @Override
    public String getServletInfo() {
        return "Servlet for handling user login and logout.";
    }
}
