/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to edit this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Order;
import model.Users;

/**
 * @author admin
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy Session hiện tại
        HttpSession session = request.getSession(false);

        // 2. Kiểm tra đăng nhập
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

        // 3. Phân quyền
        if (userRole == 3) {
            // Role 3: Shipper
            orders = dao.getOrdersByShipperId(userID);
            request.setAttribute("orders", orders);
            request.setAttribute("shipperName", currentUser.getFullName());
            targetPage = "dashboard_shipper.jsp";

        } else if (userRole == 2) {
            // Role 2: Staff
            orders = dao.getAllOders();
            request.setAttribute("orders", orders);
            targetPage = "dashboard_staff.jsp";

        } else {
            // Role khác → không được truy cập
            System.err.println("User " + userID + " tried to access unsupported dashboard.");
            response.sendRedirect("index.jsp");
            return;
        }

        // 4. Forward đến JSP tương ứng
        request.getRequestDispatcher(targetPage).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        OrderDAO dao = new OrderDAO();

        String status = request.getParameter("status");
        String orderIdParam = request.getParameter("orderID");

        if (orderIdParam == null || status == null) {
            response.sendRedirect("order");
            return;
        }

        int orderID = Integer.parseInt(orderIdParam);

        // Cập nhật trạng thái hoặc xóa đơn
        if (status.equalsIgnoreCase("Delivered")) {
            dao.deleteOrderByID(orderID);
        } else if (status.equalsIgnoreCase("Pending")) {
            dao.updateOrderStatus(orderID, "In Transit");
        } else if (status.equalsIgnoreCase("In Transit")) {
            dao.updateOrderStatus(orderID, "Delivered");
        }

        response.sendRedirect("order");
    }

    @Override
    public String getServletInfo() {
        return "OrderServlet - xử lý phân quyền, cập nhật & xóa đơn hàng.";
    }
}
