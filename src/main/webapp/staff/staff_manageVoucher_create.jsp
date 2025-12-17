<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="model.Staff"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Create Voucher</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_staff.css">
        <link href="css/dashboard_table.css" rel="stylesheet">

        <style>
            /* Style riêng cho Form Card */
            .form-card {
                background-color: #fff;
                padding: 30px;
                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                max-width: 800px;
                margin: 0 auto;
                border: none;
            }
        </style>
    </head>
    <body>

        <%
            // Kiểm tra đăng nhập
            Staff currentUser = (Staff) session.getAttribute("user");
            if (currentUser == null) {
                // response.sendRedirect("login.jsp");
                // return;
                currentUser = new Staff(); // Demo data
                currentUser.setFullName("Admin Staff");
            }
        %>

        <div class="d-flex" id="wrapper">

            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="product?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="order?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li><a href="review?action=manageReview"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
                    <li><a href="importproduct?action=staff_import"><i class="bi bi-file-earmark-arrow-up me-2"></i>Import Product</a></li>

                    <li><a href="voucher?action=viewVoucher" class="fw-bold text-primary">
                            <i class="bi bi-ticket-perforated me-2"></i>Voucher
                        </a></li>
                </ul>
            </nav>

            <div class="page-content flex-grow-1">

                <nav class="navbar navbar-light bg-white shadow-sm mb-4">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto">
                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span class="fw-bold"><%= currentUser.getFullName()%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-5">

                    <div class="form-card">
                        <h3 class="fw-bold text-primary border-bottom pb-3 mb-4">Create Voucher</h3>
                        <%                            String error = (String) request.getAttribute("error");
                            if (error != null) {
                        %>
                        <div class="alert alert-danger text-center" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error%>
                        </div>
                        <% }%>
                        <form action="voucher" method="post">
                            <input type="hidden" name="action" value="createVoucher">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Voucher Code</label>
                                    <input type="text" name="code" class="form-control" 
                                           placeholder="e.g. SUMMER2025" 
                                           value="<%= request.getAttribute("code") == null ? "" : request.getAttribute("code")%>" 
                                           required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Discount (%)</label>
                                    <input type="number" name="percentDiscount" class="form-control" placeholder="e.g. 20" min="1" max="100" required>
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
                                    <input type="number" name="quantity" class="form-control" placeholder="e.g. 100" min="1" required>
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
                                <button type="submit" class="btn btn-success flex-grow-1 shadow-sm">
                                    <i class="bi bi-plus-circle me-2"></i>Create Voucher
                                </button>
                                <a href="voucher?action=viewVoucher" class="btn btn-secondary">Back</a>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const today = new Date();
                const year = today.getFullYear();
                const month = String(today.getMonth() + 1).padStart(2, '0');
                const day = String(today.getDate()).padStart(2, '0');

                // Chuỗi ngày hôm nay: yyyy-mm-dd
                const todayString = year + "-" + month + "-" + day;

                const startDayInput = document.querySelector('input[name="startDay"]');
                const endDayInput = document.querySelector('input[name="endDay"]');
                const form = document.querySelector('form');

                // 1. Cấu hình mặc định ban đầu: Ngày bắt đầu tối thiểu là hôm nay
                startDayInput.setAttribute("min", todayString);

                // Nếu đã có ngày bắt đầu, thì ngày kết thúc tối thiểu là ngày bắt đầu đó
                // Nếu chưa, thì tối thiểu là hôm nay
                if (startDayInput.value) {
                    endDayInput.setAttribute("min", startDayInput.value);
                } else {
                    endDayInput.setAttribute("min", todayString);
                }

                // 2. SỰ KIỆN KHI NHẬP LIỆU (Chỉ hỗ trợ, KHÔNG bắt lỗi, KHÔNG xóa giá trị)
                startDayInput.addEventListener("change", function () {
                    // Khi chọn ngày bắt đầu, chỉ cập nhật giới hạn min cho ngày kết thúc
                    // Để user mở lịch lên sẽ không chọn sai được.
                    // Tuyệt đối không alert hay xóa giá trị ở đây để tránh làm phiền user đang nhập.
                    if (this.value) {
                        endDayInput.setAttribute("min", this.value);
                    }
                });

                // 3. SỰ KIỆN SUBMIT (Bấm nút Create mới bắt đầu kiểm tra lỗi)
                form.addEventListener("submit", function (event) {
                    const start = startDayInput.value;
                    const end = endDayInput.value;

                    // Kiểm tra rỗng (dù html có required nhưng vẫn check)
                    if (!start || !end)
                        return;

                    // Logic 1: Ngày bắt đầu không được trong quá khứ
                    // (So sánh chuỗi yyyy-mm-dd hoạt động tốt)
                    if (start < todayString) {
                        alert("Ngày bắt đầu không được nhỏ hơn ngày hiện tại!");
                        event.preventDefault();
                        return;
                    }

                    // Logic 2: Ngày kết thúc phải >= Ngày bắt đầu
                    // Lưu ý: phép so sánh < (nhỏ hơn) sẽ trả về false nếu 2 ngày bằng nhau -> Cho phép trùng ngày
                    if (end < start) {
                        alert("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu!");
                        event.preventDefault();
                        return;
                    }

                    // Nếu mọi thứ ok -> Form tự động gửi đi
                });
            });
        </script>
    </body>
</html>