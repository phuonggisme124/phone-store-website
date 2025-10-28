<%@page import="com.google.gson.Gson"%>
<%@page import="model.Review"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>

<<<<<<< Updated upstream
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
    <nav class="sidebar bg-white shadow-sm border-end">
        <div class="sidebar-header p-3">
            <h4 class="fw-bold text-primary">MiniStore</h4>
        </div>
        <ul class="list-unstyled ps-3">
            <li><a href="admin"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
            <li><a href="admin?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
            <li><a href="admin?action=manageSupplier"><i class="bi bi-truck me-2"></i>Suppliers</a></li>
            <li><a href="admin?action=managePromotion"><i class="bi bi-tag me-2"></i>Promotions</a></li>
            <li><a href="admin?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
            <li><a href="admin?action=manageReview" class="active"><i class="bi bi-chat-dots me-2"></i>Reviews</a></li>
            <li><a href="admin?action=manageUser"><i class="bi bi-people me-2"></i>Users</a></li>
            <li><a href="#"><i class="bi bi-gear me-2"></i>Settings</a></li>
        </ul>
    </nav>

    <!-- Page Content -->
    <div class="page-content flex-grow-1">
        <!-- Navbar -->
        <nav class="navbar navbar-light bg-white shadow-sm">
            <div class="container-fluid d-flex align-items-center justify-content-between">

                <div class="d-flex align-items-center">
                    <button class="btn btn-outline-primary me-3" id="menu-toggle"><i class="bi bi-list"></i></button>

                    <!-- Search + Filter -->
                    <form class="d-flex" action="admin?action=manageReview" method="get">
                        <input type="hidden" name="action" value="manageReview">
                        <input type="text" name="productName" class="form-control me-2" placeholder="🔍 Search product..." value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
                        <select name="ratingFilter" class="form-select me-2" style="width: 150px;">
                            <option value="All" <%= "All".equals(request.getParameter("ratingFilter")) ? "selected" : "" %>>All Ratings</option>
                            <option value="5" <%= "5".equals(request.getParameter("ratingFilter")) ? "selected" : "" %>>5 Stars</option>
                            <option value="4" <%= "4".equals(request.getParameter("ratingFilter")) ? "selected" : "" %>>4 Stars</option>
                            <option value="3" <%= "3".equals(request.getParameter("ratingFilter")) ? "selected" : "" %>>3 Stars</option>
                            <option value="2" <%= "2".equals(request.getParameter("ratingFilter")) ? "selected" : "" %>>2 Stars</option>
                            <option value="1" <%= "1".equals(request.getParameter("ratingFilter")) ? "selected" : "" %>>1 Star</option>
                        </select>
                        <button class="btn btn-primary">Filter</button>
                    </form>
                </div>

                <div class="d-flex align-items-center ms-auto">
                    <a href="logout" class="me-3">Logout</a>
                    <i class="bi bi-bell me-3 fs-5"></i>
                    <i class="bi bi-github fs-5 me-3"></i>
                    <div class="d-flex align-items-center">
                        <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                        <span>Admin</span>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Table -->
        <div class="card shadow-sm border-0 p-4 mt-3">
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>ReviewID</th>
                        <th>User Name</th>
                        <th>Product Name</th>
                        <th>Rating</th>
                        <th>Comment</th>
                        <th>Review Date</th>
                        <th>Reply</th>
                    </tr>
                    </thead>

                    <%
                        List<Review> listReview = (List<Review>) request.getAttribute("listReview");
                        ProductDAO pdao = new ProductDAO();
                        String currentRating = request.getParameter("ratingFilter") != null ? request.getParameter("ratingFilter") : "All";
                        String currentProductName = request.getParameter("productName") != null ? request.getParameter("productName").toLowerCase() : "";
                    %>

                    <tbody>
                    <%
                        for (Review r : listReview) {
                            String productName = pdao.getNameByID(r.getVariant().getProductID());
                            boolean matchRating = currentRating.equals("All") || r.getRating() == Integer.parseInt(currentRating);
                            boolean matchProduct = currentProductName.isEmpty() || productName.toLowerCase().contains(currentProductName);
                            if (matchRating && matchProduct) {
                    %>
                    <tr onclick="window.location.href='admin?action=reviewDetail&rID=<%= r.getReviewID()%>'">
                        <td><%= r.getReviewID()%></td>
                        <td><%= r.getUser().getFullName()%></td>
                        <td><%= productName %> <%= r.getVariant().getStorage() %></td>
                        <td><%= r.getRating()%></td>
                        <td><%= r.getComment()%></td>
                        <td><%= r.getReviewDate()%></td>
                        <td><%= r.getReply()%></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/dashboard.js"></script>
</body>
=======
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
            Users user = (Users) session.getAttribute("user");
            Integer productID = (Integer) request.getAttribute("productID");
            if (productID == null) {
                productID = 0;
            }
            String storage = (String) request.getAttribute("storage");
            
            if (storage == null || storage.isEmpty()) {
                storage = "";
            }
            Integer rating = (Integer) request.getAttribute("rating");
            
            if (rating == null) {
                rating = 0;
            }
        %>
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

                            <!-- Search Phone -->
                            <form action="admin" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="searchReview">
                                <input type="hidden" name="rating" value="<%= rating%>">

                                <!-- Hidden inputs lưu productID và storage -->
                                <input type="hidden" name="productID" id="productID">
                                <input type="hidden" name="storage" id="storage">

                                <div class="position-relative" style="width: 300px;">
                                    <input class="form-control" type="text" id="searchPhone"
                                           placeholder="Search Product Name..."
                                           value="">
                                    <div id="suggestionBox" class="list-group position-absolute w-100"
                                         style="top: 100%; z-index: 1000;"></div>
                                </div>

                                <button class="btn btn-outline-primary ms-2" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                            </form>



                            <!-- Filter Status -->
                            <form action="admin" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="filterReview">
                                <!-- Giữ lại phone nếu đang search -->
                                <input type="hidden" name="productID" value="<%= productID%>">
                                <input type="hidden" name="storage" value="<%= storage%>">

                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle" 
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i>
                                    <span id="selectedStatus">
                                        <%= (rating==0)? "All" : rating%>
                                    </span>
                                </button>

                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="rating" value="0" class="dropdown-item">All</button></li>
                                    <li><button type="submit" name="rating" value="5" class="dropdown-item">5</button></li>
                                    <li><button type="submit" name="rating" value="4" class="dropdown-item">4</button></li>
                                    <li><button type="submit" name="rating" value="3" class="dropdown-item">3</button></li>
                                    <li><button type="submit" name="rating" value="2" class="dropdown-item">2</button></li>
                                    <li><button type="submit" name="rating" value="1" class="dropdown-item">1</button></li>
                                </ul>
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                            <div class="d-flex align-items-center ms-3">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= user != null ? user.getFullName() : "Admin"%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Search bar -->
                <div class="container-fluid p-4">
                    <input type="text" class="form-control w-25" placeholder="🔍 Search">
                </div>


                <!-- Table -->
                <div class="card shadow-sm border-0 p-4">
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ReviewID</th>
                                    <th>User Name</th>
                                    <th>Product Name</th>
                                    <th>Rating</th>
                                    <th>Comment</th>
                                    <th>Review Date</th>
                                    <th>Reply</th>

                                </tr>
                            </thead>

                            

                            <%
                                for (Review r : listReview) {
                                    String fullProductName = pdao.getNameByID(r.getVariant().getProductID()) + " " + r.getVariant().getStorage();

                            %>

                            <tbody>
                                <tr data-productname="<%= fullProductName%>"
                                    data-productid="<%= r.getVariant().getProductID()%>"
                                    data-storage="<%= r.getVariant().getStorage()%>"
                                    onclick="window.location.href = 'admin?action=reviewDetail&rID=<%= r.getReviewID()%>'">

                                    <td><%= r.getReviewID()%></td>
                                    <td><%= r.getUser().getFullName()%></td>
                                    <td><%= fullProductName%></td>
                                    <td><%= r.getRating()%></td>
                                    <td><%= r.getComment()%></td>
                                    <td><%= r.getReviewDate()%></td>
                                    <td><%= r.getReply()%></td>
                                </tr>
                            </tbody>


                            <%

                                }
                            %>

                        </table>
                    </div>
                </div>
            </div>
        </div>>

        <!-- JS Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

        <!-- Custom JS -->
        <script src="js/dashboard.js"></script>
        <script>
                                        document.addEventListener("DOMContentLoaded", function () {
                                            // ===== LẤY DANH SÁCH SẢN PHẨM KHÔNG TRÙNG =====
                                            const rows = document.querySelectorAll("table tbody tr");
                                            const productMap = new Map(); // Map<ProductName, {productID, storage}>

                                            rows.forEach(row => {
                                                const name = row.getAttribute("data-productname")?.trim();
                                                const productID = row.getAttribute("data-productid");
                                                const storage = row.getAttribute("data-storage");
                                                if (name && productID && storage && !productMap.has(name)) {
                                                    productMap.set(name, {productID, storage});
                                                }
                                            });

                                            const uniqueProducts = Array.from(productMap.keys());
                                            const searchInput = document.getElementById("searchPhone");
                                            const productInput = document.getElementById("productID");
                                            const storageInput = document.getElementById("storage");
                                            const suggestionBox = document.getElementById("suggestionBox");

                                            // ===== GỢI Ý TÌM KIẾM =====
                                            function fetchSuggestions(query) {
                                                query = query.trim().toLowerCase();
                                                suggestionBox.innerHTML = "";

                                                if (!query) {
                                                    suggestionBox.style.display = "none";
                                                    return;
                                                }

                                                const matches = uniqueProducts.filter(name => name.toLowerCase().includes(query));

                                                if (matches.length === 0) {
                                                    suggestionBox.style.display = "none";
                                                    return;
                                                }

                                                matches.forEach(name => {
                                                    const item = document.createElement("button");
                                                    item.type = "button";
                                                    item.className = "list-group-item list-group-item-action";
                                                    item.innerHTML = highlightMatch(name, query);

                                                    item.addEventListener("click", () => {
                                                        const data = productMap.get(name);
                                                        searchInput.value = name;
                                                        productInput.value = data.productID;  // 🔥 Gửi productID
                                                        storageInput.value = data.storage;    // 🔥 Gửi storage
                                                        suggestionBox.style.display = "none";
                                                        document.getElementById("searchForm").submit();
                                                    });

                                                    suggestionBox.appendChild(item);
                                                });

                                                suggestionBox.style.display = "block";
                                            }

                                            // ===== HIGHLIGHT PHẦN KHỚP =====
                                            function highlightMatch(text, keyword) {
                                                const regex = new RegExp(`(${keyword})`, "gi");
                                                return text.replace(regex, `<strong>$1</strong>`);
                                            }

                                            // ===== ẨN BOX KHI CLICK RA NGOÀI =====
                                            document.addEventListener("click", (e) => {
                                                if (!e.target.closest("#searchForm")) {
                                                    suggestionBox.style.display = "none";
                                                }
                                            });

                                            // ===== LẮNG NGHE GÕ PHÍM =====
                                            searchInput.addEventListener("input", function () {
                                                fetchSuggestions(this.value);
                                            });
                                        });
        </script>



        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
>>>>>>> Stashed changes
</html>
