/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Carts;
import model.Category;


/**
 * CartServlet handles HTTP requests related to the shopping cart feature.
 *
 * @author duynu
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CartServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO dao = new ProductDAO();
        CartDAO cDAO = new CartDAO();

        int userID = Integer.parseInt(request.getParameter("userID"));
        List<Carts> carts = cDAO.getItemIntoCartByUserID(userID);

        request.setAttribute("carts", carts);
        // Retrieve the newest products from the database
        int cID = 1;
        // Retrieve all categories from the database
        List<Category> listCategory = dao.getAllCategory();
        request.setAttribute("categoryID", cID);

        // Store data in request attributes for access in JSP
        request.setAttribute("listCategory", listCategory);

        // Forward the request to the homepage.jsp view
        request.getRequestDispatcher("customer/display_cart.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        CartDAO cDAO = new CartDAO();
        if (action == null) {
            int userID = Integer.parseInt(request.getParameter("userID"));
            int variantID = Integer.parseInt(request.getParameter("variantID"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            if (!cDAO.isAddedInCart(userID, variantID)) {
                cDAO.ensureCartExists(userID);
                cDAO.addNewProductToCart(userID, variantID, quantity);
            }
            response.sendRedirect(request.getHeader("referer"));
        } else if (action.equals("delete")) {
            int cartID = Integer.parseInt(request.getParameter("cartID"));
            int variantID = Integer.parseInt(request.getParameter("variantID"));
            cDAO.removeItemFromCart(cartID, variantID);
            response.sendRedirect("cart?userID=" + cartID);
        } else if (action.equals("updateQuantity")) {
            int userID = Integer.parseInt(request.getParameter("userID"));
            int cartID = userID;
            int variantID = Integer.parseInt(request.getParameter("variantID"));
            int quantityChange = Integer.parseInt(request.getParameter("quantityChange"));
            cDAO.updateQuantityByChange(cartID, variantID, quantityChange);
            response.sendRedirect("cart?userID=" + cartID);
        }
    }

        /**
         * Returns a short description of the servlet.
         *
         * @return a String containing servlet description
         */
        @Override
        public String getServletInfo
        
            () {
        return "Short description";
        }// </editor-fold>   

    }
