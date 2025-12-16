<<<<<<< HEAD
=======
<%@page import="dao.StaffDAO"%>
>>>>>>> 62bad43794ed9e6ec4e6d026e91b6a10331a6e66
<%@page import="dao.CustomerDAO"%>
<%@page import="model.Staff"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.google.gson.Gson"%>
<<<<<<< HEAD
<%@page import="dao.CustomerDAO"%> 
<%@page import="dao.StaffDAO"%>    
=======

>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
<%@page import="model.Order"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<<<<<<< HEAD
<%@page import="model.Staff"%>     
<%@page import="model.Customer"%>
=======

>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Order</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_manageorder.css">
        
    </head>
    <body>
        <%
<<<<<<< HEAD
            // 1. FIX: Get Staff from Session (Admin is a Staff)
            Staff currentUser = (Staff) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            // Check Admin role
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login"); 
                return;
            }

=======
            Staff user = (Staff) session.getAttribute("user");
            CustomerDAO udao = new CustomerDAO();
            
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
            String phone = (String) request.getAttribute("phone");
            if (phone == null || phone.isEmpty()) phone = "";
            
            String status = (String) request.getAttribute("status");
            if (status == null || status.isEmpty()) status = "All";
            
            List<String> listPhone = (List<String>) request.getAttribute("listPhone");
            if (listPhone == null) listPhone = new ArrayList<>();
            
            List<Order> listOrder = (List<Order>) request.getAttribute("listOrder");
        %>
        
        <script>
            const phoneNumbers = <%= new Gson().toJson(listPhone)%>;
        </script>

        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <div class="page-content flex-grow-1">

                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

<<<<<<< HEAD
                            <form action="order" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
=======
                        <div class="d-flex align-items-center ms-auto gap-3">

                            <form action="order" method="get" class="position-relative mb-0" id="searchForm" autocomplete="off">
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                                <input type="hidden" name="action" value="searchOrder">
                                <input type="hidden" name="status" value="<%= status %>">

                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted ps-3 rounded-start-pill border-light-purple">
                                        <i class="bi bi-telephone"></i>
                                    </span>
                                    
                                    <input class="form-control border-start-0 border-end-0 border-light-purple shadow-none" 
                                           type="text" 
                                           id="searchPhone" 
                                           name="phone"
                                           placeholder="Search Phone..." 
                                           value="<%= phone %>"
                                           oninput="fetchSuggestions(this.value)"
                                           style="width: 250px; font-size: 0.9rem;">

                                    <button class="btn btn-gradient-primary rounded-end-pill px-3" type="submit">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>

                                <div id="suggestionBox" class="list-group position-absolute w-100 mt-1 shadow-lg border-0 rounded-3 overflow-hidden"
                                     style="top: 100%; z-index: 1000; display: none;"></div>
                            </form>

<<<<<<< HEAD
                            <form action="order" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="filterOrder">
                                <input type="hidden" name="phone" value="<%= phone%>">

                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle" 
=======
                            <% 
                                String[] statuses = {"All", "Pending", "In Transit", "Delivered", "Delayed", "Cancelled"};
                            %>
                            <form action="order" method="get" class="dropdown mb-0">
                                <input type="hidden" name="action" value="filterOrder">
                                <input type="hidden" name="phone" value="<%= phone %>">

                                <button class="btn btn-outline-custom dropdown-toggle px-3 rounded-pill d-flex align-items-center gap-2"
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel-fill"></i> 
                                    <span>Status: <%= status %></span>
                                </button>

                                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 mt-2" aria-labelledby="filterDropdown">
                                    <% for (String st : statuses) { 
                                        String icon = "bi-circle";
                                        if (st.equals("Pending")) icon = "bi-hourglass-split";
                                        else if (st.equals("In Transit")) icon = "bi-truck";
                                        else if (st.equals("Delivered")) icon = "bi-check-circle-fill";
                                        else if (st.equals("Delayed")) icon = "bi-exclamation-triangle-fill";
                                        else if (st.equals("Cancelled")) icon = "bi-x-circle-fill";
                                        else if (st.equals("All")) icon = "bi-grid-fill";
                                    %>
                                    <li>
                                        <button type="submit" name="status" value="<%= st %>" class="dropdown-item <%= status.equals(st) ? "active-gradient" : "" %>">
                                            <i class="bi <%= icon %> me-2 <%= status.equals(st) ? "text-white" : "text-muted" %>"></i> <%= st %>
                                        </button>
                                    </li>
                                    <% } %>
                                </ul>
                            </form>

<<<<<<< HEAD
                            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                            <div class="d-flex align-items-center ms-3">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser.getFullName() %></span>
=======
                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>

                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="position-relative">
                                        <img src="https://i.pravatar.cc/150?u=<%= (user != null) ? user.getStaffID(): "admin" %>" 
                                             class="rounded-circle border border-2 border-white shadow-sm" 
                                             width="40" height="40" alt="Avatar">
                                        <span class="position-absolute bottom-0 start-100 translate-middle p-1 bg-success border border-light rounded-circle">
                                            <span class="visually-hidden">Online</span>
                                        </span>
                                    </div>
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;">
                                            <%= (user != null) ? user.getFullName() : "Administrator" %>
                                        </span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                    </div>
                                </div>

                                <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" 
                                   style="width: 38px; height: 38px;" title="Logout">
                                    <i class="bi bi-box-arrow-right fs-6"></i>
                                </a>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                            </div>
                        </div>
                    </div>
                </nav>

<<<<<<< HEAD
                <%
                    // 3. FIX: Initialize Correct DAOs
                    CustomerDAO custDAO = new CustomerDAO(); 
                    StaffDAO staffDAO = new StaffDAO(); 
                    
                    List<Order> listOrder = (List<Order>) request.getAttribute("listOrder");
                %>

                <%
                    if (listOrder != null && !listOrder.isEmpty()) {
                %>
                <div class="card shadow-sm border-0 p-4 m-3">
                    <div class="card-body p-0">
                        <div class="container-fluid p-4 ps-3">
                            <h1 class="fw-bold ps-3 mb-4 fw-bold text-primary">Manage Orders</h1>
=======
                <div class="card shadow-sm border-0 rounded-4 m-3 overflow-hidden">
                    <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Manage Orders</h4>
                            <p class="text-muted small mb-0">Track and manage customer orders</p>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                        </div>
                        <a class="btn btn-gradient-primary px-4 py-2 rounded-pill shadow-sm d-flex align-items-center gap-2" href="order?action=showInstalment">
                            <i class="bi bi-credit-card-2-front"></i> 
                            <span>Instalment</span>
                        </a>
                    </div>

                    <% 
                        boolean hasSearch = !phone.isEmpty();
                        boolean hasStatus = !status.equals("All");

                        if (hasSearch || hasStatus) { 
                    %>
                    <div class="bg-light-purple bg-opacity-10 px-4 py-2 border-bottom d-flex align-items-center flex-wrap gap-2">
                        <span class="text-muted small fw-bold me-2"><i class="bi bi-funnel-fill me-1"></i>Filters:</span>

                        <% if (hasSearch) { %>
                        <span class="filter-chip chip-light">
                            Phone: <span class="fw-bold ms-1 text-primary"><%= phone %></span>
                            <a href="order?action=filterOrder&status=<%= status %>" class="btn-close-chip" title="Remove phone filter">
                                <i class="bi bi-x"></i>
                            </a>
                        </span>
                        <% } %>

                        <% if (hasStatus) { %>
                        <span class="filter-chip chip-gradient">
                            Status: <span class="fw-bold ms-1"><%= status %></span>
                            <a href="order?action=searchOrder&phone=<%= phone %>" class="btn-close-chip" title="Reset status filter">
                                <i class="bi bi-x"></i>
                            </a>
                        </span>
                        <% } %>

                        <a href="order?action=searchOrder" class="text-muted small text-decoration-none ms-auto animate-hover d-flex align-items-center">
                            <i class="bi bi-arrow-counterclockwise me-1"></i> Clear All
                        </a>
                    </div>
                    <% } %>

                    <div class="card-body p-0">
                        <% if (listOrder != null && !listOrder.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 custom-table">
                                <thead class="bg-light-purple text-uppercase small fw-bold text-muted">
                                    <tr>
                                        <th class="ps-4">Order ID</th>
                                        <th>Customer</th>
                                        <th>Receiver Info</th> 
                                        <th>Address</th>
                                        <th>Date</th>
                                        <th>Total</th>
                                        <th>Staff / Shipper</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>

                                <tbody class="border-top-0">
                                    <%
                                        for (Order o : listOrder) {
                                            String statusOrder = o.getStatus();
                                            String statusClass = "bg-secondary-subtle text-secondary";
                                            String statusIcon = "bi-circle";

                                            if (statusOrder != null) {
                                                if (statusOrder.equalsIgnoreCase("Pending")) {
                                                    statusClass = "bg-warning-subtle text-warning"; statusIcon = "bi-hourglass-split";
                                                } else if (statusOrder.equalsIgnoreCase("In Transit")) {
                                                    statusClass = "bg-info-subtle text-info"; statusIcon = "bi-truck";
                                                } else if (statusOrder.equalsIgnoreCase("Delivered")) {
                                                    statusClass = "bg-success-subtle text-success"; statusIcon = "bi-check-circle-fill";
                                                } else if (statusOrder.equalsIgnoreCase("Delayed")) {
                                                    statusClass = "bg-dark-subtle text-dark"; statusIcon = "bi-exclamation-triangle-fill";
                                                } else if (statusOrder.equalsIgnoreCase("Cancelled")) {
                                                    statusClass = "bg-danger-subtle text-danger"; statusIcon = "bi-x-circle-fill";
                                                }
                                            }

                                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy");
                                            String dateFormated = (o.getOrderDate() != null) ? o.getOrderDate().format(formatter) : "-";
<<<<<<< HEAD
                                            
                                            String staffName = (o.getStaffID() != 0 && udao.getCustomerByID(o.getStaffID()) != null) ? udao.getCustomerByID(o.getStaffID()).getFullName() : "-";
=======
                                            StaffDAO sdao = new StaffDAO();
                                            String staffName = (o.getStaffID() != 0 && sdao.getStaffByID(o.getStaffID()) != null) ? sdao.getStaffByID(o.getStaffID()).getFullName() : "-";
>>>>>>> 62bad43794ed9e6ec4e6d026e91b6a10331a6e66
                                            String shipperName = (o.getShipperID() != 0 && udao.getCustomerByID(o.getShipperID()) != null) ? udao.getCustomerByID(o.getShipperID()).getFullName() : "-";
                                    %>      
                                    <tr onclick="window.location.href = 'order?action=orderDetail&id=<%= o.getOrderID()%>&isInstalment=<%= o.getIsInstalment()%>'" 
                                        class="cursor-pointer transition-hover">
                                        
                                        <td class="ps-4"><span class="product-id-badge">#<%= o.getOrderID()%></span></td>
                                        <td><span class="fw-bold text-dark"><%= udao.getCustomerByID(o.getUserID()).getFullName()%></span></td>
                                        <td>
                                            <div class="d-flex flex-column">
                                                <span class="fw-bold text-dark"><%= o.getBuyerName()%></span>
                                                <small class="text-muted"><i class="bi bi-telephone me-1"></i><%= o.getBuyerPhone()%></small>
                                            </div>
                                        </td>
                                        <td style="max-width: 200px;">
                                            <div class="text-truncate text-secondary" title="<%= o.getShippingAddress()%>">
                                                <%= o.getShippingAddress()%>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="d-inline-flex align-items-center text-muted small bg-light rounded px-2 py-1 border border-light">
                                                <i class="bi bi-calendar3 me-2"></i> <%= dateFormated%>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="fw-bold text-primary"><%= String.format("%,.0f", o.getTotalAmount())%> đ</span>
                                            <div class="small text-muted" style="font-size: 0.75rem;"><%= o.getPaymentMethod()%></div>
                                        </td>
                                        <td>
                                            <div class="d-flex flex-column small">
                                                <span class="text-muted">Staff: <span class="text-dark fw-bold"><%= staffName %></span></span>
                                                <span class="text-muted">Ship: <span class="text-dark fw-bold"><%= shipperName %></span></span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge rounded-pill <%= statusClass %> border border-0 px-3 py-2 d-inline-flex align-items-center gap-2">
                                                <i class="bi <%= statusIcon %>"></i> <%= statusOrder %>
                                            </span>
                                        </td>
                                    </tr>                          
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
<<<<<<< HEAD
                        <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>OrderID</th>
                                    <th>User Name</th>
                                    <th>Receiver Phone</th>
                                    <th>Receiver Name</th>
                                    <th>Address</th>
                                    <th>Method</th>
                                    <th>Order Date</th>
                                    <th>Total Amount</th>
                                    <th>Staff</th>
                                    <th>Shipper</th>
                                    <th>Status</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    for (Order o : listOrder) {

                                        String statusOrder = o.getStatus();
                                        String statusBadge;
                                        if (statusOrder != null && statusOrder.equalsIgnoreCase("Pending")) {
                                            statusBadge = "<span class='badge status-yellow bg-success' style='font-size: 15px'>Pending</span>";
                                        } else if (statusOrder != null && statusOrder.equalsIgnoreCase("In Transit")) {
                                            statusBadge = "<span class='badge status-blue bg-success' style='font-size: 15px'>In Transit</span>";
                                        } else if (statusOrder != null && statusOrder.equalsIgnoreCase("Delayed")) {
                                            statusBadge = "<span class='badge status-black ' style='font-size: 15px'>Delayed</span>";
                                        } else if (statusOrder != null && statusOrder.equalsIgnoreCase("Delivered")) {
                                            statusBadge = "<span class='badge status-green bg-success' style='font-size: 15px'>Delivered</span>";
                                        } else {
                                            statusBadge = "<span class='badge status-red bg-success' style='font-size: 15px'>Cancelled</span>";
                                        }
                                        
                                        // 4. FIX: Get Customer Name using CustomerDAO
                                        String customerName = "Unknown";
                                        Customer c = custDAO.getCustomerById(o.getUserID());
                                        if(c != null) customerName = c.getFullName();
                                %>                              

                                <tr onclick="window.location.href = 'order?action=orderDetail&id=<%= o.getOrderID()%>&isInstalment=<%= o.getIsInstalment()%>'">
                                    <td>#<%= o.getOrderID()%></td>
                                    <td><%= customerName %></td>
                                    <td><%= o.getBuyerPhone()%></td>
                                    <td><%= o.getBuyerName()%></td>
                                    <td><%= o.getShippingAddress()%></td>
                                    <td><%= o.getPaymentMethod()%></td>
                                    <%
                                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                                        String dateFormated = "";
                                        LocalDateTime createAt = o.getOrderDate();
                                        if (createAt != null) {
                                            dateFormated = createAt.format(formatter);
                                        }
                                    %>
                                    <td><%= dateFormated%></td>
                                    <td><%= String.format("%,.0f", o.getTotalAmount())%></td>

                                    <%
                                        // 5. FIX: Get Staff/Shipper Name using StaffDAO
                                        String staffName = "";
                                        if (o.getStaffID() != 0) {
                                            Staff s = staffDAO.getStaffByID(o.getStaffID());
                                            if(s != null) staffName = s.getFullName();
                                        }
                                        
                                        String shipperName = "";
                                        if (o.getShipperID() != 0) {
                                            Staff s = staffDAO.getStaffByID(o.getShipperID());
                                            if(s != null) shipperName = s.getFullName();
                                        }
                                    %>

                                    <td><%=staffName%></td>   
                                    <td><%= shipperName%></td>  
                                    <td><%= statusBadge%></td>
                                </tr>                                  
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                        </div>
=======
                        <% } else { %>
                        <div class="container-fluid p-5 text-center">
                            <div class="mb-3"><i class="bi bi-inbox text-muted" style="font-size: 3rem; opacity: 0.5;"></i></div>
                            <h5 class="text-muted">No orders found</h5>
                            <p class="text-secondary small">Try adjusting your filters.</p>
                        </div>
                        <% } %>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
<<<<<<< HEAD
            const phoneNumbers = <%= new Gson().toJson(listPhone)%>;
=======
            // --- JS Logic ---
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
            const searchInput = document.getElementById("searchPhone");
            const suggestionBox = document.getElementById("suggestionBox");

            function fetchSuggestions(query) {
                query = query.trim().toLowerCase();
                suggestionBox.innerHTML = "";

                if (!query) {
                    suggestionBox.style.display = "none";
                    return;
                }

                const matches = phoneNumbers.filter(num => num.includes(query));

                if (matches.length === 0) {
<<<<<<< HEAD
                    suggestionBox.style.display = "none";
                    return;
                }

                matches.forEach(num => {
                    const item = document.createElement("button");
                    item.type = "button";
                    item.className = "list-group-item list-group-item-action";
                    item.innerHTML = highlightMatch(num, query);

                    item.addEventListener("click", () => {
                        searchInput.value = num;
                        suggestionBox.style.display = "none";
                        document.getElementById("searchForm").submit();
                    });

                    suggestionBox.appendChild(item);
                });

                suggestionBox.style.display = "block";
            }

            function highlightMatch(text, keyword) {
                const regex = new RegExp(`(${keyword})`, "gi");
                return text.replace(regex, `<strong>$1</strong>`);
            }

            document.addEventListener("click", (e) => {
                if (!e.target.closest("#searchForm")) {
                    suggestionBox.style.display = "none";
                }
            });
        </script>

        <script>
=======
                    // Hiển thị thông báo không tìm thấy
                    const item = document.createElement("div");
                    item.className = "list-group-item text-muted small";
                    item.textContent = "No number found";
                    suggestionBox.appendChild(item);
                } else {
                    matches.forEach(num => {
                        const item = document.createElement("button");
                        item.type = "button";
                        item.className = "list-group-item list-group-item-action";
                        item.innerHTML = highlightMatch(num, query);

                        item.addEventListener("click", () => {
                            searchInput.value = num;
                            suggestionBox.style.display = "none";
                            document.getElementById("searchForm").submit();
                        });
                        suggestionBox.appendChild(item);
                    });
                }
                suggestionBox.style.display = "block";
            }

            function highlightMatch(text, keyword) {
                const regex = new RegExp(`(${keyword})`, "gi");
                return text.replace(regex, `<strong class="text-primary">$1</strong>`);
            }

            document.addEventListener("click", (e) => {
                if (!e.target.closest("#searchForm")) {
                    suggestionBox.style.display = "none";
                }
            });

>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
</html>