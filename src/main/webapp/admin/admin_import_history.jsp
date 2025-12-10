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
                    </div>

                    <c:if test="${not empty sessionScope.MESS}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.MESS}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% session.removeAttribute("MESS");%>
                    </c:if>

                    <c:if test="${not empty sessionScope.ERROR}">
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.ERROR}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% session.removeAttribute("ERROR");%>
                    </c:if>

                    <div class="card card-custom p-0 overflow-hidden">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 border-light">
                                <thead class="table-light fw-bold text-secondary small">
                                    <tr>
                                        <th class="ps-4">MÃ PHIẾU</th>
                                        <th>NGÀY NHẬP</th>
                                        <th>NHÀ CUNG CẤP</th>
                                        <th>TỔNG TIỀN</th>
                                        <th class="text-center">TRẠNG THÁI</th>
                                        <th>GHI CHÚ</th>
                                        <th class="text-center" style="min-width: 180px;">HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listImports}" var="i">
                                        <tr>
                                            <td class="ps-4 fw-bold text-primary">#${i.importID}</td>

                                            <td class="text-secondary small">
                                                <i class="bi bi-clock me-1"></i> ${i.formattedDate}
                                            </td>

                                            <td class="fw-bold text-dark text-truncate" style="max-width: 150px;" title="${i.supplierName}">
                                                ${i.supplierName}
                                            </td>

                                            <td class="fw-bold text-danger">
                                                <fmt:formatNumber value="${i.totalCost}" type="currency" currencySymbol="₫"/>
                                            </td>

                                            <td class="text-center">
                                                <c:choose>
                                                    <%-- Status 1: Đã duyệt (Xanh) --%>
                                                    <c:when test="${i.status == 1}">
                                                        <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 rounded-pill">
                                                            <i class="bi bi-check-circle-fill"></i> Đã duyệt
                                                        </span>
                                                    </c:when>
                                                    <%-- Status 2: Đã hủy (Đỏ) --%>
                                                    <c:when test="${i.status == 2}">
                                                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 rounded-pill">
                                                            <i class="bi bi-x-circle-fill"></i> Đã hủy
                                                        </span>
                                                    </c:when>
                                                    <%-- Còn lại (0): Chờ duyệt (Vàng) --%>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 rounded-pill">
                                                            <i class="bi bi-hourglass-split"></i> Chờ duyệt
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <div class="text-muted small text-truncate" style="max-width: 150px;" title="${i.note}">
                                                    ${i.note}
                                                </div>
                                            </td>

                                            <td class="text-center">
                                                <div class="d-flex justify-content-center gap-2">

                                                    <a href="admin?action=viewDetail&id=${i.importID}" 
                                                       class="btn btn-sm btn-light border hover-shadow rounded-pill px-3" 
                                                       title="Xem chi tiết">
                                                        <i class="bi bi-eye"></i> Xem
                                                    </a>

                                                    <c:choose>
                                                        <%-- Nếu đang Chờ duyệt (0): Hiện nút Duyệt và Từ chối --%>
                                                        <c:when test="${i.status == 0}">
                                                            <a href="admin?action=approve&id=${i.importID}" 
                                                               class="btn btn-sm btn-primary rounded-pill px-3 shadow-sm"
                                                               onclick="return confirm('Bạn có chắc chắn muốn DUYỆT phiếu nhập này? Kho hàng và giá bán sẽ được cập nhật ngay lập tức.')"
                                                               title="Xác nhận nhập kho">
                                                                <i class="bi bi-check-lg"></i> Duyệt
                                                            </a>

                                                            <a href="admin?action=reject&id=${i.importID}" 
                                                               class="btn btn-sm btn-danger rounded-pill px-3 shadow-sm"
                                                               onclick="return confirm('Bạn có chắc chắn muốn TỪ CHỐI (HỦY) phiếu nhập này?')"
                                                               title="Hủy phiếu nhập">
                                                                <i class="bi bi-x-lg"></i> Hủy
                                                            </a>
                                                        </c:when>

                                                        <%-- Nếu đã xử lý xong: Hiện badge nhỏ để biết trạng thái --%>
                                                        <c:when test="${i.status == 1}">
                                                            <span class="badge bg-light text-success border border-success px-2 py-2 rounded-pill"><i class="bi bi-check2-all"></i> Xong</span>
                                                        </c:when>
                                                        <c:when test="${i.status == 2}">
                                                            <span class="badge bg-light text-danger border border-danger px-2 py-2 rounded-pill"><i class="bi bi-slash-circle"></i> Đã hủy</span>
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
                                    <img src="https://cdn-icons-png.flaticon.com/512/4076/4076432.png" width="60" alt="Empty" class="mb-3 opacity-50">
                                    <p class="fw-bold">Chưa có phiếu nhập hàng nào!</p>
                                    <a href="admin?action=showImportForm" class="btn btn-sm btn-primary">Tạo phiếu ngay</a>
                                </div>
                            </c:if>
                        </div>
                    </div> 
                </div>
            </div> 
        </div> 
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>