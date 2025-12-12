<%@page import="model.Customer"%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>

<%
    Customer customer = (Customer) session.getAttribute("user"); 
    
    if (customer == null) {
%>
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
        <h2 style="color:red; text-align:center; margin-top:80px;">
            Không tìm thấy thông tin người dùng. Hãy đăng nhập lại.
        </h2>
        </body>
        </html>
<%
        return; 
    }
%>

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
        <section id="billboard" class="bg-light-blue overflow-hidden padding-large">
            <div class="profile-container">
                <div class="profile-wrapper">
                    <aside class="profile-sidebar">
                        <h3>Hello, <%= customer.getFullName()%></h3> 

                        <a href="product?action=viewWishlist" class="sidebar-link">
                            <i class="fas fa-heart"></i> <span>My Wishlist</span>
                        </a>

                        <a href="user?action=transaction" class="sidebar-link">
                            <i class="fas fa-shopping-bag"></i> <span>My Orders</span>
                        </a>

                        <a href="user?action=payInstallment" class="sidebar-link">
                            <i class="fas fa-receipt"></i> <span>Installment Paying</span>
                        </a>

                        <a href="customer?action=view" class="sidebar-link active">
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

                    <main class="profile-content">
                        <div class="profile-header">
                            <h1>My Profile</h1>
                            <p>Manage your account information</p>
                        </div>

                        <div class="row">
                            <div class="col-lg-4">
                                <div class="avatar-section">
                                    <div class="avatar-wrapper">
                                        <img src="images/avatar.png" alt="User Avatar">
                                    </div>
                                    <h5><%= customer.getFullName()%></h5>
                                    <span class="user-id">ID: #<%= customer.getCustomerID()%></span> 
                                </div>
                            </div>

                            <div class="col-lg-8">
                                <div class="info-table">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <th><i class="fas fa-user"></i> Full Name:</th>
                                                <td><%= customer.getFullName()%></td>
                                            </tr>

                                            <tr>
                                                <th><i class="fas fa-id-card"></i> CCCD:</th>
                                                <td><%= customer.getCccd() != null ? customer.getCccd() : "Chưa cập nhật"%></td> 
                                            </tr>

                                            <tr>
                                                <th><i class="fas fa-birthday-cake"></i> YOB:</th>
                                                <td><%= customer.getYob() != null ? customer.getYob().toLocalDate() : "Chưa cập nhật"%></td> 
                                            </tr>

                                            <tr>
                                                <th><i class="fas fa-star"></i> Point:</th>
                                                <td><%= customer.getPoint()%></td>
                                            </tr>

                                            <tr>
                                                <th><i class="fas fa-envelope"></i> Email:</th>
                                                <td><%= customer.getEmail()%></td>
                                            </tr>

                                            <tr>
                                                <th><i class="fas fa-phone"></i> Phone Number:</th>
                                                <td><%= customer.getPhone() != null ? customer.getPhone() : "Chưa cập nhật"%></td>
                                            </tr>

                                            <tr>
                                                <th><i class="fas fa-map-marker-alt"></i> Address:</th>
                                                <td><%= customer.getAddress() != null ? customer.getAddress() : "Chưa cập nhật"%></td>
                                            </tr>

                                            <tr>
                                                <th><i class="fas fa-calendar"></i> Created Date:</th>
                                                <td><%= customer.getCreatedAt() != null ? customer.getCreatedAt().toString() : "Không xác định"%></td>
                                            </tr>

                                            <tr>
                                                <th><i class="fas fa-check-circle"></i> Status:</th>
                                                <td><span style="color:#48bb78; font-weight:600;"><%= customer.getStatus()%></span></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="mt-4 d-flex gap-3">
                                        <a href="customer?action=edit" class="btn btn-primary">
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