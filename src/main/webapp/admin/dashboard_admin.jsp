<%@page import="dao.SupplierDAO"%>
<%@page import="dao.VariantsDAO"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/dashboard_admin.css">
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>


            <!-- Page Content -->
            <%                ProductDAO pdao = new ProductDAO();
                VariantsDAO vdao = new VariantsDAO();
                SupplierDAO sldao = new SupplierDAO();
                int totalSupplier = sldao.getAllSupplier().size();
                int totalVariant = vdao.getAllVariant().size();
                int totalProduct = pdao.getAllProduct().size();

                List<Users> listUser = (List<Users>) request.getAttribute("listUser");
                int importOfMonth = (int) request.getAttribute("importOfMonth");
                int soldOfMonth = (int) request.getAttribute("soldOfMonth");
                double revenueOfMonth = (double) request.getAttribute("revenueOfMonth");
                double revenueTargetOfMonth = (double) request.getAttribute("revenueTargetOfMonth");
                double costOfMonth = (double) request.getAttribute("costOfMonth");
                double incomeOfMonth = (double) request.getAttribute("incomeOfMonth");
                double incomeTargetOfMonth = (double) request.getAttribute("incomeTargetOfMonth");

                double percentRevenue = (revenueOfMonth / revenueTargetOfMonth) * 100;
                double percentSold = ((double) soldOfMonth / importOfMonth) * 100.0;
                double percentIncome = (incomeOfMonth / incomeTargetOfMonth) * 100;

                int currentYear = Calendar.getInstance().get(Calendar.YEAR);
                int currentMonth = Calendar.getInstance().get(Calendar.MONTH);
                int yearSelect = (int) request.getAttribute("yearSelect");
                int monthSelect = (int) request.getAttribute("monthSelect");
                List<Double> monthlyIncome = (List<Double>) request.getAttribute("monthlyIncome");
                List<Integer> monthlyOrder = (List<Integer>) request.getAttribute("monthlyOrder");

                if (yearSelect == 0) {

                    yearSelect = currentYear;
                }

                if (monthSelect == 0) {

                    monthSelect = currentMonth;
                }

            %>
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <form class="d-none d-md-flex ms-3">
                            <input class="form-control" type="search" placeholder="Ctrl + K" readonly>
                        </form>
                        <div class="d-flex align-items-center ms-auto">
                            <div class="position-relative me-3">
                                <a href="${pageContext.request.contextPath}/logout">logout</a>
                            </div>
                            <i class="bi bi-bell me-3 fs-5"></i>
                            <div class="position-relative me-3">
                                <i class="bi bi-github fs-5"></i>
                            </div>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span>Admin</span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Main Dashboard -->
                <div class="container-fluid p-4">
                    <div class="row g-3">
                        <!--                        <div class="col-xl-3 col-md-6">
                                                    <div class="card p-3 border-0 shadow-sm">
                                                        <h6>Total Page Views</h6>
                                                        <h3 class="fw-bold text-primary"></h3>
                                                        <small class="text-success"><i class="bi bi-graph-up"></i> +59.3%</small>
                                                    </div>
                                                </div>-->
                        <div class="col-xl-3 col-md-6">
                            <div class="card p-3 border-0 shadow-sm">
                                <h6>Total Product</h6>
                                <h3 class="fw-bold text-primary"><%= totalProduct%></h3>

                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card p-3 border-0 shadow-sm">
                                <h6>Total Users</h6>
                                <h3 class="fw-bold text-success"><%= listUser != null ? listUser.size() : ""%></h3>

                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card p-3 border-0 shadow-sm">
                                <h6>Total Variant</h6>
                                <h3 class="fw-bold text-warning"><%= totalVariant%></h3>

                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card p-3 border-0 shadow-sm">
                                <h6>Total Supplier</h6>
                                <h3 class="fw-bold text-danger"><%= totalSupplier%></h3>

                            </div>
                        </div>
                    </div>

                    <div class="row mt-4 g-4">
                        <!-- Chart Income -->
                        <div class="col-md-8">
                            <div class="card border-0 shadow-sm p-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="card border-0 p-3">
                                        <h6>Income Overview</h6>
                                    </div>
                                    <div class="chart-toggle d-flex gap-2 mt-3">
                                        <div class="card border-0 p-1">
                                            <h6>Month</h6>
                                        </div>
                                        <select id="monthSelect" name="monthSelect" class="form-select form-select-sm me-3" style="width:auto;" onchange="goToYear(this)">
                                            <%
                                                int totalMonth = currentMonth;
                                                if (yearSelect < currentYear) {
                                                    totalMonth = 12;
                                                }
                                            %>
                                            <% for (int m = 1; m <= totalMonth; m++) {%>
                                            <option value="<%= m%>" <%= (monthSelect == m) ? "selected" : ""%>><%= m%></option>
                                            <% }%>
                                        </select>
                                        <div class="card border-0 p-1">
                                            <h6>Year</h6>
                                        </div>
                                        <select id="yearSelect" name="yearSelect" class="form-select form-select-sm me-3" style="width:auto;" onchange="goToYear(this)">
                                            <% for (int y = currentYear; y >= currentYear - 5; y--) {%>
                                            <option value="<%= y%>" <%= (yearSelect == y) ? "selected" : ""%>><%= y%></option>
                                            <% }%>
                                        </select>
                                    </div>
                                </div>
                                <div id="incomeChart" class="mt-4"></div>
                            </div>
                        </div>

                        <!-- Chart Orders -->
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm p-3">
                                <h6>Orders</h6>
                                <div id="orderChart" class="mt-3"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Nhóm Target -->
                    <div class="month-group-header mt-4 g-4">
                        Target for <%= monthSelect%> / <%= yearSelect%>
                    </div>
                    <div class="row month-stats target">
                        <div class="col-xl-3 col-md-3">
                            <div class="card month-stat-card revenue">
                                <h6>Total Revenue Target</h6>
                                <h3><%= String.format("%.2f", revenueTargetOfMonth / 1000000)%> m</h3>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-3">
                            <div class="card month-stat-card sold">
                                <h6>Total Products Imported</h6>
                                <h3><%= importOfMonth%></h3>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-5">
                            <div class="card month-stat-card income">
                                <h6>Income Target</h6>
                                <h3><%= String.format("%.2f", incomeTargetOfMonth / 1000000)%> m</h3>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-5">
                            <div class="card month-stat-card cost">
                                <h6>Total Purchase Cost</h6>
                                <h3><%= String.format("%.2f", costOfMonth / 1000000)%> m</h3>
                            </div>
                        </div>
                    </div>

                    <!-- Nhóm Achieved -->
                    <div class="month-group-header">
                        Achieved in <%= monthSelect%> / <%= yearSelect%>
                    </div>
                    <div class="row month-stats achieved">
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card revenue">
                                <h6>Total Revenue</h6>
                                <h3><%= String.format("%.2f", revenueOfMonth / 1000000)%> m</h3>
                                <div class="progress">
                                    <div class="progress-bar bg-success" role="progressbar"
                                         style="width: <%= percentRevenue%>%;" 
                                         aria-valuenow="<%= percentRevenue%>" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <small><%= String.format("%.1f", percentRevenue)%>% of target</small>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card sold">
                                <h6>Sold Products</h6>
                                <h3><%= soldOfMonth%></h3>
                                <div class="progress">
                                    <div class="progress-bar bg-warning" role="progressbar"
                                         style="width: <%= percentSold%>%;" 
                                         aria-valuenow="<%= percentSold%>" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <small><%= String.format("%.1f", percentSold)%>% of target</small>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card month-stat-card income">
                                <h6>Income</h6>
                                <h3><%= String.format("%.2f", incomeOfMonth / 1000000)%> m</h3>
                                <div class="progress">
                                    <div class="progress-bar bg-danger" role="progressbar"
                                         style="width: <%= percentIncome%>%;" 
                                         aria-valuenow="<%= percentIncome%>" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <small><%= String.format("%.1f", percentIncome)%>% of target</small>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- JS Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

        <!-- Custom JS -->
        <script>

                                            function goToYear(selectElement) {
                                                const year = selectElement.value;
                                                const yearSelected = document.getElementById("yearSelect").value;
                                                const monthSelected = document.getElementById("monthSelect").value;
                                                window.location.href = "<%= request.getContextPath()%>/admin?action=dashboard&monthSelect=" + monthSelected + "&yearSelect=" + yearSelected;
                                            }
        </script>
        <script>
            // Lấy dữ liệu từ servlet
            const monthlyIncome = ${monthlyIncome};
            const monthlyOrder = <%= monthlyOrder%>;
            const selectYear = <%= yearSelect%>;
            const contextPath = "<%= request.getContextPath()%>";
        </script>
        <script src="<%= request.getContextPath()%>/js/dashboard.js"></script>


    </body>
</html>
