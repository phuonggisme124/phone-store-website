package controller;

import com.google.gson.Gson;
import dao.CategoryDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.ReviewDAO;
import dao.SalesDAO;
import dao.SupplierDAO;
import dao.UsersDAO;
import dao.VariantsDAO;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.Order;
import model.Products;
import model.Review;
import model.Suppliers;
import model.Users;
import model.Variants;

@WebServlet(name = "StaffServlet", urlPatterns = {"/staff"})
public class StaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        UsersDAO udao = new UsersDAO();
        OrderDAO odao = new OrderDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        //đã xóa bản sales SalesDAO sdao = new SalesDAO();
        ReviewDAO rdao = new ReviewDAO();

        if (action == null) {
            action = "manageProduct";
        }

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null || currentUser.getRole() == null || currentUser.getRole() != 2) {
            response.sendRedirect("login");
            return;
        }

        // ========================= QUẢN LÝ ĐƠN HÀNG =========================
        if ("manageOrder".equals(action)) {
            List<Users> shippers = udao.getAllShippers();
            List<String> allPhones = udao.getAllBuyerPhones();
            request.setAttribute("allPhones", allPhones);

            String searchPhone = request.getParameter("phone");
            String status = request.getParameter("status");
            List<Order> listOrders;

            if (searchPhone != null && !searchPhone.trim().isEmpty() && status != null && !status.equalsIgnoreCase("All")) {
                listOrders = odao.getOrdersByPhoneAndStatus(searchPhone.trim(), status);
            } else if (searchPhone != null && !searchPhone.trim().isEmpty()) {
                listOrders = odao.getOrdersByPhone(searchPhone.trim());
            } else if (status != null && !status.equalsIgnoreCase("All")) {
                listOrders = odao.getOrdersByStatusForStaff(currentUser.getUserId(), status);
            } else {
                listOrders = odao.getAllOrderForStaff(currentUser.getUserId());
            }

            request.setAttribute("listOrders", listOrders);
            request.setAttribute("listShippers", shippers);
            request.getRequestDispatcher("staff/dashboard_staff_manageorder.jsp").forward(request, response);
        } // ========================= AJAX GỢI Ý SĐT =========================
        else if ("searchPhone".equals(action)) {
            String term = request.getParameter("term");
            List<String> phones = udao.getAllBuyerPhones();
            if (term != null && !term.isEmpty()) {
                phones = phones.stream().filter(p -> p.contains(term)).toList();
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(phones));
        } // ========================= GÁN SHIPPER =========================
        else if ("assignShipper".equals(action)) {
            try {
                int orderID = Integer.parseInt(request.getParameter("orderID"));
                int shipperID = Integer.parseInt(request.getParameter("shipperID"));

//                sdao.assignShipperForOrder(orderID, currentUser.getUserId(), shipperID);
//                odao.updateOrderStatus(orderID, "In Transit");
            } catch (NumberFormatException e) {
                System.err.println("Lỗi khi gán Shipper: " + e.getMessage());
            }
            response.sendRedirect("staff?action=manageOrder");
        } // ========================= QUẢN LÝ SẢN PHẨM =========================
        else if ("manageProduct".equals(action)) {
            String productName = request.getParameter("productName");
            String supplierIDStr = request.getParameter("supplierID");
            Integer supplierID = null;
            if (supplierIDStr != null && !supplierIDStr.equalsIgnoreCase("All")) {
                try {
                    supplierID = Integer.parseInt(supplierIDStr);
                } catch (NumberFormatException e) {
                    supplierID = null;
                }
            }

            List<Products> listProducts;
            if (productName != null && !productName.trim().isEmpty() && supplierID != null) {
                listProducts = pdao.getProductsByNameAndSupplier(productName.trim(), supplierID);
            } else if (productName != null && !productName.trim().isEmpty()) {
                listProducts = pdao.getProductsByName(productName.trim());
            } else if (supplierID != null) {
                listProducts = pdao.getProductsBySupplier(supplierID);
            } else {
                listProducts = pdao.getAllProduct();
            }

            List<Category> listCategory = ctdao.getAllCategories();
            List<Suppliers> listSupplier = sldao.getAllSupplier();

            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listCategory", listCategory);
            request.setAttribute("listSupplier", listSupplier);

            request.getRequestDispatcher("staff/dashboard_staff_manageproduct.jsp").forward(request, response);
        } // ========================= CHI TIẾT SẢN PHẨM (VARIANTS) =========================
        else if ("productDetail".equals(action)) {
            try {
                String productId = request.getParameter("productId");
                if (productId == null) {
                    productId = request.getParameter("id");
                }

                String color = request.getParameter("color");
                String storage = request.getParameter("storage");
                if (color != null && color.trim().isEmpty()) {
                    color = null;
                }
                if (storage != null && storage.trim().isEmpty()) {
                    storage = null;
                }

                List<Variants> listVariants;
                List<Products> listProducts = pdao.getAllProduct();

                if (productId != null && !productId.isEmpty()) {
                    int id = Integer.parseInt(productId);
                    if (color != null || storage != null) {
                        listVariants = vdao.searchVariantsByProductId(id, color, storage);
                    } else {
                        listVariants = vdao.getAllVariantByProductID(id);
                    }
                } else {
                    listVariants = vdao.searchVariants(color, storage);
                }

                request.setAttribute("listVariants", listVariants);
                request.setAttribute("listProducts", listProducts);
                request.setAttribute("allColors", vdao.getAllColors());
                request.setAttribute("allStorages", vdao.getAllStorages());
                request.setAttribute("selectedProductId", productId);

                request.getRequestDispatcher("staff/staff_manageproduct_detail.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }
        } // ========================= QUẢN LÝ REVIEW =========================
        else if ("manageReview".equals(action)) {
            try {
                List<Review> listReview = rdao.getAllReview();

                request.setAttribute("listReview", listReview);
                request.getRequestDispatcher("staff/staff_managereview.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }
        } else if (action.equals("reviewDetail")) {
            int rID = Integer.parseInt(request.getParameter("rID"));

            Review review = rdao.getReviewByID(rID);

            request.setAttribute("review", review);
            request.getRequestDispatcher("staff/staff_managereview_detail.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ReviewDAO reviewDAO = new ReviewDAO();

        if ("replyReview".equals(action)) {
            try {
                int reviewID = Integer.parseInt(request.getParameter("reviewID"));
                String reply = request.getParameter("reply");
                reviewDAO.replyToReview(reviewID, reply);
                response.sendRedirect("staff?action=manageReview");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }
        } else if (action.equals("replyReview")) {
            int rID = Integer.parseInt(request.getParameter("rID"));

            String reply = request.getParameter("reply");

            reviewDAO.updateReview(rID, reply);
            response.sendRedirect("staff?action=manageReview");

        }
    }

    @Override
    public String getServletInfo() {
        return "Staff Servlet for managing products, orders and reviews";
    }
}