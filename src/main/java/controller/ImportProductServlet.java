///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller;
//
//import dao.CategoryDAO;
//import dao.ImportDAO;
//import dao.OrderDAO;
//import dao.PaymentsDAO;
//import dao.ProductDAO;
//import dao.ProfitDAO;
//import dao.PromotionsDAO;
//import dao.ReviewDAO;
//import dao.SupplierDAO;
//import dao.CustomerDAO;
//import dao.VariantsDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.http.Part;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import jakarta.servlet.http.Part;
//import java.io.File;
//import java.sql.SQLException;
//import java.time.LocalDate;
//import java.time.LocalDateTime;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.stream.Collectors;
//import model.Category;
//import model.Import;
//import model.ImportDetail;
//import model.Products;
//import model.Profit;
//import model.Suppliers;
//import model.Customer;
//import model.Variants;
//
///**
// *
// * @author USER
// */
//@MultipartConfig
//@WebServlet(name = "ImportProductServlet", urlPatterns = {"/importproduct"})
//public class ImportProductServlet extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet ImportProductServlet</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet ImportProductServlet at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /**
//     * Handles the HTTP <code>GET</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        response.setCharacterEncoding("UTF-8");
//        CustomerDAO udao = new CustomerDAO();
//        ProductDAO pdao = new ProductDAO();
//        SupplierDAO sldao = new SupplierDAO();
//        CategoryDAO ctdao = new CategoryDAO();
//        VariantsDAO vdao = new VariantsDAO();
//        ImportDAO idao = new ImportDAO();
//
//        String action = request.getParameter("action");
//
//        // 2. Kiểm tra null để tránh NullPointerException nếu link không có ?action=...
//        if (action == null) {
//            action = "default";
//        }
//
//        try {
//            if (action.equals("staff_import")) {
//                //  Xem lịch sử nhập
//                List<Import> list = idao.getAllImports();
//                request.setAttribute("listImports", list);
//                request.getRequestDispatcher("staff/staff_import_history.jsp").forward(request, response);
//                return;
//
//            } else if (action.equals("showImportForm")) {
//                // Hiện form nhập hàng 
//                List<Suppliers> listSup = sldao.getAllSupplier();
//                request.setAttribute("listSup", listSup);
//
//                List<Variants> listVar = vdao.getAllVariantsWithProductName();
//                request.setAttribute("listVar", listVar);
//
//                List<Products> listProducts = pdao.getAllProduct();
//                request.setAttribute("listProducts", listProducts);
//                List<Category> listCategories = ctdao.getAllCategories();
//                request.setAttribute("listCategories", listCategories);
//
//                request.getRequestDispatcher("staff/staff_importProduct.jsp").forward(request, response);
//                return;
//            } else if (action.equals("viewDetail")) {
//                try {
//                    int id = Integer.parseInt(request.getParameter("id"));
//
//                    ImportDAO dao = new ImportDAO();
//                    // 1. Lấy danh sách sản phẩm trong phiếu đó
//                    List<ImportDetail> listDetails = dao.getDetailsByImportID(id);
//
//                    // 2. Gửi sang trang JSP chi tiết
//                    request.setAttribute("listDetails", listDetails);
//                    request.setAttribute("importID", id); // Gửi ID để hiện lên tiêu đề cho đẹp
//
//                    request.getRequestDispatcher("/staff/staff_import_detail.jsp").forward(request, response);
//                    return;
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//            } else if (action.equals("createProductPage")) {
//                // 1. Khởi tạo DAO
//                CategoryDAO cdao = new CategoryDAO();
//                SupplierDAO sdao = new SupplierDAO();
//                // 2. Lấy danh sách Category (Để hiện dropdown chọn loại SP)
//                List<Category> listCategories = cdao.getAllCategories();
//                request.setAttribute("listCategories", listCategories);
//                // 3. Lấy danh sách Supplier (Để hiện dropdown chọn NCC)
//                List<Suppliers> listSupplier = sdao.getAllSupplier();
//                request.setAttribute("listSupplier", listSupplier);
//                // 4. Chuyển hướng sang trang JSP nhập liệu
//                request.getRequestDispatcher("staff/staff_createProduct.jsp").forward(request, response);
//                return;
//            } else if (action.equals("createVariantPage")) {
//                List<Products> listProducts = pdao.getAllProduct();
//                request.setAttribute("listProducts", listProducts);
//                // 4. Chuyển hướng sang trang JSP nhập liệu
//                request.getRequestDispatcher("staff/staff_createVariant.jsp").forward(request, response);
//                return;
//            }
//
////            // Đoạn code cũ của bạn nằm lơ lửng ở dưới, giờ đưa vào luồng chính thức
////            List<Suppliers> listSup = sldao.getAllSupplier();
////            request.setAttribute("listSup", listSup);
////
////            List<Variants> listVar = vdao.getAllVariantsWithProductName();
////            request.setAttribute("listVar", listVar);
////
////            // Chuyển về trang mặc định (nếu có)
////            request.getRequestDispatcher("importProduct.jsp").forward(request, response);
//        } catch (Exception e) {
//            e.printStackTrace();
//            PrintWriter out = response.getWriter();
//            out.println("<h1>ĐÃ CÓ LỖI XẢY RA!</h1>");
//            out.println("<h3>Chi tiết lỗi: " + e.toString() + "</h3>");
//            out.println("<pre>");
//            e.printStackTrace(out); // In StackTrace ra màn hình web
//            out.println("</pre>");
//        }
//
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        VariantsDAO vdao = new VariantsDAO();
//        try {
//            HttpSession session = request.getSession();
//            Customer user = (Customer) session.getAttribute("user");
//            // --- BẮT ĐẦU ĐOẠN DEBUG ---
//            System.out.println("---------------- KIỂM TRA SESSION ----------------");
//            if (user == null) {
//                System.out.println("LỖI: User lấy từ Session bị NULL! Có thể sai tên attribute.");
//            } else {
//                System.out.println("OK: Tìm thấy User object.");
//                System.out.println("Tên User: " + user.getFullName());
//                System.out.println("ID User (getUserId): " + user.getUserId());
//                // Nếu dòng này in ra 0 -> Lỗi ở LoginDAO
//                // Nếu dòng này in ra 3 -> Lỗi ma thuật (rất hiếm, thường do chưa lưu file)
//            }
//            System.out.println("--------------------------------------------------");
//            int supplierID = Integer.parseInt(request.getParameter("supplierID"));
//            String note = request.getParameter("note");
//            String[] variantID = request.getParameterValues("variantID");
//            String[] qualities = request.getParameterValues("quantity");
//            String[] costPrice = request.getParameterValues("costPrice");
//            String[] discountPrices = request.getParameterValues("discountPrice");
//            List<ImportDetail> listDetails = new ArrayList<>();
//            double totalPrice = 0;
//            if (variantID != null) {
//                for (int i = 0; i < variantID.length; i++) {
//                    int vID = Integer.parseInt(variantID[i]);
//                    int qty = Integer.parseInt(qualities[i]);
//                    double price = Double.parseDouble(costPrice[i]);
//                    totalPrice += (qty * price); // tính tổng phiếu nhập  
//                    // Parse giá bán (thêm dòng này)
//                    double discountPrice = 0;
//                    if (discountPrices != null && discountPrices.length > i) {
//                        // Parse từ chuỗi discountPrice gửi lên
//                        discountPrice = Double.parseDouble(discountPrices[i]);
//                    }
//                    ImportDetail detail = new ImportDetail();
//                    detail.setVariantID(vID);
//                    detail.setQuality(qty);
//                    detail.setCostPrice(price);
//                    detail.setSellingPrice(discountPrice);
//                    listDetails.add(detail);
//
//                }
//            }
//            Import imp = new Import();
//            if (user != null) {
//                imp.setStaffID(user.getUserId());
//            } else {
//                imp.setStaffID(1);
//            }
//            imp.setSupplierID(supplierID);
//            imp.setTotalCost(totalPrice);
//            imp.setNote(note);
//            imp.setStatus(0);
//            ImportDAO dao = new ImportDAO();
//            boolean result = dao.insertImportTransaction(imp, listDetails);
//
////            vdao.updateDiscountPrice();
//            if (result) {
//                session.setAttribute("MESS", "Đã tạo phiếu nhập thành công! Vui lòng chờ Admin duyệt.");
//                response.sendRedirect("importproduct?action=staff_import");
//            } else {
//                //request.setAttribute("ERROR", "LỖI HỆ THỐNG, VUI LÒNG THỬ LẠI");
//                System.out.println("!!! LỖI: DAO trả về False !!!");
//                request.setAttribute("ERROR", "Lỗi SQL: Vui lòng xem Console Log của Server để biết chi tiết.");
//                request.getRequestDispatcher("staff/staff_importProduct.jsp").forward(request, response);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
