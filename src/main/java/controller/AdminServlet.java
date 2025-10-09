/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.PaymentsDAO;
import dao.ProductDAO;
import dao.PromotionsDAO;
import dao.SupplierDAO;
import dao.UsersDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import model.Category;
import model.Order;
import model.OrderDetails;
import model.Payments;
import model.Products;
import model.Promotions;
import model.Sale;
import model.Suppliers;
import model.Users;
import model.Variants;

/**
 *
 * @author duynu
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

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
            out.println("<title>Servlet AdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminServlet at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        UsersDAO udao = new UsersDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        OrderDAO odao = new OrderDAO();
        PaymentsDAO paydao = new PaymentsDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        if (action == null) {
            action = "dashboard";
        }

        if (action.equals("editAccount")) {

            int id = Integer.parseInt(request.getParameter("id"));
            Users user = udao.getUserByID(id);
            request.setAttribute("user", user);

            request.getRequestDispatcher("admin_manageuser_edit.jsp").forward(request, response);
        } else if (action.equals("manageUser")) {
            List<Users> listUsers = udao.getAllUsers();
            request.setAttribute("listUsers", listUsers);

            request.getRequestDispatcher("dashboard_admin_manageuser.jsp").forward(request, response);
        } else if (action.equals("createAccount")) {
            request.getRequestDispatcher("admin_manageuser_create.jsp").forward(request, response);
        } else if (action.equals("manageProduct")) {
            List<Products> listProducts = pdao.getAllProduct();
            List<Category> listCategory = ctdao.getAllCategories();
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listCategory", listCategory);
            request.setAttribute("listSupplier", listSupplier);
            request.getRequestDispatcher("dashboard_admin_manageproduct.jsp").forward(request, response);
        } else if (action.equals("productDetail")) {

            int id = Integer.parseInt(request.getParameter("id"));
            List<Variants> listVariants = vdao.getAllVariantByProductID(id);
            List<Products> listProducts = pdao.getAllProduct();
            //Promotions promotion = pmtdao.getPromotionByProductID(id);

            request.setAttribute("productID", id);
            //request.setAttribute("promotion", promotion);
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listVariants", listVariants);

            request.getRequestDispatcher("admin_manageproduct_detail.jsp").forward(request, response);
        } else if (action.equals("editProduct")) {
            int vid = Integer.parseInt(request.getParameter("vid"));
            int pid = Integer.parseInt(request.getParameter("pid"));

            Variants variant = vdao.getVariantByID(vid);
            Products product = pdao.getProductByID(pid);
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            request.setAttribute("variant", variant);
            request.setAttribute("product", product);
            request.setAttribute("listSupplier", listSupplier);

            request.getRequestDispatcher("admin_manageproduct_edit.jsp").forward(request, response);
        } else if (action.equals("createProduct")) {
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            List<Category> listCategories = ctdao.getAllCategories();
            request.setAttribute("listSupplier", listSupplier);
            request.setAttribute("listCategories", listCategories);
            request.getRequestDispatcher("admin_manageproduct_create.jsp").forward(request, response);
        } else if (action.equals("createVariant")) {
            int pid = Integer.parseInt(request.getParameter("pid"));
            Products product = pdao.getProductByID(pid);

            request.setAttribute("product", product);
            request.setAttribute("productID", pid);
            request.getRequestDispatcher("admin_manageproduct_createvariant.jsp").forward(request, response);
        } else if (action.equals("deleteProduct")) {
            int pid = Integer.parseInt(request.getParameter("pid"));
            vdao.deleteVariantByProductID(pid);
            pdao.deleteProductByProductID(pid);
            response.sendRedirect("admin?action=manageProduct");
        } else if (action.equals("manageSupplier")) {
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            request.setAttribute("listSupplier", listSupplier);

            request.getRequestDispatcher("dashboard_admin_managesupplier.jsp").forward(request, response);
        } else if (action.equals("editSupplier")) {
            int supplierID = Integer.parseInt(request.getParameter("id"));

            Suppliers supplier = sldao.getSupplierByID(supplierID);
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("admin_managesupplier_edit.jsp").forward(request, response);
        } else if (action.equals("createSupplier")) {

            request.getRequestDispatcher("admin_managesupplier_create.jsp").forward(request, response);
        } else if (action.equals("managePromotion")) {
            List<Products> listProducts = pdao.getAllProduct();
            List<Promotions> listPromotions = pmtdao.getAllPromotion();

            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listPromotions", listPromotions);

            request.getRequestDispatcher("dashboard_admin_managepromotion.jsp").forward(request, response);
        } else if (action.equals("editPromotion")) {
            int pmtID = Integer.parseInt(request.getParameter("pmtID"));
            int pID = Integer.parseInt(request.getParameter("pID"));
            Promotions promotion = pmtdao.getPromotionByID(pmtID);
            Products product = pdao.getProductByID(pID);

            request.setAttribute("promotion", promotion);
            request.setAttribute("product", product);

            request.getRequestDispatcher("admin_managepromotion_edit.jsp").forward(request, response);
        }else if(action.equals("createPromotion")){
            List<Products> listProducts = pdao.getAllProduct();
            request.setAttribute("listProducts", listProducts);
            request.getRequestDispatcher("admin_managepromotion_create.jsp").forward(request, response);
        } else if(action.equals("manageOrder")){
            List<Order> listOrder = odao.getAllOrders();
            List<Users> listUsers = udao.getAllUsers();
            List<Sale> listSales = udao.getAllSales();
            request.setAttribute("listOrder", listOrder);
            request.setAttribute("listUsers", listUsers);
            request.setAttribute("listSales", listSales);
            request.getRequestDispatcher("dashboard_admin_manageorder.jsp").forward(request, response);
        }else if(action.equals("orderDetail")){
            int oid = Integer.parseInt(request.getParameter("id"));
            boolean isIntalment = Boolean.parseBoolean(request.getParameter("isInstalment"));
            List<OrderDetails> listOrderDetails = odao.getAllOrderDetailByOrderID(oid);
            List<Payments> listPayments = paydao.getPaymentByOrderID(oid);
            List<Products> listProducts = pdao.getAllProduct();
            List<Variants> listVariant = vdao.getAllVariant();
            request.setAttribute("listOrderDetails", listOrderDetails);
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listVariant", listVariant);
            request.setAttribute("listPayments", listPayments);
            request.setAttribute("isIntalment", isIntalment);
            request.getRequestDispatcher("admin_manageorder_detail.jsp").forward(request, response);
        }
        else {
            request.getRequestDispatcher("dashboard_admin.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        UsersDAO udao = new UsersDAO();
        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        PromotionsDAO pmtdao = new PromotionsDAO();
        if (action.equals("update")) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            int role = Integer.parseInt(request.getParameter("role"));
            String status = request.getParameter("status");

            udao.updateUser(userId, name, email, phone, address, role, status);

            response.sendRedirect("admin?action=manageUser");

        } else if (action.equals("createAccount")) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            int role = Integer.parseInt(request.getParameter("role"));

            udao.register(name, email, phone, address, password, role);
            response.sendRedirect("admin?action=manageUser");
        } else if (action.equals("delete")) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            udao.deleteUser(userId);

            response.sendRedirect("admin?action=manageUser");
        } else if (action.equals("updateProduct")) {

            int vID = Integer.parseInt(request.getParameter("vID"));
            int pID = Integer.parseInt(request.getParameter("pID"));
            String pName = request.getParameter("pName");
            String brand = request.getParameter("brand");
            String color = request.getParameter("color");
            String storage = request.getParameter("storage");
            double price = Double.parseDouble(request.getParameter("price"));
            int warrantyPeriod = Integer.parseInt(request.getParameter("warrantyPeriod"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            int supplierID = Integer.parseInt(request.getParameter("supplierID"));
            String description = request.getParameter("description");
            String img = request.getParameter("img");

            vdao.updateVariant(vID, color, storage, price, stock, description, img);
            pdao.updateProduct(pID, supplierID, pName, brand, warrantyPeriod);

            response.sendRedirect("admin?action=manageProduct");

        } else if (action.equals("createProduct")) {
            String pName = request.getParameter("pName");
            int categoryID = Integer.parseInt(request.getParameter("category"));
            String brand = request.getParameter("brand");
            int warrantyPeriod = Integer.parseInt(request.getParameter("warrantyPeriod"));
            int supplierID = Integer.parseInt(request.getParameter("supplierID"));

            pdao.createProduct(categoryID, supplierID, pName, brand, warrantyPeriod);

            response.sendRedirect("admin?action=manageProduct");
        } else if (action.equals("createVariant")) {
            int pID = Integer.parseInt(request.getParameter("pID"));
            String pName = request.getParameter("pName");
            String color = request.getParameter("color");
            String storage = request.getParameter("storage");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");
            String img = request.getParameter("img");

            vdao.createVariant(pID, color, storage, price, stock, description, img);
            response.sendRedirect("admin?action=productDetail&id=" + pID);
        } else if (action.equals("deleteVariant")) {
            int vID = Integer.parseInt(request.getParameter("vID"));
            int pID = Integer.parseInt(request.getParameter("pID"));
            vdao.deleteVariantByID(vID);

            response.sendRedirect("admin?action=productDetail&id=" + pID);
        } else if (action.equals("updateSupplier")) {
            int sID = Integer.parseInt(request.getParameter("sID"));
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            sldao.updateSupplier(sID, name, phone, email, address);

            response.sendRedirect("admin?action=manageSupplier");
        } else if (action.equals("createSupplier")) {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            sldao.createSupplier(name, phone, email, address);
            response.sendRedirect("admin?action=manageSupplier");
        } else if (action.equals("deleteSupplier")) {
            int sID = Integer.parseInt(request.getParameter("sID"));

            sldao.deleteSupplier(sID);
            response.sendRedirect("admin?action=manageSupplier");
        } else if (action.equals("updatePromotion")) {
            int pmtID = Integer.parseInt(request.getParameter("pmtID"));
            int pID = Integer.parseInt(request.getParameter("pID"));
            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            LocalDateTime startDate = LocalDateTime.parse(request.getParameter("startDate"));
            LocalDateTime endDate = LocalDateTime.parse(request.getParameter("endDate"));
            String status = request.getParameter("status");
            
            pmtdao.updatePromotion(pmtID, pID, discountPercent, startDate, endDate, status);
            
            vdao.updateDiscountPrice();
            
            response.sendRedirect("admin?action=managePromotion");
        }else if(action.equals("createPromotion")){
            int pID = Integer.parseInt(request.getParameter("pID"));
            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            LocalDateTime startDate = LocalDate.parse(request.getParameter("startDate")).atStartOfDay();
            LocalDateTime endDate = LocalDate.parse(request.getParameter("endDate")).atStartOfDay();
            String status = "active";
            
            pmtdao.createPromotion(pID, discountPercent, startDate, endDate, status);
            vdao.updateDiscountPrice();
            response.sendRedirect("admin?action=managePromotion");
            
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
