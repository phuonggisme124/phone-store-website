<<<<<<< HEAD
<%@page import="model.Staff"%> 
<%@page import="model.Import"%>
<%@page import="java.util.List"%>
=======
<%@page import="model.Staff"%>

>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Receipt History - Staff</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<<<<<<< HEAD
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
        <% 
            // 2. SỬA: Lấy Staff từ Session
            Staff currentUser = (Staff) session.getAttribute("user");
            
            // Kiểm tra null để tránh lỗi màn hình
=======
        
        <link rel="stylesheet" href="css/dashboard_admin.css">
        
        <link href="css/dashboard_manageproduct.css" rel="stylesheet">
        <link href="css/dashboard_import.css" rel="stylesheet">
    </head>
    <body>
        <%
            Staff currentUser = (Staff) session.getAttribute("user");
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
<<<<<<< HEAD
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
                            <i class="bi bi-clock-history me-2"></i> Lịch Sử Nhập Kho (Admin View)
                        </h2>

                        <a href="importproduct?action=showImportForm" 
                           class="btn btn-primary fw-bold shadow-sm px-4 btn-import-right">
                            <i class="bi bi-plus-lg me-2"></i> Nhập Hàng Mới
                        </a>
=======
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login");
                return;
            }


        %>



        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->

            <%@ include file="sidebar.jsp"%>


            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">


                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>

                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="position-relative">
                                        <img src="https://i.pravatar.cc/150?u=<%= currentUser.getStaffID()%>" 
                                             class="rounded-circle border border-2 border-white shadow-sm" 
                                             width="40" height="40" alt="Avatar">
                                        <span class="position-absolute bottom-0 start-100 translate-middle p-1 bg-success border border-light rounded-circle">
                                            <span class="visually-hidden">Online</span>
                                        </span>
                                    </div>
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;"><%= currentUser.getFullName()%></span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                    </div>
                                </div>

                                <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" 
                                   style="width: 38px; height: 38px;" title="Logout">
                                    <i class="bi bi-box-arrow-right fs-6"></i>
                                </a>
                            </div>
                        </div>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                    </div>
                </nav>

                <div class="card shadow-sm border-0 p-4 m-3" style="border-radius: 16px;">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center mb-4 ps-2 pe-2">
                            <h2 class="page-title mb-0 fs-3">
                                <i class="bi bi-clock-history me-2"></i> Lịch Sử Nhập Kho
                            </h2>

                        </div>
<<<<<<< HEAD
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
                                        <th>NGƯỜI NHẬP</th> <th>TỔNG TIỀN</th>
                                        <th>GHI CHÚ</th>
                                        <th>HÀNH ĐỘNG</th>
=======

                        <c:if test="${not empty sessionScope.MESS}">
                            <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-4" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.MESS}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <% session.removeAttribute("MESS");%>
                        </c:if>
                        <c:if test="${not empty sessionScope.ERROR}">
                            <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-4" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.ERROR}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <% session.removeAttribute("ERROR");%>
                        </c:if>

                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Mã Phiếu</th>
                                        <th>Ngày Nhập</th>
                                        <th>Nhà Cung Cấp</th>
                                        <th>Tổng Tiền</th>
                                        <th class="text-center">Trạng Thái</th>
                                        <th>Ghi Chú</th>
                                        <th class="text-center" style="min-width: 180px;">Hành Động</th>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listImports}" var="i">
<<<<<<< HEAD
                                        <tr>
                                            <td class="ps-4 fw-bold text-primary">#${i.importID}</td>
                                            <td class="text-secondary small"><i class="bi bi-clock me-1"></i> ${i.formattedDate}</td>
                                            <td class="fw-bold text-dark text-truncate" title="${i.supplierName}" style="max-width: 150px;">${i.supplierName}</td>
                                            
                                            <td>
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 rounded-pill px-3">
                                                    <i class="bi bi-person me-1"></i> ${i.staffName}
                                                </span>
                                            </td>

                                            <td>
                                                <span class="fw-bold text-danger">
                                                    <fmt:formatNumber value="${i.totalCost}" type="currency" currencySymbol="₫"/>
                                                </span>
                                            </td>
                                            <td><div class="text-muted small text-truncate" title="${i.note}" style="max-width: 200px;">${i.note}</div></td>
                                            <td class="text-center">
                                                <div class="d-flex justify-content-center gap-2">
                                                    <a href="importproduct?action=viewDetail&id=${i.importID}" class="btn btn-sm btn-light border hover-shadow rounded-pill px-3" title="Xem chi tiết">
                                                        Xem <i class="bi bi-arrow-right-short"></i>
                                                    </a>
                                                    
                                                    <c:choose>
                                                        <c:when test="${i.status == 0}">
                                                            <a href="admin?action=approve&id=${i.importID}" 
                                                               class="btn btn-sm btn-primary rounded-pill px-3 shadow-sm"
                                                               onclick="return confirm('Bạn có chắc chắn muốn DUYỆT phiếu nhập này?')"
                                                               title="Duyệt">
                                                                <i class="bi bi-check-lg"></i> Duyệt
                                                            </a>
                                                            <a href="admin?action=reject&id=${i.importID}" 
                                                               class="btn btn-sm btn-danger rounded-pill px-3 shadow-sm"
                                                               onclick="return confirm('Bạn có chắc chắn muốn TỪ CHỐI phiếu nhập này?')"
                                                               title="Hủy">
                                                                <i class="bi bi-x-lg"></i> Hủy
                                                            </a>
                                                        </c:when>
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
                                </div>
                            </c:if>
=======
                                    <tr>
                                        <td class="ps-4">
                                            <span class="import-id">#${i.importID}</span>
                                        </td>

                                        <td class="text-secondary fw-semibold small">
                                            <i class="bi bi-calendar3 me-1 text-muted"></i> ${i.formattedDate}
                                        </td>

                                        <td class="fw-bold text-dark text-truncate" style="max-width: 150px;" title="${i.supplierName}">
                                            ${i.supplierName}
                                        </td>

                                        <td>
                                            <span class="total-cost">
                                                <fmt:formatNumber value="${i.totalCost}" type="currency" currencySymbol="₫"/>
                                            </span>
                                        </td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${i.status == 1}">
                                                    <span class="status-badge status-approved">
                                                        <i class="bi bi-check-circle-fill"></i> Đã duyệt
                                                    </span>
                                                </c:when>
                                                <c:when test="${i.status == 2}">
                                                    <span class="status-badge status-rejected">
                                                        <i class="bi bi-x-circle-fill"></i> Đã hủy
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-pending">
                                                        <i class="bi bi-hourglass-split"></i> Chờ duyệt
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <div class="text-muted small text-truncate" style="max-width: 150px;" title="${i.note}">
                                                ${empty i.note ? '<span class="fst-italic text-light-gray">Không có</span>' : i.note}
                                            </div>
                                        </td>

                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="admin?action=viewDetail&id=${i.importID}" 
                                                   class="btn btn-sm btn-action-view rounded-pill px-3 shadow-sm" 
                                                   title="Xem chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>

                                                <c:choose>
                                                    <c:when test="${i.status == 0}">
                                                        <a href="admin?action=approve&id=${i.importID}" 
                                                           class="btn btn-sm btn-action-approve rounded-pill px-3 shadow-sm"
                                                           onclick="return confirm('Bạn có chắc chắn muốn DUYỆT phiếu nhập này?')"
                                                           title="Duyệt">
                                                            <i class="bi bi-check-lg"></i>
                                                        </a>

                                                        <a href="admin?action=reject&id=${i.importID}" 
                                                           class="btn btn-sm btn-action-reject rounded-pill px-3 shadow-sm"
                                                           onclick="return confirm('Bạn có chắc chắn muốn TỪ CHỐI (HỦY) phiếu nhập này?')"
                                                           title="Hủy">
                                                            <i class="bi bi-x-lg"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                        </div>
                        
                        <c:if test="${empty listImports}">
                            <div class="p-5 text-center text-muted">
                                <img src="https://cdn-icons-png.flaticon.com/512/4076/4076432.png" width="80" alt="Empty" class="mb-3 opacity-50">
                                <p class="fw-bold fs-5">Chưa có phiếu nhập hàng nào!</p>
                                <a href="admin?action=showImportForm" class="btn btn-create-now text-white">
                                    <i class="bi bi-plus-lg me-2"></i>Tạo phiếu ngay
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Custom JS -->
        <script>
                                                                   var currentOrderID = null;
                                                                   var myModal = null;

                                                                   window.onload = function () {
                                                                       myModal = new bootstrap.Modal(document.getElementById('shipperModal'));
                                                                   };

                                                                   function openModal(orderID) {
                                                                       currentOrderID = orderID;
                                                                       myModal.show();
                                                                   }

                                                                   function assignShipper(shipperID) {
                                                                       var staffID = '<%= (currentUser != null) ? currentUser.getStaffID(): ""%>';
                                                                       if (!currentOrderID || !shipperID || !staffID) {
                                                                           alert("Missing information!");
                                                                           return;
                                                                       }
                                                                       window.location.href = "staff?action=assignShipper&orderID=" + currentOrderID + "&shipperID=" + shipperID;
                                                                   }

                                                                   // ------------------ Autocomplete ------------------
                                                                   var debounceTimer;
                                                                   function showSuggestions(str) {
                                                                       clearTimeout(debounceTimer);
                                                                       debounceTimer = setTimeout(() => {
                                                                           var box = document.getElementById("suggestionBox");
                                                                           box.innerHTML = "";
                                                                           if (str.length < 1)
                                                                               return;

                                                                           var matches = allPhones.filter(phone => phone.includes(str));
                                                                           if (matches.length > 0) {
                                                                               matches.forEach(phone => {
                                                                                   var item = document.createElement("button");
                                                                                   item.type = "button";
                                                                                   item.className = "list-group-item list-group-item-action";
                                                                                   item.textContent = phone;
                                                                                   item.onclick = function () {
                                                                                       document.getElementById("searchPhone").value = phone;
                                                                                       box.innerHTML = "";
                                                                                       document.getElementById("searchForm").submit();
                                                                                   };
                                                                                   box.appendChild(item);
                                                                               });
                                                                           } else {
                                                                               var item = document.createElement("div");
                                                                               item.className = "list-group-item text-muted small";
                                                                               item.textContent = "No phone numbers found.";
                                                                               box.appendChild(item);
                                                                           }
                                                                       }, 200);
                                                                   }

                                                                   // Ẩn suggestions khi click bên ngoài
                                                                   document.addEventListener('click', function (e) {
                                                                       var searchInput = document.getElementById('searchProduct');
                                                                       var suggestionBox = document.getElementById('suggestionBox');
                                                                       if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
                                                                           suggestionBox.innerHTML = "";
                                                                       }
                                                                   });

        </script>
        <script>
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>

    </body>
</html>