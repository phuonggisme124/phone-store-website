<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="model.Vouchers"%>
<%@page import="model.Staff"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Voucher</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        
        <link rel="stylesheet" href="css/dashboard_staff.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
        
        <style>
            /* CSS riêng cho form */
            .form-card {
                background-color: #fff;
                padding: 30px;
                border-radius: 16px; /* Bo góc tròn hơn giống Product */
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                max-width: 800px;
                margin: 0 auto;
                border: none;
            }
        </style>
    </head>
    <body>

        <%
            // Lấy dữ liệu Voucher & Staff
            Staff currentUser = (Staff) session.getAttribute("user");
            if (currentUser == null) {
                // response.sendRedirect("login.jsp");
                // return;
                currentUser = new Staff(); // Demo data
                currentUser.setFullName("Admin Staff");
            }

            Vouchers v = (Vouchers) request.getAttribute("voucher");
            if (v == null) {
                response.sendRedirect("voucher?action=viewVoucher");
                return;
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
                        <h3 class="fw-bold text-primary border-bottom pb-3 mb-4">Edit Voucher</h3>

                        <form action="voucher" method="post">

                            <input type="hidden" name="action" value="updateVoucher">
                            <input type="hidden" name="id" value="<%= v.getVoucherID()%>">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Voucher Code</label>
                                    <input type="text" name="code" class="form-control" 
                                           value="<%= v.getCode()%>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Discount (%)</label>
                                    <input type="number" name="percentDiscount" class="form-control" 
                                           value="<%= v.getPercentDiscount()%>" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Start Day</label>
                                    <input type="date" name="startDay" class="form-control" 
                                           value="<%= v.getStartDay()%>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">End Day</label>
                                    <input type="date" name="endDay" class="form-control" 
                                           value="<%= v.getEndDay()%>" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Quantity</label>
                                    <input type="number" name="quantity" class="form-control" 
                                           value="<%= v.getQuantity()%>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Status</label>
                                    <select name="status" class="form-select">
                                        <option value="Active" <%= "Active".equals(v.getStatus()) ? "selected" : ""%>>Active</option>
                                        <option value="Expired" <%= "Expired".equals(v.getStatus()) ? "selected" : ""%>>Expired</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mt-4 d-flex gap-2">
                                <button type="submit" class="btn btn-primary flex-grow-1 shadow-sm">
                                    <i class="bi bi-save me-2"></i>Update Voucher
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
</html>