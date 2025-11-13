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
        <title>Staff Dashboard - Review Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_admin_managereview.css"> 
        <link href="css/dashboard_table.css" rel="stylesheet">
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
                    <li><a href="staff?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="order?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li><a href="review?action=manageReview" class="fw-bold text-primary"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
                </ul>
            </nav>

            <div class="page-content flex-grow-1">
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
                            
                            <a href="review?action=manageReview" class="btn btn-outline-secondary mb-3">
                                <i class="bi bi-arrow-left me-1"></i> Back to All Reviews
                            </a>

                            <h4 class="fw-bold ps-3 mb-4">Review Detail #<%= review != null ? review.getReviewID() : "N/A" %></h4>

                            <% if (review != null) {%>
                            <%
                                ReviewDAO rdao = new ReviewDAO();
                                List<String> listImage = rdao.getImages(review.getImage());
                            %>
                            <div class="review-container">
                                <div class="review-left">
                                    <h3 class="product-name"><%= pdao.getNameByID(review.getVariant().getProductID())%> <%= review.getVariant().getStorage()%></h3>
                                    
                                    <% if (listImage != null && !listImage.isEmpty()) { %>
                                        <% for (int i = 1; i <= listImage.size(); i++) { %>
                                            <input type="radio" name="thumb" id="img<%= i%>" <%= (i == 1) ? "checked" : ""%>>
                                        <% } %>

                                        <div class="main-image">
                                            <% for (int i = 1; i <= listImage.size(); i++) { %>
                                                <img src="images_review/<%= listImage.get(i - 1)%>" class="image img<%= i%>" alt="Review Image <%= i %>">
                                            <% } %>
                                        </div>

                                        <div class="thumbnail-list">
                                            <% for (int i = 1; i <= listImage.size(); i++) { %>
                                                <label for="img<%= i%>"><img src="images_review/<%= listImage.get(i - 1)%>" alt="Thumbnail <%= i %>"></label>
                                            <% } %>
                                        </div>
                                    <% } else { %>
                                        <div class="alert alert-light border mt-3">User did not upload any images.</div>
                                    <% } %>
                                </div>

                                <div class="review-right">
                                    <div class="review-info">
                                        <p><strong>User Name:</strong> <%= review.getUser().getFullName()%></p>
                                        <p><strong>Rating:</strong> 
                                            <% for(int i=0; i<review.getRating(); i++) { %>
                                                <i class="bi bi-star-fill text-warning"></i>
                                            <% } %>
                                        </p>
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
                                <i class="bi bi-info-circle me-2"></i>Review not found.
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