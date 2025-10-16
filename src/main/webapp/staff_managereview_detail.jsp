<%@page import="dao.ProductDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Review"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Staff Dashboard - Product Reviews</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="css/dashboard_staff.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
        <link rel="stylesheet" href="css/review_detail.css">
    </head>
    <body>
        <%
            Review review = (Review) request.getAttribute("review");
            Users currentUser = (Users) session.getAttribute("user");
            ProductDAO pdao = new ProductDAO();
        %>

        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="staff?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="staff?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li><a href="staff?action=manageReview" class="fw-bold text-primary"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>

                </ul>
            </nav>

            <!-- Page Content -->
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

                <!-- Reviews Table -->
                <div class="container-fluid p-4">
                    <div class="card shadow-sm border-0 p-4">
                        <div class="card-body p-0">
                            <h4 class="fw-bold ps-3 mb-4">All Product Reviews</h4>

                            <% if (review != null) {%>
                            <div class="review-container">
                                <!-- Left: Product Image -->
                                <div class="review-left">
                                    <h3 class="product-name"><%= pdao.getNameByID(review.getVariant().getProductID())%> <%= review.getVariant().getStorage()%></h3>

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
                                        <p><strong>User Name:</strong> <%= review.getUser().getFullName()%></p>
                                        <p><strong>Rating:</strong> <%= review.getRating()%></p>
                                        <p><strong>Review Date:</strong> <%= review.getReviewDate()%></p>
                                        <p><strong>Comment:</strong></p>
                                        <p class="comment"><%= review.getComment()%></p>

                                        <form action="staff?action=replyReview" method="post">
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
                            <% } else { %>
                            <div class="alert alert-info m-4" role="alert">
                                <i class="bi bi-info-circle me-2"></i>No reviews available.
                            </div>
                            <% }%>
                        </div>
                    </div>
                </div>

                <!-- Modal Reply -->
<!--                <div class="modal fade" id="replyModal" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Reply to Review</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="staff" method="post">
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
                </div>-->

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            var replyModal = null;
            window.onload = function () {
                replyModal = new bootstrap.Modal(document.getElementById('replyModal'));
            };
            function openReplyModal(reviewID, currentReply) {
                document.getElementById('modalReviewID').value = reviewID;
                document.getElementById('replyText').value = currentReply;
                replyModal.show();
            }
        </script>

        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
</html>
