<%-- 
    Document   : forgotPassword
    Created on : Nov 10, 2025, 10:25:04 PM
    Author     : Nhung Hoa
--%>

<%--<%@page import="java.util.List"%>
<%@page import="model.Category"%>

<%@page import="model.Customer"%>--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>
<%
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Quên mật khẩu | Phone Store</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
     
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="css/profile.css">
           <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body>
        <section id="billboard" class="bg-light-blue overflow-hidden padding-large">
            <div class="profile-container">
       
                    <!-- Main Content -->
                    <main class="profile-content">
                        <div class="profile-header">
                            <h1>Quên mật khẩu</h1>
                            <p>Nhập email và số điện thoại để đặt lại mật khẩu.</p>
                        </div>

                        <div class="row justify-content-center">
                            <div class="col-lg-6">
                                <div class="card p-4 shadow-sm">
                                    <form action="${pageContext.request.contextPath}/forgotPassword" method="post" onsubmit="return validateForm()">
                                        <div class="mb-3">
                                            <label>Email:</label>
                                            <input type="email" id="emailOrPhone" name="email" class="form-control" required>
                                            <small id="errorEmailPhone" class="text-danger"></small>
                                        </div>
                                        <div class="mb-3">
                                            <label>Số điện thoại:</label>
                                            <input type="text" name="phone" class="form-control" required>
                                        </div>
                                        <div class="mb-3">
                                            <label>Mật khẩu mới:</label>
                                            <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                                            <small id="errorNewPass" class="text-danger"></small>
                                        </div>
                                        <div class="mb-3">
                                            <label>Xác nhận mật khẩu:</label>
                                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                                            <small id="errorConfirmPass" class="text-danger"></small>
                                        </div>

                                        <% if (message != null) { %>
                                        <div class="text-success mb-3"><%= message %></div>
                                        <% } %>
                                        <% if (error != null) { %>
                                        <div class="text-danger mb-3"><%= error %></div>
                                        <% } %>

                                        <button type="submit" class="btn btn-primary w-100">Cập nhật mật khẩu</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </main>

                </div>
            
        </section>

        <script>
            function validateForm() {
                let emailOrPhone = document.getElementById("emailOrPhone").value.trim();
                let newPassword = document.getElementById("newPassword").value;
                let confirmPassword = document.getElementById("confirmPassword").value;

                let errorEmailPhone = document.getElementById("errorEmailPhone");
                let errorNewPass = document.getElementById("errorNewPass");
                let errorConfirmPass = document.getElementById("errorConfirmPass");

                let hasError = false;
                errorEmailPhone.textContent = "";
                errorNewPass.textContent = "";
                errorConfirmPass.textContent = "";

                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                const phoneRegex = /^\d{9,12}$/;
                if (!emailRegex.test(emailOrPhone) && !phoneRegex.test(emailOrPhone)) {
                    errorEmailPhone.textContent = "Email hoặc SĐT không hợp lệ!";
                    hasError = true;
                }

                const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
                if (!strongRegex.test(newPassword)) {
                    errorNewPass.textContent = "Mật khẩu phải ≥8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt!";
                    hasError = true;
                }

                if (newPassword !== confirmPassword) {
                    errorConfirmPass.textContent = "Xác nhận mật khẩu không trùng khớp!";
                    hasError = true;
                }

                return !hasError;
            }
        </script>

        <script src="js/jquery-1.11.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
