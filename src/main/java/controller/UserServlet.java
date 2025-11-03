package controller;

import dao.UsersDAO;
import dao.CategoryDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.PaymentsDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;
import model.Category;
import model.Order;
import model.OrderDetails;
import model.Payments;

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
     *
     * @param request The servlet request.
     */
    private void loadCommonData(HttpServletRequest request) {
        List<Category> listCategory = categoryDAO.getAllCategories();
        request.setAttribute("listCategory", listCategory);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
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
                request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
                break;
            
            case "transaction":
                String status = request.getParameter("status");
                
                OrderDAO orderDAO = new OrderDAO();
                List<Order> oList;
                if (status == null || status.equalsIgnoreCase("All")) {
                    oList = orderDAO.getOrdersByStatus(user.getUserId(), "All");
                } else {
                    oList = orderDAO.getOrdersByStatus(user.getUserId(), status);
                }

                // TẠO MỘT MAP để chứa chi tiết cho TẤT CẢ các đơn hàng
                Map<Integer, List<OrderDetails>> allOrderDetails = new HashMap<>();
                if (oList != null) {
                    for (Order o : oList) {
                        List<OrderDetails> details = orderDetailDAO.getOrderDetailByOrderID(o.getOrderID());
                        allOrderDetails.put(o.getOrderID(), details);
                    }
                }

                // Gửi cả danh sách đơn hàng và map chi tiết sang JSP
                request.setAttribute("oList", oList);
                request.setAttribute("allOrderDetails", allOrderDetails); // Gửi map này!

                request.getRequestDispatcher("customer/customer_transaction.jsp").forward(request, response);
                break;
            case "payInstallment":
                
                PaymentsDAO pmDAO = new PaymentsDAO();
                oList = this.orderDAO.getInstalmentOrdersByUserId(user.getUserId());
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
                break;

            // FIXED: Merged from conflicting branch
            case "changePassword":
                response.sendRedirect("customer/changePassword.jsp");
                break;
            
            default:
                request.setAttribute("user", user);
                request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        UsersDAO udao = new UsersDAO();
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        loadCommonData(request); // REFACTORED: Load common data

        if ("update".equals(action)) {
            updateUserProfile(request, response, user, session);
        } else if ("changePassword".equals(action)) {
            updateUserPassword(request, response, user, session);
        } else if (action.equals("updateUserAdmin")) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            int role = Integer.parseInt(request.getParameter("role"));
            String status = request.getParameter("status");


            Users u = udao.getUserByID(userId);
            if (email.equalsIgnoreCase(u.getEmail())) {
                udao.updateUser(userId, name, email, phone, address, role, status);

                response.sendRedirect("admin?action=manageUser");

            } else {
                boolean isEmail = udao.getUserByEmail(email);
                if (isEmail) {
                    session.setAttribute("exist", email + " already exists!");

                    response.sendRedirect("admin?action=editAccount&id=" + userId);

                } else {
                    udao.updateUser(userId, name, email, phone, address, role, status);

                    response.sendRedirect("admin?action=manageUser");
                }

            }


        } else if (action.equals("createAccountAdmin")) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            int role = Integer.parseInt(request.getParameter("role"));
            
            boolean isRegistered = udao.register(name, email, phone, address, password, role);
            if (!isRegistered) {
                
                session.setAttribute("exist", email + " already exists!");
                
                response.sendRedirect("admin?action=createAccount");
                
                return;
            }
            
            response.sendRedirect("admin?action=manageUser");
        } else if (action.equals("deleteUserAdmin")) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            udao.deleteUser(userId);
            
            response.sendRedirect("admin?action=manageUser");
            
        } else if (action.equals("paidInstalment")) {
            String paymentIDStr = request.getParameter("paymentID");
            if (paymentIDStr != null) {
                int paymentID = Integer.parseInt(paymentIDStr);
                PaymentsDAO pmDAO = new PaymentsDAO();
                pmDAO.updatePaymentStatusToPaid(paymentID);
                response.sendRedirect("user?action=payInstallment");
            }
            
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
