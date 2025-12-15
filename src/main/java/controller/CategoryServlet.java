package controller;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.InstallmentDetailDAO;
import dao.ProductDAO;
import dao.ProfitDAO;
import dao.PromotionsDAO;
import dao.ReviewDAO;
import dao.SupplierDAO;
import dao.CustomerDAO;
import dao.VariantsDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Category;

/**
 *
 * @author duynu
 */
@WebServlet(name = "CategoryServlet", urlPatterns = {"/category"})
public class CategoryServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP GET and POST methods.
     */
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

    /**
     * Handles the HTTP GET method.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        // DAO khởi tạo
        CustomerDAO udao = new CustomerDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        ReviewDAO rdao = new ReviewDAO();
        OrderDAO odao = new OrderDAO();
        InstallmentDetailDAO paydao = new InstallmentDetailDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        ProfitDAO pfdao = new ProfitDAO();

        switch (action) {
            case "manageCategory": {
                List<Category> listCategory = ctdao.getAllCategories();
                request.setAttribute("listCategory", listCategory);
                request.getRequestDispatcher("admin/dashboard_admin_managecategory.jsp")
                        .forward(request, response);
                break;
            }

            case "editCategory": {
                int cateID = Integer.parseInt(request.getParameter("id"));
                Category category = ctdao.getCategoryByCategoryID(cateID);
                request.setAttribute("catergory", category);
                request.getRequestDispatcher("admin/admin_managecategory_edit.jsp")
                        .forward(request, response);
                break;
            }

            case "createCategory": {
                request.getRequestDispatcher("admin/admin_managecategory_create.jsp")
                        .forward(request, response);
                break;
            }

            default:
                response.sendRedirect("admin/dashboard.jsp");
                break;
        }
    }

    /**
     * Handles the HTTP POST method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        CategoryDAO ctdao = new CategoryDAO();

        if ("updateCategory".equals(action)) {

            int cateID = Integer.parseInt(request.getParameter("cateID"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            ctdao.editCategory(cateID, name, description);
            response.sendRedirect("category?action=manageCategory");

        } else if ("deleteCategory".equals(action)) {

            int cateID = Integer.parseInt(request.getParameter("cateID"));
            ctdao.removeCategory(cateID);
            response.sendRedirect("category?action=manageCategory");

        } else if ("createCategory".equals(action)) {

            String name = request.getParameter("name");
            String description = request.getParameter("description");

            ctdao.createCategory(name, description);
            response.sendRedirect("category?action=manageCategory");

        } else {
            response.sendRedirect("category?action=manageCategory");
        }
    }

    @Override
    public String getServletInfo() {
        return "Category management servlet";
    }
}
