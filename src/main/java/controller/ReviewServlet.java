package controller;

import dao.OrderDAO;
import dao.ReviewDAO;
import dao.VariantsDAO;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Review;
import model.Users;
import model.Variants;

/**
 * Servlet xử lý review (thêm / xóa / upload ảnh)
 *
 * @author Dâu
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024, // 10MB mỗi file
        maxRequestSize = 50 * 1024 * 1024 // 50MB tổng request
)
public class ReviewServlet extends HttpServlet {

    // ===== GET: load review theo variantID =====
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ReviewDAO rdao = new ReviewDAO();
        String action = request.getParameter("action");

        if (action == null) {
            action = "null";
        }

        try {
            if ("reviewDetail".equals(action)) {
                int rID = Integer.parseInt(request.getParameter("rID"));

                Review review = rdao.getReviewByID(rID);

                request.setAttribute("review", review);
                request.getRequestDispatcher("admin/admin_managereview_detail.jsp").forward(request, response);
            } else {
                int variantID = Integer.parseInt(request.getParameter("variantID"));
                List<Review> review = rdao.getReviewsByVariantID(variantID);
                request.setAttribute("review", review);
                request.getRequestDispatcher("productdetail.jsp").forward(request, response);
            }

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
        if (action == null) {
            action = "review";
        }

        ReviewDAO rdao = new ReviewDAO();
        VariantsDAO vdao = new VariantsDAO();
        OrderDAO odao = new OrderDAO();

        if ("review".equals(action)) {
            // === Thêm review mới ===
            int vID = Integer.parseInt(request.getParameter("vID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            int uID = user.getUserId();

            // === Kiểm tra xem người dùng đã mua sản phẩm chưa ===
            boolean hasPurchased = odao.checkUserPurchase(uID, vID);
            Variants variant = vdao.getVariantByID(vID);
            int productID = variant.getProductID();

            if (!hasPurchased) {
                session.setAttribute("reviewError", "Bạn phải mua sản phẩm này để được đánh giá.");
                response.sendRedirect("product?action=viewDetail&pID=" + productID);
                return;
            }

            // Tạo review trong DB
            rdao.createReview(uID, vID, rating, comment);

            // Lấy ID review mới nhất
            int currentReviewID = rdao.getCurrentReviewID();

            // === Upload ảnh review ===
            String filePath = request.getServletContext().getRealPath("images_review");
            String basePath = filePath.substring(0, filePath.indexOf("\\target"));
            String uploadDir = basePath + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "images_review";

            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) {
                uploadFolder.mkdirs();
            }

            String img = "";
            for (Part part : request.getParts()) {
                if ("photos".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = currentReviewID + "_" + Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    img += fileName + "#";
                    String srcFile = uploadDir + File.separator + fileName;
                    part.write(srcFile);

                    // Copy đến thư mục thực thi (target)
                    File srcFileImages = new File(srcFile);
                    File targetFile = new File(filePath + File.separator + fileName);
                    Files.copy(srcFileImages.toPath(), targetFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                }
            }

            if (!img.isEmpty()) {
                img = img.substring(0, img.length() - 1);
                rdao.updateImageReview(currentReviewID, img);
            }

            response.sendRedirect("product?action=viewDetail&pID=" + productID);

        } else if ("deleteReview".equals(action)) {
            // === Xóa review ===
            int rID = Integer.parseInt(request.getParameter("rID"));
            int vID = Integer.parseInt(request.getParameter("vID"));
            rdao.deleteReview(rID);

            Variants variant = vdao.getVariantByID(vID);
            int productID = variant.getProductID();
            response.sendRedirect("product?action=viewDetail&pID=" + productID);

        } else if ("replyReview".equals(action)) {
            // === Admin trả lời review ===
            int rID = Integer.parseInt(request.getParameter("rID"));
            String reply = request.getParameter("reply");

            rdao.updateReview(rID, reply);
            response.sendRedirect("admin?action=manageReview");
        }
    }
}
