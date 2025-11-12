package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import dao.ReviewDAO;
import dao.UsersDAO;
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
import model.Order;
import model.Products;
import model.Review;
import model.Sale;
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
        OrderDAO dao = new OrderDAO();
        UsersDAO udao = new UsersDAO();
        VariantsDAO vdao = new VariantsDAO();
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
            } else if (action.equals("manageReview")) {
                List<Review> listReview = rdao.getAllReview();
                request.setAttribute("listReview", listReview);
                request.getRequestDispatcher("admin/dashboard_admin_managereview.jsp").forward(request, response);
            } else if (action.equals("showInstalment")) {

                List<Order> listOrder = dao.getAllOrder();
                List<String> listPhone = dao.getAllPhoneInstalment();
                List<Sale> listSales = udao.getAllSales();
                request.setAttribute("listOrder", listOrder);
                request.setAttribute("listPhone", listPhone);

                request.setAttribute("listSales", listSales);
                request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
            } else if (action.equals("searchInstalment")) {
                String phone = request.getParameter("phone");
                String status = request.getParameter("status");
                List<String> listPhone = dao.getAllPhoneInstalment();
                List<Order> listOrder;

                if (status.equals("Filter") || status.equals("All")) {
                    listOrder = dao.getAllOrderInstalmentByPhone(phone);
                } else if (status.equals("Pending")) {
                    List<Order> listInstalment = dao.getAllOrderInstalment();
                    listOrder = dao.getAllPendingInstalment(listInstalment);
                } else {
                    List<Order> listInstalment = dao.getAllOrderInstalment();
                    listOrder = dao.getAllCompletedInstalment(listInstalment);
                }

                List<Sale> listSales = udao.getAllSales();

                request.setAttribute("listOrder", listOrder);
                request.setAttribute("listPhone", listPhone);

                request.setAttribute("action", action);
                request.setAttribute("phone", phone);
                request.setAttribute("status", status);
                request.setAttribute("listSales", listSales);
                request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
            } else if (action.equals("filterInstalment")) {

                String phone = request.getParameter("phone");
                String status = request.getParameter("status");
                List<String> listPhone = dao.getAllPhoneInstalment();
                List<Order> listOrder;

                if (phone == null || phone.isEmpty()) {
                    if (status.equals("Pending")) {
                        List<Order> listInstalment = dao.getAllOrderInstalment();
                        listOrder = dao.getAllPendingInstalment(listInstalment);
                    } else {
                        List<Order> listInstalment = dao.getAllOrderInstalment();
                        listOrder = dao.getAllCompletedInstalment(listInstalment);
                    }
                } else {
                    if (status.equals("Pending")) {
                        List<Order> listInstalment = dao.getAllOrderInstalment();
                        listOrder = dao.getAllPendingInstalmentAndPhone(listInstalment, phone);
                    } else {
                        List<Order> listInstalment = dao.getAllOrderInstalment();
                        listOrder = dao.getAllCompletedInstalmentAndPhone(listInstalment, phone);
                    }
                }

                List<Sale> listSales = udao.getAllSales();

                request.setAttribute("listOrder", listOrder);
                request.setAttribute("listPhone", listPhone);

                request.setAttribute("action", action);
                request.setAttribute("phone", phone);
                request.setAttribute("status", status);
                request.setAttribute("listSales", listSales);
                request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
            } else if (action.equals("searchReview")) {
                int productID = Integer.parseInt(request.getParameter("productID"));
                String storage = request.getParameter("storage");
                int rating = Integer.parseInt(request.getParameter("rating"));

                List<Review> listReview;
                if (rating == 0) {
                    List<Variants> listVariant = vdao.getAllVariantByStorage(productID, storage);
                    listReview = rdao.getAllReviewByListVariant(listVariant);
                } else {
                    List<Variants> listVariant = vdao.getAllVariantByStorage(productID, storage);
                    listReview = rdao.getAllReviewByListVariantAndRating(listVariant, rating);
                }

                request.setAttribute("listReview", listReview);
                request.setAttribute("productID", productID);
                request.setAttribute("storage", storage);
                request.setAttribute("rating", rating);
                request.getRequestDispatcher("admin/dashboard_admin_managereview.jsp").forward(request, response);

            } else if (action.equals("filterReview")) {
                int productID = Integer.parseInt(request.getParameter("productID"));
                String storage = request.getParameter("storage");
                int rating = Integer.parseInt(request.getParameter("rating"));
                List<Review> listReview;
                if ((productID == 0) && (storage == null || storage.isEmpty()) && rating != 0) {
                    listReview = rdao.getAllReviewByRating(rating);
                } else if ((productID != 0) && (storage != null) && rating != 0) {
                    List<Variants> listVariant = vdao.getAllVariantByStorage(productID, storage);
                    listReview = rdao.getAllReviewByListVariantAndRating(listVariant, rating);
                } else if ((productID != 0) && (storage != null) && rating == 0) {
                    List<Variants> listVariant = vdao.getAllVariantByStorage(productID, storage);
                    listReview = rdao.getAllReviewByListVariant(listVariant);
                } else {
                    listReview = rdao.getAllReview();
                }

                request.setAttribute("listReview", listReview);
                request.setAttribute("productID", productID);
                request.setAttribute("storage", storage);
                request.setAttribute("rating", rating);
                request.getRequestDispatcher("admin/dashboard_admin_managereview.jsp").forward(request, response);
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
        ProductDAO pdao = new ProductDAO();

        if ("review".equals(action)) {
            // === Thêm review mới ===
            int vID = Integer.parseInt(request.getParameter("vID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            int uID = user.getUserId();

            // === Kiểm tra xem người dùng đã mua sản phẩm chưa ===
            Variants variant = vdao.getVariantByID(vID);
            boolean hasPurchased = odao.checkUserPurchase(uID, variant.getProductID(), variant.getStorage());

            int productID = variant.getProductID();
            Products product = pdao.getProductByID(productID);

            if (!hasPurchased) {
                session.setAttribute("reviewError", "Bạn phải mua sản phẩm này để được đánh giá.");
                response.sendRedirect("product?action=selectStorage&pID=" + productID + "&cID=" + product.getCategoryID() + "&storage=" + variant.getStorage() + "&color=" + variant.getColor());
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

            response.sendRedirect("product?action=selectStorage&pID=" + productID + "&cID=" + product.getCategoryID() + "&storage=" + variant.getStorage() + "&color=" + variant.getColor());

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
            response.sendRedirect("review?action=manageReview");
        }
    }
}
