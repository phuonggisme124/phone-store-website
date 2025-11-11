<%-- 
    Document   : changePassword
    Created on : Oct 16, 2025, 3:50:10 PM
    Author     : Hoa Hong Nhung
--%>

<%@page import="model.Category"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Users" %>
<%@ include file="/layout/header.jsp" %>

<%
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đổi mật khẩu</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="format-detection" content="telephone=no">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="author" content="">
        <meta name="keywords" content="">
        <meta name="description" content="">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <script src="js/modernizr.js"></script>
        <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
        <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    </head>

    <body>
        <div style="display: flex; background-color: #f3f5f9; min-height: 100vh;">
            <!-- Sidebar -->
            <div style="width: 400px; background-color: #fff; padding: 20px;">
                <h3 style="margin-top: 100px; margin-bottom: 50px; font-size: 1.5rem;">Anh/Chị <%= user.getFullName()%></h3>

                <a href="order" style="display: flex; align-items: center; background-color: #f2f3f5; color: #333; font-weight: 500;
                   border-radius: 8px; padding: 10px 15px; text-decoration: none; margin-bottom: 15px;">
                    <i class="fa fa-shopping-bag" style="margin-right: 10px;"></i> My orders
                </a>

                <a href="user" style="display: flex; align-items: center; background-color: #f2f3f5; color: #333; font-weight: 500;
                   border-radius: 8px; padding: 10px 15px; text-decoration: none; margin-bottom: 15px;">
                    <i class="fa fa-user" style="margin-right: 10px;"></i> Infomation and address
                </a>

                <a href="changePassword.jsp" style="display: flex; align-items: center; background-color: #f2f3f5; color: #333; font-weight: 500;
                   border-radius: 8px; padding: 10px 15px; text-decoration: none; margin-bottom: 25px;">
                    <i class="fa fa-user" style="margin-right: 10px;"></i> Change password
                </a>

                <form action="logout" method="post">
                    <button type="submit" style="background-color: #ff4d4f; color: white; border: none; width: 100%; padding: 10px;
                            border-radius: 8px; font-weight: 500; cursor: pointer;">
                        Đăng Xuất
                    </button>
                </form>
            </div>

            <!-- Main -->
            <div class="container mb-5">
                <div class="row justify-content-center">
                    <div class="col-md-9 p-4" style="background-color: transparent; box-shadow: none; border: none;">
                        <div class="card-body p-5">
                            <section class="py-5">
                                <div class="container text-center">
                                    <h1 class="fw-bold text-uppercase" style="margin-top: 100px;">Đổi mật khẩu</h1>
                                </div>
                            </section>      

                            <div class="col-md-8" style="margin-left: 120px;">
                                <div class="mx-auto">
                                    <form id="changePasswordForm" action="user" method="post">
                                        <input type="hidden" name="action" value="updatePassword">

                                        <div class="mb-2">
                                            <label class="form-label" for="oldPassword">Mật khẩu hiện tại</label>
                                            <input class="form-control" type="password" name="oldPassword" id="oldPassword" required>
                                            <small id="errorOld" class="text-danger"></small>
                                        </div>

                                        <div class="mb-2">
                                            <label class="form-label" for="newPassword">Mật khẩu mới</label>
                                            <input class="form-control" type="password" name="newPassword" id="newPassword" required>
                                            <small id="errorNew" class="text-danger"></small>
                                        </div>

                                        <div class="mb-2">
                                            <label class="form-label" for="confirmPassword">Xác nhận mật khẩu mới</label>
                                            <input class="form-control" type="password" name="confirmPassword" id="confirmPassword" required>
                                            <small id="errorConfirm" class="text-danger"></small>
                                        </div>

                                        <% if (message != null) { %>
                                            <div class="message text-success"><%= message %></div>
                                        <% } %>
                                        <% if (error != null) { %>
                                            <div class="error text-danger"><%= error %></div>
                                        <% } %>

                                        <div class="d-flex justify-content-center">
                                            <button type="submit" class="btn btn-secondary ms-2 px-4">Cập nhật mật khẩu</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
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
                    errorOld.textContent = oldPassword.value.trim() === "" ? "Vui lòng nhập mật khẩu hiện tại" : "";
                });

                newPassword.addEventListener("input", () => {
                    const value = newPassword.value;
                    const strongRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/;
                    if (value === "") {
                        errorNew.textContent = "";
                    } else if (!strongRegex.test(value)) {
                        errorNew.textContent = "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số.";
                    } else {
                        errorNew.textContent = "";
                    }
                    if (confirmPassword.value && confirmPassword.value !== value) {
                        errorConfirm.textContent = "Mật khẩu xác nhận không khớp.";
                    } else {
                        errorConfirm.textContent = "";
                    }
                });

                confirmPassword.addEventListener("input", () => {
                    if (confirmPassword.value === "") {
                        errorConfirm.textContent = "";
                    } else if (confirmPassword.value !== newPassword.value) {
                        errorConfirm.textContent = "Mật khẩu xác nhận không khớp.";
                    } else {
                        errorConfirm.textContent = "";
                    }
                });

                document.getElementById("changePasswordForm").addEventListener("submit", (e) => {
                    if (errorOld.textContent || errorNew.textContent || errorConfirm.textContent) {
                        e.preventDefault();
                        alert("Vui lòng sửa lỗi trước khi gửi biểu mẫu.");
                    }
                });
            </script>
        </div>

        <%-- Footer --%>
        <div class="container padding-xlarge">
            <footer id="footer" class="overflow-hidden">
                <div class="container">
                    <div class="row">
                        <div class="footer-top-area">
                            <div class="row d-flex flex-wrap justify-content-between">
                                <div class="col-lg-3 col-sm-6 pb-3">
                                    <div class="footer-menu">
                                        <img src="images/main-logo.png" alt="logo">
                                        <p>Nisi, purus vitae, ultrices nunc. Sit ac sit suscipit hendrerit. Gravida massa volutpat aenean odio erat nullam fringilla.</p>
                                        <div class="social-links">
                                            <ul class="d-flex list-unstyled">
                                                <li><a href="#"><svg class="facebook"><use xlink:href="#facebook"/></svg></a></li>
                                                <li><a href="#"><svg class="instagram"><use xlink:href="#instagram"/></svg></a></li>
                                                <li><a href="#"><svg class="twitter"><use xlink:href="#twitter"/></svg></a></li>
                                                <li><a href="#"><svg class="linkedin"><use xlink:href="#linkedin"/></svg></a></li>
                                                <li><a href="#"><svg class="youtube"><use xlink:href="#youtube"/></svg></a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-2 col-sm-6 pb-3">
                                    <div class="footer-menu text-uppercase">
                                        <h5 class="widget-title pb-2">Quick Links</h5>
                                        <ul class="menu-list list-unstyled text-uppercase">
                                            <li><a href="#">Home</a></li>
                                            <li><a href="#">About</a></li>
                                            <li><a href="#">Shop</a></li>
                                            <li><a href="#">Blogs</a></li>
                                            <li><a href="#">Contact</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-sm-6 pb-3">
                                    <div class="footer-menu text-uppercase">
                                        <h5 class="widget-title pb-2">Help & Info Help</h5>
                                        <ul class="menu-list list-unstyled">
                                            <li><a href="#">Track Your Order</a></li>
                                            <li><a href="#">Returns Policies</a></li>
                                            <li><a href="#">Shipping + Delivery</a></li>
                                            <li><a href="#">Contact Us</a></li>
                                            <li><a href="#">Faqs</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-sm-6 pb-3">
                                    <div class="footer-menu contact-item">
                                        <h5 class="widget-title text-uppercase pb-2">Contact Us</h5>
                                        <p>Do you have any queries or suggestions? <a href="mailto:">yourinfo@gmail.com</a></p>
                                        <p>If you need support? Just give us a call. <a href="">+55 111 222 333 44</a></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <hr>
            </footer>
        </div>

        <div id="footer-bottom">
            <div class="container">
                <div class="row d-flex flex-wrap justify-content-between">
                    <div class="col-md-4 col-sm-6">
                        <div class="Shipping d-flex">
                            <p>We ship with:</p>
                            <div class="card-wrap ps-2">
                                <img src="images/dhl.png" alt="visa">
                                <img src="images/shippingcard.png" alt="mastercard">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <div class="payment-method d-flex">
                            <p>Payment options:</p>
                            <div class="card-wrap ps-2">
                                <img src="images/visa.jpg" alt="visa">
                                <img src="images/mastercard.jpg" alt="mastercard">
                                <img src="images/paypal.jpg" alt="paypal">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <div class="copyright">
                            <p>© Copyright 2023 MiniStore. Design by <a href="https://templatesjungle.com/">TemplatesJungle</a> Distribution by <a href="https://themewagon.com">ThemeWagon</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="js/jquery-1.11.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/plugins.js"></script>
        <script src="js/script.js"></script>
        <script>
            var swiper = new Swiper(".product-swiper", {
                slidesPerView: 4,
                spaceBetween: 30,
                pagination: { el: ".swiper-pagination", clickable: true },
                breakpoints: {
                    320: { slidesPerView: 1 },
                    768: { slidesPerView: 2 },
                    1024: { slidesPerView: 4 }
                }
            });
        </script>
    </body>
</html>
