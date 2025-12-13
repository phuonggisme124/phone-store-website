/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet responsible for handling user logout by invalidating the current session.
 * 
 * Once the session is invalidated, all user-related data (such as user info, role, etc.)
 * will be removed, and the user will be redirected to the homepage or login page.
 * 
 * This servlet typically corresponds to the "Logout" function in the application.
 * 
 * Author: admin
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    /**
     * Handles the HTTP GET method, which is commonly used for logout actions.
     * 
     * Workflow:
     *  1. Retrieve the current session (if it exists).
     *  2. Invalidate (destroy) the session to log out the user.
     *  3. Redirect the user to the homepage (or login page).
     *
     * @param request  the HttpServletRequest object that contains the client request
     * @param response the HttpServletResponse object used to return the response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an input or output error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // STEP 1: Invalidate the session (main logout action)
        HttpSession session = request.getSession(false); // Get current session without creating a new one
        
        if (session != null) {
            // Remove all session data (e.g., user info, role, etc.)
            session.invalidate(); 
        }

        // STEP 2: Redirect user to the homepage (or login page)
        // After invalidation, any protected page will redirect to login.jsp automatically
        response.sendRedirect("homepage");
    }

    /**
     * Handles the HTTP POST method.
     * 
     * For logout, this method simply calls doGet() to perform the same action.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Provides a short description of this servlet for documentation or debugging.
     *
     * @return A brief description of this servlet.
     */
    @Override
    public String getServletInfo() {
        return "Handles user logout by invalidating the HttpSession.";
    }
}
