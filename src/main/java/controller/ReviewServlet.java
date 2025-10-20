/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
import dao.ReviewDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import model.Review;
import model.Users;
import model.Variants;

/**
 * Servlet xử lý review (thêm / xóa / upload ảnh)
 * @author Dâu
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024,  // 10MB mỗi file
        maxRequestSize = 50 * 1024 * 1024 // 50MB tổng request
)
public class ReviewServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ReviewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReviewServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // ===== GET: load review theo variantID =====
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int variantID = Integer.parseInt(request.getParameter("variantID"));
            ReviewDAO dao = new ReviewDAO();
            List<Review> review = dao.getReviewsByVariantID(variantID);
            request.setAttribute("review", review);
            request.getRequestDispatcher("productdetail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Variant ID");
        }
    }

    // ===== POST: thêm hoặc xóa review =====
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        // Chưa đăng nhập thì đá về login
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "review";

        ReviewDAO rdao = new ReviewDAO();
        VariantsDAO vdao = new VariantsDAO();

        if ("review".equals(action)) {
            // === Tạo review mới ===
            int vID = Integer.parseInt(request.getParameter("vID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            // Tạo review trong DB
            rdao.createReview(user.getUserId(), vID, rating, comment);
            
            // Lấy ID của review mới nhất
            int currentReviewID = rdao.getCurrentReviewID();
            
            // === Upload ảnh review ===
            String filePath = request.getServletContext().getRealPath("");
            String basePath = filePath.substring(0, filePath.indexOf("\\target"));
            String uploadDir = basePath + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "images_review";
            
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) uploadFolder.mkdirs();
            
            String img = "";
            for (Part part : request.getParts()) {
                if ("photos".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = currentReviewID + "_" + Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    img += fileName + "#";
                    part.write(uploadDir + File.separator + fileName);
                }
            }
            
            if (!img.isEmpty()) {
                img = img.substring(0, img.length() - 1);
                rdao.updateImageReview(currentReviewID, img);
            }
            
            // Redirect về product detail
            Variants variant = vdao.getVariantByID(vID);
            int productID = variant.getProductID();
            response.sendRedirect("product?action=viewDetail&pID=" + productID);
            
        } else if ("deleteReview".equals(action)) {
            // === Xóa review ===
            int rID = Integer.parseInt(request.getParameter("rID"));
            int vID = Integer.parseInt(request.getParameter("vID"));
            
            rdao.deleteReview(rID);
            Variants variant = vdao.getVariantByID(vID);
            int productID = variant.getProductID();
            response.sendRedirect("product?action=viewDetail&pID=" + productID);
        }
    }
}
