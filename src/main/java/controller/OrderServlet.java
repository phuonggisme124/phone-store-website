package controller;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.PaymentsDAO;
import dao.ProductDAO;
import dao.UsersDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Category;
import model.InterestRate;
import model.Order;
import model.OrderDetails;
import model.Payments;
import model.Users;
import com.google.gson.Gson;
import dao.OrderDetailDAO;
import dao.VariantsDAO;
import java.util.HashMap;

/**
 * OrderServlet - Handles order management for Staff, Shipper, Admin, and Customer
 * Authors: phương, thịnh, duy
 * Note: Removed cancelOrder action for Staff (customers now cancel their own orders)
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        UsersDAO udao = new UsersDAO();
        ProductDAO pdao = new ProductDAO();
        OrderDAO dao = new OrderDAO();
        PaymentsDAO paydao = new PaymentsDAO();

        if (action == null) {
            action = "null";
        }

        if (action.equals("null")) {
            HttpSession session = request.getSession(false);
            Users currentUser = (Users) session.getAttribute("user");

            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int userID = currentUser.getUserId();
            int userRole = currentUser.getRole();

            String targetPage = "";
            List<Order> orders = null;

            if (userRole == 3) { // Shipper

                String status = request.getParameter("status");

                if (status == null || status.equalsIgnoreCase("all")) {
                    orders = dao.getOrdersByShipperId(userID);
                } else {
                    orders = dao.getOrdersByShipperIdAndStatus(userID, status);
                }
                HashMap<Integer, List<OrderDetails>> orderDetailList = new HashMap<>();
                OrderDetailDAO oDDAO = new OrderDetailDAO();
                for(Order o : orders) {
                    List<OrderDetails> oDList = oDDAO.getOrderDetailByOrderID(o.getOrderID());
                    orderDetailList.put(o.getOrderID(), oDList);
                }
                request.setAttribute("orderDetailList", orderDetailList);
                request.setAttribute("orders", orders);
                request.setAttribute("shipperName", currentUser.getFullName());
                targetPage = "shipper/dashboard_shipper.jsp";

            } else if (userRole == 2) { // Staff
                response.sendRedirect("order?action=manageOrder");
                return;

            } else if (userRole == 1) { // Customer

                String status = request.getParameter("status");
                if (status == null || status.isEmpty() || status.equalsIgnoreCase("All")) {
                    orders = dao.getOrdersByUserId(userID);
                } else {
                    orders = dao.getOrdersByStatus(userID, status);
                }
                request.setAttribute("orders", orders);
                targetPage = "orders.jsp";

            } else if (userRole == 4) { // Admin
                response.sendRedirect("order?action=manageOrderAdmin");
                return;
            } else {
                response.sendRedirect("login.jsp");
                return;
            }

            String orderIdParam = request.getParameter("id");
            if (orderIdParam != null && userRole == 1) {
                try {
                    int orderId = Integer.parseInt(orderIdParam);
                    Order order = dao.getOrderById(orderId);
                    List<OrderDetails> details = dao.getAllOrderDetailByOrderID(orderId);

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
                } catch (NumberFormatException e) {
                    response.sendRedirect("order");
                    return;
                }
            }

            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> listCategory = categoryDAO.getAllCategories();
            request.setAttribute("listCategory", listCategory);

            request.getRequestDispatcher(targetPage).forward(request, response);
        } // --- STAFF MANAGE ORDER ---
        else if ("manageOrder".equals(action)) {
            HttpSession session = request.getSession();
            Users currentUser = (Users) session.getAttribute("user");

            if (currentUser == null || (currentUser.getRole() != 2 && currentUser.getRole() != 4)) {
                response.sendRedirect("login");
                return;
            }

            if (currentUser.getRole() == 2) {
                List<Users> shippers = udao.getAllShippers();
                List<String> allPhones = udao.getAllBuyerPhones();
                request.setAttribute("allPhones", allPhones);

                String searchPhone = request.getParameter("phone");
                String status = request.getParameter("status");
                List<Order> listOrders;

                if (searchPhone != null && !searchPhone.trim().isEmpty() && status != null && !status.equalsIgnoreCase("All")) {
                    listOrders = dao.getOrdersByPhoneAndStatus(searchPhone.trim(), status);
                } else if (searchPhone != null && !searchPhone.trim().isEmpty()) {
                    listOrders = dao.getOrdersByPhone(searchPhone.trim());
                } else if (status != null && !status.equalsIgnoreCase("All")) {
                    listOrders = dao.getOrdersByStatusForStaff(currentUser.getUserId(), status);
                } else {
                    listOrders = dao.getAllOrderForStaff(currentUser.getUserId());
                }

                request.setAttribute("listOrders", listOrders);
                request.setAttribute("listShippers", shippers);
                request.getRequestDispatcher("staff/dashboard_staff_manageorder.jsp").forward(request, response);
            } else if (currentUser.getRole() == 4) {
                List<Order> listOrder = dao.getAllOrder();
                List<String> listPhone = dao.getAllPhone();

                for (Order o : listOrder) {
                    System.out.println("OrderID: " + o.getOrderID() + " StaffID: " + o.getStaffID());
                }
                request.setAttribute("listOrder", listOrder);
                request.setAttribute("listPhone", listPhone);

                request.getRequestDispatcher("admin/dashboard_admin_manageorder.jsp").forward(request, response);
            }

        } // --- AJAX SEARCH PHONE ---
        else if ("searchPhone".equals(action)) {
            String term = request.getParameter("term");
            List<String> phones = udao.getAllBuyerPhones();

            if (term != null && !term.isEmpty()) {
                phones = phones.stream().filter(p -> p.contains(term)).toList();
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(phones));
        } // --- ADMIN ORDER DETAIL ---
        else if (action.equals("orderDetail")) {
            int oid = Integer.parseInt(request.getParameter("id"));
            String isInstalmentParam = request.getParameter("isIntalment");
            boolean isInstalment = (isInstalmentParam != null) ? Boolean.parseBoolean(isInstalmentParam) : false;

            List<OrderDetails> listOrderDetails = dao.getAllOrderDetailByOrderID(oid);
            List<Payments> listPayments = paydao.getPaymentByOrderID(oid);
            List<InterestRate> listInterestRate = pdao.getAllInterestRate();

            request.setAttribute("listOrderDetails", listOrderDetails);
            request.setAttribute("listInterestRate", listInterestRate);
            request.setAttribute("listPayments", listPayments);
            request.setAttribute("isIntalment", isInstalment);
            request.getRequestDispatcher("admin/admin_manageorder_detail.jsp").forward(request, response);
        } // --- INSTALMENT ---
        else if (action.equals("showInstalment")) {
            List<Order> listOrder = dao.getAllOrderInstalment();
            List<String> listPhone = dao.getAllPhoneInstalment();
            List<Users> listShippers = udao.getAllShippers();
            List<Users> listStaff = udao.getUsersByRole(2);

            request.setAttribute("listOrder", listOrder);
            request.setAttribute("listPhone", listPhone);
            request.setAttribute("listShippers", listShippers);
            request.setAttribute("listStaff", listStaff);

            request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
        } // --- SEARCH ORDER (ADMIN) ---
        else if (action.equals("searchOrder")) {
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            List<String> listPhone = dao.getAllPhone();
            List<Order> listOrder;

            if (status.equals("Filter") || status.equals("All")) {
                listOrder = dao.getAllOrderByPhone(phone);
            } else {
                listOrder = dao.getAllOrderByPhoneAndStatus(phone, status);
            }

            List<Users> listShippers = udao.getAllShippers();
            List<Users> listStaff = udao.getUsersByRole(2);
            request.setAttribute("listShippers", listShippers);
            request.setAttribute("listStaff", listStaff);

            request.setAttribute("listOrder", listOrder);
            request.setAttribute("phone", phone);
            request.setAttribute("status", status);
            request.setAttribute("listPhone", listPhone);
            request.getRequestDispatcher("admin/dashboard_admin_manageorder.jsp").forward(request, response);
        } // --- FILTER ORDER (ADMIN) ---
        else if (action.equals("filterOrder")) {
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            List<String> listPhone = dao.getAllPhone();
            List<Order> listOrder;

            if ((phone == null || phone.isEmpty()) && (status.equals("Filter") || status.equals("All"))) {
                listOrder = dao.getAllOrder();
            } else if (status.equals("Filter") || status.equals("All")) {
                listOrder = dao.getAllOrderByPhone(phone);
            } else if (!(status.equals("Filter") || status.equals("All")) && (phone == null || phone.isEmpty())) {
                listOrder = dao.getAllOrderByStatus(status);
            } else {
                listOrder = dao.getAllOrderByPhoneAndStatus(phone, status);
            }

            List<Users> listShippers = udao.getAllShippers();
            List<Users> listStaff = udao.getUsersByRole(2);
            request.setAttribute("listShippers", listShippers);
            request.setAttribute("listStaff", listStaff);

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

        if (action == null) {
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            String newStatus = request.getParameter("newStatus");
            if (newStatus.equalsIgnoreCase("cancelled")) {
                OrderDetailDAO oDDAO = new OrderDetailDAO();
                List<OrderDetails> oDList = oDDAO.getOrderDetailByOrderID(orderID);
                VariantsDAO vDAO = new VariantsDAO();
                //If user cancel order, return stock of product
                for (OrderDetails oD : oDList) {
                    vDAO.increaseQuantity(oD.getVariantID(), oD.getQuantity());
                }
            }
            dao.updateOrderStatus(orderID, newStatus);
            response.sendRedirect("order");
            return;
        }

        // chọn shipper
        if ("assignShipper".equals(action)) {
            if (session == null) {
                response.sendRedirect("login");
                return;
            }
            Users currentUser = (Users) session.getAttribute("user");

            if (currentUser == null || (currentUser.getRole() != 2 && currentUser.getRole() != 4)) {
                response.sendRedirect("login");
                return;
            }

            try {
                int orderID = Integer.parseInt(request.getParameter("orderID"));
                int shipperID = Integer.parseInt(request.getParameter("shipperID"));

                boolean assignSuccess = dao.assignShipperAndStaff(orderID, currentUser.getUserId(), shipperID);

                if (assignSuccess) {
                    session.setAttribute("message", "Shipper assigned successfully! Stock has been reduced.");
                } else {
                    session.setAttribute("error", "Cannot assign shipper. Order must be Pending!");
                }
            } catch (NumberFormatException e) {
                System.err.println("Error assigning shipper: " + e.getMessage());
                session.setAttribute("error", "Invalid shipper assignment data.");
            }

            if (currentUser.getRole() == 4) {
                response.sendRedirect("order?action=manageOrderAdmin");
            } else {
                response.sendRedirect("order?action=manageOrder");
            }
            return;
        }
        //của thịnh cấm đụng
        // hủy đơn
        else if ("cancelOrder".equals(action)) {
            if (session == null) {
                response.sendRedirect("login");
                return;
            }
            Users currentUser = (Users) session.getAttribute("user");

            if (currentUser == null || (currentUser.getRole() != 2 && currentUser.getRole() != 4)) {
                response.sendRedirect("login");
                return;
            }

            try {
                int orderID = Integer.parseInt(request.getParameter("orderID"));

                boolean cancelSuccess = dao.cancelOrderByStaff(orderID, currentUser.getUserId());

                if (cancelSuccess) {
                    session.setAttribute("message", "Order cancelled successfully!");
                } else {
                    session.setAttribute("error", "Cannot cancel order. Order must be Pending!");
                }
            } catch (NumberFormatException e) {
                System.err.println("Error cancelling order: " + e.getMessage());
                session.setAttribute("error", "Invalid order cancellation data.");
            }

            if (currentUser.getRole() == 4) {
                response.sendRedirect("order?action=manageOrderAdmin");
            } else {
                response.sendRedirect("order?action=manageOrder");
            }
            return;
        }
// --- UPDATE STATUS (Shipper only) ---
        else if ("updateStatus".equals(action)) {
            if (session == null) {
                response.sendRedirect("login");
                return;
            }
            Users currentUser = (Users) session.getAttribute("user");

            if (currentUser == null || currentUser.getRole() != 3) {
                response.sendRedirect("login");
                return;
            }

            String newStatus = request.getParameter("newStatus");
            String orderIdParam = request.getParameter("orderID");

            if (orderIdParam == null || newStatus == null) {
                response.sendRedirect("order");
                return;
            }

            try {
                int orderID = Integer.parseInt(orderIdParam);

                boolean updateSuccess = dao.updateOrderStatusByShipper(orderID, currentUser.getUserId(), newStatus);

                if (updateSuccess) {
                    session.setAttribute("message", "Order status updated to " + newStatus + " successfully!");
                } else {
                    session.setAttribute("error", "Cannot update status. Order must be In Transit and assigned to you!");
                }
            } catch (NumberFormatException e) {
                System.err.println("Error updating status: " + e.getMessage());
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