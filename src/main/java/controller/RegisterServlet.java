package controller;

import dao.UsersDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
// Đã xóa import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Thêm import cho HttpSession
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy dữ liệu từ form
        String name = request.getParameter("fullname");
        String email = request.getParameter("email");
        String numberPhone = request.getParameter("numberphone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("rePassword");
        
        // --- Logic kiểm tra đầu vào ---
        
        // 1. Check password and rePassword match
        if (!password.equals(rePassword) || password.isEmpty() || password == null) {
            request.setAttribute("error", "Password do not match or cannot be empty!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return; // Dừng lại sau khi chuyển tiếp
        }
        
        // 2. Check required fields
        if (name == null || name.isEmpty() || email == null || email.trim().isEmpty() || 
            numberPhone == null || numberPhone.isEmpty() || address == null || address.isEmpty()) {
            request.setAttribute("error", "You must fill in all required fields to register.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return; // Dừng lại sau khi chuyển tiếp
        }
        
        // --- Logic Đăng ký và Xử lý kết quả ---
        
        UsersDAO dao = new UsersDAO();
        Users u = null;
        try {
             // Giả định phương thức register trong UsersDAO sẽ trả về đối tượng Users nếu thành công
             u = dao.register(name, email, numberPhone, address, password);
        } catch (Exception e) {
            // Đây thường là lỗi Email đã tồn tại hoặc lỗi CSDL
            System.out.println("Registration error: " + e.getMessage());
            request.setAttribute("error", "Registration failed. This email may already be in use.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (u != null) { // Đăng ký thành công
            
            // =========================================================
            // A. GÁN DỮ LIỆU VÀO SESSION (TỰ ĐỘNG ĐĂNG NHẬP) 🚀
            // =========================================================
            HttpSession session = request.getSession(); // Lấy hoặc tạo Session mới
            
            // Lưu toàn bộ đối tượng User (phương pháp tốt nhất)
            session.setAttribute("user", u);
            
            // Lưu các thông tin cá nhân quan trọng vào Session
            session.setAttribute("email", u.getEmail());
            // Giả sử Users class có phương thức getId()
            // session.setAttribute("id_user", u.getId()); 

            String roleValue = (u.getRole() != null) ? u.getRole().toString() : "1"; // Mặc định role là 1 (người dùng)
            session.setAttribute("role", roleValue); 

            // Loại bỏ logic Cookie đã cũ
            
            // Bước 4: Chuyển hướng đến trang chủ
            response.sendRedirect("homepage.jsp");

        } else {
            // Đăng ký thất bại (Lỗi không xác định hoặc DAO trả về null)
            request.setAttribute("error", "Registration failed due to an unexpected error.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles user registration and subsequent automatic login using Session.";
    }
}