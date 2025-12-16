<%@page import="model.Staff"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<<<<<<< HEAD
<%@page import="model.Staff"%> <%@page import="com.google.gson.Gson"%>
=======

<%@page import="com.google.gson.Gson"%>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Categories</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<<<<<<< HEAD

=======
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_managecategory.css">
        
    </head>
    <body>
        <%
<<<<<<< HEAD
            // SỬA: Lấy Staff từ Session
            Staff currentUser = (Staff) session.getAttribute("user");
            
=======
            Staff currentUser = (Staff) session.getAttribute("user");
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
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
<<<<<<< HEAD
                <nav class="navbar navbar-light bg-white shadow-sm">
=======
                
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>
<<<<<<< HEAD
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
=======

                        <div class="d-flex align-items-center ms-auto gap-3">

                            <form action="category" method="get" class="position-relative mb-0" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="manageCategory">
                                
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted ps-3 rounded-start-pill border-light-purple">
                                        <i class="bi bi-grid"></i> </span>
                                    
                                    <input class="form-control border-start-0 border-end-0 border-light-purple shadow-none" 
                                           type="text" 
                                           id="searchCategory" 
                                           name="categoryName"
                                           placeholder="Search Category..." 
                                           value="<%= currentCategoryName %>"
                                           oninput="showSuggestions(this.value)"
                                           style="width: 250px; font-size: 0.9rem;">

                                    <button class="btn btn-gradient-primary rounded-end-pill px-3" type="submit">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>

                                <div id="suggestionBox" class="list-group position-absolute w-100 mt-1 shadow-lg border-0 rounded-3 overflow-hidden"
                                     style="top: 100%; z-index: 1000; display: none;"></div>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                            </form>

                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>

                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="position-relative">
                                        <img src="https://i.pravatar.cc/150?u=<%= currentUser.getStaffID()%>" 
                                             class="rounded-circle border border-2 border-white shadow-sm" 
                                             width="40" height="40" alt="Avatar">
                                        <span class="position-absolute bottom-0 start-100 translate-middle p-1 bg-success border border-light rounded-circle">
                                            <span class="visually-hidden">Online</span>
                                        </span>
                                    </div>
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;"><%= currentUser.getFullName()%></span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                    </div>
                                </div>

                                <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" 
                                   style="width: 38px; height: 38px;" title="Logout">
                                    <i class="bi bi-box-arrow-right fs-6"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </nav>

<<<<<<< HEAD
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
=======
                <div class="card shadow-sm border-0 rounded-4 m-3 overflow-hidden">
                    <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Manage Category</h4>
                            <p class="text-muted small mb-0">List of all product categories</p>
                        </div>
                        <a class="btn btn-gradient-primary px-4 py-2 rounded-pill shadow-sm d-flex align-items-center gap-2" href="category?action=createCategory">
                            <i class="bi bi-plus-lg"></i> 
                            <span>Create Category</span>
                        </a>
                    </div>

                    <% if (!currentCategoryName.isEmpty()) { %>
                    <div class="bg-light-purple bg-opacity-10 px-4 py-2 border-bottom d-flex align-items-center flex-wrap gap-2">
                        <span class="text-muted small fw-bold me-2"><i class="bi bi-funnel-fill me-1"></i>Filters:</span>

                        <span class="filter-chip chip-light">
                            Name: <span class="fw-bold ms-1 text-primary"><%= currentCategoryName %></span>
                            <a href="category?action=manageCategory" class="btn-close-chip" title="Remove search"><i class="bi bi-x"></i></a>
                        </span>

                        <a href="category?action=manageCategory" class="text-muted small text-decoration-none ms-auto animate-hover d-flex align-items-center">
                            <i class="bi bi-arrow-counterclockwise me-1"></i> Clear All
                        </a>
                    </div>
                    <% } %>

                    <div class="card-body p-0">
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                        <% if (listCategory != null && !listCategory.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 custom-table">
                                <thead class="bg-light-purple text-uppercase small fw-bold text-muted">
                                    <tr>
                                        <th class="ps-4" style="width: 80px;">ID</th>
                                        <th>Category Name</th>
                                        <th>Descriptions</th>
                                        <th class="text-end pe-4">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="border-top-0">
                                    <%
                                        for (Category c : listCategory) {
                                            if (!currentCategoryName.isEmpty() && !c.getCategoryName().toLowerCase().contains(currentCategoryName.toLowerCase())) {
                                                continue;
                                            }
                                    %>
<<<<<<< HEAD
                                    <tr onclick="window.location.href = 'category?action=editCategory&id=<%= c.getCategoryId()%>'" style="cursor: pointer;">
                                        <td>#<%= c.getCategoryId()%></td>
                                        <td><%= c.getCategoryName() %></td>
                                        <td><%= c.getDescription() %></td>
=======
                                    <tr onclick="window.location.href = 'category?action=editCategory&id=<%= c.getCategoryId()%>'" 
                                        class="cursor-pointer transition-hover">
                                        
                                        <td class="ps-4 fw-bold text-primary">
                                            <span class="product-id-badge">#<%= c.getCategoryId()%></span>
                                        </td>
                                        
                                        <td>
                                            <span class="fw-bold text-dark"><%= c.getCategoryName() %></span>
                                        </td>
                                        
                                        <td class="text-secondary">
                                            <%= c.getDescription() %>
                                        </td>

                                        <td class="text-end pe-4">
                                            <button class="btn btn-sm btn-light text-primary rounded-circle">
                                                <i class="bi bi-chevron-right"></i>
                                            </button>
                                        </td>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
<<<<<<< HEAD
                        <div class="alert alert-info m-4" role="alert">
                            <i class="bi bi-info-circle me-2"></i>No Categories available.
=======
                        <div class="text-center p-5">
                            <div class="mb-3">
                                <i class="bi bi-grid text-muted" style="font-size: 3rem; opacity: 0.5;"></i>
                            </div>
                            <h5 class="text-muted">No categories found</h5>
                            <p class="text-secondary small">Try creating a new category.</p>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
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
                    if (str.length < 1) {
                        box.style.display = "none";
                        return;
                    }

                    var matches = allCategoryNames.filter(name => 
                        name.toLowerCase().includes(str.toLowerCase())
                    );
                    
                    if (matches.length > 0) {
                        matches.slice(0, 5).forEach(name => {
                            var item = document.createElement("button");
                            item.type = "button";
                            item.className = "list-group-item list-group-item-action text-start";
                            item.textContent = name;
                            item.onclick = function () {
                                document.getElementById("searchCategory").value = name;
                                box.style.display = "none";
                                box.innerHTML = "";
                                document.getElementById("searchForm").submit();
                            };
                            box.appendChild(item);
                        });
                        box.style.display = "block";
                    } else {
                        var item = document.createElement("div");
                        item.className = "list-group-item text-muted small";
                        item.textContent = "No categories found.";
                        box.appendChild(item);
                        box.style.display = "block";
                    }
                }, 200);
            }

            // Ẩn suggestions khi click bên ngoài
            document.addEventListener('click', function(e) {
                var searchInput = document.getElementById('searchCategory');
                var suggestionBox = document.getElementById('suggestionBox');
                if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                    suggestionBox.style.display = "none";
                }
            });
        </script>
    </body>
</html>