<%@page import="model.Staff"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="model.Review"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<<<<<<< HEAD
<%@page import="java.util.ArrayList"%>
<%@page import="model.Staff"%> <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Manage Reviews</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="css/dashboard_admin.css">
    <link href="css/dashboard_table.css" rel="stylesheet">
</head>
<body>
    <%
        // 1. SỬA: Lấy Staff từ Session (Admin là Staff Role 4)
        Staff user = (Staff) session.getAttribute("user");
        
        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // Kiểm tra quyền Admin (Role = 4)
        if (user.getRole() != 4) {
            response.sendRedirect("login"); 
            return;
        }

        ProductDAO pdao = new ProductDAO(); 
        List<Review> listReview = (List<Review>) request.getAttribute("listReview");
        if (listReview == null) listReview = new ArrayList<>(); // Tránh null pointer

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
        <%@ include file="sidebar.jsp" %>

        <div class="page-content flex-grow-1">
            <nav class="navbar navbar-light bg-white shadow-sm">
                <div class="container-fluid">
                    <button class="btn btn-outline-primary" id="menu-toggle">
                        <i class="bi bi-list"></i>
                    </button>
                    <div class="d-flex align-items-center ms-auto">

                        <form action="review" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                            <input type="hidden" name="action" value="searchReview">
                            <input type="hidden" name="rating" value="<%= rating%>">

                            <input type="hidden" name="productID" id="productID" value="<%= productID %>">
                            <input type="hidden" name="storage" id="storage" value="<%= storage %>">

                            <div class="position-relative" style="width: 300px;">
                                <input class="form-control" type="text" id="searchPhone"
                                       placeholder="Search Product Name..."
                                       value="">
                                <div id="suggestionBox" class="list-group position-absolute w-100"
                                     style="top: 100%; z-index: 1000;"></div>
=======

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Reviews</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_managereview.css">
        
    </head>
    <body>
        <%
            // 1. Kiểm tra đăng nhập
            Staff user = (Staff) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            // if (user.getRole() != 4) { response.sendRedirect("login"); return; } // Uncomment nếu cần check role

            ProductDAO pdao = new ProductDAO();
            List<Review> listReview = (List<Review>) request.getAttribute("listReview");

            // 2. Xử lý Rating (Tránh lỗi NullPointerException / NumberFormatException)
            int rating = 0;
            String ratingStr = request.getParameter("rating");
            if (ratingStr != null && !ratingStr.isEmpty()) {
                try {
                    rating = Integer.parseInt(ratingStr);
                } catch (NumberFormatException e) {
                    rating = 0;
                }
            }

            // 3. Xử lý các biến khác
            String productName = request.getParameter("productName"); // Lấy tên sản phẩm tìm kiếm để hiển thị lại
            if (productName == null) {
                productName = "";
            }

            String productIDStr = request.getParameter("productID");
            int productID = 0;
            if (productIDStr != null && !productIDStr.isEmpty()) {
                try {
                    productID = Integer.parseInt(productIDStr);
                } catch (Exception e) {
                }
            }

            String storage = request.getParameter("storage");
            if (storage == null)
                storage = "";
        %>

        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <div class="page-content flex-grow-1">

                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">

                            <form action="review" method="get" class="position-relative mb-0" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="searchReview">
                                <input type="hidden" name="rating" value="<%= rating%>">

                                <input type="hidden" name="productID" id="productID" value="<%= (productID > 0 ? productID : 0)%>">
                                <input type="hidden" name="storage" id="storage" value="<%= storage%>">

                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted ps-3 rounded-start-pill border-light-purple">
                                        <i class="bi bi-star"></i>
                                    </span>

                                    <input class="form-control border-start-0 border-end-0 border-light-purple shadow-none" 
                                           type="text" 
                                           id="searchProduct" 
                                           name="productName"
                                           placeholder="Search Product Name..." 
                                           value="<%= productName%>"
                                           oninput="fetchSuggestions(this.value)"
                                           style="width: 250px; font-size: 0.9rem;">

                                    <button class="btn btn-gradient-primary rounded-end-pill px-3" type="submit">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>

                                <div id="suggestionBox" class="list-group position-absolute w-100 mt-1 shadow-lg border-0 rounded-3 overflow-hidden"
                                     style="top: 100%; z-index: 1000; display: none;"></div>
                            </form>

                            <% String ratingLabel = (rating == 0) ? "All Ratings" : rating + " Stars";%>
                            <form action="review" method="get" class="dropdown mb-0">
                                <input type="hidden" name="action" value="filterReview">
                                <input type="hidden" name="productName" value="<%= productName%>">
                                <input type="hidden" name="productID" value="<%= (productID > 0 ? productID : 0)%>">
                                <input type="hidden" name="storage" value="<%= storage%>">

                                <button class="btn btn-outline-custom dropdown-toggle px-3 rounded-pill d-flex align-items-center gap-2"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel-fill"></i> 
                                    <span>Rating: <%= ratingLabel%></span>
                                </button>

                                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 mt-2" aria-labelledby="filterDropdown">
                                    <li>
                                        <button type="submit" name="rating" value="0" class="dropdown-item <%= (rating == 0) ? "active-gradient" : ""%>">
                                            <i class="bi bi-grid-fill me-2 text-muted"></i> All Ratings
                                        </button>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                        <% for (int r = 5; r >= 1; r--) {%>
                                    <li>
                                        <button type="submit" name="rating" value="<%= r%>" class="dropdown-item <%= (rating == r) ? "active-gradient" : ""%>">
                                            <i class="bi bi-star-fill me-2 text-warning"></i> <%= r%> Stars
                                        </button>
                                    </li>
                                    <% }%>
                                </ul>
                            </form>

                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>

                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="position-relative">
                                        <img src="https://i.pravatar.cc/150?u=<%= (user != null) ? user.getStaffID(): "admin"%>" 
                                             class="rounded-circle border border-2 border-white shadow-sm" 
                                             width="40" height="40" alt="Avatar">
                                        <span class="position-absolute bottom-0 start-100 translate-middle p-1 bg-success border border-light rounded-circle">
                                            <span class="visually-hidden">Online</span>
                                        </span>
                                    </div>
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;">
                                            <%= (user != null) ? user.getFullName() : "Administrator"%>
                                        </span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                    </div>
                                </div>

                                <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" 
                                   style="width: 38px; height: 38px;" title="Logout">
                                    <i class="bi bi-box-arrow-right fs-6"></i>
                                </a>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                            </div>

                            <button class="btn btn-outline-primary ms-2" type="submit">
                                <i class="bi bi-search"></i>
                            </button>
                        </form>

                        <form action="review" method="get" class="dropdown me-3">
                            <input type="hidden" name="action" value="filterReview">
                            <input type="hidden" name="productID" value="<%= productID%>">
                            <input type="hidden" name="storage" value="<%= storage%>">

                            <button class="btn btn-outline-secondary fw-bold dropdown-toggle" 
                                    type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-funnel"></i>
                                <span id="selectedStatus">
                                    <%= (rating==0)? "All Ratings" : rating + " Stars"%>
                                </span>
                            </button>

                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                <li><button type="submit" name="rating" value="0" class="dropdown-item">All</button></li>
                                <li><button type="submit" name="rating" value="5" class="dropdown-item">5 Stars</button></li>
                                <li><button type="submit" name="rating" value="4" class="dropdown-item">4 Stars</button></li>
                                <li><button type="submit" name="rating" value="3" class="dropdown-item">3 Stars</button></li>
                                <li><button type="submit" name="rating" value="2" class="dropdown-item">2 Stars</button></li>
                                <li><button type="submit" name="rating" value="1" class="dropdown-item">1 Star</button></li>
                            </ul>
                        </form>

                        <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                        <div class="d-flex align-items-center ms-3">
                            <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                            <span><%= user.getFullName()%></span>
                        </div>
                    </div>
<<<<<<< HEAD
                </div>
            </nav>

            <div class="container-fluid p-4">
                <h1 class="fw-bold text-primary">Manage Reviews</h1>
            </div>

            <div class="card shadow-sm border-0 p-4 m-3">
                <div class="card-body p-0">
                    <% if (listReview != null && !listReview.isEmpty()) { %>
                    <div class="table-responsive">
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
                            <tbody>
                            <%
                                for (Review r : listReview) {
                                    // Lấy tên sản phẩm từ ProductDAO
                                    String fullProductName = pdao.getNameByID(r.getVariant().getProductID()) + " " + r.getVariant().getStorage();
                            %>
                                <tr style="cursor: pointer;" 
                                    data-productname="<%= fullProductName%>"
                                    data-productid="<%= r.getVariant().getProductID()%>"
                                    data-storage="<%= r.getVariant().getStorage()%>"
                                    onclick="window.location.href = 'review?action=reviewDetail&rID=<%= r.getReviewID()%>'">
                                    
                                    <td>#<%= r.getReviewID()%></td>
                                    <td><%= r.getUser().getFullName()%></td>
                                    <td><%= fullProductName%></td>
                                    <td>
                                        <span class="text-warning fw-bold"><%= r.getRating()%> <i class="bi bi-star-fill"></i></span>
                                    </td>
                                    <td>
                                        <% 
                                            String comment = r.getComment();
                                            if (comment != null && comment.length() > 50) {
                                                comment = comment.substring(0, 50) + "...";
                                            }
                                        %>
                                        <%= comment %>
                                    </td>
                                    <td><%= r.getReviewDate()%></td>
                                    <td>
                                        <% if(r.getReply() != null && !r.getReply().isEmpty()) { %>
                                            <span class="badge bg-success">Replied</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">No Reply</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
=======
                </nav>

                <div class="card shadow-sm border-0 rounded-4 m-3 overflow-hidden">
                    <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Manage Reviews</h4>
                            <p class="text-muted small mb-0">Customer feedback and ratings</p>
                        </div>
                    </div>

                    <%
                        boolean hasSearch = !productName.isEmpty();
                        boolean hasRating = (rating > 0);

                        if (hasSearch || hasRating) {
                    %>
                    <div class="bg-light-purple bg-opacity-10 px-4 py-2 border-bottom d-flex align-items-center flex-wrap gap-2">
                        <span class="text-muted small fw-bold me-2"><i class="bi bi-funnel-fill me-1"></i>Filters:</span>

                        <% if (hasSearch) {%>
                        <span class="filter-chip chip-light">
                            Product: <span class="fw-bold ms-1 text-primary"><%= productName%></span>
                            <a href="review?action=searchReview&rating=<%= rating%>" class="btn-close-chip" title="Remove search"><i class="bi bi-x"></i></a>
                        </span>
                        <% } %>

                        <% if (hasRating) {%>
                        <span class="filter-chip chip-gradient">
                            Rating: <span class="fw-bold ms-1"><%= rating%> <i class="bi bi-star-fill text-warning" style="font-size: 0.7rem;"></i></span>
                            <a href="review?action=searchReview&productName=<%= productName%>&productID=<%= (productID > 0 ? productID : "")%>&storage=<%= storage%>" class="btn-close-chip" title="Reset rating"><i class="bi bi-x"></i></a>
                        </span>
                        <% } %>

                       
                        <a href="review?action=manageReview" class="btn btn-sm btn-link text-danger text-decoration-none fw-bold ms-2 animate-hover">
                            Clear All
                        </a>
                    </div>
                    <% } %>

                    <div class="card-body p-0">
                        <% if (listReview != null && !listReview.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 custom-table">
                                <thead class="bg-light-purple text-uppercase small fw-bold text-muted">
                                    <tr>
                                        <th class="ps-4">ID</th>
                                        <th>User</th>
                                        <th>Product Name</th>
                                        <th>Rating</th>
                                        <th>Comment</th>
                                        <th>Date</th>
                                        <th>Reply</th>
                                    </tr>
                                </thead>
                                <tbody class="border-top-0">
                                    <%
                                        for (Review r : listReview) {
                                            String fullProductName = pdao.getNameByID(r.getVariant().getProductID()) + " " + r.getVariant().getStorage();
                                    %>
                                    <tr data-productname="<%= fullProductName%>"
                                        data-productid="<%= r.getVariant().getProductID()%>"
                                        data-storage="<%= r.getVariant().getStorage()%>"
                                        onclick="window.location.href = 'review?action=reviewDetail&rID=<%= r.getReviewID()%>'"
                                        class="cursor-pointer transition-hover">

                                        <td class="ps-4"><span class="product-id-badge">#<%= r.getReviewID()%></span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="rounded-circle bg-light d-flex justify-content-center align-items-center text-secondary fw-bold" style="width: 32px; height: 32px;">
                                                    <%= r.getUser().getFullName().substring(0, 1).toUpperCase()%>
                                                </div>
                                                <span class="fw-bold text-dark"><%= r.getUser().getFullName()%></span>
                                            </div>
                                        </td>
                                        <td><span class="text-primary fw-bold"><%= fullProductName%></span></td>
                                        <td>
                                            <div class="text-warning">
                                                <% for (int i = 1; i <= 5; i++) {%>
                                                <i class="bi <%= (i <= r.getRating()) ? "bi-star-fill" : "bi-star"%>"></i>
                                                <% }%>
                                            </div>
                                        </td>
                                        <td style="max-width: 300px;">
                                            <div class="text-truncate text-secondary" title="<%= r.getComment()%>"><%= r.getComment()%></div>
                                        </td>
                                        <td><small class="text-muted"><%= r.getReviewDate()%></small></td>
                                        <td>
                                            <% if (r.getReply() != null && !r.getReply().isEmpty()) { %>
                                            <span class="badge bg-success-subtle text-success"><i class="bi bi-check-circle me-1"></i>Replied</span>
                                            <% } else { %>
                                            <span class="badge bg-warning-subtle text-warning"><i class="bi bi-hourglass-split me-1"></i>Waiting</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="text-center p-5">
                            <div class="mb-3"><i class="bi bi-chat-square-quote text-muted" style="font-size: 3rem; opacity: 0.5;"></i></div>
                            <h5 class="text-muted">No reviews found</h5>
                            <p class="text-secondary small">Try adjusting filters.</p>
                        </div>
                        <% }%>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                    </div>
                    <% } else { %>
                        <div class="alert alert-info m-4">No reviews found matching your criteria.</div>
                    <% } %>
                </div>
            </div>
        </div>
<<<<<<< HEAD
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Lấy danh sách sản phẩm để gợi ý (Logic JS giữ nguyên)
            const rows = document.querySelectorAll("table tbody tr");
            const productMap = new Map();

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
                        productInput.value = data.productID; 
                        storageInput.value = data.storage;   
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
            
            // Toggle Sidebar
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        });
    </script>
</body>
=======

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                            document.addEventListener("DOMContentLoaded", function () {
                                                // ===== 1. THU THẬP DỮ LIỆU SẢN PHẨM TỪ BẢNG ĐỂ LÀM GỢI Ý =====
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
                                                const searchInput = document.getElementById("searchProduct");
                                                const productInput = document.getElementById("productID");
                                                const storageInput = document.getElementById("storage");
                                                const suggestionBox = document.getElementById("suggestionBox");

                                                // ===== 2. HÀM TÌM KIẾM GỢI Ý =====
                                                window.fetchSuggestions = function (query) {
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
                                                        item.className = "list-group-item list-group-item-action text-start";
                                                        item.innerHTML = highlightMatch(name, query);

                                                        item.addEventListener("click", () => {
                                                            const data = productMap.get(name);
                                                            searchInput.value = name;
                                                            productInput.value = data.productID; // Set value cho hidden input
                                                            storageInput.value = data.storage;   // Set value cho hidden input
                                                            suggestionBox.style.display = "none";
                                                            document.getElementById("searchForm").submit();
                                                        });
                                                        suggestionBox.appendChild(item);
                                                    });
                                                    suggestionBox.style.display = "block";
                                                };

                                                function highlightMatch(text, keyword) {
                                                    const regex = new RegExp(`(${keyword})`, "gi");
                                                    return text.replace(regex, `<strong class="text-primary">$1</strong>`);
                                                }

                                                // Ẩn box khi click ra ngoài
                                                document.addEventListener("click", (e) => {
                                                    if (!e.target.closest("#searchForm")) {
                                                        suggestionBox.style.display = "none";
                                                    }
                                                });
                                            });

                                            // Toggle Sidebar
                                            document.getElementById("menu-toggle").addEventListener("click", function () {
                                                document.getElementById("wrapper").classList.toggle("toggled");
                                            });
        </script>
    </body>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
</html>