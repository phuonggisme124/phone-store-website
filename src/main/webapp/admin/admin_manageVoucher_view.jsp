<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.List"%>
<%@page import="model.Vouchers"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voucher Management - Admin Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="css/dashboard_admin.css">
    <link href="css/dashboard_table.css" rel="stylesheet">
</head>
<body>

    <div class="d-flex" id="wrapper">
        
        <%@ include file="sidebar.jsp" %>

        <div class="page-content flex-grow-1">
            
            <nav class="navbar navbar-light bg-white shadow-sm mb-4">
                <div class="container-fluid">
                    <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                    <div class="d-flex align-items-center ms-auto">
                        <div class="d-flex align-items-center">
                            <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                            <span class="fw-bold">Admin</span>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="container-fluid px-4 pb-5">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold text-primary mb-0">Voucher List</h3>
                    <a href="admin?action=createVoucher" class="btn btn-success shadow-sm">
                        <i class="bi bi-plus-lg me-1"></i> Create Voucher
                    </a>
                </div>

                <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 text-center">
                                <thead class="table-light text-secondary">
                                    <tr>
                                        <th class="py-3">ID</th>
                                        <th class="py-3">Code</th>
                                        <th class="py-3">Discount (%)</th>
                                        <th class="py-3">Start Day</th>
                                        <th class="py-3">End Day</th>
                                        <th class="py-3">Quantity</th>
                                        <th class="py-3">Status</th>
                                        <th class="py-3" width="180">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Vouchers> list = (List<Vouchers>) request.getAttribute("listVouchers");
                                        if (list != null && !list.isEmpty()) {
                                            for (Vouchers v : list) {
                                    %>
                                    <tr>
                                        <td class="fw-bold text-muted">#<%= v.getVoucherID() %></td>
                                        <td class="text-primary fw-bold"><%= v.getCode() %></td>
                                        <td>
                                            <span class="badge bg-info text-dark bg-opacity-25 border border-info px-3">
                                                <%= v.getPercentDiscount() %>%
                                            </span>
                                        </td>
                                        <td><%= v.getStartDay() %></td>
                                        <td><%= v.getEndDay() %></td>
                                        <td><%= v.getQuantity() %></td>
                                        <td>
                                            <%= v.getStatus() %>
                                        </td>
                                        <td>
                                            <a href="admin?action=updateVoucher&id=<%=v.getVoucherID()%>" 
                                               class="btn btn-outline-warning btn-sm me-1" title="Edit">
                                                <i class="bi bi-pencil-square"></i>
                                            </a>

                                            <a href="admin?action=deleteVoucher&id=<%=v.getVoucherID()%>" 
                                               class="btn btn-outline-danger btn-sm"
                                               onclick="return confirm('Are you sure you want to delete voucher: <%= v.getCode() %>?')"
                                               title="Delete">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <% 
                                            } 
                                        } else {
                                    %>
                                        <tr>
                                            <td colspan="8" class="text-center py-5 text-muted">
                                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                                <p class="mb-0">No vouchers found.</p>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/dashboard.js"></script>

</body>
</html>