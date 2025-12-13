/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
import dao.ProfitDAO;
import dao.PromotionsDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import model.Products;
import model.Profit;
import model.Promotions;
import model.Variants;

/**
 *
 * @author
 */
@WebServlet(name = "PromotionServlet", urlPatterns = {"/promotion"})
public class PromotionServlet extends HttpServlet {

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
            out.println("<title>Servlet PromotionServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PromotionServlet at " + request.getContextPath() + "</h1>");
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
        ProductDAO pdao = new ProductDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
       
        String action = request.getParameter("action");

        if (action == null) {
            action = "dashboard";

        }

        if (action.equals("dashboard")) {
            response.sendRedirect("admin");
        } else if (action.equals("createPromotion")) {
            List<Products> listProducts = pdao.getAllProduct();
            request.setAttribute("listProducts", listProducts);
            request.getRequestDispatcher("admin/admin_managepromotion_create.jsp").forward(request, response);

        } else if (action.equals("editPromotion")) {
            int pmtID = Integer.parseInt(request.getParameter("pmtID"));
            int pID = Integer.parseInt(request.getParameter("pID"));
            Promotions promotion = pmtdao.getPromotionByID(pmtID);
            Products product = pdao.getProductByID(pID);
            List<Products> listProduct = pdao.getAllProduct();

            request.setAttribute("listProduct", listProduct);
            request.setAttribute("promotion", promotion);
            request.setAttribute("product", product);

            request.getRequestDispatcher("admin/admin_managepromotion_edit.jsp").forward(request, response);
        } else if (action.equals("managePromotion")) {
            pmtdao.updateAllStatus();
            List<Products> listProducts = pdao.getAllProduct();
            List<Promotions> listPromotions = pmtdao.getAllPromotion();

            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listPromotions", listPromotions);

            request.getRequestDispatcher("admin/dashboard_admin_managepromotion.jsp").forward(request, response);
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
        DateTimeFormatter formatDate = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        HttpSession session = request.getSession();
        LocalDateTime today = LocalDate.now().atStartOfDay();
        ProfitDAO pfdao = new ProfitDAO();
        ProductDAO pdao = new ProductDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        VariantsDAO vdao = new VariantsDAO();
        String action = request.getParameter("action");

        if (action == null) {
            action = "dashboard";

        }

        if (action.equals("dashboard")) {
            response.sendRedirect("admin");
        } else if (action.equals("createPromotion")) {
            int pID = Integer.parseInt(request.getParameter("pID"));

            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            LocalDateTime startDate = LocalDate.parse(startDateStr, formatDate).atStartOfDay();
            LocalDateTime endDate = LocalDate.parse(endDateStr, formatDate).atStartOfDay();
            String status;
            if (!startDate.isAfter(today)) {
                status = "active";
            } else {
                status = "pending";
            }

            List<Promotions> listPromotion = pmtdao.getListPromotionByProductID(pID);
            if (listPromotion != null && status.equals("active")) {
                for (Promotions pmt : listPromotion) {
                    if (pmt.getStatus().equalsIgnoreCase("active")) {
                        String updateStatus = "expired";
                        pmtdao.updateStatus(pmt.getPromotionID(), updateStatus);
                    }
                }
            }
            pmtdao.createPromotion(pID, discountPercent, startDate, endDate, status);
            vdao.updateDiscountPrice();
            List<Variants> listVariant = vdao.getVariantByProductID(pID);
            for (Variants v : listVariant) {
                pfdao.updateSellPriceByVariantID(v.getVariantID());
            }
            session.setAttribute("successCreatePromotion", pdao.getProductByID(pID).getName() + " created promotion successfully!");
            response.sendRedirect("promotion?action=managePromotion");
        } else if (action.equals("updatePromotion")) {
            int pmtID = Integer.parseInt(request.getParameter("pmtID"));
            int pID = Integer.parseInt(request.getParameter("pID"));
            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            LocalDateTime startDate = LocalDate.parse(startDateStr, formatDate).atStartOfDay();
            LocalDateTime endDate = LocalDate.parse(endDateStr, formatDate).atStartOfDay();
            String status = request.getParameter("status");

            pmtdao.updatePromotion(pmtID, pID, discountPercent, startDate, endDate, status);
            pmtdao.updateAllStatus();
            vdao.updateDiscountPrice();
            List<Variants> listVariant = vdao.getVariantByProductID(pID);
            for (Variants v : listVariant) {
                pfdao.updateSellPriceByVariantID(v.getVariantID());
            }
            session.setAttribute("successUpdatePromotion", pdao.getProductByID(pID).getName() + " updated promotion successfully!");
            response.sendRedirect("promotion?action=managePromotion");
        } else if (action.equals("deletePromotion")) {
            int pmtID = Integer.parseInt(request.getParameter("pmtID"));
            Promotions promotion = pmtdao.getPromotionByID(pmtID);
            pmtdao.deletePromotion(pmtID);
            vdao.updateDiscountPrice();
            List<Variants> listVariant = vdao.getVariantByProductID(promotion.getProductID());
            for (Variants v : listVariant) {
                pfdao.updateSellPriceByVariantID(v.getVariantID());
            }
            session.setAttribute("successDeletePromotion", pdao.getProductByID(promotion.getProductID()).getName() + " deleted promotion successfully!");
            response.sendRedirect("promotion?action=managePromotion");
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
