/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.ProfitDAO;
import dao.PromotionsDAO;
import dao.ReviewDAO;
import dao.SupplierDAO;
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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.Products;
import model.Promotions;
import model.Review;
import model.Specification;
import model.Suppliers;
import model.Variants;

/**
 *
 * @author duynu
 */
@MultipartConfig
@WebServlet(name = "ProductServlet", urlPatterns = {"/product"})
public class ProductServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods.">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ProductDAO pdao = new ProductDAO();
        VariantsDAO vdao = new VariantsDAO();
        ReviewDAO rdao = new ReviewDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        ProfitDAO pfdao = new ProfitDAO();

        // === Case 1: View product details ===
        if ("viewDetail".equals(action)) {
            String vID = request.getParameter("vID");
            int productID = Integer.parseInt(request.getParameter("pID"));

            List<Category> listCategory = pdao.getAllCategory();
            List<String> listStorage = vdao.getAllStorage(productID);
            Products p = pdao.getProductByID(productID);
            int cID = p.getCategoryID();
            List<Variants> listVariants = vdao.getAllVariantByProductID(productID);

            Variants variants = null;

            if (vID != null && !vID.isEmpty()) {
                try {
                    int variantID = Integer.parseInt(vID);
                    variants = vdao.getVariantByID(variantID);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

            if (variants == null) {
                // fallback nếu không truyền vID
                variants = vdao.getVariant(
                        productID,
                        listVariants.get(0).getStorage(),
                        listVariants.get(0).getColor()
                );
            }

            List<Variants> listVariantRating = vdao.getAllVariantByStorage(variants.getProductID(), variants.getStorage());

            Specification specification = pdao.getSpecificationByProductID(productID);

            // Lấy danh sách review theo VariantID
            List<Review> listReview = rdao.getAllReviewByListVariant(listVariantRating);

            double rating = rdao.getTotalRating(listVariantRating, listReview);

            // Pass data to JSP
            request.setAttribute("categoryID", cID);
            if (vID != null) {
                request.setAttribute("vID", vID);
            }
            request.setAttribute("rating", rating);
            request.setAttribute("specification", specification);
            request.setAttribute("productID", productID);
            request.setAttribute("listStorage", listStorage);
            request.setAttribute("listVariants", listVariants);
            request.setAttribute("variants", variants);
            request.setAttribute("listCategory", listCategory);
            request.setAttribute("listVariantRating", listVariantRating);
            request.setAttribute("listReview", listReview);
            request.setAttribute("product", p);

            // Forward to product detail page
            request.getRequestDispatcher("public/productdetail.jsp").forward(request, response);

            // === Case 2: Change storage variant ===
        } else if ("selectStorage".equals(action)) {
            int pID = Integer.parseInt(request.getParameter("pID"));
            int cID = Integer.parseInt(request.getParameter("cID"));
            String storage = request.getParameter("storage");
            String color = request.getParameter("color");

            Variants variants;
            List<Products> listProducts = pdao.getAllProduct();
            List<Variants> listVariants = vdao.getAllVariantByProductID(pID);
            List<Variants> listVariantRating = vdao.getAllVariantByStorage(pID, storage);
            List<String> listStorage = vdao.getAllStorage(pID);
            List<Category> listCategory = pdao.getAllCategory();

            // Retrieve specific variant
            variants = vdao.getVariant(pID, storage, color);
            if (variants == null && !listVariantRating.isEmpty()) {
                // If color not found, select first available variant
                variants = vdao.getVariant(pID, storage, listVariantRating.get(0).getColor());
            }

            List<Review> listReview = rdao.getAllReviewByListVariant(listVariantRating);
            double rating = rdao.getTotalRating(listVariantRating, listReview);
            Specification specification = pdao.getSpecificationByProductID(pID);
            // Send data to JSP
            request.setAttribute("productID", pID);
            request.setAttribute("rating", rating);
            request.setAttribute("categoryID", cID);
            request.setAttribute("variants", variants);
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listVariants", listVariants);
            request.setAttribute("listVariantRating", listVariantRating);
            request.setAttribute("listReview", listReview);
            request.setAttribute("specification", specification);
            request.setAttribute("listStorage", listStorage);
            request.setAttribute("listCategory", listCategory);

            // Forward to product detail page
            request.getRequestDispatcher("public/productdetail.jsp").forward(request, response);

// === Case 3: Filter by category ===
        } else if ("category".equals(action)) {
            int cID = Integer.parseInt(request.getParameter("cID"));
            String variation = request.getParameter("variation");
            if (variation == null) {
                variation = "ALL";
            }
            List<Products> listProduct = pdao.getAllProductByCategory(cID);
            List<Variants> listVariant;
            List<Review> listReview = rdao.getAllReview();

            if (variation.equals("ALL")) {
                listVariant = vdao.getAllVariantByCategory(cID);
            } else if (variation.equals("PROMOTION")) {
                listVariant = vdao.getAllVariantByCategory(cID);
                PromotionsDAO promotionDAO = new PromotionsDAO();
                List<Promotions> promotionsList = promotionDAO.getTheHighestPromotion();
                request.setAttribute("promotionsList", promotionsList);
            } else {
                listVariant = vdao.getAllVariantByCategoryAndOrderByPrice(cID, variation);
            }

            // ====== THÊM DỮ LIỆU CHO THANH SEARCH ======
            // Lấy TẤT CẢ products và variants để search
            List<Products> productList1_search = pdao.getAllProduct();
            List<Variants> variantsList_search = new ArrayList<>();
            try {
                variantsList_search = vdao.getAllVariants();
            } catch (SQLException ex) {
                Logger.getLogger(ProductServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            request.setAttribute("productList1", productList1_search);
            request.setAttribute("variantsList", variantsList_search);
            // ============================================

            // Set attributes for category page
            request.setAttribute("listVariant", listVariant);
            request.setAttribute("categoryID", cID);
            request.setAttribute("listProduct", listProduct);
            request.setAttribute("listReview", listReview);

            // Forward to category JSP
            request.getRequestDispatcher("public/view_product_by_category.jsp").forward(request, response);
        } else if (action.equals("productDetail")) {

            int pID = Integer.parseInt(request.getParameter("pID"));
            List<Products> listProducts = pdao.getAllProduct();
            List<Variants> listVariants = vdao.getAllVariantByProductID(pID);
            if (listVariants == null || listVariants.isEmpty()) {
                response.sendRedirect("admin?action=manageProduct");

            } else {
                //Promotions promotion = pmtdao.getPromotionByProductID(id);

                request.setAttribute("pID", pID);
                //request.setAttribute("promotion", promotion);
                request.setAttribute("listProducts", listProducts);
                request.setAttribute("listVariants", listVariants);

                request.getRequestDispatcher("admin/admin_manageproduct_detail.jsp").forward(request, response);
            }

        } else if (action.equals("updateProduct")) {
            int pID = Integer.parseInt(request.getParameter("pID"));
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            List<Category> listCategories = ctdao.getAllCategories();

            Products product = pdao.getProductByID(pID);
            Specification specification = pdao.getSpecificationByProductID(pID);

            request.setAttribute("listSupplier", listSupplier);
            request.setAttribute("listCategories", listCategories);
            request.setAttribute("product", product);
            request.setAttribute("specification", specification);
            request.getRequestDispatcher("admin/admin_manageproduct_editproduct.jsp").forward(request, response);
        } else if (action.equals("deleteProduct")) {
            int pID = Integer.parseInt(request.getParameter("pID"));

            List<Variants> listVariant = vdao.getVariantByProductID(pID);
            for (Variants v : listVariant) {
                pfdao.deleteProfitByVariantID(v.getVariantID());
            }
            vdao.deleteVariantByProductID(pID);

            pdao.deleteSpecificationByProductID(pID);
            pmtdao.deletePromotionByProductID(pID);
            pdao.deleteProductByProductID(pID);

            response.sendRedirect("admin?action=manageProduct");
        } else if (action.equals("createProduct")) {
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            List<Category> listCategories = ctdao.getAllCategories();
            request.setAttribute("listSupplier", listSupplier);
            request.setAttribute("listCategories", listCategories);
            request.getRequestDispatcher("admin/admin_manageproduct_create.jsp").forward(request, response);
        } else if (action.equals("manageProduct")) {
            List<Products> listProducts = pdao.getAllProduct();
            List<Category> listCategory = ctdao.getAllCategories();
            List<Suppliers> listSupplier = sldao.getAllSupplier();

            for (Products product : listProducts) {
                List<Variants> listVariant = vdao.getAllVariantByProductID(product.getProductID());
                if (listVariant == null || listVariant.isEmpty()) {
                    pdao.deleteSpecificationByProductID(product.getProductID());
                    pmtdao.deletePromotionByProductID(product.getProductID());
                    pdao.deleteProductByProductID(product.getProductID());
                }
            }
            List<Products> currentListProduct = pdao.getAllProduct();
            request.setAttribute("currentListProduct", currentListProduct);
            request.setAttribute("listCategory", listCategory);
            request.setAttribute("listSupplier", listSupplier);

            request.getRequestDispatcher("admin/dashboard_admin_manageproduct.jsp").forward(request, response);
        } 
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        VariantsDAO vdao = new VariantsDAO();
        ProductDAO pdao = new ProductDAO();

        if (action == null) {
            action = "dashboard";
        }

        if ("viewVariantColor".equals(action)) {
            int pID = Integer.parseInt(request.getParameter("pID"));

            String storage = request.getParameter("storage");
            if (storage == null) {
                request.getRequestDispatcher("public/homepage.jsp").forward(request, response);
                return;
            }
            String color = request.getParameter("color");
            if (color == null) {
                request.getRequestDispatcher("public/homepage.jsp").forward(request, response);
                return;
            }
            List<Variants> listVariants = vdao.getAllVariantByColor(pID, color);
            Variants variants = vdao.getVariant(pID, storage, color);
            if (listVariants.isEmpty()) {
                request.getRequestDispatcher("public/homepage.jsp").forward(request, response);
                return;
            }
            request.setAttribute("variants", variants);
            request.setAttribute("listVariants", listVariants);

            request.getRequestDispatcher("public/homepage.jsp").forward(request, response);

        } else if (action.equals("createProduct")) {
            String pName = request.getParameter("pName");
            int categoryID = Integer.parseInt(request.getParameter("category"));
            String brand = request.getParameter("brand");
            int warrantyPeriod = Integer.parseInt(request.getParameter("warrantyPeriod"));
            int supplierID = Integer.parseInt(request.getParameter("supplierID"));
            String os = request.getParameter("os");
            String cpu = request.getParameter("cpu");
            String gpu = request.getParameter("gpu");
            String ram = request.getParameter("ram");
            String batteryCapacityStr = request.getParameter("batteryCapacity");
            int batteryCapacity = 0;
            if (batteryCapacityStr != null && !batteryCapacityStr.isEmpty()) {
                batteryCapacity = Integer.parseInt(batteryCapacityStr);
            }

            String touchscreen = request.getParameter("touchscreen");

            boolean isNameProduct = pdao.isProductByName(pName);
            if (isNameProduct) {
                session.setAttribute("existName", pName + " already exists!");

                response.sendRedirect("product?action=createProduct");

            } else {
                pdao.createProduct(categoryID, supplierID, pName, brand, warrantyPeriod);

                int currentProductID = pdao.getCurrentProductID();
                pdao.createSpecification(currentProductID, os, cpu, gpu, ram, batteryCapacity, touchscreen);
                List<Variants> listVariants = vdao.getAllVariantByProductID(currentProductID);
                if (listVariants == null || listVariants.isEmpty()) {
                    response.sendRedirect("variants?action=createVariant&pID=" + currentProductID);
                    return;
                }

                response.sendRedirect("admin?action=manageProduct");
            }
        } else if (action.equals("updateProduct")) {
            int pID = Integer.parseInt(request.getParameter("pID"));
            String pName = request.getParameter("pName");
            int categoryID = Integer.parseInt(request.getParameter("category"));
            String brand = request.getParameter("brand");
            int warrantyPeriod = Integer.parseInt(request.getParameter("warrantyPeriod"));
            int supplierID = Integer.parseInt(request.getParameter("supplierID"));
            int specID = Integer.parseInt(request.getParameter("specID"));
            String os = request.getParameter("os");
            String cpu = request.getParameter("cpu");
            String gpu = request.getParameter("gpu");
            String ram = request.getParameter("ram");
            int batteryCapacity = Integer.parseInt(request.getParameter("batteryCapacity"));
            String touchscreen = request.getParameter("touchscreen");

            pdao.updateProduct(pID, categoryID, supplierID, pName, brand, warrantyPeriod);
            pdao.updateSpecification(specID, os, cpu, gpu, ram, batteryCapacity, touchscreen);

            response.sendRedirect("admin?action=manageProduct");
        } else if (action.equals("dashboard")) {
            response.sendRedirect("admin");

        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
