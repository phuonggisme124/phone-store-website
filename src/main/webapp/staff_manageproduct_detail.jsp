<%@page import="model.Variants"%>
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
    <title>Staff Dashboard</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/dashboard_staff.css">
    <link href="css/dashboard_table.css" rel="stylesheet">

    <style>
        tr.clickable-row { cursor: pointer; transition: background 0.2s; }
        tr.clickable-row:hover { background: #f8f9fa; }
    </style>
</head>
<body>
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
                        <span>Staff</span>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Search bar -->
        <div class="container-fluid p-4">
            <input type="text" class="form-control w-25" placeholder="🔍 Search">
        </div>

        <!-- Table -->
        <div class="card shadow-sm border-0 p-4">
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>VariantID</th>
                        <th>Product Name</th>
                        <th>Color</th>
                        <th>Storage</th>
                        <th>Price</th>
                        <th>Discount Price</th>
                        <th>Stock</th>
                        <th>Description</th>
                        <th>ImageURL</th>
                    </tr>
                    </thead>

                    <%
                        List<Products> listProducts = (List<Products>) request.getAttribute("listProducts");
                        List<Variants> listVariants = (List<Variants>) request.getAttribute("listVariants");
                        for (Variants v : listVariants) {
                            Products matchedProduct = null;
                            for (Products p : listProducts) {
                                if (p.getProductID() == v.getProductID()) {
                                    matchedProduct = p;
                                    break;
                                }
                            }
                    %>

                    <tbody>
                    <tr class="clickable-row" onclick="window.location.href='staff?action=productDetail&id=<%= matchedProduct != null ? matchedProduct.getProductID() : 0 %>'">
                        <td><%= v.getVariantID() %></td>
                        <td><%= matchedProduct != null ? matchedProduct.getName() : "Unknown" %></td>
                        <td><%= v.getColor() %></td>
                        <td><%= v.getStorage() %></td>
                        <td><%= String.format("%,.0f", v.getPrice()) %></td>
                        <td><%= String.format("%,.0f", v.getDiscountPrice()) %></td>
                        <td><%= v.getStock() %></td>
                        <td><%= v.getDescription() %></td>
                        <td><%= v.getImageUrl() %></td>
                    </tr>
                    </tbody>

                    <%
                        }
                    %>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script src="js/dashboard.js"></script>
</body>
</html>
