<%-- 
    Document   : changePassword
    Created on : Oct 16, 2025, 3:50:10 PM
    Author     : Hoa Hong Nhung
--%>

<%@page import="java.util.List"%>
<%@page import="model.Products"%>
<%@page import="model.Category"%>
<%@ page import="model.Users" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>

<%
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = (String) session.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Change Password | MiniStore</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">        
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


        <style>
            body {
                background: #EDF1F3;
                min-height: 100vh;
                font-family: 'Jost', sans-serif;
                margin-top: 120px;
                padding: 20px;
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

            /* Form Styling */
            .profile-form {
                padding: 30px;
            }

            .form-group {
                margin-bottom: 28px;
            }

            .form-label {
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 10px;
                font-size: 0.95rem;
                display: flex;
                align-items: center;
            }

            .form-label i {
                margin-right: 8px;
                color: #667eea;
            }

            .form-control {
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                padding: 14px 18px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: #f7fafc;
            }

            .form-control:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
                background: white;
            }

            /* Alert Styling */
            .alert {
                border-radius: 12px;
                border: none;
                padding: 16px 20px;
                margin-bottom: 25px;
                display: flex;
                align-items: center;
                animation: slideIn 0.3s ease;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .alert i {
                margin-right: 12px;
                font-size: 1.2rem;
            }

            .alert-success {
                background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                color: white;
            }

            .alert-danger {
                background: linear-gradient(135deg, #f56565 0%, #c53030 100%);
                color: white;
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
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }

            .btn-secondary {
                background: #e2e8f0;
                border: none;
                color: #4a5568;
                padding: 14px 32px;
                border-radius: 12px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-secondary:hover {
                background: #cbd5e0;
                color: #2d3748;
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
            }
        </style>
    </head>

    <body>
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
                        <h1>Change Password</h1>
                        <p>Manage your account security</p>
                    </div>

                    <div class="row">
                        <!-- Avatar Section -->
                        <div class="col-lg-4">
                            <div class="avatar-section">
                                <div class="avatar-wrapper">
                                    <img src="images/avatar.png" alt="User Avatar">
                                </div>
                                <h5><%= user.getFullName() %></h5>
                                <span class="user-id">ID: #<%= user.getUserId() %></span>
                            </div>
                        </div>

                        <!-- Form Section -->
                        <div class="col-lg-8">
                            <form id="changePasswordForm" action="user" method="post" class="profile-form">
                                <input type="hidden" name="action" value="changePassword">
                                <% 
                                    
                                %>
                                <% if (message != null) { %>
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i>
                                    <%= message %>
                                </div>
                                <% 
                                    session.removeAttribute("message");
                                %>
                                <% } else if (error != null) { %>
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <%= error %>
                                </div>
                                <% } %>

                                <div class="form-group">
                                    <label for="oldPassword" class="form-label">
                                        <i class="fas fa-lock"></i> Current Password
                                    </label>
                                    <input type="password" class="form-control" name="oldPassword" id="oldPassword" required>
                                    <small id="errorOld" class="text-danger"></small>
                                </div>

                                <div class="form-group">
                                    <label for="newPassword" class="form-label">
                                        <i class="fas fa-key"></i> New Password
                                    </label>
                                    <input type="password" class="form-control" name="newPassword" id="newPassword" required>
                                    <small id="errorNew" class="text-danger"></small>
                                </div>

                                <div class="form-group">
                                    <label for="confirmPassword" class="form-label">
                                        <i class="fas fa-key"></i> Confirm New Password
                                    </label>
                                    <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" required>
                                    <small id="errorConfirm" class="text-danger"></small>
                                </div>

                                <div class="d-flex justify-content-end gap-3">
                                    <a href="user" class="btn btn-secondary"><i class="fas fa-times"></i> Cancel</a>
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Password</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script>
            const oldPassword = document.getElementById("oldPassword");
            const newPassword = document.getElementById("newPassword");
            const confirmPassword = document.getElementById("confirmPassword");

            const errorOld = document.getElementById("errorOld");
            const errorNew = document.getElementById("errorNew");
            const errorConfirm = document.getElementById("errorConfirm");

            oldPassword.addEventListener("input", () => {
                errorOld.textContent = oldPassword.value.trim() === "" ? "Please enter current password" : "";
            });

            newPassword.addEventListener("input", () => {
                const value = newPassword.value;
                const strongRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/;
                errorNew.textContent = value && !strongRegex.test(value)
                        ? "Password must be at least 8 characters, with uppercase, lowercase, and a number."
                        : "";
                if (confirmPassword.value && confirmPassword.value !== value) {
                    errorConfirm.textContent = "Password confirmation does not match.";
                } else {
                    errorConfirm.textContent = "";
                }
            });

            confirmPassword.addEventListener("input", () => {
                errorConfirm.textContent = confirmPassword.value && confirmPassword.value !== newPassword.value
                        ? "Password confirmation does not match."
                        : "";
            });

            document.getElementById("changePasswordForm").addEventListener("submit", (e) => {
                if (errorOld.textContent || errorNew.textContent || errorConfirm.textContent) {
                    e.preventDefault();
                    alert("Please fix errors before submitting.");
                }
            });
        </script>

        <script src="js/jquery-1.11.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
