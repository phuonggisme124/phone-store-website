
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%@page import="model.Promotions"%>
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
        <title>Admin Dashboard - Manage Promotions</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
        <link href="css/dashboard_admin_managepromotion.css" rel="stylesheet">

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

            List<Products> listProducts = (List<Products>) request.getAttribute("listProducts");
            List<Promotions> listPromotions = (List<Promotions>) request.getAttribute("listPromotions");

            // Lấy giá trị filter/search hiện tại từ request
            String currentDiscount = request.getParameter("discountFilter") != null ? request.getParameter("discountFilter") : "All";
            String currentProductName = request.getParameter("productName") != null ? request.getParameter("productName") : "";

            // Tạo danh sách tên sản phẩm để autocomplete
            List<String> allProductNames = new ArrayList<>();
            if (listPromotions != null && listProducts != null) {
                for (Promotions pmt : listPromotions) {
                    for (Products pd : listProducts) {
                        if (pmt.getProductID() == pd.getProductID() && !allProductNames.contains(pd.getName())) {
                            allProductNames.add(pd.getName());
                        }
                    }
                }
            }
        %>

        <script>
            const allProductNames = <%= new Gson().toJson(allProductNames)%>;

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

                            <!-- Search Product -->
                            <form action="admin" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="managePromotion">
                                <!-- Giữ lại discountFilter nếu đang filter -->
                                <input type="hidden" name="discountFilter" value="<%= currentDiscount%>">
                                <input class="form-control me-2" type="text" id="searchProduct" name="productName"
                                       placeholder="Search Product…" value="<%= currentProductName%>"

                                       oninput="showSuggestions(this.value)">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                                <div id="suggestionBox" class="list-group position-absolute w-100"
                                     style="top: 100%; z-index: 1000;"></div>
                            </form>

                            <!-- Filter Discount -->
                            <form action="admin" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="managePromotion">
                                <!-- Giữ lại productName nếu đang search -->

                                <input type="hidden" name="productName" value="<%= currentProductName%>">


                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Filter
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="discountFilter" value="All" class="dropdown-item">All Discounts</button></li>
                                    <li><button type="submit" name="discountFilter" value="0-20" class="dropdown-item">

                                            <i class="bi bi-tag"></i> 0% - 20%
                                        </button></li>
                                    <li><button type="submit" name="discountFilter" value="21-40" class="dropdown-item">
                                            <i class="bi bi-tag"></i> 21% - 40%
                                        </button></li>
                                    <li><button type="submit" name="discountFilter" value="41-60" class="dropdown-item">
                                            <i class="bi bi-tag"></i> 41% - 60%
                                        </button></li>
                                    <li><button type="submit" name="discountFilter" value="61-80" class="dropdown-item">
                                            <i class="bi bi-tag"></i> 61% - 80%
                                        </button></li>
                                    <li><button type="submit" name="discountFilter" value="81-100" class="dropdown-item">
                                            <i class="bi bi-tag-fill"></i> 81% - 100%
                                        </button></li>

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

                <!-- Promotions Table -->
                <%
                    String successCreatePromotion = (String) session.getAttribute("successCreatePromotion");
                    String successUpdatePromotion = (String) session.getAttribute("successUpdatePromotion");
                    String successDeletePromotion = (String) session.getAttribute("successDeletePromotion");
                    if (successCreatePromotion != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successCreatePromotion%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successCreatePromotion");
                    }
                %>
                
                
                <%
                    
                    
                    if (successUpdatePromotion != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successUpdatePromotion%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successUpdatePromotion");
                    }
                %>
                <%
                    
                    
                    if (successDeletePromotion != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successDeletePromotion%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successDeletePromotion");
                    }
                %>
                <div class="card shadow-sm border-0 p-4 m-3">
                    <div class="card-body p-0">
                        <div class="container-fluid p-4 ps-3">
                            <h1 class="fw-bold ps-3 mb-4 fw-bold text-primary">Manage Promotions</h1>
                        </div>
                        <!-- Create Promotion Button -->
                        <div class="container-fluid p-4">
                            <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm" href="promotion?action=createPromotion">
                                <i class="bi bi-tag-fill me-2"></i> Create Promotion
                            </a>
                        </div>
                        <% if (listPromotions != null && !listPromotions.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>PromotionID</th>
                                        <th>Product Name</th>
                                        <th>Discount Percent</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Promotions pmt : listPromotions) {
                                            // Tìm tên sản phẩm
                                            String productName = "";
                                            for (Products pd : listProducts) {
                                                if (pmt.getProductID() == pd.getProductID()) {
                                                    productName = pd.getName();
                                                    break;
                                                }
                                            }

                                            // Lọc theo Product Name nếu có search
                                            if (!currentProductName.isEmpty() && !productName.toLowerCase().contains(currentProductName.toLowerCase())) {
                                                continue;
                                            }

                                            // Lọc theo Discount Percent
                                            int discount = (int) pmt.getDiscountPercent();
                                            boolean matchDiscount = false;
                                            if (currentDiscount.equals("All")) {
                                                matchDiscount = true;
                                            } else if (currentDiscount.equals("0-20") && discount >= 0 && discount <= 20) {
                                                matchDiscount = true;
                                            } else if (currentDiscount.equals("21-40") && discount >= 21 && discount <= 40) {
                                                matchDiscount = true;
                                            } else if (currentDiscount.equals("41-60") && discount >= 41 && discount <= 60) {
                                                matchDiscount = true;
                                            } else if (currentDiscount.equals("61-80") && discount >= 61 && discount <= 80) {
                                                matchDiscount = true;
                                            } else if (currentDiscount.equals("81-100") && discount >= 81 && discount <= 100) {
                                                matchDiscount = true;
                                            }

                                            if (!matchDiscount) {
                                                continue;
                                            }

                                            // Xác định màu badge cho discount
                                            String discountBadge;
                                            if (discount >= 50) {
                                                discountBadge = "<span class='badge bg-danger status-green ' style='font-size: 15px'>" + pmt.getDiscountPercent() + "%</span>";
                                            } else if (discount >= 30) {
                                                discountBadge = "<span class='badge bg-warning text-dark status-yellow' style='font-size: 15px'>" + pmt.getDiscountPercent() + "%</span>";
                                            } else {
                                                discountBadge = "<span class='badge bg-info status-red' style='font-size: 15px'>" + pmt.getDiscountPercent() + "%</span>";
                                            }

                                            // Status badge
                                            String statusBadge;
                                            String status = pmt.getStatus();
                                            if (status != null && status.equalsIgnoreCase("Active")) {
                                                statusBadge = "<span class='badge status-green bg-success' style='font-size: 15px'>Active</span>";
                                            } else if (status != null && status.equalsIgnoreCase("Pending")) {
                                                statusBadge = "<span class='badge text-dark status-yellow bg-warning' style='font-size: 15px'>Pending</span>";
                                            } else {
                                                statusBadge = "<span class='badge status-red bg-danger' style='font-size: 15px'>Expired</span>";
                                            }
                                    %>

                                    <tr onclick="window.location.href = 'promotion?action=editPromotion&pmtID=<%= pmt.getPromotionID()%>&pID=<%= pmt.getProductID()%>'" style="cursor: pointer;">
                                        <td>#<%= pmt.getPromotionID()%></td>
                                        <td><%= productName%></td>
                                        <td><%= discountBadge%></td>
                                        <%
                                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                                            String startDateFormatted = "";
                                            String endDateFormatted = "";

                                            LocalDateTime start = pmt.getStartDate();
                                            LocalDateTime end = pmt.getEndDate();

                                            if (start != null) {
                                                startDateFormatted = start.format(formatter);
                                            }
                                            if (end != null)
                                                endDateFormatted = end.format(formatter);
                                        %>

                                        <td><%= startDateFormatted%></td>
                                        <td><%= endDateFormatted%></td>
                                        <td style="font-size: 15px"><%= statusBadge%></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info m-4" role="alert">
                            <i class="bi bi-info-circle me-2"></i>No promotions available.
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
                                        // Menu toggle
                                        document.getElementById("menu-toggle").addEventListener("click", function () {
                                            document.getElementById("wrapper").classList.toggle("toggled");
                                        });

                                        // ------------------ Autocomplete ------------------
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
                                        document.addEventListener('click', function (e) {
                                            var searchInput = document.getElementById('searchProduct');
                                            var suggestionBox = document.getElementById('suggestionBox');
                                            if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                                                suggestionBox.innerHTML = "";
                                            }
                                        });
        </script>
        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
</html>