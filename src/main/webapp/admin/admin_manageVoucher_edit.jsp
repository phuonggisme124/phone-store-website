<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="model.Vouchers"%>
<!DOCTYPE html>
<html lang="en">
<<<<<<< HEAD
<head>
    <meta charset="UTF-8">
    <title>Edit Voucher - Admin Dashboard</title>

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
                
                <%
                    // Lấy dữ liệu voucher từ Controller
                    Vouchers v = (Vouchers) request.getAttribute("voucher");
                %>

                <div class="mx-auto bg-white p-4 rounded shadow-sm" style="max-width: 800px;">
                    <h3 class="fw-bold text-primary border-bottom pb-3 mb-4">Edit Voucher</h3>

                    <form action="voucher" method="post">
                        
                        <input type="hidden" name="action" value="updateVoucher">
                        <input type="hidden" name="id" value="<%= (v != null) ? v.getVoucherID() : "" %>">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Voucher Code</label>
                                <input type="text" name="code" class="form-control" 
                                       value="<%= (v != null) ? v.getCode() : "" %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Discount (%)</label>
                                <input type="number" name="percentDiscount" class="form-control" 
                                       value="<%= (v != null) ? v.getPercentDiscount() : "" %>" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Start Day</label>
                                <input type="date" name="startDay" class="form-control" 
                                       value="<%= (v != null) ? v.getStartDay() : "" %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">End Day</label>
                                <input type="date" name="endDay" class="form-control" 
                                       value="<%= (v != null) ? v.getEndDay() : "" %>" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Quantity</label>
                                <input type="number" name="quantity" class="form-control" 
                                       value="<%= (v != null) ? v.getQuantity() : "" %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Status</label>
                                <select name="status" class="form-select">
                                    <% 
                                        String status = (v != null) ? v.getStatus() : "";
                                    %>
                                    <option value="Active" <%= "Active".equals(status) ? "selected" : "" %>>Active</option>
                                    <option value="Expired" <%= "Expired".equals(status) ? "selected" : "" %>>Expired</option>
                                       
                                </select>
                            </div>
                        </div>

                        <div class="mt-4 d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-grow-1">
                                <i class="bi bi-save me-2"></i>Update
                            </button>
                            <a href="admin?action=viewVoucher" class="btn btn-secondary">Back</a>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/dashboard.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const startDayInput = document.querySelector('input[name="startDay"]');
            const endDayInput = document.querySelector('input[name="endDay"]');
            const form = document.querySelector('form');

            // 1. KHI VỪA VÀO TRANG EDIT
            // Thiết lập ngay giới hạn cho End Day dựa trên Start Day hiện có trong Database
            if (startDayInput.value) {
                endDayInput.setAttribute("min", startDayInput.value);
            }

            // 2. KHI NGƯỜI DÙNG THAY ĐỔI NGÀY BẮT ĐẦU
            startDayInput.addEventListener("change", function () {
                const newStartDate = this.value;
                
                // Cập nhật lại giới hạn cho ngày kết thúc
                endDayInput.setAttribute("min", newStartDate);

                // Nếu ngày kết thúc đang chọn lại nhỏ hơn ngày bắt đầu mới -> Xóa hoặc cảnh báo
                // Ở đây ta không xóa để user tự sửa, chỉ cảnh báo khi submit cho đỡ phiền
            });

            // 3. KHI BẤM NÚT UPDATE (Quan trọng nhất)
            form.addEventListener("submit", function(event) {
                const start = startDayInput.value;
                const end = endDayInput.value;

                if (!start || !end) return;

                // Logic: Ngày kết thúc phải >= Ngày bắt đầu
                if (end < start) {
                    alert("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu!");
                    event.preventDefault(); // Chặn không cho gửi form
                    return;
                }
                
            
            });
        });
    </script>
</body>
=======
    <head>
        <meta charset="UTF-8">
        <title>Edit Voucher - Admin Dashboard</title>

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

                    <%                    // Lấy dữ liệu voucher từ Controller
                        Vouchers v = (Vouchers) request.getAttribute("voucher");
                    %>

                    <div class="mx-auto bg-white p-4 rounded shadow-sm" style="max-width: 800px;">
                        <h3 class="fw-bold text-primary border-bottom pb-3 mb-4">Edit Voucher</h3>

                        <form action="voucher" method="post">

                            <input type="hidden" name="action" value="updateVoucher">
                            <input type="hidden" name="id" value="<%= (v != null) ? v.getVoucherID() : ""%>">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Voucher Code</label>
                                    <input type="text" name="code" class="form-control" 
                                           value="<%= (v != null) ? v.getCode() : ""%>" 
                                           required 
                                           readonly 
                                           style="background-color: #e9ecef; cursor: not-allowed;">
                                    <small class="text-muted">Mã Voucher không thể chỉnh sửa</small>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Discount (%)</label>
                                    <input type="number" name="percentDiscount" class="form-control" 
                                           value="<%= (v != null) ? v.getPercentDiscount() : ""%>" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Start Day</label>
                                    <input type="date" name="startDay" class="form-control" 
                                           value="<%= (v != null) ? v.getStartDay() : ""%>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">End Day</label>
                                    <input type="date" name="endDay" class="form-control" 
                                           value="<%= (v != null) ? v.getEndDay() : ""%>" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Quantity</label>
                                    <input type="number" name="quantity" class="form-control" 
                                           value="<%= (v != null) ? v.getQuantity() : ""%>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Status</label>
                                    <select name="status" class="form-select">
                                        <%
                                            String status = (v != null) ? v.getStatus() : "";
                                        %>
                                        <option value="Active" <%= "Active".equals(status) ? "selected" : ""%>>Active</option>
                                        <option value="Expired" <%= "Expired".equals(status) ? "selected" : ""%>>Expired</option>

                                    </select>
                                </div>
                            </div>

                            <div class="mt-4 d-flex gap-2">
                                <button type="submit" class="btn btn-primary flex-grow-1">
                                    <i class="bi bi-save me-2"></i>Update
                                </button>
                                <a href="admin?action=viewVoucher" class="btn btn-secondary">Back</a>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/dashboard.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const startDayInput = document.querySelector('input[name="startDay"]');
                const endDayInput = document.querySelector('input[name="endDay"]');
                const form = document.querySelector('form');

                // 1. KHI VỪA VÀO TRANG EDIT
                // Thiết lập ngay giới hạn cho End Day dựa trên Start Day hiện có trong Database
                if (startDayInput.value) {
                    endDayInput.setAttribute("min", startDayInput.value);
                }

                // 2. KHI NGƯỜI DÙNG THAY ĐỔI NGÀY BẮT ĐẦU
                startDayInput.addEventListener("change", function () {
                    const newStartDate = this.value;

                    // Cập nhật lại giới hạn cho ngày kết thúc
                    endDayInput.setAttribute("min", newStartDate);

                    // Nếu ngày kết thúc đang chọn lại nhỏ hơn ngày bắt đầu mới -> Xóa hoặc cảnh báo
                    // Ở đây ta không xóa để user tự sửa, chỉ cảnh báo khi submit cho đỡ phiền
                });

                // 3. KHI BẤM NÚT UPDATE (Quan trọng nhất)
                form.addEventListener("submit", function (event) {
                    const start = startDayInput.value;
                    const end = endDayInput.value;

                    if (!start || !end)
                        return;

                    // Logic: Ngày kết thúc phải >= Ngày bắt đầu
                    if (end < start) {
                        alert("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu!");
                        event.preventDefault(); // Chặn không cho gửi form
                        return;
                    }


                });
            });
        </script>
    </body>
>>>>>>> 88d3dd42faad5697b2abfed47d19f424d4faa425
</html>

</body>
</html>