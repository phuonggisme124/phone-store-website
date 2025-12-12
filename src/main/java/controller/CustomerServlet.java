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
import model.Staff; // Import Staff model

/**
 * Servlet Controller for Customer (Role 1) and Staff/Admin managing Customers.
 */
@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    // Load common data for Header/Footer
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

        // Check login and determine user type
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
            // 1. Customer: View/Edit Profile
            case "edit":
                //  ADMIN/STAFF SỬA KHÁCH HÀNG
                if (staff != null && (staff.getRole() == 2 || staff.getRole() == 4)) {
                    String idStr = request.getParameter("id");
                    if (idStr != null && !idStr.isEmpty()) {
                        try {
                            int customerID = Integer.parseInt(idStr);
                         
                            Customer targetUser = customerDAO.getCustomerById(customerID);
               
                            request.getRequestDispatcher("admin/admin_manageuser_edit.jsp").forward(request, response);
                            return;
                        } catch (NumberFormatException e) {
                            System.out.println("ID không hợp lệ: " + idStr);
                        }
                    }
                }

                //  KHÁCH HÀNG TỰ SỬA HỒ SƠ
                if (customer != null) {
                   
                    request.setAttribute("user", customer);
                    request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
                } else {
                   
                    response.sendRedirect("login.jsp");
                }
                break;

            // 2. Customer: Transaction History
            case "transaction":
                if (customer != null) {
                    viewTransaction(request, response, customer);
                } else {
                    response.sendRedirect("login.jsp");
                }
                break;

            // 3. Customer: Installment
            case "payInstallment":
                if (customer != null) {
                    viewInstallment(request, response, customer);
                } else {
                    response.sendRedirect("login.jsp");
                }
                break;

            // 4. Customer: Change Password
            case "changePassword":
                if (customer != null) {
                    request.getRequestDispatcher("customer/changePassword.jsp").forward(request, response);
                } else {
                    response.sendRedirect("login.jsp");
                }
                break;

            // 5. Admin/Staff: Manage Users
            case "manageUser":
                // Only allow Staff/Admin to access this
                if (staff != null && (staff.getRole() == 2 || staff.getRole() == 4)) {
                    List<Customer> listUsers = customerDAO.getAllCustomers();
                    request.setAttribute("listUsers", listUsers);
                    // Ensure the path to the JSP is correct based on your project structure
                    request.getRequestDispatcher("admin/dashboard_admin_manageuser.jsp").forward(request, response);
                } else {
                    // If a customer tries to access manageUser, redirect them home or show error
                    response.sendRedirect("home");
                }
                break;
            case "createAccount":
                // Use 'staff' variable here, and check if role is 4 (Admin)
                if (staff != null && staff.getRole() == 4) {
                    request.getRequestDispatcher("admin/admin_manageuser_create.jsp").forward(request, response);
                } else {
                    // If not admin, redirect or show error
                    response.sendRedirect("login.jsp");
                }
                break;

            // Default: View Profile (Customer only)
            default:
                if (customer != null) {
                    request.setAttribute("user", customer);
                    request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
                } else if (staff != null) {
                    // If staff hits /customer with no action, redirect to manageUser
                    response.sendRedirect("customer?action=manageUser");
                } else {
                    response.sendRedirect("login.jsp");
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");

        Customer customer = null;
        if (userObj instanceof Customer) {
            customer = (Customer) userObj;
        }

        // Most POST actions here seem to be for the Customer. 
        if (customer == null) {
            // You might want to handle Staff POST actions here if needed
            response.sendRedirect("login.jsp");
            return;
        }

        loadCommonData(request);

        if ("update".equals(action)) {
            updateCustomerProfile(request, response, customer, session);

        } else if ("changePassword".equals(action)) {
            updateCustomerPassword(request, response, customer, session);

        } else if ("cancelOrder".equals(action)) {
            cancelOrder(request, response);

        } else if ("paidInstalment".equals(action)) {
            processInstallmentPayment(request, response);
        } else {
            response.sendRedirect("customer?action=view");
        }
    }

    // --- LOGIC HELPER METHODS ---
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

            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Họ tên không được để trống");
                request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
                return;
            }

            Date yob = null;
            if (yobStr != null && !yobStr.isEmpty()) {
                try {
                    yob = Date.valueOf(yobStr);
                } catch (IllegalArgumentException e) {
                    System.out.println("Invalid date format: " + yobStr);
                }
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

    private void updateCustomerPassword(HttpServletRequest request, HttpServletResponse response, Customer customer, HttpSession session)
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
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không trùng khớp!");
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
