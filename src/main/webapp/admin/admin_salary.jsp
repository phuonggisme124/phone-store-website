<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Staff"%>
<%@page import="model.Shipper"%>
<%@page import="model.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - Quản Lý Lương</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/dashboard_admin.css">
    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/dashboard_table.css">
    
    <style>
        .table-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="d-flex" id="wrapper">
        <%@ include file="sidebar.jsp" %>

        <div class="page-content flex-grow-1">
            
            <% 
                // 1. Kiểm tra đăng nhập
                Users user = (Users) session.getAttribute("user");
                if (user == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                // 2. Lấy dữ liệu từ Servlet gửi sang
                List<Staff> staffs = (List<Staff>) request.getAttribute("staffs");
                List<Shipper> shippers = (List<Shipper>) request.getAttribute("shippers");

                // Tránh null pointer nếu list chưa khởi tạo
                if (staffs == null) staffs = new ArrayList<>();
                if (shippers == null) shippers = new ArrayList<>();
            %>

            <nav class="navbar navbar-light bg-white shadow-sm mb-4">
                <div class="container-fluid">
                    <button class="btn btn-outline-primary" id="menu-toggle">
                        <i class="bi bi-list"></i>
                    </button>
                    <h5 class="ms-3 mb-0 text-secondary">Salary Management</h5>
                    <div class="d-flex align-items-center ms-auto">
                        <div class="d-flex align-items-center">
                            <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                            <span><%= user.getFullName() %></span>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="container-fluid px-4">
                
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm p-3 text-white bg-success">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6>Total Staff</h6>
                                    <h3><%= staffs.size() %></h3>
                                </div>
                                <i class="bi bi-people-fill fs-1"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm p-3 text-white bg-primary">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6>Total Shippers</h6>
                                    <h3><%= shippers.size() %></h3>
                                </div>
                                <i class="bi bi-truck fs-1"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="table-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="text-success"><i class="bi bi-person-workspace me-2"></i>Bảng Lương Nhân Viên</h5>
                        <button class="btn btn-sm btn-outline-success"><i class="bi bi-file-earmark-excel"></i> Export Excel</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ và Tên</th>
                                    <th>Ngày Vào Làm</th>
                                    <th class="text-center">Hệ Số (Rate)</th>
                                    <th>Lương</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    // Kiểm tra nếu list rỗng
                                    if (staffs.isEmpty()) { 
                                %>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">Không có dữ liệu nhân viên</td>
                                    </tr>
                                <% 
                                    } else {
                                        // Vòng lặp duyệt danh sách Staff
                                        for (Staff s : staffs) {
                                            // Logic màu sắc cho Rate
                                            String badgeClass = "bg-secondary";
                                            if (s.getRate() >= 1.6) badgeClass = "bg-danger";
                                            else if (s.getRate() >= 1.4) badgeClass = "bg-primary";
                                %>
                                    <tr>
                                        <td>#<%= s.getId() %></td>
                                        <td>
                                            <div class="fw-bold"><%= s.getFullName() %></div>
                                            <small class="text-muted">Staff</small>
                                        </td>
                                        <td><%= s.getCreatedAt().toLocalDate() %></td> 
                                        
                                        <td class="text-center">
                                            <span class="badge rounded-pill <%= badgeClass %>">
                                                <%= s.getRate() %>
                                            </span>
                                        </td>
                                        <td class = "fw-bold text-success">
                                            <%= String.format("%,.0f VND", s.getTotalsalary())  %>
                                            
                                        </td>
                                       
                                    </tr>
                                <% 
                                        } // End for
                                    } // End else
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="table-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="text-primary"><i class="bi bi-truck me-2"></i>Bảng Lương Shipper</h5>
                        <button class="btn btn-sm btn-outline-primary"><i class="bi bi-file-earmark-excel"></i> Export Excel</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ và Tên</th>
                                    <th>Ngày Vào Làm</th>
                                    <th>Hoa Hồng (Commission)</th>
                                    <th class="text-center">Hệ Số (Rate)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    // Kiểm tra list Shipper rỗng
                                    if (shippers.isEmpty()) { 
                                %>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">Không có dữ liệu shipper</td>
                                    </tr>
                                <% 
                                    } else {
                                        // Duyệt danh sách Shipper
                                        for (Shipper ship : shippers) {
                                            // Logic màu sắc
                                            String badgeClass = "bg-secondary";
                                            if (ship.getRate() >= 1.6) badgeClass = "bg-danger";
                                            else if (ship.getRate() >= 1.4) badgeClass = "bg-primary";
                                %>
                                    <tr>
                                        <td>#<%= ship.getId() %></td>
                                        <td>
                                            <div class="fw-bold"><%= ship.getFullName() %></div>
                                            <small class="text-muted">Shipper</small>
                                        </td>
                                        <td><%= ship.getCreatedAt().toLocalDate() %></td>
                                        
                                        <td class="text-success fw-bold">
                                            <%= String.format("$%.2f", ship.getCommission()) %>
                                        </td>
                                        
                                        <td class="text-center">
                                            <span class="badge rounded-pill <%= badgeClass %>">
                                                <%= ship.getRate() %>
                                            </span>
                                        </td>
                                            <td class = "fw-bold text-success">
                                            <%= String.format("%,.0f VND", ship.getTotalSalary())  %>
                                            
                                        </td>
                                    </tr>
                                <% 
                                        } // End for
                                    } // End else 
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div> </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var el = document.getElementById("wrapper");
        var toggleButton = document.getElementById("menu-toggle");

        toggleButton.onclick = function () {
            el.classList.toggle("toggled");
        };
    </script>
</body>
</html>