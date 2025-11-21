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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import model.Products;
import model.Profit;
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
        request.setCharacterEncoding("UTF-8");
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
            String storage = request.getParameter("storage").trim().toUpperCase();
            String color = request.getParameter("color").trim().toUpperCase();

            // Parse số liệu
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double costPrice = Double.parseDouble(request.getParameter("costPrice"));
            double sellingPrice = Double.parseDouble(request.getParameter("sellingPrice"));

            // Lấy thời gian hiện tại
            LocalDateTime dateTime = LocalDateTime.now();
            String description = request.getParameter("description");
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "products";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            List<String> photoPathsForDB = new ArrayList<>();
            List<Part> photoParts = request.getParts().stream()
                    .filter(part -> "photos".equals(part.getName()) && part.getSize() > 0)
                    .collect(Collectors.toList());

            for (Part photoPart : photoParts) {
                String originalFileName = photoPart.getSubmittedFileName();
                String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;
                String filePath = uploadPath + File.separator + uniqueFileName;
                photoPart.write(filePath);
                photoPathsForDB.add("uploads/products/" + uniqueFileName);
            }

            // Lấy ảnh đầu tiên làm ảnh đại diện mới (nếu có)
            String newMainImagePath = (!photoPathsForDB.isEmpty()) ? photoPathsForDB.get(0) : null;
            // Khởi tạo DAO
            VariantsDAO variantDAO = new VariantsDAO();
            ProfitDAO profitDAO = new ProfitDAO();
            ProductDAO pdao = new ProductDAO();

            // 2. KIỂM TRA VARIANT ĐÃ TỒN TẠI CHƯA?
            // -------------------------------------------------------------
            Variants variant = variantDAO.getVariantByProductStorageColor(productID, storage, color);
            int variantID;

            if (variant != null) {

                variantID = variant.getVariantID();

                // Cập nhật đối tượng 'variant' có sẵn trong bộ nhớ
                int newTotalStock = variant.getStock() + quantity;
                variant.setStock(newTotalStock);
                variant.setPrice(sellingPrice); // Luôn cập nhật giá bán mới

                // Gọi hàm DAO mới để update mọi thứ
                variantDAO.updateVariantPriceAndStock(variantID, newTotalStock, sellingPrice);

            } else {
                request.setAttribute("pID", productID);
                Products product = pdao.getProductByID(productID);
                request.setAttribute("product", product);

                // Nếu có description + ảnh thì vẫn giữ, hoặc người dùng sẽ nhập ở trang create variant
                request.getRequestDispatcher("admin/admin_manageproduct_createvariant.jsp").forward(request, response);
                return;
            }
            // 3. LƯU LỊCH SỬ NHẬP HÀNG (PROFIT)
            // -------------------------------------------------------------
            // Logic này giờ dùng chung cho cả 2 trường hợp (if và else)
            // vì chúng ta đã có 'variantID'
            Profit profit = new Profit();
            profit.setVariantID(variantID);
            profit.setQuantity(quantity);       // Lưu số lượng vừa nhập
            profit.setCostPrice(costPrice);     // Lưu giá vốn
            profit.setSellingPrice(sellingPrice);
            profit.setCalculatedDate(dateTime);

            profitDAO.addProfit(profit);

            // 4. CHUYỂN HƯỚNG
            // -------------------------------------------------------------
            response.sendRedirect("admin?action=importproduct");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?action=importproduct");
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
