<%@page import="model.InterestRate"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Payments"%>
<%@page import="model.OrderDetails"%>
<%@page import="model.Sale"%>
<%@page import="model.Order"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Order Details</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
    </head>
    <body>
        <%
            // Lấy thông tin User đăng nhập
            Users user = (Users) session.getAttribute("user");
            
            // Lấy dữ liệu từ Servlet gửi sang
            ProductDAO pdao = new ProductDAO();
            List<InterestRate> listInterestRate = (List<InterestRate>) request.getAttribute("listInterestRate");
            List<Payments> listPayments = (List<Payments>) request.getAttribute("listPayments");
            List<OrderDetails> listOrderDetails = (List<OrderDetails>) request.getAttribute("listOrderDetails");
            
            // SỬA LỖI: Nhận kiểu Boolean thay vì byte
            Boolean isInstalmentObj = (Boolean) request.getAttribute("isIntalment");
            boolean isInstalment = (isInstalmentObj != null) ? isInstalmentObj : false;

            if(listOrderDetails == null) listOrderDetails = new ArrayList<>();
            if(listPayments == null) listPayments = new ArrayList<>();
            if(listInterestRate == null) listInterestRate = new ArrayList<>();
        %>

        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm mb-4">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <div class="d-flex align-items-center ms-auto">
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= user != null ? user.getFullName() : "Admin" %></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="text-primary fw-bold">Order Details</h2>
                        
                    </div>
                </div>

                <div class="container-fluid px-4 mb-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0 fw-bold text-secondary"><i class="bi bi-cart-check me-2"></i>Products in Order</h5>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Product Name</th>
                                        <th>Color</th>
                                        <th>Storage</th>
                                        <th>Unit Price</th>
                                        <th>Quantity</th>
                                        <% if (isInstalment) { %>
                                            <th>Instalment Period</th>
                                            <th>Monthly Payment</th>                                    
                                            <th>Interest Rate</th>
                                        <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (OrderDetails od : listOrderDetails) { %>
                                    <tr>
                                        <td><span class="fw-bold"><%= pdao.getNameByID(od.getVariant().getProductID())%></span></td>
                                        <td><%= od.getVariant().getColor()%></td>
                                        <td><%= od.getVariant().getStorage()%></td>
                                        <td><%= String.format("%,.0f", od.getVariant().getPrice())%> ₫</td>
                                        <td><%= od.getQuantity()%></td>
                                        
                                        <% if (isInstalment) { 
                                            String period = "N/A";
                                            // Tìm thông tin kỳ hạn trả góp
                                            for (InterestRate iR : listInterestRate) {
                                                if (od.getInterestRateID() == iR.getInterestRateID()) {
                                                    period = iR.getInstalmentPeriod() + " Months";
                                                    break;
                                                }
                                            }
                                        %>
                                            <td><span class="badge bg-info text-dark"><%= period %></span></td>
                                            <td class="fw-bold text-danger"><%= String.format("%,.0f", od.getMonthlyPayment())%> ₫</td>
                                            <td><%= od.getInterestRate()%> %</td>
                                        <% } %>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <% if (isInstalment) { %>
                <div class="container-fluid px-4 mb-5">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0 fw-bold text-secondary"><i class="bi bi-calendar-check me-2"></i>Payment Schedule</h5>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Month</th>
                                        <th>Amount</th>
                                        <th>Due Date</th>
                                        <th>Status</th> 
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Payments p : listPayments) { %>
                                    <tr>
                                        <td>#<%= p.getPaymentID()%></td>
                                        <td>Month <%= p.getCurrentMonth()%> / <%= p.getTotalMonth()%></td>
                                        <td class="fw-bold"><%= String.format("%,.0f", p.getAmount())%> ₫</td>
                                        <td><%= p.getPaymentDate()%></td>
                                        <td>
                                            <% if("Paid".equalsIgnoreCase(p.getPaymentStatus())) { %>
                                                <span class="badge bg-success">Paid</span>
                                            <% } else { %>
                                                <span class="badge bg-warning text-dark">Unpaid</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                    
                                    <% if(listPayments.isEmpty()) { %>
                                        <tr><td colspan="5" class="text-center py-3">No payment records found.</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } %>

            </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
</html>