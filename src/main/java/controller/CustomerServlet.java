package controller;

import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.*;
import model.*;

/**
 * Servlet Controller for Customer (Role 1) and Staff/Admin (Role 2,4)
 */
@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final StaffDAO staffDAO = new StaffDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
    private final PaymentsDAO paymentsDAO = new PaymentsDAO();

    // =====================================================
    // Load common data for Header/Footer
    private void loadCommonData(HttpServletRequest request) {
        request.setAttribute("listCategory", categoryDAO.getAllCategories());
    }

    // =====================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "view";
        }

        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");

        Customer customer = null;
        Staff staff = null;

        if (userObj instanceof Customer) {
            customer = (Customer) userObj;
        } else if (userObj instanceof Staff) {
            staff = (Staff) userObj;
        }

        if (customer == null && staff == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        loadCommonData(request);

        switch (action) {

            // ================= CUSTOMER =================
            case "view":
                if (customer != null) {
                    request.setAttribute("user", customer);
                    request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
                } else {
                    response.sendRedirect("customer?action=manageUser");
                }
                break;

            case "edit":
                // Staff/Admin edit user
                if (staff != null && (staff.getRole() == 2 || staff.getRole() == 4)) {
                    handleAdminEditUser(request, response);
                    return;
                }

                // Customer edit self
                if (customer != null) {
                    request.setAttribute("user", customer);
                    request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
                }
                break;

            case "transaction":
                if (customer != null) {
                    viewTransaction(request, response, customer);
                }
                break;

            case "payInstallment":
                if (customer != null) {
                    viewInstallment(request, response, customer);
                }
                break;

            case "changePassword":
                if (customer != null) {
                    request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
                }
                break;

            // ================= ADMIN / STAFF =================
            case "manageUser":
                if (staff != null && (staff.getRole() == 2 || staff.getRole() == 4)) {
                    int role = 2;
                    String roleStr = request.getParameter("role");
                    if (roleStr != null && !roleStr.isEmpty()) {
                        role = Integer.parseInt(roleStr);
                    }

                    request.setAttribute("listCustomers", customerDAO.getAllCustomers());
                    request.setAttribute("listStaff", staffDAO.getAllStaffs());
                    request.setAttribute("role", role);
                    request.getRequestDispatcher("admin/dashboard_admin_manageuser.jsp").forward(request, response);
                } else {
                    response.sendRedirect("home");
                }
                break;

            case "createAccount":
                if (staff != null && staff.getRole() == 4) {
                    request.getRequestDispatcher("admin/admin_manageuser_create.jsp").forward(request, response);
                }
                break;

            default:
                response.sendRedirect("customer?action=view");
        }
    }

    // =====================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");

        if (!(userObj instanceof Customer)) {
            response.sendRedirect("login.jsp");
            return;
        }

        Customer customer = (Customer) userObj;
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
        }
    }

    // =====================================================
    // ================= HELPER METHODS ====================
    private void handleAdminEditUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int role = Integer.parseInt(request.getParameter("role"));

            if (role == 1) {
                request.setAttribute("currentUser", customerDAO.getCustomerByID(id));
            } else {
                request.setAttribute("currentUser", staffDAO.getStaffByID(id));
            }
            request.getRequestDispatcher("admin/admin_manageuser_edit.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect("customer?action=manageUser");
        }
    }

    private void viewTransaction(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        if (status == null) {
            status = "All";
        }

        List<Order> oList = orderDAO.getOrdersByStatus(customer.getCustomerID(), status);
        Map<Integer, List<OrderDetails>> allDetails = new HashMap<>();

        for (Order o : oList) {
            allDetails.put(o.getOrderID(),
                    orderDetailDAO.getOrderDetailByOrderID(o.getOrderID()));
        }

        request.setAttribute("oList", oList);
        request.setAttribute("allOrderDetails", allDetails);
        request.getRequestDispatcher("customer/customer_transaction.jsp").forward(request, response);
    }

    private void viewInstallment(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {

        List<Order> oList = orderDAO.getInstalmentOrdersByUserId(customer.getCustomerID());
        Map<Integer, List<Payments>> allPayments = new HashMap<>();

        for (Order o : oList) {
            allPayments.put(o.getOrderID(),
                    paymentsDAO.getPaymentByOrderID(o.getOrderID()));
        }

        request.setAttribute("oList", oList);
        request.setAttribute("allPayments", allPayments);
        request.getRequestDispatcher("customer/instalment.jsp").forward(request, response);
    }

    private void updateCustomerProfile(HttpServletRequest request, HttpServletResponse response,
            Customer customer, HttpSession session)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Họ tên không được để trống");
            request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
            return;
        }

        customer.setFullName(fullName);
        customer.setEmail(request.getParameter("email"));
        customer.setPhone(request.getParameter("phone"));
        customer.setAddress(request.getParameter("address"));
        customer.setCccd(request.getParameter("cccd"));

        try {
            customer.setYob(Date.valueOf(request.getParameter("yob")));
        } catch (Exception ignored) {
        }

        customerDAO.updateProfile(customer);
        session.setAttribute("user", customer);

        request.setAttribute("message", "Cập nhật hồ sơ thành công!");
        request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
    }

    private void updateCustomerPassword(HttpServletRequest request, HttpServletResponse response,
            Customer customer, HttpSession session)
            throws ServletException, IOException {

        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        if (!customerDAO.checkOldPassword(customer.getCustomerID(), oldPass)) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
            return;
        }

        if (newPass == null || !newPass.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
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
        } catch (Exception ignored) {
        }

        response.sendRedirect("customer?action=transaction");
    }

    private void processInstallmentPayment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int paymentID = Integer.parseInt(request.getParameter("paymentID"));
            paymentsDAO.updatePaymentStatusToPaid(paymentID);
        } catch (Exception ignored) {
        }

        response.sendRedirect("customer?action=payInstallment");
    }
}
