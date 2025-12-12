<%@page import="model.Customer"%>
<%@page import="model.Users"%>
<%@page import="dto.UserCustomerDTO"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Hồ sơ cá nhân | Phone Store</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="css/profile.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body>

        <%    UserCustomerDTO uC = (UserCustomerDTO) request.getAttribute("customerInfo");


            if (uC == null) {
        %>
        <h2 style="color:red; text-align:center; margin-top:80px;">
            Không tìm thấy thông tin người dùng. Hãy đăng nhập lại.
        </h2>
    </body>
</html>
<%
        return;
    }

    Users u = uC.getUser();
    Customer customer = uC.getCustomer();
%>

<section id="billboard" class="bg-light-blue overflow-hidden padding-large">
    <div class="profile-container">
        <div class="profile-wrapper">

            <!-- SIDEBAR -->
            <aside class="profile-sidebar">
                <h3>Hello, <%= u.getFullName()%></h3>

                <a href="product?action=viewWishlist" class="sidebar-link">
                    <i class="fas fa-heart"></i> <span>My Wishlist</span>
                </a>

                <a href="user?action=transaction" class="sidebar-link">
                    <i class="fas fa-shopping-bag"></i> <span>My Orders</span>
                </a>

                <a href="user?action=payInstallment" class="sidebar-link">
                    <i class="fas fa-receipt"></i> <span>Installment Paying</span>
                </a>

                <a href="user" class="sidebar-link">
                    <i class="fas fa-user"></i> <span>Profile & Address</span>
                </a>

                <a href="user?action=changePassword" class="sidebar-link">
                    <i class="fas fa-lock"></i> <span>Change Password</span>
                </a>

                <form action="logout" method="post">
                    <button type="submit" class="logout-btn">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
                </form>
            </aside>

            <!-- MAIN CONTENT -->
            <main class="profile-content">
                <div class="profile-header">
                    <h1>My Profile</h1>
                    <p>Manage your account information</p>
                </div>

                <div class="row">
                    <!-- Avatar -->
                    <div class="col-lg-4">
                        <div class="avatar-section">
                            <div class="avatar-wrapper">
                                <img src="images/avatar.png" alt="User Avatar">
                            </div>
                            <h5><%= u.getFullName()%></h5>
                            <span class="user-id">ID: #<%= u.getUserId()%></span>
                        </div>
                    </div>

                    <!-- USER INFO -->
                    <div class="col-lg-8">
                        <div class="info-table">
                            <table>
                                <tbody>
                                    <tr>
                                        <th><i class="fas fa-user"></i> Full Name:</th>
                                        <td><%= u.getFullName()%></td>
                                    </tr>

                                    <tr>
                                        <th><i class="fas fa-id-card"></i> CCID:</th>
                                        <td><%= customer.getcCCD() != null ? customer.getcCCD() : "Chưa cập nhật"%></td>
                                    </tr>

                                    <tr>
                                        <th><i class="fas fa-birthday-cake"></i> YOB:</th>
                                        <td><%= customer.getYOB() != null ? customer.getYOB().toLocalDate() : "Chưa cập nhật"%></td>
                                    </tr>

                                    <tr>
                                        <th><i class="fas fa-star"></i> Point:</th>
                                        <td><%= customer.getPoint()%></td>
                                    </tr>

                                    <tr>
                                        <th><i class="fas fa-envelope"></i> Email:</th>
                                        <td><%= u.getEmail()%></td>
                                    </tr>

                                    <tr>
                                        <th><i class="fas fa-phone"></i> Phone Number:</th>
                                        <td><%= u.getPhone() != null ? u.getPhone() : "Chưa cập nhật"%></td>
                                    </tr>

                                    <tr>
                                        <th><i class="fas fa-map-marker-alt"></i> Address:</th>
                                        <td><%= u.getAddress() != null ? u.getAddress() : "Chưa cập nhật"%></td>
                                    </tr>

                                    <tr>
                                        <th><i class="fas fa-calendar"></i> Created Date:</th>
                                        <td><%= u.getCreatedAt() != null ? u.getCreatedAt().toLocalDate() : "Không xác định"%></td>
                                    </tr>

                                    <tr>
                                        <th><i class="fas fa-check-circle"></i> Status:</th>
                                        <td><span style="color:#48bb78; font-weight:600;"><%= u.getStatus()%></span></td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="mt-4 d-flex gap-3">
                                <a href="user?action=edit" class="btn btn-primary">
                                    <i class="fas fa-edit"></i> Edit Profile
                                </a>
                                <a href="logout" class="btn btn-outline-danger">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </div>

                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>
</section>

<script src="js/jquery-1.11.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
