package controller;

import dao.UsersDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Added import for HttpSession
import model.Users;

/**
 * Servlet that handles user registration and automatic login using session.
 *
 * Author: ADMIN
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    /**
     * Default method to generate a simple HTML response (for debugging only).
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* Example HTML output */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles HTTP GET requests (not used for registration, only for testing).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles HTTP POST requests for user registration.
     * Validates form data, registers a new user, and automatically logs them in.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Retrieve form data
        String name = request.getParameter("fullname");
        String email = request.getParameter("email");
        String numberPhone = request.getParameter("numberphone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("rePassword");
        
        // --- Input validation logic ---

        // 1. Check if passwords match and are not empty
        if (!password.equals(rePassword) || password.isEmpty() || password == null) {
            request.setAttribute("error", "Passwords do not match or cannot be empty!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return; // Stop further processing
        }
        
        // 2. Check if all required fields are filled
        if (name == null || name.isEmpty() || email == null || email.trim().isEmpty() || 
            numberPhone == null || numberPhone.isEmpty() || address == null || address.isEmpty()) {
            request.setAttribute("error", "You must fill in all required fields to register.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return; // Stop further processing
        }
        
        // --- Registration logic and result handling ---
        
        UsersDAO dao = new UsersDAO();
        boolean isRegsitered = false;
        try {
            // The register() method is assumed to return a Users object if successful
             isRegsitered = dao.register(name, email, numberPhone, address, password, 1);
        } catch (Exception e) {
            // Common causes: duplicate email or database error
            System.out.println("Registration error: " + e.getMessage());
            request.setAttribute("error", "Registration failed. This email may already be in use.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (isRegsitered) { 
            
            response.sendRedirect("login.jsp");

        } else {
            // Registration failed (null returned from DAO)
            request.setAttribute("error", "Registration failed due to an unexpected error.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }

    /**
     * Returns a brief description of this servlet.
     */
    @Override
    public String getServletInfo() {
        return "Handles user registration and automatic login using Session.";
    }
}
