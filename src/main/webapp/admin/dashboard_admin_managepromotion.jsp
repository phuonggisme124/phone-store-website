<%@page import="model.Staff"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.Promotions"%>
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
        <title>Admin Dashboard - Manage Promotions</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
        <link href="css/dashboard_managepromotion.css" rel="stylesheet">

        
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

            List<Products> listProducts = (List<Products>) request.getAttribute("listProducts");
            List<Promotions> listPromotions = (List<Promotions>) request.getAttribute("listPromotions");

            // Lấy giá trị filter/search hiện tại từ request
            String currentDiscount = request.getParameter("discountFilter") != null ? request.getParameter("discountFilter") : "All";
            String currentProductName = request.getParameter("productName") != null ? request.getParameter("productName") : "";

            // Tạo danh sách tên sản phẩm để autocomplete
            List<String> allProductNames = new ArrayList<>();
            if (listPromotions != null && listProducts != null) {
                for (Promotions pmt : listPromotions) {
                    for (Products pd : listProducts) {
                        if (pmt.getProductID() == pd.getProductID() && !allProductNames.contains(pd.getName())) {
                            allProductNames.add(pd.getName());
                        }
                    }
                }
            }
            
            // Giả lập số liệu cho Alert
            int activePromoCount = 0;
            if(listPromotions != null) {
                for(Promotions p : listPromotions) {
                    if("Active".equalsIgnoreCase(p.getStatus())) activePromoCount++;
                }
            }
        %>

        <script>
            const allProductNames = <%= new Gson().toJson(allProductNames)%>;
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

                            <form action="promotion" method="get" class="position-relative mb-0" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="managePromotion">
                                <input type="hidden" name="discountFilter" value="<%= currentDiscount%>">

                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 text-muted ps-3 rounded-start-pill border-light-purple">
                                        <i class="bi bi-gift"></i> 
                                    </span>

                                    <input class="form-control border-start-0 border-end-0 border-light-purple shadow-none" 
                                           type="text" 
                                           id="searchProduct" 
                                           name="productName"
                                           placeholder="Search Product..." 
                                           value="<%= currentProductName%>"
                                           oninput="showSuggestions(this.value)"
                                           style="width: 250px; font-size: 0.9rem;">

                                    <button class="btn btn-gradient-primary rounded-end-pill px-3" type="submit">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>

                                <div id="suggestionBox" class="list-group position-absolute w-100 mt-1 shadow-lg border-0 rounded-3 overflow-hidden"
                                     style="top: 100%; z-index: 1000; display: none;"></div>
                            </form>

                            <form action="promotion" method="get" class="dropdown mb-0">
                                <input type="hidden" name="action" value="managePromotion">
                                <input type="hidden" name="productName" value="<%= currentProductName%>">

                                <button class="btn btn-outline-custom dropdown-toggle px-3 rounded-pill d-flex align-items-center gap-2"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel-fill"></i> 
                                    <span>Discount: <%= currentDiscount.equals("All") ? "All" : currentDiscount + "%"%></span>
                                </button>

                                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 mt-2" aria-labelledby="filterDropdown">
                                    <li>
                                        <button type="submit" name="discountFilter" value="All" class="dropdown-item <%= currentDiscount.equals("All") ? "active-gradient" : ""%>">
                                            <i class="bi bi-grid-fill me-2 text-muted"></i> All Discounts
                                        </button>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <%
                                        String[] discounts = {"0-20", "21-40", "41-60", "61-80", "81-100"};
                                        for (String disc : discounts) {
                                    %>
                                    <li>
                                        <button type="submit" name="discountFilter" value="<%= disc%>" class="dropdown-item <%= currentDiscount.equals(disc) ? "active-gradient" : ""%>">
                                            <i class="bi bi-tag-fill me-2 text-primary"></i> <%= disc%>%
                                        </button>
                                    </li>
                                    <% }%>
                                </ul>
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
                    String successCreatePromotion = (String) session.getAttribute("successCreatePromotion");
                    String successUpdatePromotion = (String) session.getAttribute("successUpdatePromotion");
                    String successDeletePromotion = (String) session.getAttribute("successDeletePromotion");
                    if (successCreatePromotion != null) {
                %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successCreatePromotion%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("successCreatePromotion"); } %>

                <% if (successUpdatePromotion != null) { %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successUpdatePromotion%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("successUpdatePromotion"); } %>

                <% if (successDeletePromotion != null) { %>
                <div class="alert alert-success alert-dismissible fade show w-50 mx-auto mt-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= successDeletePromotion%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("successDeletePromotion"); } %>

                <div class="card shadow-sm border-0 rounded-4 m-3 overflow-hidden">
                    <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Manage Promotions</h4>
                            <p class="text-muted small mb-0">Active discount campaigns</p>
                        </div>
                        <a class="btn btn-gradient-primary px-4 py-2 rounded-pill shadow-sm d-flex align-items-center gap-2" href="promotion?action=createPromotion">
                            <i class="bi bi-tag-fill"></i> 
                            <span>Create Promo</span>
                        </a>
                    </div>

                    <% 
                        boolean hasSearch = !currentProductName.isEmpty();
                        boolean hasDiscount = !currentDiscount.equals("All");
                        if (hasSearch || hasDiscount) { 
                    %>
                    <div class="bg-light-purple bg-opacity-10 px-4 py-2 border-bottom d-flex align-items-center flex-wrap gap-2">
                        <span class="text-muted small fw-bold me-2"><i class="bi bi-funnel-fill me-1"></i>Filters:</span>
                        
                        <% if (hasSearch) { %>
                        <div class="badge bg-white text-dark border border-light-purple shadow-sm rounded-pill p-2 pe-3 d-flex align-items-center">
                            <span class="text-muted fw-normal me-1">Product:</span>
                            <span class="text-primary fw-bold"><%= currentProductName %></span>
                            <a href="promotion?action=managePromotion&discountFilter=<%= currentDiscount %>" 
                               class="ms-2 text-danger d-flex align-items-center text-decoration-none hover-scale"><i class="bi bi-x-circle-fill fs-6"></i></a>
                        </div>
                        <% } %>

                        <% if (hasDiscount) { %>
                        <div class="badge bg-white text-dark border border-light-purple shadow-sm rounded-pill p-2 pe-3 d-flex align-items-center">
                            <span class="text-muted fw-normal me-1">Discount:</span>
                            <span class="text-primary fw-bold"><%= currentDiscount %>%</span>
                            <a href="promotion?action=managePromotion&productName=<%= currentProductName %>" 
                               class="ms-2 text-danger d-flex align-items-center text-decoration-none hover-scale"><i class="bi bi-x-circle-fill fs-6"></i></a>
                        </div>
                        <% } %>

                        
                        <a href="promotion?action=managePromotion" class="btn btn-sm btn-link text-danger text-decoration-none fw-bold ms-2 animate-hover">
                                    Clear All
                                </a>
                    </div>
                    <% } %>

                    <div class="card-body p-0">
                        <% if (listPromotions != null && !listPromotions.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 custom-table">
                                <thead class="bg-light-purple text-uppercase small fw-bold text-muted">
                                    <tr>
                                        <th class="ps-4" style="width: 80px;">ID</th>
                                        <th>Product Info</th>
                                        <th>Discount</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Status</th>
                                        <th class="text-end pe-4">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="border-top-0">
                                    <%
                                        for (Promotions pmt : listPromotions) {
                                            String productName = "";
                                            for (Products pd : listProducts) {
                                                if (pmt.getProductID() == pd.getProductID()) {
                                                    productName = pd.getName();
                                                    break;
                                                }
                                            }
                                            
                                            if (!currentProductName.isEmpty() && !productName.toLowerCase().contains(currentProductName.toLowerCase())) continue;
                                            
                                            int discount = (int) pmt.getDiscountPercent();
                                            boolean matchDiscount = false;
                                            if (currentDiscount.equals("All")) matchDiscount = true;
                                            else if (currentDiscount.equals("0-20") && discount >= 0 && discount <= 20) matchDiscount = true;
                                            else if (currentDiscount.equals("21-40") && discount >= 21 && discount <= 40) matchDiscount = true;
                                            else if (currentDiscount.equals("41-60") && discount >= 41 && discount <= 60) matchDiscount = true;
                                            else if (currentDiscount.equals("61-80") && discount >= 61 && discount <= 80) matchDiscount = true;
                                            else if (currentDiscount.equals("81-100") && discount >= 81 && discount <= 100) matchDiscount = true;
                                            
                                            if (!matchDiscount) continue;

                                            String discountClass = "bg-info";
                                            if (discount >= 50) discountClass = "bg-danger";
                                            else if (discount >= 30) discountClass = "bg-warning text-dark";

                                            String statusClass = "bg-secondary";
                                            String statusIcon = "bi-dash-circle";
                                            String status = pmt.getStatus();
                                            if (status != null && status.equalsIgnoreCase("Active")) {
                                                statusClass = "bg-success-subtle text-success";
                                                statusIcon = "bi-check-circle-fill";
                                            } else if (status != null && status.equalsIgnoreCase("Pending")) {
                                                statusClass = "bg-warning-subtle text-warning";
                                                statusIcon = "bi-hourglass-split";
                                            } else {
                                                statusClass = "bg-danger-subtle text-danger";
                                                statusIcon = "bi-x-circle-fill";
                                            }

                                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy");
                                            String startDateFormatted = (pmt.getStartDate() != null) ? pmt.getStartDate().format(formatter) : "-";
                                            String endDateFormatted = (pmt.getEndDate() != null) ? pmt.getEndDate().format(formatter) : "-";
                                    %>
                                    <tr onclick="window.location.href = 'promotion?action=editPromotion&pmtID=<%= pmt.getPromotionID()%>&pID=<%= pmt.getProductID()%>'" 
                                        class="cursor-pointer transition-hover">
                                        
                                        <td class="ps-4 fw-bold text-primary">
                                            <span class="product-id-badge" style="color: white">#<%= pmt.getPromotionID()%></span>
                                        </td>
                                        
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="rounded bg-light-purple text-primary d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                                    <i class="bi bi-box-seam"></i>
                                                </div>
                                                <span class="fw-bold text-dark"><%= productName %></span>
                                            </div>
                                        </td>

                                        <td>
                                            <span class="badge rounded-pill <%= discountClass %> shadow-sm px-3 py-2">
                                                <i class="bi bi-arrow-down-short"></i> <%= discount %>%
                                            </span>
                                        </td>

                                        <td>
                                            <span class="d-inline-flex align-items-center text-muted small bg-light rounded px-2 py-1 border border-light">
                                                <i class="bi bi-calendar-event me-2 text-primary"></i> <%= startDateFormatted %>
                                            </span>
                                        </td>

                                        <td>
                                            <span class="d-inline-flex align-items-center text-muted small bg-light rounded px-2 py-1 border border-light">
                                                <i class="bi bi-calendar-check me-2 text-danger"></i> <%= endDateFormatted %>
                                            </span>
                                        </td>

                                        <td>
                                            <span class="badge rounded-pill <%= statusClass %> border border-0 px-3 py-2 d-inline-flex align-items-center gap-1">
                                                <i class="bi <%= statusIcon %>"></i> <%= status %>
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
                                <i class="bi bi-tags text-muted" style="font-size: 3rem; opacity: 0.5;"></i>
                            </div>
                            <h5 class="text-muted">No promotions found</h5>
                            <p class="text-secondary small">Try adjusting your filters or create a new campaign.</p>
                        </div>
                        <% }%>
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

            // ------------------ Autocomplete (Fixed Version) ------------------
            var debounceTimer;
            function showSuggestions(str) {
                var box = document.getElementById("suggestionBox");
                clearTimeout(debounceTimer);
                
                debounceTimer = setTimeout(() => {
                    box.innerHTML = "";
                    
                    if (str.length < 1) {
                        box.style.display = "none";
                        return;
                    }

                    var matches = allProductNames.filter(name =>
                        name.toLowerCase().includes(str.toLowerCase())
                    );

                    if (matches.length > 0) {
                        matches.slice(0, 5).forEach(name => {
                            var item = document.createElement("button");
                            item.type = "button";
                            item.className = "list-group-item list-group-item-action text-start";
                            item.textContent = name;
                            item.onclick = function () {
                                document.getElementById("searchProduct").value = name;
                                box.style.display = "none";
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
                    
                    // QUAN TRỌNG: Hiện box
                    box.style.display = "block";
                }, 200);
            }

            // Ẩn suggestions khi click bên ngoài
            document.addEventListener('click', function (e) {
                var searchInput = document.getElementById('searchProduct');
                var suggestionBox = document.getElementById('suggestionBox');
                if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                    suggestionBox.style.display = "none";
                }
            });
            
            // Auto hide success alerts
            setTimeout(() => {
                const alert = document.querySelector('.alert-success');
                if (alert) {
                    alert.classList.remove('show');
                    alert.classList.add('fade');
                    setTimeout(() => alert.remove(), 500);
                }
            }, 3000);
        </script>
    </body>
</html>