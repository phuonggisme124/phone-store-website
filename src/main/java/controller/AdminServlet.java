/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.PaymentsDAO;
import dao.ProductDAO;
import dao.ProfitDAO;
import dao.PromotionsDAO;
import dao.ReviewDAO;
import dao.SupplierDAO;
import dao.UsersDAO;
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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import model.Category;
import model.InterestRate;
import model.Order;
import model.OrderDetails;
import model.Payments;
import model.Products;
import model.Promotions;
import model.Review;
import model.Sale;
import model.Suppliers;
import model.Users;
import model.Variants;

/**
 *
 * @author duynu
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 15 // 15MB
)
public class AdminServlet extends HttpServlet {

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
            out.println("<title>Servlet AdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminServlet at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        UsersDAO udao = new UsersDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        ReviewDAO rdao = new ReviewDAO();
        OrderDAO odao = new OrderDAO();
        PaymentsDAO paydao = new PaymentsDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        ProfitDAO pfdao = new ProfitDAO();

        if (action == null) {
            action = "dashboard";
        }

        if (action.equals("manageUser")) {

            List<Users> listUsers = udao.getAllUsers();
            request.setAttribute("listUsers", listUsers);

            request.getRequestDispatcher("admin/dashboard_admin_manageuser.jsp").forward(request, response);

        } else if (action.equals("editAccount")) {

            int id = Integer.parseInt(request.getParameter("id"));
            Users user = udao.getUserByID(id);
            request.setAttribute("user", user);

            request.getRequestDispatcher("admin/admin_manageuser_edit.jsp").forward(request, response);
        } else if (action.equals("createAccount")) {
            request.getRequestDispatcher("admin/admin_manageuser_create.jsp").forward(request, response);
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

        } else if (action.equals("productDetail")) {

            int id = Integer.parseInt(request.getParameter("id"));
            List<Variants> listVariants = vdao.getAllVariantByProductID(id);
            List<Products> listProducts = pdao.getAllProduct();
            //Promotions promotion = pmtdao.getPromotionByProductID(id);

            request.setAttribute("productID", id);
            //request.setAttribute("promotion", promotion);
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listVariants", listVariants);

            request.getRequestDispatcher("admin/admin_manageproduct_detail.jsp").forward(request, response);
        } else if (action.equals("editProduct")) {
            int vid = Integer.parseInt(request.getParameter("vid"));
            int pid = Integer.parseInt(request.getParameter("pid"));

            Variants variant = vdao.getVariantByID(vid);
            Products product = pdao.getProductByID(pid);
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            request.setAttribute("variant", variant);
            request.setAttribute("product", product);
            request.setAttribute("listSupplier", listSupplier);

            request.getRequestDispatcher("admin/admin_manageproduct_edit.jsp").forward(request, response);
        }  else if (action.equals("createVariant")) {
            int pid = Integer.parseInt(request.getParameter("pid"));
            Products product = pdao.getProductByID(pid);

            request.setAttribute("product", product);
            request.setAttribute("productID", pid);
            request.getRequestDispatcher("admin/admin_manageproduct_createvariant.jsp").forward(request, response);
        } else if (action.equals("deleteProduct")) {
            int pid = Integer.parseInt(request.getParameter("pid"));
            vdao.deleteVariantByProductID(pid);
            pdao.deleteProductByProductID(pid);
            response.sendRedirect("admin/admin?action=manageProduct");

        } else if (action.equals("manageSupplier")) {
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            request.setAttribute("listSupplier", listSupplier);

            request.getRequestDispatcher("admin/dashboard_admin_managesupplier.jsp").forward(request, response);
        } else if (action.equals("editSupplier")) {
            int supplierID = Integer.parseInt(request.getParameter("id"));

            Suppliers supplier = sldao.getSupplierByID(supplierID);
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("admin/admin_managesupplier_edit.jsp").forward(request, response);
        } else if (action.equals("createSupplier")) {

            request.getRequestDispatcher("admin/admin_managesupplier_create.jsp").forward(request, response);

        } else if (action.equals("managePromotion")) {
            pmtdao.updateAllStatus();
            List<Products> listProducts = pdao.getAllProduct();
            List<Promotions> listPromotions = pmtdao.getAllPromotion();

            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listPromotions", listPromotions);

            request.getRequestDispatcher("admin/dashboard_admin_managepromotion.jsp").forward(request, response);
        } else if (action.equals("editPromotion")) {
            int pmtID = Integer.parseInt(request.getParameter("pmtID"));
            int pID = Integer.parseInt(request.getParameter("pID"));
            Promotions promotion = pmtdao.getPromotionByID(pmtID);
            Products product = pdao.getProductByID(pID);

            request.setAttribute("promotion", promotion);
            request.setAttribute("product", product);

            request.getRequestDispatcher("admin/admin_managepromotion_edit.jsp").forward(request, response);
        } else if (action.equals("createPromotion")) {
            List<Products> listProducts = pdao.getAllProduct();
            request.setAttribute("listProducts", listProducts);
            request.getRequestDispatcher("admin/admin_managepromotion_create.jsp").forward(request, response);

        } else if (action.equals("manageOrder")) {
            List<Order> listOrder = odao.getAllOrder();
            List<String> listPhone = odao.getAllPhone();
            List<Sale> listSales = udao.getAllSales();
            request.setAttribute("listOrder", listOrder);
            request.setAttribute("listPhone", listPhone);

            request.setAttribute("listSales", listSales);

            request.getRequestDispatcher("admin/dashboard_admin_manageorder.jsp").forward(request, response);
        } else if (action.equals("orderDetail")) {
            int oid = Integer.parseInt(request.getParameter("id"));
            byte isIntalment = Byte.parseByte(request.getParameter("isInstalment"));

            List<OrderDetails> listOrderDetails = odao.getAllOrderDetailByOrderID(oid);
            List<Payments> listPayments = paydao.getPaymentByOrderID(oid);
            List<InterestRate> listInterestRate = pdao.getAllInterestRate();
            request.setAttribute("listOrderDetails", listOrderDetails);
            request.setAttribute("listInterestRate", listInterestRate);
            request.setAttribute("listPayments", listPayments);
            request.setAttribute("isIntalment", isIntalment);
            request.getRequestDispatcher("admin/admin_manageorder_detail.jsp").forward(request, response);
        } else if (action.equals("manageReview")) {
            List<Review> listReview = rdao.getAllReview();
            request.setAttribute("listReview", listReview);
            request.getRequestDispatcher("admin/dashboard_admin_managereview.jsp").forward(request, response);
        } else if (action.equals("reviewDetail")) {
            int rID = Integer.parseInt(request.getParameter("rID"));

            Review review = rdao.getReviewByID(rID);

            request.setAttribute("review", review);
            request.getRequestDispatcher("admin/admin_managereview_detail.jsp").forward(request, response);
        } else if (action.equals("showInstalment")) {

            List<Order> listOrder = odao.getAllOrder();
            List<String> listPhone = odao.getAllPhoneInstalment();
            List<Sale> listSales = udao.getAllSales();
            request.setAttribute("listOrder", listOrder);
            request.setAttribute("listPhone", listPhone);

            request.setAttribute("listSales", listSales);
            request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
        } else if (action.equals("searchInstalment")) {
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            List<String> listPhone = odao.getAllPhoneInstalment();
            List<Order> listOrder;

            if (status.equals("Filter") || status.equals("All")) {
                listOrder = odao.getAllOrderInstalmentByPhone(phone);
            } else if (status.equals("Pending")) {
                List<Order> listInstalment = odao.getAllOrderInstalment();
                listOrder = odao.getAllPendingInstalment(listInstalment);
            } else {
                List<Order> listInstalment = odao.getAllOrderInstalment();
                listOrder = odao.getAllCompletedInstalment(listInstalment);
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
            List<String> listPhone = odao.getAllPhoneInstalment();
            List<Order> listOrder;

            if (phone == null || phone.isEmpty()) {
                if (status.equals("Pending")) {
                    List<Order> listInstalment = odao.getAllOrderInstalment();
                    listOrder = odao.getAllPendingInstalment(listInstalment);
                } else {
                    List<Order> listInstalment = odao.getAllOrderInstalment();
                    listOrder = odao.getAllCompletedInstalment(listInstalment);
                }
            } else {
                if (status.equals("Pending")) {
                    List<Order> listInstalment = odao.getAllOrderInstalment();
                    listOrder = odao.getAllPendingInstalmentAndPhone(listInstalment, phone);
                } else {
                    List<Order> listInstalment = odao.getAllOrderInstalment();
                    listOrder = odao.getAllCompletedInstalmentAndPhone(listInstalment, phone);
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
        } else if (action.equals("searchOrder")) {
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            List<String> listPhone = odao.getAllPhone();
            List<Order> listOrder;
            List<Sale> listSales = udao.getAllSales();
            if (status.equals("Filter") || status.equals("All")) {
                listOrder = odao.getAllOrderByPhone(phone);
            } else {
                listOrder = odao.getAllOrderByPhoneAndStatus(phone, status);
            }

            request.setAttribute("listOrder", listOrder);
            request.setAttribute("phone", phone);
            request.setAttribute("status", status);
            request.setAttribute("listPhone", listPhone);
            request.setAttribute("listSales", listSales);
            request.getRequestDispatcher("admin/dashboard_admin_manageorder.jsp").forward(request, response);
        } else if (action.equals("filterOrder")) {
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            List<String> listPhone = odao.getAllPhone();
            List<Order> listOrder;
            List<Sale> listSales = udao.getAllSales();

            if ((phone == null || phone.isEmpty()) && (status.equals("Filter") || status.equals("All"))) {
                listOrder = odao.getAllOrder();
            } else if (status.equals("Filter") || status.equals("All")) {
                listOrder = odao.getAllOrderByPhone(phone);
            } else if (!(status.equals("Filter") || status.equals("All"))) {
                listOrder = odao.getAllOrderByStatus(status);
            } else {
                listOrder = odao.getAllOrderByPhoneAndStatus(phone, status);
            }
            request.setAttribute("phone", phone);
            request.setAttribute("status", status);
            request.setAttribute("listOrder", listOrder);
            request.setAttribute("listPhone", listPhone);
            request.setAttribute("listSales", listSales);
            request.getRequestDispatcher("admin/dashboard_admin_manageorder.jsp").forward(request, response);
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
        } else if (action.equals("manageCategory")) {
            List<Category> listCategory = ctdao.getAllCategories();

            request.setAttribute("listCategory", listCategory);
            request.getRequestDispatcher("admin/dashboard_admin_managecategory.jsp").forward(request, response);

        } else if (action.equals("editCategory")) {
            int cateID = Integer.parseInt(request.getParameter("id"));

            Category catergory = ctdao.getCategoryByCategoryID(cateID);
            request.setAttribute("catergory", catergory);
            request.getRequestDispatcher("admin/admin_managecategory_edit.jsp").forward(request, response);
        } else if (action.equals("createCategory")) {
            request.getRequestDispatcher("admin/admin_managecategory_create.jsp").forward(request, response);
        } else if(action.equals("dashboard")){
            String monthSelectStr = request.getParameter("monthSelect");
            String yearSelectStr = request.getParameter("yearSelect");
            int yearSelect = Calendar.getInstance().get(Calendar.YEAR);
            int monthSelect = Calendar.getInstance().get(Calendar.MONTH);
            
            if(yearSelectStr != null){
                yearSelect = Integer.parseInt(yearSelectStr);
            }
            
            if(monthSelectStr != null){
                monthSelect = Integer.parseInt(monthSelectStr);
            }
            List<Users> listUser = udao.getAllUsers();
            List<Double> monthlyIncome = pfdao.getAllIncomeOfYear(yearSelect);
            List<Integer> monthlyOrder = pfdao.getAllOrderOfYear(yearSelect);
            System.out.println("tháng đang truy vấn: " + monthSelect);
            System.out.println("tháng gui về: " + monthSelectStr);
            int importOfMonth = pfdao.getImportByMonthAndYear(monthSelect, yearSelect);
            int soldOfMonth = pfdao.getSoldByMonthAndYear(monthSelect, yearSelect);
            double revenueTargetOfMonth = pfdao.getRevenueTargetByMonthAndYear(monthSelect, yearSelect);
            double revenueOfMonth = pfdao.getRevenueByMonthAndYear(monthSelect, yearSelect);
            double costOfMonth = pfdao.getCostByMonthAndYear(monthSelect, yearSelect);
            double incomeTargetOfMonth = revenueTargetOfMonth - costOfMonth;
            double incomeOfMonth = revenueOfMonth - costOfMonth;
            
            request.setAttribute("yearSelect", yearSelect);
            request.setAttribute("monthSelect", monthSelect);
            request.setAttribute("incomeOfMonth", incomeOfMonth);
            request.setAttribute("incomeTargetOfMonth", incomeTargetOfMonth);
            request.setAttribute("revenueTargetOfMonth", revenueTargetOfMonth);
            request.setAttribute("revenueOfMonth", revenueOfMonth);
            request.setAttribute("costOfMonth", costOfMonth);
            request.setAttribute("importOfMonth", importOfMonth);
            request.setAttribute("soldOfMonth", soldOfMonth);
            request.setAttribute("monthlyIncome", monthlyIncome);
            request.setAttribute("monthlyOrder", monthlyOrder);
            request.setAttribute("listUser", listUser);
            
            request.getRequestDispatcher("admin/dashboard_admin.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        UsersDAO udao = new UsersDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        ReviewDAO rdao = new ReviewDAO();
        if (action.equals("updateProduct")) {

        } else if (action.equals("createProduct")) {

        } else if (action.equals("createVariant")) {

        } else if (action.equals("createSupplier")) {

        } else if (action.equals("updateCategory")) {
            int cateID = Integer.parseInt(request.getParameter("cateID"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            ctdao.editCategory(cateID, name, description);
            response.sendRedirect("admin?action=manageCategory");

        } else if (action.equals("deleteCategory")) {
            int cateID = Integer.parseInt(request.getParameter("cateID"));
            System.out.println("delete cateID: " + cateID);
            ctdao.removeCategory(cateID);
            response.sendRedirect("admin?action=manageCategory");
        } else if (action.equals("createCategory")) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            ctdao.createCategory(name, description);
            response.sendRedirect("admin?action=manageCategory");
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
