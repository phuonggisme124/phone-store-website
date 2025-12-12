package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("fullname");
        String email = request.getParameter("email");
        String numberPhone = request.getParameter("numberphone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("rePassword");

        // Validate password match
        if (password == null || !password.equals(rePassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Validate password strength
        if (!password.matches("^(?=.*[A-Za-z])(?=.*\\d).{8,}$")) {
            request.setAttribute("error", "Password must have at least 8 characters including letters and numbers.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Validate required fields
        if (name == null || name.isEmpty() ||
            email == null || email.isEmpty() ||
            numberPhone == null || numberPhone.isEmpty() ||
            address == null || address.isEmpty()) {

            request.setAttribute("error", "All fields must be filled.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // === Register Customer ===
        CustomerDAO dao = new CustomerDAO();
        int isRegistered = 0;

        try {
            isRegistered = dao.register(name, email, numberPhone, address, password); 
        } catch (Exception e) {
            System.out.println("Registration error: " + e.getMessage());
            request.setAttribute("error", "This email already exists or registration failed.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // === Result handling ===
        if (isRegistered > 0) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("error", "Registration failed due to server error.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles customer registration.";
    }
}
