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
import java.net.URLDecoder;
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
     * This method is triggered when a GET request is made to /login, which is
     * treated as a logout action in this context.
     */
    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("attempts", 0);
        response.sendRedirect("login.jsp");
    }

    /**
     * Handles user login functionality.
     *
     * Workflow: 1. Get login credentials (email & password) from the request.
     * 2. Validate that both fields are not empty. 3. Use UsersDAO to verify
     * user credentials. 4. If valid → create a session and redirect based on
     * the user role. 5. If invalid → forward back to login.jsp with an error
     * message.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Login with Google
        HttpSession session = request.getSession();
        if (session.getAttribute("attempts") == null) {
            session.setAttribute("attempts", 0);
        }

        String action = request.getParameter("action");
        if (action != null && action.equalsIgnoreCase("googleLogin")) {
            UsersDAO uDAO = new UsersDAO();

            String email = request.getParameter("email");
            String name = request.getParameter("name");
            if (email != null && name != null) {
                uDAO.registerForLoginWithGoogle(name, email, 1);
                Users u = uDAO.loginWithEmail(email);
                session.setAttribute("user", u);
                CartDAO cDAO = new CartDAO();
                List<Carts> carts = cDAO.getItemIntoCartByUserID(u.getUserId());
                session.setAttribute("cart", carts);
                response.sendRedirect("homepage");
                return;
            }
        }
        //Normal login
        // Get user input from the login form
        String email = request.getParameter("username");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect"); // Lấy URL redirect nếu có
        UsersDAO uDAO = new UsersDAO();

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
        Users u = uDAO.login(email, password); // Attempt to authenticate user
        if (u != null && u.getStatus().equalsIgnoreCase("block")) {
            request.setAttribute("error", "Your account has been locked.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        } else if (u != null) { // Login successful
            // Create a new session for the logged-in user
            session.setAttribute("user", u); // Store the user object in the session

            // Nếu có redirect URL từ productdetail.jsp, quay lại đó
            if (u.getRole() == 1) {
                if (redirect != null && !redirect.isEmpty()) {
                    try {
                        String decodedURL = URLDecoder.decode(redirect, "UTF-8");
                        CartDAO cDAO = new CartDAO();
                        List<Carts> carts = cDAO.getItemIntoCartByUserID(u.getUserId());
                        session.setAttribute("cart", carts);
                        response.sendRedirect(decodedURL);
                        return;
                    } catch (Exception e) {
                        System.err.println("Error decoding redirect URL: " + e.getMessage());
                    }
                }

            }

            //Set attemps to 0 if login successfully
            session.setAttribute("attempts", 0);

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

                    response.sendRedirect("product");
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
            // If wrong password but correct email
        } else if (uDAO.getUserByEmail(email)) {
            // Set error message for invalid credentials
            int attempts = (int) session.getAttribute("attempts");
            if (attempts < 5) {
                int newAttempts = attempts + 1;
                request.setAttribute("error", "Invalid password.");
                session.setAttribute("attempts", newAttempts);

            } else {
                request.setAttribute("error", "You have entered the wrong password more than 5 times. Your account has been locked.");
                // Update status to block if exceed attempts
                uDAO.updateUserStatus("block", email);
            }
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
