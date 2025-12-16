<%@page import="model.Staff"%>
<%@page import="model.Import"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Import History </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        
        <link rel="stylesheet" href="css/dashboard_staff.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
        
        <style>
            /* CSS bổ sung nhỏ cho các nút hành động tròn */
            .btn-action {
                width: 32px;
                height: 32px;
                padding: 0;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
            }
        </style>
    </head>
    <body>
        <%
            // Kiểm tra đăng nhập
            Staff currentUser = (Staff) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
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
                    
                    <li><a href="importproduct?action=staff_import" class="fw-bold text-primary active-link">
                        <i class="bi bi-clock-history me-2"></i>Import Products
                    </a></li>
                    
                    <li><a href="voucher?action=viewVoucher"><i class="bi bi-ticket-perforated me-2"></i>Voucher</a></li>
                </ul>
            </nav>

            <div class="page-content flex-grow-1">
                
                <nav class="navbar navbar-light bg-white shadow-sm mb-4">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        
                        <div class="d-flex align-items-center ms-auto">
                            <a href="importproduct?action=showImportForm" class="btn btn-sm btn-primary me-3 shadow-sm">
                                <i class="bi bi-plus-lg"></i> Nhập Hàng
                            </a>
                            
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
                            <i class="bi bi-clock-history me-2"></i>Lịch Sử Nhập Kho
                        </h3>
                    </div>

                    <c:if test="${not empty sessionScope.MESS}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.MESS}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% session.removeAttribute("MESS");%>
                    </c:if>

                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 text-center">
                                    <thead class="table-light text-secondary">
                                        <tr>
                                            <th class="py-3">Mã Phiếu</th>
                                            <th class="py-3">Ngày Nhập</th>
                                            <th class="py-3">Nhà Cung Cấp</th>
                                            <th class="py-3">Người Nhập</th>
                                            <th class="py-3">Tổng Tiền</th>
                                            <th class="py-3">Ghi Chú</th>
                                            <th class="py-3">Hành Động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${listImports}" var="i">
                                            <tr>
                                                <td class="fw-bold text-primary">#${i.importID}</td>
                                                <td class="text-secondary small">
                                                    <i class="bi bi-calendar3 me-1"></i>${i.formattedDate}
                                                </td>
                                                <td class="fw-bold text-dark text-truncate" style="max-width: 150px;" title="${i.supplierName}">
                                                    ${i.supplierName}
                                                </td>
                                                <td>
                                                    <span class="badge bg-light text-dark border rounded-pill px-3">
                                                        ${i.staffName}
                                                    </span>
                                                </td>
                                                <td class="fw-bold text-danger">
                                                    <fmt:formatNumber value="${i.totalCost}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                <td>
                                                    <div class="text-muted small text-truncate" style="max-width: 150px;" title="${i.note}">
                                                        ${i.note}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex justify-content-center align-items-center gap-2">
                                                        <a href="importproduct?action=viewDetail&id=${i.importID}" 
                                                           class="btn btn-outline-primary btn-action" 
                                                           title="Xem chi tiết">
                                                            <i class="bi bi-eye"></i>
                                                        </a>

                                                        <c:choose>
                                                            <c:when test="${i.status == 0}">
                                                                <span class="badge bg-warning text-dark border border-warning">Pending</span>
                                                            </c:when>
                                                            <c:when test="${i.status == 1}">
                                                                <span class="badge bg-success bg-opacity-75 border border-success">Success</span>
                                                            </c:when>
                                                            <c:when test="${i.status == 2}">
                                                                <span class="badge bg-danger bg-opacity-75 border border-danger">Cancel</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <c:if test="${empty listImports}">
                                    <div class="p-5 text-center text-muted">
                                        <i class="bi bi-inbox fs-1 opacity-50 mb-3 d-block"></i>
                                        <p class="fw-bold mb-3">Chưa có phiếu nhập hàng nào!</p>
                                        <a href="importproduct?action=showImportForm" class="btn btn-primary rounded-pill px-4">
                                            <i class="bi bi-plus-lg me-1"></i> Tạo phiếu ngay
                                        </a>
                                    </div>
                                </c:if>
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