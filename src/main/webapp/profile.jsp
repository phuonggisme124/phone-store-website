<%@page import="java.util.List"%>
<%@page import="model.Products"%>
<%@page import="model.Category"%>
<%@ page import="model.Users" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="layout/header.jsp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Hồ sơ cá nhân | Phone Store</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


    </head>
    <style>
        body {
            background: white;
            min-height: 100vh;
            font-family: 'Jost', sans-serif;
            padding-top: 80px;
        }

        .profile-container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .profile-wrapper {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 30px;
            margin-bottom: 50px;
        }

        /* Sidebar Styling */
        .profile-sidebar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 40px 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            height: fit-content;
            position: sticky;
            top: 100px;
        }

        .profile-sidebar h3 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 35px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e2e8f0;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            margin-bottom: 12px;
            border-radius: 12px;
            text-decoration: none;
            color: #4a5568;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .sidebar-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .sidebar-link:hover {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            color: #667eea;
            transform: translateX(5px);
        }

        .sidebar-link:hover::before {
            transform: scaleY(1);
        }

        .sidebar-link i {
            margin-right: 15px;
            font-size: 1.1rem;
            width: 24px;
            text-align: center;
        }

        .logout-btn {
            background: linear-gradient(135deg, #f56565 0%, #c53030 100%);
            color: white;
            border: none;
            width: 100%;
            padding: 16px;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 25px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(245, 101, 101, 0.3);
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 101, 101, 0.4);
        }

        /* Main Content Styling */
        .profile-content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 50px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
        }

        .profile-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .profile-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .profile-header p {
            color: #718096;
            font-size: 1.1rem;
        }

        /* Avatar Section */
        .avatar-section {
            text-align: center;
            padding: 30px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
            border-radius: 20px;
            margin-bottom: 30px;
        }

        .avatar-wrapper {
            position: relative;
            display: inline-block;
            margin-bottom: 20px;
        }

        .avatar-wrapper img {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            border: 6px solid white;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            object-fit: cover;
        }

        .avatar-wrapper::after {
            content: '';
            position: absolute;
            top: -5px;
            left: -5px;
            right: -5px;
            bottom: -5px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            z-index: -1;
            opacity: 0.3;
        }

        .avatar-section h5 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
        }

        .user-id {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* Info Table Styling */
        .info-table {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .info-table table {
            width: 100%;
            margin-bottom: 0;
        }

        .info-table tr {
            border-bottom: 1px solid #e2e8f0;
        }

        .info-table tr:last-child {
            border-bottom: none;
        }

        .info-table th {
            padding: 16px 0;
            font-weight: 600;
            color: #4a5568;
            width: 35%;
            font-size: 0.95rem;
        }

        .info-table td {
            padding: 16px 0;
            color: #2d3748;
            font-size: 1rem;
        }

        /* Button Styling */
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 14px 32px;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            color: white;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-outline-danger {
            background: transparent;
            border: 2px solid #f56565;
            color: #f56565;
            padding: 14px 32px;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-outline-danger:hover {
            background: #f56565;
            color: white;
            transform: translateY(-2px);
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .profile-wrapper {
                grid-template-columns: 1fr;
            }

            .profile-sidebar {
                position: relative;
                top: 0;
            }

            .profile-content {
                padding: 30px 20px;
            }
        }

        @media (max-width: 576px) {
            .profile-header h1 {
                font-size: 1.8rem;
            }

            .avatar-wrapper img {
                width: 120px;
                height: 120px;
            }

            .sidebar-link {
                padding: 12px 16px;
            }

            .info-table th {
                font-size: 0.85rem;
            }

            .info-table td {
                font-size: 0.9rem;
            }
        }
    </style>
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

                        <a href="user" class="sidebar-link">
                            <i class="fas fa-user"></i>
                            <span>Profile & Address</span>
                        </a>

                        <a href="user?action=changePassword" class="sidebar-link">
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

<<<<<<< HEAD
                                    <div class="mt-4">
                                        <a href="user?action=edit" class="btn btn-primary px-4 me-2">Chỉnh sửa thông tin</a>
=======
                                    <div class="mt-4 d-flex gap-3">
                                        <a href="user?action=edit" class="btn btn-primary">
                                            <i class="fas fa-edit"></i> Edit Profile
                                        </a>
                                        <a href="logout" class="btn btn-outline-danger">
                                            <i class="fas fa-sign-out-alt"></i> Logout
                                        </a>
>>>>>>> a00e84feffbb0886aeae7175af3a19e816cf2043
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