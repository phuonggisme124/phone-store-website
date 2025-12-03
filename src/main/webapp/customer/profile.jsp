<%@page import="java.util.List"%>
<%@page import="model.Products"%>
<%@page import="model.Category"%>
<%@ page import="model.Users" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Hồ sơ cá nhân | Phone Store</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="css/profile.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


    </head>

    <body>
        <section id="billboard" class="bg-light-blue overflow-hidden padding-large" >
            <div class="profile-container">
                <div class="profile-wrapper">
                    <!-- Sidebar -->
                    <aside class="profile-sidebar">
                        <h3>Hello, <%= user.getFullName()%></h3>

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

                        <a href="<%= request.getContextPath() %>/user?action=changePassword" class="sidebar-link">
                            <i class="fas fa-lock"></i>
                            <span>Change Password</span>
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
                            <h1>My Profile</h1>
                            <p>Manage your account information</p>
                        </div>

                        <div class="row">
                            <!-- Avatar Section -->
                            <div class="col-lg-4">
                                <div class="avatar-section">
                                    <div class="avatar-wrapper">
                                        <img src="images/avatar.png" alt="User Avatar">
                                    </div>
                                    <h5><%= user.getFullName()%></h5>
                                    <span class="user-id">ID: #<%= user.getUserId()%></span>
                                </div>
                            </div>

                            <!-- Info Section -->
                            <div class="col-lg-8">
                                <div class="info-table">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <th><i class="fas fa-user" style="color: #667eea; margin-right: 8px;"></i>Full Name:</th>
                                                <td><%= user.getFullName()%></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-envelope" style="color: #667eea; margin-right: 8px;"></i>Email:</th>
                                                <td><%= user.getEmail()%></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-phone" style="color: #667eea; margin-right: 8px;"></i>Phone Number:</th>
                                                <td><%= user.getPhone() != null ? user.getPhone() : "Chưa cập nhật"%></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-map-marker-alt" style="color: #667eea; margin-right: 8px;"></i>Address:</th>
                                                <td><%= user.getAddress() != null ? user.getAddress() : "Chưa cập nhật"%></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-calendar" style="color: #667eea; margin-right: 8px;"></i>Created Date:</th>
                                                <td><%= user.getCreatedAt() != null ? user.getCreatedAt() : "Không xác định"%></td>
                                            </tr>
                                            <tr>
                                                <th><i class="fas fa-check-circle" style="color: #667eea; margin-right: 8px;"></i>Status:</th>
                                                <td><span style="color: #48bb78; font-weight: 600;"><%= user.getStatus() != null ? user.getStatus() : "Đang hoạt động"%></span></td>
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