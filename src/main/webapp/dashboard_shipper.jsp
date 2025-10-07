<%@page import="java.util.List"%>
<%@page import="model.Order"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Shipper Orders</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                background-color: #f8f9fa;
            }
            .sidebar {
                width: 230px;
                min-height: 100vh;
                transition: all 0.3s ease;
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
            .btn-logout {
                background-color: #dc3545;
                color: #fff;
                border: none;
                border-radius: 10px;
                padding: 6px 18px;
                font-weight: bold;
                transition: 0.3s;
            }
            .btn-logout:hover {
                background-color: #ff4d4f;
                box-shadow: 0 4px 10px rgba(220, 53, 69, 0.5);
                transform: translateY(-2px);
            }
            .badge {
                font-size: 1.1rem !important;
                padding: 0.5em 1.1em;
                border-radius: 0.7rem;
            }
            #wrapper.toggled .sidebar {
                margin-left: -230px;
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
                <ul class="list-unstyled ps-3">
                    <li><a href="shipper?action=myOrders" class="active"><i class="bi bi-truck me-2"></i>My Orders</a></li>
                </ul>
            </nav>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <div class="d-flex align-items-center ms-auto">
                            <!-- Filter Dropdown -->
                            <form action="order" method="get" class="dropdown me-3">
                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle" 
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Filter
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="status" value="All" class="dropdown-item">All</button></li>
                                    <li><button type="submit" name="status" value="Pending" class="dropdown-item">Pending</button></li>
                                    <li><button type="submit" name="status" value="In Transit" class="dropdown-item">In Transit</button></li>
                                    <li><button type="submit" name="status" value="Delivered" class="dropdown-item">Delivered</button></li>
                                </ul>
                            </form>


                            <form action="logout" method="post" class="d-inline me-3">
                                <button type="submit" class="btn-logout">Log out</button>
                            </form>
                            <i class="bi bi-bell me-3 fs-5"></i>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40?u=<%= request.getAttribute("shipperName")%>"
                                     class="rounded-circle me-2" width="35">
                                <span><%= request.getAttribute("shipperName")%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Orders Section -->
                <div class="container-fluid p-4">
                    <h4 class="mb-4 fw-bold">Orders Assigned to You</h4>
                    <div class="row g-3" id="orderList">
                        <% if (orders != null && !orders.isEmpty()) {
                        for (Order o : orders) {%>

                        <div class="col-lg-6 order-card" data-status="<%= o.getStatus()%>">
                            <div class="card border-0 shadow-sm p-3">
                                <div class="row">
                                    <div class="col-md-8 border-end">
                                        <h6 class="fw-bold text-primary mb-2">Order ID: #<%= o.getOrderID()%></h6>
                                        <p class="mb-1"><i class="bi bi-person"></i> Customer: <%= o.getBuyer().getFullName()%></p>
                                        <p class="mb-1"><i class="bi bi-telephone"></i> Phone: <%= o.getBuyer().getPhone()%></p>
                                        <p class="mb-1"><i class="bi bi-geo-alt"></i> Address: <%= o.getShippingAddress()%></p>
                                        <p class="mb-1"><i class="bi bi-cash-coin"></i> Total: $<%= o.getTotalAmount()%></p>
                                        <p class="mb-0"><i class="bi bi-calendar-event"></i> Date: <%= o.getOrderDate()%></p>
                                    </div>
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
        <script>
            const menuToggle = document.getElementById('menu-toggle');
            const wrapper = document.getElementById('wrapper');
            menuToggle.addEventListener('click', () => wrapper.classList.toggle('toggled'));

            // Filter logic
            document.querySelectorAll('.filter-option').forEach(option => {
                option.addEventListener('click', function (e) {
                    e.preventDefault();
                    const status = this.getAttribute('data-status');
                    document.querySelectorAll('.filter-option').forEach(o => o.classList.remove('active'));
                    this.classList.add('active');

                    document.querySelectorAll('.order-card').forEach(card => {
                        if (status === 'All' || card.dataset.status === status)
                            card.style.display = 'block';
                        else
                            card.style.display = 'none';
                    });
                });
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
