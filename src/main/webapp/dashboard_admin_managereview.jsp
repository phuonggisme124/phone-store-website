<%@page import="model.Review"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>

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
</html>
