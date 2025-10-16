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

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/review_detail.css">
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
                    <li><a href="admin" ><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                    <li><a href="admin?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="admin?action=manageSupplier"><i class="bi bi-truck me-2"></i>Suppliers</a></li>
                    <li><a href="admin?action=managePromotion"><i class="bi bi-tag me-2"></i></i>Promotions</a></li>
                    <li><a href="admin?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li><a href="admin?action=manageReview" class="active"><i class="bi bi-bag me-2"></i>Reviews</a></li>
                    <li><a href="admin?action=manageUser"><i class="bi bi-people me-2"></i>Users</a></li>
                    <li><a href="#"><i class="bi bi-gear me-2"></i>Settings</a></li>
                </ul>
            </nav>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <form class="d-none d-md-flex ms-3">
                            <input class="form-control" type="search" placeholder="Ctrl + K" readonly>
                        </form>
                        <div class="d-flex align-items-center ms-auto">
                            <div class="position-relative me-3">
                                <a href="logout">logout</a>
                            </div>
                            <i class="bi bi-bell me-3 fs-5"></i>
                            <div class="position-relative me-3">
                                <i class="bi bi-github fs-5"></i>
                            </div>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span>Admin</span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Search bar -->
                <div class="container-fluid p-4">
                    <input type="text" class="form-control w-25" placeholder="🔍 Search">
                </div>
                <%
                    ProductDAO pdao = new ProductDAO();
                    Review review = (Review) request.getAttribute("review");
                %>
                <!-- Table -->
                <div class="review-container">
                    <!-- Left: Product Image -->
                    <div class="review-left">
                        <h3 class="product-name"><%= pdao.getNameByID(review.getVariant().getProductID())%> <%= review.getVariant().getStorage() %></h3>

                        <!-- Radio buttons (ẩn) -->
                        <input type="radio" name="thumb" id="img1" checked>
                        <input type="radio" name="thumb" id="img2">
                        <input type="radio" name="thumb" id="img3">

                        <!-- Ảnh chính -->
                        <div class="main-image">
                            <img src="images/iphone15_black.jpg" class="image img1">
                            <img src="images/iphone15_silver.jpg" class="image img2">
                            <img src="images/iphone15_blue.jpg" class="image img3">
                        </div>

                        <!-- Thumbnail -->
                        <div class="thumbnail-list">
                            <label for="img1"><img src="images/iphone15_black.jpg" alt="Black"></label>
                            <label for="img2"><img src="images/iphone15_silver.jpg" alt="Silver"></label>
                            <label for="img3"><img src="images/iphone15_blue.jpg" alt="Blue"></label>
                        </div>
                    </div>

                    <!-- Right: Review Info -->
                    <div class="review-right">


                        <div class="review-info">
                            <p><strong>User Name:</strong> <%= review.getUser().getFullName() %></p>
                            <p><strong>Rating:</strong> <%= review.getRating() %></p>
                            <p><strong>Review Date:</strong> <%= review.getReviewDate() %></p>
                            <p><strong>Comment:</strong></p>
                            <p class="comment"><%= review.getComment() %></p>

                            <form action="admin?action=replyReview" method="post">
                                <p><strong>Reply:</strong></p>

                                <div class="reply-box">
                                    <textarea name="reply" class="reply-input" placeholder="Your reply..."><%= (review.getReply()!= null)?  review.getReply() : "" %></textarea>
                                </div>

                                <input type="hidden" name="rID" value="<%= review.getReviewID()%>">

                                <button type="submit" class="send-btn">Send Reply</button>
                            </form>                 
                        </div>

                        
                    </div>
                </div>

            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
    </body>
</html>
