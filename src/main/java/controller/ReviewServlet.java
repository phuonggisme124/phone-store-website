package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import dao.ReviewDAO;
import dao.CustomerDAO;
import dao.VariantsDAO;
import java.io.File;
import java.io.IOException;
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
import model.Customer;
import model.Staff; // Đã thêm import Staff
import model.Variants;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, 
        maxFileSize = 10 * 1024 * 1024, 
        maxRequestSize = 50 * 1024 * 1024 
)
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ReviewDAO rdao = new ReviewDAO();
        OrderDAO dao = new OrderDAO();
        CustomerDAO udao = new CustomerDAO();
        VariantsDAO vdao = new VariantsDAO();
        
        String action = request.getParameter("action");
        if (action == null) action = "null";

        HttpSession session = request.getSession();
        
        // --- SỬA LỖI ClassCastException TẠI ĐÂY ---
        Object userObj = session.getAttribute("user");
        Customer currentUser = null;
        Staff currentStaff = null;

        if (userObj != null) {
            if (userObj instanceof Customer) {
                currentUser = (Customer) userObj;
            } else if (userObj instanceof Staff) {
                currentStaff = (Staff) userObj;
            }
        }
        // -------------------------------------------

        try {
            // STAFF & ADMIN: Quản lý Review
            if ("manageReview".equals(action)) {
                
                // Kiểm tra quyền Staff/Admin (Role 2 hoặc 4)
                if (currentStaff == null || (currentStaff.getRole() != 2 && currentStaff.getRole() != 4)) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                String message = (String) session.getAttribute("message");
                if (message != null) {
                    request.setAttribute("message", message);
                    session.removeAttribute("message"); 
                }
                String error = (String) session.getAttribute("error");
                if (error != null) {
                    request.setAttribute("error", error);
                    session.removeAttribute("error");
                }
               
                List<Review> listReview = rdao.getAllReview();
                request.setAttribute("listReview", listReview);
               
                // Điều hướng dựa trên Role
                if (currentStaff.getRole() == 2) {
                    // Staff
                   
                    request.getRequestDispatcher("staff/staff_managereview.jsp").forward(request, response);
                } else {
                    // Admin
                    
                    request.getRequestDispatcher("admin/dashboard_admin_managereview.jsp").forward(request, response);
                }
            } 
            
            // STAFF & ADMIN: Xem chi tiết Review
            else if ("reviewDetail".equals(action)) {
                if (currentStaff == null || (currentStaff.getRole() != 2 && currentStaff.getRole() != 4)) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                int rID = Integer.parseInt(request.getParameter("rID"));
                Review review = rdao.getReviewByID(rID);
                request.setAttribute("review", review);

                if (currentStaff.getRole() == 2) {
                    request.getRequestDispatcher("staff/staff_managereview_detail.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("admin/admin_managereview_detail.jsp").forward(request, response);
                }
            } 
            
            // ADMIN ONLY: Các chức năng Trả góp (Instalment)
            else if (action.equals("showInstalment")) {
                if (currentStaff == null || currentStaff.getRole() != 4) {
                    response.sendRedirect("login.jsp"); return;
                }
                List<Order> listOrder = dao.getAllOrder();
                List<String> listPhone = dao.getAllPhoneInstalment();
//                List<Sale> listSales = udao.getAllSales();
                request.setAttribute("listOrder", listOrder);
                request.setAttribute("listPhone", listPhone);
//                request.setAttribute("listSales", listSales);
                request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
            } 
            else if (action.equals("searchInstalment")) {
                if (currentStaff == null || currentStaff.getRole() != 4) {
                    response.sendRedirect("login.jsp"); return;
                }
                String phone = request.getParameter("phone");
                String status = request.getParameter("status");
                List<String> listPhone = dao.getAllPhoneInstalment();
                List<Order> listOrder;
                if (status.equals("Filter") || status.equals("All")) {
                    listOrder = dao.getAllOrderInstalmentByPhone(phone);
                } else if (status.equals("Pending")) {
                    listOrder = dao.getAllPendingInstalment(dao.getAllOrderInstalment());
                } else {
                    listOrder = dao.getAllCompletedInstalment(dao.getAllOrderInstalment());
                }
                request.setAttribute("listOrder", listOrder);
                request.setAttribute("listPhone", listPhone);
                request.setAttribute("action", action);
                request.setAttribute("phone", phone);
                request.setAttribute("status", status);
//                request.setAttribute("listSales", udao.getAllSales());
                request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
            } 
            else if (action.equals("filterInstalment")) {
                 if (currentStaff == null || currentStaff.getRole() != 4) {
                    response.sendRedirect("login.jsp"); return;
                }
 
                 String phone = request.getParameter("phone");
                 String status = request.getParameter("status");
                 List<Order> listOrder;
                 if (phone == null || phone.isEmpty()) {
                    if (status.equals("Pending")) listOrder = dao.getAllPendingInstalment(dao.getAllOrderInstalment());
                    else listOrder = dao.getAllCompletedInstalment(dao.getAllOrderInstalment());
                 } else {
                    if (status.equals("Pending")) listOrder = dao.getAllPendingInstalmentAndPhone(dao.getAllOrderInstalment(), phone);
                    else listOrder = dao.getAllCompletedInstalmentAndPhone(dao.getAllOrderInstalment(), phone);
                 }
                 request.setAttribute("listOrder", listOrder);
                 request.setAttribute("listPhone", dao.getAllPhoneInstalment());
                 request.setAttribute("action", action);
                 request.setAttribute("phone", phone);
                 request.setAttribute("status", status);
//                 request.setAttribute("listSales", udao.getAllSales());
                 request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
            }
            // ADMIN: Search/Filter Review
            else if (action.equals("searchReview") || action.equals("filterReview")) {
                if (currentStaff == null || currentStaff.getRole() != 4) {
                    response.sendRedirect("login.jsp"); return;
                }
                int productID = Integer.parseInt(request.getParameter("productID"));
                String storage = request.getParameter("storage");
                int rating = Integer.parseInt(request.getParameter("rating"));
                
                List<Review> listReview;
  
                if (rating == 0 && (productID == 0)) {
                     listReview = rdao.getAllReview();
                } else if (rating == 0) {
                    List<Variants> listVariant = vdao.getAllVariantByStorage(productID, storage);
                    listReview = rdao.getAllReviewByListVariant(listVariant);
                } else if (productID == 0 && (storage == null || storage.isEmpty())) {
                    listReview = rdao.getAllReviewByRating(rating);
                } else {
                    List<Variants> listVariant = vdao.getAllVariantByStorage(productID, storage);
                    listReview = rdao.getAllReviewByListVariantAndRating(listVariant, rating);
                }
                
                request.setAttribute("listReview", listReview);
                request.setAttribute("productID", productID);
                request.setAttribute("storage", storage);
                request.setAttribute("rating", rating);
                request.getRequestDispatcher("admin/dashboard_admin_managereview.jsp").forward(request, response);
            }

            // PUBLIC: Xem review (Không bắt buộc login)
            else {
                try {
                    int variantID = Integer.parseInt(request.getParameter("variantID"));
                    List<Review> review = rdao.getReviewsByVariantID(variantID);
                    request.setAttribute("review", review);
                    request.getRequestDispatcher("productdetail.jsp").forward(request, response);
                } catch (Exception e) {
                    response.sendRedirect("home");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error: " + e.getMessage());
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
        // --- SỬA LỖI ClassCastException CHO DOPOST ---
        Object userObj = session.getAttribute("user");
        Customer currentUser = null;
        Staff currentStaff = null;

        if (userObj != null) {
            if (userObj instanceof Customer) {
                currentUser = (Customer) userObj;
            } else if (userObj instanceof Staff) {
                currentStaff = (Staff) userObj;
            }
        }
        // ---------------------------------------------

        if (currentUser == null && currentStaff == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "review";

        ReviewDAO rdao = new ReviewDAO();
        VariantsDAO vdao = new VariantsDAO();
        OrderDAO odao = new OrderDAO();
        ProductDAO pdao = new ProductDAO();

        // CUSTOMER: Viết Review
        if ("review".equals(action)) {
            // Chỉ Customer mới được viết review
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            try {
                int vID = Integer.parseInt(request.getParameter("vID"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");
                
                // Lấy ID từ currentUser (sử dụng getCustomerID theo model bạn gửi)
                int uID = currentUser.getCustomerID();

                Variants variant = vdao.getVariantByID(vID);
                boolean hasPurchased = odao.checkUserPurchase(uID, variant.getProductID(), variant.getStorage());
                int productID = variant.getProductID();
                Products product = pdao.getProductByID(productID);

                   if (!hasPurchased) {
                    session.setAttribute("reviewError", "You must purchase this product to rate.");
                    response.sendRedirect("product?action=selectStorage&pID=" + productID + "&cID=" + product.getCategoryID() + "&storage=" + variant.getStorage() + "&color=" + variant.getColor());
                    return;
                }

                // Gọi DAO: createReview (void)
                rdao.createReview(uID, vID, rating, comment);
                
                // Xử lý ảnh
                int currentReviewID = rdao.getCurrentReviewID();
                String filePath = request.getServletContext().getRealPath("images_review");
                
                // Xử lý đường dẫn lưu file (Source + Target)
                String basePath = "";
                if (filePath.contains("\\target")) {
                    basePath = filePath.substring(0, filePath.indexOf("\\target"));
                } else {
                    basePath = filePath;
                }
                String uploadDir = basePath + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "images_review";
                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) uploadFolder.mkdirs();
                
                String img = "";
                for (Part part : request.getParts()) {
                    if ("photos".equals(part.getName()) && part.getSize() > 0) {
                        String fileName = currentReviewID + "_" + Paths.get(part.getSubmittedFileName()).getFileName().toString();
                        img += fileName + "#";
                        String srcFile = uploadDir + File.separator + fileName;
                        part.write(srcFile); 

                        // Copy sang Target
                        File srcFileImages = new File(srcFile);
                        File targetDir = new File(filePath);
                        if (!targetDir.exists()) targetDir.mkdirs();
                        File targetFile = new File(filePath + File.separator + fileName);
                        Files.copy(srcFileImages.toPath(), targetFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    }
                }
             
                if (!img.isEmpty()) {
                    img = img.substring(0, img.length() - 1);
                    rdao.updateImageReview(currentReviewID, img);
                }

                response.sendRedirect("product?action=selectStorage&pID=" + productID + "&cID=" + product.getCategoryID() + "&storage=" + variant.getStorage() + "&color=" + variant.getColor());

            } catch (Exception e) {
                e.printStackTrace();
            }

        } 
        // CUSTOMER: Xóa reviews
        else if ("deleteReview".equals(action)) {
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int rID = Integer.parseInt(request.getParameter("rID"));
            int vID = Integer.parseInt(request.getParameter("vID"));
            rdao.deleteReview(rID); 

            Variants variant = vdao.getVariantByID(vID);
            response.sendRedirect("product?action=viewDetail&pID=" + variant.getProductID());
        } 
        
        // STAFF & ADMIN: Trả lời Review
        else if ("replyReview".equals(action)) {

            // Kiểm tra quyền Staff/Admin
            if (currentStaff == null || (currentStaff.getRole() != 2 && currentStaff.getRole() != 4)) {
                response.sendRedirect("login.jsp");
                return;
            }

            try {
                int reviewID = Integer.parseInt(request.getParameter("reviewID"));
                String reply = request.getParameter("reply");

                rdao.replyToReview(reviewID, reply);

                session.setAttribute("message", "Review reply successful!");

                response.sendRedirect("review?action=manageReview");

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Lỗi reply: " + e.getMessage());
                response.sendRedirect("review?action=manageReview");
            }
        }
    }
}