package controller;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.InstallmentDetailDAO;
import dao.ProductDAO;
import dao.CustomerDAO;
import dao.OrderDetailDAO;
import dao.VariantsDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.HashMap;
import model.Category;
import model.InterestRate;
import model.Order;
import model.OrderDetails;
import model.Customer;
import model.Staff;
import com.google.gson.Gson;
import model.InstallmentDetail;

/**
 * OrderServlet - Handles order management for Staff, Shipper, Admin, and
 * Customer Authors: phương, thịnh, duy
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    private final CustomerDAO udao = new CustomerDAO();
    private final ProductDAO pdao = new ProductDAO();
    private final OrderDAO dao = new OrderDAO();
    private final InstallmentDetailDAO paydao = new InstallmentDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "null";
        }

        HttpSession session = request.getSession(false);
        Object userObj = (session != null) ? session.getAttribute("user") : null;
        Integer roleObj = (session != null && session.getAttribute("role") != null) ? (Integer) session.getAttribute("role") : null;
        int role = (roleObj != null) ? roleObj : 0;

        // If no user in session -> redirect to login
        if (userObj == null || role == 0) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Default customer/shipper/staff/admin flow
        if ("null".equals(action)) {
            // Determine user id based on role
            int userID;
            if (role == 1) {
                Customer currentCustomer = (Customer) userObj;
                userID = currentCustomer.getCustomerID();
            } else {
                // Staff/shipper/admin use Staff model
                Staff currentStaff = (Staff) userObj;
                userID = currentStaff.getStaffID();
            }

            String targetPage = "";
            List<Order> orders = null;

            if (role == 3) { // Shipper

                Staff shipper = (Staff) userObj; // userObj đã set ở LoginServlet
                int shipperID = shipper.getStaffID();

                String status = request.getParameter("status");

                if (status == null || status.equalsIgnoreCase("all")) {
                    orders = dao.getOrdersByShipperId(shipperID);
                } else {
                    orders = dao.getOrdersByShipperIdAndStatus(shipperID, status);
                }

                HashMap<Integer, List<OrderDetails>> orderDetailList = new HashMap<>();
                OrderDetailDAO oDDAO = new OrderDetailDAO();

                if (orders != null) {
                    for (Order o : orders) {
                        List<OrderDetails> list = oDDAO.getOrderDetailByOrderID(o.getOrderID());
                        orderDetailList.put(o.getOrderID(), list);
                    }
                }

                request.setAttribute("orderDetailList", orderDetailList);
                request.setAttribute("orders", orders);
                request.setAttribute("shipperName", shipper.getFullName());

                targetPage = "shipper/dashboard_shipper.jsp";
            } else if (role == 2) { // Staff
                response.sendRedirect("order?action=manageOrder");
                return;

            } else if (role == 1) { // Customer
                String status = request.getParameter("status");
                if (status == null || status.isEmpty() || status.equalsIgnoreCase("All")) {
                    orders = dao.getOrdersByUserId(userID);
                } else {
                    orders = dao.getOrdersByStatus(userID, status);
                }
                request.setAttribute("orders", orders);
                targetPage = "orders.jsp";

                // If customer requests specific order detail (order id passed)
                String orderIdParam = request.getParameter("id");
                if (orderIdParam != null) {
                    try {
                        int orderId = Integer.parseInt(orderIdParam);
                        Order order = dao.getOrderById(orderId);
                        List<OrderDetails> details = dao.getAllOrderDetailByOrderID(orderId);

                        // Check ownership
                        if (order == null || order.getUserID() == null || !order.getUserID().equals(userID)) {
                            response.sendRedirect("order");
                            return;
                        }

                        request.setAttribute("order", order);
                        request.setAttribute("details", details);

                        CategoryDAO categoryDAO = new CategoryDAO();
                        List<Category> listCategory = categoryDAO.getAllCategories();
                        request.setAttribute("listCategory", listCategory);

                        request.getRequestDispatcher("orderDetail.jsp").forward(request, response);
                        return;
                    } catch (NumberFormatException ex) {
                        response.sendRedirect("order");
                        return;
                    }
                }

            } else if (role == 4) { // Admin
                response.sendRedirect("order?action=manageOrderAdmin");
                return;
            } else {
                response.sendRedirect("login.jsp");
                return;
            }

            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> listCategory = categoryDAO.getAllCategories();
            request.setAttribute("listCategory", listCategory);

            request.getRequestDispatcher(targetPage).forward(request, response);
            return;
        }

        // --- STAFF MANAGE ORDER ---
        if ("manageOrder".equals(action)) {
            if (session == null || userObj == null || !(role == 2 || role == 4)) {
                response.sendRedirect("login");
                return;
            }

            if (role == 2) { // Staff view
//                List<Customer> shippers = udao.getAllShippers();
//                List<String> allPhones = udao.getAllBuyerPhones();
//                request.setAttribute("allPhones", allPhones);

                String searchPhone = request.getParameter("phone");
                String status = request.getParameter("status");
                List<Order> listOrders;

                if (searchPhone != null && !searchPhone.trim().isEmpty() && status != null && !status.equalsIgnoreCase("All")) {
                    listOrders = dao.getOrdersByPhoneAndStatus(searchPhone.trim(), status);
                } else if (searchPhone != null && !searchPhone.trim().isEmpty()) {
                    listOrders = dao.getOrdersByPhone(searchPhone.trim());
                } else if (status != null && !status.equalsIgnoreCase("All")) {
                    listOrders = dao.getOrdersByStatusForStaff(((Staff) userObj).getStaffID(), status);
                } else {
                    listOrders = dao.getAllOrderForStaff(((Staff) userObj).getStaffID());
                }

                request.setAttribute("listOrders", listOrders);
//                request.setAttribute("listShippers", shippers);
                request.getRequestDispatcher("staff/dashboard_staff_manageorder.jsp").forward(request, response);
                return;

            } else if (role == 4) { // Admin manage
                List<Order> listOrder = dao.getAllOrder();
                List<String> listPhone = dao.getAllPhone();

                request.setAttribute("listOrder", listOrder);
                request.setAttribute("listPhone", listPhone);

                request.getRequestDispatcher("admin/dashboard_admin_manageorder.jsp").forward(request, response);
                return;
            }
        }

        // --- AJAX SEARCH PHONE ---
        if ("searchPhone".equals(action)) {
            String term = request.getParameter("term");
//            List<String> phones = udao.getAllBuyerPhones();

            if (term != null && !term.isEmpty()) {
//                phones = phones.stream().filter(p -> p.contains(term)).toList();
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
//            response.getWriter().write(new Gson().toJson(phones));
            return;
        }

        // --- ADMIN ORDER DETAIL ---
        if ("orderDetail".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendRedirect("order?action=manageOrderAdmin");
                return;
            }
            int oid = Integer.parseInt(idParam);
            String isInstalmentParam = request.getParameter("isIntalment");
            boolean isInstalment = (isInstalmentParam != null) ? Boolean.parseBoolean(isInstalmentParam) : false;

            List<OrderDetails> listOrderDetails = dao.getAllOrderDetailByOrderID(oid);
            List<InstallmentDetail> listPayments = paydao.getPaymentByOrderID(oid);
            List<InterestRate> listInterestRate = pdao.getAllInterestRate();

            request.setAttribute("listOrderDetails", listOrderDetails);
            request.setAttribute("listInterestRate", listInterestRate);
            request.setAttribute("listPayments", listPayments);
            request.setAttribute("isIntalment", isInstalment);
            request.getRequestDispatcher("admin/admin_manageorder_detail.jsp").forward(request, response);
            return;
        }

        // --- INSTALMENT ---
        if ("showInstalment".equals(action)) {
            List<Order> listOrder = dao.getAllOrderInstalment();
//            List<String> listPhone = dao.getAllPhoneInstalment();
//            List<Customer> listShippers = udao.getAllShippers();
//            List<Customer> listStaff = udao.getCustomerByRole(2);

            request.setAttribute("listOrder", listOrder);
//            request.setAttribute("listPhone", listPhone);
//            request.setAttribute("listShippers", listShippers);
//            request.setAttribute("listStaff", listStaff);

            request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
            return;
        }

        // --- SEARCH ORDER (ADMIN) ---
        if ("searchOrder".equals(action)) {
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            List<String> listPhone = dao.getAllPhone();
            List<Order> listOrder;

            if (status == null || status.equals("Filter") || status.equals("All")) {
                listOrder = dao.getAllOrderByPhone(phone);
            } else {
                listOrder = dao.getAllOrderByPhoneAndStatus(phone, status);
            }

//            List<Customer> listShippers = udao.getAllShippers();
//            List<Customer> listStaff = udao.getCustomerByRole(2);
//            request.setAttribute("listShippers", listShippers);
//            request.setAttribute("listStaff", listStaff);

            request.setAttribute("listOrder", listOrder);
            request.setAttribute("phone", phone);
            request.setAttribute("status", status);
            request.setAttribute("listPhone", listPhone);
            request.getRequestDispatcher("admin/dashboard_admin_manageorder.jsp").forward(request, response);
            return;
        }

        // --- FILTER ORDER (ADMIN) ---
        if ("filterOrder".equals(action)) {
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            List<String> listPhone = dao.getAllPhone();
            List<Order> listOrder;

            boolean statusAll = (status == null || status.equals("Filter") || status.equals("All"));
            boolean phoneEmpty = (phone == null || phone.isEmpty());

            if (phoneEmpty && statusAll) {
                listOrder = dao.getAllOrder();
            } else if (statusAll) {
                listOrder = dao.getAllOrderByPhone(phone);
            } else if (phoneEmpty) {
                listOrder = dao.getAllOrderByStatus(status);
            } else {
                listOrder = dao.getAllOrderByPhoneAndStatus(phone, status);
            }
//
//            List<Customer> listShippers = udao.getAllShippers();
//            List<Customer> listStaff = udao.getCustomerByRole(2);
//            request.setAttribute("listShippers", listShippers);
//            request.setAttribute("listStaff", listStaff);

            request.setAttribute("phone", phone);
            request.setAttribute("status", status);
            request.setAttribute("listOrder", listOrder);
            request.setAttribute("listPhone", listPhone);
            request.getRequestDispatcher("admin/dashboard_admin_manageorder.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        OrderDAO dao = new OrderDAO();
        HttpSession session = request.getSession(false);

        // Validate session & role
        Object userObj = (session != null) ? session.getAttribute("user") : null;
        Integer roleObj = (session != null && session.getAttribute("role") != null) ? (Integer) session.getAttribute("role") : null;
        int role = (roleObj != null) ? roleObj : 0;
        // Assign shipper (Staff/Admin)
        if ("assignShipper".equals(action)) {
            if (session == null || userObj == null || !(role == 2 || role == 4)) {
                response.sendRedirect("login");
                return;
            }

            Staff currentStaff = (Staff) userObj;
            try {
                int orderID = Integer.parseInt(request.getParameter("orderID"));
                int shipperID = Integer.parseInt(request.getParameter("shipperID"));

                boolean assignSuccess = dao.assignShipperAndStaff(orderID, currentStaff.getStaffID(), shipperID);

                if (assignSuccess) {
                    session.setAttribute("message", "Shipper assigned successfully! Stock has been reduced.");
                } else {
                    session.setAttribute("error", "Cannot assign shipper. Order must be Pending!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid shipper assignment data.");
            }

            if (role == 4) {
                response.sendRedirect("order?action=manageOrderAdmin");
            } else {
                response.sendRedirect("order?action=manageOrder");
            }
            return;
        }

        // Cancel order by staff/admin
        if ("cancelOrder".equals(action)) {
            if (session == null || userObj == null || !(role == 2 || role == 4)) {
                response.sendRedirect("login");
                return;
            }

            Staff currentStaff = (Staff) userObj;
            try {
                int orderID = Integer.parseInt(request.getParameter("orderID"));

                boolean cancelSuccess = dao.cancelOrderByStaff(orderID, currentStaff.getStaffID());

                if (cancelSuccess) {
                    session.setAttribute("message", "Order cancelled successfully!");
                } else {
                    session.setAttribute("error", "Cannot cancel order. Order must be Pending!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid order cancellation data.");
            }

            if (role == 4) {
                response.sendRedirect("order?action=manageOrderAdmin");
            } else {
                response.sendRedirect("order?action=manageOrder");
            }
            return;
        }

        // Update status by shipper only
        if ("updateStatus".equals(action)) {
            if (session == null || userObj == null || role != 3) {
                response.sendRedirect("login");
                return;
            }

            Staff currentShipper = (Staff) userObj;
            String newStatus = request.getParameter("newStatus");
            String orderIdParam = request.getParameter("orderID");

            if (orderIdParam == null || newStatus == null) {
                response.sendRedirect("order");
                return;
            }

            try {
                int orderID = Integer.parseInt(orderIdParam);

                boolean updateSuccess = dao.updateOrderStatusByShipper(orderID, currentShipper.getStaffID(), newStatus);

                if (updateSuccess) {
                    session.setAttribute("message", "Order status updated to " + newStatus + " successfully!");
                } else {
                    session.setAttribute("error", "Cannot update status. Order must be In Transit and assigned to you!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid status update data.");
            }

            response.sendRedirect("order");
            return;
        }

        response.sendRedirect("order");
    }

    @Override
    public String getServletInfo() {
        return "OrderServlet - Handles order management for Staff, Shipper, Admin, and Customer";
    }
}
