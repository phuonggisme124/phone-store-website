/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.VouchersDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import model.Staff;
import model.Vouchers;

/**
 *
 * @author USER
 */
@WebServlet(name = "VoucherServlet", urlPatterns = {"/voucher"})
public class VoucherServlet extends HttpServlet {

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
            out.println("<title>Servlet VoucherServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VoucherServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "viewVoucher";
        }

        VouchersDAO dao = new VouchersDAO();
        if (action.equals("viewVoucher")) {
            List<Vouchers> list = dao.getAllVouchers();
            request.setAttribute("listVouchers", list);
            request.getRequestDispatcher("staff/staff_manageVoucher_view.jsp").forward(request, response);
        } else if (action.equals("createVoucher")) {
            CustomerDAO cdao = new CustomerDAO();
            List<Customer> listCustomer = cdao.getAllCustomers();
            request.setAttribute("listCustomers", listCustomer);
            request.getRequestDispatcher("staff/staff_manageVoucher_create.jsp").forward(request, response);
        } else if (action.equals("updateVoucher")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Vouchers v = dao.getVoucherByID(id);
            request.setAttribute("voucher", v);
            request.getRequestDispatcher("staff/staff_manageVoucher_edit.jsp").forward(request, response);
        } else if (action.equals("deleteVoucher")) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteVoucher(id);
            response.sendRedirect("voucher?action=viewVoucher");
        }
        if (action != null && action.equals("saveVoucher")) {
            Customer u = (Customer) session.getAttribute("user");

            // 1. Kiểm tra đăng nhập
            if (u == null) {
                // Chưa đăng nhập -> Chuyển sang login
                response.sendRedirect("login.jsp");
                return;
            }

            try {
                int voucherID = Integer.parseInt(request.getParameter("id"));

                // 2. Gọi hàm lưu vào bảng VoucherCustomers (đã viết ở bước trước)
                // Hàm này sẽ trả về false nếu đã lưu rồi
                boolean success = dao.saveVoucherForCustomer(voucherID, u.getCustomerID());

                if (success) {
                    session.setAttribute("msg", "Lưu voucher thành công! Bạn có thể dùng khi thanh toán.");
                } else {
                    session.setAttribute("error", "Bạn đã lưu voucher này rồi!");
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            // 3. Quay lại trang cũ (Trang chủ hoặc trang danh sách voucher)
            String referer = request.getHeader("Referer"); // Lấy link trang vừa bấm
            response.sendRedirect(referer != null ? referer : "homepage");
        } // Trong VoucherServlet.java
        else if (action.equals("viewMyVouchers")) {

            Customer user = (Customer) session.getAttribute("user");

            if (user != null) {
                VouchersDAO vDAO = new VouchersDAO();

                // 1. Lấy TẤT CẢ voucher đang hoạt động (để khách săn)
                List<Vouchers> allVouchers = vDAO.getAllVouchers(); // Hàm này bạn đã có

                // 2. Lấy danh sách ID các voucher mà khách ĐÃ lưu
                List<Vouchers> listAll = vDAO.getAvailableVouchers();

                // 2. Lấy danh sách các ID mà khách NÀY đã lưu
                // Dùng hàm getSavedVoucherIDsByCustomer() trong DAO của bạn
                List<Integer> savedIds = vDAO.getSavedVoucherIDsByCustomer(user.getCustomerID());

                // Xử lý null để tránh lỗi JSP
                if (savedIds == null) {
                    savedIds = new ArrayList<>();
                }

                // 3. Gửi sang JSP (Tên attribute phải khớp với JSP)
                request.setAttribute("listAllVouchers", listAll);
                request.setAttribute("mySavedIds", savedIds);

                request.getRequestDispatcher("public/customer_view_voucher.jsp").forward(request, response);
                return;
            } else {
                response.sendRedirect("login.jsp");
            }
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
        Staff user = (Staff) request.getSession().getAttribute("user");
        VouchersDAO dao = new VouchersDAO();

        String code = request.getParameter("code");
        int percent = Integer.parseInt(request.getParameter("percentDiscount"));
        Date start = Date.valueOf(request.getParameter("startDay"));
        Date end = Date.valueOf(request.getParameter("endDay"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String status = request.getParameter("status");

        if (action.equals("createVoucher")) {

            // 1. Chuẩn bị dữ liệu để so sánh ngày
            long millis = System.currentTimeMillis();
            // Dùng java.time.LocalDate để lấy đúng ngày hôm nay (00:00:00)
            java.sql.Date today = java.sql.Date.valueOf(java.time.LocalDate.now());
            String errorMsg = null;

            // 2. CHUỖI KIỂM TRA LOGIC (Validate)
            // Bước A: Kiểm tra trùng tên trước
            if (dao.checkVoucherCodeExist(code)) {
                errorMsg = "Mã Voucher '" + code + "' đã tồn tại!";
            } // Bước B: Kiểm tra ngày bắt đầu phải >= hôm nay
            else if (start.before(today)) {
                errorMsg = "Ngày bắt đầu không được nhỏ hơn ngày hiện tại!";
            } // Bước C: Kiểm tra ngày kết thúc phải > ngày bắt đầu
            else if (end.before(start)) {
                errorMsg = "Ngày kết thúc không được nhỏ hơn ngày bắt đầu!";
            }

            // 3. XỬ LÝ KẾT QUẢ
            if (errorMsg != null) {
                // === TRƯỜNG HỢP CÓ LỖI ===
                request.setAttribute("error", errorMsg);

                // Giữ lại dữ liệu cũ để form không bị trắng xóa
                request.setAttribute("code", code);
                request.setAttribute("percentDiscount", percent);
                request.setAttribute("startDay", start);
                request.setAttribute("endDay", end);
                request.setAttribute("quantity", quantity);
                // Lưu ý: attribute "status" nếu cần cũng set lại luôn

                // Điều hướng lại trang nhập liệu
                if (user.getRole() == 2) {
                    request.getRequestDispatcher("staff/staff_manageVoucher_create.jsp").forward(request, response);
                } else if (user.getRole() == 4) {
                    request.getRequestDispatcher("admin/admin_manageVoucher_create.jsp").forward(request, response);
                }
                return; // Dừng code tại đây, KHÔNG chạy xuống dưới nữa
            }

            // === TRƯỜNG HỢP THÀNH CÔNG (Không có lỗi) ===
            Vouchers v = new Vouchers(0, code, percent, start, end, quantity, status);
            dao.createVoucher(v);

        } else if (action.equals("updateVoucher")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Vouchers v = new Vouchers(id, code, percent, start, end, quantity, status);
            dao.updateVoucher(v);
        }
        if (user.getRole() == 4) {
            response.sendRedirect("admin?action=viewVoucher");
        } else if (user.getRole() == 2) {
            response.sendRedirect("voucher?action=viewVoucher");
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
