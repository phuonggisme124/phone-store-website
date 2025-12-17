/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.InterestRateDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.InterestRate;

/**
 *
 * @author duynu
 */
@WebServlet(name="InterestRateServlet", urlPatterns={"/interestrates"})
public class InterestRateServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet InterestRateServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InterestRateServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        InterestRateDAO irdao = new InterestRateDAO();
        String action = request.getParameter("action");

        if (action == null) {
            action = "null";
        }
        
        if("viewInterestRate".equals(action)){
            List<InterestRate> listInterestRate = irdao.getAllInterestRate();
            request.setAttribute("listInterestRate", listInterestRate);
            request.getRequestDispatcher("admin/dashboard_admin_manageinterestrates.jsp").forward(request, response);
        }else if("edit".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));
            InterestRate interestRate = irdao.getAllInterestRateByID(id);
            request.setAttribute("interestRate", interestRate);
            request.getRequestDispatcher("admin/admin_manageinterestrates_edit.jsp").forward(request, response);
        }else if("create".equals(action)){
            request.getRequestDispatcher("admin/admin_manageinterestrates_create.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        InterestRateDAO irdao = new InterestRateDAO();
        String action = request.getParameter("action");

        if (action == null) {
            action = "null";
        }
        
        if("updateInterestRate".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));
            int period = Integer.parseInt(request.getParameter("period"));
            int rateValue = Integer.parseInt(request.getParameter("rateValue"));
            float rateExpired = Float.parseFloat(request.getParameter("rateExpired"));
            
            irdao.updateInterestRate(id, period, rateValue, rateExpired);
            response.sendRedirect("interestrates?action=viewInterestRate");
        }else if("createInterestRate".equals(action)){
            int period = Integer.parseInt(request.getParameter("period"));
            int rateValue = Integer.parseInt(request.getParameter("rateValue"));
            float rateExpired = Float.parseFloat(request.getParameter("rateExpired"));
            irdao.createInterestRate(period, rateValue, rateExpired);
            response.sendRedirect("interestrates?action=viewInterestRate");
        }else if("deleteInterestRate".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));
            irdao.deleteInterestRate(id);
            response.sendRedirect("interestrates?action=viewInterestRate");
        }
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
