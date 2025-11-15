/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
import dao.ProfitDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import model.Products;
import model.Profit;
import model.Variants;

/**
 *
 * @author USER
 */
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
        processRequest(request, response);
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
            // 1. XỬ LÝ INPUT TỪ FORM
            // -------------------------------------------------------------
            String productSelect = request.getParameter("productID");
            
            // Kiểm tra nếu chọn "Tạo mới" thì chuyển hướng
            if ("NEW".equals(productSelect)) {
                response.sendRedirect("admin?action=showCreateProduct"); 
                return;
            } 
            
            int productID = Integer.parseInt(productSelect);

            // Lấy dữ liệu và dùng .trim() để xóa khoảng trắng thừa (tránh lỗi "Black " != "Black")
            String storage = request.getParameter("storage").trim();
            String color = request.getParameter("color").trim();

            // Parse số liệu
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double costPrice = Double.parseDouble(request.getParameter("costPrice"));
            double sellingPrice = Double.parseDouble(request.getParameter("sellingPrice"));

            // Lấy thời gian hiện tại
            LocalDateTime dateTime = LocalDateTime.now();

            // Khởi tạo DAO
            VariantsDAO variantDAO = new VariantsDAO();
            ProfitDAO profitDAO = new ProfitDAO();

            // 2. KIỂM TRA VARIANT ĐÃ TỒN TẠI CHƯA?
            // -------------------------------------------------------------
            Variants variant = variantDAO.getVariantByProductStorageColor(productID, storage, color);
            int variantID;

            if (variant != null) {

                int currentStock = variant.getStock();

                int newTotalStock = currentStock + quantity;

                variantDAO.updateVariantPriceAndStock(variant.getVariantID(), newTotalStock, sellingPrice);

                variantID = variant.getVariantID();
                System.out.println("Updated Variant ID: " + variantID + ". Old Stock: " + currentStock + " -> New Stock: " + newTotalStock);

            } else {
   
                Variants newVariant = new Variants();
                newVariant.setProductID(productID);
                newVariant.setColor(color);
                newVariant.setStorage(storage);
                newVariant.setPrice(sellingPrice);
                newVariant.setDiscountPrice(sellingPrice); // Giá giảm mặc định bằng giá gốc
                newVariant.setStock(quantity);             // Mới tinh thì Stock bằng số nhập vào
                
                // Set các giá trị mặc định để tránh lỗi Database
                newVariant.setDescription("Hàng mới nhập kho");
                newVariant.setImageUrl("default.jpg"); 
                
                variantID = variantDAO.createVariant(newVariant);
                System.out.println("Created New Variant ID: " + variantID);
            }

            // 3. LƯU LỊCH SỬ NHẬP HÀNG (PROFIT)
            // -------------------------------------------------------------
            Profit profit = new Profit();
            profit.setVariantID(variantID);
            profit.setQuantity(quantity);     // Lưu số lượng vừa nhập (không phải tổng)
            profit.setCostPrice(costPrice);   // Lưu giá vốn
            profit.setSellingPrice(sellingPrice);
            profit.setCalculatedDate(dateTime);

            profitDAO.addProfit(profit);
            response.sendRedirect("admin?action=importproduct&msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?action=importproduct&msg=error");
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
