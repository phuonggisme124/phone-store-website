<<<<<<< HEAD
<%@page import="model.Staff"%> <%@page import="model.Import"%>
<%@page import="java.util.List"%>
=======
<%@page import="dao.StaffDAO"%>
<%@page import="model.Staff"%>

>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Receipt History - Staff</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="css/staff_importproduct.css" rel="stylesheet">

        <style>
            /* CSS Giao diện cũ */
            .d-flex-wrapper {
                display: flex !important;
                width: 100%;
                min-height: 100vh;
                overflow-x: hidden;
            }
            .sidebar {
                width: 250px !important;
                min-width: 250px !important;
                flex-shrink: 0 !important;
                background-color: #fff;
                border-right: 1px solid #dee2e6;
            }
            .main-content {
                flex-grow: 1 !important;
                width: calc(100% - 250px) !important;
                padding: 0;
                overflow-x: auto;
            }
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
<<<<<<< HEAD
        <% 
            // 2. SỬA: Lấy Staff từ Session
            Staff currentUser = (Staff) session.getAttribute("user");
            
            // Kiểm tra null để tránh lỗi màn hình
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
=======
        <% Staff currentUser = (Staff) session.getAttribute("user");
            StaffDAO udao = new StaffDAO();
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
        %>

        <div class="d-flex align-items-center" style="position: absolute; top: 15px; right: 20px; z-index: 1000;">
            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
            <div class="d-flex align-items-center ms-3">
                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                <span class="fw-bold text-dark"><%= currentUser.getFullName() %></span>
            </div>
        </div>

        <div class="d-flex-wrapper">
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li><a href="product?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="order?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li><a href="review?action=manageReview"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
                    <li><a href="importproduct?action=staff_import" class="fw-bold text-primary"><i class="bi bi-chat-left-text me-2"></i>importProduct</a></li>
                </ul>
            </nav>

            <div class="main-content">
                <div class="container-fluid p-4" style="padding-top: 50px !important;"> 

                    <div class="header-actions-container">
                        <h2 class="page-title mb-0">
                            <i class="bi bi-clock-history me-2"></i> Lịch Sử Nhập Kho
                        </h2>

                        <a href="importproduct?action=showImportForm" 
                           class="btn btn-primary fw-bold shadow-sm px-4 btn-import-right">
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

                    <div class="card card-custom p-0 overflow-hidden shadow-sm"> 
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 border-light">
                                <thead class="table-light">
                                    <tr>
                                        <th>MÃ PHIẾU</th>
                                        <th>NGÀY NHẬP</th>
                                        <th>NHÀ CUNG CẤP</th>
                                        <th>NGƯỜI NHẬP</th>
                                        <th>TỔNG TIỀN</th>
                                        <th>GHI CHÚ</th>
                                        <th>HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listImports}" var="i">
                                        <tr>
                                            <td class="ps-4 fw-bold text-primary">#${i.importID}</td>
                                            <td class="text-secondary small"><i class="bi bi-clock me-1"></i> ${i.formattedDate}</td>
                                            <td class="fw-bold text-dark text-truncate" title="${i.supplierName}" style="max-width: 150px;">${i.supplierName}</td>
                                            <td><span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 rounded-pill px-3">  ${i.staffName}  </span></td>
                                            <td>
                                                <span class="fw-bold text-danger">
                                                    <fmt:formatNumber value="${i.totalCost}" type="currency" currencySymbol="₫"/>
                                                </span>
                                            </td>
                                            <td><div class="text-muted small text-truncate" title="${i.note}" style="max-width: 200px;">${i.note}</div></td>
                                            <td class="text-center">
                                                <a href="importproduct?action=viewDetail&id=${i.importID}" class="btn btn-sm btn-light border hover-shadow rounded-pill px-3" title="Xem chi tiết">
                                                    Xem <i class="bi bi-arrow-right-short"></i>
                                                </a>
                                                <c:choose>
                                                    <c:when test="${i.status == 0}">
                                                        <span class="badge bg-warning text-dark ms-1">Pending</span>
                                                    </c:when>
                                                    <c:when test="${i.status == 1}">
                                                        <span class="badge bg-success ms-1">Successful</span>
                                                    </c:when>
                                                    <c:when test="${i.status == 2}">
                                                        <span class="badge bg-danger ms-1">Cancel</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <c:if test="${empty listImports}">
                                <div class="p-5 text-center text-muted">
                                    <img src="https://cdn-icons-png.flaticon.com/512/4076/4076432.png" width="60" alt="Empty" class="mb-3 opacity-50">
                                    <p class="fw-bold">Chưa có phiếu nhập hàng nào!</p>
                                    <a href="importproduct?action=showImportForm" class="btn btn-sm btn-primary">Tạo phiếu ngay</a>
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


