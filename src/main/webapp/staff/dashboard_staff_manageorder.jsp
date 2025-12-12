<%@page import="model.Staff"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="model.Order"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    /* ===== SESSION + ROLE CHECK (BẮT BUỘC) ===== */
    HttpSession s = request.getSession(false);
    if (s == null) {
        response.sendRedirect("login");
        return;
    }

    Integer role = (Integer) s.getAttribute("role");
    Object userObj = s.getAttribute("user");

    if (role == null || role != 2 || !(userObj instanceof Staff)) {
        response.sendRedirect("login");
        return;
    }

    Staff currentUser = (Staff) userObj;

    /* ===== SAFE DATA ===== */
    List<Order> orders = (List<Order>) request.getAttribute("listOrders");
    if (orders == null) orders = new ArrayList<>();

    List<Staff> shippers = (List<Staff>) request.getAttribute("listShippers");
    if (shippers == null) shippers = new ArrayList<>();

    List<String> allPhones = (List<String>) request.getAttribute("allPhones");
    if (allPhones == null) allPhones = new ArrayList<>();

    String currentPhone = request.getParameter("phone") != null
            ? request.getParameter("phone") : "";

    String currentStatus = request.getParameter("status") != null
            ? request.getParameter("status") : "";

    NumberFormat currencyFormatter =
            NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    currencyFormatter.setMaximumFractionDigits(0);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard - Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard_staff.css">
    <link href="css/dashboard_table.css" rel="stylesheet">
</head>

<body>

<script>
    const allPhones = <%= new Gson().toJson(allPhones) %>;
</script>

<div class="d-flex" id="wrapper">

    <!-- SIDEBAR -->
    <nav class="sidebar bg-white shadow-sm border-end">
        <div class="sidebar-header p-3">
            <h4 class="fw-bold text-primary">Mantis</h4>
        </div>
        <ul class="list-unstyled ps-3">
            <li><a href="product?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
            <li><a href="order?action=manageOrder" class="fw-bold text-primary"><i class="bi bi-bag me-2"></i>Orders</a></li>
            <li><a href="review?action=manageReview"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
            <li><a href="importproduct?action=staff_import"><i class="bi bi-truck me-2"></i>Import</a></li>
        </ul>
    </nav>

    <!-- CONTENT -->
    <div class="page-content flex-grow-1">

        <!-- NAVBAR -->
        <nav class="navbar navbar-light bg-white shadow-sm">
            <div class="container-fluid">
                <button class="btn btn-outline-primary" id="menu-toggle">
                    <i class="bi bi-list"></i>
                </button>

                <div class="ms-auto d-flex align-items-center">
                    <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                    <span class="fw-semibold"><%= currentUser.getFullName() %></span>
                </div>
            </div>
        </nav>

        <!-- BODY -->
        <div class="container-fluid p-4">

            <div class="card shadow-sm border-0 p-4">
                <h4 class="fw-bold mb-4">Manage Orders</h4>

                <% if (!orders.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Customer</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>Total</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>

                        <% for (Order o : orders) { %>
                        <tr>
                            <td>#<%= o.getOrderID() %></td>
                            <td><%= o.getBuyer() != null ? o.getBuyer().getFullName() : o.getReceiverName() %></td>
                            <td><%= o.getBuyer() != null ? o.getBuyer().getPhone() : o.getReceiverPhone() %></td>
                            <td><%= o.getShippingAddress() %></td>
                            <td><%= currencyFormatter.format(o.getTotalAmount()) %></td>
                            <td><%= o.getOrderDate() %></td>
                            <td><%= o.getStatus() %></td>
                            <td>
                                <% if ("pending".equalsIgnoreCase(o.getStatus())) { %>
                                    <button class="btn btn-sm btn-primary">Assign</button>
                                    <button class="btn btn-sm btn-danger">Cancel</button>
                                <% } else if (o.getShippers() != null) { %>
                                    <strong><%= o.getShippers().getFullName() %></strong>
                                <% } else { %>
                                    N/A
                                <% } %>
                            </td>
                        </tr>
                        <% } %>

                        </tbody>
                    </table>
                </div>
                <% } else { %>
                    <div class="alert alert-info">No orders available.</div>
                <% } %>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById("menu-toggle").addEventListener("click", function () {
        document.getElementById("wrapper").classList.toggle("toggled");
    });
</script>

</body>
</html>
