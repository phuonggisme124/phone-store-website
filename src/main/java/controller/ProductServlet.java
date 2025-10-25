/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
import dao.PromotionsDAO;
import dao.ReviewDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Products;
import model.Promotions;
import model.Review;
import model.Variants;

/**
 *
 * @author duynu
 */
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

            // Lấy danh sách review theo VariantID
            List<Review> listReview = new ArrayList<>();
            try {
                listReview = rdao.getReviewsByVariantID(variants.getVariantID());
            } catch (SQLException e) {
                e.printStackTrace();
            }

            double rating = rdao.getTotalRating(listVariantRating, listReview);

            // Pass data to JSP
            request.setAttribute("categoryID", cID);
            if (vID != null) {
                request.setAttribute("vID", vID);
            }
            request.setAttribute("rating", rating);
            request.setAttribute("productID", productID);
            request.setAttribute("listStorage", listStorage);
            request.setAttribute("listVariants", listVariants);
            request.setAttribute("variants", variants);
            request.setAttribute("listCategory", listCategory);
            request.setAttribute("listVariantRating", listVariantRating);
            request.setAttribute("listReview", listReview);
            request.setAttribute("product", p);

            // Forward to product detail page
            request.getRequestDispatcher("productdetail.jsp").forward(request, response);

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

            List<Review> listReview = rdao.getReview();
            double rating = rdao.getTotalRating(listVariantRating, listReview);

            // Send data to JSP
            request.setAttribute("productID", pID);
            request.setAttribute("rating", rating);
            request.setAttribute("categoryID", cID);
            request.setAttribute("variants", variants);
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listVariants", listVariants);
            request.setAttribute("listVariantRating", listVariantRating);
            request.setAttribute("listReview", listReview);
            request.setAttribute("listStorage", listStorage);
            request.setAttribute("listCategory", listCategory);

            // Forward to product detail page
            request.getRequestDispatcher("productdetail.jsp").forward(request, response);

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

            // Set attributes for category page
            request.setAttribute("listVariant", listVariant);
            request.setAttribute("categoryID", cID);
            request.setAttribute("listProduct", listProduct);
            request.setAttribute("listReview", listReview);

            // Forward to category JSP
            request.getRequestDispatcher("view_product_by_category.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        VariantsDAO vdao = new VariantsDAO();
        if ("viewVariantColor".equals(action)) {
            int pID = Integer.parseInt(request.getParameter("pID"));

            String storage = request.getParameter("storage");
            if (storage == null) {
                request.getRequestDispatcher("homepage.jsp").forward(request, response);
                return;
            }
            String color = request.getParameter("color");
            if (color == null) {
                request.getRequestDispatcher("homepage.jsp").forward(request, response);
                return;
            }
            List<Variants> listVariants = vdao.getAllVariantByColor(pID, color);
            Variants variants = vdao.getVariant(pID, storage, color);
            if (listVariants.isEmpty()) {
                request.getRequestDispatcher("homepage.jsp").forward(request, response);
                return;
            }
            request.setAttribute("variants", variants);
            request.setAttribute("listVariants", listVariants);
            request.getRequestDispatcher("homepage.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
