<%@page import="model.Category"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Products"%>
<%@page import="model.Variants"%>
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
            <%@ include file="sidebar.jsp" %>

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
                    <h1 class="w-50 mx-auto bg-light p-4 rounded shadow">Create Product</h1>
                </div>


                <%
                    Variants variant = (Variants) request.getAttribute("variant");
                    Products product = (Products) request.getAttribute("product");
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                    List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
                %>
                <!-- Table -->
                <form action="admin" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow">
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="vID" value="" readonly>
                    </div>

                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="pID" value="" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="pName" value="" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <select class="form-select" name="category" id="category">
                            <option selected>Select Category</option>
                            <%
                                for (Category ct : listCategories) {
                            %>
                            <option value="<%= ct.getCategoryId()%>" ><%= ct.getCategoryName()%></option>
                            <%
                                }
                            %>             
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Brand</label>
                        <input type="text" class="form-control" name="brand" value="" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Warranty Period</label>
                        <input type="text" class="form-control" name="warrantyPeriod" value="" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Supplier</label>
                        <select class="form-select" name="supplierID" id="supplierID">
                            <option selected>Supplier</option>
                            <%
                                for (Suppliers sl : listSupplier) {
                            %>
                            <option value="<%= sl.getSupplierID()%>"><%= sl.getName()%></option>
                            <%
                                }
                            %>             
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">OS</label>
                        <input type="text" class="form-control" name="os" value="" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">CPU</label>
                        <input type="text" class="form-control" name="cpu" value="" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">GPU</label>
                        <input type="text" class="form-control" name="gpu" value="" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">RAM</label>
                        <input type="text" class="form-control" name="ram" value="" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Battery Capacity</label>
                        <input type="number" class="form-control" name="batteryCapacity" value="" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Touchscreen</label>
                        <input type="text" class="form-control" name="touchscreen" value="" required>
                    </div>
                    <div class="mb-3">

                        <button type="submit" name="action" value="createProduct" class="btn btn-primary w-100">Create</button>
                    </div>


                </form>
            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
    </body>
</html>
