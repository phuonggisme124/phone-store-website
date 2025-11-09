<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="model.Users"%>
<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Products</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
    </head>
    <body>
        <%
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login");
                return;
            }

            List<Products> currentListProduct = (List<Products>) request.getAttribute("currentListProduct");
            List<Category> listCategory = (List<Category>) request.getAttribute("listCategory");
            List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");

            // Lấy giá trị filter/search hiện tại từ request
            String currentProductName = request.getParameter("productName") != null ? request.getParameter("productName") : "";
            String currentBrand = request.getParameter("brandFilter") != null ? request.getParameter("brandFilter") : "All";

            // Tạo danh sách tên sản phẩm để autocomplete
            List<String> allProductNames = new ArrayList<>();
            Set<String> brandSet = new HashSet<>();
            if (currentListProduct != null) {
                for (Products p : currentListProduct) {
                    if (!allProductNames.contains(p.getName())) {
                        allProductNames.add(p.getName());
                    }
                    if (p.getBrand() != null && !p.getBrand().isEmpty()) {
                        brandSet.add(p.getBrand());
                    }
                }
            }
            List<String> allBrands = new ArrayList<>(brandSet);
            java.util.Collections.sort(allBrands);
        %>

        <script>
            const allProductNames = <%= new Gson().toJson(allProductNames)%>;
        </script>

        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <%@ include file="/sidebar.jsp" %>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">
                            <!-- Search bar in navbar -->
                            <form action="admin" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off" style="width: 250px;">
                                <input type="hidden" name="action" value="manageProduct">
                                <input type="hidden" name="brandFilter" value="<%= currentBrand%>">
                                <input class="form-control me-2" type="text" id="searchProduct" name="productName"
                                       placeholder="Search Product" value="<%= currentProductName%>"
                                       oninput="showSuggestions(this.value)">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                                <div id="suggestionBox" class="list-group position-absolute"
                                     style="top: 100%; left: 0; width: 250px; z-index: 1000;"></div>
                            </form>

                            <!-- Filter Brand -->
                            <form action="admin" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="manageProduct">
                                <input type="hidden" name="productName" value="<%= currentProductName%>">

                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Brand
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="brandFilter" value="All" class="dropdown-item">All Brands</button></li>
                                    <li><hr class="dropdown-divider"></li>
                                        <% for (String brand : allBrands) {%>
                                    <li><button type="submit" name="brandFilter" value="<%= brand%>" class="dropdown-item">
                                            <%= brand%>
                                        </button></li>
                                        <% }%>
                                </ul>
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser.getFullName()%></span>
                            </div>
                        </div>
                    </div>
                </nav>
                            
                <!-- Create Product Button -->
                <div class="container-fluid p-4 ps-3">
                    <h1 class="fw-bold ps-3 mb-4 fw-bold text-primary">Manage Products</h1>
                </div>
                <div class="container-fluid p-4 ps-3">
                    <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm" href="product?action=createProduct">
                        <i class="bi bi-box-seam me-2"></i> Create Product
                    </a>
                </div>

                <!-- Products Table -->
                <div class="card shadow-sm border-0 p-4">
                    <div class="card-body p-0">
                        
                        <% if (currentListProduct != null && !currentListProduct.isEmpty()) { %>
                        <div class="table-responsive">
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
                                <tbody>
                                    <%
                                        for (Products p : currentListProduct) {
                                            // Lọc theo Product Name nếu có search
                                            if (!currentProductName.isEmpty() && !p.getName().toLowerCase().contains(currentProductName.toLowerCase())) {
                                                continue;
                                            }

                                            // Lọc theo Brand
                                            if (!currentBrand.equals("All") && !p.getBrand().equals(currentBrand)) {
                                                continue;
                                            }

                                            String categoryName = "";
                                            for (Category ct : listCategory) {
                                                if (p.getCategoryID().equals(ct.getCategoryId())) {
                                                    categoryName = ct.getCategoryName();
                                                    break;
                                                }
                                            }

                                            String supplierName = "";
                                            for (Suppliers sl : listSupplier) {
                                                if (p.getSupplierID().equals(sl.getSupplierID())) {
                                                    supplierName = sl.getName();
                                                    break;
                                                }
                                            }
                                    %>
                                    <tr onclick="window.location.href = 'product?action=productDetail&pID=<%= p.getProductID()%>'" style="cursor: pointer;">
                                        <td>#<%= p.getProductID()%></td>
                                        <td><%= categoryName%></td>
                                        <td><%= supplierName%></td>
                                        <td><%= p.getName()%></td>
                                        <td><span class="badge bg-info"><%= p.getBrand()%></span></td>
                                        <td><%= p.getWarrantyPeriod()%></td>
                                        <td><%= p.getCreatedAt()%></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info m-4" role="alert">
                            <i class="bi bi-info-circle me-2"></i>No products available.
                        </div>
                        <% }%>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Custom JS -->
        <script src="js/dashboard.js"></script>
        <script>
                                        var currentOrderID = null;
                                        var myModal = null;

                                        window.onload = function () {
                                            myModal = new bootstrap.Modal(document.getElementById('shipperModal'));
                                        };

                                        function openModal(orderID) {
                                            currentOrderID = orderID;
                                            myModal.show();
                                        }

                                        function assignShipper(shipperID) {
                                            var staffID = '<%= (currentUser != null) ? currentUser.getUserId() : ""%>';
                                            if (!currentOrderID || !shipperID || !staffID) {
                                                alert("Missing information!");
                                                return;
                                            }
                                            window.location.href = "staff?action=assignShipper&orderID=" + currentOrderID + "&shipperID=" + shipperID;
                                        }

                                        // ------------------ Autocomplete ------------------
                                        var debounceTimer;
                                        function showSuggestions(str) {
                                            clearTimeout(debounceTimer);
                                            debounceTimer = setTimeout(() => {
                                                var box = document.getElementById("suggestionBox");
                                                box.innerHTML = "";
                                                if (str.length < 1)
                                                    return;

                                                var matches = allPhones.filter(phone => phone.includes(str));
                                                if (matches.length > 0) {
                                                    matches.forEach(phone => {
                                                        var item = document.createElement("button");
                                                        item.type = "button";
                                                        item.className = "list-group-item list-group-item-action";
                                                        item.textContent = phone;
                                                        item.onclick = function () {
                                                            document.getElementById("searchPhone").value = phone;
                                                            box.innerHTML = "";
                                                            document.getElementById("searchForm").submit();
                                                        };
                                                        box.appendChild(item);
                                                    });
                                                } else {
                                                    var item = document.createElement("div");
                                                    item.className = "list-group-item text-muted small";
                                                    item.textContent = "No phone numbers found.";
                                                    box.appendChild(item);
                                                }
                                            }, 200);
                                        }
        </script>
        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
</html>