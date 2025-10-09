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

        if (action.equals("manageOrder")) {
            List<Users> shippers = udao.getAllShippers();

            List<Order> listOrders = odao.getAllOrderForStaff();
            request.setAttribute("listOrders", listOrders);
            request.setAttribute("listShippers", shippers);
            request.getRequestDispatcher("dashboard_staff_manageorder.jsp").forward(request, response);

        } else if (action.equals("manageProduct")) {
            List<Products> listProducts = pdao.getAllProduct();
            List<Category> listCategory = ctdao.getAllCategories();
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listCategory", listCategory);
            request.setAttribute("listSupplier", listSupplier);
            request.getRequestDispatcher("dashboard_staff_manageproduct.jsp").forward(request, response);

        } else if (action.equals("productDetail")) {
            int id = Integer.parseInt(request.getParameter("id"));
            List<Variants> listVariants = vdao.getAllVariantByProductID(id);
            List<Products> listProducts = pdao.getAllProduct();

            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listVariants", listVariants);

            request.getRequestDispatcher("staff_manageproduct_detail.jsp").forward(request, response);
        } else if (action.equals("chooseShipper")) {
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            // Lấy danh sách shipper từ DB
            List<Users> shippers = udao.getAllShippers();

            request.setAttribute("orderID", orderID);
            request.setAttribute("listShippers", shippers);
            request.getRequestDispatcher("dashboard_staff_manageorder.jsp").forward(request, response);
        }else if (action.equals("assignShipper")) {
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            int shipperID = Integer.parseInt(request.getParameter("shipperID"));
            int StaffID =  Integer.parseInt(request.getParameter("staffID"));   
            sdao.assignShipperForOrder(orderID,StaffID , shipperID);
            List<Order> listOrders = odao.getAllOrderForStaff();
            request.setAttribute("listOrders", listOrders);
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
