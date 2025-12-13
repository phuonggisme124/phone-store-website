<%@page import="model.Staff"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Lịch Sử Nhập Kho - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        
        <link rel="stylesheet" href="css/dashboard_admin.css">
        
        <link href="css/dashboard_manageproduct.css" rel="stylesheet">
        <link href="css/dashboard_import.css" rel="stylesheet">
    </head>
    <body>
        <%
            Staff currentUser = (Staff) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
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
                    </div>
                </nav>

                <div class="card shadow-sm border-0 p-4 m-3" style="border-radius: 16px;">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center mb-4 ps-2 pe-2">
                            <h2 class="page-title mb-0 fs-3">
                                <i class="bi bi-clock-history me-2"></i> Lịch Sử Nhập Kho
                            </h2>

                        </div>

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
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listImports}" var="i">
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