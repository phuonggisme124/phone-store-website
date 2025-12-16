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
        if (session == null) return null;
        Integer role = getRole(session);
        Object u = session.getAttribute("user");
        return (role != null && role == 1 && u instanceof Customer) ? (Customer) u : null;
    }

    private Staff getStaff(HttpSession session) {
        if (session == null) return null;
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
        if (action == null) action = "manageProduct";

        HttpSession session = request.getSession();
        Integer role = getRole(session);
        Customer customer = getCustomer(session);
        Staff staff = getStaff(session);

        ProductDAO pdao = new ProductDAO();
        VariantsDAO vdao = new VariantsDAO();
        ReviewDAO rdao = new ReviewDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        ProfitDAO pfdao = new ProfitDAO();

        /* ================= ROLE CHECK ================= */
        if (Set.of("manageProduct", "productDetail", "updateProduct",
                   "deleteProduct", "createProduct").contains(action)) {
            if (staff == null) {
                response.sendRedirect("login");
                return;
            }
        }

        /* ================= PUBLIC ================= */
        if ("viewDetail".equals(action)) {
            int productID = Integer.parseInt(request.getParameter("pID"));
            String vID = request.getParameter("vID");

            Products p = pdao.getProductByID(productID);
            List<Variants> listVariants = vdao.getAllVariantByProductID(productID);
            Variants variants = (vID != null)
                    ? vdao.getVariantByID(Integer.parseInt(vID))
                    : listVariants.get(0);

            List<Variants> ratingVariants =
                    vdao.getAllVariantByStorage(productID, variants.getStorage());

            List<Review> listReview = rdao.getAllReviewByListVariant(ratingVariants);
            double rating = rdao.getTotalRating(ratingVariants, listReview);

            request.setAttribute("product", p);
            request.setAttribute("variants", variants);
            request.setAttribute("listVariants", listVariants);
            request.setAttribute("listReview", listReview);
            request.setAttribute("rating", rating);
            request.setAttribute("specification",
                    pdao.getSpecificationByProductID(productID));
            request.setAttribute("listCategory", pdao.getAllCategory());

            // Wishlist
            if (customer != null) {
                WishlistDAO wdao = new WishlistDAO();
                request.setAttribute("wishlist",
                        wdao.getWishlistByCustomer(customer.getCustomerID()));
                request.setAttribute("user", customer);
            }

            request.getRequestDispatcher("public/productdetail.jsp")
                   .forward(request, response);
            return;
        }

        /* ================= MANAGE PRODUCT ================= */
        if ("manageProduct".equals(action)) {

            List<Products> products = pdao.getAllProduct();
            request.setAttribute("currentListProduct", products);
            request.setAttribute("listCategory", ctdao.getAllCategories());
            request.setAttribute("listSupplier", sldao.getAllSupplier());

            if (role == 2) {
                request.getRequestDispatcher("staff/dashboard_staff_manageproduct.jsp")
                       .forward(request, response);
            } else {
                request.getRequestDispatcher("admin/dashboard_admin_manageproduct.jsp")
                       .forward(request, response);
            }
            return;
        }

        response.sendRedirect("home");
    }

    /* ================= POST ================= */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        ProductDAO pdao = new ProductDAO();
        VariantsDAO vdao = new VariantsDAO();
        ProfitDAO pfdao = new ProfitDAO();
        WishlistDAO wdao = new WishlistDAO();

        Customer customer = getCustomer(session);
        Staff staff = getStaff(session);

        /* ================= CREATE / UPDATE PRODUCT ================= */
        if ("createProduct".equals(action) || "updateProduct".equals(action)) {
            if (!isAdmin(staff)) {
                response.sendRedirect("product?action=manageProduct");
                return;
            }
        }

        /* ================= WISHLIST ================= */
        if ("toggleWishlist".equals(action)) {
            if (customer == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            int productId = Integer.parseInt(request.getParameter("productId"));
            String v = request.getParameter("variantId");
            int variantId = (v == null || v.isEmpty() || "undefined".equals(v))
                    ? 0 : Integer.parseInt(v);

            if (wdao.isExist(customer.getCustomerID(), productId, variantId)) {
                wdao.removeFromWishlist(customer.getCustomerID(), productId, variantId);
            } else {
                wdao.addToWishlist(customer.getCustomerID(), productId, variantId);
            }
            response.getWriter().write("ok");
            return;
        }

        if ("viewWishlist".equals(action)) {
            if (customer == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            request.setAttribute("wishlist",
                    wdao.getWishlistByCustomer(customer.getCustomerID()));
            request.setAttribute("user", customer);
            request.getRequestDispatcher("public/wishlist.jsp")
                   .forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "ProductServlet - FINAL merged & stable version";
    }
}
