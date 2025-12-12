package controller;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.*;

@MultipartConfig
@WebServlet(name = "ProductServlet", urlPatterns = {"/product"})
public class ProductServlet extends HttpServlet {

    /* ================= SESSION HELPERS ================= */
    private Integer getRole(HttpSession session) {
        return (session != null) ? (Integer) session.getAttribute("role") : null;
    }

    private Customer getCustomer(HttpSession session) {
        if (session == null) {
            return null;
        }
        Integer role = getRole(session);
        Object u = session.getAttribute("user");
        return (role != null && role == 1 && u instanceof Customer) ? (Customer) u : null;
    }

    private Staff getStaff(HttpSession session) {
        if (session == null) {
            return null;
        }
        Integer role = getRole(session);
        Object u = session.getAttribute("user");
        return (role != null && (role == 2 || role == 4) && u instanceof Staff) ? (Staff) u : null;
    }

    private boolean isAdmin(Staff s) {
        return s != null && s.getRole() == 4;
    }

    private boolean isStaffOrAdmin(Staff s) {
        return s != null && (s.getRole() == 2 || s.getRole() == 4);
    }

    /* ================= GET ================= */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "manageProduct";
        }

        HttpSession session = request.getSession(false);
        Customer customer = getCustomer(session);
        Staff staff = getStaff(session);

        ProductDAO pdao = new ProductDAO();
        VariantsDAO vdao = new VariantsDAO();
        ReviewDAO rdao = new ReviewDAO();
        CategoryDAO ctdao = new CategoryDAO();
        SupplierDAO sldao = new SupplierDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        ProfitDAO pfdao = new ProfitDAO();

        /* ================= PUBLIC ================= */
        if ("viewDetail".equals(action) || "selectStorage".equals(action)) {

            int productID = Integer.parseInt(request.getParameter("pID"));
            String vID = request.getParameter("vID");

            Products product = pdao.getProductByID(productID);
            List<Variants> listVariants = vdao.getAllVariantByProductID(productID);
            List<String> listStorage = vdao.getAllStorage(productID);

            Variants variants = null;
            if (vID != null && !vID.isEmpty()) {
                try {
                    variants = vdao.getVariantByID(Integer.parseInt(vID));
                } catch (NumberFormatException ignored) {
                }
            }

            if (variants == null && !listVariants.isEmpty()) {
                Variants v = listVariants.get(0);
                variants = vdao.getVariant(productID, v.getStorage(), v.getColor());
            }

            List<Variants> listVariantRating
                    = vdao.getAllVariantByStorage(productID, variants.getStorage());

            List<Review> listReview
                    = rdao.getAllReviewByListVariant(listVariantRating);

            double rating = rdao.getTotalRating(listVariantRating, listReview);
            Specification specification = pdao.getSpecificationByProductID(productID);

            /* ====== SET ĐỦ ATTRIBUTE CHO JSP ====== */
            request.setAttribute("productID", productID);        // 🔥 FIX NPE
            request.setAttribute("product", product);
            request.setAttribute("variants", variants);
            request.setAttribute("listVariants", listVariants);
            request.setAttribute("listStorage", listStorage);
            request.setAttribute("listVariantRating", listVariantRating);
            request.setAttribute("listReview", listReview);
            request.setAttribute("rating", rating);
            request.setAttribute("specification", specification);
            request.setAttribute("listCategory", ctdao.getAllCategories());

            // Wishlist
            if (customer != null) {
                WishlistDAO wdao = new WishlistDAO();
                request.setAttribute("wishlist",
                        wdao.getWishlistByUser(customer.getCustomerID()));
            }

            request.getRequestDispatcher("public/productdetail.jsp")
                    .forward(request, response);
            return;
        }

        /* ================= STAFF / ADMIN ================= */
        if (!isStaffOrAdmin(staff)) {
            response.sendRedirect("login");
            return;
        }

        /* ================= MANAGE PRODUCT ================= */
        if ("manageProduct".equals(action)) {

            List<Products> listProducts = pdao.getAllProduct();

            request.setAttribute("listProducts", listProducts); // ✅ FIX
            request.setAttribute("listCategory", ctdao.getAllCategories());
            request.setAttribute("listSupplier", sldao.getAllSupplier());

            if (staff.getRole() == 2) {
                request.getRequestDispatcher(
                        "staff/dashboard_staff_manageproduct.jsp")
                        .forward(request, response);
            } else {
                request.getRequestDispatcher(
                        "admin/dashboard_admin_manageproduct.jsp")
                        .forward(request, response);
            }
            return;
        } else if (action.equals("productDetail")) {
            try {
                List<Products> listProducts = pdao.getAllProduct();
                List<Variants> listVariants;

                if (staff != null && staff.getRole() == 2) {
                    // staff logic
                    String productId = request.getParameter("productId");
                    if (productId == null) {
                        productId = request.getParameter("pID");
                    }
                    if (productId == null) {
                        productId = request.getParameter("id");
                    }

                    String color = request.getParameter("color");
                    String storage = request.getParameter("storage");

                    if (color != null && color.trim().isEmpty()) {
                        color = null;
                    }
                    if (storage != null && storage.trim().isEmpty()) {
                        storage = null;
                    }

                    if (productId != null && !productId.isEmpty()) {
                        int id = Integer.parseInt(productId);
                        if (color != null || storage != null) {
                            listVariants = vdao.searchVariantsByProductId(id, color, storage);
                        } else {
                            listVariants = vdao.getAllVariantByProductID(id);
                        }
                    } else {
                        listVariants = vdao.searchVariants(color, storage);
                    }

                    request.setAttribute("listVariants", listVariants);
                    request.setAttribute("listProducts", listProducts);
                    request.setAttribute("allColors", vdao.getAllColors());
                    request.setAttribute("allStorages", vdao.getAllStorages());
                    request.setAttribute("selectedProductId", productId);

                    request.getRequestDispatcher("staff/staff_manageproduct_detail.jsp").forward(request, response);

                } else if (staff != null && staff.getRole() == 4) {
                    // admin logic
                    int pID = Integer.parseInt(request.getParameter("pID"));
                    listVariants = vdao.getAllVariantByProductID(pID);

                    if (listVariants == null || listVariants.isEmpty()) {
                        response.sendRedirect("product?action=manageProduct");
                        return;
                    }

                    request.setAttribute("pID", pID);
                    request.setAttribute("listProducts", listProducts);
                    request.setAttribute("listVariants", listVariants);
                    vdao.updateDiscountPrice();
                    request.getRequestDispatcher("admin/admin_manageproduct_detail.jsp").forward(request, response);
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }
        }


        /* ================= UPDATE PRODUCT ================= */
        if ("updateProduct".equals(action)) {
            if (!isAdmin(staff)) {
                response.sendRedirect("product?action=manageProduct");
                return;
            }

            int pID = Integer.parseInt(request.getParameter("pID"));
            request.setAttribute("product", pdao.getProductByID(pID));
            request.setAttribute("specification",
                    pdao.getSpecificationByProductID(pID));
            request.setAttribute("listSupplier", sldao.getAllSupplier());
            request.setAttribute("listCategories", ctdao.getAllCategories());

            request.getRequestDispatcher(
                    "admin/admin_manageproduct_editproduct.jsp")
                    .forward(request, response);
            return;
        }

        /* ================= DELETE PRODUCT ================= */
        if ("deleteProduct".equals(action)) {
            if (!isAdmin(staff)) {
                response.sendRedirect("product?action=manageProduct");
                return;
            }

            int pID = Integer.parseInt(request.getParameter("pID"));
            for (Variants v : vdao.getVariantByProductID(pID)) {
                pfdao.deleteProfitByVariantID(v.getVariantID());
            }

            vdao.deleteVariantByProductID(pID);
            pdao.deleteSpecificationByProductID(pID);
            pmtdao.deletePromotionByProductID(pID);
            pdao.deleteProductByProductID(pID);

            response.sendRedirect("product?action=manageProduct");
        }
    }

    /* ================= POST ================= */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Staff staff = getStaff(session);
        String action = request.getParameter("action");

        if ("createProduct".equals(action)) {
            if (!isAdmin(staff)) {
                response.sendRedirect("login");
                return;
            }

            ProductDAO pdao = new ProductDAO();
            pdao.createProduct(
                    Integer.parseInt(request.getParameter("category")),
                    Integer.parseInt(request.getParameter("supplierID")),
                    request.getParameter("pName"),
                    request.getParameter("brand"),
                    Integer.parseInt(request.getParameter("warrantyPeriod"))
            );

            response.sendRedirect("product?action=manageProduct");
        }
    }

    @Override
    public String getServletInfo() {
        return "ProductServlet - FINAL stable version (no NPE, safe role handling)";
    }
}
