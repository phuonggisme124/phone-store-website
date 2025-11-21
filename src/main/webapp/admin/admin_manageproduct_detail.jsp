
<%@page import="model.Promotions"%>
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
        <title>Admin Dashboard - Product Details</title>

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

            int pID = (int) request.getAttribute("pID");
            List<Products> listProducts = (List<Products>) request.getAttribute("listProducts");
            List<Variants> listVariants = (List<Variants>) request.getAttribute("listVariants");
            List<Promotions> listPromotions = (List<Promotions>) request.getAttribute("listPromotions");

            // Lấy danh sách màu sắc và storage unique
            List<String> allColors = new ArrayList<>();
            List<String> allStorages = new ArrayList<>();
            if (listVariants != null) {
                for (Variants v : listVariants) {
                    if (!allColors.contains(v.getColor())) {
                        allColors.add(v.getColor());
                    }
                    if (!allStorages.contains(v.getStorage())) {
                        allStorages.add(v.getStorage());
                    }
                }
            }

            // Tìm promotion cho product này
            Promotions activePromotion = null;
            if (listPromotions != null) {
                for (Promotions pmt : listPromotions) {
                    if (pmt.getProductID() == pID && "Active".equalsIgnoreCase(pmt.getStatus())) {
                        activePromotion = pmt;
                        break;
                    }
                }
            }

            // Tìm thông tin product hiện tại
            Products currentProduct = null;
            for (Products p : listProducts) {
                if (p.getProductID() == pID) {
                    currentProduct = p;
                    break;
                }
            }
        %>

        <script>
        const allColors = <%= new Gson().toJson(allColors)%>;
        const allStorages = <%= new Gson().toJson(allStorages)%>;
        </script>

        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">

                            <!-- Search Color -->
                            <div class="d-flex position-relative me-3" id="searchColorForm" autocomplete="off">
                                <input class="form-control me-2" type="text" id="searchColor"
                                       placeholder="Search Color…"
                                       oninput="handleColorSearch(this.value)" style="width: 150px;">
                                <button class="btn btn-outline-primary" type="button" onclick="applyFilters()">
                                    <i class="bi bi-search"></i>
                                </button>
                                <div id="colorSuggestionBox" class="list-group position-absolute w-100"
                                     style="top: 100%; z-index: 1000;"></div>
                            </div>

                            <!-- Filter Storage -->
                            <div class="dropdown me-3">
                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Storage
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="button" onclick="selectStorage('')" class="dropdown-item">All Storage</button></li>
                                        <% if (allStorages != null) {
                                        for (String storage : allStorages) {%>
                                    <li><button type="button" onclick="selectStorage('<%= storage%>')" class="dropdown-item">
                                            <%= storage%>
                                        </button></li>
                                        <% }
                                    }%>
                                </ul>
                            </div>

                            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                            <div class="d-flex align-items-center ms-3">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser.getFullName()%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Active Promotion Alert -->
                <% if (activePromotion != null) {%>
                <div class="container-fluid px-4 pt-4">
                    <div class="alert alert-success d-flex align-items-center" role="alert">
                        <i class="bi bi-tag-fill me-2 fs-4"></i>
                        <div>
                            <strong>Active Promotion:</strong> 
                            <%= activePromotion.getDiscountPercent()%>% OFF 
                            (Valid: <%= activePromotion.getStartDate()%> - <%= activePromotion.getEndDate()%>)
                        </div>
                    </div>
                </div>
                <% }%>

                <!-- Action Buttons -->
                <div class="container-fluid p-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm me-2" 
                               href="variants?action=createVariant&pID=<%= pID%>">
                                <i class="bi bi-sliders me-2"></i> Create Variant
                            </a>
                            <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm me-2" 
                               href="product?action=updateProduct&pID=<%= pID%>">
                                <i class="bi bi-sliders me-2"></i> Update Product
                            </a>
                            <a class="btn btn-danger px-4 py-2 rounded-pill shadow-sm" 
                               href="product?action=deleteProduct&pID=<%= pID%>">
                                <i class="bi bi-trash me-2"></i> Delete Product
                            </a>
                        </div>

                    </div>
                </div>

                <!-- Variants Table -->
                <%
                    String successCreateProduct = (String) session.getAttribute("successCreateProduct");
                    String successUpdateProduct = (String) session.getAttribute("successUpdateProduct");
                    String successDeleteProduct = (String) session.getAttribute("successDeleteProduct");
                    if (successCreateProduct != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successCreateProduct%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successCreateProduct");
                    }
                %>
                
                
                <%
                    
                    
                    if (successUpdateProduct != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successUpdateProduct%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successUpdateProduct");
                    }
                %>
                <%
                    
                    
                    if (successDeleteProduct != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successDeleteProduct%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successDeleteProduct");
                    }
                %>
                <div class="container-fluid px-4 pb-4">
                    <div class="card shadow-sm border-0 p-4">
                        <div class="card-body p-0">
                            <div class="ps-3 mb-4">
                                <h4 class="fw-bold mb-1">Product Variants</h4>
                                <% if (currentProduct != null) {%>
                                <p class="text-muted mb-0">
                                    <i class="bi bi-box-seam me-2"></i>
                                    Product: <span class="fw-semibold"><%= currentProduct.getName()%></span>
                                </p>
                                <% } %>
                            </div>

                            <!-- Active Filters Display -->
                            <div class="ps-3 mb-3" id="activeFiltersDisplay" style="display: none;">
                                <span class="text-muted me-2">Active Filters:</span>
                                <span id="colorFilterBadge" style="display: none;" class="badge bg-primary me-2">
                                    Color: <span id="colorFilterText"></span>
                                    <a href="javascript:void(0)" onclick="clearColorFilter()" 
                                       class="text-white ms-1" style="text-decoration: none;">×</a>
                                </span>
                                <span id="storageFilterBadge" style="display: none;" class="badge bg-secondary me-2">
                                    Storage: <span id="storageFilterText"></span>
                                    <a href="javascript:void(0)" onclick="clearStorageFilter()" 
                                       class="text-white ms-1" style="text-decoration: none;">×</a>
                                </span>
                                <button onclick="clearAllFilters()" class="btn btn-sm btn-outline-danger">
                                    Clear All
                                </button>
                            </div>

                            <% if (listVariants != null && !listVariants.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>VariantID</th>
                                            <th>Product Name</th>
                                            <th>Color</th>
                                            <th>Storage</th>
                                            <th>Original Price</th>
                                            <th>Discount Price</th>
                                            <th>Final Price</th>
                                            <th>Stock</th>
                                            <th>Description</th>
                                            <th>Image</th>
                                        </tr>
                                    </thead>
                                    <tbody id="variantsTableBody">
                                        <%
                                            for (Variants v : listVariants) {
                                                // Tìm tên sản phẩm
                                                String nameProduct = "";
                                                for (Products p : listProducts) {
                                                    if (p.getProductID() == v.getProductID()) {
                                                        nameProduct = p.getName();
                                                        break;
                                                    }
                                                }

                                                // Tính giá cuối cùng với promotion
                                                double finalPrice = v.getDiscountPrice();
                                                if (activePromotion != null) {
                                                    finalPrice = v.getDiscountPrice() * (1 - activePromotion.getDiscountPercent() / 100.0);
                                                }
                                                boolean hasPromotion = activePromotion != null;
                                        %>
                                        <tr class="variant-row" 
                                            data-color="<%= v.getColor().toLowerCase()%>" 
                                            data-storage="<%= v.getStorage()%>"
                                            onclick="window.location.href = 'variants?action=editVariant&vid=<%= v.getVariantID()%>&pID=<%= pID%>'" 
                                            style="cursor: pointer;">
                                            <td><span class="badge bg-primary">#<%= v.getVariantID()%></span></td>
                                            <td><strong><%= nameProduct%></strong></td>
                                            <td>
                                                <span class="badge" style="background-color: <%= v.getColor().toLowerCase()%>; color: white;">
                                                    <%= v.getColor()%>
                                                </span>
                                            </td>
                                            <td><i class="bi bi-device-hdd me-1"></i><%= v.getStorage()%></td>
                                            <td><span style="text-decoration: line-through; color: #999;">
                                                    <%= String.format("%,.0f", v.getPrice())%> ₫
                                                </span></td>
                                            <td>
                                                <% if (hasPromotion) {%>
                                                <span style="text-decoration: line-through; color: #999;">
                                                    <%= String.format("%,.0f", v.getDiscountPrice())%> ₫
                                                </span>
                                                <% } else {%>
                                                <strong><%= String.format("%,.0f", v.getDiscountPrice())%> ₫</strong>
                                                <% }%>
                                            </td>
                                            <td>
                                                <strong class="text-danger fs-5">
                                                    <%= String.format("%,.0f", finalPrice)%> ₫
                                                </strong>
                                                <% if (hasPromotion) {%>
                                                <span class="badge bg-danger ms-1">
                                                    -<%= activePromotion.getDiscountPercent()%>%
                                                </span>
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
                                <div id="noResultsMessage" style="display: none;" class="text-center py-4">
                                    <i class="bi bi-inbox fs-1 text-muted"></i>
                                    <p class="text-muted mt-2">No variants found matching your filters.</p>
                                </div>
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

        <!-- JS Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Custom JS -->
        <script src="js/dashboard.js"></script>
        <script>
                                                // Global variables
                                                let currentColorFilter = '';
                                                let currentStorageFilter = '';

                                                document.getElementById("menu-toggle").addEventListener("click", function () {
                                                    document.getElementById("wrapper").classList.toggle("toggled");
                                                });

                                                // ------------------ Autocomplete cho Color ------------------
                                                var debounceTimer;
                                                function handleColorSearch(str) {
                                                    var box = document.getElementById("colorSuggestionBox");
                                                    box.innerHTML = "";

                                                    if (str.length < 1) {
                                                        clearTimeout(debounceTimer);
                                                        return;
                                                    }

                                                    clearTimeout(debounceTimer);
                                                    debounceTimer = setTimeout(() => {
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
                                                                    currentColorFilter = color;
                                                                    applyFilters();
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

                                                // Ẩn suggestions khi click bên ngoài
                                                document.addEventListener('click', function (e) {
                                                    var searchInput = document.getElementById('searchColor');
                                                    var suggestionBox = document.getElementById('colorSuggestionBox');
                                                    if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                                                        suggestionBox.innerHTML = "";
                                                    }
                                                });

                                                // ------------------ Filter Functions ------------------
                                                function selectStorage(storage) {
                                                    currentStorageFilter = storage;
                                                    applyFilters();
                                                }

                                                function applyFilters() {
                                                    const colorInput = document.getElementById("searchColor").value.toLowerCase();
                                                    currentColorFilter = colorInput;

                                                    const rows = document.querySelectorAll('.variant-row');
                                                    let visibleCount = 0;

                                                    rows.forEach(row => {
                                                        const rowColor = row.getAttribute('data-color');
                                                        const rowStorage = row.getAttribute('data-storage');

                                                        const matchColor = !currentColorFilter || rowColor.includes(currentColorFilter);
                                                        const matchStorage = !currentStorageFilter || rowStorage === currentStorageFilter;

                                                        if (matchColor && matchStorage) {
                                                            row.style.display = '';
                                                            visibleCount++;
                                                        } else {
                                                            row.style.display = 'none';
                                                        }
                                                    });

                                                    // Update UI
                                                    updateFilterDisplay();

                                                    // Show/hide no results message
                                                    const noResultsMsg = document.getElementById('noResultsMessage');
                                                    const tableBody = document.getElementById('variantsTableBody');
                                                    if (visibleCount === 0) {
                                                        tableBody.style.display = 'none';
                                                        noResultsMsg.style.display = 'block';
                                                    } else {
                                                        tableBody.style.display = '';
                                                        noResultsMsg.style.display = 'none';
                                                    }
                                                }

                                                function updateFilterDisplay() {
                                                    const activeFiltersDiv = document.getElementById('activeFiltersDisplay');
                                                    const colorBadge = document.getElementById('colorFilterBadge');
                                                    const storageBadge = document.getElementById('storageFilterBadge');

                                                    if (currentColorFilter || currentStorageFilter) {
                                                        activeFiltersDiv.style.display = 'block';

                                                        if (currentColorFilter) {
                                                            colorBadge.style.display = 'inline-block';
                                                            document.getElementById('colorFilterText').textContent = currentColorFilter;
                                                        } else {
                                                            colorBadge.style.display = 'none';
                                                        }

                                                        if (currentStorageFilter) {
                                                            storageBadge.style.display = 'inline-block';
                                                            document.getElementById('storageFilterText').textContent = currentStorageFilter;
                                                        } else {
                                                            storageBadge.style.display = 'none';
                                                        }
                                                    } else {
                                                        activeFiltersDiv.style.display = 'none';
                                                    }
                                                }

                                                function clearColorFilter() {
                                                    currentColorFilter = '';
                                                    document.getElementById('searchColor').value = '';
                                                    applyFilters();
                                                }

                                                function clearStorageFilter() {
                                                    currentStorageFilter = '';
                                                    applyFilters();
                                                }

                                                function clearAllFilters() {
                                                    currentColorFilter = '';
                                                    currentStorageFilter = '';
                                                    document.getElementById('searchColor').value = '';
                                                    applyFilters();
                                                }

                                                // Press Enter to search
                                                document.getElementById('searchColor').addEventListener('keypress', function (e) {
                                                    if (e.key === 'Enter') {
                                                        e.preventDefault();
                                                        document.getElementById('colorSuggestionBox').innerHTML = '';
                                                        applyFilters();
                                                    }
                                                });
        </script>
        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
        <script>
            setTimeout(() => {
                const alert = document.querySelector('.alert');
                if (alert) {
                    alert.classList.remove('show');
                    alert.classList.add('fade');
                    setTimeout(() => alert.remove(), 500);
                }
            }, 3000);
        </script>
    </body>
</html>