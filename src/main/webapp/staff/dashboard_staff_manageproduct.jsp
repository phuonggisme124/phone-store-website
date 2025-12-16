<%@page import="model.Staff"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%@page import="model.Customer"%>

<%@page import="com.google.gson.Gson"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
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
        <style>
            /* nhãn */
            .category-badge {
                padding: 6px 14px;
                border-radius: 16px;
                font-weight: 600;
                font-size: 0.8rem;
                letter-spacing: 0.3px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }

            .category-badge:hover {
                transform: translateY(-1px) scale(1.05);
                box-shadow: 0 5px 14px rgba(0, 0, 0, 0.15);
            }

            /* màu loại */
            .category-badge.cat-1 {
                background: linear-gradient(135deg, #FF6B6B 0%, #FF8E53 100%);
                color: white;
            }

            .category-badge.cat-2 {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            .category-badge.cat-3 {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                color: white;
            }

            .category-badge.cat-4 {
                background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
                color: white;
            }

            .category-badge.cat-5 {
                background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
                color: white;
            }

            .category-badge.cat-default {
                background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
                color: #333;
            }

            .brand-badge {
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.15), rgba(118, 75, 162, 0.15));
                padding: 6px 12px;
                border-radius: 12px;
                font-weight: 600;
                font-size: 0.85rem;
                color: #667eea;
                border: 2px solid rgba(102, 126, 234, 0.3);
                transition: all 0.3s ease;
                display: inline-block;
                max-width: 150px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .brand-badge:hover {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-color: transparent;
                transform: scale(1.05);
                max-width: none;
                white-space: normal;
            }

            .warranty-badge {
                background: linear-gradient(135deg, rgba(67, 233, 123, 0.15), rgba(56, 249, 215, 0.15));
                padding: 6px 12px;
                border-radius: 12px;
                font-weight: 600;
                font-size: 0.85rem;
                color: #43e97b;
                border: 2px solid rgba(67, 233, 123, 0.3);
                display: inline-flex;
                align-items: center;
                gap: 5px;
                transition: all 0.3s ease;
            }

            .warranty-badge:hover {
                background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
                color: white;
                border-color: transparent;
                transform: scale(1.05);
            }

            .product-id-badge {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 700;
                font-size: 0.9rem;
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
                transition: all 0.3s ease;
            }

            .product-id-badge:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
            }

            /* rê chuột hàng */
            tbody tr {
                transition: all 0.3s ease;
                cursor: pointer;
            }

            tbody tr:hover {
                background: linear-gradient(90deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
                transform: translateX(5px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            }

            #suggestionBox {
                background: white;
                border: 1px solid rgba(102, 126, 234, 0.2);
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                max-height: 300px;
                overflow-y: auto;
            }

            #suggestionBox .list-group-item {
                border: none;
                transition: all 0.3s ease;
                padding: 12px 16px;
            }

            #suggestionBox .list-group-item:hover {
                background: linear-gradient(90deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
                transform: translateX(5px);
                padding-left: 20px;
            }

            .card {
                border-radius: 16px !important;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08) !important;
                transition: all 0.3s ease;
                border: none !important;
            }

            .card:hover {
                box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12) !important;
            }

            .alert {
                border-radius: 12px;
                border: none;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                animation: slideDown 0.5s ease-out;
            }


            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .filter-active {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                color: white !important;
                border-color: transparent !important;
            }

            .form-control:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
            }

            .dropdown-menu {
                border-radius: 12px;
                border: none;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
                padding: 8px;
            }

            .dropdown-item {
                border-radius: 8px;
                margin: 2px 0;
                transition: all 0.3s ease;
                padding: 10px 16px;
            }

            .dropdown-item:hover {
                background: linear-gradient(90deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
                transform: translateX(5px);
                color: #667eea;
            }

            .dropdown-item.active {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            td:nth-child(4) {
                font-weight: 600;
                color: #333;
            }

            .supplier-info {
                color: #6c757d;
                font-size: 0.9rem;
            }

            .date-badge {
                background: rgba(108, 117, 125, 0.1);
                padding: 4px 10px;
                border-radius: 8px;
                font-size: 0.85rem;
                color: #6c757d;
                font-weight: 500;
            }

            .stat-card {
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
                border-radius: 12px;
                padding: 20px;
                transition: all 0.3s ease;
                border: 2px solid rgba(102, 126, 234, 0.2);
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
            }

            .stat-card .stat-number {
                font-size: 2rem;
                font-weight: 700;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            #suggestionBox::-webkit-scrollbar {
                width: 8px;
            }

            #suggestionBox::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 10px;
            }

            #suggestionBox::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 10px;
            }

            #suggestionBox::-webkit-scrollbar-thumb:hover {
                background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            }

            thead th {
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1)) !important;
                color: #667eea !important;
                font-weight: 700 !important;
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.5px;
                border: none !important;
                padding: 16px 12px !important;
            }

            .bi {
                transition: all 0.3s ease;
            }

            tr:hover .bi {
                transform: scale(1.1);
            }
        </style>
    </head>
    <body>
        <%
            Staff currentStaff = (Staff) session.getAttribute("user");
            if (currentStaff == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            if (currentStaff.getRole() != 2) {
                response.sendRedirect("login");
                return;
            }

            List<Products> listProducts = (List<Products>) request.getAttribute("listProducts");
            List<Category> listCategory = (List<Category>) request.getAttribute("listCategory");

            String currentBrand = request.getParameter("brandFilter") != null ? request.getParameter("brandFilter") : "All";
            String currentProductName = request.getParameter("productName") != null ? request.getParameter("productName") : "";

            List<String> allProductNames = new ArrayList<>();
            for (Products p : listProducts) {
                if (!allProductNames.contains(p.getName())) {
                    allProductNames.add(p.getName());
                }
            }

            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            currencyFormatter.setMaximumFractionDigits(0);
        %>

        <script>
    const allProductNames = <%= new Gson().toJson(allProductNames)%>;
        </script>

        <div class="d-flex" id="wrapper">
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="product?action=manageProduct" class="fw-bold text-primary"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="order?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li><a href="review?action=manageReview"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
                    <li><a href="importproduct?action=staff_import"><i class="bi bi-chat-left-text me-2"></i>importProduct</a></li>
                    <li><a href="voucher?action=viewVoucher" class="fw-bold text-primary">
                        <i class="bi bi-ticket-perforated me-2"></i>Voucher
                    </a></li>
                </ul>
            </nav>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">
                            <!-- Search Product -->
                            <form action="product" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="manageProduct">
                                <input type="hidden" name="brandFilter" value="<%= currentBrand%>">
                                <input class="form-control me-2" type="text" id="searchProduct" name="productName"
                                       placeholder="Search Product…" value="<%= currentProductName%>"
                                       oninput="showSuggestions(this.value)">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                                <div id="suggestionBox" class="list-group position-absolute w-100"
                                     style="top: 100%; z-index: 1000;"></div>
                            </form>

                            <form action="product" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="manageProduct">
                                <input type="hidden" name="productName" value="<%= currentProductName%>">
                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle <%= !currentBrand.equals("All") ? "filter-active" : ""%>"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> <%= currentBrand.equals("All") ? "Filter" : currentBrand%>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="brandFilter" value="All" class="dropdown-item <%= currentBrand.equals("All") ? "active" : ""%>">
                                            <i class="bi bi-grid-3x3-gap me-2"></i>All Brands
                                        </button></li>
                                    <li><hr class="dropdown-divider"></li>
                                        <%
                                            List<String> brandList = new ArrayList<>();
                                            for (Products p : listProducts) {
                                                if (!brandList.contains(p.getBrand())) {
                                                    brandList.add(p.getBrand());
                                                }
                                            }
                                            for (String brand : brandList) {
                                        %>
                                    <li><button type="submit" name="brandFilter" value="<%= brand%>" class="dropdown-item <%= currentBrand.equals(brand) ? "active" : ""%>">
                                            <i class="bi bi-tag me-2"></i><%= brand%>
                                        </button></li>
                                        <% }%>
                                </ul>
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                            <div class="d-flex align-items-center ms-3">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentStaff.getFullName()%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4">
                    <!-- Stats Overview -->
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-box-seam fs-1 text-primary me-3"></i>
                                    <div>
                                        <div class="text-muted small">Total Products</div>
                                        <div class="stat-number"><%= listProducts != null ? listProducts.size() : 0%></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-tags fs-1 text-primary me-3"></i>
                                    <div>
                                        <div class="text-muted small">Total Brands</div>
                                        <div class="stat-number"><%= brandList != null ? brandList.size() : 0%></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-grid-3x3-gap fs-1 text-primary me-3"></i>
                                    <div>
                                        <div class="text-muted small">Categories</div>
                                        <div class="stat-number"><%= listCategory != null ? listCategory.size() : 0%></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0 p-4">
                        <div class="card-body p-0">
                            <div class="d-flex justify-content-between align-items-center ps-3 mb-4">
                                <h4 class="fw-bold mb-0">
                                    <i class="bi bi-box-seam me-2"></i>Manage Products
                                </h4>
                                <% if (!currentBrand.equals("All") || !currentProductName.isEmpty()) { %>
                                <a href="product?action=manageProduct" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-x-circle me-1"></i>Clear Filters
                                </a>
                                <% } %>
                            </div>

                            <% if (listProducts != null && !listProducts.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th><i class="bi bi-hash me-1"></i>Product ID</th>
                                            <th><i class="bi bi-grid-3x3-gap me-1"></i>Category</th>
                                            <th><i class=""></i>Supplier</th>
                                            <th><i class="bi bi-box me-1"></i>Product Name</th>
                                            <th><i class="bi bi-tag me-1"></i>Brand</th>
                                            <th><i class="bi bi-shield-check me-1"></i>Warranty</th>
                                            <th><i class="bi bi-calendar-event me-1"></i>Created</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            int displayCount = 0;
                                            // filter brand
                                            for (Products p : listProducts) {
                                                if (!currentBrand.equals("All") && !p.getBrand().equals(currentBrand)) {
                                                    continue;
                                                }
                                                displayCount++;

                                                String catClass = "cat-default";
                                                if (p.getCategoryID() != null) {
                                                    catClass = "cat-" + p.getCategoryID();
                                                }
                                        %>
                                        <tr onclick="window.location.href = 'product?action=productDetail&productId=<%= p.getProductID()%>'">
                                            <td>
                                                <span class="product-id-badge">#<%= p.getProductID()%></span>
                                            </td>
                                            <td>
                                                <% for (Category ct : listCategory) {
                                                if (p.getCategoryID().equals(ct.getCategoryId())) {%>
                                                <span class="category-badge <%= catClass%>">
                                                    <%= ct.getCategoryName()%>
                                                </span>
                                                <% }
                                            }%>
                                            </td>
                                            <td>
                                                <span class="supplier-info">#<%= p.getSupplierID()%></span>
                                            </td>
                                            <td>
                                                <strong><%= p.getName()%></strong>
                                            </td>
                                            <td>
                                                <span class="brand-badge">
                                                    <%= p.getBrand()%>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="warranty-badge">
                                                    <i class="bi bi-shield-check"></i>
                                                    <%= p.getWarrantyPeriod()%> months
                                                </span>
                                            </td>
                                            <td>
                                                <span class="date-badge">
                                                    <i class="bi bi-calendar-event me-1"></i>
                                                    <%= p.getCreatedAt()%>
                                                </span>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                            <% if (displayCount == 0) { %>
                            <div class="alert alert-warning m-4" role="alert">
                                <i class="bi bi-exclamation-triangle me-2"></i>No products found matching your criteria.
                            </div>
                            <% } %>

                            <% } else { %>
                            <div class="alert alert-info m-4" role="alert">
                                <i class="bi bi-info-circle me-2"></i>No products available.
                            </div>
                            <% }%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                            // thu menu
                                            document.getElementById("menu-toggle").addEventListener("click", function () {
                                                document.getElementById("wrapper").classList.toggle("toggled");
                                            });

                                            // gợi í tên
                                            var debounceTimer;
                                            function showSuggestions(str) {
                                                clearTimeout(debounceTimer);
                                                debounceTimer = setTimeout(() => {
                                                    var box = document.getElementById("suggestionBox");
                                                    box.innerHTML = "";
                                                    if (str.length < 1)
                                                        return;

                                                    var matches = allProductNames.filter(name =>
                                                        name.toLowerCase().includes(str.toLowerCase())
                                                    );

                                                    if (matches.length > 0) {
                                                        matches.slice(0, 8).forEach(name => {
                                                            var item = document.createElement("button");
                                                            item.type = "button";
                                                            item.className = "list-group-item list-group-item-action";
                                                            item.innerHTML = '<i class="bi bi-box me-2"></i>' + name;
                                                            item.onclick = function () {
                                                                document.getElementById("searchProduct").value = name;
                                                                box.innerHTML = "";
                                                                document.getElementById("searchForm").submit();
                                                            };
                                                            box.appendChild(item);
                                                        });
                                                    } else {
                                                        var item = document.createElement("div");
                                                        item.className = "list-group-item text-muted small text-center";
                                                        item.innerHTML = '<i class="bi bi-search me-2"></i>No products found.';
                                                        box.appendChild(item);
                                                    }
                                                }, 200);
                                            }

                                            // tắt gợi í
                                            document.addEventListener('click', function (e) {
                                                var searchInput = document.getElementById('searchProduct');
                                                var suggestionBox = document.getElementById('suggestionBox');
                                                if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                                                    suggestionBox.innerHTML = "";
                                                }
                                            });

                                            // enter tìm
                                            document.getElementById('searchProduct').addEventListener('keydown', function (e) {
                                                if (e.key === 'Enter') {
                                                    e.preventDefault();
                                                    document.getElementById('searchForm').submit();
                                                }
                                            });
        </script>
    </body>
</html>


