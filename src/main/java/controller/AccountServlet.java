/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.StaffDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Customer;
import model.Staff;

/**
 *
 * @author duynu
 */
@WebServlet(name = "AccountServlet", urlPatterns = {"/account"})
public class AccountServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AccountServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AccountServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StaffDAO sdao = new StaffDAO();
        CustomerDAO cdao = new CustomerDAO();
        String action = request.getParameter("action");
        // Check login and determine user type
        HttpSession session = request.getSession();
        Staff admin = (Staff) session.getAttribute("user");
        if ("edit".equals(action)) {

            if (admin != null && (admin.getRole() == 4)) {
                String idStr = request.getParameter("id");
                String roleStr = request.getParameter("role");
                if (idStr != null && !idStr.isEmpty()) {
                    try {
                        int ID = Integer.parseInt(idStr);
                        int role = Integer.parseInt(roleStr);
                        if (role != 1) {
                            Staff targetUser = sdao.getStaffByID(ID);
                            request.setAttribute("currentUser", targetUser);
                            request.setAttribute("role", role);
                            request.getRequestDispatcher("admin/admin_manageuser_edit.jsp").forward(request, response);
                            return;
                        } else {
                            Customer targetUser = cdao.getCustomerByID(ID);
                            request.setAttribute("currentUser", targetUser);
                            request.setAttribute("role", role);
                            request.getRequestDispatcher("admin/admin_manageuser_edit.jsp").forward(request, response);
                            return;
                        }

                    } catch (NumberFormatException e) {
                        System.out.println("ID không hợp lệ: " + idStr);
                    }
                }
            }
        } else if ("manageUser".equals(action)) {
            String roleStr = request.getParameter("role");
            int role = 1;
            if (roleStr == null || roleStr.isEmpty() || roleStr.equals("2")) {
                role = 2;
            }
            if (admin != null && (admin.getRole() == 4)) {
                List<Customer> listCustomers = cdao.getAllCustomers();
                List<Staff> listStaff = sdao.getAllStaffs();
                request.setAttribute("listCustomers", listCustomers);
                request.setAttribute("listStaff", listStaff);
                request.setAttribute("role", role);
                // Ensure the path to the JSP is correct based on your project structure
                request.getRequestDispatcher("admin/dashboard_admin_manageuser.jsp").forward(request, response);
            } else {
                // If a customer tries to access manageUser, redirect them home or show error
                response.sendRedirect("admin");
            }
        } else if ("createAccount".equals(action)) {
            if (admin != null && admin.getRole() == 4) {
                request.getRequestDispatcher("admin/admin_manageuser_create.jsp").forward(request, response);
            } else {
                // If not admin, redirect or show error
                response.sendRedirect("login.jsp");
            }
        } else {
            response.sendRedirect("admin");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StaffDAO sdao = new StaffDAO();
        CustomerDAO cdao = new CustomerDAO();
        String action = request.getParameter("action");
        // Check login and determine user type
        HttpSession session = request.getSession(false);
        Staff admin = (Staff) session.getAttribute("admin");

        if (action.equals("updateUserAdmin")) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");

            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            int role = Integer.parseInt(request.getParameter("role"));
            int oldRole = 0;
            if (role != 1) {
                oldRole = Integer.parseInt(request.getParameter("oldRole"));
            }

            String status = request.getParameter("status");

            if (role > 1) {
                Staff u = sdao.getStaffByID(userId);
                if (email.equalsIgnoreCase(u.getEmail())) {
                    sdao.updateStaff(userId, name, email, phone, role, status);

                    session.setAttribute("successUpdateUser", email + " update successfully!");
                    response.sendRedirect("account?action=manageUser");

                } else {
                    Staff isStaff = sdao.getStaffByEmail(email);
                    if (isStaff == null) {
                        session.setAttribute("exist", email + " already exists!");

                        response.sendRedirect("account?action=edit&id=" + userId);

                    } else {
                        sdao.updateStaff(userId, name, email, phone, role, status);

                        session.setAttribute("successUpdateUser", email + " update successfully!");
                        response.sendRedirect("account?action=manageUser");
                    }

                }
            } else {
                Customer u = cdao.getCustomerByID(userId);
                if (email.equalsIgnoreCase(u.getEmail())) {
                    cdao.updateCustomerStatus(status, email);

                    session.setAttribute("successUpdateUser", email + " update successfully!");
                    response.sendRedirect("account?action=manageUser&role=1");

                } else {
                    Customer isCustomer = cdao.getCustomerByEmail(email);
                    if (isCustomer == null) {
                        session.setAttribute("exist", email + " already exists!");

                        response.sendRedirect("account?action=edit&id=" + userId);

                    } else {
                        cdao.updateCustomerStatus(status, email);

                        session.setAttribute("successUpdateUser", email + " update successfully!");
                        response.sendRedirect("account?action=manageUser&role=1");
                    }

                }
            }

        } else if (action.equals("createAccountAdmin")) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");

            int role = Integer.parseInt(request.getParameter("role"));

            boolean isRegistered = sdao.register(name, email, phone, password, role);
            if (!isRegistered) {

                session.setAttribute("exist", email + " already exists!");

                response.sendRedirect("account?action=createAccount");

                return;
            }

            session.setAttribute("successCreateUser", email + " create successfully!");
            response.sendRedirect("account?action=manageUser");
        } else if (action.equals("deleteUserAdmin")) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int role = Integer.parseInt(request.getParameter("role"));
            Customer customerDelete = new Customer();
            Staff staffDelete = new Staff();
            if (role == 1) {
                customerDelete = cdao.getCustomerByID(userId);
            } else if (role > 1) {
                staffDelete = sdao.getStaffByID(userId);
            } else {
                response.sendRedirect("login.jsp");
                return;
            }
            sdao.deleteByRole(userId, role);

            if (role == 1) {
                session.setAttribute("successDeleteUser", customerDelete.getEmail() + " delete successfully!");
                response.sendRedirect("account?action=manageUser&role=1");
            } else {
                session.setAttribute("successDeleteUser", staffDelete.getEmail() + " delete successfully!");
                response.sendRedirect("account?action=manageUser");
            }

        } else {
            response.sendRedirect("account?action=view");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
