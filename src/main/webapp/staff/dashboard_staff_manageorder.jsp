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
    /* status */
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            /* rê chuột đôngj */
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-badge:hover {
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        }
 /* màu chuyển,rê chuột */
        .status-badge.pending {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }

        .status-badge.in-transit {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }

        .status-badge.delivered {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }

        .status-badge.delay {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
        }

        .status-badge.cancelled {
            background: linear-gradient(135deg, #fc6076 0%, #ff9a44 100%);
            color: white;
        }

        /* đập */
        .status-badge i {
            animation: pulse 2s infinite;
        }
  /* icon to */
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2); }
        }

        /* rê chuột */
        .btn-action {
            border-radius: 10px;
            padding: 8px 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 2px solid;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        }

        .btn-outline-primary.btn-action {
            border-color: #667eea;
            color: #667eea;
        }

        .btn-outline-primary.btn-action:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
        }

        .btn-outline-danger.btn-action:hover {
            background: linear-gradient(135deg, #fc6076 0%, #ff9a44 100%);
            border-color: transparent;
        }

        /* shipper */
        .shipper-info {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            padding: 8px 12px;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .shipper-info:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }

        /* rê chuột hàng */
        tbody tr {
            transition: all 0.3s ease;
            cursor: pointer;
        }

        tbody tr:hover {
            background: linear-gradient(90deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        #suggestionBox {
            background: white;
            border: 1px solid rgba(102, 126, 234, 0.2);
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        #suggestionBox .list-group-item {
            border: none;
            transition: all 0.3s ease;
        }

        #suggestionBox .list-group-item:hover {
            background: linear-gradient(90deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            transform: translateX(5px);
            padding-left: 20px;
        }

        /* card  */
        .card {
            border-radius: 16px !important;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08) !important;
            transition: all 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12) !important;
        }

        .alert {
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            animation: slideDown 0.5s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-content {
            border-radius: 16px;
            border: none;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            border-radius: 16px 16px 0 0;
        }

        /* list shipper */
        .list-group-item {
            border: 1px solid rgba(0, 0, 0, 0.05) !important;
            border-radius: 8px !important;
            margin-bottom: 8px;
            transition: all 0.3s ease;
        }

        .list-group-item:hover {
            background: linear-gradient(90deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .spinner-border {
            width: 3rem;
            height: 3rem;
            border-width: 0.3em;
        }


        td:nth-child(5) {
            font-weight: 700;
            color: #667eea;
        }

        td:nth-child(3) {
            font-family: 'Courier New', monospace;
            font-weight: 600;
        }

        /* thông báo */
        .alert.auto-hide {
            animation: slideDown 0.5s ease-out, fadeOut 0.5s ease-out 2.5s forwards;
        }

        @keyframes fadeOut {
            to {
                opacity: 0;
                transform: translateY(-20px);
            }
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
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
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
            <li><a href="product?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
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
                    <!-- search sđt -->
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

                    <!-- filter status -->
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
            <!-- thông báo -->
            <%
                String message = (String) session.getAttribute("message");
                if (message != null) {
            %>
            <div class="alert alert-success alert-dismissible fade show auto-hide" role="alert">
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
            <div class="alert alert-danger alert-dismissible fade show auto-hide" role="alert">
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
                                String statusClass = "";
                                String statusIcon = "";
                                
                                if (status != null) {
                                    String statusLower = status.trim().toLowerCase();
                                    switch(statusLower) {
                                        case "pending":
                                            statusClass = "pending";
                                            statusIcon = "bi-clock-fill";
                                            break;
                                        case "in transit":
                                            statusClass = "in-transit";
                                            statusIcon = "bi-truck";
                                            break;
                                        case "delivered":
                                            statusClass = "delivered";
                                            statusIcon = "bi-check-circle-fill";
                                            break;
                                        case "delay":
                                            statusClass = "delay";
                                            statusIcon = "bi-exclamation-triangle-fill";
                                            break;
                                        case "cancelled":
                                            statusClass = "cancelled";
                                            statusIcon = "bi-x-circle-fill";
                                            break;
                                    }
                                }
                            %>
                             <!-- orderdetail  -->
                            <tr onclick="viewOrderDetail(<%= o.getOrderID()%>, <%= o.getIsInstalment() != null && o.getIsInstalment() %>)">
                                <td><span class="badge bg-primary">#<%= o.getOrderID()%></span></td>
                                <td>
                                    <!-- ng mua ko có => người nhận  -->
                                    <strong>
                                    <% if (o.getBuyer() != null) { %>
                                        <%= o.getBuyer().getFullName() != null ? o.getBuyer().getFullName() : o.getReceiverName() %>
                                    <% } else { %>
                                        <%= o.getReceiverName() %>
                                    <% } %>
                                    </strong>
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
                                <td>
                                    <span class="status-badge <%= statusClass%>">
                                        <i class="bi <%= statusIcon%>"></i>
                                        <%= status%>
                                    </span>
                                </td>
                                <!-- assign, cancle ko đè lên orderdetail  -->
                                <td onclick="event.stopPropagation();">
                                    <%
                                        boolean isPending = status != null && "pending".equalsIgnoreCase(status.trim());
                                        boolean hasShipper = o.getShippers() != null;
                                        boolean isCancelled = status != null && "cancelled".equalsIgnoreCase(status.trim());
                                    %>
                                    
                                    <% if (isPending) { %>
                                        <button class="btn btn-sm btn-outline-primary btn-action me-1" onclick="openAssignModal(<%= o.getOrderID()%>)">
                                            <i class="bi bi-truck"></i> Assign
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger btn-action" onclick="openCancelModal(<%= o.getOrderID()%>)">
                                            <i class="bi bi-x-circle"></i> Cancel
                                        </button>
                                    <% } else if (isCancelled && !hasShipper) { %>
                                        <span class="text-muted fst-italic">Cancelled</span>
                                    <% } else if (hasShipper) { %>
                                        <div class="shipper-info d-flex align-items-center">
                                            <i class="bi bi-person-badge-fill text-primary me-2 fs-5"></i>
                                            <div>
                                                <div class="fw-bold"><%= o.getShippers().getFullName()%></div>
                                                <small class="text-muted"><%= o.getShippers().getPhone()%></small>
                                            </div>
                                        </div>
                                    <% } else { %>                                    
                                        <span class="text-muted fst-italic">N/A</span>
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

        <!-- modal orderdetail -->
        <div class="modal fade" id="orderDetailModal" tabindex="-1">
            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            <i class="bi bi-receipt me-2"></i>Order Details
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
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

        <!-- modal assgin shipper -->
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
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-person-circle text-primary me-3 fs-4"></i>
                                    <div>
                                        <div class="fw-bold"><%= s.getFullName()%></div>
                                        <small class="text-muted"><i class="bi bi-telephone"></i> <%= s.getPhone()%></small>
                                    </div>
                                </div>
                                <button class="btn btn-sm btn-primary" onclick="submitAssignForm(<%= s.getUserId()%>)">
                                    <i class="bi bi-check-lg"></i> Select
                                </button>
                            </li>
                            <% }
                            } else { %>
                            <li class="list-group-item text-center text-muted">
                                <i class="bi bi-inbox fs-1"></i>
                                <p class="mt-2">No shippers available</p>
                            </li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- modal cancel order -->
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
        assignModal = new bootstrap.Modal(document.getElementById('shipperModal'));
        orderDetailModal = new bootstrap.Modal(document.getElementById('orderDetailModal'));
        cancelModal = new bootstrap.Modal(document.getElementById('cancelModal'));
        
        // tắt thông báo 
        // 3s
        setTimeout(() => {
            document.querySelectorAll('.alert.auto-hide').forEach(alert => {
                const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
                bsAlert.close();
            });
        }, 3000);
    };

    function openAssignModal(orderID) {
        document.getElementById("modalOrderID").value = orderID;
        assignModal.show();
    }

    function openCancelModal(orderID) {
        document.getElementById("cancelOrderID").value = orderID;
        document.getElementById("cancelOrderIDText").innerText = "#" + orderID;
        cancelModal.show();
    }

    function submitAssignForm(shipperID) {
        document.getElementById("modalShipperID").value = shipperID;
        document.getElementById("assignShipperForm").submit();
    }

    function viewOrderDetail(orderID, isInstalment) {
        orderDetailModal.show();
        
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
                document.getElementById('orderDetailContent').innerHTML = 
                    '<div class="alert alert-danger m-3">' +
                    '<i class="bi bi-exclamation-triangle me-2"></i>Failed to load order details.' +
                    '</div>';
            });
    }

    // gợi í sđt
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

    document.addEventListener('click', function(e) {
        var box = document.getElementById("suggestionBox");
        var searchInput = document.getElementById("searchPhone");
        if (box && searchInput && !box.contains(e.target) && e.target !== searchInput) {
            box.innerHTML = "";
        }
    });

    // thu menu
    document.getElementById("menu-toggle").addEventListener("click", function () {
        document.getElementById("wrapper").classList.toggle("toggled");
    });
</script>
</body>
</html>