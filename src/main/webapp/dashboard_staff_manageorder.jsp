<%@page import="java.util.List"%>
<%@page import="model.Order"%>
<%@page import="model.Users"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<%
    List<Order> orders = (List<Order>) request.getAttribute("listOrders");
    List<Users> shippers = (List<Users>) request.getAttribute("listShippers");
    Users currentUser = (Users) session.getAttribute("user");
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "US"));
    currencyFormatter.setMaximumFractionDigits(0);
%>

<div class="d-flex" id="wrapper">
    <!-- Sidebar -->
    <nav class="sidebar bg-white shadow-sm border-end">
        <div class="sidebar-header p-3">
            <h4 class="fw-bold text-primary">Mantis</h4>
        </div>
        <ul class="list-unstyled ps-3">
            <li><a href="staff?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
            <li><a href="staff?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
        </ul>
    </nav>

    <!-- Page Content -->
    <div class="page-content flex-grow-1">
        <!-- Navbar -->
        <nav class="navbar navbar-light bg-white shadow-sm">
            <div class="container-fluid">
                <button class="btn btn-outline-primary" id="menu-toggle">
                    <i class="bi bi-list"></i>
                </button>
                <form class="d-none d-md-flex ms-3">
                    <input class="form-control" type="search" placeholder="Ctrl + K" readonly>
                </form>
                <div class="d-flex align-items-center ms-auto">
                    <div class="position-relative me-3">
                        <a href="logout">logout</a>
                    </div>
                    <i class="bi bi-bell me-3 fs-5"></i>
                    <i class="bi bi-github me-3 fs-5"></i>
                    <div class="d-flex align-items-center">
                        <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                        <span>Staff</span>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Search bar -->
        <div class="container-fluid p-4">
            <input type="text" class="form-control w-25" placeholder="🔍 Search Orders">
        </div>

        <!-- Orders Table -->
        <div class="card shadow-sm border-0 p-4">
            <div class="card-body p-0">
                <h4 class="fw-bold ps-3 mb-4">Manage All Orders</h4>

                <% if (orders != null && !orders.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Customer</th>
                                <th>Phone</th>
                                <th>Address</th>
                                <th>Total Amount</th>
                                <th>Order Date</th>
                                <th>Status</th>
                                <th>Shipper</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Order o : orders) {
                                    String status = o.getStatus();
                                    String badgeClass;
                                    if ("Delivered".equalsIgnoreCase(status)) {
                                        badgeClass = "badge bg-success";
                                    } else if ("In Transit".equalsIgnoreCase(status)) {
                                        badgeClass = "badge bg-warning text-dark";
                                    } else {
                                        badgeClass = "badge bg-danger";
                                    }
                            %>
                            <tr>
                                <td>#<%= o.getOrderID() %></td>
                                <td><%= o.getBuyer().getFullName() %></td>
                                <td><%= o.getBuyer().getPhone() %></td>
                                <td><%= o.getShippingAddress() %></td>
                                <td><%= currencyFormatter.format(o.getTotalAmount()) %></td>
                                <td><%= o.getOrderDate() %></td>
                                <td>
                                    <span class="<%= badgeClass %> fs-6 px-3 py-2">
                                        <%= status %>
                                    </span>
                                </td>
                                <td>
                                    <%
                                        if (o.getShippers() != null && o.getShippers().getFullName() != null) {
                                            Users s = o.getShippers();
                                    %>
                                    <%= s.getFullName() %> (<%= s.getPhone() %>)
                                    <%
                                        } else if (currentUser != null) {
                                    %>
                                    <button class="btn btn-sm btn-outline-primary" 
                                            onclick="openModal(<%= o.getOrderID() %>)">
                                        <i class="bi bi-truck"></i> Choose Shipper
                                    </button>
                                    <%
                                        } else {
                                    %>
                                    <span class="text-muted">Login required</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="alert alert-info m-4" role="alert">
                    <i class="bi bi-info-circle me-2"></i>There are currently no orders in the system.
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Shipper Selection Modal -->
<div class="modal fade" id="shipperModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Choose a Shipper</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <ul class="list-group">
                    <%
                        if (shippers != null && !shippers.isEmpty()) {
                            for (Users s : shippers) {
                    %>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <%= s.getFullName() %> (<%= s.getPhone() %>)
                        <button class="btn btn-sm btn-primary" 
                                onclick="assignShipper(<%= s.getUserId() %>)">
                            Select
                        </button>
                    </li>
                    <%
                            }
                        } else {
                    %>
                    <li class="list-group-item text-center text-muted">No shippers available</li>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
var currentOrderID = null;
var myModal = null;

// Khởi tạo modal khi trang load
window.onload = function() {
    myModal = new bootstrap.Modal(document.getElementById('shipperModal'));
    console.log("Modal initialized");
};

// Mở modal
function openModal(orderID) {
    console.log("openModal called with orderID:", orderID);
    currentOrderID = orderID;
    myModal.show();
}

// Assign shipper
function assignShipper(shipperID) {
    console.log("assignShipper called");
    console.log("Order ID:", currentOrderID);
    console.log("Shipper ID:", shipperID);
    
    var staffID = '<%= (currentUser != null) ? currentUser.getUserId() : "" %>';
    console.log("Staff ID:", staffID);
    
    if (!currentOrderID) {
        alert("Error: No order selected!");
        return;
    }
    
    if (!shipperID) {
        alert("Error: No shipper selected!");
        return;
    }
    
    if (!staffID) {
        alert("Error: Not logged in!");
        return;
    }
    
    var url = "staff?action=assignShipper&orderID=" + currentOrderID + 
              "&shipperID=" + shipperID + 
              "&staffID=" + staffID;
    
    console.log("Redirecting to:", url);
    window.location.href = url;
}
</script>

</body>
</html>