<%@page import="java.sql.Timestamp"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Customer"%> 
<%@page import="model.Staff"%>    
<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Users</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">

        <style>
            /* --- 1. GENERAL TONE --- */
            body { background-color: #f5f5f9; font-family: 'Segoe UI', sans-serif; }
            .text-primary { color: #696cff !important; }
            .bg-light-purple { background-color: #f5f5f9 !important; color: #697a8d; }
            .border-light-purple { border-color: rgba(102, 126, 234, 0.3) !important; }

            /* --- 2. BUTTONS --- */
            .btn-gradient-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none; color: white; transition: all 0.3s ease;
            }
            .btn-gradient-primary:hover { transform: translateY(-2px); box-shadow: 0 4px 10px rgba(105, 108, 255, 0.4); color: white; }

            .btn-outline-custom {
                color: #667eea; border: 1px solid rgba(102, 126, 234, 0.3); background: white;
            }
            .btn-outline-custom:hover {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-color: transparent;
            }

            /* --- 3. TABS (Styled Links) --- */
            .nav-pills .nav-link {
                color: #697a8d; font-weight: 600; border-radius: 50px; padding: 10px 25px; margin-right: 10px; transition: all 0.3s; cursor: pointer;
            }
            .nav-pills .nav-link.active {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white; box-shadow: 0 4px 10px rgba(105, 108, 255, 0.4);
            }
            .nav-pills .nav-link:hover:not(.active) { background-color: rgba(105, 108, 255, 0.1); color: #696cff; }

            /* --- 4. TABLE --- */
            .custom-table thead th {
                background-color: #f5f5f9 !important; color: #566a7f;
                font-size: 0.75rem; font-weight: 700; text-transform: uppercase;
                border-bottom: 1px solid #d9dee3; padding: 1.2rem 1rem;
            }
            .custom-table tbody tr { transition: all 0.2s ease-in-out; background-color: #fff; }
            .custom-table tbody tr:hover {
                transform: scale(1.01); box-shadow: 0 5px 15px rgba(105, 108, 255, 0.15);
                z-index: 10; position: relative; background-color: #fff !important; border-radius: 5px;
            }
            .product-id-badge { background-color: rgba(105, 108, 255, 0.12); color: #696cff; padding: 5px 10px; border-radius: 6px; font-weight: 600; font-size: 0.85rem; }

            /* --- 5. ROLES & STATUS --- */
            .role-customer { color: #696cff; background-color: #e8fadf; padding: 5px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: 600;}
            .role-staff { color: #03c3ec; background-color: #d7f5fc; padding: 5px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: 600;}
            .role-shipper { color: #ffab00; background-color: #fff2d6; padding: 5px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: 600;}
            
            .status-green { color: #71dd37; background-color: #e8fadf; padding: 5px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: 600; }
            .status-red { color: #ff3e1d; background-color: #ffe0db; padding: 5px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: 600; }

            /* Suggestion Box */
            #suggestionBox { background: white; border: 1px solid rgba(102, 126, 234, 0.2); border-radius: 0 0 12px 12px; box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1); }
            #suggestionBox .list-group-item:hover { background-color: #f5f5f9; padding-left: 1.5rem; transition: all 0.2s; color: #696cff; }
            
            /* Navbar Profile */
            .hover-danger:hover { background-color: #ffe5e5 !important; color: #dc3545 !important; transform: rotate(90deg); transition: 0.3s; }
        </style>
    </head>
    <body>
        <%
            // 1. LOGIC GIỮ NGUYÊN
            Staff currentUser = (Staff) session.getAttribute("user");
            
            // Xử lý roleTable (Tránh null pointer)
            Integer roleTableObj = (Integer) request.getAttribute("role");
            int roleTable = (roleTableObj != null) ? roleTableObj : 0; // Mặc định 0 nếu null

            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login");
                return;
            }

            List<Customer> listCustomers = (List<Customer>) request.getAttribute("listCustomers");
            List<Staff> listStaff = (List<Staff>) request.getAttribute("listStaff");

            String currentRole = request.getParameter("roleFilter") != null ? request.getParameter("roleFilter") : "All";
            String currentUserName = request.getParameter("userName") != null ? request.getParameter("userName") : "";

            List<String> allUserNames = new ArrayList<>();
            if (listCustomers != null) {
                for (Customer u : listCustomers) {
                    if (!allUserNames.contains(u.getFullName())) {
                        allUserNames.add(u.getFullName());
                    }
                }
            }
             // Bổ sung autocomplete cho Staff nếu cần
            if (listStaff != null) {
                for (Staff u : listStaff) {
                    if (u.getRole() != 4 && !allUserNames.contains(u.getFullName())) {
                         allUserNames.add(u.getFullName());
                    }
                }
            }
        %>

        <script>const allUserNames = <%= new Gson().toJson(allUserNames)%>;</script>

        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <div class="page-content flex-grow-1">
                
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">
                            <form action="admin" method="get" class="position-relative mb-0" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="manageUser">
                                <input type="hidden" name="roleFilter" value="<%= currentRole%>">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted ps-3 rounded-start-pill border-light-purple"><i class="bi bi-person-circle"></i></span>
                                    <input class="form-control border-start-0 border-end-0 border-light-purple shadow-none" type="text" id="searchUser" name="userName" placeholder="Search User..." value="<%= currentUserName%>" oninput="showSuggestions(this.value)" style="width: 250px; font-size: 0.9rem;">
                                    <button class="btn btn-gradient-primary rounded-end-pill px-3" type="submit"><i class="bi bi-search"></i></button>
                                </div>
                                <div id="suggestionBox" class="list-group position-absolute w-100 mt-1 shadow-lg border-0 rounded-3 overflow-hidden" style="top: 100%; z-index: 1000; display: none;"></div>
                            </form>

                            <% 
                                String roleLabel = "All Roles";
                                if(currentRole.equals("1")) roleLabel = "Customer";
                            %>
                            <form action="admin" method="get" class="dropdown mb-0">
                                <input type="hidden" name="action" value="manageUser">
                                <input type="hidden" name="userName" value="<%= currentUserName%>">
                                <button class="btn btn-outline-custom dropdown-toggle px-3 rounded-pill d-flex align-items-center gap-2" type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel-fill"></i> <span>Role: <%= roleLabel %></span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 mt-2">
                                    <li><button type="submit" name="roleFilter" value="All" class="dropdown-item">All Roles</button></li>
                                    <li><button type="submit" name="roleFilter" value="1" class="dropdown-item">Customer</button></li>
                                </ul>
                            </form>

                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>

                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <img src="https://i.pravatar.cc/150?u=<%= currentUser.getStaffID()%>" class="rounded-circle border border-2 border-white shadow-sm" width="40" height="40">
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;"><%= currentUser.getFullName()%></span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                    </div>
                                </div>
                                <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" style="width: 38px; height: 38px;"><i class="bi bi-box-arrow-right fs-6"></i></a>
                            </div>
                        </div>
                    </div>
                </nav>

                <%
                    String successCreateUser = (String) session.getAttribute("successCreateUser");
                    String successUpdateUser = (String) session.getAttribute("successUpdateUser");
                    String successDeleteUser = (String) session.getAttribute("successDeleteUser");

                    if (successCreateUser != null) { %>
                    <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3 shadow-sm border-0" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i><%= successCreateUser%>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("successCreateUser"); } %>

                    <% if (successUpdateUser != null) { %>
                    <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3 shadow-sm border-0" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i><%= successUpdateUser%>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("successUpdateUser"); } %>
                    
                    <% if (successDeleteUser != null) { %>
                    <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3 shadow-sm border-0" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i><%= successDeleteUser%>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("successDeleteUser"); } %>

                <div class="card shadow-sm border-0 rounded-4 m-3 overflow-hidden">
                    <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Manage Users</h4>
                            <p class="text-muted small mb-0">Manage staff and customer accounts</p>
                        </div>
                        
                        <div class="nav nav-pills">
                            <a href="customer?action=manageUser" class="nav-link d-flex align-items-center gap-2 <%= (roleTable != 1) ? "active" : "" %>">
                                <i class="bi bi-person-badge"></i> Staff
                            </a>
                            <a href="customer?action=manageUser&role=1" class="nav-link d-flex align-items-center gap-2 <%= (roleTable == 1) ? "active" : "" %>">
                                <i class="bi bi-people"></i> Customer
                            </a>
                        </div>

                        <a class="btn btn-gradient-primary px-4 py-2 rounded-pill shadow-sm d-flex align-items-center gap-2" href="customer?action=createAccount">
                            <i class="bi bi-person-plus"></i> <span>Add User</span>
                        </a>
                    </div>

                    <div class="card-body p-0">
                        
                        <% if (roleTable == 1) { %>
                            <% if (listCustomers != null && !listCustomers.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 custom-table">
                                    <thead class="bg-light-purple">
                                        <tr>
                                            <th class="ps-4">ID</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Role</th>
                                            <th>Address</th>
                                            <th>Joined Date</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Customer u : listCustomers) { 
                                            // Logic Filter cũ
                                            if (!currentRole.equals("All") && u.getRole() != Integer.parseInt(currentRole)) continue;
                                            if (!currentUserName.isEmpty() && !u.getFullName().toLowerCase().contains(currentUserName.toLowerCase())) continue;
                                            
                                            // Logic hiển thị
                                            String statusBadge = (u.getStatus() != null && u.getStatus().equalsIgnoreCase("Active")) 
                                                ? "<span class='status-green'><i class='bi bi-check-circle me-1'></i>Active</span>" 
                                                : "<span class='status-red'><i class='bi bi-lock me-1'></i>Locked</span>";
                                                
                                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy");
                                            String dateFormated = "N/A";
                                            // Xử lý Date an toàn (Vì đại ca import cả Timestamp và LocalDateTime)
                                            if (u.getCreatedAt() != null) {
                                                try {
                                                    dateFormated = u.getCreatedAt().toLocalDateTime().format(formatter);
                                                } catch (Exception e) {
                                                    // Fallback nếu là Date thường
                                                }
                                            }
                                        %>
                                        <tr onclick="window.location.href='customer?action=edit&id=<%= u.getCustomerID()%>&role=<%= u.getRole()%>'" class="cursor-pointer">
                                            <td class="ps-4"><span class="product-id-badge">#<%= u.getCustomerID()%></span></td>
                                            <td><span class="fw-bold text-dark"><%= u.getFullName()%></span></td>
                                            <td><%= u.getEmail()%></td>
                                            <td><%= u.getPhone()%></td>
                                            <td><span class="role-customer"><i class="bi bi-person me-1"></i>Customer</span></td>
                                            <td><div class="text-truncate" style="max-width: 150px;"><%= u.getAddress() != null ? u.getAddress() : "N/A"%></div></td>
                                            <td><small class="text-muted"><%= dateFormated%></small></td>
                                            <td><%= statusBadge%></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } else { %>
                                <div class="text-center p-5 text-muted">No customers found.</div>
                            <% } %>
                        
                        <% } else { %>
                            <% if (listStaff != null && !listStaff.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 custom-table">
                                    <thead class="bg-light-purple">
                                        <tr>
                                            <th class="ps-4">ID</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Role</th>
                                            <th>Joined Date</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Staff u : listStaff) { 
                                            if (u.getRole() == 4) continue; // Skip Admin
                                            if (!currentRole.equals("All") && u.getRole() != Integer.parseInt(currentRole)) continue;
                                            if (!currentUserName.isEmpty() && !u.getFullName().toLowerCase().contains(currentUserName.toLowerCase())) continue;
                                            
                                            String roleName = (u.getRole() == 2) ? "Staff" : "Shipper";
                                            String roleClass = (u.getRole() == 2) ? "role-staff" : "role-shipper";
                                            String roleIcon = (u.getRole() == 2) ? "bi-person-badge" : "bi-truck";
                                            
                                            String statusBadge = (u.getStatus() != null && u.getStatus().equalsIgnoreCase("Active")) 
                                                ? "<span class='status-green'><i class='bi bi-check-circle me-1'></i>Active</span>" 
                                                : "<span class='status-red'><i class='bi bi-lock me-1'></i>Locked</span>";
                                            
                                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy");
                                            String dateFormated = "N/A";
                                            if (u.getCreatedAt() != null) {
                                                try {
                                                    dateFormated = u.getCreatedAt().toLocalDateTime().format(formatter);
                                                } catch (Exception e) {}
                                            }
                                        %>
                                        <tr onclick="window.location.href='user?action=edit&id=<%= u.getStaffID()%>&role=<%= u.getRole()%>'" class="cursor-pointer">
                                            <td class="ps-4"><span class="product-id-badge">#<%= u.getStaffID()%></span></td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="rounded-circle bg-light d-flex justify-content-center align-items-center text-secondary fw-bold" style="width: 32px; height: 32px;"><%= u.getFullName().substring(0, 1).toUpperCase()%></div>
                                                    <span class="fw-bold text-dark"><%= u.getFullName()%></span>
                                                </div>
                                            </td>
                                            <td><%= u.getEmail()%></td>
                                            <td><%= u.getPhone()%></td>
                                            <td><span class="<%= roleClass%>"><i class="bi <%= roleIcon%> me-1"></i><%= roleName%></span></td>
                                            <td><small class="text-muted"><%= dateFormated%></small></td>
                                            <td><%= statusBadge%></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } else { %>
                                <div class="text-center p-5 text-muted">No staff found.</div>
                            <% } %>
                        <% } %>

                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/dashboard.js"></script>
        <script>
            // Toggle Sidebar
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            // Autocomplete Search
            var debounceTimer;
            function showSuggestions(str) {
                var box = document.getElementById("suggestionBox");
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    box.innerHTML = "";
                    if (str.length < 1) { box.style.display = "none"; return; }
                    var matches = allUserNames.filter(name => name.toLowerCase().includes(str.toLowerCase()));
                    if (matches.length > 0) {
                        matches.slice(0, 5).forEach(name => {
                            var item = document.createElement("button");
                            item.type = "button";
                            item.className = "list-group-item list-group-item-action text-start";
                            item.textContent = name;
                            item.onclick = function () {
                                document.getElementById("searchUser").value = name;
                                box.style.display = "none";
                                document.getElementById("searchForm").submit();
                            };
                            box.appendChild(item);
                        });
                        box.style.display = "block";
                    } else { box.style.display = "none"; }
                }, 200);
            }
            
            document.addEventListener('click', function (e) {
                if (!document.getElementById('searchUser').contains(e.target)) {
                    document.getElementById('suggestionBox').style.display = "none";
                }
            });
            
            // Auto hide alerts
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