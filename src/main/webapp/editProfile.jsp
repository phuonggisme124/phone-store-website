
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
        <!-- Swiper CSS -->
        <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />

        <!-- Swiper JS -->
        <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    </head>

    <body data-bs-spy="scroll" data-bs-target="#navbar" data-bs-root-margin="0px 0px -40%" data-bs-smooth-scroll="true" tabindex="0">


        <div style="display: flex; background-color: #f3f5f9; min-height: 100vh;">
            <!-- Sidebar -->
            <div style="width: 400px; background-color: #fff; padding: 20px;">
                <h3 style="margin-top: 100px; margin-bottom: 50px; font-size: 1.5rem;">Anh/Chị <%= user.getFullName()%></h3>

                <!-- Nút 0: My Wishlist -->
                <a href="product?action=viewWishlist" class="sidebar-link">
                            <i class="fas fa-heart"></i>
                            <span>My Wishlist</span>
                        </a>


                <!-- Nút 1: Đơn hàng đã mua -->
                <a href="order"
                   style="display: flex; align-items: center; background-color: #f2f3f5; color: #333; font-weight: 500;
                   border-radius: 8px; padding: 10px 15px; text-decoration: none; margin-bottom: 15px;">
                    <i class="fa fa-shopping-bag" style="margin-right: 10px;"></i>
                    My orders
                </a>

                <!-- Nút 2: Thông tin và sổ địa chỉ -->
                <a href="user"
                   style="display: flex; align-items: center; background-color: #f2f3f5; color: #333; font-weight: 500;
                   border-radius: 8px; padding: 10px 15px; text-decoration: none; margin-bottom: 15px;">
                    <i class="fa fa-user" style="margin-right: 10px;"></i>
                    Infomation and address
                </a>

                <!-- Nút 3: Change password -->
                <a href="changePassword.jsp"
                   style="display: flex; align-items: center; background-color: #f2f3f5; color: #333; font-weight: 500;
                   border-radius: 8px; padding: 10px 15px; text-decoration: none; margin-bottom: 25px;">
                    <i class="fa fa-user" style="margin-right: 10px;"></i>
                    Change password
                </a>

                <!-- Nút Đăng xuất -->
                <form action="logout" method="post">
                    <button type="submit"
                            style="background-color: #ff4d4f; color: white; border: none; width: 100%; padding: 10px;
                            border-radius: 8px; font-weight: 500; cursor: pointer;">
                        Đăng Xuất
                    </button>
                </form>
            </div>

            <!-- Content -->
            <div class="container mb-5">
                <div class="row justify-content-center">
                    <div class="col-md-9 p-4" style="background-color: transparent; box-shadow: none; border: none;">
                        <div class="card-body p-5">

                            <!--  Banner Section -->
                            <section class="py-5">
                                <div class="container text-center">
                                    <h1 class="fw-bold text-uppercase" style="margin-top: 50px;">Thông tin cá nhân</h1>
                                    <p class="text-muted">Quản lý thông tin tài khoản của bạn tại Phone Store</p>
                                </div>
                            </section>

                            <div class="row">
                                <!-- Avatar + Tên -->
                                <div class="col-md-4 text-center mb-4">
                                    <img src="images/avatar.png"
                                         alt="Avatar" class="rounded-circle border mb-3" width="150" height="150">
                                    <h5 class="fw-bold"><%= user.getFullName()%></h5>
                                    <p class="text-muted small">Mã người dùng: #<%= user.getUserId()%></p>
                                </div>

                                <!-- Form chỉnh sửa -->
                                <div class="col-md-8">
                                    <form action="user?action=update" method="post" class="needs-validation" novalidate>
                                        <div class="mb-3">
                                            <label for="fullName" class="form-label">Họ và tên</label>
                                            <input type="text" class="form-control" id="fullName" name="fullName"
                                                   value="<%= user.getFullName()%>" required>
                                        </div>

                                        <div class="mb-3">
                                            <label for="email" class="form-label">Email</label>
                                            <input type="email" class="form-control" id="email" name="email"
                                                   value="<%= user.getEmail()%>" required>
                                        </div>

                                        <div class="mb-3">
                                            <label for="phone" class="form-label">Số điện thoại</label>
                                            <input type="text" class="form-control" id="phone" name="phone"
                                                   value="<%= user.getPhone() != null ? user.getPhone() : ""%>">
                                        </div>

                                        <div class="mb-3">
                                            <label for="address" class="form-label">Địa chỉ</label>
                                            <input type="text" class="form-control" id="address" name="address"
                                                   value="<%= user.getAddress() != null ? user.getAddress() : ""%>">
                                        </div>

                                        <%-- Thông báo sau khi cập nhật --%>
                                        <% if (request.getAttribute("message") != null) {%>
                                        <div class="alert alert-success text-center" role="alert">
                                            <%= request.getAttribute("message")%>
                                        </div>
                                        <% } else if (request.getAttribute("error") != null) {%>
                                        <div class="alert alert-danger text-center" role="alert">
                                            <%= request.getAttribute("error")%>
                                        </div>
                                        <% }%>
                                        <div class="d-flex justify-content-end">
                                            <button type="submit" class="btn btn-primary px-4">Lưu thay đổi</button>
                                            <a href="user" class="btn btn-secondary ms-2 px-4">Hủy</a>
                                        </div>
                                    </form>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

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
                                                <li>
                                                    <a href="#">
                                                        <svg class="facebook">
                                                        <use xlink:href="#facebook" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#">
                                                        <svg class="instagram">
                                                        <use xlink:href="#instagram" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#">
                                                        <svg class="twitter">
                                                        <use xlink:href="#twitter" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#">
                                                        <svg class="linkedin">
                                                        <use xlink:href="#linkedin" />
                                                        </svg>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#">
                                                        <svg class="youtube">
                                                        <use xlink:href="#youtube" />
                                                        </svg>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-2 col-sm-6 pb-3">
                                    <div class="footer-menu text-uppercase">
                                        <h5 class="widget-title pb-2">Quick Links</h5>
                                        <ul class="menu-list list-unstyled text-uppercase">
                                            <li class="menu-item pb-2">
                                                <a href="#">Home</a>
                                            </li>
                                            <li class="menu-item pb-2">
                                                <a href="#">About</a>
                                            </li>
                                            <li class="menu-item pb-2">
                                                <a href="#">Shop</a>
                                            </li>
                                            <li class="menu-item pb-2">
                                                <a href="#">Blogs</a>
                                            </li>
                                            <li class="menu-item pb-2">
                                                <a href="#">Contact</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-sm-6 pb-3">
                                    <div class="footer-menu text-uppercase">
                                        <h5 class="widget-title pb-2">Help & Info Help</h5>
                                        <ul class="menu-list list-unstyled">
                                            <li class="menu-item pb-2">
                                                <a href="#">Track Your Order</a>
                                            </li>
                                            <li class="menu-item pb-2">
                                                <a href="#">Returns Policies</a>
                                            </li>
                                            <li class="menu-item pb-2">
                                                <a href="#">Shipping + Delivery</a>
                                            </li>
                                            <li class="menu-item pb-2">
                                                <a href="#">Contact Us</a>
                                            </li>
                                            <li class="menu-item pb-2">
                                                <a href="#">Faqs</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-sm-6 pb-3">
                                    <div class="footer-menu contact-item">
                                        <h5 class="widget-title text-uppercase pb-2">Contact Us</h5>
                                        <p>Do you have any queries or suggestions? <a href="mailto:">yourinfo@gmail.com</a>
                                        </p>
                                        <p>If you need support? Just give us a call. <a href="">+55 111 222 333 44</a>
                                        </p>
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
                            <p>? Copyright 2023 MiniStore. Design by <a href="https://templatesjungle.com/">TemplatesJungle</a> Distribution by <a href="https://themewagon.com">ThemeWagon</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="js/jquery-1.11.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>
        <script type="text/javascript" src="js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript" src="js/plugins.js"></script>
        <script type="text/javascript" src="js/script.js"></script>
        <script>
            var swiper = new Swiper(".product-swiper", {
                slidesPerView: 4,
                spaceBetween: 30,
                pagination: {
                    el: ".swiper-pagination",
                    clickable: true,
                },
                breakpoints: {
                    320: {slidesPerView: 1},
                    768: {slidesPerView: 2},
                    1024: {slidesPerView: 4}
                }
            });
        </script>

    </body>
</html>


