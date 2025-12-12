
<%@page import="dao.VariantsDAO"%>
<%@page import="model.Variants"%>
<%@page import="java.util.HashMap"%>
<%@page import="model.OrderDetails"%>
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

        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            HashMap<Integer, List<OrderDetails>> orderDetailList = (HashMap<Integer, List<OrderDetails>>) request.getAttribute("orderDetailList");
            VariantsDAO vDAO = new VariantsDAO();
        %>

        <div class="d-flex" id="wrapper">

            <!-- =============== SIDEBAR =============== -->
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mini Store</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="order" class="active"><i class="bi bi-truck me-2"></i>My Orders</a></li>
                </ul>
            </nav>

            <!-- =============== MAIN CONTENT =============== -->
            <div class="page-content flex-grow-1">

                <!-- NAVBAR -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>

                        <div class="d-flex align-items-center ms-auto">

                            <!-- FILTER -->
                            <form action="order" method="get" class="dropdown me-3">
                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Filter
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><button type="submit" name="status" value="All" class="dropdown-item">All</button></li>
                                    <li><button type="submit" name="status" value="Cancelled" class="dropdown-item">Cancelled</button></li>
                                    <li><button type="submit" name="status" value="In Transit" class="dropdown-item">In Transit</button></li>
                                    <li><button type="submit" name="status" value="Delivered" class="dropdown-item">Delivered</button></li>
                                    <li><button type="submit" name="status" value="Delayed" class="dropdown-item">Delayed</button></li>
                                </ul>
                            </form>

                            <!-- LOGOUT -->
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

                <!-- PAGE BODY -->
                <div class="container-fluid p-4">
                    <h4 class="mb-4 fw-bold">Orders Assigned to You</h4>

                    <div class="row g-3" id="orderList">

                        <% if (orders != null && !orders.isEmpty()) {
                                for (Order o : orders) {%>

                        <div class="col-lg-6 order-card-wrapper">
                            <div class="order-card shadow-sm">

                                <!-- HEADER -->
                                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                    <h6 class="mb-0 fw-bold text-primary">Order ID: #<%= o.getOrderID()%></h6>

                                    <%
                                        NumberFormat vn = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                                        String st = o.getStatus();
                                        String badgeClass = "bg-secondary";
                                        if (st.equals("Delivered"))
                                            badgeClass = "bg-success";
                                        else if (st.equals("In Transit"))
                                            badgeClass = "bg-warning text-dark";
                                        else if (st.equals("Cancelled"))
                                            badgeClass = "bg-dark";
                                        else if (st.equals("Delayed"))
                                            badgeClass = "bg-danger";
                                    %>

                                    <span class="badge rounded-pill <%= badgeClass%>"><%= st%></span>
                                </div>

                                <!-- BODY -->
                                <div class="card-body">
                                    <p><i class="bi bi-person-circle"></i> <strong>Customer:</strong> <%= o.getBuyer().getFullName()%></p>
                                    <p><i class="bi bi-telephone-fill"></i> <strong>Phone:</strong> <%= o.getBuyer().getPhone()%></p>
                                    <p><i class="bi bi-geo-alt-fill"></i> <strong>Address:</strong> <%= o.getShippingAddress()%></p>
                                    <p><i class="bi bi-cash-coin"></i> <strong>Total:</strong> <%= vn.format(o.getTotalAmount())%></p>
                                    <p><i class="bi bi-calendar3"></i> <strong>Date:</strong> <%= o.getOrderDate()%></p>
                                </div>

                                <!-- ORDER ITEMS BUTTON -->
                                <div class="card-body pt-0">
                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary"
                                            data-bs-toggle="modal"
                                            data-bs-target="#orderItemsModal-<%= o.getOrderID()%>">
                                        <i class="bi bi-box-seam"></i> View Items
                                    </button>
                                </div>

                                <!-- STATUS UPDATE FOOTER -->
                                <div class="card-footer bg-light">
                                    <form action="order" method="post" class="update-form">
                                        <input type="hidden" name="orderID" value="<%= o.getOrderID()%>">

                                        <%
                                            List<String> list = new ArrayList<>();
                                            list.add("In Transit");
                                            list.add("Delivered");
                                            list.add("Delayed");
                                            list.add("Cancelled");

                                            if (st.equals("In Transit"))
                                                list.remove("In Transit");
                                            else if (st.equals("Delayed")) {
                                                list.remove("In Transit");
                                                list.remove("Delayed");
                                            } else
                                                list = null;
                                        %>

                                        <% if (list != null) { %>
                                        <div class="input-group">
                                            <select name="newStatus" class="form-select form-select-sm">
                                                <% for (String s : list) {%>
                                                <option value="<%= s%>"><%= s%></option>
                                                <% } %>
                                            </select>
                                            <button class="btn btn-sm btn-primary" type="submit">Update</button>
                                        </div>
                                        <% }%>
                                    </form>
                                </div>

                            </div>
                        </div>

                        <!-- Modal for this order -->
                        <div class="modal fade" id="orderItemsModal-<%= o.getOrderID()%>" tabindex="-1" aria-labelledby="orderItemsLabel-<%= o.getOrderID()%>" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="orderItemsLabel-<%= o.getOrderID()%>">Order #<%= o.getOrderID()%> — Items</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="order-items-box">
                                            <%
                                                List<OrderDetails> odList = orderDetailList.get(o.getOrderID());
                                                if (odList != null) {
                                                    for (OrderDetails d : odList) {
                                                        Variants v = vDAO.getVariantByID(d.getVariantID());
                                            %>

                                            <div class="order-item d-flex align-items-center p-2 mb-2">
                                                <img src="images/<%= v.getImageList()[0]%>" class="order-item-img rounded me-3">

                                                <div class="flex-grow-1">
                                                    <div class="text-muted small"><%= v.getColor()%> • <%= v.getStorage()%></div>
                                                    <div class="small">Price: <strong><%= vn.format(d.getUnitPrice())%></strong></div>
                                                    <div class="small">Qty: <strong><%= d.getQuantity()%></strong></div>
                                                </div>

                                                <div class="text-end fw-bold text-success small">
                                                    <%= vn.format(d.getUnitPrice() * d.getQuantity())%>
                                                </div>
                                            </div>

                                            <% }
                                  } else { %>
                                            <p class="text-muted">No items found for this order.</p>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
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

        <script>
            document.getElementById('menu-toggle').onclick = () =>
                document.getElementById('wrapper').classList.toggle('toggled');
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>

