<%@page import="model.Staff"%>
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
        <title>Admin Dashboard - Review Details</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_reviewdetail.css">
        
        
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>
            <% Staff currentUser = (Staff) session.getAttribute("user"); %>

            <div class="page-content flex-grow-1">
                
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto gap-3">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://i.pravatar.cc/150?u=<%= currentUser.getStaffID()%>" class="rounded-circle border border-2 border-white shadow-sm" width="40" height="40">
                                <span class="d-none d-md-block fw-bold text-dark"><%= currentUser.getFullName()%></span>
                            </div>
                            <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" style="width: 38px; height: 38px;">
                                <i class="bi bi-box-arrow-right fs-6"></i>
                            </a>
                        </div>
                    </div>
                </nav>

                <% 
                    ProductDAO pdao = new ProductDAO();
                    ReviewDAO rdao = new ReviewDAO();
                    Review review = (Review) request.getAttribute("review");
                    List<String> listImage = null;
                    if(review != null) listImage = rdao.getImages(review.getImage());
                %>

                <div class="container-fluid p-4">
                    <div class="mb-3">
                        <a href="review?action=manageReviews" class="btn btn-outline-secondary rounded-pill btn-sm px-3">
                            <i class="bi bi-arrow-left me-1"></i> Back to Reviews
                        </a>
                    </div>

                    <div class="card review-card p-4">
                        <div class="row g-5">
                            
                            <div class="col-lg-5 border-end">
                                <div class="mb-4">
                                    <h3 class="product-name"><%= pdao.getNameByID(review.getVariant().getProductID())%></h3>
                                    <span class="product-storage"><%= review.getVariant().getStorage()%></span>
                                </div>

                                <% if (listImage != null && !listImage.isEmpty()) { %>
                                    <div class="main-image-container shadow-sm">
                                        <img id="main-img" src="images_review/<%= listImage.get(0)%>" alt="Product Image">
                                    </div>
                                    <div class="thumbnail-list">
                                        <% for (String img : listImage) { %>
                                            <img class="thumb shadow-sm" src="images_review/<%= img%>" onclick="changeImage(this)">
                                        <% } %>
                                    </div>
                                <% } else { %>
                                    <div class="alert alert-secondary text-center">No images uploaded by user.</div>
                                <% } %>
                            </div>

                            <div class="col-lg-7">
                                <h5 class="text-uppercase text-muted fw-bold mb-4 small ls-1">Customer Review</h5>
                                
                                <div class="user-info">
                                    <div class="user-avatar shadow-sm">
                                        <%= review.getUser().getFullName().substring(0, 1).toUpperCase() %>
                                    </div>
                                    <div>
                                        <h5 class="fw-bold mb-0 text-dark"><%= review.getUser().getFullName()%></h5>
                                        <div class="text-muted small review-date">
                                            <i class="bi bi-clock me-1"></i><%= review.getReviewDate()%>
                                        </div>
                                    </div>
                                    <div class="ms-auto rating-stars">
                                        <% for (int s = 1; s <= 5; s++) { %>
                                            <i class="bi <%= (s <= review.getRating()) ? "bi-star-fill" : "bi-star" %>"></i>
                                        <% } %>
                                    </div>
                                </div>

                                <div class="comment-box shadow-sm">
                                    <i class="bi bi-quote fs-3 text-primary opacity-25"></i>
                                    <%= review.getComment()%>
                                </div>

                                <div class="reply-section mt-5">
                                    <h6 class="fw-bold text-primary mb-3"><i class="bi bi-reply-fill me-2"></i>Admin Reply</h6>
                                    <form action="review?action=replyReview" method="post">
                                        <input type="hidden" name="reviewID" value="<%= review.getReviewID()%>">
                                        
                                        <div class="mb-3">
                                            <textarea name="reply" class="reply-input shadow-sm" placeholder="Write your response here..."><%= (review.getReply() != null) ? review.getReply() : ""%></textarea>
                                        </div>
                                        
                                        <div class="text-end">
                                            <button type="submit" class="btn btn-gradient-primary rounded-pill px-4">
                                                <i class="bi bi-send me-2"></i>Send Reply
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/dashboard.js"></script>
        
        <script>
            function changeImage(element) {
                // Đổi ảnh chính
                document.getElementById('main-img').src = element.src;
                
                // Highlight thumb đang chọn
                document.querySelectorAll('.thumb').forEach(img => img.classList.remove('active'));
                element.classList.add('active');
            }
            
            // Sidebar Toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
</html>