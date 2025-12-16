<%-- 
    Document   : warranty
    Created on : Dec 16, 2025, 6:52:26 PM
    Author     : Nhung Hoa
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Warranty" %>

<%@ include file="/layout/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Bảo Hành Của Tôi</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="css/profile.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    </head>

    <body>
        <section id="billboard" class="bg-light-blue overflow-hidden padding-large">
            <div class="profile-container">
                <div class="profile-wrapper">

                    <!-- Sidebar (GIỮ NGUYÊN) -->
                    <aside class="profile-sidebar">
                        <h3>Hello, <%= user.getFullName() %></h3>

                        <a href="product?action=viewWishlist" class="sidebar-link">
                            <i class="fas fa-heart"></i>
                            <span>My Wishlist</span>
                        </a>

                        <a href="user?action=transaction" class="sidebar-link">
                            <i class="fas fa-shopping-bag"></i>
                            <span>My Orders</span>
                        </a>

                        <a href="user?action=payInstallment" class="sidebar-link">
                            <i class="fas fa-receipt"></i>
                            <span>Installment Paying</span>
                        </a>

                        <a href="user" class="sidebar-link">
                            <i class="fas fa-user"></i>
                            <span>Profile & Address</span>
                        </a>

                        <a href="user?action=changePassword" class="sidebar-link">
                            <i class="fas fa-lock"></i>
                            <span>Change Password</span>
                        </a>

                        <!-- 👉 THÊM LINK BẢO HÀNH -->
                        <a href="warranty" class="sidebar-link active">
                            <i class="fas fa-tools"></i>
                            <span>My Warranty</span>
                        </a>

                        <form action="logout" method="post">
                            <button type="submit" class="logout-btn">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </button>
                        </form>
                    </aside>

                    <!-- Main Content -->
                    <main class="profile-content">
                        <div class="profile-header">
                            <h1>Bảo Hành Của Tôi</h1>
                        </div>

                        <%
                            List<Warranty> warranties = (List<Warranty>) request.getAttribute("warranties");
                        %>

                        <div class="table-responsive mt-4">
                            <table class="table table-bordered text-center">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã BH</th>
                                        <th>Variant</th>
                                        <th>Ngày mua</th>
                                        <th>Hết hạn</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (warranties != null && !warranties.isEmpty()) {
                            for (Warranty w : warranties) { %>
                                    <tr>
                                        <td><%= w.getWarrantyID() %></td>
                                        <td><%= w.getVariantID() %></td>
                                        <td><%= w.getSoldDay() %></td>
                                        <td><%= w.getExpiryDate() %></td>
                                        <td>
                                            <span class="badge bg-success">
                                                <%= w.getStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <% if ("active".equalsIgnoreCase(w.getStatus())) { %>
                                            <a href="warranty?action=claim&warrantyID=<%= w.getWarrantyID() %>"
                                               class="btn btn-sm btn-primary">
                                                Gửi bảo hành
                                            </a>
                                            <% } else { %>
                                            <span class="text-muted">Không khả dụng</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td colspan="6" class="text-muted">
                                            Bạn chưa có sản phẩm nào được bảo hành
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </main>
                </div>
            </div>
        </section>
    </body>
</html>
