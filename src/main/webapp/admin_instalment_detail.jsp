<%@page import="model.Payments"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.UsersDAO"%>
<%@page import="model.Sale"%>
<%@page import="model.Order"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="admin" ><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                    <li><a href="admin?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="admin?action=manageSupplier"><i class="bi bi-truck me-2"></i>Suppliers</a></li>
                    <li><a href="admin?action=managePromotion"><i class="bi bi-tag me-2"></i></i>Promotions</a></li>
                    <li><a href="admin?action=manageOrder" class="active"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li><a href="admin?action=manageReview"><i class="bi bi-bag me-2"></i>Reviews</a></li>
                    <li><a href="admin?action=manageUser"><i class="bi bi-people me-2"></i>Users</a></li>
                    <li><a href="#"><i class="bi bi-gear me-2"></i>Settings</a></li>
                </ul>
            </nav>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <form class="d-none d-md-flex ms-3">
                            <input class="form-control" type="search" placeholder="Ctrl + K" readonly>
                        </form>
                        <div class="d-flex align-items-center ms-auto">
                            <div class="position-relative me-3">
                                <a href="logout">logout</a>
                            </div>
                            <i class="bi bi-bell me-3 fs-5"></i>
                            <div class="position-relative me-3">
                                <i class="bi bi-github fs-5"></i>
                            </div>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span>Admin</span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Search bar -->
                <div class="container-fluid p-4">
                    <input type="text" class="form-control w-25" placeholder="🔍 Search">
                </div>
                <div class="container-fluid p-4 ps-3">
                    <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm" href="admin?action=pendingInstalment">
                        <i class="bi bi-box-seam me-2"></i> Pending
                    </a>
                    <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm" href="admin?action=completedInstalment">
                        <i class="bi bi-box-seam me-2"></i> Done
                    </a>
                </div>
                <%
                    UsersDAO udao = new UsersDAO();
                    List<Order> listOrder = (List<Order>) request.getAttribute("listOrder");
                    String action = (String) request.getAttribute("action");
                    List<Sale> listSales = (List<Sale>) request.getAttribute("listSales");
                    
                    List<Order> statusInstalment = null;
                    if(action.equals("pendingInstalment")){
                        statusInstalment = (List<Order>) request.getAttribute("pendingInstalment");
                    }else{
                        statusInstalment = (List<Order>) request.getAttribute("completedInstalment");
                    }
                    

                    
                %>

                <%
                    if (statusInstalment != null && !statusInstalment.isEmpty()) {
                %>
                <!-- Table -->
                <div class="card shadow-sm border-0 p-4">
                    <div class="card-body p-0">
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



                            <%
                                for (Order o : statusInstalment) {


                            %>

                            <tbody>
                                <tr  onclick="window.location.href = 'admin?action=orderDetail&id=<%= o.getOrderID()%>&isInstalment=<%= o.isIsInstallment()%>'">
                                    <td><%= o.getOrderID()%></td>
                                    <td><%= udao.getUserByID(o.getUserID()).getFullName()%></td>
                                    <td><%= o.getBuyerPhone()%></td>
                                    <td><%= o.getBuyerName()%></td>
                                    <td><%= o.getShippingAddress()%></td>
                                    <td><%= o.getPaymentMethod()%></td>
                                    <td><%= o.getOrderDate()%></td>
                                    <td><%= o.getTotalAmount()%></td>
                                    <%
                                        for (Sale s : listSales) {
                                            if (o.getOrderID() == s.getOrderID()) {
                                    %>
                                    <td><%= s.getStaff().getFullName()%></td>   
                                    <td><%= s.getShipper().getFullName()%></td>   
                                    <%
                                            }
                                        }
                                    %>

                                    <td><%= o.getStatus()%></td>
                                </tr>                          
                            </tbody>

                            <%

                                }
                            %>

                        </table>
                    </div>
                </div>
                <%
                } else {
                %>
                <div class="container-fluid p-4 ps-3">
                    <p>The instalment list is currently empty.</p>
                </div>
                <%
                    }
                %>
            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
    </body>
</html>
