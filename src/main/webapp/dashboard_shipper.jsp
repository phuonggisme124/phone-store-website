<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="model.Order"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Shipper Orders</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link href="css/dashboard_shipper.css" rel="stylesheet">
    </head>
    <body>
        <% List<Order> orders = (List<Order>) request.getAttribute("orders");%>

        <div class="d-flex" id="wrapper">
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mini Store</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="order" class="active"><i class="bi bi-truck me-2"></i>My Orders</a></li>
                </ul>
            </nav>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <div class="d-flex align-items-center ms-auto">
                            <form action="order" method="get" class="dropdown me-3">
                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle" 
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Filter
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="status" value="All" class="dropdown-item">All</button></li>
                                    <li><button type="submit" name="status" value="Cancelled" class="dropdown-item">Cancelled</button></li>
                                    <li><button type="submit" name="status" value="In Transit" class="dropdown-item">In Transit</button></li>
                                    <li><button type="submit" name="status" value="Delivered" class="dropdown-item">Delivered</button></li>
                                    <li><button type="submit" name="status" value="Delayed" class="dropdown-item">Delayed</button></li>
                                </ul>
                            </form>

                            <form action="logout" method="post">
                                <button type="submit" class="btn-logout">
                                    <i class="bi bi-box-arrow-right me-2"></i>Log out
                                </button>
                            </form>

                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40?u=<%= request.getAttribute("shipperName")%>"
                                     class="rounded-circle me-2" width="35">
                                <span><%= request.getAttribute("shipperName")%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4">
                    <h4 class="mb-4 fw-bold">Orders Assigned to You</h4>
                    <div class="row g-3" id="orderList">
                        <%-- DÁN KHỐI LẶP MỚI NÀY VÀO FILE JSP CỦA BẠN --%>
                        <% if (orders != null && !orders.isEmpty()) {
                                for (Order o : orders) {%>

                        <div class="col-lg-6 order-card-wrapper">
                            <div class="order-card shadow-sm">

                                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                    <h6 class="mb-0 fw-bold text-primary">Order ID: #<%= o.getOrderID()%></h6>
                                    <%
                                        NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                                        String currentStatus = o.getStatus();
                                        String badgeClass = "bg-secondary";
                                        if ("Delivered".equalsIgnoreCase(currentStatus))
                                            badgeClass = "bg-success";
                                        else if ("In Transit".equalsIgnoreCase(currentStatus))
                                            badgeClass = "bg-warning text-dark";
                                        else if ("Delayed".equalsIgnoreCase(currentStatus))
                                            badgeClass = "bg-danger";
                                        else if ("Cancelled".equalsIgnoreCase(currentStatus))
                                            badgeClass = "bg-dark";
                                    %>
                                    <span class="badge rounded-pill <%= badgeClass%>"><%= currentStatus%></span>
                                </div>

                                <div class="card-body">
                                    <p><i class="bi bi-person-circle"></i> <strong>Customer:</strong><%= o.getBuyer().getFullName()%></p>
                                    <p><i class="bi bi-telephone-fill"></i> <strong>Phone:</strong> <%= o.getBuyer().getPhone()%></p>
                                    <p><i class="bi bi-geo-alt-fill"></i> <strong>Address:</strong> <%= o.getShippingAddress()%></p>
                                    <p><i class="bi bi-cash-coin"></i> <strong>Total:</strong><%= vnFormat.format(o.getTotalAmount())%></p>
                                    <p class="mb-0"><i class="bi bi-calendar3"></i> <strong>Date:</strong> <%= o.getOrderDate()%></p>
                                </div>

                                <div class="card-footer bg-light">
                                    <form action="order" method="post" class="update-form">
                                        <input type="hidden" name="orderID" value="<%= o.getOrderID()%>">

                                        <%
                                            List<String> statusList = new ArrayList<>();
                                            statusList.add("In Transit");
                                            statusList.add("Delivered");
                                            statusList.add("Delayed");
                                            statusList.add("Cancelled");
                                            if ("In Transit".equalsIgnoreCase(currentStatus)) {
                                                statusList.remove("In Transit");
                                            } else if ("Delayed".equalsIgnoreCase(currentStatus)) {
                                                statusList.remove("In Transit");
                                                statusList.remove("Delayed");
                                            } else {
                                                statusList = null;
                                            }

                                        %>
                                        <%if (statusList != null) {%>
                                        <div class="input-group">
                                            <select name="newStatus" class="form-select form-select-sm" aria-label="Update order status">
                                                <% for (String updateStatus : statusList) {%>
                                                <option value="<%=updateStatus%>" <%= updateStatus.equalsIgnoreCase(currentStatus) ? "selected" : ""%>><%=updateStatus%></option>
                                                <% } %>
                                            </select>
                                            <button class="btn btn-sm btn-primary" style="background-color: #72AEC8" type="submit">Update</button>
                                        </div>
                                        <% } %>
                                    </form>
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

        <script>
            const menuToggle = document.getElementById('menu-toggle');
            const wrapper = document.getElementById('wrapper');
            menuToggle.addEventListener('click', () => wrapper.classList.toggle('toggled'));
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>