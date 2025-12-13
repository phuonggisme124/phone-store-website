<%@page import="dao.ReviewDAO"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Review"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff Dashboard - Product Reviews</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f8f9fa;
            }

            #wrapper {
                min-height: 100vh;
            }
   /* thu menu */
            #wrapper.toggled .sidebar {
                margin-left: -250px;
            }

            .sidebar {
                width: 250px;
                min-height: 100vh;
                transition: margin 0.3s ease-in-out;
                position: fixed;
                left: 0;
                top: 0;
                z-index: 1000;
            }

            .sidebar-header {
                border-bottom: 1px solid #e0e0e0;
            }

            .sidebar-header h4 {
                margin: 0;
                color: #0d6efd;
            }

            .sidebar ul {
                padding: 0;
                margin-top: 20px;
            }

            .sidebar ul li {
                list-style: none;
                margin-bottom: 5px;
            }

            .sidebar ul li a {
                display: block;
                padding: 12px 20px;
                color: #333;
                text-decoration: none;
                border-radius: 8px;
                margin-right: 15px;
                transition: all 0.3s;
            }

            .sidebar ul li a:hover {
                background-color: #e7f3ff;
                color: #0d6efd;
            }

            .sidebar ul li a.fw-bold {
                background-color: #e7f3ff;
                color: #0d6efd;
            }

            /* Page Content */
            .page-content {
                margin-left: 250px;
                transition: margin 0.3s ease-in-out;
                min-height: 100vh;
            }

            #wrapper.toggled .page-content {
                margin-left: 0;
            }

            .navbar {
                border-bottom: 1px solid #e0e0e0;
            }

            .review-container {
                display: flex;
                gap: 30px;
                padding: 20px;
                flex-wrap: wrap;
            }

            .review-left {
                flex: 1;
                min-width: 300px;
                max-width: 500px;
            }

            .product-name {
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 20px;
                color: #333;
            }

            .review-left input[type="radio"] {
                display: none;
            }

            .main-image {
                width: 100%;
                height: 400px;
                border: 2px solid #e0e0e0;
                border-radius: 12px;
                overflow: hidden;
                position: relative;
                margin-bottom: 15px;
                background-color: #f8f9fa;
            }

            .main-image img {
                width: 100%;
                height: 100%;
                object-fit: contain;
                display: none;
                padding: 10px;
            }

            /* ảnh theo check*/
            #img1:checked ~ .main-image .img1,
            #img2:checked ~ .main-image .img2,
            #img3:checked ~ .main-image .img3,
            #img4:checked ~ .main-image .img4,
            #img5:checked ~ .main-image .img5 {
                display: block;
            }

            .thumbnail-list {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .thumbnail-list label {
                cursor: pointer;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                overflow: hidden;
                transition: all 0.3s;
                width: 80px;
                height: 80px;
            }

            .thumbnail-list label:hover {
                border-color: #0d6efd;
                transform: scale(1.05);
            }

            .thumbnail-list label img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            /* viền */
            #img1:checked ~ .thumbnail-list label[for="img1"],
            #img2:checked ~ .thumbnail-list label[for="img2"],
            #img3:checked ~ .thumbnail-list label[for="img3"],
            #img4:checked ~ .thumbnail-list label[for="img4"],
            #img5:checked ~ .thumbnail-list label[for="img5"] {
                border-color: #0d6efd;
                box-shadow: 0 0 8px rgba(13, 110, 253, 0.3);
            }

            .review-right {
                flex: 1;
                min-width: 300px;
            }

            .review-info {
                background-color: #fff;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .review-info p {
                margin-bottom: 15px;
                font-size: 1rem;
                color: #555;
            }

            .review-info p strong {
                color: #333;
                font-weight: 600;
            }

            .comment {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                border-left: 4px solid #0d6efd;
                font-style: italic;
                color: #666;
            }

            /* tra loi*/
            .reply-box {
                margin: 15px 0;
            }

            .reply-input {
                width: 100%;
                min-height: 120px;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 1rem;
                font-family: inherit;
                resize: vertical;
                transition: border-color 0.3s;
            }

            .reply-input:focus {
                outline: none;
                border-color: #0d6efd;
                box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
            }

            /* nút */
            .send-btn {
                background-color: #0d6efd;
                color: white;
                padding: 10px 25px;
                border: none;
                border-radius: 8px;
                font-size: 1rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                margin-top: 10px;
            }

            .send-btn:hover {
                background-color: #0b5ed7;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3);
            }

            .send-btn:active {
                transform: translateY(0);
            }

            @media (max-width: 768px) {
                .sidebar {
                    margin-left: -250px;
                }

                #wrapper.toggled .sidebar {
                    margin-left: 0;
                }

                .page-content {
                    margin-left: 0;
                }

                .review-container {
                    flex-direction: column;
                }

                .review-left,
                .review-right {
                    max-width: 100%;
                }

                .main-image {
                    height: 300px;
                }
            }

            .card {
                border-radius: 12px;
            }

            .card-body h4 {
                color: #333;
                border-bottom: 2px solid #e0e0e0;
                padding-bottom: 15px;
            }
        </style>

    </head>
    <body>
        <%
            Review review = (Review) request.getAttribute("review");
            Users currentUser = (Users) session.getAttribute("user");
            ProductDAO pdao = new ProductDAO();
        %>

        <div class="d-flex" id="wrapper">

 
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="product?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="order?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li><a href="review?action=manageReview" class="fw-bold text-primary"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
                    <li><a href="importproduct?action=staff_import"><i class="bi bi-chat-left-text me-2"></i>importProduct</a></li>
                </ul>
            </nav>

            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">
                            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                            <div class="d-flex align-items-center ms-3">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser != null ? currentUser.getFullName() : "Staff"%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4">
                    <div class="card shadow-sm border-0 p-4">
                        <div class="card-body p-0">
                            <h4 class="fw-bold ps-3 mb-4">Reply Reviews</h4>

                            <% if (review != null) {%>
                            <%
                                ReviewDAO rdao = new ReviewDAO();
                                List<String> listImage = rdao.getImages(review.getImage());
                            %>
                            <div class="review-container">

                                <%
                                    if (listImage != null && !listImage.isEmpty()) {
                                %>
                                <div class="review-left">
                                    <h3 class="product-name"><%= pdao.getNameByID(review.getVariant().getProductID())%> <%= review.getVariant().getStorage()%></h3>


                                    <%
                                        for (int i = 1; i <= listImage.size(); i++) {
                                    %>
                                    <input type="radio" name="thumb" id="img<%= i%>" <%= (i == 1) ? "checked" : ""%>>
                                    <%
                                        }
                                    %>

        
                                    <div class="main-image">
                                        <%
                                            for (int i = 1; i <= listImage.size(); i++) {
                                        %>
                                        <img src="images_review/<%= listImage.get(i - 1)%>" class="image img<%= i%>">
                                        <%
                                            }
                                        %>
                                    </div>

            
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

                                <div class="review-right">
                                    <div class="review-info">
                                        <p><strong>User Name:</strong> <%= review.getUser().getFullName()%></p>
                                        <p><strong>Rating:</strong> <%= review.getRating()%> ⭐</p>
                                        <p><strong>Review Date:</strong> <%= review.getReviewDate()%></p>
                                        <p><strong>Comment:</strong></p>
                                        <p class="comment"><%= review.getComment()%></p>


                                        <form action="review?action=replyReview" method="post">
                                            <p><strong>Reply:</strong></p>

                                            <div class="reply-box">
                                                <textarea name="reply" class="reply-input" placeholder="Your reply..."><%= (review.getReply() != null) ? review.getReply() : ""%></textarea>
                                            </div>

                                            <input type="hidden" name="reviewID" value="<%= review.getReviewID()%>">

                                            <button type="submit" class="send-btn">Send Reply</button>
                                        </form>                 

                                    </div>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="alert alert-info m-4" role="alert">

                                <i class="bi bi-info-circle me-2"></i>No reviews available.
                            </div>
                            <% }%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
</html>