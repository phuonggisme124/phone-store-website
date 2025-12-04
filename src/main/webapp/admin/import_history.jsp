<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Lịch Sử Nhập Kho - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/importproduct.css">
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
 
    </head>
    <body>

        <div class="d-flex-wrapper">

            <div class="sidebar-wrapper">
                <jsp:include page="sidebar.jsp"/> 
            </div>

            <div class="main-content">
                <div class="container-fluid">

                    <div class="d-flex justify-content-center align-items-center position-relative mb-4">
                        <h2 class="page-title mb-0">
                            <i class="bi bi-clock-history me-2"></i> Lịch Sử Nhập Kho
                        </h2>
                        <a href="admin?action=showImportForm" class="btn btn-primary fw-bold shadow-sm px-4 position-absolute end-0">
                            <i class="bi bi-plus-lg me-2"></i> Nhập Hàng Mới
                        </a>
                    </div>

                    <c:if test="${not empty sessionScope.MESS}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.MESS}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% session.removeAttribute("MESS");%>
                    </c:if>

                    <div class="card card-custom p-0 overflow-hidden">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 border-light">
                                <thead class="table-light fw-bold text-secondary small">
                                    <tr>
                                        <th class="ps-4" style="width: 10%">MÃ PHIẾU</th>
                                        <th style="width: 15%">NGÀY NHẬP</th>
                                        <th style="width: 20%">NHÀ CUNG CẤP</th>
                                        <th style="width: 10%">NGƯỜI NHẬP</th>
                                        <th class="text-end" style="width: 15%">TỔNG TIỀN</th>
                                        <th style="width: 20%">GHI CHÚ</th>
                                        <th class="text-center" style="width: 10%">HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listImports}" var="i">
                                        <tr>
                                            <td class="ps-4 fw-bold text-primary">
                                                #${i.importID}
                                            </td>

                                            <td class="text-secondary small">
                                                <i class="bi bi-clock me-1"></i> ${i.formattedDate}
                                            </td>

                                            <td class="fw-bold text-dark text-truncate" title="${i.supplierName}">
                                                ${i.supplierName}
                                            </td>

                                            <td>
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 rounded-pill px-3">
                                                    Admin
                                                </span>
                                            </td> 

                                            <td class="text-end fw-bold text-danger">
                                                <fmt:formatNumber value="${i.totalCost}" type="currency" currencySymbol="₫"/>
                                            </td>

                                            <td>
                                                <div class="text-muted small text-truncate" title="${i.note}">
                                                    ${i.note}
                                                </div>
                                            </td>

                                            <td class="text-center">
                                                <a href="admin?action=viewDetail&id=${i.importID}" class="btn btn-sm btn-light border hover-shadow rounded-pill px-3" title="Xem chi tiết">
                                                    Xem <i class="bi bi-arrow-right-short"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <c:if test="${empty listImports}">
                                <div class="p-5 text-center text-muted">
                                    <img src="https://cdn-icons-png.flaticon.com/512/4076/4076432.png" width="60" alt="Empty" class="mb-3 opacity-50">
                                    <p class="fw-bold">Chưa có phiếu nhập hàng nào!</p>
                                    <a href="admin?action=showImportForm" class="btn btn-sm btn-primary">Tạo phiếu ngay</a>
                                </div>
                            </c:if>
                        </div>
                    </div> </div>
            </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>