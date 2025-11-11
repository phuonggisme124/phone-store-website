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
        <link rel="stylesheet" href="css/dashboard_staff.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
        <style>
            /* Toast notification style */
            .toast-notification {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                min-width: 300px;
                animation: slideInRight 0.3s ease-out;
            }
            
            @keyframes slideInRight {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            
            .toast-notification.hiding {
                animation: slideOutRight 0.3s ease-in;
            }
            
            @keyframes slideOutRight {
                from {
                    transform: translateX(0);
                    opacity: 1;
                }
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }
        </style>
    </head>
    <body>
        <%
            List<Review> listReview = (List<Review>) request.getAttribute("listReview");
            Users currentUser = (Users) session.getAttribute("user");
            
            // Lấy giá trị filter/search hiện tại từ request
            String currentRating = request.getParameter("ratingFilter") != null ? request.getParameter("ratingFilter") : "All";
            String currentProductName = request.getParameter("productName") != null ? request.getParameter("productName") : "";
            
            // Kiểm tra có thông báo success không
            String successMessage = request.getParameter("success");
            
            // Tạo danh sách tên sản phẩm để autocomplete
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

        <!-- Toast Notification -->
        <% if (successMessage != null && !successMessage.isEmpty()) { %>
        <div class="toast-notification">
            <div class="alert alert-success alert-dismissible fade show shadow-lg" role="alert" id="successToast">
                <i class="bi bi-check-circle-fill me-2"></i>
                <strong>
                    <% if (successMessage.equals("reply")) { %>
                        Review reply updated successfully!
                    <% } else if (successMessage.equals("update")) { %>
                        Review updated successfully!
                    <% } else { %>
                        Operation completed successfully!
                    <% } %>
                </strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <% } %>

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

                            <!-- Search Product -->
                            <form action="staff" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="manageReview">
                                <!-- Giữ lại ratingFilter nếu đang filter -->
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

                            <!-- Filter Rating -->
                            <form action="staff" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="manageReview">
                                <!-- Giữ lại productName nếu đang search -->
                                <input type="hidden" name="productName" value="<%= currentProductName %>">

                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Filter
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="ratingFilter" value="All" class="dropdown-item">All Ratings</button></li>
                                    <li><button type="submit" name="ratingFilter" value="5" class="dropdown-item">
                                        <i class="bi bi-star-fill text-warning"></i> 5 Stars
                                    </button></li>
                                    <li><button type="submit" name="ratingFilter" value="4" class="dropdown-item">
                                        <i class="bi bi-star-fill text-warning"></i> 4 Stars
                                    </button></li>
                                    <li><button type="submit" name="ratingFilter" value="3" class="dropdown-item">
                                        <i class="bi bi-star-fill text-warning"></i> 3 Stars
                                    </button></li>
                                    <li><button type="submit" name="ratingFilter" value="2" class="dropdown-item">
                                        <i class="bi bi-star-fill text-warning"></i> 2 Stars
                                    </button></li>
                                    <li><button type="submit" name="ratingFilter" value="1" class="dropdown-item">
                                        <i class="bi bi-star-fill text-warning"></i> 1 Star
                                    </button></li>
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

                <!-- Reviews Table -->
                <div class="container-fluid p-4">
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
                                            for (Review r : listReview) {
                                                String productName = pdao.getNameByID(r.getVariant().getProductID());
                                                
                                                // Lọc theo Rating nếu không phải "All"
                                                if (!currentRating.equals("All") && r.getRating() != Integer.parseInt(currentRating)) {
                                                    continue;
                                                }
                                                
                                                // Lọc theo Product Name nếu có search
                                                if (!currentProductName.isEmpty() && !productName.toLowerCase().contains(currentProductName.toLowerCase())) {
                                                    continue;
                                                }
                                        %>
                                        <tr onclick="window.location.href = 'staff?action=reviewDetail&rID=<%= r.getReviewID()%>'" style="cursor: pointer;">
                                            <td>#<%= r.getReviewID()%></td>
                                            <td><%= r.getUser().getFullName()%></td>
                                            <td><%= productName%> <%= r.getVariant().getStorage()%></td>
                                            <td>
                                                <% for (int i = 0; i < r.getRating(); i++) { %>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <% } %>
                                                <span class="ms-1"><%= r.getRating()%></span>
                                            </td>
                                            <td><%= r.getComment()%></td>
                                            <td><%= r.getReviewDate()%></td>
                                            <td>
                                                <% if (r.getReply() != null && !r.getReply().isEmpty()) { %>
                                                <i class="bi bi-check-circle-fill text-success"></i> Replied
                                                <% } else { %>
                                                <i class="bi bi-dash-circle text-muted"></i> No reply
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
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
                <div class="modal fade" id="replyModal" tabindex="-1">
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
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Menu toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            // Reply Modal
            var replyModal = null;
            window.onload = function () {
                replyModal = new bootstrap.Modal(document.getElementById('replyModal'));
                
                // Tự động ẩn thông báo sau 3 giây
                var successToast = document.getElementById('successToast');
                if (successToast) {
                    setTimeout(function() {
                        // Thêm class hiding để chạy animation
                        var toastContainer = successToast.closest('.toast-notification');
                        if (toastContainer) {
                            toastContainer.classList.add('hiding');
                        }
                        
                        // Đợi animation hoàn thành rồi mới xóa element
                        setTimeout(function() {
                            var alert = bootstrap.Alert.getOrCreateInstance(successToast);
                            alert.close();
                            
                            // Xóa parameter 'success' khỏi URL
                            if (window.history.replaceState) {
                                var url = new URL(window.location);
                                url.searchParams.delete('success');
                                window.history.replaceState({}, '', url);
                            }
                        }, 300);
                    }, 3000);
                }
            };
            
            function openReplyModal(reviewID, currentReply) {
                document.getElementById('modalReviewID').value = reviewID;
                document.getElementById('replyText').value = currentReply;
                replyModal.show();
            }

            // ------------------ Autocomplete ------------------
            var debounceTimer;
            function showSuggestions(str) {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    var box = document.getElementById("suggestionBox");
                    box.innerHTML = "";
                    if (str.length < 1) return;

                    var matches = allProductNames.filter(name => 
                        name.toLowerCase().includes(str.toLowerCase())
                    );
                    
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

            // Ẩn suggestions khi click bên ngoài
            document.addEventListener('click', function(e) {
                var searchInput = document.getElementById('searchProduct');
                var suggestionBox = document.getElementById('suggestionBox');
                if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                    suggestionBox.innerHTML = "";
                }
            });
        </script>
    </body>
</html>