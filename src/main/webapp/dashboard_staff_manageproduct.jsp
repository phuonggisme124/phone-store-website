

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

                        <!-- ✅ Search theo thời gian duy nhất -->
                        <form class="d-flex ms-3" action="staff" method="get">
                            <input type="hidden" name="action" value="manageProduct">
                            <label class="me-2 align-self-center">From:</label>
                            <input type="date" name="startDate" class="form-control me-2" required>
                            <label class="me-2 align-self-center">To:</label>
                            <input type="date" name="endDate" class="form-control me-2" required>
                            <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
                        </form>

                        <div class="d-flex align-items-center ms-auto">
                            <div class="position-relative me-3">
                                <a href="logout">Logout</a>
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

                <!-- ❌ Đã xóa phần Search bar giữa trang -->

                <!-- Table -->
                <div class="card shadow-sm border-0 p-4 mt-3">
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ProductID</th>
                                    <th>Category</th>
                                    <th>Supplier</th>
                                    <th>Name</th>
                                    <th>Brand</th>
                                    <th>Warranty Period</th>
                                    <th>CreatedAt</th>
                                </tr>
                            </thead>

                            <%
                                List<Products> listProducts = (List<Products>) request.getAttribute("listProducts");
                                List<Category> listCategory = (List<Category>) request.getAttribute("listCategory");
                                List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                            %>

                            <%
                                for (Products p : listProducts) {
                            %>
                            <tbody>
                                <tr onclick="window.location.href = 'staff?action=productDetail&id=<%= p.getProductID()%>'">
                                    <td><%= p.getProductID()%></td>
                                    <%
                                        for (Category ct : listCategory) {
                                            if (p.getCategoryID().equals(ct.getCategoryId())) {
                                    %>
                                    <td><%= ct.getCategoryName()%></td>
                                    <%
                                            }
                                        }
                                    %>
                                    <%
                                        for (Suppliers sl : listSupplier) {
                                            if (p.getSupplierID().equals(sl.getSupplierID())) {
                                    %>
                                    <td><%= sl.getName()%></td>
                                    <%
                                            }
                                        }
                                    %>
                                    <td><%= p.getName()%></td>
                                    <td><%= p.getBrand()%></td>
                                    <td><%= p.getWarrantyPeriod()%></td>
                                    <td><%= p.getCreatedAt()%></td>
                                </tr>                          
                            </tbody>
                            <%
                                }
                            %>
                        </table>
                    </div>
                </div>
            </div>

            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
    </body>
</html>
