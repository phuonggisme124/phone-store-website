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
        
        <link rel="stylesheet" href="css/importproduct.css">
        <link rel="stylesheet" href="css/dashboard_admin.css"> <style>
            .d-flex-wrapper {
                display: flex !important;
                width: 100%;
                min-height: 100vh;
                overflow-x: hidden;
            }
            .sidebar {
                width: 250px !important;      /* Fix cứng chiều rộng */
                min-width: 250px !important;  /* Không cho co nhỏ hơn */
                flex-shrink: 0 !important;    /* Không bị nén lại */
                background-color: #fff;
                border-right: 1px solid #dee2e6;
                height: 100vh;                /* Full chiều cao màn hình */
                position: sticky;             /* Giữ cố định khi scroll */
                top: 0;
            }
            .main-content {
                flex-grow: 1 !important;
                width: calc(100% - 250px) !important; /* Chiếm phần còn lại */
                padding: 0;
                overflow-x: auto;
                background-color: #f8f9fa; /* Màu nền nhẹ cho nội dung dễ nhìn */
            }
            
            /* Responsive cho Mobile */
            @media (max-width: 992px) {
                .d-flex-wrapper {
                    flex-direction: column !important;
                }
                .sidebar {
                    width: 100% !important;
                    height: auto !important;
                    position: relative !important;
                }
                .main-content {
                    width: 100% !important;
                }
            }
        </style>
    </head>
    <body>

        <div class="d-flex-wrapper">

            <nav class="sidebar shadow-sm">
                <div class="sidebar-header p-3 border-bottom">
                    <h4 class="fw-bold text-primary m-0">Mantis</h4>
                </div>
                <ul class="list-unstyled p-3">
                    <li class="mb-2"><a href="product?action=manageProduct" class="text-decoration-none text-dark d-block p-2 rounded hover-bg-light"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li class="mb-2"><a href="order?action=manageOrder" class="text-decoration-none text-dark d-block p-2 rounded hover-bg-light"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li class="mb-2"><a href="review?action=manageReview" class="text-decoration-none text-dark d-block p-2 rounded hover-bg-light"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
                    <li class="mb-2"><a href="importproduct?action=staff_import" class="text-decoration-none fw-bold text-primary d-block p-2 rounded bg-light"><i class="bi bi-file-earmark-arrow-down me-2"></i>Import Product</a></li>
                    <li><a href="voucher?action=viewVoucher" class="fw-bold text-primary">
                        <i class="bi bi-ticket-perforated me-2"></i>Voucher
                    </a></li>
                </ul>
            </nav>

            <div class="main-content">
                
                <div class="d-flex align-items-center justify-content-end p-3 bg-white border-bottom mb-4">
                    <div class="me-3">Staff</div> <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                </div>

                <div class="container-fluid px-4">

                    <div class="mb-3">
                        <a href="importproduct?action=staff_import" class="text-decoration-none text-secondary fw-bold small hover-link">
                            <i class="bi bi-arrow-left"></i> Quay lại lịch sử nhập
                        </a>
                    </div>

                    <div class="d-flex justify-content-between align-items-end mb-4 pb-3 border-bottom">
                        <div>
                            <h2 class="page-title mb-1 text-primary fw-bold">
                                <i class="bi bi-receipt-cutoff me-2"></i>Phiếu Nhập #${currImport.importID}
                            </h2>
                            <div class="text-muted">
                                <span class="me-3"><i class="bi bi-calendar3 me-1"></i> ${currImport.formattedDate}</span>
                                <span><i class="bi bi-shop me-1"></i> ${currImport.supplierName}</span>
                            </div>
                        </div>
                        <div class="text-end bg-white p-3 rounded shadow-sm border">
                            <div class="small text-muted mb-1">TỔNG GIÁ TRỊ</div>
                            <h3 class="fw-bold text-danger m-0">
                                <fmt:formatNumber value="${currImport.totalCost}" type="currency" currencySymbol="₫"/>
                            </h3>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden mb-4">
                        <div class="card-header bg-white py-3 fw-bold text-uppercase text-secondary small border-bottom">
                            Danh sách sản phẩm
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light text-secondary small fw-bold">
                                    <tr>
                                        <th class="ps-4" style="width: 5%">#</th>
                                        <th style="width: 40%">SẢN PHẨM</th>
                                        <th class="text-center" style="width: 15%">PHÂN LOẠI</th>
                                        <th class="text-end" style="width: 15%">ĐƠN GIÁ</th>
                                        <th class="text-center" style="width: 10%">SL</th>
                                        <th class="text-end pe-4" style="width: 15%">THÀNH TIỀN</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listDetails}" var="d" varStatus="status">
                                        <tr>
                                            <td class="ps-4 text-muted">${status.index + 1}</td>
                                            <td>
                                                <div class="fw-bold text-dark">${d.productName}</div>
                                                <div class="small text-muted font-monospace">SKU: #${d.variantID}</div>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border">${d.color}</span>
                                                <span class="badge bg-light text-dark border ms-1">${d.storage}</span>
                                            </td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${d.costPrice}" type="currency" currencySymbol=""/> ₫
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-primary bg-opacity-10 text-primary px-3 rounded-pill">${d.quality}</span>
                                            </td>
                                            <td class="text-end fw-bold text-dark pe-4">
                                                <fmt:formatNumber value="${d.costPrice * d.quality}" type="currency" currencySymbol=""/> ₫
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm rounded-3 p-3 bg-light-subtle">
                        <label class="fw-bold text-secondary small mb-2"><i class="bi bi-sticky me-1"></i>Ghi chú phiếu nhập:</label>
                        <div class="fst-italic text-muted">
                            ${not empty currImport.note ? currImport.note : "Không có ghi chú."}
                        </div>
                    </div>
                    
                    <div class="mb-5"></div> </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>