
<%@page import="model.Staff"%>
<%@page import="model.Promotions"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

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
        <link href="css/dashboard_manageproduct.css" rel="stylesheet">
        <link href="css/dashboard_managevariant.css" rel="stylesheet">
    </head>
    <body>
        <%
            Staff currentUser = (Staff) session.getAttribute("user");
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
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">

                            <div class="position-relative" id="searchColorForm">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted ps-3 rounded-start-pill border-light-purple">
                                        <i class="bi bi-palette"></i>
                                    </span>
                                    <input class="form-control border-start-0 border-end-0 border-light-purple shadow-none" 
                                           type="text" 
                                           id="searchColor"
                                           placeholder="Search Color..."
                                           oninput="handleColorSearch(this.value)" 
                                           style="width: 180px; font-size: 0.9rem;">
                                    <button class="btn btn-gradient-primary rounded-end-pill px-3" type="button" onclick="applyFilters()">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                                <div id="colorSuggestionBox" class="list-group position-absolute w-100 mt-1 shadow-lg border-0 rounded-3 overflow-hidden"
                                     style="top: 100%; z-index: 1000;"></div>
                            </div>

                            <div class="dropdown">
                                <button class="btn btn-outline-custom dropdown-toggle px-3 rounded-pill d-flex align-items-center gap-2"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel-fill"></i> 
                                    <span id="selectedStorageText">Storage</span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 mt-2" aria-labelledby="filterDropdown">
                                    <li>
                                        <button type="button" onclick="selectStorage('')" class="dropdown-item active-gradient">
                                            <i class="bi bi-grid-fill me-2 text-muted"></i> All Storage
                                        </button>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                        <% if (allStorages != null) {
                                                for (String storage : allStorages) {%>
                                    <li>
                                        <button type="button" onclick="selectStorage('<%= storage%>')" class="dropdown-item">
                                            <i class="bi bi-device-hdd me-2 text-primary"></i> <%= storage%>
                                        </button>
                                    </li>
                                    <%     }
                                        }%>
                                </ul>
                            </div>

                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>

                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="position-relative">
                                        <img src="https://i.pravatar.cc/150?u=<%= currentUser.getStaffID()%>" 
                                             class="rounded-circle border border-2 border-white shadow-sm" 
                                             width="40" height="40" alt="Avatar">
                                        <span class="position-absolute bottom-0 start-100 translate-middle p-1 bg-success border border-light rounded-circle">
                                            <span class="visually-hidden">Online</span>
                                        </span>
                                    </div>
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;"><%= currentUser.getFullName()%></span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                    </div>
                                </div>

                                <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" 
                                   style="width: 38px; height: 38px;" title="Logout">
                                    <i class="bi bi-box-arrow-right fs-6"></i>
                                </a>
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
                    <div class="d-flex justify-content-between align-items-center bg-white p-3 rounded-4 shadow-sm border border-light">
                        <div>
                            <a href="product?action=manageProduct" class="btn btn-outline-secondary rounded-pill border-0">
                                <i class="bi bi-arrow-left"></i> Back
                            </a>
                        </div>

                        <div class="d-flex gap-2">
                            <a class="btn btn-action btn-create" 
                               href="variants?action=createVariant&pID=<%= pID%>">
                                <i class="bi bi-plus-lg me-1"></i> Add Variant
                            </a>

                            <a class="btn btn-action btn-update" 
                               href="product?action=updateProduct&pID=<%= pID%>">
                                <i class="bi bi-pencil-square me-1"></i> Edit Info
                            </a>

                            <a class="btn btn-action btn-delete" 
                               href="product?action=deleteProduct&pID=<%= pID%>"
                               onclick="return confirm('WARNING: Deleting this product will remove ALL variants. Are you sure?');">
                                <i class="bi bi-trash3 me-1"></i> Delete
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
                            <div class="ps-4 mb-4" id="activeFiltersDisplay" style="display: none;">
                                <div class="d-flex align-items-center flex-wrap gap-2">
                                    <span class="text-secondary small fw-bold text-uppercase me-2" style="letter-spacing: 0.5px;">
                                        <i class="bi bi-funnel-fill me-1"></i> Filtering by:
                                    </span>

                                    <div id="colorFilterBadge" class="filter-chip chip-gradient" style="display: none;">
                                        <i class="bi bi-palette-fill me-1 opacity-75"></i>
                                        <span>Color: <strong id="colorFilterText"></strong></span>
                                        
                                    </div>

                                    <div id="storageFilterBadge" class="filter-chip chip-light" style="display: none;">
                                        <i class="bi bi-device-hdd-fill me-1 text-primary"></i>
                                        <span>Storage: <strong id="storageFilterText" class="text-dark"></strong></span>
                                    </div>

                                    <button onclick="clearAllFilters()" class="btn btn-sm btn-link text-danger text-decoration-none fw-bold ms-2 animate-hover">
                                        Clear All
                                    </button>
                                </div>
                            </div>

                            <% if (listVariants != null && !listVariants.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">
                                                <i class="bi bi-upc-scan me-1"></i> VariantID
                                            </th>
                                            <th>
                                                <i class="bi bi-phone me-1"></i> Product Name
                                            </th>
                                            <th>
                                                <i class="bi bi-palette me-1"></i> Color
                                            </th>
                                            <th>
                                                <i class="bi bi-memory me-1"></i> Storage
                                            </th>
                                            <th>
                                                <i class="bi bi-tag me-1"></i> Original Price
                                            </th>
                                            <th>
                                                <i class="bi bi-percent me-1"></i> Discount Price
                                            </th>
                                            <th>
                                                <i class="bi bi-cash-stack me-1"></i> Final Price
                                            </th>
                                            <th>
                                                <i class="bi bi-box-seam me-1"></i> Stock
                                            </th>
                                            <th>
                                                <i class="bi bi-card-text me-1"></i> Description
                                            </th>
                                            <th class="text-center">
                                                <i class="bi bi-image me-1"></i> Image
                                            </th>
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

                                            <td class="ps-4"><span class="product-id-badge">#<%= v.getVariantID()%></span></td>

                                            <td class="fw-bold text-dark"><%= nameProduct%></td>

                                            <td>
                                                <div class="color-wrapper">
                                                    <span class="color-dot" style="background-color: <%= v.getColor().toLowerCase()%>; border-color: <%= v.getColor().equalsIgnoreCase("white") ? "#ddd" : "transparent"%>;"></span>
                                                    <span class="color-name" style="color: #555;"><%= v.getColor()%></span>
                                                </div>
                                            </td>

                                            <td>
                                                <div class="d-flex align-items-center text-secondary">
                                                    <i class="bi bi-device-hdd me-2 text-primary"></i>
                                                    <span class="fw-semibold"><%= v.getStorage()%></span>
                                                </div>
                                            </td>

                                            <td>
                                                <span class="price-original">
                                                    <%= String.format("%,.0f", v.getPrice())%> ₫
                                                </span>
                                            </td>

                                            <td>
                                                <% if (hasPromotion) {%>
                                                <span class="price-original">
                                                    <%= String.format("%,.0f", v.getDiscountPrice())%> ₫
                                                </span>
                                                <% } else {%>
                                                <span class="fw-semibold text-secondary"><%= String.format("%,.0f", v.getDiscountPrice())%> ₫</span>
                                                <% }%>
                                            </td>

                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <span class="price-final">
                                                        <%= String.format("%,.0f", finalPrice)%> ₫
                                                    </span>
                                                    <% if (hasPromotion) {%>
                                                    <span class="discount-tag shadow-sm">
                                                        -<%= activePromotion.getDiscountPercent()%>%
                                                    </span>
                                                    <% } %>
                                                </div>
                                            </td>

                                            <td>
                                                <% if (v.getStock() > 10) {%>
                                                <span class="stock-badge stock-success">
                                                    <i class="bi bi-check-circle-fill" style="font-size: 0.7rem;"></i> <%= v.getStock()%>
                                                </span>
                                                <% } else if (v.getStock() > 0) {%>
                                                <span class="stock-badge stock-warning">
                                                    <i class="bi bi-exclamation-circle-fill" style="font-size: 0.7rem;"></i> <%= v.getStock()%>
                                                </span>
                                                <% } else { %>
                                                <span class="stock-badge stock-danger">
                                                    <i class="bi bi-x-circle-fill" style="font-size: 0.7rem;"></i> Out
                                                </span>
                                                <% }%>
                                            </td>

                                            <td class="text-muted small">
                                                <div class="text-truncate" style="max-width: 150px;" title="<%= v.getDescription()%>">
                                                    <%= v.getDescription() != null ? v.getDescription() : "N/A"%>
                                                </div>
                                            </td>

                                            <td class="text-center">
                                                <% if (v.getImageUrl() != null && !v.getImageUrl().isEmpty()) {%>
                                                <img src="images/<%= v.getImageList()[0]%>" 
                                                     alt="Variant" 
                                                     class="variant-img"
                                                     style="width: 45px; height: 45px; object-fit: cover;">
                                                <% } else { %>
                                                <div class="rounded-circle bg-light d-inline-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                                    <i class="bi bi-image text-muted"></i>
                                                </div>
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