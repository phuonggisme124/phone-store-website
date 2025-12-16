/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import dao.ImportDAO;
import dao.ProductDAO;
import dao.SupplierDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Import;
import model.ImportDetail;
import model.Products;
import model.Suppliers;
import model.Staff; // [QUAN TRỌNG] Đã thêm model Staff
import model.Variants;

/**
 *
 * @author USER
 */
@MultipartConfig
@WebServlet(name = "ImportProductServlet", urlPatterns = {"/importproduct"})
public class ImportProductServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ImportProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ImportProductServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        ProductDAO pdao = new ProductDAO();
        SupplierDAO sldao = new SupplierDAO();
        CategoryDAO ctdao = new CategoryDAO();
        VariantsDAO vdao = new VariantsDAO();
        ImportDAO idao = new ImportDAO();

        String action = request.getParameter("action");

        if (action == null) {
            action = "default";
        }

        // Kiểm tra quyền truy cập (Optional - tránh lỗi null khi chưa login)
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        if (userObj != null && !(userObj instanceof Staff)) {
            // Nếu đã login nhưng không phải Staff (ví dụ là Customer) -> Đá về home hoặc login
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            if (action.equals("staff_import")) {
                // Xem lịch sử nhập
                List<Import> list = idao.getAllImports();
                request.setAttribute("listImports", list);
                request.getRequestDispatcher("staff/staff_import_history.jsp").forward(request, response);

            } else if (action.equals("showImportForm")) {
                // Hiện form nhập hàng 
                List<Suppliers> listSup = sldao.getAllSupplier();
                request.setAttribute("listSup", listSup);

                List<Variants> listVar = vdao.getAllVariantsWithProductName();
                // --- THÊM ĐOẠN DEBUG NÀY ---
                if (listVar == null || listVar.isEmpty()) {
                    System.out.println("DEBUG: listVar bị RỖNG! Kiểm tra lại SQL trong VariantsDAO.");
                } else {
                    System.out.println("DEBUG: listVar có dữ liệu. Số lượng: " + listVar.size());
                    // Kiểm tra thử phần tử đầu tiên
                    System.out.println("DEBUG: Phần tử 1 - CategoryID: " + listVar.get(0).getCategoryID());
                }
                request.setAttribute("listVar", listVar);

                List<Products> listProducts = pdao.getAllProduct();
                request.setAttribute("listProducts", listProducts);
                List<Category> listCategories = ctdao.getAllCategories();
                request.setAttribute("listCategories", listCategories);

                request.getRequestDispatcher("staff/staff_importProduct.jsp").forward(request, response);

            } else if (action.equals("viewDetail")) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    // 1. Lấy danh sách sản phẩm trong phiếu đó
                    List<ImportDetail> listDetails = idao.getDetailsByImportID(id);

                    // 2. Gửi sang trang JSP chi tiết
                    request.setAttribute("listDetails", listDetails);
                    request.setAttribute("importID", id);

                    request.getRequestDispatcher("/staff/staff_import_detail.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                }

            } else if (action.equals("createProductPage")) {
                // 1. Lấy danh sách Category
                List<Category> listCategories = ctdao.getAllCategories();
                request.setAttribute("listCategories", listCategories);
                // 2. Lấy danh sách Supplier
                List<Suppliers> listSupplier = sldao.getAllSupplier();
                request.setAttribute("listSupplier", listSupplier);
                // 3. Chuyển hướng
                request.getRequestDispatcher("staff/staff_createProduct.jsp").forward(request, response);

            } else if (action.equals("createVariantPage")) {
                List<Products> listProducts = pdao.getAllProduct();
                request.setAttribute("listProducts", listProducts);
                request.getRequestDispatcher("staff/staff_createVariant.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            PrintWriter out = response.getWriter();
            out.println("<h1>ĐÃ CÓ LỖI XẢY RA!</h1>");
            out.println("<h3>Chi tiết lỗi: " + e.toString() + "</h3>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();

            // --- SỬA LỖI Ở ĐÂY: Thay vì Customer, ta lấy Staff ---
            Object userObj = session.getAttribute("user");
            Staff currentStaff = null;

            if (userObj instanceof Staff) {
                currentStaff = (Staff) userObj;
            } else {
                // Nếu người dùng không phải Staff (chưa login hoặc là Customer)
                response.sendRedirect("login.jsp");
                return;
            }

            // --- DEBUG LOG ---
            System.out.println("---------------- IMPORT PROCESS ----------------");
            System.out.println("Staff performing import: " + currentStaff.getFullName() + " (ID: " + currentStaff.getStaffID() + ")");
            // -----------------

            int supplierID = Integer.parseInt(request.getParameter("supplierID"));
            String note = request.getParameter("note");
            String[] variantID = request.getParameterValues("variantID");
            String[] qualities = request.getParameterValues("quantity");
            String[] costPrice = request.getParameterValues("costPrice");
            String[] discountPrices = request.getParameterValues("discountPrice");

            List<ImportDetail> listDetails = new ArrayList<>();
            double totalPrice = 0;

            if (variantID != null) {
                for (int i = 0; i < variantID.length; i++) {
                    int vID = Integer.parseInt(variantID[i]);
                    int qty = Integer.parseInt(qualities[i]);
                    double price = Double.parseDouble(costPrice[i]);
                    totalPrice += (qty * price); // tính tổng phiếu nhập  

                    // Parse giá bán (discountPrice)
                    double discountPrice = 0;
                    if (discountPrices != null && discountPrices.length > i && !discountPrices[i].trim().isEmpty()) {
                        try {
                            discountPrice = Double.parseDouble(discountPrices[i]);
                        } catch (NumberFormatException e) {
                            discountPrice = 0;
                        }
                    }

                    ImportDetail detail = new ImportDetail();
                    detail.setVariantID(vID);
                    detail.setQuality(qty);
                    detail.setCostPrice(price);
                    detail.setSellingPrice(discountPrice);
                    listDetails.add(detail);
                }
            }

            Import imp = new Import();
            // Sử dụng ID của Staff
            imp.setStaffID(currentStaff.getStaffID());

            imp.setSupplierID(supplierID);
            imp.setTotalCost(totalPrice);
            imp.setNote(note);
            imp.setStatus(0); // 0: Pending, 1: Completed

            ImportDAO dao = new ImportDAO();
            boolean result = dao.insertImportTransaction(imp, listDetails);

            if (result) {
                session.setAttribute("MESS", "Đã tạo phiếu nhập thành công! Vui lòng chờ Admin duyệt.");
                response.sendRedirect("importproduct?action=staff_import");
            } else {
                System.out.println("!!! LỖI: DAO trả về False !!!");
                request.setAttribute("ERROR", "Lỗi SQL: Không thể tạo phiếu nhập.");
                request.getRequestDispatcher("staff/staff_importProduct.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public String getServletInfo() {
        return "Import Product Servlet";
    }
}