<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi Tiết Phiếu Nhập #${currImport.importID}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/importproduct.css"> </head>
    <body>

        <div class="d-flex-wrapper">

            <div class="sidebar-wrapper">
                <jsp:include page="sidebar.jsp"/> 
            </div>

            <div class="main-content">
                <div class="container-fluid">

                    <div class="mb-3">
                        <a href="admin?action=importproduct" class="text-decoration-none text-secondary fw-bold">
                            <i class="bi bi-arrow-left"></i> Quay lại lịch sử nhập
                        </a>
                    </div>

                    <div class="d-flex justify-content-between align-items-end mb-4 border-bottom pb-3">
                        <div>
                            <h2 class="page-title mb-1 text-primary">
                                <i class="bi bi-receipt-cutoff me-2"></i>Chi Tiết Phiếu Nhập #${currImport.importID}
                            </h2>
                            <div class="text-muted small">
                                Ngày nhập: <span class="fw-bold text-dark me-3"><i class="bi bi-calendar3"></i> ${currImport.formattedDate}</span>
                                Nhà cung cấp: <span class="fw-bold text-dark"><i class="bi bi-shop"></i> ${currImport.supplierName}</span>
                            </div>
                        </div>
                        <div class="text-end">
                            <div class="small text-muted mb-1">Tổng giá trị đơn hàng</div>
                            <h3 class="fw-bold text-danger m-0">
                                <fmt:formatNumber value="${currImport.totalCost}" type="currency" currencySymbol="₫"/>
                            </h3>
                        </div>
                    </div>

                    <div class="card card-custom p-0 overflow-hidden shadow-sm">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0" style="table-layout: fixed;">
                                <thead class="table-light text-secondary small fw-bold">
                                    <tr>
                                        <th class="ps-4" style="width: 5%">STT</th>
                                        <th style="width: 35%">TÊN SẢN PHẨM</th> <th class="text-center" style="width: 15%">PHÂN LOẠI</th>
                                        <th class="text-end" style="width: 15%">GIÁ NHẬP</th>
                                        <th class="text-center" style="width: 10%">SỐ LƯỢNG</th>
                                        <th class="text-end pe-4" style="width: 20%">THÀNH TIỀN</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listDetails}" var="d" varStatus="status">
                                        <tr>
                                            <td class="ps-4 text-muted">${status.index + 1}</td>

                                            <td>
                                                <div class="fw-bold text-dark">${d.productName}</div>
                                                <div class="small text-muted">Mã Variant: #${d.variantID}</div>
                                            </td>

                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border">
                                                    ${d.color}
                                                </span>
                                                <span class="badge bg-light text-dark border ms-1">
                                                    ${d.storage}
                                                </span>
                                            </td>

                                            <td class="text-end">
                                                <fmt:formatNumber value="${d.costPrice}" type="currency" currencySymbol=""/> ₫
                                            </td>

                                            <td class="text-center fw-bold text-primary bg-light">
                                                ${d.quality}
                                            </td>

                                            <td class="text-end fw-bold text-dark pe-4">
                                                <fmt:formatNumber value="${d.costPrice * d.quality}" type="currency" currencySymbol=""/> ₫
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                
                                <tfoot class="table-light">
                                    <tr>
                                        <td colspan="4" class="text-end fw-bold text-secondary">TỔNG CỘNG:</td>
                                        <td class="text-center fw-bold text-primary">
                                            </td>
                                        <td class="text-end fw-bold text-danger pe-4 fs-5">
                                            <fmt:formatNumber value="${currImport.totalCost}" type="currency" currencySymbol="₫"/>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                    <div class="mt-4">
                        <label class="fw-bold text-secondary small">Ghi chú phiếu nhập:</label>
                        <div class="p-3 bg-white border rounded text-muted fst-italic mt-1">
                            ${not empty currImport.note ? currImport.note : "Không có ghi chú."}
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>