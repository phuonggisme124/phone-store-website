<%@page import="model.Variants"%>
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
        <title>Staff Dashboard - Product Detail</title>
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

                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Storage
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
                                <span><%= currentUser.getFullName()%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4">
                    <div class="card shadow-sm border-0 p-4">
                        <div class="card-body p-0">
                            <div class="d-flex justify-content-between align-items-center ps-3 mb-4">
                                <div>
                                    <h4 class="fw-bold mb-1">Product Variants</h4>
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
                                            <th>VariantID</th>
                                            <th>Product Name</th>
                                            <th>Color</th>
                                            <th>Storage</th>
                                            <th>Price</th>
                                            <th>Discount Price</th>
                                            <th>Stock</th>
                                            <th>Description</th>
                                            <th>Image</th>
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
                                                
                                                // màu
                                                String textColor = "white";
                                                if (v.getColor().equalsIgnoreCase("white")) {
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
                                                <strong><%= String.format("%,.0f", v.getDiscountPrice())%> ₫</strong>
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
                                                     style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;">
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
        <script src="js/dashboard.js"></script>

        <script>
            //thu menu
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
                            item.textContent = color;
                            item.onclick = function () {
                                document.getElementById("searchColor").value = color;
                                box.innerHTML = "";
                                document.getElementById("searchColorForm").submit();
                            };
                            box.appendChild(item);
                        });
                    } else {
                        var item = document.createElement("div");
                        item.className = "list-group-item text-muted small";
                        item.textContent = "No colors found.";
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