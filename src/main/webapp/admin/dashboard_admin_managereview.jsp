<%@page import="com.google.gson.Gson"%>
<%@page import="model.Review"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Staff"%> <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Manage Reviews</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="css/dashboard_admin.css">
    <link href="css/dashboard_table.css" rel="stylesheet">
</head>
<body>
    <%
        // 1. SỬA: Lấy Staff từ Session (Admin là Staff Role 4)
        Staff user = (Staff) session.getAttribute("user");
        
        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // Kiểm tra quyền Admin (Role = 4)
        if (user.getRole() != 4) {
            response.sendRedirect("login"); 
            return;
        }

        ProductDAO pdao = new ProductDAO(); 
        List<Review> listReview = (List<Review>) request.getAttribute("listReview");
        if (listReview == null) listReview = new ArrayList<>(); // Tránh null pointer

        Integer productID = (Integer) request.getAttribute("productID");
        if (productID == null) {
            productID = 0;
        }
        
        String storage = (String) request.getAttribute("storage");
        if (storage == null || storage.isEmpty()) {
            storage = "";
        }
        
        Integer rating = (Integer) request.getAttribute("rating");
        if (rating == null) {
            rating = 0;
        }
    %>

    <div class="d-flex" id="wrapper">
        <%@ include file="sidebar.jsp" %>

        <div class="page-content flex-grow-1">
            <nav class="navbar navbar-light bg-white shadow-sm">
                <div class="container-fluid">
                    <button class="btn btn-outline-primary" id="menu-toggle">
                        <i class="bi bi-list"></i>
                    </button>
                    <div class="d-flex align-items-center ms-auto">

                        <form action="review" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                            <input type="hidden" name="action" value="searchReview">
                            <input type="hidden" name="rating" value="<%= rating%>">

                            <input type="hidden" name="productID" id="productID" value="<%= productID %>">
                            <input type="hidden" name="storage" id="storage" value="<%= storage %>">

                            <div class="position-relative" style="width: 300px;">
                                <input class="form-control" type="text" id="searchPhone"
                                       placeholder="Search Product Name..."
                                       value="">
                                <div id="suggestionBox" class="list-group position-absolute w-100"
                                     style="top: 100%; z-index: 1000;"></div>
                            </div>

                            <button class="btn btn-outline-primary ms-2" type="submit">
                                <i class="bi bi-search"></i>
                            </button>
                        </form>

                        <form action="review" method="get" class="dropdown me-3">
                            <input type="hidden" name="action" value="filterReview">
                            <input type="hidden" name="productID" value="<%= productID%>">
                            <input type="hidden" name="storage" value="<%= storage%>">

                            <button class="btn btn-outline-secondary fw-bold dropdown-toggle" 
                                    type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-funnel"></i>
                                <span id="selectedStatus">
                                    <%= (rating==0)? "All Ratings" : rating + " Stars"%>
                                </span>
                            </button>

                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                <li><button type="submit" name="rating" value="0" class="dropdown-item">All</button></li>
                                <li><button type="submit" name="rating" value="5" class="dropdown-item">5 Stars</button></li>
                                <li><button type="submit" name="rating" value="4" class="dropdown-item">4 Stars</button></li>
                                <li><button type="submit" name="rating" value="3" class="dropdown-item">3 Stars</button></li>
                                <li><button type="submit" name="rating" value="2" class="dropdown-item">2 Stars</button></li>
                                <li><button type="submit" name="rating" value="1" class="dropdown-item">1 Star</button></li>
                            </ul>
                        </form>

                        <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                        <div class="d-flex align-items-center ms-3">
                            <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                            <span><%= user.getFullName()%></span>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="container-fluid p-4">
                <h1 class="fw-bold text-primary">Manage Reviews</h1>
            </div>

            <div class="card shadow-sm border-0 p-4 m-3">
                <div class="card-body p-0">
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
                                    // Lấy tên sản phẩm từ ProductDAO
                                    String fullProductName = pdao.getNameByID(r.getVariant().getProductID()) + " " + r.getVariant().getStorage();
                            %>
                                <tr style="cursor: pointer;" 
                                    data-productname="<%= fullProductName%>"
                                    data-productid="<%= r.getVariant().getProductID()%>"
                                    data-storage="<%= r.getVariant().getStorage()%>"
                                    onclick="window.location.href = 'review?action=reviewDetail&rID=<%= r.getReviewID()%>'">
                                    
                                    <td>#<%= r.getReviewID()%></td>
                                    <td><%= r.getUser().getFullName()%></td>
                                    <td><%= fullProductName%></td>
                                    <td>
                                        <span class="text-warning fw-bold"><%= r.getRating()%> <i class="bi bi-star-fill"></i></span>
                                    </td>
                                    <td>
                                        <% 
                                            String comment = r.getComment();
                                            if (comment != null && comment.length() > 50) {
                                                comment = comment.substring(0, 50) + "...";
                                            }
                                        %>
                                        <%= comment %>
                                    </td>
                                    <td><%= r.getReviewDate()%></td>
                                    <td>
                                        <% if(r.getReply() != null && !r.getReply().isEmpty()) { %>
                                            <span class="badge bg-success">Replied</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">No Reply</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                        <div class="alert alert-info m-4">No reviews found matching your criteria.</div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Lấy danh sách sản phẩm để gợi ý (Logic JS giữ nguyên)
            const rows = document.querySelectorAll("table tbody tr");
            const productMap = new Map();

            rows.forEach(row => {
                const name = row.getAttribute("data-productname")?.trim();
                const productID = row.getAttribute("data-productid");
                const storage = row.getAttribute("data-storage");
                if (name && productID && storage && !productMap.has(name)) {
                    productMap.set(name, {productID, storage});
                }
            });

            const uniqueProducts = Array.from(productMap.keys());
            const searchInput = document.getElementById("searchPhone");
            const productInput = document.getElementById("productID");
            const storageInput = document.getElementById("storage");
            const suggestionBox = document.getElementById("suggestionBox");

            // ===== GỢI Ý TÌM KIẾM =====
            function fetchSuggestions(query) {
                query = query.trim().toLowerCase();
                suggestionBox.innerHTML = "";

                if (!query) {
                    suggestionBox.style.display = "none";
                    return;
                }

                const matches = uniqueProducts.filter(name => name.toLowerCase().includes(query));

                if (matches.length === 0) {
                    suggestionBox.style.display = "none";
                    return;
                }

                matches.forEach(name => {
                    const item = document.createElement("button");
                    item.type = "button";
                    item.className = "list-group-item list-group-item-action";
                    item.innerHTML = highlightMatch(name, query);

                    item.addEventListener("click", () => {
                        const data = productMap.get(name);
                        searchInput.value = name;
                        productInput.value = data.productID; 
                        storageInput.value = data.storage;   
                        suggestionBox.style.display = "none";
                        document.getElementById("searchForm").submit();
                    });

                    suggestionBox.appendChild(item);
                });

                suggestionBox.style.display = "block";
            }

            // ===== HIGHLIGHT PHẦN KHỚP =====
            function highlightMatch(text, keyword) {
                const regex = new RegExp(`(${keyword})`, "gi");
                return text.replace(regex, `<strong>$1</strong>`);
            }

            // ===== ẨN BOX KHI CLICK RA NGOÀI =====
            document.addEventListener("click", (e) => {
                if (!e.target.closest("#searchForm")) {
                    suggestionBox.style.display = "none";
                }
            });

            // ===== LẮNG NGHE GÕ PHÍM =====
            searchInput.addEventListener("input", function () {
                fetchSuggestions(this.value);
            });
            
            // Toggle Sidebar
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        });
    </script>
</body>
</html>