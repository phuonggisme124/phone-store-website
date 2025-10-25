<%@page import="model.Promotions"%>
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
                    <input type="text" class="form-control w-25" placeholder="🔍 Search">
                </div>
                

                <%
                    Promotions promotion = (Promotions) request.getAttribute("promotion");
                    Products product = (Products) request.getAttribute("product");
                %>
                <!-- Table -->
                <form action="admin" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow">
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="pmtID" value="<%= promotion.getPromotionID()%>" readonly>
                    </div>
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="pID" value="<%= product.getProductID()%>" readonly>
                    </div>
                    

                    <div class="mb-3">
                        <label class="form-label">Product Name</label>
                        <input type="text" class="form-control" name="name" value="<%= product.getName()%>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Discount Percent</label>
                        <input type="number" class="form-control" name="discountPercent" value="<%= promotion.getDiscountPercent()%>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Start Date</label>
                        <input type="text" class="form-control" name="startDate" value="<%= promotion.getStartDate()%>" required>
                    </div>
                    
                    

                    <div class="mb-3">
                        <label class="form-label">End Date</label>
                        <input type="text" class="form-control" name="endDate" value="<%= promotion.getEndDate()%>" required>

                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select class="form-select" name="status" id="status">
                            
                            <option value="active" <%= (promotion.getStatus().equals("active") ? "selected" : "")%>>Active</option>
                            <option value="expired" <%= (promotion.getStatus().equals("expired") ? "selected" : "")%> >Expired</option>
                                       
                        </select>
                    </div>
                    
                    
                    
                    <div class="d-flex gap-2">
                        <button type="submit" name="action" value="updatePromotion" class="btn btn-primary flex-fill">Update</button>
                        <button type="submit" name="action" value="deletePromotion" class="btn btn-danger flex-fill">Delete</button>
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
