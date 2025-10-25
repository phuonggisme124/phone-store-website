package controller;

import dao.ProductDAO;
import dao.PromotionsDAO;
import dao.VariantsDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Category;
import model.Products;
import model.Promotions;
import model.Users;
import model.Variants;

@WebServlet(name = "HomepageServlet", urlPatterns = {"/homepage"})
public class HomepageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ====== KIỂM TRA ROLE ======
//        HttpSession session = request.getSession();
//        Users currentUser = (Users) session.getAttribute("user");
        // ====== NHẬN ACTION ======
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "viewhomepage"; // Mặc định
        }

        // ====== KHAI BÁO DAO ======
        ProductDAO pdao = new ProductDAO();
        VariantsDAO vdao = new VariantsDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();

        try {
            if ("viewhomepage".equals(action)) {
                // ====== HIỂN THỊ TRANG CHỦ ======
                List<Products> productList = pdao.getNewestProduct();
                List<Products> productList1 = pdao.getAllProduct();

                List<Variants> variantsList = vdao.getAllVariant();

                request.setAttribute("productList", productList);
                request.setAttribute("productList1", productList1);
                request.setAttribute("variantsList", variantsList);

                request.getRequestDispatcher("homepage.jsp").forward(request, response);

            } else {
                // ====== ACTION KHÔNG HỢP LỆ → QUAY VỀ TRANG CHỦ ======
                response.sendRedirect("homepage?action=viewhomepage");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error in HomepageServlet: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
