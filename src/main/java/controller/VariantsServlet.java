/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.util.List;
import model.Variants;
import utils.DBContext;

/**
 * This servlet handles variant-related requests from the client.
 * It connects to the database using DBContext, retrieves all product variants
 * from the VariantsDAO, and forwards the data to the JSP for rendering.
 * 
 * @author USER
 */
@WebServlet(name = "VariantsServlet", urlPatterns = {"/variants"})
public class VariantsServlet extends HttpServlet {

    /**
     * Default process method for both GET and POST requests.
     * This is usually used as a placeholder for testing purposes.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* Basic HTML output for quick servlet testing */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet VariantsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VariantsServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods.">
    /**
     * Handles HTTP GET requests.
     * Retrieves all product variants from the database and forwards them to homepage.jsp.
     *
     * @param request  HTTP request object
     * @param response HTTP response object
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Create a DBContext instance to establish a database connection
            DBContext db = new DBContext();
            Connection conn = db.conn;

            // Create DAO instance for Variants operations
            VariantsDAO dao = new VariantsDAO(); // Uses DAO to fetch data from DB

            // Retrieve all product variants
            List<Variants> variants = dao.getAllVariants();

            // Attach the retrieved variants list to the request object
            request.setAttribute("variants", variants);

            // Forward the request and response to homepage.jsp for display
            request.getRequestDispatcher("homepage.jsp").forward(request, response);

        } catch (Exception e) {
            // Print stack trace for debugging and send error message to client
            e.printStackTrace();
            response.getWriter().println("Error loading product data: " + e.getMessage());
        }
    }

    /**
     * Handles HTTP POST requests.
     * Forwards POST requests to processRequest (default behavior for testing).
     *
     * @param request  HTTP request object
     * @param response HTTP response object
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
