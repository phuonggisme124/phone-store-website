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
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>
<div class="d-flex" id="wrapper">
    <!-- Sidebar -->
    <nav class="sidebar bg-white shadow-sm border-end">
        <div class="sidebar-header p-3">
            <h4 class="fw-bold text-primary">Mantis</h4>
        </div>
        <ul class="list-unstyled ps-3">
            <li><a href="#" class="active"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
            <li><a href="#"><i class="bi bi-box me-2"></i>Products</a></li>
            <li><a href="#"><i class="bi bi-bag me-2"></i>Orders</a></li>
            <li><a href="#"><i class="bi bi-people me-2"></i>Users</a></li>
            <li><a href="#"><i class="bi bi-gear me-2"></i>Settings</a></li>
        </ul>
    </nav>

    <!-- Page Content -->
    <div class="page-content flex-grow-1">
        <!-- Navbar -->
        <nav class="navbar navbar-light bg-white shadow-sm">
            <div class="container-fluid">
                <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                <form class="d-none d-md-flex ms-3">
                    <input class="form-control" type="search" placeholder="Ctrl + K" readonly>
                </form>
                <div class="d-flex align-items-center ms-auto">
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
                <div class="col-xl-3 col-md-6">
                    <div class="card p-3 border-0 shadow-sm">
                        <h6>Total Page Views</h6>
                        <h3 class="fw-bold text-primary"><%= request.getAttribute("views") != null ? request.getAttribute("views") : "442,236" %></h3>
                        <small class="text-success"><i class="bi bi-graph-up"></i> +59.3%</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card p-3 border-0 shadow-sm">
                        <h6>Total Users</h6>
                        <h3 class="fw-bold text-success"><%= request.getAttribute("users") != null ? request.getAttribute("users") : "78,250" %></h3>
                        <small class="text-success"><i class="bi bi-arrow-up-right"></i> +70.5%</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card p-3 border-0 shadow-sm">
                        <h6>Total Orders</h6>
                        <h3 class="fw-bold text-warning"><%= request.getAttribute("orders") != null ? request.getAttribute("orders") : "18,800" %></h3>
                        <small class="text-warning"><i class="bi bi-arrow-down-right"></i> -27.4%</small>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card p-3 border-0 shadow-sm">
                        <h6>Total Sales</h6>
                        <h3 class="fw-bold text-danger">$<%= request.getAttribute("sales") != null ? request.getAttribute("sales") : "35,078" %></h3>
                        <small class="text-danger"><i class="bi bi-arrow-down-right"></i> -27.4%</small>
                    </div>
                </div>
            </div>

            <div class="row mt-4 g-4">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h6>Unique Visitors</h6>
                            <div>
                                <button class="btn btn-sm btn-outline-primary active">Week</button>
                                <button class="btn btn-sm btn-outline-secondary">Month</button>
                            </div>
                        </div>
                        <div id="visitorChart" class="mt-3"></div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm p-3">
                        <h6>Income Overview</h6>
                        <h3 class="fw-bold">$7,650</h3>
                        <div id="incomeChart" class="mt-4"></div>
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
<script src="js/dashboard.js"></script>
</body>
</html>
