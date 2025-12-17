<%@page import="model.Staff"%>
<%@page import="java.util.List"%>
<%@page import="model.Order"%>
<%@page import="model.Users"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>STAFF Dashboard - Order Management</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                background-color: #f8f9fa;
            }
            .sidebar {
                width: 230px;
                min-height: 100vh;
            }
            .sidebar a {
                color: #333;
                text-decoration: none;
                display: block;
                padding: 10px 15px;
                border-radius: 6px;
            }
            .sidebar a.active, .sidebar a:hover {
                background-color: #0d6efd;
                color: #fff;
            }
            .page-content {
                background-color: #fff;
            }
            .card-header-staff {
                background-color: #f7f7f7;
                border-bottom: 1px solid #eee;
            }



        </style>
    </head>
    <body>
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            Staff currentUser = (Staff) session.getAttribute("user");

            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "US"));
            currencyFormatter.setMaximumFractionDigits(0);
        %>

        <div class="d-flex" id="wrapper">
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">STAFF Portal</h4>
                </div>
                <ul class="list-unstyled" style="padding-left: 0 !important;">
                    <li><a href="#" class="active"><i class="bi bi-list-check me-2"></i>All Orders</a></li>
                </ul>
            </nav>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid d-flex justify-content-end">
                        <div class="d-flex align-items-center">
                            <img src="https://i.pravatar.cc/40?u=<%= currentUser != null ? currentUser.getStaffID() : "staff"%>" class="rounded-circle me-2" width="35">
                            <span>Staff (<%= currentUser != null ? currentUser.getFullName() : "Unknown"%>)</span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4">
                    <h4 class="mb-4 fw-bold">Manage All Orders</h4>
                    <div class="row g-3">
<% if (orders != null && !orders.isEmpty()) { %>

                        <div class="col-12">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover table-striped">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Customer</th>
                                                    <th>Phone</th>
                                                    <th>Address</th>
                                                    <th>Total Amount</th>
                                                    <th>Order Date</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (Order o : orders) {
                                                        String status = o.getStatus();

                                                        // Bootstrap badge classes
                                                        String badgeClass;
                                                        if ("Delivered".equalsIgnoreCase(status)) {
                                                            badgeClass = "badge bg-success"; // Xanh lá
                                                        } else if ("In Transit".equalsIgnoreCase(status)) {
                                                            badgeClass = "badge bg-warning text-dark"; // Vàng
                                                        } else {
                                                            badgeClass = "badge bg-danger"; // ??
                                                        }
                                                %>
                                                <tr>
                                                    <td>#<%= o.getOrderID()%></td>
                                                    <td><%= o.getBuyer().getFullName()%></td>
                                                    <td><%= o.getBuyer().getPhone()%></td>
                                                    <td><%= o.getShippingAddress()%></td>
                                                    <td><%= currencyFormatter.format(o.getTotalAmount())%></td>
                                                    <td><%= o.getOrderDate()%></td>
                                                    <td>
                                                        <span class="<%= badgeClass%> fs-6 px-3 py-2">
                                                            <%= status%>
</span>
                                                    </td>
                                                </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <% } else { %>
                        <div class="col-12">
                            <div class="alert alert-info" role="alert">
                                <i class="bi bi-info-circle me-2"></i>There are currently no orders in the system.
                            </div>
                        </div>
                        <% }%>

                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
