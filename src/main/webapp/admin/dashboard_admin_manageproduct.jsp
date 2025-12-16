
<%@page import="model.Staff"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>

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


        <link href="css/dashboard_manageproduct.css" rel="stylesheet">

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

            <%@ include file="sidebar.jsp"%>


            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">

                            <form action="product" method="get" class="position-relative mb-0" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="manageProduct">
                                <input type="hidden" name="brandFilter" value="<%= currentBrand%>">

                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted ps-3 rounded-start-pill border-light-purple">
                                        <i class="bi bi-box-seam"></i>
                                    </span>
                                    <input class="form-control border-start-0 border-end-0 border-light-purple shadow-none" 
                                           type="text" 
                                           id="searchProduct" 
                                           name="productName"
                                           placeholder="Search Product..." 
                                           value="<%= currentProductName%>"
                                           oninput="showSuggestions(this.value)"
                                           style="width: 220px; font-size: 0.9rem;">
                                    <button class="btn btn-gradient-primary rounded-end-pill px-3" type="submit">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>

                                <div id="suggestionBox" class="list-group position-absolute w-100 mt-1 shadow-lg border-0 rounded-3 overflow-hidden"
                                     style="top: 100%; z-index: 1000;"></div>
                            </form>

                            <form action="product" method="get" class="dropdown mb-0">
                                <input type="hidden" name="action" value="manageProduct">
                                <input type="hidden" name="productName" value="<%= currentProductName%>">

                                <button class="btn btn-outline-custom dropdown-toggle px-3 rounded-pill d-flex align-items-center gap-2"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel-fill"></i> 
                                    <span>Brand: <%= currentBrand.equals("All") ? "All" : currentBrand%></span>
                                </button>

                                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 mt-2" aria-labelledby="filterDropdown">
                                    <li>
                                        <button type="submit" name="brandFilter" value="All" class="dropdown-item <%= currentBrand.equals("All") ? "active-gradient" : ""%>">
                                            <i class="bi bi-grid-fill me-2 text-muted"></i> All Brands
                                        </button>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                        <% for (String brand : allBrands) {%>
                                    <li>
                                        <button type="submit" name="brandFilter" value="<%= brand%>" class="dropdown-item <%= brand.equals(currentBrand) ? "active-gradient" : ""%>">
                                            <i class="bi bi-tag-fill me-2 text-primary"></i> <%= brand%>
                                        </button>
                                    </li>
                                    <% }%>
                                </ul>
                            </form>

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


                <!-- Products Table -->
                <%

                    String successDeleteProduct = (String) session.getAttribute("successDeleteProduct");
                    if (successDeleteProduct != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successDeleteProduct%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successCreateProduct");
                    }
                %>

                <div class="card shadow-sm border-0 p-4 m-3">
                    <div class="card-body p-0">
                        <div class="container-fluid p-4 ps-3">
                            <h1 class="fw-bold ps-3 mb-4 fw-bold text-primary">Manage Products</h1>
                        </div>
                        <!-- Create Product Button -->
                        <div class="container-fluid p-4 ps-3">
                            <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm" href="product?action=createProduct">
                                <i class="bi bi-box-seam me-2"></i> Create Product
                            </a>
                        </div>

                        <%
                            boolean hasSearch = !currentProductName.isEmpty();
                            boolean hasBrand = !currentBrand.equals("All");

                            if (hasSearch || hasBrand) {
                        %>
                        <div class="container-fluid px-4 mt-3 mb-2">
                            <div class="d-flex align-items-center flex-wrap gap-2">
                                <span class="text-secondary small fw-bold text-uppercase me-2" style="letter-spacing: 0.5px;">
                                    <i class="bi bi-funnel-fill me-1"></i> Filtering by:
                                </span>

                                <% if (hasSearch) {%>
                                <div class="filter-chip chip-gradient">
                                    <i class="bi bi-search me-1 opacity-75"></i>
                                    <span>Search: <strong><%= currentProductName%></strong></span>
                                    <a href="javascript:void(0)" onclick="clearSearch()" class="btn-close-chip text-white" title="Remove">
                                        <i class="bi bi-x-circle-fill"></i>
                                    </a>
                                </div>
                                <% } %>

                                <% if (hasBrand) {%>
                                <div class="filter-chip chip-light">
                                    <i class="bi bi-tag-fill me-1 text-primary"></i>
                                    <span>Brand: <strong class="text-dark"><%= currentBrand%></strong></span>
                                </div>
                                <% } %>

                                <a href="product?action=manageProduct" class="btn btn-sm btn-link text-danger text-decoration-none fw-bold ms-2 animate-hover">
                                    Clear All
                                </a>
                            </div>
                        </div>
                        <% } %>
                        <% if (currentListProduct != null && !currentListProduct.isEmpty()) { %>
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
                                            String catClass = "cat-default";
                                            for (Category ct : listCategory) {
                                                if (p.getCategoryID().equals(ct.getCategoryId())) {
                                                    categoryName = ct.getCategoryName();
                                                    catClass = "cat-" + ct.getCategoryId();
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
                                        <td>
                                            <span class="product-id-badge">#<%= p.getProductID()%></span>
                                        </td>
                                        <td><span class="category-badge <%= catClass%>">
                                                <%= categoryName%>
                                            </span>
                                        </td>
                                        <td><%= supplierName%></td>
                                        <td><strong><%= p.getName()%></strong></td>
                                        <td><span class="brand-badge">
                                                <%= p.getBrand()%>
                                            </span></td>
                                        <td><span class="warranty-badge">
                                                <i class="bi bi-shield-check"></i>
                                                <%= p.getWarrantyPeriod()%> months
                                            </span></td>
                                            <%
                                                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                                                String dateFormated = "";
                                                LocalDateTime createAt = p.getCreatedAt();
                                                if (createAt != null) {
                                                    dateFormated = createAt.format(formatter);
                                                }
                                            %>
                                        <td><%= dateFormated%></td>

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
        <script>
                                        // Biến lưu trữ ID của timeout để debounce
                                        var debounceTimer;

                                        function showSuggestions(str) {
                                            clearTimeout(debounceTimer);
                                            debounceTimer = setTimeout(() => {
                                                var box = document.getElementById("suggestionBox");
                                                box.innerHTML = "";

                                                // Nếu chuỗi rỗng thì không làm gì cả
                                                if (str.length < 1)
                                                    return;

                                                // SỬA LỖI 1: Dùng đúng biến allProductNames thay vì allPhones
                                                // Lọc không phân biệt hoa thường (toLowerCase) cho xịn
                                                var matches = allProductNames.filter(product =>
                                                    product.toLowerCase().includes(str.toLowerCase())
                                                );

                                                if (matches.length > 0) {
                                                    // Giới hạn chỉ hiện 5-7 gợi ý đầu tiên cho đỡ dài dòng
                                                    matches.slice(0, 7).forEach(product => {
                                                        var item = document.createElement("button");
                                                        item.type = "button";
                                                        item.className = "list-group-item list-group-item-action";
                                                        item.textContent = product;

                                                        item.onclick = function () {
                                                            // SỬA LỖI 2: Dùng đúng ID là searchProduct
                                                            document.getElementById("searchProduct").value = product;
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
                                            }, 200); // Thời gian delay 200ms
                                        }

                                        // Ẩn suggestions khi click bên ngoài
                                        document.addEventListener('click', function (e) {
                                            var searchInput = document.getElementById('searchProduct'); // SỬA ID
                                            var suggestionBox = document.getElementById('suggestionBox');
                                            if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                                                suggestionBox.innerHTML = "";
                                            }
                                        });

                                        function clearSearch() {
                                            document.getElementById("searchProduct").value = "";
                                            document.getElementById("searchForm").submit();
                                        }
        </script>
        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>

    </body>
</html>