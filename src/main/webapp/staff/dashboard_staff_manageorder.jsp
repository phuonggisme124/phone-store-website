<%@page import="java.util.List"%>
<%@page import="model.Order"%>
<%@page import="model.Users"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="com.google.gson.Gson"%>
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
    <style>
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }
    </style>
</head>
<body>
<%
    List<Order> orders = (List<Order>) request.getAttribute("listOrders");
    List<Users> shippers = (List<Users>) request.getAttribute("listShippers");
    Users currentUser = (Users) session.getAttribute("user");
    List<String> allPhones = (List<String>) request.getAttribute("allPhones");
    String currentPhone = request.getParameter("phone") != null ? request.getParameter("phone") : "";
    String currentStatus = request.getParameter("status") != null ? request.getParameter("status") : "";
    String assignSuccess = request.getParameter("assignSuccess");
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "US"));
    currencyFormatter.setMaximumFractionDigits(0);
%>

<script>
    const allPhones = <%= new Gson().toJson(allPhones) %>;
</script>

<!-- Toast Notification -->
<div class="toast-container">
    <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="bi bi-check-circle-fill me-2"></i>
                assign shipper successfully!
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<div class="d-flex" id="wrapper">
    <nav class="sidebar bg-white shadow-sm border-end">
        <div class="sidebar-header p-3">
            <h4 class="fw-bold text-primary">Mantis</h4>
        </div>
        <ul class="list-unstyled ps-3">
            <li><a href="staff?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
            <li><a href="staff?action=manageOrder" class="fw-bold text-primary"><i class="bi bi-bag me-2"></i>Orders</a></li>
            <li><a href="staff?action=manageReview"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
        </ul>
    </nav>

    <div class="page-content flex-grow-1">
        <nav class="navbar navbar-light bg-white shadow-sm">
            <div class="container-fluid">
                <button class="btn btn-outline-primary" id="menu-toggle">
                    <i class="bi bi-list"></i>
                </button>
                <div class="d-flex align-items-center ms-auto">

                    <!-- Search Phone -->
                    <form action="staff" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                        <input type="hidden" name="action" value="manageOrder">
                        <!-- Giữ lại status nếu đang filter -->
                        <input type="hidden" name="status" value="<%= currentStatus %>">
                        <input class="form-control me-2" type="text" id="searchPhone" name="phone"
                               placeholder="Search Phone…" value="<%= currentPhone %>"
                               oninput="showSuggestions(this.value)">
                        <button class="btn btn-outline-primary" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                        <div id="suggestionBox" class="list-group position-absolute w-100"
                             style="top: 100%; z-index: 1000;"></div>
                    </form>

                    <!-- Filter Status -->
                    <form action="staff" method="get" class="dropdown me-3">
                        <input type="hidden" name="action" value="manageOrder">
                        <!-- Giữ lại phone nếu đang search -->
                        <input type="hidden" name="phone" value="<%= currentPhone %>">

                        <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                 type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-funnel"></i> Filter
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                            <li><button type="submit" name="status" value="All" class="dropdown-item">All</button></li>
                            <li><button type="submit" name="status" value="Pending" class="dropdown-item">Pending</button></li>
                            <li><button type="submit" name="status" value="In Transit" class="dropdown-item">In Transit</button></li>
                            <li><button type="submit" name="status" value="Delivered" class="dropdown-item">Delivered</button></li>
                            <li><button type="submit" name="status" value="Delay" class="dropdown-item">Delay</button></li>
                            <li><button type="submit" name="status" value="Cancelled" class="dropdown-item">Cancelled</button></li>
                        </ul>
                    </form>

                    <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                    <div class="d-flex align-items-center ms-3">
                        <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                        <span><%= currentUser != null ? currentUser.getFullName() : "Staff"%></span>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container-fluid p-4">
            <div class="card shadow-sm border-0 p-4">
                <div class="card-body p-0">
                    <h4 class="fw-bold ps-3 mb-4">Manage Orders</h4>
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
                            <% for (Order o : orders) {
                                String status = o.getStatus();
                                String badgeClass = "badge bg-secondary";
                                if ("Pending".equalsIgnoreCase(status))
                                    badgeClass = "badge bg-warning text-dark";
                                else if ("In Transit".equalsIgnoreCase(status))
                                    badgeClass = "badge bg-info text-dark";
                                else if ("Delivered".equalsIgnoreCase(status))
                                    badgeClass = "badge bg-success";
                                else if ("Delay".equalsIgnoreCase(status))
                                    badgeClass = "badge bg-secondary";
                                else if ("Cancelled".equalsIgnoreCase(status))
                                    badgeClass = "badge bg-danger";
                            %>
                            <tr>
                                <td>#<%= o.getOrderID()%></td>
                                <td><%= o.getBuyer().getFullName()%></td>
                                <td><%= o.getBuyer().getPhone()%></td>
                                <td><%= o.getShippingAddress()%></td>
                                <td><%= currencyFormatter.format(o.getTotalAmount())%></td>
                                <td><%= o.getOrderDate()%></td>
                                <td><span class="<%= badgeClass%> fs-6 px-3 py-2"><%= status%></span></td>
                                <td>
                                    <% if ("Pending".equalsIgnoreCase(status)) {%>
                                    <button class="btn btn-sm btn-outline-primary" onclick="openModal(<%= o.getOrderID()%>)">
                                        <i class="bi bi-truck"></i> Assign
                                    </button>
                                    <% } else if (o.getShippers() != null) { %>
                                    <%= o.getShippers().getFullName()%> (<%= o.getShippers().getPhone()%>)
                                    <% } else { %>
                                    <span class="text-muted">N/A</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="alert alert-info m-4" role="alert">
                        <i class="bi bi-info-circle me-2"></i>No orders available.
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Modal chọn Shipper -->
        <div class="modal fade" id="shipperModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Choose a Shipper</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <ul class="list-group">
                            <% if (shippers != null && !shippers.isEmpty()) {
                                for (Users s : shippers) { %>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <%= s.getFullName()%> (<%= s.getPhone()%>)
                                <button class="btn btn-sm btn-primary" onclick="assignShipper(<%= s.getUserId()%>)">Select</button>
                            </li>
                            <% }
                            } else { %>
                            <li class="list-group-item text-center text-muted">No shippers available</li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    var currentOrderID = null;
    var myModal = null;

    window.onload = function () {
        myModal = new bootstrap.Modal(document.getElementById('shipperModal'));
        
        // Kiểm tra flag từ sessionStorage
        console.log('Checking sessionStorage:', sessionStorage.getItem('showAssignSuccess'));
        if (sessionStorage.getItem('showAssignSuccess') === 'true') {
            console.log('Showing toast...');
            sessionStorage.removeItem('showAssignSuccess');
            
            setTimeout(function() {
                var toastEl = document.getElementById('successToast');
                console.log('Toast element:', toastEl);
                if (toastEl) {
                    var toast = new bootstrap.Toast(toastEl, {
                        autohide: true,
                        delay: 3000
                    });
                    toast.show();
                    console.log('Toast shown!');
                }
            }, 100);
        }
    };

    function openModal(orderID) {
        currentOrderID = orderID;
        myModal.show();
    }

    function assignShipper(shipperID) {
        var staffID = '<%= (currentUser != null) ? currentUser.getUserId() : ""%>';
        if (!currentOrderID || !shipperID || !staffID) {
            alert("Missing information!");
            return;
        }
        // Lưu flag vào sessionStorage
        sessionStorage.setItem('showAssignSuccess', 'true');
        window.location.href = "staff?action=assignShipper&orderID=" + currentOrderID + "&shipperID=" + shipperID;
    }

    // ------------------ Autocomplete ------------------
    var debounceTimer;
    function showSuggestions(str) {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => {
            var box = document.getElementById("suggestionBox");
            box.innerHTML = "";
            if (str.length < 1) return;

            var matches = allPhones.filter(phone => phone.includes(str));
            if (matches.length > 0) {
                matches.forEach(phone => {
                    var item = document.createElement("button");
                    item.type = "button";
                    item.className = "list-group-item list-group-item-action";
                    item.textContent = phone;
                    item.onclick = function () {
                        document.getElementById("searchPhone").value = phone;
                        box.innerHTML = "";
                        document.getElementById("searchForm").submit();
                    };
                    box.appendChild(item);
                });
            } else {
                var item = document.createElement("div");
                item.className = "list-group-item text-muted small";
                item.textContent = "No phone numbers found.";
                box.appendChild(item);
            }
        }, 200);
    }
</script>
<script>
    document.getElementById("menu-toggle").addEventListener("click", function () {
        document.getElementById("wrapper").classList.toggle("toggled");
    });
</script>

</body>
</html>