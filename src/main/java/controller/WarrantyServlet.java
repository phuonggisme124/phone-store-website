package controller;

import dao.WarrantyDAO;
import dao.WarrantyClaimDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Customer;
import model.Warranty;

@WebServlet(name = "WarrantyServlet", urlPatterns = {"/warranty"})
public class WarrantyServlet extends HttpServlet {

    private final WarrantyDAO warrantyDAO = new WarrantyDAO();
    private final WarrantyClaimDAO claimDAO = new WarrantyClaimDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");

        if (!(userObj instanceof Customer)) {
            response.sendRedirect("login.jsp");
            return;
        }

        Customer customer = (Customer) userObj;
        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {
            System.out.println("--- DEBUG WARRANTY ---");
            System.out.println("Đang truy vấn cho CustomerID: " + customer.getCustomerID());

            List<Warranty> warranties = warrantyDAO.getWarrantyByCustomer(customer.getCustomerID());
            System.out.println("Số lượng bản ghi tìm thấy trong DB: " + (warranties != null ? warranties.size() : "NULL"));

            request.setAttribute("warranties", warranties);
            request.getRequestDispatcher("customer/warranty.jsp")
                    .forward(request, response);
            return;
        }
        if (action.equals("claim")) {
            int warrantyID = Integer.parseInt(request.getParameter("warrantyID"));

            // Lấy đầy đủ thông tin bảo hành để hiển thị lên form claim
            Warranty w = warrantyDAO.getWarrantyByID(warrantyID);

            if (w == null || !"active".equalsIgnoreCase(w.getStatus())) {
                request.setAttribute("error", "Bảo hành không tồn tại hoặc không còn hiệu lực.");
                // Quay lại trang danh sách nếu có lỗi
                List<Warranty> warranties = warrantyDAO.getWarrantyByCustomer(customer.getCustomerID());
                request.setAttribute("warranties", warranties);
                request.getRequestDispatcher("customer/warranty.jsp").forward(request, response);
                return;
            }

            request.setAttribute("warranty", w); // Đặt đối tượng warranty vào request
            // SỬA Ở ĐÂY: forward đúng tên file claim.jsp
            request.getRequestDispatcher("customer/claim.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");

        if (!(userObj instanceof Customer)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("submitClaim".equals(action)) {
            int warrantyID = Integer.parseInt(request.getParameter("warrantyID"));
            String reason = request.getParameter("reason");

            if (!warrantyDAO.isWarrantyValid(warrantyID)) {
                request.setAttribute("error", "Bảo hành không còn hiệu lực.");
                request.setAttribute("warrantyID", warrantyID);
                request.getRequestDispatcher("customer/warranty_claim.jsp")
                        .forward(request, response);
                return;
            }

            claimDAO.createClaim(warrantyID, reason);
            response.sendRedirect("warranty");
        }
    }
}
