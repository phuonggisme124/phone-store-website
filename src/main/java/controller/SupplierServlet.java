/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SupplierDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Suppliers;

/**
 *
 * @author
 */
@WebServlet(name = "SupplierServlet", urlPatterns = {"/supplier"})
public class SupplierServlet extends HttpServlet {

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
            out.println("<title>Servlet SupplierServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SupplierServlet at " + request.getContextPath() + "</h1>");
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
        SupplierDAO sldao = new SupplierDAO();
        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        if (action.equals("dashboard")) {

            response.sendRedirect("admin");
        } else if (action.equals("createSupplier")) {

            request.getRequestDispatcher("admin/admin_managesupplier_create.jsp").forward(request, response);
        }else if (action.equals("editSupplier")) {
            int supplierID = Integer.parseInt(request.getParameter("id"));

            Suppliers supplier = sldao.getSupplierByID(supplierID);
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("admin/admin_managesupplier_edit.jsp").forward(request, response);
        }else if(action.equals("manageSupplier")){
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            request.setAttribute("listSupplier", listSupplier);

            request.getRequestDispatcher("admin/dashboard_admin_managesupplier.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        SupplierDAO sldao = new SupplierDAO();
        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }
        
        if (action.equals("dashboard")) {

            response.sendRedirect("admin");
        } else if (action.equals("createSupplier")) {

            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            sldao.createSupplier(name, phone, email, address);
            session.setAttribute("successCreateSupplier", name + " create successfully!");
            
            response.sendRedirect("supplier?action=manageSupplier");
        }else if (action.equals("updateSupplier")) {
            int sID = Integer.parseInt(request.getParameter("sID"));
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            sldao.updateSupplier(sID, name, phone, email, address);
            session.setAttribute("successUpdateSupplier", name + " update successfully!");
            response.sendRedirect("supplier?action=manageSupplier");
        }else if (action.equals("deleteSupplier")) {
            int sID = Integer.parseInt(request.getParameter("sID"));
            Suppliers supplier = sldao.getSupplierByID(sID);
            sldao.deleteSupplier(sID);
            session.setAttribute("successDeleteSupplier", supplier.getName() + " delete successfully!");
            response.sendRedirect("supplier?action=manageSupplier");
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
