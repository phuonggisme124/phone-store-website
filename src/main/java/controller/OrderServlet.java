/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Order;
import model.Users;
import dao.CategoryDAO;
import java.util.List;
import model.Category;
import model.OrderDetails;

/**
 * Servlet responsible for handling order-related operations.
 *
 * Main features:
 * - Display orders depending on the user's role (staff or shipper)
 * - Update order status (Pending → In Transit → Delivered)
 * - Delete delivered orders
 *
 * This servlet supports both GET (view orders) and POST (update order) methods.
 *
 * Author: admin
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    /**
     * Handles the HTTP GET method.
     *
     * Workflow:
     * 1. Retrieve current session and verify login status.
     * 2. Identify user role (shipper or staff).
     * 3. Fetch corresponding order list from OrderDAO.
     * 4. Forward to the correct JSP based on user role.
     *
     * @param request HttpServletRequest object containing client request
     * @param response HttpServletResponse object for sending response to the client
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get current session
        HttpSession session = request.getSession(false);

        // 2. Verify login (redirect to login page if user is not logged in)
        Users currentUser = (Users) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userID = currentUser.getUserId();
        int userRole = currentUser.getRole();

        OrderDAO dao = new OrderDAO();
        String targetPage = "";
        List<Order> orders = null;

        // 3. Role-based authorization
        if (userRole == 3) {
            // Role 3: Shipper
            String status = request.getParameter("status");

            if (status == null || status.equalsIgnoreCase("all")) {
                // If no specific status filter, get all orders for this shipper
                orders = dao.getOrdersByShipperId(userID);
                request.setAttribute("orders", orders);
                request.setAttribute("shipperName", currentUser.getFullName());
                targetPage = "shipper/dashboard_shipper.jsp";
            } else {
                // If status filter is provided, get orders by that status
                orders = dao.getOrdersByShipperIdAndStatus(userID, status);
                request.setAttribute("orders", orders);
                request.setAttribute("shipperName", currentUser.getFullName());
                targetPage = "shipper/dashboard_shipper.jsp";
            }

        } else if (userRole == 2) {
            // Role 2: Staff
            orders = dao.getAllOrders(); // Staff can see all orders
            request.setAttribute("orders", orders);
            targetPage = "staff";

        } else if (userRole == 1) {
            // Role 1: Normal customer
            orders = dao.getOrdersByUserId(userID); // lấy danh sách đơn hàng theo ID người dùng
            request.setAttribute("orders", orders);
            targetPage = "orders.jsp"; // trang hiển thị danh sách đơn hàng
        } else {
            // Other roles → access denied, redirect to index
            System.err.println("User " + userID + " tried to access unsupported dashboard.");
            response.sendRedirect("index.jsp");
            return;
        }

        String orderIdParam = request.getParameter("id");
        if (orderIdParam != null) {
            try {
                int orderId = Integer.parseInt(orderIdParam);
                OrderDAO orderDAO = new OrderDAO();

                // Lấy chi tiết đơn hàng
                Order order = orderDAO.getOrderById(orderId);
                List<OrderDetails> details = orderDAO.getAllOrderDetailByOrderID(orderId);

                // Nếu không tìm thấy đơn
                if (order == null) {
                    response.sendRedirect("order");
                    return;
                }

                // Đưa dữ liệu qua JSP
                request.setAttribute("order", order);
                request.setAttribute("details", details);

                // Lấy danh mục để hiển thị navbar
                CategoryDAO categoryDAO = new CategoryDAO();
                List<Category> listCategory = categoryDAO.getAllCategories();
                request.setAttribute("listCategory", listCategory);

                // Forward qua trang chi tiết
                request.getRequestDispatcher("orderDetail.jsp").forward(request, response);
                return; // ✅ rất quan trọng, để không chạy tiếp phần phía dưới
            } catch (NumberFormatException e) {
                response.sendRedirect("order");
                return;
            }
        }

        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> listCategory = categoryDAO.getAllCategories();
        request.setAttribute("listCategory", listCategory);

        // 4. Forward to the appropriate JSP page
        request.getRequestDispatcher(targetPage).forward(request, response);
    }

    /**
     * Handles the HTTP POST method.
     *
     * Used for updating or deleting orders based on their current status.
     *
     * Workflow:
     * 1. Get orderID and status from the request.
     * 2. Depending on status:
     * - Pending → update to "In Transit"
     * - In Transit → update to "Delivered"
     * - Delivered → delete the order
     * 3. Redirect back to /order after update.
     *
     * @param request HttpServletRequest object
     * @param response HttpServletResponse object
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ensure correct character encoding (UTF-8)
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        OrderDAO dao = new OrderDAO();

        // Retrieve order parameters
        String status = request.getParameter("newStatus");
        String orderIdParam = request.getParameter("orderID");

        // If missing parameters, redirect back
        if (orderIdParam == null || status == null) {
            response.sendRedirect("order");
            return;
        }

        int orderID = Integer.parseInt(orderIdParam);

     
        dao.updateOrderStatus(orderID, status);
        

        // Redirect back to order management page
        response.sendRedirect("order");
    }

    /**
     * Provides a brief description of this servlet for documentation.
     *
     * @return A short string describing the servlet's purpose.
     */
    @Override
    public String getServletInfo() {
        return "OrderServlet - Handles role-based order viewing, updating, and deleting.";
    }
}
