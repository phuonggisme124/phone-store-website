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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.Products;
import model.Profit;
import model.Promotions;
import model.Review;
import model.Specification;
import model.Suppliers;
import model.Variants;

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

        HttpSession session = request.getSession();
        model.Users currentUser = (model.Users) session.getAttribute("user");

        // mặt định manageProduct
        if (action == null) {
            action = "manageProduct";
        }

        // check role
        if (action.equals("manageProduct") || action.equals("productDetail")
                || action.equals("updateProduct") || action.equals("deleteProduct")
                || action.equals("createProduct")) {
            if (currentUser == null || (currentUser.getRole() != 2 && currentUser.getRole() != 4)) {
                response.sendRedirect("login");
                return;
            }
        }

        // public
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
                variants = vdao.getVariant(
                        productID,
                        listVariants.get(0).getStorage(),
                        listVariants.get(0).getColor()
                );
            }

            List<Variants> listVariantRating = vdao.getAllVariantByStorage(variants.getProductID(), variants.getStorage());
            Specification specification = pdao.getSpecificationByProductID(productID);
            List<Review> listReview = rdao.getAllReviewByListVariant(listVariantRating);
            double rating = rdao.getTotalRating(listVariantRating, listReview);

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

            request.getRequestDispatcher("public/productdetail.jsp").forward(request, response);
        } else if ("selectStorage".equals(action)) {
            int pID = Integer.parseInt(request.getParameter("pID"));

            String storage = request.getParameter("storage");
            String color = request.getParameter("color");

            Variants variants;
            List<Products> listProducts = pdao.getAllProduct();
            List<Variants> listVariants = vdao.getAllVariantByProductID(pID);
            List<Variants> listVariantRating = vdao.getAllVariantByStorage(pID, storage);
            List<String> listStorage = vdao.getAllStorage(pID);
            List<Category> listCategory = pdao.getAllCategory();

            variants = vdao.getVariant(pID, storage, color);
            if (variants == null && !listVariantRating.isEmpty()) {
                variants = vdao.getVariant(pID, storage, listVariantRating.get(0).getColor());
            }

            List<Review> listReview = rdao.getAllReviewByListVariant(listVariantRating);
            double rating = rdao.getTotalRating(listVariantRating, listReview);
            Specification specification = pdao.getSpecificationByProductID(pID);

            request.setAttribute("productID", pID);
            request.setAttribute("rating", rating);
            request.setAttribute("variants", variants);
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listVariants", listVariants);
            request.setAttribute("listVariantRating", listVariantRating);
            request.setAttribute("listReview", listReview);
            request.setAttribute("specification", specification);
            request.setAttribute("listStorage", listStorage);
            request.setAttribute("listCategory", listCategory);

            request.getRequestDispatcher("public/productdetail.jsp").forward(request, response);
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

            List<Products> productList1_search = pdao.getAllProduct();
            List<Variants> variantsList_search = new ArrayList<>();
            try {
                variantsList_search = vdao.getAllVariants();
            } catch (SQLException ex) {
                Logger.getLogger(ProductServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            request.setAttribute("productList1", productList1_search);
            request.setAttribute("variantsList", variantsList_search);
            request.setAttribute("listVariant", listVariant);
            request.setAttribute("categoryID", cID);
            request.setAttribute("listProduct", listProduct);
            request.setAttribute("listReview", listReview);

            request.getRequestDispatcher("public/view_product_by_category.jsp").forward(request, response);
        } else if (action.equals("productDetail")) {
            try {
                List<Products> listProducts = pdao.getAllProduct();
                List<Variants> listVariants;

                // check roel 2,4
                if (currentUser.getRole() == 2) {
                    // staff
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

                } else if (currentUser.getRole() == 4) {
                    // admin
                    int pID = Integer.parseInt(request.getParameter("pID"));
                    listVariants = vdao.getAllVariantByProductID(pID);

                    if (listVariants == null || listVariants.isEmpty()) {
                        response.sendRedirect("product?action=manageProduct");
                        return;
                    }

                    request.setAttribute("pID", pID);
                    request.setAttribute("listProducts", listProducts);
                    request.setAttribute("listVariants", listVariants);

                    request.getRequestDispatcher("admin/admin_manageproduct_detail.jsp").forward(request, response);
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }
        } else if (action.equals("updateProduct")) {
            if (currentUser.getRole() != 4) {
                response.sendRedirect("product?action=manageProduct");
                return;
            }

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
            if (currentUser.getRole() != 4) {
                response.sendRedirect("product?action=manageProduct");
                return;
            }

            int pID = Integer.parseInt(request.getParameter("pID"));

            List<Variants> listVariant = vdao.getVariantByProductID(pID);
            for (Variants v : listVariant) {
                pfdao.deleteProfitByVariantID(v.getVariantID());
            }
            vdao.deleteVariantByProductID(pID);

            pdao.deleteSpecificationByProductID(pID);
            pmtdao.deletePromotionByProductID(pID);
            pdao.deleteProductByProductID(pID);

            response.sendRedirect("product?action=manageProduct");

        } else if (action.equals("createProduct")) {
            if (currentUser.getRole() != 4) {
                response.sendRedirect("product?action=manageProduct");
                return;
            }
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

            // check role 2,4
            if (currentUser.getRole() == 2) {
                // staff
                String productName = request.getParameter("productName");
                String supplierIDStr = request.getParameter("supplierID");
                Integer supplierID = null;

                if (supplierIDStr != null && !supplierIDStr.equalsIgnoreCase("All")) {
                    try {
                        supplierID = Integer.parseInt(supplierIDStr);
                    } catch (NumberFormatException e) {
                        supplierID = null;
                    }
                }

                List<Products> filteredProducts;
                if (productName != null && !productName.trim().isEmpty() && supplierID != null) {
                    filteredProducts = pdao.getProductsByNameAndSupplier(productName.trim(), supplierID);
                } else if (productName != null && !productName.trim().isEmpty()) {
                    filteredProducts = pdao.getProductsByName(productName.trim());
                } else if (supplierID != null) {
                    filteredProducts = pdao.getProductsBySupplier(supplierID);
                } else {
                    filteredProducts = currentListProduct;
                }

                request.setAttribute("listProducts", filteredProducts);
                request.getRequestDispatcher("staff/dashboard_staff_manageproduct.jsp").forward(request, response);

            } else if (currentUser.getRole() == 4) {
                // admin
                request.getRequestDispatcher("admin/dashboard_admin_manageproduct.jsp").forward(request, response);
            }
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        VariantsDAO vdao = new VariantsDAO();
        ProductDAO pdao = new ProductDAO();
        ProfitDAO pfdao = new ProfitDAO();

        if (action == null) {
            action = "dashboard";
        }

        model.Users currentUser = (model.Users) session.getAttribute("user");
        if (action.equals("createProduct") || action.equals("updateProduct")) {
            if (currentUser == null || currentUser.getRole() != 4) {
                response.sendRedirect("login");
                return;
            }
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

                response.sendRedirect("product?action=manageProduct");
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

            response.sendRedirect("product?action=manageProduct");
        } else if (action.equals("dashboard")) {
            response.sendRedirect("admin");
        } else if (action.equals("importproduct")) {
            List<Profit> listImports = pfdao.getAllProfit();
            request.setAttribute("listImports", listImports);
            request.getRequestDispatcher("admin/import_history.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "ProductServlet - Staff can view/search, Admin can CRUD";
    }
}
