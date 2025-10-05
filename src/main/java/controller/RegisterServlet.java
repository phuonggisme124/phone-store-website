/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UsersDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

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
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        String name = request.getParameter("fullname");
        String email = request.getParameter("email");
        String numberPhone = request.getParameter("numberphone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("rePassword");
        //Check password and repeat pass word have to match
        if (!password.equals(rePassword) || password.isEmpty() || rePassword.isEmpty() || password == null || rePassword == null) {
            request.setAttribute("error", "Password do not match!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
        if (name == null || name.isEmpty() || email == null || email.trim().isEmpty() || numberPhone.isEmpty() || numberPhone == null || address.isEmpty() || address == null) {
            request.setAttribute("error", "You must fill in all required fields to register.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
        UsersDAO dao = new UsersDAO();
        Users u = null;
        try {
             u = dao.register(name, email, numberPhone, address, password);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
         if (u != null) { // Đăng nhập thành công (UsersDAO.login trả về null nếu thất bại)
            
            // Đăng nhập thành công -> Tạo cookie và Session
            
            // A. Gán User vào Session (Tốt hơn là chỉ gán các thông tin cần thiết)
            // Lưu đối tượng User vào Session để truy cập dễ dàng hơn
            request.getSession().setAttribute("user", u);
            
            // B. Gán cookie (dành cho việc ghi nhớ đăng nhập hoặc kiểm tra nhanh)
            
            // Lưu EMAIL vào cookie
            Cookie cookieEmail = new Cookie("email", u.getEmail()); 
            cookieEmail.setMaxAge(60 * 60); // Tồn tại 1 tiếng
            response.addCookie(cookieEmail);

            // Gán Role vào cookie 
            String roleValue = (u.getRole() != null) ? u.getRole().toString() : "1"; // Mặc định role là 2 nếu null
            Cookie cookieRole = new Cookie("role", roleValue);
            cookieRole.setMaxAge(60 * 60); // Tồn tại 1 tiếng
            response.addCookie(cookieRole);

            // Bước 4: Chuyển hướng đến Product
            response.sendRedirect("homepage.jsp");

        } else {
            // Đăng nhập thất bại -> Gửi lại về trang login với thông báo lỗi
            request.setAttribute("error", "Invalid email or password.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
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
