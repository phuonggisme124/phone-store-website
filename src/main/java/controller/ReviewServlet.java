/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

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
 *
 * @author USER
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class ReviewServlet extends HttpServlet {

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
            out.println("<title>Servlet ReviewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReviewServlet at " + request.getContextPath() + "</h1>");
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
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        try {
            ReviewDAO dao = new ReviewDAO();

            if ("delete".equals(action)) {
                // Xóa review
                int reviewID = Integer.parseInt(request.getParameter("reviewID"));

                dao.deleteReview(reviewID, user.getUserId());
                int variantID = Integer.parseInt(request.getParameter("variantID"));

                VariantsDAO vdao = new VariantsDAO();
                Variants variant = vdao.getVariantByID(variantID);
                int productID = variant.getProductID();
                response.sendRedirect("product?action=viewDetail&pID=" + productID);
            } else {
                // Thêm review
                int variantID = Integer.parseInt(request.getParameter("variantID"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");
                // Xử lý hình ảnh upload
                String imagePath = null;
                if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/")) {
                    Part imagePart = request.getPart("image");
                    if (imagePart != null && imagePart.getSize() > 0) {
                        String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                        String uploadDir = getServletContext().getRealPath("/image");
                        File uploadDirFile = new File(uploadDir);
                        if (!uploadDirFile.exists()) {
                            uploadDirFile.mkdirs(); // mkdirs() tạo đủ thư mục cha
                        }
                        imagePath = "image/" + fileName;
                        try {
                            imagePart.write(uploadDir + File.separator + fileName);
                        } catch (Exception e) {
                            e.printStackTrace(); // log lỗi nhưng không crash servlet
                        }
                    }
                }

                Review r = new Review();
                r.setUserID(user.getUserId());
                r.setVariantID(variantID);
                r.setRating(rating);
                r.setComment(comment);
                r.setReviewDate(LocalDateTime.now());
                r.setImage(imagePath);
                r.setReply(null);

                dao.addReview(r);
                VariantsDAO vdao = new VariantsDAO();
                Variants variant = vdao.getVariantByID(variantID);
                int productID = variant.getProductID();

                response.sendRedirect("product?action=viewDetail&pID=" + productID);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi ra console (log)
            throw new ServletException("Error handling review: " + e.getMessage(), e);
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
