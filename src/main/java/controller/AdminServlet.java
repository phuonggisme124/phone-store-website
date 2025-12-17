/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import dao.CategoryDAO;
import dao.ImportDAO;
import dao.OrderDAO;

import dao.ProductDAO;
import dao.ProfitDAO;
import dao.PromotionsDAO;
import dao.ReviewDAO;
import dao.SupplierDAO;
import dao.CustomerDAO;
import dao.InstallmentDetailDAO;
import dao.VariantsDAO;
import dao.VouchersDAO;
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
import model.Import;
import model.ImportDetail;
import model.InterestRate;
import model.Order;
import model.OrderDetails;

import model.Products;
import model.Profit;
import model.Promotions;
import model.Review;
import model.Sale;
import model.Suppliers;
import model.Customer;
import model.Variants;
import model.Vouchers;

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
        CustomerDAO udao = new CustomerDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        ReviewDAO rdao = new ReviewDAO();
        OrderDAO odao = new OrderDAO();
        InstallmentDetailDAO paydao = new InstallmentDetailDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        ProfitDAO pfdao = new ProfitDAO();
        HttpSession session = request.getSession();
        ImportDAO imdao = new ImportDAO();
        VouchersDAO vouDAO = new VouchersDAO();

        System.out.println("DEBUG: Action nhận được = " + action);
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
            List<Customer> listUser = udao.getAllCustomers() ;
            List<Double> monthlyIncome = pfdao.getAllIncomeOfYear(yearSelect);
            List<Integer> monthlyOrder = pfdao.getAllOrderOfYear(yearSelect);
            int importOfMonth = pfdao.getImportByMonthAndYear(monthSelect, yearSelect);
            System.out.println("so san pham nhap: "+ importOfMonth);
            int soldOfMonth = pfdao.getSoldByMonthAndYear(monthSelect, yearSelect);
            System.out.println("so san pham ban: "+ soldOfMonth);
            double revenueTargetOfMonth = pfdao.getRevenueTargetByMonthAndYear(monthSelect, yearSelect);
            System.out.println("Tong doanh thu du kien: " + revenueTargetOfMonth);
            double revenueOfMonth = pfdao.getRevenueByMonthAndYear(monthSelect, yearSelect);
            System.out.println("Tong doanh thu thuc te: "+ revenueOfMonth);
            double costOfMonth = pfdao.getCostByMonthAndYear(monthSelect, yearSelect);
            System.out.println("Tong gia nhap hang: " + costOfMonth);
            double incomeTargetOfMonth = revenueTargetOfMonth - costOfMonth;
            System.out.println("tien loi du kien: "+ incomeTargetOfMonth);
            double incomeOfMonth = revenueOfMonth - costOfMonth;
            System.out.println("tien loi thuc te: " + incomeOfMonth);
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
            ImportDAO dao = new ImportDAO();
            List<Import> list = dao.getAllImports();
            request.setAttribute("listImports", list);
            // Chuyển sang trang JSP lịch sử
            request.getRequestDispatcher("admin/admin_import_history.jsp").forward(request, response);
        }  else if (action.equals("viewDetail")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));

                ImportDAO dao = new ImportDAO();
                // 1. Lấy danh sách sản phẩm trong phiếu đó
                List<ImportDetail> listDetails = dao.getDetailsByImportID(id);

                // 2. Gửi sang trang JSP chi tiết
                request.setAttribute("listDetails", listDetails);
                request.setAttribute("importID", id); // Gửi ID để hiện lên tiêu đề cho đẹp

                request.getRequestDispatcher("admin/admin_import_detail.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (action.equals("approve")) {
            try {
                String idRaw = request.getParameter("id");
                if (idRaw == null) {
                    throw new Exception("ID null");
                }
                int id = Integer.parseInt(idRaw);

                boolean result = imdao.approveImport(id); // Gọi hàm duyệt + cộng kho

                if (result) {
                    session.setAttribute("MESS", "Duyệt đơn thành công! Kho đã cập nhật.");
                } else {
                    session.setAttribute("ERROR", "Lỗi khi duyệt đơn (Kiểm tra Log).");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR", "Lỗi hệ thống: " + e.getMessage());
            }
            // Quay lại trang danh sách của ADMIN (Load lại dữ liệu mới nhất)
            response.sendRedirect("admin?action=importproduct");
        } // 2.4 Từ chối đơn (Reject)
        else if (action.equals("reject")) {
            try {
                String idRaw = request.getParameter("id");
                if (idRaw == null) {
                    throw new Exception("ID null");
                }
                int id = Integer.parseInt(idRaw);

                imdao.cancelImport(id); // Gọi hàm hủy (Status = 2)
                session.setAttribute("MESS", "Đã TỪ CHỐI phiếu nhập #" + id);
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("ERROR", "Lỗi khi từ chối: " + e.getMessage());
            }
            // Quay lại trang danh sách của ADMIN
            response.sendRedirect("admin?action=importproduct");
        } if (action.equals("viewVoucher")) {
            List<Vouchers> list = vouDAO.getAllVouchers();
            request.setAttribute("listVouchers", list);
            request.getRequestDispatcher("admin/admin_manageVoucher_view.jsp").forward(request, response);
        }  else if (action.equals("createVoucher")) {
            CustomerDAO cdao = new CustomerDAO();
            List<Customer> listCustomer = cdao.getAllCustomers();
            request.setAttribute("listCustomers", listCustomer);
            request.getRequestDispatcher("admin/admin_manageVoucher_create.jsp").forward(request, response);
        } else if (action.equals("updateVoucher")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Vouchers v = vouDAO.getVoucherByID(id);
            request.setAttribute("voucher", v);
            request.getRequestDispatcher("admin/admin_manageVoucher_edit.jsp").forward(request, response);
        } else if (action.equals("deleteVoucher")) {
            int id = Integer.parseInt(request.getParameter("id"));
            vouDAO.deleteVoucher(id);
            response.sendRedirect("admin?action=viewVoucher");
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
        CustomerDAO udao = new CustomerDAO();
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





