package controller;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.PaymentsDAO;
import dao.ProductDAO;
import dao.CustomerDAO;
import dao.StaffDAO; // Thêm nếu cần dùng
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
import model.Customer;
import model.Staff; // [QUAN TRỌNG] Import Staff
import com.google.gson.Gson;
import dao.OrderDetailDAO;
import dao.VariantsDAO;
import java.util.HashMap;
import java.util.ArrayList;

/**
 * OrderServlet - Handles order management for Staff, Shipper, Admin, and Customer
 * Authors: phương, thịnh, duy
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        CustomerDAO udao = new CustomerDAO();
        ProductDAO pdao = new ProductDAO();
        OrderDAO dao = new OrderDAO();
        PaymentsDAO paydao = new PaymentsDAO();

        if (action == null) {
            action = "null";
        }

        HttpSession session = request.getSession(false);
        
        // --- SỬA LỖI CASTING: Lấy User linh hoạt (Staff hoặc Customer) ---
        Object userObj = (session != null) ? session.getAttribute("user") : null;
        Customer currentCustomer = null;
        Staff currentStaff = null;
        
        int userID = 0;
        int userRole = 0; // 0: Guest

        if (userObj != null) {
            if (userObj instanceof Customer) {
                currentCustomer = (Customer) userObj;
                userID = currentCustomer.getCustomerID(); // Hoặc getUserId() tùy model
                userRole = currentCustomer.getRole();
            } else if (userObj instanceof Staff) {
                currentStaff = (Staff) userObj;
                userID = currentStaff.getStaffID() ;
                userRole = currentStaff.getRole();
            }
        }
        // -------------------------------------------------------------

        // Nếu chưa đăng nhập
        if (userID == 0 && !action.equals("searchPhone")) { // searchPhone có thể public hoặc check riêng
             response.sendRedirect("login.jsp");
             return;
        }

        if (action.equals("null")) {
            
            String targetPage = "";
            List<Order> orders = null;

            if (userRole == 3) { // Shipper (Là Staff)
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
                request.setAttribute("shipperName", currentStaff.getFullName());
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
            } 

            // Logic xem chi tiết đơn hàng (Dành cho Customer)
            String orderIdParam = request.getParameter("id");
            if (orderIdParam != null && userRole == 1) {
                try {
                    int orderId = Integer.parseInt(orderIdParam);
                    Order order = dao.getOrderById(orderId);
                    List<OrderDetails> details = dao.getAllOrderDetailByOrderID(orderId);

                    if (order == null || order.getUserID() != userID) {
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

            if(!targetPage.isEmpty()){
                request.getRequestDispatcher(targetPage).forward(request, response);
            }

        } // --- STAFF MANAGE ORDER ---
        else if ("manageOrder".equals(action)) {
            
            // Check quyền Staff (2) hoặc Admin (4)
            if (currentStaff == null || (userRole != 2 && userRole != 4)) {
                response.sendRedirect("login.jsp");
                return;
            }

            if (userRole == 2) { // Staff Dashboard
                List<Staff> shippers = udao.getAllShippers();
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
                    // Method này trong DAO cần support staffID nếu muốn lọc theo staff, hoặc lấy all
                    listOrders = dao.getOrdersByStatusForStaff(userID, status); 
                } else {
                    listOrders = dao.getAllOrderForStaff(userID);
                }

                request.setAttribute("listOrders", listOrders);
                request.setAttribute("listShippers", shippers);
                request.getRequestDispatcher("staff/dashboard_staff_manageorder.jsp").forward(request, response);
                
            } else if (userRole == 4) { // Admin Dashboard (Redirect nội bộ)
                 // Logic của Admin đã được tách ra hoặc redirect về đây
                 // Nếu muốn dùng chung action manageOrder cho Admin thì viết code ở đây
                 response.sendRedirect("order?action=manageOrderAdmin");
            }

        } else if ("manageOrderAdmin".equals(action)) { // Action riêng cho Admin
             if (currentStaff == null || userRole != 4) {
                response.sendRedirect("login.jsp");
                return;
            }
            List<Order> listOrder = dao.getAllOrder();
            List<String> listPhone = dao.getAllPhone();
            request.setAttribute("listOrder", listOrder);
            request.setAttribute("listPhone", listPhone);
            request.getRequestDispatcher("staff/dashboard_staff_manageorder.jsp").forward(request, response);
        }

        // --- AJAX SEARCH PHONE ---
        else if ("searchPhone".equals(action)) {
            String term = request.getParameter("term");
            List<String> phones = udao.getAllBuyerPhones();

            if (term != null && !term.isEmpty()) {
                phones = phones.stream().filter(p -> p.contains(term)).toList();
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(phones));
        } 
        // --- ADMIN ORDER DETAIL ---
        else if (action.equals("orderDetail")) {
            // Ai có quyền xem chi tiết? Staff + Admin
            if (currentStaff == null) { response.sendRedirect("login.jsp"); return; }
            
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
            
            // Điều hướng dựa trên role
            if (userRole == 2) {
                 // Tạo trang detail cho staff nếu cần, hoặc dùng chung
                 request.getRequestDispatcher("admin/admin_manageorder_detail.jsp").forward(request, response);
            } else {
                 request.getRequestDispatcher("admin/admin_manageorder_detail.jsp").forward(request, response);
            }
            
        } 
        // --- INSTALMENT (ADMIN) ---
        else if (action.equals("showInstalment")) {
            if (userRole != 4) { response.sendRedirect("login.jsp"); return; }
            
            List<Order> listOrder = dao.getAllOrderInstalment();
            List<String> listPhone = dao.getAllPhoneInstalment();
            List<Staff> listShippers = udao.getAllShippers();
            List<Staff> listStaff = udao.getStaffByRole(2);

            request.setAttribute("listOrder", listOrder);
            request.setAttribute("listPhone", listPhone);
            request.setAttribute("listShippers", listShippers);
            request.setAttribute("listStaff", listStaff);

            request.getRequestDispatcher("admin/admin_manageorder_instalment.jsp").forward(request, response);
        } 
        // --- SEARCH ORDER (ADMIN) ---
        else if (action.equals("searchOrder")) {
            if (userRole != 4) { response.sendRedirect("login.jsp"); return; }
            
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            List<String> listPhone = dao.getAllPhone();
            List<Order> listOrder;

            if (status.equals("Filter") || status.equals("All")) {
                listOrder = dao.getAllOrderByPhone(phone);
            } else {
                listOrder = dao.getAllOrderByPhoneAndStatus(phone, status);
            }

            List<Staff> listShippers = udao.getAllShippers() ;
            List<Staff> listStaff = udao.getStaffByRole(2);
            request.setAttribute("listShippers", listShippers);
            request.setAttribute("listStaff", listStaff);

            request.setAttribute("listOrder", listOrder);
            request.setAttribute("phone", phone);
            request.setAttribute("status", status);
            request.setAttribute("listPhone", listPhone);
            request.getRequestDispatcher("admin/dashboard_admin_manageorder.jsp").forward(request, response);
        } 
        // --- FILTER ORDER (ADMIN) ---
        else if (action.equals("filterOrder")) {
            if (userRole != 4) { response.sendRedirect("login.jsp"); return; }
            
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

            List<Staff> listShippers = udao.getAllShippers();
            List<Staff> listStaff = udao.getStaffByRole(2);
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
        
        // --- SỬA LỖI CASTING DOPOST ---
        Object userObj = (session != null) ? session.getAttribute("user") : null;
        Customer currentCustomer = null;
        Staff currentStaff = null;
        int userID = 0;
        int userRole = 0;

        if (userObj != null) {
            if (userObj instanceof Customer) {
                currentCustomer = (Customer) userObj;
                userID = currentCustomer.getCustomerID();
                userRole = currentCustomer.getRole();
            } else if (userObj instanceof Staff) {
                currentStaff = (Staff) userObj;
                userID = currentStaff.getStaffID() ;
                userRole = currentStaff.getRole();
            }
        }
        
        if (userID == 0) {
             response.sendRedirect("login.jsp");
             return;
        }
        // ------------------------------

        if (action == null) {
            // Update Status đơn giản
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            String newStatus = request.getParameter("newStatus");
            if (newStatus.equalsIgnoreCase("cancelled")) {
                OrderDetailDAO oDDAO = new OrderDetailDAO();
                List<OrderDetails> oDList = oDDAO.getOrderDetailByOrderID(orderID);
                VariantsDAO vDAO = new VariantsDAO();
                for (OrderDetails oD : oDList) {
                    vDAO.increaseQuantity(oD.getVariantID(), oD.getQuantity());
                }
            }
            dao.updateOrderStatus(orderID, newStatus);
            response.sendRedirect("order");
            return;
        }

        // Chọn shipper (Chỉ Staff/Admin)
        if ("assignShipper".equals(action)) {
            if (currentStaff == null || (userRole != 2 && userRole != 4)) {
                response.sendRedirect("login.jsp");
                return;
            }

            try {
                int orderID = Integer.parseInt(request.getParameter("orderID"));
                int shipperID = Integer.parseInt(request.getParameter("shipperID"));

                boolean assignSuccess = dao.assignShipperAndStaff(orderID, userID, shipperID);

                if (assignSuccess) {
                    session.setAttribute("message", "Shipper assigned successfully! Stock has been reduced.");
                } else {
                    session.setAttribute("error", "Cannot assign shipper. Order must be Pending!");
                }
            } catch (NumberFormatException e) {
                System.err.println("Error assigning shipper: " + e.getMessage());
                session.setAttribute("error", "Invalid shipper assignment data.");
            }

            if (userRole == 4) {
                response.sendRedirect("order?action=manageOrderAdmin");
            } else {
                response.sendRedirect("order?action=manageOrder");
            }
            return;
        }
        
        // Hủy đơn (Staff/Admin hủy)
        else if ("cancelOrder".equals(action)) {
            if (currentStaff == null || (userRole != 2 && userRole != 4)) {
                response.sendRedirect("login.jsp");
                return;
            }

            try {
                int orderID = Integer.parseInt(request.getParameter("orderID"));

                boolean cancelSuccess = dao.cancelOrderByStaff(orderID, userID);

                if (cancelSuccess) {
                    session.setAttribute("message", "Order cancelled successfully!");
                } else {
                    session.setAttribute("error", "Cannot cancel order. Order must be Pending!");
                }
            } catch (NumberFormatException e) {
                System.err.println("Error cancelling order: " + e.getMessage());
                session.setAttribute("error", "Invalid order cancellation data.");
            }

            if (userRole == 4) {
                response.sendRedirect("order?action=manageOrderAdmin");
            } else {
                response.sendRedirect("order?action=manageOrder");
            }
            return;
        }
        // --- UPDATE STATUS (Shipper only) ---
        else if ("updateStatus".equals(action)) {
            if (currentStaff == null || userRole != 3) {
                response.sendRedirect("login.jsp");
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

                boolean updateSuccess = dao.updateOrderStatusByShipper(orderID, userID, newStatus);

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