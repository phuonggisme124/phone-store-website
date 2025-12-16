<<<<<<< HEAD
<%@page import="model.Staff"%>
=======
<%@page import="model.Customer"%>
<%@page import="model.Staff"%>
<%@page import="com.google.gson.Gson"%>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
<%@page import="dao.SupplierDAO"%>
<%@page import="dao.VariantsDAO"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<<<<<<< HEAD
=======

>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/dashboard_admin.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/dashboard_revenue.css">
        
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

<<<<<<< HEAD

            <!-- Page Content -->
            <%                Staff user = (Staff) session.getAttribute("user");
=======
            <% 
                Staff user = (Staff) session.getAttribute("user");
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                ProductDAO pdao = new ProductDAO();
                VariantsDAO vdao = new VariantsDAO();
                SupplierDAO sldao = new SupplierDAO();
                int totalSupplier = sldao.getAllSupplier().size();
                int totalVariant = vdao.getAllVariant().size();
                int totalProduct = pdao.getAllProduct().size();

<<<<<<< HEAD
                List<Staff> listUser = (List<Staff>) request.getAttribute("listUser");
=======
                List<Customer> listUser = (List<Customer>) request.getAttribute("listUser");
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                int importOfMonth = (int) request.getAttribute("importOfMonth");
                int soldOfMonth = (int) request.getAttribute("soldOfMonth");
                double revenueOfMonth = (double) request.getAttribute("revenueOfMonth");
                double revenueTargetOfMonth = (double) request.getAttribute("revenueTargetOfMonth");
                double costOfMonth = (double) request.getAttribute("costOfMonth");
                double incomeOfMonth = (double) request.getAttribute("incomeOfMonth");
                double incomeTargetOfMonth = (double) request.getAttribute("incomeTargetOfMonth");

                double percentRevenue = (revenueTargetOfMonth > 0) ? (revenueOfMonth / revenueTargetOfMonth) * 100 : 0;
                double percentSold = (importOfMonth > 0) ? ((double) soldOfMonth / importOfMonth) * 100.0 : 0;
                double percentIncome = (incomeTargetOfMonth > 0) ? (incomeOfMonth / incomeTargetOfMonth) * 100 : 0;

                int currentYear = Calendar.getInstance().get(Calendar.YEAR);
                int currentMonth = Calendar.getInstance().get(Calendar.MONTH) + 1;

                int yearSelect = (request.getAttribute("yearSelect") != null) ? (int) request.getAttribute("yearSelect") : currentYear;
                int monthSelect = (request.getAttribute("monthSelect") != null) ? (int) request.getAttribute("monthSelect") : currentMonth;
                
                List<Double> monthlyIncome = (List<Double>) request.getAttribute("monthlyIncome");
                List<Integer> monthlyOrder = (List<Integer>) request.getAttribute("monthlyOrder");
            %>
            
            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">
                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>

                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="position-relative">
                                        <img src="https://i.pravatar.cc/150?u=<%= user.getStaffID()%>" 
                                             class="rounded-circle border border-2 border-white shadow-sm" 
                                             width="40" height="40" alt="Avatar">
                                        <span class="position-absolute bottom-0 start-100 translate-middle p-1 bg-success border border-light rounded-circle">
                                            <span class="visually-hidden">Online</span>
                                        </span>
                                    </div>
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;"><%= user.getFullName()%></span>
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

                <div class="container-fluid p-4">
                    <div class="row g-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card revenue shadow-sm">
                                <h6>Total Product</h6>
                                <h3 class="fw-bold text-success"><%= totalProduct%></h3>
                                <small class="text-muted"><i class="bi bi-box-seam"></i> Items in stock</small>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card sold shadow-sm">
                                <h6>Total Users</h6>
                                <h3 class="fw-bold text-warning"><%= listUser != null ? listUser.size() : 0%></h3>
                                <small class="text-muted"><i class="bi bi-people"></i> Registered accounts</small>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card income shadow-sm">
                                <h6>Total Variant</h6>
                                <h3 class="fw-bold text-danger"><%= totalVariant%></h3>
                                <small class="text-muted"><i class="bi bi-phone"></i> Models available</small>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card cost shadow-sm">
                                <h6>Total Supplier</h6>
                                <h3 class="fw-bold text-primary"><%= totalSupplier%></h3>
                                <small class="text-muted"><i class="bi bi-shop"></i> Active partners</small>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-4 g-4">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm p-4">
                                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    <div>
                                        <h5 class="fw-bold text-dark mb-1">Income Overview</h5>
                                        <p class="text-muted small mb-0">Yearly income statistics</p>
                                    </div>
                                    
                                    <div class="d-flex align-items-center gap-2">
                                        <label for="monthSelect" class="text-muted small fw-bold">Month:</label>
                                        <select id="monthSelect" name="monthSelect" class="form-select form-select-sm" style="width: auto;" onchange="goToYear(this)">
                                            <%
                                                int totalMonth = (yearSelect < currentYear) ? 12 : currentMonth;
                                                for (int m = 1; m <= totalMonth; m++) {
                                            %>
                                            <option value="<%= m%>" <%= (monthSelect == m) ? "selected" : ""%>><%= m%></option>
                                            <% }%>
                                        </select>

                                        <label for="yearSelect" class="text-muted small fw-bold ms-2">Year:</label>
                                        <select id="yearSelect" name="yearSelect" class="form-select form-select-sm" style="width: auto;" onchange="goToYear(this)">
                                            <% for (int y = currentYear; y >= currentYear - 5; y--) {%>
                                            <option value="<%= y%>" <%= (yearSelect == y) ? "selected" : ""%>><%= y%></option>
                                            <% }%>
                                        </select>
                                    </div>
                                </div>
                                <div id="incomeChart" class="mt-4" style="min-height: 350px;"></div>
                            </div>
                        </div>
                    </div>

                    <div class="month-group-header mt-5">
                        Target for <%= monthSelect%> / <%= yearSelect%>
                    </div>
                    <div class="row g-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card revenue shadow-sm">
                                <h6>Revenue Target</h6>
                                <h3 class="text-success"><%= String.format("%.2f", revenueTargetOfMonth / 1000000)%> m</h3>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card sold shadow-sm">
                                <h6>Import Target</h6>
                                <h3 class="text-warning"><%= importOfMonth%></h3>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card income shadow-sm">
                                <h6>Income Target</h6>
                                <h3 class="text-danger"><%= String.format("%.2f", incomeTargetOfMonth / 1000000)%> m</h3>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card cost shadow-sm">
                                <h6>Purchase Cost</h6>
                                <h3 class="text-primary"><%= String.format("%.2f", costOfMonth / 1000000)%> m</h3>
                            </div>
                        </div>
                    </div>

                    <div class="month-group-header mt-5">
                        Achieved in <%= monthSelect%> / <%= yearSelect%>
                    </div>
                    <div class="row g-4 pb-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card revenue shadow-sm">
                                <h6>Revenue Achieved</h6>
                                <h3 class="text-success"><%= String.format("%.2f", revenueOfMonth / 1000000)%> m</h3>
                                <div class="progress">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: <%= percentRevenue%>%;"></div>
                                </div>
                                <small class="text-muted fw-bold"><%= String.format("%.1f", percentRevenue)%>% of target</small>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card sold shadow-sm">
                                <h6>Products Sold</h6>
                                <h3 class="text-warning"><%= soldOfMonth%></h3>
                                <div class="progress">
                                    <div class="progress-bar bg-warning" role="progressbar" style="width: <%= percentSold%>%;"></div>
                                </div>
                                <small class="text-muted fw-bold"><%= String.format("%.1f", percentSold)%>% of target</small>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card income shadow-sm">
                                <h6>Income Achieved</h6>
                                <h3 class="text-danger"><%= String.format("%.2f", incomeOfMonth / 1000000)%> m</h3>
                                <div class="progress">
                                    <div class="progress-bar bg-danger" role="progressbar" style="width: <%= percentIncome%>%;"></div>
                                </div>
                                <small class="text-muted fw-bold"><%= String.format("%.1f", percentIncome)%>% of target</small>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

        <script>
            function goToYear(selectElement) {
                const yearSelected = document.getElementById("yearSelect").value;
                const monthSelected = document.getElementById("monthSelect").value;
                window.location.href = "<%= request.getContextPath()%>/admin?action=dashboard&monthSelect=" + monthSelected + "&yearSelect=" + yearSelected;
            }
            
            // Menu Toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
        <script>
            // Lấy dữ liệu từ servlet (Xử lý an toàn cho JSON)
            const monthlyIncome = <%= (monthlyIncome != null) ? new Gson().toJson(monthlyIncome) : "[]" %>;
            const monthlyOrder = <%= (monthlyOrder != null) ? new Gson().toJson(monthlyOrder) : "[]" %>;
            const selectYear = <%= yearSelect%>;
            const contextPath = "<%= request.getContextPath()%>";
        </script>
        <script src="<%= request.getContextPath()%>/js/dashboard.js"></script>
    </body>
</html>