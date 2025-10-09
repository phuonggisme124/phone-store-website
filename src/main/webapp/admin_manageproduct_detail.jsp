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
                    <li><a href="admin?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
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
                <%
                    int productID = (int) request.getAttribute("productID");
                %>
                <div class="container-fluid p-4">
                    <input type="text" class="form-control w-25" placeholder="🔍 Search">
                </div>
                <div class="container-fluid p-4 ps-3">
                    <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm" href="admin?action=createVariant&pid=<%= productID%>">
                        <i class="bi bi-sliders me-2"></i> Create Variant
                    </a>
                    <a class="btn btn-danger px-4 py-2 rounded-pill shadow-sm" href="admin?action=deleteProduct&pid=<%= productID%>">
                         Delete Product
                    </a>
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

                            %>

                            <%                                for (Variants v : listVariants) {
                            String nameProduct="";
                            //int productID = 0;
                                
                                
                                        for (Products p : listProducts) {
                                            if (p.getProductID() == v.getProductID()) {
                                                    nameProduct = p.getName();
                                                    //productID = p.getProductID();
                                                }
                                        }
                            %>

                            <tbody>
                                <tr  onclick="window.location.href = 'admin?action=editProduct&vid=<%= v.getVariantID()%>&pid=<%= productID%>'">
                                    <td><%= v.getVariantID()%></td>

                                    
                                    <td><%= nameProduct%></td>                                   
                                    <td><%= v.getColor()%></td>
                                    <td><%= v.getStorage()%></td>
                                    <td><%= String.format("%,.0f", v.getPrice())%></td>
                                    <td><%= String.format("%,.0f", v.getDiscountPrice())%></td>
                                    <td><%= v.getStock()%></td>
                                    <td><%= v.getDescription()%></td>
                                    <td><%= v.getImageUrl()%></td>



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
