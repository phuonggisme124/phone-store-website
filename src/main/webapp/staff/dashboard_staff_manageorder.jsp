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
</head>
<body>
<%
    List<Order> orders = (List<Order>) request.getAttribute("listOrders");
    List<Users> shippers = (List<Users>) request.getAttribute("listShippers");
    Users currentUser = (Users) session.getAttribute("user");
    List<String> allPhones = (List<String>) request.getAttribute("allPhones");
    String currentPhone = request.getParameter("phone") != null ? request.getParameter("phone") : "";
    String currentStatus = request.getParameter("status") != null ? request.getParameter("status") : "";
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "US"));
    currencyFormatter.setMaximumFractionDigits(0);
%>

<script>
    const allPhones = <%= (allPhones != null) ? new Gson().toJson(allPhones) : "[]" %>;
</script>

<div class="d-flex" id="wrapper">
    <nav class="sidebar bg-white shadow-sm border-end">
        <div class="sidebar-header p-3">
            <h4 class="fw-bold text-primary">Mantis</h4>
        </div>
        <ul class="list-unstyled ps-3">
            <li><a href="order?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
            <li><a href="order?action=manageOrder" class="fw-bold text-primary"><i class="bi bi-bag me-2"></i>Orders</a></li>
            <li><a href="review?action=manageReview"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
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
                    <form action="order" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                        <input type="hidden" name="action" value="manageOrder">
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
                    <form action="order" method="get" class="dropdown me-3">
                        <input type="hidden" name="action" value="manageOrder">
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

            <!-- Messages -->
            <%
                String message = (String) session.getAttribute("message");
                if (message != null) {
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%
                    session.removeAttribute("message");
                }
                String error = (String) session.getAttribute("error");
                if (error != null) {
            %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%
                    session.removeAttribute("error");
                }
            %>

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
                                <th>Shipper / Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Order o : orders) {
                                String status = o.getStatus();
                                String badgeClass = "badge bg-secondary";
                                
                                if (status != null) {
                                    String statusLower = status.trim().toLowerCase();
                                    switch(statusLower) {
                                        case "pending":
                                            badgeClass = "badge bg-warning text-dark";
                                            break;
                                        case "in transit":
                                            badgeClass = "badge bg-info text-dark";
                                            break;
                                        case "delivered":
                                            badgeClass = "badge bg-success";
                                            break;
                                        case "delay":
                                            badgeClass = "badge bg-warning text-dark";
                                            break;
                                        case "cancelled":
                                            badgeClass = "badge bg-danger";
                                            break;
                                    }
                                }
                            %>
                            <tr style="cursor: pointer;" onclick="viewOrderDetail(<%= o.getOrderID()%>, <%= o.getIsInstalment() != null && o.getIsInstalment() %>)">
                                <td>#<%= o.getOrderID()%></td>
                                <td>
                                    <% if (o.getBuyer() != null) { %>
                                        <%= o.getBuyer().getFullName() != null ? o.getBuyer().getFullName() : o.getReceiverName() %>
                                    <% } else { %>
                                        <%= o.getReceiverName() %>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (o.getBuyer() != null && o.getBuyer().getPhone() != null) { %>
                                        <%= o.getBuyer().getPhone() %>
                                    <% } else { %>
                                        <%= o.getReceiverPhone() %>
                                    <% } %>
                                </td>
                                <td><%= o.getShippingAddress()%></td>
                                <td><%= currencyFormatter.format(o.getTotalAmount())%></td>
                                <td><%= o.getOrderDate()%></td>
                                <td><span class="<%= badgeClass%> fs-6 px-3 py-2"><%= status%></span></td>
                                <td onclick="event.stopPropagation();">
                                    <%
                                        boolean isPending = status != null && "pending".equalsIgnoreCase(status.trim());
                                        boolean hasShipper = o.getShippers() != null;
                                        boolean isCancelled = status != null && "cancelled".equalsIgnoreCase(status.trim());
                                    %>
                                    
                                    <% if (isPending) { %>
                                        <button class="btn btn-sm btn-outline-primary me-1" onclick="openAssignModal(<%= o.getOrderID()%>)">
                                            <i class="bi bi-truck"></i> Assign
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" onclick="openCancelModal(<%= o.getOrderID()%>)">
                                            <i class="bi bi-x-circle"></i> Cancel
                                        </button>
                                        
                                    <% } else if (isCancelled && !hasShipper) { %>
                                        <span class="text-muted">Cancelled</span>
                                        
                                    <% } else if (hasShipper) { %>
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-person-badge text-primary me-2"></i>
                                            <div>
                                                <div class="fw-bold"><%= o.getShippers().getFullName()%></div>
                                                <small class="text-muted"><%= o.getShippers().getPhone()%></small>
                                            </div>
                                        </div>
                                        
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

        <!-- model order detail-->
        <div class="modal fade" id="orderDetailModal" tabindex="-1" aria-labelledby="orderDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="orderDetailModalLabel">
                            <i class="bi bi-receipt me-2"></i>Order Details
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="orderDetailContent">
                            <div class="text-center py-5">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-3 text-muted">Loading order details...</p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="bi bi-x-lg me-1"></i>Close
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- modal chọn shipper -->
        <div class="modal fade" id="shipperModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bi bi-truck me-2"></i>Choose a Shipper
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form action="order" method="POST" id="assignShipperForm">
                            <input type="hidden" name="action" value="assignShipper">
                            <input type="hidden" name="orderID" id="modalOrderID">
                            <input type="hidden" name="shipperID" id="modalShipperID">
                        </form>
                        
                        <ul class="list-group">
                            <% if (shippers != null && !shippers.isEmpty()) {
                                for (Users s : shippers) { %>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="fw-bold"><%= s.getFullName()%></div>
                                    <small class="text-muted"><%= s.getPhone()%></small>
                                </div>
                                <button class="btn btn-sm btn-primary" onclick="submitAssignForm(<%= s.getUserId()%>)">
                                    Select
                                </button>
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

        <!-- Modal: Cancel Order -->
        <div class="modal fade" id="cancelModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>Confirm Cancel Order
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to cancel order <strong id="cancelOrderIDText">#</strong>?</p>
                        <p class="text-muted small mb-0">
                            <i class="bi bi-info-circle me-1"></i>This action cannot be undone.
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="bi bi-x-lg me-1"></i>No
                        </button>
                        <form action="order" method="POST" id="cancelOrderForm" class="d-inline">
                            <input type="hidden" name="action" value="cancelOrder">
                            <input type="hidden" name="orderID" id="cancelOrderID">
                            <button type="submit" class="btn btn-danger">
                                <i class="bi bi-trash me-1"></i>Cancel Order
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    var assignModal = null;
    var orderDetailModal = null;
    var cancelModal = null;

    window.onload = function () {
        var shipperModalEl = document.getElementById('shipperModal');
        var orderDetailModalEl = document.getElementById('orderDetailModal');
        var cancelModalEl = document.getElementById('cancelModal');
        
        if (shipperModalEl) {
            assignModal = new bootstrap.Modal(shipperModalEl);
        }
        if (orderDetailModalEl) {
            orderDetailModal = new bootstrap.Modal(orderDetailModalEl);
        }
        if (cancelModalEl) {
            cancelModal = new bootstrap.Modal(cancelModalEl);
        }
    };

    function openAssignModal(orderID) {
        document.getElementById("modalOrderID").value = orderID;
        if (assignModal) assignModal.show();
    }

    function openCancelModal(orderID) {
        document.getElementById("cancelOrderID").value = orderID;
        document.getElementById("cancelOrderIDText").innerText = "#" + orderID;
        if (cancelModal) cancelModal.show();
    }

    function submitAssignForm(shipperID) {
        document.getElementById("modalShipperID").value = shipperID;
        document.getElementById("assignShipperForm").submit();
    }

    function viewOrderDetail(orderID, isInstalment) {
        if (orderDetailModal) {
            orderDetailModal.show();
        }
             
        fetch('order?action=orderDetail&id=' + orderID + '&isIntalment=' + isInstalment)
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                
                let content = '<div class="container-fluid">';
                
                const productsCard = doc.querySelector('.card');
                if (productsCard) {
                    content += '<div class="mb-4">';
                    content += '<h5 class="fw-bold text-secondary mb-3"><i class="bi bi-cart-check me-2"></i>Products in Order</h5>';
                    content += productsCard.querySelector('.table-responsive, table').outerHTML;
                    content += '</div>';
                }
                
                // Get payment schedule if exists
                const allCards = doc.querySelectorAll('.card');
                if (allCards.length > 1) {
                    content += '<div class="mb-4">';
                    content += '<h5 class="fw-bold text-secondary mb-3"><i class="bi bi-calendar-check me-2"></i>Payment Schedule</h5>';
                    content += allCards[1].querySelector('.table-responsive, table').outerHTML;
                    content += '</div>';
                }
                
                content += '</div>';
                
                document.getElementById('orderDetailContent').innerHTML = content;
            })
            .catch(error => {
                console.error('Error loading order details:', error);
                document.getElementById('orderDetailContent').innerHTML = 
                    '<div class="alert alert-danger m-3">' +
                    '<i class="bi bi-exclamation-triangle me-2"></i>Failed to load order details. Please try again.' +
                    '</div>';
            });
    }
</script>


<script>
    var debounceTimer;
    function showSuggestions(str) {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => {
            var box = document.getElementById("suggestionBox");
            if (!box) return;
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

    document.addEventListener('click', function(event) {
        var box = document.getElementById("suggestionBox");
        var searchInput = document.getElementById("searchPhone");
        if (box && searchInput && !box.contains(event.target) && event.target !== searchInput) {
            box.innerHTML = "";
        }
    });
</script>


<script>
    var menuToggle = document.getElementById("menu-toggle");
    if (menuToggle) {
        menuToggle.addEventListener("click", function () {
            document.getElementById("wrapper").classList.toggle("toggled");
        });
    }
</script>

</body>
</html>