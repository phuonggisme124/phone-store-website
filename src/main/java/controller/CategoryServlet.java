/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Category;
import model.Staff; // Import model Staff để check quyền Admin

/**
 * Category Servlet - Handles Category Management (Admin only)
 */
@WebServlet(name = "CategoryServlet", urlPatterns = {"/category"})
public class CategoryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CategoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CategoryServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check Login & Admin Role
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        Staff currentStaff = null;

        if (userObj instanceof Staff) {
            currentStaff = (Staff) userObj;
        }

        // Nếu chưa đăng nhập hoặc không phải Admin (Role 4) -> Đá về trang Login
        if (currentStaff == null || currentStaff.getRole() != 4) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        CategoryDAO ctdao = new CategoryDAO();

        if (action == null) {
            action = "manageCategory"; // Mặc định vào trang quản lý
        }

        if (action.equals("manageCategory")) {
            List<Category> listCategory = ctdao.getAllCategories();
            request.setAttribute("listCategory", listCategory);
            request.getRequestDispatcher("admin/dashboard_admin_managecategory.jsp").forward(request, response);

        } else if (action.equals("editCategory")) {
            try {
                int cateID = Integer.parseInt(request.getParameter("id"));
                Category catergory = ctdao.getCategoryByCategoryID(cateID);
                request.setAttribute("catergory", catergory);
                request.getRequestDispatcher("admin/admin_managecategory_edit.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect("category?action=manageCategory");
            }
            
        } else if (action.equals("createCategory")) {
            request.getRequestDispatcher("admin/admin_managecategory_create.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check Login & Admin Role cho POST request
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        Staff currentStaff = null;
        if (userObj instanceof Staff) {
            currentStaff = (Staff) userObj;
        }
        if (currentStaff == null || currentStaff.getRole() != 4) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        CategoryDAO ctdao = new CategoryDAO();
        
        if (action == null) action = "";

        if (action.equals("updateCategory")) {
            try {
                int cateID = Integer.parseInt(request.getParameter("cateID"));
                String name = request.getParameter("name");
                String description = request.getParameter("description");

                ctdao.editCategory(cateID, name, description);
                response.sendRedirect("category?action=manageCategory");
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (action.equals("deleteCategory")) {
            try {
                int cateID = Integer.parseInt(request.getParameter("cateID"));
                System.out.println("Delete cateID: " + cateID);
                ctdao.removeCategory(cateID);
                response.sendRedirect("category?action=manageCategory");
            } catch (Exception e) {
                e.printStackTrace();
            }
            
        } else if (action.equals("createCategory")) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            ctdao.createCategory(name, description);
            response.sendRedirect("category?action=manageCategory");
        }
    }

    @Override
    public String getServletInfo() {
        return "Category Servlet";
    }
}