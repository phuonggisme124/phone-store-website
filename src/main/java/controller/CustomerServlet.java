package controller;

import dao.CustomerDAO;
import dao.CategoryDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.PaymentsDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Customer;
import model.Category;
import model.Order;
import model.OrderDetails;
import model.Payments;

/**
 * Servlet Controller dành riêng cho Khách hàng (Role 1).
 * Xử lý: Profile, Edit Profile, Change Password, Transaction (Orders), Installment.
 */
@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    // Load các danh mục chung cho Header/Footer (nếu cần)
    private void loadCommonData(HttpServletRequest request) {
        List<Category> listCategory = categoryDAO.getAllCategories();
        request.setAttribute("listCategory", listCategory);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "view";
        }

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");

        if (customer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        loadCommonData(request);

        switch (action) {
            // 1. Xem trang sửa hồ sơ
            case "edit":
                request.setAttribute("user", customer);
                request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
                break;

            // 2. Xem lịch sử giao dịch / Đơn hàng
            case "transaction":
                viewTransaction(request, response, customer);
                break;

            // 3. Xem trang trả góp
            case "payInstallment":
                viewInstallment(request, response, customer);
                break;

            // 4. Xem trang đổi mật khẩu
            case "changePassword":
                request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
                break;

            // Mặc định: Xem hồ sơ (Profile)
            default:
                request.setAttribute("user", customer);
                request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");

        if (customer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        loadCommonData(request);

        if ("update".equals(action)) {
            // Xử lý cập nhật thông tin cá nhân
            updateCustomerProfile(request, response, customer, session);

        } else if ("changePassword".equals(action)) {
            // Xử lý đổi mật khẩu
            updateCustomerPassword(request, response, customer, session);

        } else if ("cancelOrder".equals(action)) {
            // Hủy đơn hàng
            cancelOrder(request, response);

        } else if ("paidInstalment".equals(action)) {
            // Thanh toán trả góp (Giả lập)
            processInstallmentPayment(request, response);
        } else {
            response.sendRedirect("customer?action=view");
        }
    }

    // --- CÁC HÀM XỬ LÝ LOGIC CHI TIẾT ---
    private void viewTransaction(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        List<Order> oList;

        // Lấy danh sách đơn hàng theo trạng thái
        if (status == null || status.equalsIgnoreCase("All")) {
            oList = orderDAO.getOrdersByStatus(customer.getCustomerID(), "All");
        } else {
            oList = orderDAO.getOrdersByStatus(customer.getCustomerID(), status);
        }

        // Lấy chi tiết sản phẩm cho từng đơn hàng
        Map<Integer, List<OrderDetails>> allOrderDetails = new HashMap<>();
        if (oList != null) {
            for (Order o : oList) {
                List<OrderDetails> details = orderDetailDAO.getOrderDetailByOrderID(o.getOrderID());
                allOrderDetails.put(o.getOrderID(), details);
            }
        }

        request.setAttribute("oList", oList);
        request.setAttribute("allOrderDetails", allOrderDetails);
        request.getRequestDispatcher("customer/customer_transaction.jsp").forward(request, response);
    }

    private void viewInstallment(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        PaymentsDAO pmDAO = new PaymentsDAO();
        List<Order> oList = orderDAO.getInstalmentOrdersByUserId(customer.getCustomerID());

        Map<Integer, List<Payments>> allPayments = new HashMap<>();
        if (oList != null) {
            for (Order o : oList) {
                List<Payments> payments = pmDAO.getPaymentByOrderID(o.getOrderID());
                allPayments.put(o.getOrderID(), payments);
            }
        }

        request.setAttribute("oList", oList);
        request.setAttribute("allPayments", allPayments);
        request.getRequestDispatcher("customer/instalment.jsp").forward(request, response);
    }

    private void updateCustomerProfile(HttpServletRequest request, HttpServletResponse response, Customer customer, HttpSession session)
            throws ServletException, IOException {
        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String cccd = request.getParameter("cccd");
            String yobStr = request.getParameter("yob");

            // Validate sơ bộ
            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Họ tên không được để trống");
                request.setAttribute("user", customer);
                request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
                return;
            }

            // Xử lý Date (YOB)
            Date yob = null;
            if (yobStr != null && !yobStr.isEmpty()) {
                try {
                    yob = Date.valueOf(yobStr);
                } catch (IllegalArgumentException e) {
                    System.out.println("Invalid date format: " + yobStr);
                }
            }

            // Cập nhật dữ liệu mới trực tiếp vào object 'customer' đang giữ trong session
            customer.setFullName(fullName);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setAddress(address);
            customer.setCccd(cccd);
            customer.setYob(yob);

            // Gọi DAO update
            customerDAO.updateProfile(customer); // DAO đã được sửa để bỏ qua Password

            // Cập nhật lại session (đã được sửa)
            session.setAttribute("user", customer);

            request.setAttribute("message", "Cập nhật hồ sơ thành công!");
            request.setAttribute("user", customer);
            request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật!");
            request.setAttribute("user", customer);
            request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
        }
    }

    private void updateCustomerPassword(HttpServletRequest request, HttpServletResponse response, Customer customer, HttpSession session)
            throws ServletException, IOException {
        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu cũ
        if (!customerDAO.checkOldPassword(customer.getCustomerID(), oldPass)) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
            return;
        }

        // Kiểm tra trùng khớp mật khẩu mới
        if (newPass == null || newPass.isEmpty() || !newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không trùng khớp!");
            request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
            return;
        }

        // Tiến hành update
        customerDAO.updatePassword(customer.getCustomerID(), newPass);

        // Update mật khẩu (đã hash) trong session để đồng bộ
        customer.setPassword(customerDAO.md5(newPass));
        session.setAttribute("user", customer);

        request.setAttribute("message", "Đổi mật khẩu thành công!");
        request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            Order o = orderDAO.getOrderById(orderID);

            // Chỉ cho phép hủy nếu đơn hàng đang ở trạng thái 'Pending'
            if (o != null && ("Pending".equalsIgnoreCase(o.getStatus()))) {
                orderDAO.updateOrderStatus(orderID, "Cancelled");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        response.sendRedirect("customer?action=transaction");
    }

    private void processInstallmentPayment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String paymentIDStr = request.getParameter("paymentID");
            if (paymentIDStr != null) {
                int paymentID = Integer.parseInt(paymentIDStr);
                PaymentsDAO pmDAO = new PaymentsDAO();
                pmDAO.updatePaymentStatusToPaid(paymentID);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        response.sendRedirect("customer?action=payInstallment");
    }
}
