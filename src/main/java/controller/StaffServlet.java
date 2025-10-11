/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.SupplierDAO;
import dao.UsersDAO;
import dao.VariantsDAO;
import dao.OrderDAO;
import dao.SalesDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Category;
import model.Order;
import model.Products;
import model.Suppliers;
import model.Users;
import model.Variants;

/**
 *
 * @author duynu
 */
@WebServlet(name = "StaffServlet", urlPatterns = {"/staff"})
public class StaffServlet extends HttpServlet {

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
            out.println("<title>Servlet StaffServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StaffServlet at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        UsersDAO udao = new UsersDAO();
        OrderDAO odao = new OrderDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        SalesDAO sdao = new SalesDAO();
        if (action == null) {
            action = "manageProduct";
        }

        // =====================================================
        // Case 1: Staff manages orders
        // =====================================================
        if (action.equals("manageOrder")) {

            // Get all available shippers for assignment
            List<Users> shippers = udao.getAllShippers();

            // Get all orders that staff can manage
            List<Order> listOrders = odao.getAllOrderForStaff();

            // Pass data to JSP
            request.setAttribute("listOrders", listOrders);
            request.setAttribute("listShippers", shippers);

            // Forward request to the staff order management page
            request.getRequestDispatcher("dashboard_staff_manageorder.jsp").forward(request, response);

            // =====================================================
            // Case 2: Staff manages products
            // =====================================================
        } else if (action.equals("manageProduct")) {

            // Retrieve all product-related data
            List<Products> listProducts = pdao.getAllProduct();
            List<Category> listCategory = ctdao.getAllCategories();
            List<Suppliers> listSupplier = sldao.getAllSupplier();

            // Set data as attributes for JSP
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listCategory", listCategory);
            request.setAttribute("listSupplier", listSupplier);

            // Forward to the product management dashboard
            request.getRequestDispatcher("dashboard_staff_manageproduct.jsp").forward(request, response);

            // =====================================================
            // Case 3: View details of a specific product
            // =====================================================
        } else if (action.equals("productDetail")) {

            // Get product ID from request
            int id = Integer.parseInt(request.getParameter("id"));

            // Retrieve all variants of the product
            List<Variants> listVariants = vdao.getAllVariantByProductID(id);

            // Get all products for reference
            List<Products> listProducts = pdao.getAllProduct();

            // Attach data to request
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listVariants", listVariants);

            // Forward to the product detail management page
            request.getRequestDispatcher("staff_manageproduct_detail.jsp").forward(request, response);

            // =====================================================
            // Case 4: Display available shippers for a specific order
            // =====================================================
        } else if (action.equals("chooseShipper")) {

            // Get order ID from request
            int orderID = Integer.parseInt(request.getParameter("orderID"));

            // Retrieve list of shippers
            List<Users> shippers = udao.getAllShippers();

            // Set data for the JSP
            request.setAttribute("orderID", orderID);
            request.setAttribute("listShippers", shippers);

            // Forward to the order management dashboard with shipper selection
            request.getRequestDispatcher("dashboard_staff_manageorder.jsp").forward(request, response);

            // =====================================================
            // Case 5: Assign a shipper to an order
            // =====================================================
        } else if (action.equals("assignShipper")) {

            // Parse order and user data from request
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            int shipperID = Integer.parseInt(request.getParameter("shipperID"));
            int StaffID = Integer.parseInt(request.getParameter("staffID"));

            // Assign the selected shipper to the order
            sdao.assignShipperForOrder(orderID, StaffID, shipperID);

            // Reload the order list after assignment
            List<Order> listOrders = odao.getAllOrderForStaff();
            request.setAttribute("listOrders", listOrders);

            // Redirect to manage order page
            action = "manageOrder";
            request.getRequestDispatcher("dashboard_staff_manageorder.jsp").forward(request, response);
        }
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
