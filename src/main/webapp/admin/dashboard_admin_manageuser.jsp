
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Users"%>
<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Users</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
        <link href="css/dashboard_admin_manageuser.css" rel="stylesheet">

    </head>
    <body>
        <%
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login");
                return;
            }

            List<Users> listUsers = (List<Users>) request.getAttribute("listUsers");

            // Lấy giá trị filter/search hiện tại từ request
            String currentRole = request.getParameter("roleFilter") != null ? request.getParameter("roleFilter") : "All";
            String currentUserName = request.getParameter("userName") != null ? request.getParameter("userName") : "";

            // Tạo danh sách tên người dùng để autocomplete
            List<String> allUserNames = new ArrayList<>();
            if (listUsers != null) {
                for (Users u : listUsers) {
                    if (u.getRole() != 4 && !allUserNames.contains(u.getFullName())) {
                        allUserNames.add(u.getFullName());
                    }
                }
            }
        %>

        <script>
            const allUserNames = <%= new Gson().toJson(allUserNames)%>;

        </script>

        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">

                            <!-- Search User -->
                            <form action="admin" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="manageUser">
                                <!-- Giữ lại roleFilter nếu đang filter -->
                                <input type="hidden" name="roleFilter" value="<%= currentRole%>">
                                <input class="form-control me-2" type="text" id="searchUser" name="userName"
                                       placeholder="Search User…" value="<%= currentUserName%>"

                                       oninput="showSuggestions(this.value)">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                                <div id="suggestionBox" class="list-group position-absolute w-100"
                                     style="top: 100%; z-index: 1000;"></div>
                            </form>

                            <!-- Filter Role -->
                            <form action="admin" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="manageUser">
                                <!-- Giữ lại userName nếu đang search -->
                                <input type="hidden" name="userName" value="<%= currentUserName%>">


                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Filter
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="roleFilter" value="All" class="dropdown-item">All Roles</button></li>
                                    <li><button type="submit" name="roleFilter" value="1" class="dropdown-item">
                                            <i class="bi bi-person"></i> Customer
                                        </button></li>
                                    <li><button type="submit" name="roleFilter" value="2" class="dropdown-item">
                                            <i class="bi bi-person-badge"></i> Staff
                                        </button></li>
                                    <li><button type="submit" name="roleFilter" value="3" class="dropdown-item">
                                            <i class="bi bi-truck"></i> Shipper
                                        </button></li>
                                </ul>
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                            <div class="d-flex align-items-center ms-3">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser.getFullName()%></span>

                            </div>
                        </div>
                    </div>
                </nav>
                <!-- Users Table -->
                <%
                    String successCreateUser = (String) session.getAttribute("successCreateUser");
                    String successUpdateUser = (String) session.getAttribute("successUpdateUser");
                    String successDeleteUser = (String) session.getAttribute("successDeleteUser");
                    if (successCreateUser != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successCreateUser%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successCreateUser");
                    }
                %>
                
                
                <%
                    
                    
                    if (successUpdateUser != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successUpdateUser%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successUpdateUser");
                    }
                %>
                <%
                    
                    
                    if (successDeleteUser != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successDeleteUser%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <%
                        session.removeAttribute("successDeleteUser");
                    }
                %>
                <div class="container-fluid px-4 pb-4 m-3">
                    <div class="card shadow-sm border-0 p-4">
                        <div class="card-body p-0">
                            <div class="container-fluid p-4 ps-3">
                                <h1 class="fw-bold ps-3 mb-4 fw-bold text-primary">Manage User</h1>
                            </div>
                            <!-- Create Account Button -->
                            <div class="container-fluid p-4">
                                <a class="btn btn-primary px-4 py-2 rounded-pill shadow-sm" href="user?action=createAccount">
                                    <i class="bi bi-person-plus"></i> Create Account
                                </a>
                            </div>
                            <% if (listUsers != null && !listUsers.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>UserID</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Role</th>
                                            <th>Address</th>
                                            <th>CreatedAt</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Users u : listUsers) {
                                                // Không hiển thị Admin (role 4)
                                                if (u.getRole() == 4) {
                                                    continue;
                                                }


                                                // Lọc theo Role nếu không phải "All"
                                                if (!currentRole.equals("All") && u.getRole() != Integer.parseInt(currentRole)) {
                                                    continue;
                                                }

                                                // Lọc theo User Name nếu có search
                                                if (!currentUserName.isEmpty() && !u.getFullName().toLowerCase().contains(currentUserName.toLowerCase())) {
                                                    continue;
                                                }

                                                String role;
                                                String roleIcon;
                                                String roleColor;

                                                switch (u.getRole()) {
                                                    case 1:
                                                        role = "Customer";
                                                        roleIcon = "bi-person";
                                                       roleColor = "status-green";

                                                        break;
                                                    case 2:
                                                        role = "Staff";
                                                        roleIcon = "bi-person-badge";

                                                        roleColor = "status-blue";

                                                        break;
                                                    case 3:
                                                        role = "Shipper";
                                                        roleIcon = "bi-truck";

                                                        roleColor = "status-yellow";

                                                        break;
                                                    default:
                                                        role = "Unknown";
                                                        roleIcon = "bi-question-circle";

                                                        roleColor = "";

                                                }

                                                String statusBadge;
                                                String status = u.getStatus();
                                                if (status != null && status.equalsIgnoreCase("Active")) {

                                                    statusBadge = "<span class='badge status-green '>Active</span>";
                                                } else {
                                                    statusBadge = "<span class='badge status-red '>Locked</span>";
                                                }
                                        %>
                                        <tr onclick="window.location.href = 'user?action=edit&id=<%= u.getUserId()%>'" style="cursor: pointer;">

                                            <td>#<%= u.getUserId()%></td>
                                            <td><%= u.getFullName()%></td>
                                            <td><%= u.getEmail()%></td>
                                            <td><%= u.getPhone()%></td>

                                            <td class="<%= roleColor %>">
                                                <i class="bi <%= roleIcon%> me-1 <%= roleColor %>"></i><%= role%>
                                            </td>
                                            <td><%= u.getAddress() != null ? u.getAddress() : "N/A"%></td>
                                            <%
                                                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                                                String dateFormated = "";
                                                LocalDateTime createAt = u.getCreatedAt();
                                                if (createAt != null) {
                                                    dateFormated = createAt.format(formatter);
                                                }
                                            %>
                                            <td><%= dateFormated%></td>
                                            <td><%= statusBadge%></td>

                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } else { %>
                            <div class="alert alert-info m-4" role="alert">
                                <i class="bi bi-info-circle me-2"></i>No users available.
                            </div>

                            <% }%>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Custom JS -->
        <script src="js/dashboard.js"></script>
        <script>
                                            // Menu toggle
                                            document.getElementById("menu-toggle").addEventListener("click", function () {
                                                document.getElementById("wrapper").classList.toggle("toggled");
                                            });

                                            // ------------------ Autocomplete ------------------
                                            var debounceTimer;
                                            function showSuggestions(str) {
                                                clearTimeout(debounceTimer);
                                                debounceTimer = setTimeout(() => {
                                                    var box = document.getElementById("suggestionBox");
                                                    box.innerHTML = "";
                                                    if (str.length < 1)
                                                        return;

                                                    var matches = allUserNames.filter(name =>
                                                        name.toLowerCase().includes(str.toLowerCase())
                                                    );

                                                    if (matches.length > 0) {
                                                        matches.slice(0, 5).forEach(name => {
                                                            var item = document.createElement("button");
                                                            item.type = "button";
                                                            item.className = "list-group-item list-group-item-action";
                                                            item.textContent = name;
                                                            item.onclick = function () {
                                                                document.getElementById("searchUser").value = name;
                                                                box.innerHTML = "";
                                                                document.getElementById("searchForm").submit();
                                                            };
                                                            box.appendChild(item);
                                                        });
                                                    } else {
                                                        var item = document.createElement("div");
                                                        item.className = "list-group-item text-muted small";
                                                        item.textContent = "No users found.";
                                                        box.appendChild(item);
                                                    }
                                                }, 200);
                                            }

                                            // Ẩn suggestions khi click bên ngoài
                                            document.addEventListener('click', function (e) {
                                                var searchInput = document.getElementById('searchUser');
                                                var suggestionBox = document.getElementById('suggestionBox');
                                                if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                                                    suggestionBox.innerHTML = "";
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
                const alert = document.querySelector('.alert');
                if (alert) {
                    alert.classList.remove('show');
                    alert.classList.add('fade');
                    setTimeout(() => alert.remove(), 500);
                }
            }, 3000);
        </script>

    </body>
</html>