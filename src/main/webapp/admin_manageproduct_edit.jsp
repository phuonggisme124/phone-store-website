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
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="admin" ><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                    <li><a href="admin?action=manageProduct" class="active"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="admin?action=manageSupplier"><i class="bi bi-truck me-2"></i>Suppliers</a></li>
                    <li><a href="admin?action=managePromotion"><i class="bi bi-tag me-2"></i></i>Promotions</a></li>
                    <li><a href="#"><i class="bi bi-bag me-2"></i>Orders</a></li>
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
                

                <%
                    Variants variant = (Variants) request.getAttribute("variant");
                    Products product = (Products) request.getAttribute("product");
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                %>
                <!-- Table -->
                <form action="admin" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow">
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="vID" value="<%= variant.getVariantID()%>" readonly>
                    </div>
                    
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="pID" value="<%= product.getProductID()%>" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="pName" value="<%= product.getName()%>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Brand</label>
                        <input type="text" class="form-control" name="brand" value="<%= product.getBrand()%>" required>
                    </div>
                    
                    

                    <div class="mb-3">
                        <label class="form-label">Color</label>
                        <input type="text" class="form-control" name="color" value="<%= variant.getColor()%>" required>

                    </div>
                    <div class="mb-3">
                        <label class="form-label">Storage</label>
                        <input type="text" class="form-control" name="storage" value="<%= variant.getStorage()%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price</label>
                        <input type="text" class="form-control" name="price" value="<%= String.format("%.0f", variant.getPrice())%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Warranty Period</label>
                        <input type="text" class="form-control" name="warrantyPeriod" value="<%= product.getWarrantyPeriod()%>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Stock</label>
                        <input type="text" class="form-control" name="stock" value="<%= variant.getStock()%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Supplier</label>
                        <select class="form-select" name="supplierID" id="supplierID">
                            <%
                                for(Suppliers sl : listSupplier){
                            %>
                            <option value="<%= sl.getSupplierID()%>" <%= (sl.getSupplierID() == product.getSupplierID() ? "selected" : "")%>><%= sl.getName()%></option>
                            <%
                                }
                            %>             
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <input type="text" class="form-control" name="description" value="<%= variant.getDescription()%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Image</label>
                        <input type="text" class="form-control" name="img" value="<%= variant.getImageUrl()%>">
                    </div>
                    
                    
                    <div class="d-flex gap-2">
                        <button type="submit" name="action" value="updateProduct" class="btn btn-primary flex-fill">Update</button>
                        <button type="submit" name="action" value="deleteVariant" class="btn btn-danger flex-fill">Delete</button>
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
