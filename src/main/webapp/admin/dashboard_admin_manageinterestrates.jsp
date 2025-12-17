<%@page import="model.Staff"%>
<%@page import="model.InterestRate"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Interest Rates</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="css/dashboard_admin.css">
        
        <style>
            /* --- CSS Style "Light Purple" Tone --- */
            
            /* 1. Nền & Border tím nhạt */
            .bg-light-purple { background-color: #f5f5f9 !important; color: #697a8d; }
            .border-light-purple { border-color: #d1d9e6 !important; }
            
            /* 2. Nút Gradient chủ đạo */
            .btn-gradient-primary {
                background: linear-gradient(45deg, #696cff, #8592a3);
                border: none;
                color: white;
                transition: all 0.2s;
            }
            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(105, 108, 255, 0.4);
                color: white;
            }

            /* 3. Hiệu ứng bảng */
            .custom-table th {
                font-weight: 600;
                letter-spacing: 0.5px;
                border-bottom: 1px solid #d9dee3;
                padding: 1rem;
            }
            .custom-table td {
                padding: 1rem;
                vertical-align: middle;
            }
            .transition-hover { transition: all 0.2s ease; }
            .transition-hover:hover {
                background-color: white !important;
                transform: scale(1.01);
                box-shadow: 0 0.25rem 1rem rgba(161, 172, 184, 0.4);
                z-index: 1;
                position: relative;
            }

            /* 4. Badges & Icons riêng cho Interest Rate */
            .period-badge {
                background-color: rgba(105, 108, 255, 0.1);
                color: #696cff;
                font-weight: bold;
                padding: 0.5em 0.8em;
                border-radius: 6px;
            }
            .interest-value {
                font-size: 1.1rem;
                font-weight: 700;
                color: #2e3a59;
            }
            .expired-value {
                color: #ff3e1d;
                font-weight: 600;
            }
            
            /* Avatar/Icon đại diện */
            .icon-box {
                width: 40px; height: 40px;
                display: flex; align-items: center; justify-content: center;
                border-radius: 50%;
                font-size: 1.2rem;
            }
        </style>
    </head>
    <body>
        <%
            // 1. Auth Check (Giữ nguyên logic bảo mật)
            Staff currentUser = (Staff) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login");
                return;
            }

            // 2. Lấy dữ liệu
            List<InterestRate> listInterestRate = (List<InterestRate>) request.getAttribute("listInterestRate");
            if (listInterestRate == null) listInterestRate = new ArrayList<>();
        %>

        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>
                        
                        <div class="d-flex align-items-center ms-auto gap-3">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://i.pravatar.cc/150?u=<%= currentUser.getStaffID()%>" class="rounded-circle border shadow-sm" width="40" height="40" alt="Avatar">
                                <div class="d-none d-md-block lh-1">
                                    <span class="d-block fw-bold text-dark small"><%= currentUser.getFullName()%></span>
                                    <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4">
                    
                    <% 
                        String successMsg = (String) session.getAttribute("successMessage");
                        if (successMsg != null) { 
                    %>
                    <div class="alert alert-success alert-dismissible fade show w-50 mx-auto" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i><%= successMsg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("successMessage"); } %>

                    <div class="card shadow-sm border-0 rounded-4 overflow-hidden">
                        <div class="card-header bg-white border-0 p-4 d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="fw-bold text-dark mb-1">Interest Rates</h4>
                                <p class="text-muted small mb-0">Configuration for installment periods & fees</p>
                            </div>
                            <a class="btn btn-gradient-primary px-4 py-2 rounded-pill shadow-sm d-flex align-items-center gap-2" href="interestrates?action=create">
                                <i class="bi bi-plus-lg"></i> 
                                <span>Add New Rate</span>
                            </a>
                        </div>

                        <div class="card-body p-0">
                            <% if (listInterestRate != null && !listInterestRate.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 custom-table">
                                    <thead class="bg-light-purple text-uppercase small fw-bold text-muted">
                                        <tr>
                                            <th class="ps-4">ID</th>
                                            <th>Period</th>
                                            <th>Interest Rate</th>
                                            <th>Penalty (Expired)</th>
                                            
                                        </tr>
                                    </thead>
                                    <tbody class="border-top-0">
                                        <% for (InterestRate ir : listInterestRate) { %>
                                        <tr onclick="window.location.href='interestrates?action=edit&id=<%= ir.getInterestRateID() %>'" 
                                            class="cursor-pointer transition-hover">
                                            
                                            <td class="ps-4 text-muted fw-bold">#<%= ir.getInterestRateID() %></td>

                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="icon-box bg-light-purple text-primary">
                                                        <i class="bi bi-calendar4-week"></i>
                                                    </div>
                                                    <div>
                                                        <span class="period-badge">
                                                            <%= ir.getInstalmentPeriod() %> Months
                                                        </span>
                                                        <div class="small text-muted mt-1">Installment Cycle</div>
                                                    </div>
                                                </div>
                                            </td>

                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-graph-up-arrow text-success"></i>
                                                    <span class="interest-value"><%= ir.getPercent() %>%</span>
                                                </div>
                                                <span class="small text-muted">Per Term</span>
                                            </td>

                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-exclamation-triangle-fill text-warning"></i>
                                                    <span class="expired-value"><%= ir.getPercentExpried() %>%</span>
                                                </div>
                                                <span class="small text-muted">Overdue Fee</span>
                                            </td>

                                            
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } else { %>
                            <div class="text-center p-5">
                                <div class="mb-3">
                                    <i class="bi bi-percent text-muted" style="font-size: 3rem; opacity: 0.5;"></i>
                                </div>
                                <h5 class="text-muted">No Interest Rates Found</h5>
                                <p class="text-secondary small">Set up the first installment period.</p>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Toggle Menu Script
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
            
            // Auto hide alert
            setTimeout(() => {
                const alert = document.querySelector('.alert');
                if (alert) {
                    alert.classList.remove('show');
                    alert.classList.add('fade');
                    setTimeout(() => alert.remove(), 500);
                }
            }, 3000);
        </script>
    </body>
</html>