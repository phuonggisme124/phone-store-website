<%@page import="dao.ReviewDAO"%>
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
            <%@ include file="sidebar.jsp" %>

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
                    ReviewDAO rdao = new ReviewDAO();
                    Review review = (Review) request.getAttribute("review");
                    List<String> listImage = rdao.getImages(review.getImage());
                %>
                <!-- Table -->
                <div class="review-container">
                    <!-- Left: Product Image -->
                    <%
                        if (listImage != null && !listImage.isEmpty()) {
                    %>
                    <div class="review-left">
                        <h3 class="product-name"><%= pdao.getNameByID(review.getVariant().getProductID())%> <%= review.getVariant().getStorage()%></h3>

                        <!-- Radio buttons (ẩn) -->
                        <%
                            for (int i = 1; i <= listImage.size(); i++) {
                        %>
                        <input type="radio" name="thumb" id="img<%= i%>" <%= (i == 1) ? "checked" : ""%>>
                        <%
                            }
                        %>


                        <!-- Ảnh chính -->            
                        <div class="main-image">
                            <%
                                for (int i = 1; i <= listImage.size(); i++) {
                            %>
                            <img src="images_review/<%= listImage.get(i - 1)%>" class="image img<%= i%>">
                            <%
                                }
                            %>

                        </div>

                        <!-- Thumbnail -->
                        <div class="thumbnail-list">
                            <%
                                for (int i = 1; i <= listImage.size(); i++) {
                            %>
                            <label for="img<%= i%>"><img src="images_review/<%= listImage.get(i - 1)%>" alt="<%= listImage.get(i - 1)%>"></label>
                                <%
                                    }   
                                %>

                        </div>
                    </div>
                    <%
                        }
                    %>

                    <!-- Right: Review Info -->
                    <div class="review-right">


                        <div class="review-info">
                            <p><strong>User Name:</strong> <%= review.getUser().getFullName()%></p>
                            <p><strong>Rating:</strong> <%= review.getRating()%></p>
                            <p><strong>Review Date:</strong> <%= review.getReviewDate()%></p>
                            <p><strong>Comment:</strong></p>
                            <p class="comment"><%= review.getComment()%></p>

                            <form action="review?action=replyReview" method="post">
                                <p><strong>Reply:</strong></p>

                                <div class="reply-box">
                                    <textarea name="reply" class="reply-input" placeholder="Your reply..."><%= (review.getReply() != null) ? review.getReply() : ""%></textarea>
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
