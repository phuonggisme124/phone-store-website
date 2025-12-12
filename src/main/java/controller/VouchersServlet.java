///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller;
//
//import dao.VouchersDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.sql.Date;
//import model.Vouchers;
//
///**
// *
// * @author USER
// */
//@WebServlet(name = "VouchersServlet", urlPatterns = {"/vouchers"})
//public class VouchersServlet extends HttpServlet {
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
//            out.println("<title>Servlet VoucherServlet</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet VoucherServlet at " + request.getContextPath() + "</h1>");
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
//        String action = request.getParameter("action");
//        if (action == null) {
//            action = "homepage";
//        }
//        if (action.equals("CreateVoucher")) {
//            request.getRequestDispatcher("admin/admin_createvouchers.jsp").forward(request, response);
//        } else {
//            request.getRequestDispatcher("admin/admin_manage_voucher.jsp").forward(request, response);
//        }
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
//        String action = request.getParameter("action");
//        VouchersDAO voucher = new VouchersDAO();
//        try {
//            if (action.equals("insert")) {
//                String code = request.getParameter("code");
//                String percentStr = request.getParameter("percent");
//                String startStr = request.getParameter("startDay"); // format yyyy-MM-dd từ input type date
//                String endStr = request.getParameter("endDay");
//                String quantityStr = request.getParameter("quantity");
//                String status = "Active"; // Mặc định là Active hoặc lấy từ form
//
//                // 2. Validate và Convert dữ liệu
//                int percent = Integer.parseInt(percentStr);
//                int quantity = Integer.parseInt(quantityStr);
//                Date startDay = Date.valueOf(startStr); // Chuyển String "2024-05-20" thành SQL Date
//                Date endDay = Date.valueOf(endStr);
//
//                // Kiểm tra Logic cơ bản: Ngày kết thúc phải sau ngày bắt đầu
//                if (endDay.before(startDay)) {
//                    request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu!");
//                    request.getRequestDispatcher("admin/create_voucher.jsp").forward(request, response);
//                    return;
//                }
//
//                // 3. Tạo đối tượng Model
//                Vouchers newVoucher = new Vouchers(code, percent, startDay, endDay, quantity, status);
//
//                // 4. Gọi DAO để lưu
//                voucher.createVoucher(newVoucher);
//
//                // 5. Thông báo và chuyển hướng
//                response.sendRedirect("manage-voucher?action=list");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            // Nếu lỗi định dạng số hoặc ngày tháng
//            request.setAttribute("error", "Dữ liệu nhập vào không hợp lệ!");
//            request.getRequestDispatcher("admin/create_voucher.jsp").forward(request, response);
//        }
//    }
//
//}
//
//}
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     * @return a String containing servlet description
//     */
//    @Override
//public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
