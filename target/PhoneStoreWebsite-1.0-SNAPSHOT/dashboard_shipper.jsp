<%@page import="java.util.List"%>
<%@page import="model.Order"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Shipper Orders</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
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
            /* Làm ch? tr?ng thái to và rõ h?n */
            .badge {
                font-size: 1.25rem !important;
                padding: 0.6em 1.2em;
                border-radius: 0.8rem;
            }
        </style>
    </head>
    <body>
        <% List<Order> orders = (List<Order>) request.getAttribute("orders");%>

        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled" style="padding-left: 0 !important;">
                    <li><a href="#" class="active"><i class="bi bi-truck me-2"></i>My Orders</a></li>
                </ul>
            </nav>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <div class="d-flex align-items-center ms-auto">
                            <i class="bi bi-bell me-3 fs-5"></i>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%=request.getAttribute("shipperName")%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Orders Section -->
                <div class="container-fluid p-4">
                    <h4 class="mb-4 fw-bold">Orders Assigned to You</h4>
                    <div class="row g-3">

                        <% if (orders != null && !orders.isEmpty()) {
                                for (Order o : orders) {%>

                        <div class="col-lg-6">
                            <div class="card border-0 shadow-sm p-3">
                                <div class="row">
                                    <!-- Thông tin ??n hàng -->
                                    <div class="col-md-8 border-end">
                                        <h6 class="fw-bold text-primary mb-2">Order ID: #<%= o.getOrderID()%></h6>
                                        <p class="mb-1"><i class="bi bi-person"></i> Customer: <%= o.getBuyer().getFullName()%></p>
                                        <p class="mb-1"><i class="bi bi-telephone"></i> Phone: <%= o.getBuyer().getPhone()%></p>
                                        <p class="mb-1"><i class="bi bi-geo-alt"></i> Address: <%= o.getShippingAddress()%></p>
                                        <p class="mb-1"><i class="bi bi-cash-coin"></i> Total: $<%= o.getTotalAmount()%></p>
                                        <p class="mb-0"><i class="bi bi-calendar-event"></i> Date: <%= o.getOrderDate()%></p>
                                    </div>

                                    <!-- Tr?ng thái ??n hàng -->
                                    <div class="col-md-4 d-flex flex-column justify-content-center align-items-center">
                                        <form action="order" method="post">
                                            <input type="hidden" name="orderID" value="<%= o.getOrderID()%>">
                                            <input type="hidden" name="status" value="<%= o.getStatus()%>">

                                            <%
                                                String status = o.getStatus();
                                                String badgeClass = "bg-secondary";
                                                if ("Delivered".equalsIgnoreCase(status))
                                                    badgeClass = "bg-success";
                                                else if ("In Transit".equalsIgnoreCase(status))
                                                    badgeClass = "bg-warning";
                                                else if ("Pending".equalsIgnoreCase(status))
                                                    badgeClass = "bg-secondary";
                                            %>

                                            <button type="submit" class="btn <%= badgeClass%> text-white px-4 py-2 fw-bold">
                                                <%= status%>
                                            </button>
                                        </form>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <% }
                        } else { %>
                        <p class="text-muted">No orders assigned to you.</p>
                        <% }%>

                    </div>
                </div>
            </div>
        </div>

        <!-- JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
