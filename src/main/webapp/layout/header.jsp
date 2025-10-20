<%-- File: /layout/header.jsp --%>
<%@page import="model.Users"%>
<%@page import="model.Category"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Ministore</title>
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
    <body data-bs-spy="scroll" data-bs-target="#navbar" data-bs-root-margin="0px 0px -40%" data-bs-smooth-scroll="true" tabindex="0">
        <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
            <%-- TẤT CẢ CÁC THẺ <symbol> CỦA BẠN ĐẶT Ở ĐÂY --%>
            <symbol id="search" ... >...</symbol>
            <symbol id="user" ... >...</symbol>
            <symbol id="cart" ... >...</symbol>
            <%-- vân vân... --%>
        </svg>

        <div class="search-popup">
            <div class="search-popup-container">
                <form role="search" method="get" class="search-form" action="">
                    <input type="search" id="search-form" class="search-field" placeholder="Type and press enter" value="" name="s" />
                    <button type="submit" class="search-submit"><svg class="search"><use xlink:href="#search"></use></svg></button>
                </form>
                <h5 class="cat-list-title">Browse Categories</h5>
                <ul class="cat-list">
                    <%-- Các li items... --%>
                </ul>
            </div>
        </div>

        <header id="header" class="site-header header-scrolled position-fixed text-black bg-light">
            <nav id="header-nav" class="navbar navbar-expand-lg px-3 mb-3">
                <div class="container-fluid">
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/homepage">
                        <img src="images/main-logo.png" class="logo">
                    </a>
                    <button class="navbar-toggler d-flex d-lg-none order-3 p-2" type="button" data-bs-toggle="offcanvas" data-bs-target="#bdNavbar" aria-controls="bdNavbar" aria-expanded="false" aria-label="Toggle navigation">
                        <svg class="navbar-icon"><use xlink:href="#navbar-icon"></use></svg>
                    </button>
                    <div class="offcanvas offcanvas-end" tabindex="-1" id="bdNavbar" aria-labelledby="bdNavbarOffcanvasLabel">
                        <div class="offcanvas-header px-4 pb-0">
                            <a class="navbar-brand" href="${pageContext.request.contextPath}/homepage">
                                <img src="images/main-logo.png" class="logo">
                            </a>
                            <button type="button" class="btn-close btn-close-black" data-bs-dismiss="offcanvas" aria-label="Close" data-bs-target="#bdNavbar"></button>
                        </div>
                        <%
                            List<Category> listCategory = (List<Category>) request.getAttribute("listCategory");
                        %>
                        <div class="offcanvas-body">
                            <ul id="navbar" class="navbar-nav text-uppercase justify-content-end align-items-center flex-grow-1 pe-3">
                                <li class="nav-item">
                                    <a class="nav-link me-4 active" href="${pageContext.request.contextPath}/homepage">Home</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link me-4" href="product?action=category&cID=1">Phone</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link me-4" href="product?action=category&cID=3">Tablet</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link me-4" href="product?action=category&cID=4">Smartwatch</a>
                                </li>
                                <li class="nav-item dropdown">
                                    <a class="nav-link me-4 dropdown-toggle link-dark" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false">Accessories</a>
                                    <ul class="dropdown-menu">
                                        <%
                                            if (listCategory != null) {
                                                for (Category c : listCategory) {
                                                    if (c.getCategoryId() != 1 && c.getCategoryId() != 3 && c.getCategoryId() != 4) {
                                        %>
                                        <li>
                                            <a href="product?action=category&cID=<%= c.getCategoryId()%>" class="dropdown-item"><%= c.getCategoryName()%></a>
                                        </li>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </ul>
                                </li>
                                <div class="user-items ps-5">
                                    <ul class="d-flex justify-content-end list-unstyled align-items-center">
                                        <%
                                            model.Users user = (model.Users) session.getAttribute("user");
                                            if (user != null) {
                                                String displayName = (user.getFullName() != null && !user.getFullName().trim().isEmpty()) ? user.getFullName() : user.getEmail();
                                        %>
                                        <li class="search-item pe-3">
                                            <a href="#" class="search-button">
                                                <svg class="search"><use xlink:href="#search"></use></svg>
                                            </a>
                                        </li>
                                        <li class="pe-3">
                                            <a href="${pageContext.request.contextPath}/cart?userID=<%= user.getUserId()%>" class="cart-link">
                                                <svg class="cart"><use xlink:href="#cart"></use></svg>
                                            </a>
                                        </li>
                                        <li class="pe-3">
                                            <a href="logout" class="nav-link p-0 text-dark text-uppercase fw-bold">Logout</a>
                                        </li>
                                        <li class="text-dark fw-bold">
                                            <%= displayName%>
                                        </li>
                                        <%
                                        } else {
                                        %>
                                        <li class="pe-3">
                                            <a href="login.jsp" class="nav-link p-0 text-dark text-uppercase fw-bold">Login/Register</a>
                                        </li>
                                        <li class="text-dark fw-bold">
                                            Hello Guest
                                        </li>
                                        <%
                                            }
                                        %>
                                    </ul>
                                </div>
                            </ul>
                        </div>
                    </div>
                </div>
            </nav>
        </header>