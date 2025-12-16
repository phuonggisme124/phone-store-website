<%@page import="model.Staff"%>
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
<<<<<<< HEAD
<%@page import="model.Users"%>
=======

>>>>>>> 62bad43794ed9e6ec4e6d026e91b6a10331a6e66
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Order Details</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_manageorder.css">
        
        
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>
            <% 
                Staff user = (Staff) session.getAttribute("user");
                ProductDAO pdao = new ProductDAO();
                List<InterestRate> listInterestRate = (List<InterestRate>) request.getAttribute("listInterestRate");
                List<Payments> listPayments = (List<Payments>) request.getAttribute("listPayments");
                List<OrderDetails> listOrderDetails = (List<OrderDetails>) request.getAttribute("listOrderDetails");
                
                Boolean isInstalmentObj = (Boolean) request.getAttribute("isIntalment");
                boolean isInstalment = (isInstalmentObj != null) ? isInstalmentObj : false;

                if(listOrderDetails == null) listOrderDetails = new ArrayList<>();
                if(listPayments == null) listPayments = new ArrayList<>();
                if(listInterestRate == null) listInterestRate = new ArrayList<>();
            %>

            <div class="page-content flex-grow-1">
                
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">
                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>
                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="position-relative">
<<<<<<< HEAD
                                        <img src="https://i.pravatar.cc/150?u=<%= (user != null) ? user.getUserId() : "admin" %>" 
=======
                                        <img src="https://i.pravatar.cc/150?u=<%= (user != null) ? user.getStaffID(): "admin" %>" 
>>>>>>> 62bad43794ed9e6ec4e6d026e91b6a10331a6e66
                                             class="rounded-circle border border-2 border-white shadow-sm" 
                                             width="40" height="40" alt="Avatar">
                                        <span class="position-absolute bottom-0 start-100 translate-middle p-1 bg-success border border-light rounded-circle">
                                            <span class="visually-hidden">Online</span>
                                        </span>
                                    </div>
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;"><%= (user != null) ? user.getFullName() : "Administrator" %></span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                    </div>
                                </div>
                                <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" 
                                   style="width: 38px; height: 38px;" title="Logout">
                                    <i class="bi bi-box-arrow-right fs-6"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4 pt-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Order Details</h4>
                            <p class="text-muted small mb-0">View products and payment information</p>
                        </div>
                        <a href="order?action=manageOrder" class="btn btn-outline-secondary rounded-pill btn-sm px-3">
                            <i class="bi bi-arrow-left me-1"></i> Back to Orders
                        </a>
                    </div>
                </div>

                <div class="container-fluid px-4 mb-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white py-3 border-bottom">
                            <h6 class="mb-0 fw-bold text-primary"><i class="bi bi-box-seam me-2"></i>Items Ordered</h6>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table align-middle mb-0 custom-table">
                                    <thead class="bg-light-purple">
                                        <tr>
                                            <th class="ps-4">Product</th>
                                            <th>Specs</th>
                                            <th>Price</th>
                                            <th>Qty</th>
                                            <% if (isInstalment) { %>
                                                <th>Period</th>
                                                <th>Monthly Pay</th>
                                                <th>Interest</th>
                                            <% } %>
                                            <th class="text-end pe-4">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (OrderDetails od : listOrderDetails) { %>
                                        <tr>
                                            <td class="ps-4 fw-bold text-dark">
                                                <%= pdao.getNameByID(od.getVariant().getProductID())%>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border"><%= od.getVariant().getColor()%></span>
                                                <span class="badge bg-light text-dark border"><%= od.getVariant().getStorage()%></span>
                                            </td>
                                            <td><%= String.format("%,.0f", od.getUnitPrice())%> ₫</td>
                                            <td>x<%= od.getQuantity()%></td>
                                            
                                            <% if (isInstalment) { 
                                                String period = "N/A";
                                                for (InterestRate iR : listInterestRate) {
                                                    if (od.getInterestRateID() == iR.getInterestRateID()) {
                                                        period = iR.getInstalmentPeriod() + " Months";
                                                        break;
                                                    }
                                                }
                                            %>
                                                <td><span class="badge bg-info-subtle text-info"><%= period %></span></td>
                                                <td class="fw-bold text-danger"><%= String.format("%,.0f", od.getMonthlyPayment())%> ₫</td>
                                                <td><%= od.getInterestRate()%> %</td>
                                            <% } %>

                                            <td class="text-end pe-4 fw-bold text-primary">
                                                <%= String.format("%,.0f", od.getUnitPrice() * od.getQuantity())%> ₫
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <% if (isInstalment) { %>
                <div class="container-fluid px-4 mb-5">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white py-3 border-bottom">
                            <h6 class="mb-0 fw-bold text-success"><i class="bi bi-calendar-check me-2"></i>Payment Schedule (Instalment)</h6>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table align-middle mb-0 custom-table">
                                    <thead class="bg-light-purple">
                                        <tr>
                                            <th class="ps-4">ID</th>
                                            <th>Month</th>
                                            <th>Amount Due</th>
                                            <th>Due Date</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Payments p : listPayments) { %>
                                        <tr>
                                            <td class="ps-4 text-muted">#<%= p.getPaymentID()%></td>
                                            <td class="fw-bold">Month <%= p.getCurrentMonth()%> / <%= p.getTotalMonth()%></td>
                                            <td class="fw-bold text-danger"><%= String.format("%,.0f", p.getAmount())%> ₫</td>
                                            <td>
                                                <span class="d-inline-flex align-items-center text-muted small bg-light rounded px-2 py-1 border">
                                                    <i class="bi bi-calendar3 me-2"></i> <%= p.getPaymentDate()%>
                                                </span>
                                            </td>
                                            <td>
                                                <% if("Paid".equalsIgnoreCase(p.getPaymentStatus())) { %>
                                                    <span class="badge bg-success-subtle text-success rounded-pill px-3"><i class="bi bi-check-circle me-1"></i> Paid</span>
                                                <% } else { %>
                                                    <span class="badge bg-warning-subtle text-warning rounded-pill px-3"><i class="bi bi-hourglass-split me-1"></i> Unpaid</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } %>
                                        
                                        <% if(listPayments.isEmpty()) { %>
                                            <tr><td colspan="5" class="text-center py-4 text-muted fst-italic">No payment records found.</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/dashboard.js"></script>

        <script>
            // Sidebar Toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
</html>