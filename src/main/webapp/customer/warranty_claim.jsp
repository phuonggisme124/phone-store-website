<%-- 
    Document   : claim
    Created on : Dec 16, 2025, 7:12:14 PM
    Author     : Nhung Hoa
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Warranty" %>
<%@ page import="java.util.List" %>
<%@ include file="/layout/header.jsp" %>

<%
    Warranty w = (Warranty) request.getAttribute("warranty"); // warranty được chọn để claim
%>
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
                            <h1>Gửi Yêu Cầu Bảo Hành</h1>
                        </div>

                        <% if (w != null) { %>
                        <div class="table-responsive mt-4">
                            <table class="table table-bordered text-center">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã BH</th>
                                        <th>Mã Đơn</th>
                                        <th>Sản phẩm</th>
                                        <th>Ngày mua</th>
                                        <th>Hết hạn</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><%= w.getWarrantyID() %></td>
                                        <td><%= w.getOrderID() %></td>
                                        <td><%= w.getProductName() != null ? w.getProductName() : "Variant " + w.getVariantID() %></td>
                                        <td><%= w.getSoldDay() %></td>
                                        <td><%= w.getExpiryDate() %></td>
                                        <td>
                                            <span class="badge <%= "active".equalsIgnoreCase(w.getStatus()) ? "bg-success" : "bg-secondary" %>">
                                                <%= w.getStatus() %>
                                            </span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Form gửi yêu cầu -->
                        <div class="mt-4">
                            <form action="warranty?action=submitClaim" method="post">
                                <input type="hidden" name="warrantyID" value="<%= w.getWarrantyID() %>">
                                <div class="mb-3">
                                    <label for="reason" class="form-label">Lý do bảo hành</label>
                                    <textarea class="form-control" id="reason" name="reason" rows="4" required></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">Gửi yêu cầu</button>
                            </form>
                        </div>
                        <% } else { %>
                        <p class="text-danger">Không tìm thấy thông tin bảo hành.</p>
                        <% } %>

                    </main>
                </div>
            </div>
        </section>
    </body>
</html>