package controller;

import dao.UsersDAO;
import dao.CategoryDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Users;
import model.Category;
import model.Order;
import model.OrderDetails;

/**
 * Servlet Controller to handle user profile actions.
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/user"})
public class UserServlet extends HttpServlet {

    private final UsersDAO usersDAO = new UsersDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    /**
     * Helper method to load common data needed for the header.
     * @param request The servlet request.
     */
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

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        loadCommonData(request); // REFACTORED: Load common data

        switch (action) {
            case "edit":
                request.setAttribute("user", user);
                request.getRequestDispatcher("editProfile.jsp").forward(request, response);
                break;

            case "transaction":
                String status = request.getParameter("status");
                if (status == null || status.equalsIgnoreCase("All")) {
                    status = "All";
                }
                List<Order> oList = orderDAO.getOrdersByStatus(user.getUserId(), status);
                request.setAttribute("oList", oList);
                
                String orderIDStr = request.getParameter("orderID");
                if (orderIDStr != null) {
                    // FIXED: Added try-catch for NumberFormatException
                    try {
                        int orderID = Integer.parseInt(orderIDStr);
                        List<OrderDetails> oDList = orderDetailDAO.getOrderDetailByOrderID(orderID);
                        request.setAttribute("oDList", oDList);
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid OrderID parameter: " + orderIDStr);
                    }
                }
                request.getRequestDispatcher("customer_transaction.jsp").forward(request, response);
                break;
            
            // FIXED: Merged from conflicting branch
            case "changePassword":
                request.getRequestDispatcher("changePassword.jsp").forward(request, response);
                break;

            case "view":
            default:
                request.setAttribute("user", user);
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        loadCommonData(request); // REFACTORED: Load common data

        if ("update".equals(action)) {
            updateUserProfile(request, response, user, session);
        } else if ("updatePassword".equals(action)) {
            updateUserPassword(request, response, user, session);
        } else {
            response.sendRedirect("user?action=view");
        }
    }

    private void updateUserProfile(HttpServletRequest request, HttpServletResponse response, Users user, HttpSession session)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        // Password is not updated here for security. It's handled in updateUserPassword.
        
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);

        usersDAO.updateUserProfile(user);
        session.setAttribute("user", user); // Update session with new data

        request.setAttribute("message", "Cập nhật hồ sơ thành công!");
        request.getRequestDispatcher("editProfile.jsp").forward(request, response);
    }

    private void updateUserPassword(HttpServletRequest request, HttpServletResponse response, Users user, HttpSession session)
            throws ServletException, IOException {
        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        // REFACTORED: Use the dedicated DAO method for checking password
        if (!usersDAO.checkOldPassword(user.getUserId(), oldPass)) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
        } else if (newPass == null || newPass.isEmpty() || !newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không trùng khớp!");
        } else {
            // Let the DAO handle the hashing
            usersDAO.updatePassword(user.getUserId(), newPass);
            
            // Update the password in the session object to keep it in sync
            user.setPassword(usersDAO.hashMD5(newPass));
            session.setAttribute("user", user);
            
            request.setAttribute("message", "Đổi mật khẩu thành công!");
        }

        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }
}