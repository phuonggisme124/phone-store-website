/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.ProfitDAO;
import dao.PromotionsDAO;
import dao.ReviewDAO;
import dao.SupplierDAO;
import dao.CustomerDAO;
import dao.InstallmentDetailDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Category;

/**
 *
 * @author duynu
 */
@WebServlet(name = "CategoryServlet", urlPatterns = {"/category"})
public class CategoryServlet extends HttpServlet {

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
            out.println("<title>Servlet CategoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CategoryServlet at " + request.getContextPath() + "</h1>");
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
        CustomerDAO udao = new CustomerDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        ReviewDAO rdao = new ReviewDAO();
        OrderDAO odao = new OrderDAO();
        InstallmentDetailDAO paydao = new InstallmentDetailDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        ProfitDAO pfdao = new ProfitDAO();
        if (action == null) {
            action = "dashboard";
        }

        if (action.equals("manageCategory")) {
            List<Category> listCategory = ctdao.getAllCategories();

            request.setAttribute("listCategory", listCategory);
            request.getRequestDispatcher("admin/dashboard_admin_managecategory.jsp").forward(request, response);

        } else if (action.equals("editCategory")) {
            int cateID = Integer.parseInt(request.getParameter("id"));

            Category catergory = ctdao.getCategoryByCategoryID(cateID);
            request.setAttribute("catergory", catergory);
            request.getRequestDispatcher("admin/admin_managecategory_edit.jsp").forward(request, response);
        } else if (action.equals("createCategory")) {
            request.getRequestDispatcher("admin/admin_managecategory_create.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        CustomerDAO udao = new CustomerDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        ReviewDAO rdao = new ReviewDAO();
        
        if (action.equals("updateCategory")) {
            int cateID = Integer.parseInt(request.getParameter("cateID"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            ctdao.editCategory(cateID, name, description);
            response.sendRedirect("category?action=manageCategory");

        } else if (action.equals("deleteCategory")) {
            int cateID = Integer.parseInt(request.getParameter("cateID"));
            System.out.println("delete cateID: " + cateID);
            ctdao.removeCategory(cateID);
            response.sendRedirect("category?action=manageCategory");
        } else if (action.equals("createCategory")) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            ctdao.createCategory(name, description);
            response.sendRedirect("category?action=manageCategory");
        }

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


