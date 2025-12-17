package controller;

import dao.CustomerDAO;
import dao.CategoryDAO;
import dao.InstallmentDetailDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;

import dao.StaffDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Customer;
import model.Category;
import model.InstallmentDetail;
import model.Order;
import model.OrderDetails;
import model.Staff; // Import Staff model

/**
 * Servlet Controller for Customer (Role 1) and Staff/Admin managing Customers.
 */
@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final StaffDAO staffDAO = new StaffDAO();
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
                    InstallmentDetailDAO iDAO = new InstallmentDetailDAO();
                    List<InstallmentDetail> iDList = iDAO.getInstallmentNearToPay();
                    for (InstallmentDetail iD : iDList) {
                        if (iD.getExpriedDay() > 0) {
                            iDAO.updateExpiredDateByOrderID(iD.getInstallmentDetailID(), iD.getExpriedDay());
                        }
                    }
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

        // 1. QUAN TRỌNG: Thêm 2 dòng này đầu tiên để nhận dữ liệu Tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        StaffDAO sdao = new StaffDAO();
        CustomerDAO cdao = new CustomerDAO();

        // Lấy action từ form
        String action = request.getParameter("action");

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

        // 2. SỬA LỖI Ở ĐÂY: Đổi "update" thành "updateProfile" cho khớp với JSP
        if ("updateProfile".equals(action)) {
            updateCustomerProfile(request, response, customer, session);

        } else if ("changePassword".equals(action)) {
            updateCustomerPassword(request, response, customer, session);

        } else if ("cancelOrder".equals(action)) {
            cancelOrder(request, response);

        } else if ("paidInstalment".equals(action)) {
            processInstallmentPayment(request, response);
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
        InstallmentDetailDAO pmDAO = new InstallmentDetailDAO();
        List<Order> oList = orderDAO.getInstalmentOrdersByUserId(customer.getCustomerID());

        Map<Integer, List<InstallmentDetail>> allPayments = new HashMap<>();
        if (oList != null) {
            for (Order o : oList) {
                List<InstallmentDetail> payments = pmDAO.getPaymentByOrderID(o.getOrderID());
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

            String redirectTarget = request.getParameter("redirect");

            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Họ tên không được để trống");
                request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
                return;
            }

            Date yob = null;
            if (yobStr != null && !yobStr.isEmpty()) {
                try {
                    yob = Date.valueOf(yobStr); // Yêu cầu format từ input date là yyyy-MM-dd
                } catch (IllegalArgumentException e) {
                    System.out.println("Lỗi định dạng ngày tháng: " + yobStr);
                }
            }

            // 4. Set thông tin mới vào đối tượng Customer
            customer.setFullName(fullName);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setAddress(address);
            customer.setCccd(cccd);
            customer.setYob(yob);

            customerDAO.updateProfile(customer);

            session.setAttribute("user", customer);

            if ("payment".equals(redirectTarget)) {

                String addressID = (String) session.getAttribute("addressID");
                String receiverName = (String) session.getAttribute("receiverName");
                String receiverPhone = (String) session.getAttribute("receiverPhone");

                if (addressID == null) {
                    addressID = "";
                }
                if (receiverName == null) {
                    receiverName = "";
                }
                if (receiverPhone == null) {
                    receiverPhone = "";
                }

                String encodedName = java.net.URLEncoder.encode(receiverName, "UTF-8");
                String encodedPhone = java.net.URLEncoder.encode(receiverPhone, "UTF-8");

                session.removeAttribute("addressID");
                session.removeAttribute("receiverName");
                session.removeAttribute("receiverPhone");

                response.sendRedirect(request.getContextPath()
                        + "/payment?action=checkout&addressID=" + addressID
                        + "&receiverName=" + encodedName
                        + "&receiverPhone=" + encodedPhone);

                return;
            }

            request.setAttribute("message", "Cập nhật hồ sơ thành công!");
            request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật hệ thống!");
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
                InstallmentDetailDAO pmDAO = new InstallmentDetailDAO();
                pmDAO.updatePaymentStatusToPaid(paymentID);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        response.sendRedirect("customer?action=payInstallment");
    }
}
