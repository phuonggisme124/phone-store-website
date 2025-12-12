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
           
            /* thông báo */
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

            /* động*/
            .reply-badge {
                display: inline-flex;
                align-items: center;
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.85rem;
                transition: all 0.3s ease;
                animation: fadeIn 0.5s ease-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: scale(0.8);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            .reply-badge.replied {
                background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                color: white;
                box-shadow: 0 4px 12px rgba(17, 153, 142, 0.3);
            }

            .reply-badge.no-reply {
                background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%);
                color: #666;
            }

            .reply-badge:hover {
                transform: translateY(-2px) scale(1.05);
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
            }

            .reply-badge i {
                margin-right: 6px;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
            }

            /* sao nổi */
            .star-rating i {
                animation: starGlow 1.5s ease-in-out infinite;
                animation-delay: calc(var(--star-index) * 0.1s);
            }

            @keyframes starGlow {
                0%, 100% {
                    filter: drop-shadow(0 0 2px rgba(255, 193, 7, 0.5));
                }
                50% {
                    filter: drop-shadow(0 0 6px rgba(255, 193, 7, 0.8));
                }
            }

            /* rê chuật hàng */
            tbody tr {
                transition: all 0.3s ease;
                cursor: pointer;
            }

            tbody tr:hover {
                background: linear-gradient(90deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
                transform: translateX(5px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            }

            
            #suggestionBox {
                background: white;
                border: 1px solid rgba(102, 126, 234, 0.2);
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }

            #suggestionBox .list-group-item {
                border: none;
                transition: all 0.3s ease;
            }

            #suggestionBox .list-group-item:hover {
                background: linear-gradient(90deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
                transform: translateX(5px);
                padding-left: 20px;
            }

          
            .comment-preview {
                max-width: 200px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                cursor: help;
                position: relative;
            }

            .comment-preview:hover::after {
                content: attr(data-full-comment);
                position: absolute;
                bottom: 100%;
                left: 0;
                background: rgba(0, 0, 0, 0.9);
                color: white;
                padding: 8px 12px;
                border-radius: 8px;
                white-space: normal;
                max-width: 300px;
                z-index: 1000;
                font-size: 0.85rem;
                animation: tooltipFadeIn 0.3s ease;
            }

            @keyframes tooltipFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(5px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            
            .card {
                border-radius: 16px !important;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08) !important;
                transition: all 0.3s ease;
            }

            .card:hover {
                box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12) !important;
            }

            
            .btn {
                border-radius: 10px;
                transition: all 0.3s ease;
            }

            .btn:hover {
                transform: translateY(-2px);
            }
        </style>
    </head>
    <body>
        <%
            List<Review> listReview = (List<Review>) request.getAttribute("listReview");
            Users currentUser = (Users) session.getAttribute("user");
            
            String currentRating = request.getParameter("ratingFilter") != null ? request.getParameter("ratingFilter") : "All";
            String currentProductName = request.getParameter("productName") != null ? request.getParameter("productName") : "";
            String successMessage = request.getParameter("success");
            
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
                            <!-- Search Product -->
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

                            <!-- Filter Rating -->
                            <form action="review" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="manageReview">
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
                                            <th>Reply Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Review r : listReview) {
                                                String productName = pdao.getNameByID(r.getVariant().getProductID());
                                                
                                                if (!currentRating.equals("All") && r.getRating() != Integer.parseInt(currentRating)) {
                                                    continue;
                                                }
                                                
                                                if (!currentProductName.isEmpty() && !productName.toLowerCase().contains(currentProductName.toLowerCase())) {
                                                    continue;
                                                }
                                                
                                                boolean hasReply = r.getReply() != null && !r.getReply().isEmpty();
                                        %>
                                        <tr onclick="window.location.href = 'review?action=reviewDetail&rID=<%= r.getReviewID()%>'">
                                            <td><span class="badge bg-primary">#<%= r.getReviewID()%></span></td>
                                            <td><strong><%= r.getUser().getFullName()%></strong></td>
                                            <td><%= productName%> <%= r.getVariant().getStorage()%></td>
                                            <td>
                                                <!-- loop só sao -->
                                                <div class="star-rating">
                                                    <% for (int i = 0; i < r.getRating(); i++) { %>
                                                    <i class="bi bi-star-fill text-warning" style="--star-index: <%= i %>;"></i>
                                                    <% } %>
                                                    <span class="ms-1 fw-bold"><%= r.getRating()%></span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="comment-preview" data-full-comment="<%= r.getComment()%>">
                                                    <%= r.getComment()%>
                                                </div>
                                            </td>
                                            <td><%= r.getReviewDate()%></td>
                                            <td>
                                                <% if (hasReply) { %>
                                                <span class="reply-badge replied">
                                                    <i class="bi bi-check-circle-fill"></i>
                                                    Replied
                                                </span>
                                                <% } else { %>
                                                <span class="reply-badge no-reply">
                                                    <i class="bi bi-dash-circle"></i>
                                                    No reply
                                                </span>
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
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // thu menu
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            //thông báo
            window.onload = function () {
                var successToast = document.getElementById('successToast');
                if (successToast) {
                    setTimeout(function() {
                        var toastContainer = successToast.closest('.toast-notification');
                        if (toastContainer) {
                            toastContainer.classList.add('hiding');
                        }
                        
                        setTimeout(function() {
                            var alert = bootstrap.Alert.getOrCreateInstance(successToast);
                            alert.close();
                            
                            if (window.history.replaceState) {
                                var url = new URL(window.location);
                                url.searchParams.delete('success');
                                window.history.replaceState({}, '', url);
                            }
                        }, 300);
                    }, 3000);
                }
            };

            //gợi í
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

            
            document.addEventListener('click', function(e) {
                var searchInput = document.getElementById('searchProduct');
                var suggestionBox = document.getElementById('suggestionBox');
                if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                    suggestionBox.innerHTML = "";
                }
            });

            // Add row animation on load
//            document.addEventListener('DOMContentLoaded', function() {
//                const rows = document.querySelectorAll('tbody tr');
//                rows.forEach((row, index) => {
//                    row.style.animation = `fadeIn 0.5s ease-out ${index * 0.05}s backwards`;
//                });
//            });
        </script>
    </body>
</html>