<%@page import="dao.ProductDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Review"%>
<%@page import="model.Users"%>
<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Staff Dashboard - Product Reviews</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="css/dashboard_staff.css"> <link href="css/dashboard_table.css" rel="stylesheet">
        <style>
            .sidebar { min-width: 250px; max-width: 250px; min-height: 100vh; }
            .sidebar .active { color: #0d6efd; font-weight: bold; }
            .page-content { width: 100%; }
            #wrapper.toggled .sidebar { margin-left: -250px; }
        </style>
    </head>
    <body>
        <%
            List<Review> listReview = (List<Review>) request.getAttribute("listReview");
            Users currentUser = (Users) session.getAttribute("user");
            String currentRating = request.getParameter("ratingFilter") != null ? request.getParameter("ratingFilter") : "All";
            String currentProductName = request.getParameter("productName") != null ? request.getParameter("productName") : "";

            ProductDAO pdao = new ProductDAO();
            List<String> allProductNames = new ArrayList<>();
            if (listReview != null) {
                for (Review r : listReview) {
                    String productName = pdao.getNameByID(r.getVariant().getProductID());
                    if (!allProductNames.contains(productName)) {
                        allProductNames.add(productName);
                    }
                }
            }
        %>

        <script>
            const allProductNames = <%= new Gson().toJson(allProductNames) %>;
        </script>

        <div class="d-flex" id="wrapper">
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="product?action=manageProduct" class="text-decoration-none text-dark"><i class="bi bi-box me-2"></i>Products</a></li>
                    
                    <li><a href="order?action=manageOrder" class="text-decoration-none text-dark"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    
                    <li><a href="review?action=manageReview" class="text-decoration-none fw-bold text-primary"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
                </ul>
            </nav>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">

                            <form action="review" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="manageReview">
                                <input type="hidden" name="ratingFilter" value="<%= currentRating %>">
                                <input class="form-control me-2" type="text" id="searchProduct" name="productName"
                                       placeholder="Search Product…" value="<%= currentProductName %>"
                                       oninput="showSuggestions(this.value)">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                                <div id="suggestionBox" class="list-group position-absolute w-100"
                                     style="top: 100%; z-index: 1000;"></div>
                            </form>

                            <form action="review" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="manageReview">
                                <input type="hidden" name="productName" value="<%= currentProductName %>">

                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Filter
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="ratingFilter" value="All" class="dropdown-item">All Ratings</button></li>
                                    <li><button type="submit" name="ratingFilter" value="5" class="dropdown-item"><i class="bi bi-star-fill text-warning"></i> 5 Stars</button></li>
                                    <li><button type="submit" name="ratingFilter" value="4" class="dropdown-item"><i class="bi bi-star-fill text-warning"></i> 4 Stars</button></li>
                                    <li><button type="submit" name="ratingFilter" value="3" class="dropdown-item"><i class="bi bi-star-fill text-warning"></i> 3 Stars</button></li>
                                    <li><button type="submit" name="ratingFilter" value="2" class="dropdown-item"><i class="bi bi-star-fill text-warning"></i> 2 Stars</button></li>
                                    <li><button type="submit" name="ratingFilter" value="1" class="dropdown-item"><i class="bi bi-star-fill text-warning"></i> 1 Star</button></li>
                                </ul>
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                            <div class="d-flex align-items-center ms-3">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser != null ? currentUser.getFullName() : "Staff"%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4">
                
                    <%
                        String message = (String) request.getAttribute("message");
                        String error = (String) request.getAttribute("error");
                    %>
                    <% if (message != null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> <%= message %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>
                    <% if (error != null) { %>
                         <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>
                    <div class="card shadow-sm border-0 p-4">
                        <div class="card-body p-0">
                            <h4 class="fw-bold ps-3 mb-4">All Product Reviews</h4>

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
                                            int displayedCount = 0;
                                            for (Review r : listReview) {
                                                String productName = pdao.getNameByID(r.getVariant().getProductID());
                                                
                                                // Logic lọc hiển thị (giữ nguyên)
                                                if (!currentRating.equals("All") && r.getRating() != Integer.parseInt(currentRating)) continue;
                                                if (!currentProductName.isEmpty() && !productName.toLowerCase().contains(currentProductName.toLowerCase())) continue;
                                                
                                                displayedCount++;
                                        %>
                                        <tr onclick="window.location.href = 'review?action=reviewDetail&rID=<%= r.getReviewID()%>'" style="cursor: pointer;">
                                            <td>#<%= r.getReviewID()%></td>
                                            <td><%= r.getUser().getFullName()%></td>
                                            <td><%= productName%> <%= r.getVariant().getStorage()%></td>
                                            <td>
                                                <% for (int i = 0; i < r.getRating(); i++) { %>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <% } %>
                                            </td>
                                            <td>
                                                <% 
                                                    String cmt = r.getComment();
                                                    if (cmt != null && cmt.length() > 50) cmt = cmt.substring(0, 50) + "...";
                                                %>
                                                <%= cmt %>
                                            </td>
                                            <td><%= r.getReviewDate()%></td>
                                            <td>
                                                <% if (r.getReply() != null && !r.getReply().isEmpty()) { %>
                                                <span class="badge bg-success"><i class="bi bi-check-circle-fill me-1"></i>Replied</span>
                                                <% } else { %>
                                                <span class="badge bg-secondary"><i class="bi bi-dash-circle me-1"></i>Pending</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } 
                                            if (displayedCount == 0) {
                                        %>
                                            <tr><td colspan="7" class="text-center text-muted p-4">No reviews match filters.</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } else { %>
                            <div class="alert alert-info m-4" role="alert">
                                <i class="bi bi-info-circle me-2"></i>No reviews available.
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="replyModal" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Reply to Review</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="review" method="post">
                                <input type="hidden" name="action" value="replyReview">
                                <input type="hidden" name="reviewID" id="modalReviewID">
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label for="replyText" class="form-label">Reply</label>
                                        <textarea class="form-control" id="replyText" name="reply" rows="3" required></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Save Reply</button>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Menu toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            // Autocomplete & Suggestions (Giữ nguyên)
            var debounceTimer;
            function showSuggestions(str) {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    var box = document.getElementById("suggestionBox");
                    box.innerHTML = "";
                    if (str.length < 1) return;
                    var matches = allProductNames.filter(name => name.toLowerCase().includes(str.toLowerCase()));
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
            
            document.addEventListener('click', function(e) {
                var searchInput = document.getElementById('searchProduct');
                var suggestionBox = document.getElementById('suggestionBox');
                if (searchInput && suggestionBox && !searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                    suggestionBox.innerHTML = "";
                }
            });
        </script>
    </body>
</html>