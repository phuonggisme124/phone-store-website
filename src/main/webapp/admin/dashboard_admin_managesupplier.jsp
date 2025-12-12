<%@page import="model.Staff"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Suppliers</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_managesupplier.css" rel="stylesheet">
        
        
    </head>
    <body>
        <%
            Staff currentUser = (Staff) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login");
                return;
            }

            List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
            // Lấy giá trị search hiện tại từ request
            String currentSupplierName = request.getParameter("supplierName") != null ? request.getParameter("supplierName") : "";

            // Tạo danh sách tên nhà cung cấp để autocomplete
            List<String> allSupplierNames = new ArrayList<>();
            if (listSupplier != null) {
                for (Suppliers s : listSupplier) {
                    if (!allSupplierNames.contains(s.getName())) {
                        allSupplierNames.add(s.getName());
                    }
                }
            }
            
           
        %>

        <script>
            const allSupplierNames = <%= new Gson().toJson(allSupplierNames)%>;
        </script>

        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">

                            <form action="supplier" method="get" class="position-relative mb-0" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="manageSupplier">

                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted ps-3 rounded-start-pill border-light-purple">
                                        <i class="bi bi-shop"></i>
                                    </span>

                                    <input class="form-control border-start-0 border-end-0 border-light-purple shadow-none" 
                                           type="text" 
                                           id="searchSupplier" 
                                           name="supplierName"
                                           placeholder="Search Supplier..." 
                                           value="<%= (request.getAttribute("currentSupplierName") != null) ? request.getAttribute("currentSupplierName") : ""%>"
                                           oninput="showSuggestions(this.value)"
                                           style="width: 250px; font-size: 0.9rem;">

                                    <button class="btn btn-gradient-primary rounded-end-pill px-3" type="submit">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>

                                <div id="suggestionBox" class="list-group position-absolute w-100 mt-1 shadow-lg border-0 rounded-3 overflow-hidden"
                                     style="top: 100%; z-index: 1000; display: none;"></div>
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

                
                
                <%
                    String successCreateSupplier = (String) session.getAttribute("successCreateSupplier");
                    String successUpdateSupplier = (String) session.getAttribute("successUpdateSupplier");
                    String successDeleteSupplier = (String) session.getAttribute("successDeleteSupplier");
                    if (successCreateSupplier != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successCreateSupplier%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("successCreateSupplier"); } %>

                <% if (successUpdateSupplier != null) { %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successUpdateSupplier%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("successUpdateSupplier"); } %>
                
                <% if (successDeleteSupplier != null) { %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successDeleteSupplier%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("successDeleteSupplier"); } %>

                <div class="card shadow-sm border-0 rounded-4 m-3 overflow-hidden">
                    <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Manage Suppliers</h4>
                            <p class="text-muted small mb-0">List of all product suppliers</p>
                        </div>
                        <a class="btn btn-gradient-primary px-4 py-2 rounded-pill shadow-sm d-flex align-items-center gap-2" href="supplier?action=createSupplier">
                            <i class="bi bi-plus-lg"></i> 
                            <span>Add New</span>
                        </a>
                    </div>
                    
                    <% if (!currentSupplierName.isEmpty()) { %>
                    <div class="bg-light-purple bg-opacity-10 px-4 py-2 border-bottom d-flex align-items-center flex-wrap gap-2">
                        <span class="text-muted small fw-bold me-2"><i class="bi bi-funnel-fill me-1"></i>Filters:</span>

                        <div class="badge bg-white text-dark border border-light-purple shadow-sm rounded-pill p-2 pe-3 d-flex align-items-center">
                            <span class="text-muted fw-normal me-1">Name:</span>
                            <span class="text-primary fw-bold"><%= currentSupplierName %></span>
                            <a href="supplier?action=manageSupplier" class="ms-2 text-danger d-flex align-items-center text-decoration-none hover-scale">
                                <i class="bi bi-x-circle-fill fs-6"></i>
                            </a>
                        </div>

                        <a href="supplier?action=manageSupplier" class="text-muted small text-decoration-none ms-auto hover-danger d-flex align-items-center">
                            <i class="bi bi-arrow-counterclockwise me-1"></i> Clear All
                        </a>
                    </div>
                    <% } %>

                    <div class="card-body p-0">
                        <% if (listSupplier != null && !listSupplier.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 custom-table">
                                <thead class="bg-light-purple text-uppercase small fw-bold text-muted">
                                    <tr>
                                        <th class="ps-4" style="width: 80px;">ID</th>
                                        <th>Supplier Info</th>
                                        <th>Contact</th>
                                        <th>Address</th>
                                        <th class="text-end pe-4">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="border-top-0">
                                    <%
                                        for (Suppliers s : listSupplier) {
                                            if (!currentSupplierName.isEmpty() && !s.getName().toLowerCase().contains(currentSupplierName.toLowerCase())) {
                                                continue;
                                            }
                                            // Tạo avatar giả từ chữ cái đầu
                                            String initial = s.getName().length() > 0 ? s.getName().substring(0, 1).toUpperCase() : "S";
                                    %>
                                    <tr onclick="window.location.href = 'supplier?action=editSupplier&id=<%= s.getSupplierID()%>'" 
                                        class="cursor-pointer transition-hover">

                                        <td class="ps-4 fw-bold text-primary">
                                            <span class="product-id-badge">#<%= s.getSupplierID()%></span></td>

                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="rounded-circle bg-light-purple text-primary d-flex align-items-center justify-content-center fw-bold" 
                                                     style="width: 40px; height: 40px;">
                                                    <%= initial%>
                                                </div>
                                                <div>
                                                    <span class="d-block fw-bold text-dark"><%= s.getName()%></span>
                                                    <span class="small text-muted">Active</span>
                                                </div>
                                            </div>
                                        </td>

                                        <td>
                                            <div class="d-flex flex-column">
                                                <span class="text-dark"><i class="bi bi-telephone me-2 text-muted"></i><%= s.getPhone()%></span>
                                                <small class="text-muted"><i class="bi bi-envelope me-2"></i><%= s.getEmail()%></small>
                                            </div>
                                        </td>

                                        <td class="text-secondary" style="max-width: 200px;">
                                            <span class="d-inline-block text-truncate w-100">
                                                <%= s.getAddress()%>
                                            </span>
                                        </td>

                                        <td class="text-end pe-4">
                                            <button class="btn btn-sm btn-light text-primary rounded-circle">
                                                <i class="bi bi-chevron-right"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="text-center p-5">
                            <div class="mb-3">
                                <i class="bi bi-shop text-muted" style="font-size: 3rem; opacity: 0.5;"></i>
                            </div>
                            <h5 class="text-muted">No suppliers found</h5>
                            <p class="text-secondary small">Try adding a new supplier or adjusting your search.</p>
                        </div>
                        <% }%>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script src="js/dashboard.js"></script>
        <script>
            // 1. Biến Timer để Debounce (tránh spam)
            var debounceTimer;

            function showSuggestions(str) {
                var box = document.getElementById("suggestionBox");

                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    box.innerHTML = ""; // Xóa gợi ý cũ

                    // Nếu ô input rỗng thì ẨN hộp gợi ý và dừng lại
                    if (str.length < 1) {
                        box.style.display = "none";
                        return;
                    }

                    // Lọc tên Supplier
                    var matches = allSupplierNames.filter(name =>
                        name.toLowerCase().includes(str.toLowerCase())
                    );

                    // Xử lý hiển thị
                    if (matches.length > 0) {
                        // Có kết quả -> Render danh sách
                        matches.slice(0, 5).forEach(name => {
                            var item = document.createElement("button");
                            item.type = "button";
                            item.className = "list-group-item list-group-item-action text-start";
                            item.textContent = name;

                            // Click vào gợi ý
                            item.onclick = function () {
                                document.getElementById("searchSupplier").value = name;
                                box.style.display = "none"; // Chọn xong thì ẩn đi
                                box.innerHTML = "";
                                document.getElementById("searchForm").submit();
                            };
                            box.appendChild(item);
                        });
                    } else {
                        // Không tìm thấy -> Báo lỗi nhẹ
                        var item = document.createElement("div");
                        item.className = "list-group-item text-muted small";
                        item.textContent = "No suppliers found.";
                        box.appendChild(item);
                    }

                    // QUAN TRỌNG NHẤT: BẬT ĐÈN LÊN (Hiện box) 💡
                    box.style.display = "block";

                }, 200);
            }

            // 2. Ẩn suggestions khi click bên ngoài
            document.addEventListener('click', function (e) {
                var searchInput = document.getElementById('searchSupplier');
                var suggestionBox = document.getElementById('suggestionBox');

                // Nếu click không trúng ô input VÀ không trúng hộp gợi ý
                if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                    suggestionBox.style.display = "none"; // Ẩn box đi
                }
            });
        </script>
        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
        <script>
            setTimeout(() => {
                const alert = document.querySelector('.alert'); // Chỉ auto hide alert success thôi, không hide promo alert
                if (alert && alert.classList.contains('alert-success')) {
                    alert.classList.remove('show');
                    alert.classList.add('fade');
                    setTimeout(() => alert.remove(), 500);
                }
            }, 3000);
        </script>
    </body>
</html>