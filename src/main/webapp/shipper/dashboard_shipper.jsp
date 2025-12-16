<%@page import="dao.ProductDAO"%>
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
            HashMap<Integer, List<OrderDetails>> orderDetailList
                    = (HashMap<Integer, List<OrderDetails>>) request.getAttribute("orderDetailList");
            String shipperName = (String) request.getAttribute("shipperName");

            VariantsDAO vDAO = new VariantsDAO();
            ProductDAO pdao = new ProductDAO();
            NumberFormat vn = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        %>

        <div class="d-flex" id="wrapper">

            <!-- SIDEBAR -->
            <nav class="sidebar">
                <div class="sidebar-header">
                    <h4 class="fw-bold text-primary">Mini Store</h4>
                </div>
                <ul class="list-unstyled">
                    <li><a href="order" class="active"><i class="bi bi-truck"></i>My Orders</a></li>
                </ul>
            </nav>

            <!-- PAGE CONTENT -->
            <div class="page-content flex-grow-1">

                <!-- NAVBAR -->
                <nav class="navbar navbar-light bg-white">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">

                            <form action="order" method="get">
                                <input type="hidden" name="action" value="">
                                <select name="status"
                                        class="form-select form-select-sm"
                                        onchange="this.form.submit()">
                                    <option value="all">All</option>
                                    <option value="In Transit">In Transit</option>
                                    <option value="Delivered">Delivered</option>
                                    <option value="Cancelled">Cancelled</option>
                                    <option value="Delayed">Delayed</option>
                                </select>
                            </form>


                            <!-- LOGOUT -->
                            <form action="logout" method="post">
                                <button type="submit" class="btn-logout">
                                    <i class="bi bi-box-arrow-right"></i> Logout
                                </button>
                            </form>

                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40?u=<%=shipperName%>"
                                     class="rounded-circle me-2" width="36">
                                <span><%= shipperName%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- BODY -->
                <div class="container-fluid p-4">
                    <h4 class="fw-bold mb-4">Orders Assigned to You</h4>

                    <div class="row g-4">

                        <% if (orders != null && !orders.isEmpty()) {
                                for (Order o : orders) {
                                    String st = o.getStatus();
                                    String badgeClass = "bg-secondary";
                                    if ("Delivered".equals(st))
                                        badgeClass = "bg-success";
                                    else if ("In Transit".equals(st))
                                        badgeClass = "bg-warning text-dark";
                                    else if ("Cancelled".equals(st))
                                        badgeClass = "bg-dark";
                                    else if ("Delayed".equals(st))
                                        badgeClass = "bg-danger";
                        %>

                        <div class="col-lg-6">
                            <div class="order-card">

                                <!-- HEADER -->
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h6 class="fw-bold mb-0">Order #<%= o.getOrderID()%></h6>
                                    <span class="badge <%= badgeClass%>"><%= st%></span>
                                </div>

                                <!-- BODY -->
                                <div class="card-body">
                                    <p><i class="bi bi-person-circle"></i>
                                        <strong>Customer:</strong> <%= o.getBuyer().getFullName()%></p>
                                    <p><i class="bi bi-telephone-fill"></i>
                                        <strong>Phone:</strong> <%= o.getBuyer().getPhone()%></p>
                                    <p><i class="bi bi-geo-alt-fill"></i>
                                        <strong>Address:</strong> <%= o.getShippingAddress()%></p>
                                    <p><i class="bi bi-cash-coin"></i>
                                        <strong>Total:</strong> <%= vn.format(o.getTotalAmount())%></p>
                                    <p><i class="bi bi-calendar3"></i>
                                        <strong>Date:</strong> <%= o.getOrderDate()%></p>
                                </div>

                                <!-- FOOTER -->
                                <div class="card-footer d-flex justify-content-between align-items-center">

                                    <!-- VIEW -->
                                    <button class="btn btn-sm btn-outline-primary"
                                            data-bs-toggle="modal"
                                            data-bs-target="#orderModal-<%= o.getOrderID()%>">
                                        <i class="bi bi-eye"></i> View
                                    </button>

                                    <!-- UPDATE STATUS -->
                                    <form action="order" method="post" class="d-flex gap-2 mb-0">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="orderID" value="<%= o.getOrderID()%>">

                                        <%
                                            List<String> statusList = new ArrayList<>();
                                            if ("In Transit".equals(st)) {
                                                statusList.add("Delivered");
                                                statusList.add("Cancelled");
<<<<<<< HEAD
=======
                                                statusList.add("Delayed");
>>>>>>> 62bad43794ed9e6ec4e6d026e91b6a10331a6e66
                                            } else if ("Delayed".equals(st)) {
                                                statusList.add("Delivered");
                                                statusList.add("Cancelled");
                                            } else {
                                                statusList = null;
                                            }
                                        %>

                                        <% if (statusList != null) { %>
                                        <select name="newStatus" class="form-select form-select-sm">
                                            <% for (String s : statusList) {%>
                                            <option value="<%= s%>"><%= s%></option>
                                            <% } %>
                                        </select>
                                        <button class="btn btn-sm btn-primary">Update</button>
                                        <% }%>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- MODAL -->
                        <div class="modal fade"
                             id="orderModal-<%= o.getOrderID()%>"
                             tabindex="-1">
                            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                                <div class="modal-content">

                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            Order #<%= o.getOrderID()%> – Details
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>

                                    <div class="modal-body">
                                        <div class="order-items-box">
                                            <%
                                                List<OrderDetails> odList = orderDetailList.get(o.getOrderID());
                                                if (odList != null && !odList.isEmpty()) {
                                                    for (OrderDetails d : odList) {
                                                        Variants v = vDAO.getVariantByID(d.getVariantID());
                                            %>

                                            <div class="order-item d-flex align-items-center p-2 mb-2">
                                                <img src="images/<%= v.getImageList()[0]%>"
                                                     class="order-item-img me-3">
                                                <div class="flex-grow-1">
                                                    <div class="small text-muted">
                                                        <%= pdao.getNameByID(v.getProductID())%>
                                                        - <%= v.getColor()%> • <%= v.getStorage()%>
                                                    </div>
                                                    <div class="small">
                                                        Price: <strong><%= vn.format(d.getUnitPrice())%></strong>
                                                        | Qty: <strong><%= d.getQuantity()%></strong>
                                                    </div>
                                                </div>
                                                <div class="fw-bold text-success">
                                                    <%= vn.format(d.getUnitPrice() * d.getQuantity())%>
                                                </div>
                                            </div>

                                            <%      }
                                    } else { %>
                                            <p class="text-muted">No items found.</p>
                                            <% } %>
                                        </div>
                                    </div>

                                    <div class="modal-footer">
                                        <button class="btn btn-secondary" data-bs-dismiss="modal">
                                            Close
                                        </button>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <% }
                } else { %>
                        <p class="text-muted">No orders assigned.</p>
                        <% }%>

                    </div>
                </div>
            </div>
        </div>

        <script>
            document.getElementById('menu-toggle').onclick =
                    () => document.getElementById('wrapper').classList.toggle('toggled');
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
<<<<<<< HEAD
</html>
=======
</html>
>>>>>>> 62bad43794ed9e6ec4e6d026e91b6a10331a6e66
