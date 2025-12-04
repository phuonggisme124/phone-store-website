/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ImportDAO;
import dao.ProductDAO;
import dao.ProfitDAO;
import dao.SupplierDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import model.Import;
import model.ImportDetail;
import model.Products;
import model.Profit;
import model.Suppliers;
import model.Users;
import model.Variants;

/**
 *
 * @author USER
 */
@MultipartConfig
@WebServlet(name = "ImportProductServlet", urlPatterns = {"/importproduct"})
public class ImportProductServlet extends HttpServlet {

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
            out.println("<title>Servlet ImportProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ImportProductServlet at " + request.getContextPath() + "</h1>");
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
        try {
            SupplierDAO sup = new SupplierDAO();
            List<Suppliers> listSup = sup.getAllSupplier();
            request.setAttribute("listSup", listSup);
            VariantsDAO var = new VariantsDAO();
            List<Variants> listVar = var.getAllVariantsWithProductName();
            request.setAttribute("listVar", listVar);
            request.getRequestDispatcher("importProduct.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
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
        try {
            HttpSession session = request.getSession();
            Users user = (Users) session.getAttribute("acc");
            int supplierID = Integer.parseInt(request.getParameter("supplierID"));
            String note = request.getParameter("note");
            String[] variantID = request.getParameterValues("variantID");
            String[] qualities = request.getParameterValues("quantity");
            String[] costPrice = request.getParameterValues("costPrice");
            String[] sellingPrices = request.getParameterValues("sellingPrice");
            List<ImportDetail> listDetails = new ArrayList<>();
            double totalPrice = 0;
            if (variantID != null) {
                for (int i = 0; i < variantID.length; i++) {
                    int vID = Integer.parseInt(variantID[i]);
                    int qty = Integer.parseInt(qualities[i]);
                    double price = Double.parseDouble(costPrice[i]);
                    totalPrice += (qty * price); // tính tổng phiếu nhập  
                    // Parse giá bán (thêm dòng này)
                    double sellPrice = 0;
                    if (sellingPrices != null && sellingPrices.length > i) {
                        sellPrice = Double.parseDouble(sellingPrices[i]);
                    }
                    ImportDetail detail = new ImportDetail();
                    detail.setVariantID(vID);
                    detail.setQuality(qty);
                    detail.setCostPrice(price);
                    detail.setSellingPrice(sellPrice);
                    listDetails.add(detail);

                }
            }
            Import imp = new Import();
            if (user != null) {
                imp.setAccountID(user.getUserId());
            } else {
                imp.setAccountID(1);
            }
            imp.setSupplierID(supplierID);
            imp.setTotalCost(totalPrice);
            imp.setNote(note);
            ImportDAO dao = new ImportDAO();
            boolean result = dao.insertImportTransaction(imp, listDetails);
            if (result) {
                session.setAttribute("MESS", "NHẬP HÀNG THÀNH CÔNG!");
                response.sendRedirect("admin?action=importproduct");
            } else {
                request.setAttribute("ERROR", "LỖI HỆ THỐNG, VUI LÒNG THỬ LẠI");
                request.getRequestDispatcher("admin/importProduct.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
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
