<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Voucher - Admin Dashboard</title>

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
                
                <div class="mx-auto bg-white p-4 rounded shadow-sm" style="max-width: 800px;">
                    <h3 class="fw-bold text-primary border-bottom pb-3 mb-4">Create Voucher</h3>

                    <form action="voucher" method="post">
                        
                        <input type="hidden" name="action" value="createVoucher">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Voucher Code</label>
                                <input type="text" name="code" class="form-control" placeholder="e.g. SUMMER2025" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Discount (%)</label>
                                <input type="number" name="percentDiscount" class="form-control" placeholder="e.g. 10" min="1" max="100" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Start Day</label>
                                <input type="date" name="startDay" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">End Day</label>
                                <input type="date" name="endDay" class="form-control" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Quantity</label>
                                <input type="number" name="quantity" class="form-control" placeholder="e.g. 100" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Status</label>
                                <select name="status" class="form-select">
                                    <option value="Active">Active</option>
                                    <option value="Inactive">Inactive</option>
                                </select>
                            </div>
                        </div>

                        <div class="mt-4 d-flex gap-2">
                            <button type="submit" class="btn btn-success flex-grow-1">Create</button>
                             <a href="admin?action=viewVoucher" class="btn btn-secondary">Back</a>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/dashboard.js"></script> </body>
</html>