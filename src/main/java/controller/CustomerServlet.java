package controller;

import dao.CustomerDAO;
import dao.CategoryDAO;
import dao.InstallmentDetailDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;

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
import model.InstallmentDetail;
import model.Order;
import model.OrderDetails;

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

    /* ================= COMMON DATA ================= */

    private void loadCommonData(HttpServletRequest request) {
        List<Category> listCategory = categoryDAO.getAllCategories();
        request.setAttribute("listCategory", listCategory);
    }

    /* ================= GET ================= */

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "view";
        }

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");

        if (customer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        loadCommonData(request);

        switch (action) {
            case "edit":
                request.setAttribute("user", customer);
                request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
                break;

            case "transaction":
                viewTransaction(request, response, customer);
                break;

            case "payInstallment":
                viewInstallment(request, response, customer);
                break;

            case "changePassword":
                request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
                break;

            default:
                request.setAttribute("user", customer);
                request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
                break;
        }
    }

    /* ================= POST ================= */

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

        switch (action) {
            case "update":
                updateCustomerProfile(request, response, customer, session);
                break;

            case "changePassword":
                updateCustomerPassword(request, response, customer, session);
                break;

            case "cancelOrder":
                cancelOrder(request, response);
                break;

            case "paidInstalment":
                processInstallmentPayment(request, response);
                break;

            default:
                response.sendRedirect("customer?action=view");
                break;
        }
    }

    /* ================= LOGIC ================= */

    private void viewTransaction(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        List<Order> oList;

        if (status == null || status.equalsIgnoreCase("All")) {
            oList = orderDAO.getOrdersByStatus(customer.getCustomerID(), "All");
        } else {
            oList = orderDAO.getOrdersByStatus(customer.getCustomerID(), status);
        }

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

        InstallmentDetailDAO installmentDAO = new InstallmentDetailDAO();
        List<Order> oList = orderDAO.getInstalmentOrdersByUserId(customer.getCustomerID());

        Map<Integer, List<InstallmentDetail>> allPayments = new HashMap<>();
        if (oList != null) {
            for (Order o : oList) {
                List<InstallmentDetail> payments = installmentDAO.getPaymentByOrderID(o.getOrderID());
                allPayments.put(o.getOrderID(), payments);
            }
        }

        request.setAttribute("oList", oList);
        request.setAttribute("allPayments", allPayments);
        request.getRequestDispatcher("customer/instalment.jsp").forward(request, response);
    }

    private void updateCustomerProfile(HttpServletRequest request, HttpServletResponse response,
                                       Customer customer, HttpSession session)
            throws ServletException, IOException {

        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String cccd = request.getParameter("cccd");
            String yobStr = request.getParameter("yob");

            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Họ tên không được để trống");
                request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
                return;
            }

            Date yob = null;
            if (yobStr != null && !yobStr.isEmpty()) {
                yob = Date.valueOf(yobStr);
            }

            customer.setFullName(fullName);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setAddress(address);
            customer.setCccd(cccd);
            customer.setYob(yob);

            customerDAO.updateProfile(customer);
            session.setAttribute("user", customer);

            request.setAttribute("message", "Cập nhật hồ sơ thành công!");
            request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật!");
            request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
        }
    }

    private void updateCustomerPassword(HttpServletRequest request, HttpServletResponse response,
                                        Customer customer, HttpSession session)
            throws ServletException, IOException {

        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        if (!customerDAO.checkOldPassword(customer.getCustomerID(), oldPass)) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
            return;
        }

        if (newPass == null || newPass.isEmpty() || !newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu mới không hợp lệ!");
            request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
            return;
        }

        customerDAO.updatePassword(customer.getCustomerID(), newPass);
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

            if (o != null && "Pending".equalsIgnoreCase(o.getStatus())) {
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
            int paymentID = Integer.parseInt(request.getParameter("paymentID"));
            InstallmentDetailDAO installmentDAO = new InstallmentDetailDAO();
            installmentDAO.updatePaymentStatusToPaid(paymentID);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("customer?action=payInstallment");
    }
}
