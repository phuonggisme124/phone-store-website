<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.List"%>
<%@page import="model.Vouchers"%>
<%@page import="model.Staff"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Voucher Management</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        
        <link rel="stylesheet" href="css/dashboard_staff.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
    </head>
    <body>
        
        <%
            // Kiểm tra đăng nhập (để lấy tên hiển thị trên Navbar)
            Staff currentUser = (Staff) session.getAttribute("user");
            if (currentUser == null) {
                // Nếu chưa đăng nhập thì redirect hoặc xử lý tùy logic của bạn
                // response.sendRedirect("login.jsp");
                // return;
                
                // Demo data để không bị lỗi nếu test trực tiếp
                currentUser = new Staff();
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

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold text-primary mb-0">
                            <i class="bi bi-ticket-perforated me-2"></i>Voucher List
                        </h3>
                        <a href="voucher?action=createVoucher" class="btn btn-primary shadow-sm">
                            <i class="bi bi-plus-lg me-1"></i> Create Voucher
                        </a>
                    </div>

                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 text-center">
                                    <thead class="table-light text-secondary">
                                        <tr>
                                            <th class="py-3">ID</th>
                                            <th class="py-3">Code</th>
                                            <th class="py-3">Discount</th>
                                            <th class="py-3">Start Day</th>
                                            <th class="py-3">End Day</th>
                                            <th class="py-3">Quantity</th>
                                            <th class="py-3">Status</th>
                                            <th class="py-3" width="150">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<Vouchers> list = (List<Vouchers>) request.getAttribute("listVouchers");
                                            if (list != null && !list.isEmpty()) {
                                                for (Vouchers v : list) {
                                        %>
                                        <tr>
                                            <td class="fw-bold text-muted">#<%= v.getVoucherID()%></td>
                                            <td class="fw-bold text-primary"><%= v.getCode()%></td>
                                            <td>
                                                <span class="badge bg-info text-dark bg-opacity-25 border border-info px-3">
                                                    <%= v.getPercentDiscount()%>%
                                                </span>
                                            </td>
                                            <td><%= v.getStartDay()%></td>
                                            <td><%= v.getEndDay()%></td>
                                            <td><%= v.getQuantity()%></td>
                                            <td>
                                                <% if ("Active".equalsIgnoreCase(v.getStatus())) { %>
                                                    <span class="badge bg-success bg-opacity-75 border border-success">Active</span>
                                                <% } else { %>
                                                    <span class="badge bg-secondary bg-opacity-75 border border-secondary">Expired</span>
                                                <% }%>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-center gap-2">
                                                    <a href="voucher?action=updateVoucher&id=<%=v.getVoucherID()%>" 
                                                       class="btn btn-outline-warning btn-sm border-0" title="Edit">
                                                        <i class="bi bi-pencil-square fs-5"></i>
                                                    </a>

                                                    <a href="voucher?action=deleteVoucher&id=<%=v.getVoucherID()%>" 
                                                       class="btn btn-outline-danger btn-sm border-0"
                                                       onclick="return confirm('Are you sure you want to delete voucher: <%= v.getCode()%>?')" 
                                                       title="Delete">
                                                        <i class="bi bi-trash fs-5"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="8" class="text-center py-5 text-muted">
                                                <i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>
                                                No vouchers found.
                                            </td>
                                        </tr>
                                        <% }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
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
    </body>
</html>