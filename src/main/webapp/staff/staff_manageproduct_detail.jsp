<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Staff"%>
<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Staff Dashboard - Product Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="css/dashboard_staff.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
        <style>
            /* === SHARED STYLES FROM PRODUCT PAGE === */
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

            tbody tr {
                transition: all 0.3s ease;
                cursor: pointer;
            }

            tbody tr:hover {
                background: linear-gradient(90deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
                transform: translateX(5px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            }

            #colorSuggestionBox {
                background: white;
                border: 1px solid rgba(102, 126, 234, 0.2);
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                max-height: 300px;
                overflow-y: auto;
            }

            #colorSuggestionBox .list-group-item {
                border: none;
                transition: all 0.3s ease;
                padding: 12px 16px;
            }

            #colorSuggestionBox .list-group-item:hover {
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

            /* === CRITICAL: STYLED TABLE HEADER === */
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

            #colorSuggestionBox::-webkit-scrollbar {
                width: 8px;
            }

            #colorSuggestionBox::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 10px;
            }

            #colorSuggestionBox::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 10px;
            }

            #colorSuggestionBox::-webkit-scrollbar-thumb:hover {
                background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            }

            /* === SPECIFIC BADGES FOR THIS PAGE === */
            .badge.bg-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                padding: 6px 12px;
                border-radius: 12px;
                font-weight: 600;
            }

            .badge.bg-success {
                background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%) !important;
            }

            .badge.bg-warning {
                background: linear-gradient(135deg, #fa709a 0%, #fee140 100%) !important;
            }

            .badge.bg-danger {
                background: linear-gradient(135deg, #FF6B6B 0%, #FF8E53 100%) !important;
            }

            .badge.bg-secondary {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%) !important;
            }

            .filter-active {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                color: white !important;
                border-color: transparent !important;
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
            List<Variants> listVariants = (List<Variants>) request.getAttribute("listVariants");
            List<String> allColors = (List<String>) request.getAttribute("allColors");
            List<String> allStorages = (List<String>) request.getAttribute("allStorages");

            String selectedProductId = (String) request.getAttribute("selectedProductId");
            String currentColor = request.getParameter("color") != null ? request.getParameter("color") : "";
            String currentStorage = request.getParameter("storage") != null ? request.getParameter("storage") : "";

            Products currentProduct = null;
            if (selectedProductId != null && !selectedProductId.isEmpty()) {
                int productId = Integer.parseInt(selectedProductId);
                for (Products p : listProducts) {
                    if (p.getProductID() == productId) {
                        currentProduct = p;
                        break;
                    }
                }
            }
        %>

        <script>
            const allColors = <%= new Gson().toJson(allColors)%>;
            const allStorages = <%= new Gson().toJson(allStorages)%>;
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
                            <!-- Search Color -->
                            <form action="product" method="get" class="d-flex position-relative me-3" id="searchColorForm" autocomplete="off">
                                <input type="hidden" name="action" value="productDetail">
                                <input type="hidden" name="productId" value="<%= selectedProductId != null ? selectedProductId : ""%>">
                                <input type="hidden" name="storage" value="<%= currentStorage%>">
                                <input class="form-control me-2" type="text" id="searchColor" name="color"
                                       placeholder="Search Color…" value="<%= currentColor%>"
                                       oninput="showColorSuggestions(this.value)" style="width: 150px;">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                                <div id="colorSuggestionBox" class="list-group position-absolute w-100"
                                     style="top: 100%; z-index: 1000;"></div>
                            </form>

                            <!-- filter -->
                            <form action="product" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="productDetail">
                                <input type="hidden" name="productId" value="<%= selectedProductId != null ? selectedProductId : ""%>">
                                <input type="hidden" name="color" value="<%= currentColor%>">

                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle <%= !currentStorage.isEmpty() ? "filter-active" : ""%>"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> <%= currentStorage.isEmpty() ? "Storage" : currentStorage%>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="storage" value="" class="dropdown-item">All Storage</button></li>
                                    <% if (allStorages != null) {
                                        for (String storage : allStorages) {%>
                                    <li><button type="submit" name="storage" value="<%= storage%>" class="dropdown-item <%= storage.equals(currentStorage) ? "active" : ""%>"><%= storage%></button></li>
                                        <% }
                                    }%>
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
                    <div class="card shadow-sm border-0 p-4">
                        <div class="card-body p-0">
                            <div class="d-flex justify-content-between align-items-center ps-3 mb-4">
                                <div>
                                    <h4 class="fw-bold mb-1">
                                        <i class="bi bi-grid-1x2 me-2"></i>Product Variants
                                    </h4>
                                    <% if (currentProduct != null) {%>
                                    <p class="text-muted mb-0">
                                        <i class="bi bi-box-seam me-2"></i>
                                        Product: <span class="fw-semibold"><%= currentProduct.getName()%></span>
                                    </p>
                                    <% } %>
                                </div>
                                <a href="product?action=manageProduct" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-2"></i>Back to Products
                                </a>
                            </div>

                            <!-- filters -->
                            <% if (!currentColor.isEmpty() || !currentStorage.isEmpty()) { %>
                            <div class="ps-3 mb-3">
                                <span class="text-muted me-2">Active Filters:</span>
                                <% if (!currentColor.isEmpty()) {%>
                                <span class="badge bg-primary me-2">
                                    Color: <%= currentColor%>
                                    <a href="product?action=productDetail&productId=<%= selectedProductId%>&storage=<%= currentStorage%>" 
                                       class="text-white ms-1" style="text-decoration: none;">×</a>
                                </span>
                                <% } %>
                                <% if (!currentStorage.isEmpty()) {%>
                                <span class="badge bg-secondary me-2">
                                    Storage: <%= currentStorage%>
                                    <a href="product?action=productDetail&productId=<%= selectedProductId%>&color=<%= currentColor%>" 
                                       class="text-white ms-1" style="text-decoration: none;">×</a>
                                </span>
                                <% }%>
                                <a href="product?action=productDetail&productId=<%= selectedProductId%>" class="btn btn-sm btn-outline-danger">
                                    Clear All
                                </a>
                            </div>
                            <% } %>

                            <%
                                if (listVariants != null && !listVariants.isEmpty() && selectedProductId != null) {
                                    int selProductId = Integer.parseInt(selectedProductId);
                            %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th><i class="bi bi-hash me-1"></i>Variant ID</th>
                                            <th><i class="bi bi-box me-1"></i>Product Name</th>
                                            <th><i class="bi bi-palette me-1"></i>Color</th>
                                            <th><i class="bi bi-device-hdd me-1"></i>Storage</th>
                                            <th><i class="bi bi-currency-dollar me-1"></i>Price</th>
                                            <th><i class="bi bi-tag me-1"></i>Discount Price</th>
                                            <th><i class="bi bi-box-seam me-1"></i>Stock</th>
                                            <th><i class="bi bi-chat-left-text me-1"></i>Description</th>
                                            <th><i class="bi bi-image me-1"></i>Image</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Variants v : listVariants) {
                                                if (v.getProductID() != selProductId) {
                                                    continue;
                                                }
                                                Products matchedProduct = null;
                                                for (Products p : listProducts) {
                                                    if (p.getProductID() == v.getProductID()) {
                                                        matchedProduct = p;
                                                        break;
                                                    }
                                                }
                                                
                                                String textColor = "white";
                                                if (v.getColor().equalsIgnoreCase("white") || 
                                                    v.getColor().equalsIgnoreCase("yellow") ||
                                                    v.getColor().equalsIgnoreCase("silver")) {
                                                    textColor = "black";
                                                }
                                        %>
                                        <tr>
                                            <td><span class="badge bg-primary">#<%= v.getVariantID()%></span></td>
                                            <td><strong><%= matchedProduct != null ? matchedProduct.getName() : "Unknown"%></strong></td>
                                            <td>
                                                <span class="badge" style="background-color: <%= v.getColor().toLowerCase()%>; color: <%= textColor%>;">
                                                    <%= v.getColor()%>
                                                </span>
                                            </td>
                                            <td><i class="bi bi-device-hdd me-1"></i><%= v.getStorage()%></td>
                                            <td><%= String.format("%,.0f", v.getPrice())%> ₫</td>
                                            <td>
                                                <% if (v.getDiscountPrice() != null) {%>
                                                <strong class="text-success"><%= String.format("%,.0f", v.getDiscountPrice())%> ₫</strong>
                                                <% } else { %>
                                                <span class="text-muted">N/A</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <% if (v.getStock() > 10) {%>
                                                <span class="badge bg-success"><%= v.getStock()%> units</span>
                                                <% } else if (v.getStock() > 0) {%>
                                                <span class="badge bg-warning text-dark"><%= v.getStock()%> units</span>
                                                <% } else { %>
                                                <span class="badge bg-danger">Out of Stock</span>
                                                <% }%>
                                            </td>
                                            <td><%= v.getDescription() != null ? (v.getDescription().length() > 50 ? v.getDescription().substring(0, 50) + "..." : v.getDescription()) : "N/A"%></td>
                                            <td>
                                                <% if (v.getImageUrl() != null && !v.getImageUrl().isEmpty()) {%>
                                                <img src="images/<%= v.getImageList()[0] %>" alt="Product" 
                                                     style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                                <% } else { %>
                                                <span class="text-muted">No image</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } else { %>
                            <div class="alert alert-info m-4" role="alert">
                                <i class="bi bi-info-circle me-2"></i>No variants available for this product.
                            </div>
                            <% }%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            var debounceTimer;
            function showColorSuggestions(str) {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    var box = document.getElementById("colorSuggestionBox");
                    box.innerHTML = "";
                    if (str.length < 1)
                        return;

                    var matches = allColors.filter(color =>
                        color.toLowerCase().includes(str.toLowerCase())
                    );

                    if (matches.length > 0) {
                        matches.slice(0, 5).forEach(color => {
                            var item = document.createElement("button");
                            item.type = "button";
                            item.className = "list-group-item list-group-item-action";
                            item.innerHTML = '<i class="bi bi-palette me-2"></i>' + color;
                            item.onclick = function () {
                                document.getElementById("searchColor").value = color;
                                box.innerHTML = "";
                                document.getElementById("searchColorForm").submit();
                            };
                            box.appendChild(item);
                        });
                    } else {
                        var item = document.createElement("div");
                        item.className = "list-group-item text-muted small text-center";
                        item.innerHTML = '<i class="bi bi-search me-2"></i>No colors found.';
                        box.appendChild(item);
                    }
                }, 200);
            }

            document.addEventListener('click', function (e) {
                var searchInput = document.getElementById('searchColor');
                var suggestionBox = document.getElementById('colorSuggestionBox');
                if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                    suggestionBox.innerHTML = "";
                }
            });
        </script>
    </body>
</html>


