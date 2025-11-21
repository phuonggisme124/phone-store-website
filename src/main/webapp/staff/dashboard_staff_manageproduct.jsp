<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Users"%>
<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard - Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard_staff.css">
    <link href="css/dashboard_table.css" rel="stylesheet">
</head>
<body>
<%
    Users currentUser = (Users) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (currentUser.getRole() != 2) {
        response.sendRedirect("login");
        return;
    }

    List<Products> listProducts = (List<Products>) request.getAttribute("listProducts");
    List<Category> listCategory = (List<Category>) request.getAttribute("listCategory");

    // Lấy giá trị filter/search hiện tại từ request
    String currentBrand = request.getParameter("brandFilter") != null ? request.getParameter("brandFilter") : "All";
    String currentProductName = request.getParameter("productName") != null ? request.getParameter("productName") : "";
    
    // Tạo danh sách tên sản phẩm để autocomplete
    List<String> allProductNames = new ArrayList<>();
    for (Products p : listProducts) {
        if (!allProductNames.contains(p.getName())) {
            allProductNames.add(p.getName());
        }
    }
%>

<script>
    const allProductNames = <%= new Gson().toJson(allProductNames) %>;
</script>

<div class="d-flex" id="wrapper">
    <!-- Sidebar -->
    <nav class="sidebar bg-white shadow-sm border-end">
        <div class="sidebar-header p-3">
            <h4 class="fw-bold text-primary">Mantis</h4>
        </div>
        <ul class="list-unstyled ps-3">
            <li><a href="product?action=manageProduct" class="fw-bold text-primary"><i class="bi bi-box me-2"></i>Products</a></li>
            <li><a href="order?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
            <li><a href="review?action=manageReview"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
        </ul>
    </nav>


    <!-- Page Content -->
    <div class="page-content flex-grow-1">
        <!-- Navbar -->
        <nav class="navbar navbar-light bg-white shadow-sm">
            <div class="container-fluid">
                <button class="btn btn-outline-primary" id="menu-toggle">
                    <i class="bi bi-list"></i>
                </button>
                <div class="d-flex align-items-center ms-auto">

                    <!-- Search Product -->
                    <form action="staff" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                        <input type="hidden" name="action" value="manageProduct">

                        <!-- Giữ lại brandFilter nếu đang filter -->
                        <input type="hidden" name="brandFilter" value="<%= currentBrand %>">
                        <input class="form-control me-2" type="text" id="searchProduct" name="productName"
                               placeholder="Search Product…" value="<%= currentProductName %>"
                               oninput="showSuggestions(this.value)">
                        <button class="btn btn-outline-primary" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                        <div id="suggestionBox" class="list-group position-absolute w-100"
                             style="top: 100%; z-index: 1000;"></div>
                    </form>

                    <!-- Filter Brand -->
                    <form action="staff" method="get" class="dropdown me-3">
                        <input type="hidden" name="action" value="manageProduct">

                        <!-- Giữ lại productName nếu đang search -->
                        <input type="hidden" name="productName" value="<%= currentProductName %>">

                        <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-funnel"></i> Filter
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                            <li><button type="submit" name="brandFilter" value="All" class="dropdown-item">All Brands</button></li>
                            <%
                                // Lấy danh sách Brand từ listProducts
                                List<String> brandList = new ArrayList<>();
                                for (Products p : listProducts) {
                                    if (!brandList.contains(p.getBrand())) {
                                        brandList.add(p.getBrand());
                                    }
                                }
                                for (String brand : brandList) {
                            %>
                            <li><button type="submit" name="brandFilter" value="<%= brand %>" class="dropdown-item"><%= brand %></button></li>
                            <% } %>
                        </ul>
                    </form>

                    <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                    <div class="d-flex align-items-center ms-3">
                        <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                        <span><%= currentUser.getFullName() %></span>
                    </div>
                </div>
            </div>
        </nav>


        <!-- Products Table -->
        <div class="container-fluid p-4">
            <div class="card shadow-sm border-0 p-4">
                <div class="card-body p-0">
                    <h4 class="fw-bold ps-3 mb-4">Manage Products</h4>
                    <% if (listProducts != null && !listProducts.isEmpty()) { %>
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
                                <% for (Products p : listProducts) { 

                                    // Lọc theo Brand nếu không phải "All"
                                    if (!currentBrand.equals("All") && !p.getBrand().equals(currentBrand)) continue;
                                %>
                                <tr onclick="window.location.href='staff?action=productDetail&id=<%= p.getProductID()%>'" style="cursor: pointer;">
                                    <td>#<%= p.getProductID() %></td>
                                    <td>
                                        <% for (Category ct : listCategory) {
                                            if (p.getCategoryID().equals(ct.getCategoryId())) { %>
                                            <%= ct.getCategoryName() %>
                                        <% } } %>
                                    </td>
                                    <td><%= p.getSupplierID() %></td>
                                    <td><%= p.getName() %></td>
                                    <td><%= p.getBrand() %></td>
                                    <td><%= p.getWarrantyPeriod() %></td>
                                    <td><%= p.getCreatedAt() %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="alert alert-info m-4" role="alert">
                        <i class="bi bi-info-circle me-2"></i>No products available.
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/dashboard.js"></script>
<script>

    // ------------------ Autocomplete ------------------
    var debounceTimer;
    function showSuggestions(str) {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => {
            var box = document.getElementById("suggestionBox");
            box.innerHTML = "";
            if (str.length < 1) return;

            var matches = allProductNames.filter(name => 
                name.toLowerCase().includes(str.toLowerCase())
            );
            
            if (matches.length > 0) {
                matches.slice(0, 5).forEach(name => {
                    var item = document.createElement("button");
                    item.type = "button";
                    item.className = "list-group-item list-group-item-action";
                    item.textContent = name;
                    item.onclick = function () {
                        document.getElementById("searchProduct").value = name;
                        box.innerHTML = "";
                        document.getElementById("searchForm").submit();
                    };
                    box.appendChild(item);
                });
            } else {
                var item = document.createElement("div");
                item.className = "list-group-item text-muted small";
                item.textContent = "No products found.";
                box.appendChild(item);
            }
        }, 200);
    }


    // Ẩn suggestions khi click bên ngoài
    document.addEventListener('click', function(e) {
        var searchInput = document.getElementById('searchProduct');
        var suggestionBox = document.getElementById('suggestionBox');
        if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
            suggestionBox.innerHTML = "";
        }
    });
</script>
</body>
</html>