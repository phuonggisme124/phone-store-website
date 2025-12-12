<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Staff"%> <%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Categories</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
    </head>
    <body>
        <%
            // SỬA: Lấy Staff từ Session
            Staff currentUser = (Staff) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            // Check quyền Admin (Role = 4)
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login"); 
                return;
            }

            List<Category> listCategory = (List<Category>) request.getAttribute("listCategory");
            
            // Lấy giá trị search hiện tại từ request
            String currentCategoryName = request.getParameter("categoryName") != null ? request.getParameter("categoryName") : "";

            // Tạo danh sách tên danh mục để autocomplete
            List<String> allCategoryNames = new ArrayList<>();
            if (listCategory != null) {
                for (Category c : listCategory) {
                    if (!allCategoryNames.contains(c.getCategoryName())) {
                        allCategoryNames.add(c.getCategoryName());
                    }
                }
            }
        %>

        <script>
            const allCategoryNames = <%= new Gson().toJson(allCategoryNames) %>;
        </script>

        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">
                            <form action="admin" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off" style="width: 250px;">
                                <input type="hidden" name="action" value="manageCategory">
                                <input class="form-control me-2" type="text" id="searchCategory" name="categoryName"
                                       placeholder="Search Category" value="<%= currentCategoryName %>"
                                       oninput="showSuggestions(this.value)">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                                <div id="suggestionBox" class="list-group position-absolute"
                                     style="top: 100%; left: 0; width: 250px; z-index: 1000;"></div>
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser.getFullName() %></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4 ps-3">
                    <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm" href="category?action=createCategory">
                        <i class="bi bi-box-seam me-2"></i> Create Category
                    </a>
                </div>

                <div class="card shadow-sm border-0 p-4 m-3">
                    <div class="card-body p-0">
                        <div class="container-fluid p-4 ps-3">
                            <h4 class="fw-bold ps-3 mb-4 text-primary">Manage Category</h4>
                        </div>
                        <% if (listCategory != null && !listCategory.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>CategoryID</th>
                                        <th>Category Name</th>
                                        <th>Descriptions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Category c : listCategory) {
                                            // Lọc theo Category Name nếu có search
                                            if (!currentCategoryName.isEmpty() && !c.getCategoryName().toLowerCase().contains(currentCategoryName.toLowerCase())) {
                                                continue;
                                            }
                                    %>
                                    <tr onclick="window.location.href = 'category?action=editCategory&id=<%= c.getCategoryId()%>'" style="cursor: pointer;">
                                        <td>#<%= c.getCategoryId()%></td>
                                        <td><%= c.getCategoryName() %></td>
                                        <td><%= c.getDescription() %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info m-4" role="alert">
                            <i class="bi bi-info-circle me-2"></i>No Categories available.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script src="js/dashboard.js"></script>
        <script>
            // Menu toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            // Autocomplete
            var debounceTimer;
            function showSuggestions(str) {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    var box = document.getElementById("suggestionBox");
                    box.innerHTML = "";
                    if (str.length < 1) return;

                    var matches = allCategoryNames.filter(name => 
                        name.toLowerCase().includes(str.toLowerCase())
                    );
                    
                    if (matches.length > 0) {
                        matches.slice(0, 5).forEach(name => {
                            var item = document.createElement("button");
                            item.type = "button";
                            item.className = "list-group-item list-group-item-action";
                            item.textContent = name;
                            item.onclick = function () {
                                document.getElementById("searchCategory").value = name;
                                box.innerHTML = "";
                                document.getElementById("searchForm").submit();
                            };
                            box.appendChild(item);
                        });
                    } else {
                        var item = document.createElement("div");
                        item.className = "list-group-item text-muted small";
                        item.textContent = "No categories found.";
                        box.appendChild(item);
                    }
                }, 200);
            }

            // Ẩn suggestions khi click bên ngoài
            document.addEventListener('click', function(e) {
                var searchInput = document.getElementById('searchCategory');
                var suggestionBox = document.getElementById('suggestionBox');
                if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                    suggestionBox.innerHTML = "";
                }
            });
        </script>
    </body>
</html>