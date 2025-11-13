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
import model.Profit;
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

        if (action.equals("manageProduct")) {

        } else if (action.equals("dashboard")) {
            String monthSelectStr = request.getParameter("monthSelect");
            String yearSelectStr = request.getParameter("yearSelect");
            int yearSelect = Calendar.getInstance().get(Calendar.YEAR);
            int monthSelect = Calendar.getInstance().get(Calendar.MONTH) + 1;

            if (yearSelectStr != null) {
                yearSelect = Integer.parseInt(yearSelectStr);
            }

            if (monthSelectStr != null) {
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
        } else if (action.equals("importproduct")) {
            // ACTION 1: HIỂN THỊ DANH SÁCH LỊCH SỬ NHẬP KHO (Giống Manage Product)          
            List<Profit> listImports = pfdao.getAllProfit();
            request.setAttribute("listImports", listImports);
            request.getRequestDispatcher("admin/import_history.jsp").forward(request, response);
        } else if (action.equals("showImportForm")) {
            List<Products> listProducts = pdao.getAllProduct();
            request.setAttribute("listProducts", listProducts);
            request.getRequestDispatcher("admin/importProduct.jsp").forward(request, response);
        } // Thêm đoạn này vào doGet của AdminServlet
        else if (action.equals("showCreateProduct")) {
            List<Category> listCategory = ctdao.getAllCategories();
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            // 2. Gửi dữ liệu sang JSP
            request.setAttribute("listCategories", listCategory);
            request.setAttribute("listSupplier", listSupplier);
            // 3. Chuyển hướng đến trang tạo mới
            request.getRequestDispatcher("admin/admin_manageproduct_create.jsp").forward(request, response);
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
