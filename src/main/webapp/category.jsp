<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="layout/header.jsp" %>
<!DOCTYPE html>
<html>
    <div class="search-popup">
        <div class="search-popup-container">

            <form role="search" method="get" class="search-form" action="">
                <input type="search" id="search-form" class="search-field" placeholder="Type and press enter" value="" name="s" />
                <button type="submit" class="search-submit"><svg class="search"><use xlink:href="#search"></use></svg></button>
            </form>

            <h5 class="cat-list-title">Browse Categories</h5>

            <ul class="cat-list">
                <li class="cat-list-item">
                    <a href="#" title="Mobile Phones">Mobile Phones</a>
                </li>
                <li class="cat-list-item">
                    <a href="#" title="Smart Watches">Smart Watches</a>
                </li>
                <li class="cat-list-item">
                    <a href="#" title="Headphones">Headphones</a>
                </li>
                <li class="cat-list-item">
                    <a href="#" title="Accessories">Accessories</a>
                </li>
                <li class="cat-list-item">
                    <a href="#" title="Monitors">Monitors</a>
                </li>
                <li class="cat-list-item">
                    <a href="#" title="Speakers">Speakers</a>
                </li>
                <li class="cat-list-item">
                    <a href="#" title="Memory Cards">Memory Cards</a>
                </li>
            </ul>

        </div>
    </div>

    <header id="header" class="site-header header-scrolled position-fixed text-black bg-light">
        <nav id="header-nav" class="navbar navbar-expand-lg px-3 mb-3">
            <div class="container-fluid">
                <a class="navbar-brand" href="homepage">
                    <img src="images/main-logo.png" class="logo">
                </a>
                <button class="navbar-toggler d-flex d-lg-none order-3 p-2" type="button" data-bs-toggle="offcanvas" data-bs-target="#bdNavbar" aria-controls="bdNavbar" aria-expanded="false" aria-label="Toggle navigation">
                    <svg class="navbar-icon">
                    <use xlink:href="#navbar-icon"></use>
                    </svg>
                </button>
                <div class="offcanvas offcanvas-end" tabindex="-1" id="bdNavbar" aria-labelledby="bdNavbarOffcanvasLabel">
                    <div class="offcanvas-header px-4 pb-0">
                        <a class="navbar-brand" href="index.html">
                            <img src="images/main-logo.png" class="logo">
                        </a>
                        <button type="button" class="btn-close btn-close-black" data-bs-dismiss="offcanvas" aria-label="Close" data-bs-target="#bdNavbar"></button>
                    </div>
                    <div class="offcanvas-body">
                        <ul id="navbar" class="navbar-nav text-uppercase justify-content-end align-items-center flex-grow-1 pe-3">
                            <li class="nav-item">
                                <a class="nav-link me-4" href="homepage">Home</a>
                            </li>
                            <%

                                int categoryID = (int) request.getAttribute("categoryID");
                            %>

                            <%
                                for (Category c : listCategory) {
                            %>
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= (categoryID == c.getCategoryId()? "active" : "")%>" href="product?action=category&cID=<%= c.getCategoryId()%>"><%= c.getCategoryName()%></a>
                            </li>
                            <%
                                }
                            %>


                            <li class="nav-item dropdown">
                                <a class="nav-link me-4 dropdown-toggle link-dark" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false">Pages</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a href="about.html" class="dropdown-item">About</a>
                                    </li>
                                    <li>
                                        <a href="blog.html" class="dropdown-item">Blog</a>
                                    </li>
                                    <li>
                                        <a href="shop.html" class="dropdown-item">Shop</a>
                                    </li>
                                    <li>
                                        <a href="cart.html" class="dropdown-item">Cart</a>
                                    </li>
                                    <li>
                                        <a href="checkout.html" class="dropdown-item">Checkout</a>
                                    </li>
                                    <li>
                                        <a href="single-post.html" class="dropdown-item">Single Post</a>
                                    </li>
                                    <li>
                                        <a href="single-product.html" class="dropdown-item">Single Product</a>
                                    </li>
                                    <li>
                                        <a href="contact.html" class="dropdown-item">Contact</a>
                                    </li>
                                </ul>
                            </li>

                            <li class="nav-item"> 
                                <div class="user-items ps-5">
                                    <ul class="d-flex justify-content-end list-unstyled align-items-center">
                                        <%
                                            // B??C 1: L?y ??i t??ng Users t? session. 
                                            // T?n thu?c t?nh ???c l?u l? "user" (nh? trong LoginServlet).
                                            // D?ng t?n l?p ??y ?? model.Users (h?y ??m b?o t?n package l? ??ng)

                                            if (isLoggedIn) {
                                                // B??C 2: D?ng ph??ng th?c getName() c? s?n ?? l?y t?n ng??i d?ng.
                                                // Th?m logic ki?m tra null/r?ng ?? tr?nh l?i n?u t?n kh?ng ???c l?u.
                                                if (user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
                                                    displayName = user.getFullName();
                                                } else {
                                                    // N?u t?n b? r?ng, hi?n th? Email thay th? (t?y ch?n)
                                                    displayName = user.getEmail();
                                                }
                                        %>
                                        <li class="search-item pe-3">
                                            <a href="#" class="search-button">
                                                <svg class="search"><use xlink:href="#search"></use></svg>
                                            </a>
                                        </li>

                                        <li class="pe-3">
                                            <a href="cart.html"> 
                                                <svg class="cart"><use xlink:href="#cart"></use></svg>
                                            </a>
                                        </li>

                                        <li class="pe-3">
                                            <a href="logout" class="nav-link p-0 text-dark text-uppercase fw-bold">Logout</a> 
                                        </li>

                                        <li class="text-dark fw-bold">
                                            <a href="user" class="nav-link p-0 text-dark text-uppercase fw-bold"> <%= displayName%> </a>
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
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <section style="background-color: white" id="billboard" class="position-relative overflow-hidden bg-light-blue">
        <div class="swiper main-swiper">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <div class="container">
                        <div class="row d-flex align-items-center">
                            <div class="col-md-6">
                                <div class="banner-content">
                                    <h1 class="display-2 text-uppercase text-dark pb-5">Your Products Are Great.</h1>
                                    <a href="shop.html" class="btn btn-medium btn-dark text-uppercase btn-rounded-none">Shop Product</a>
                                </div>
                            </div>
                            <div class="col-md-5">
                                <div class="image-holder">
                                    <img src="images/banner-image.jpg" alt="banner">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="swiper-slide">
                    <div class="container">
                        <div class="row d-flex flex-wrap align-items-center">
                            <div class="col-md-6">
                                <div class="banner-content">
                                    <h1 class="display-2 text-uppercase text-dark pb-5">Technology Hack You Won't Get</h1>
                                    <a href="shop.html" class="btn btn-medium btn-dark text-uppercase btn-rounded-none">Shop Product</a>
                                </div>
                            </div>
                            <div class="col-md-5">
                                <div class="image-holder">
                                    <img src="images/banner-image.png" alt="banner">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="swiper-icon swiper-arrow swiper-arrow-prev">
            <svg class="chevron-left">
            <use xlink:href="#chevron-left" />
            </svg>
        </div>
        <div class="swiper-icon swiper-arrow swiper-arrow-next">
            <svg class="chevron-right">
            <use xlink:href="#chevron-right" />
            </svg>
        </div>
    </section>
    <section id="company-services" class="padding-large">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-6 pb-3">
                    <div class="icon-box d-flex">
                        <div class="icon-box-icon pe-3 pb-3">
                            <svg class="cart-outline">
                            <use xlink:href="#cart-outline" />
                            </svg>
                        </div>
                        <div class="icon-box-content">
                            <h3 class="card-title text-uppercase text-dark">Free delivery</h3>
                            <p>Consectetur adipi elit lorem ipsum dolor sit amet.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 pb-3">
                    <div class="icon-box d-flex">
                        <div class="icon-box-icon pe-3 pb-3">
                            <svg class="quality">
                            <use xlink:href="#quality" />
                            </svg>
                        </div>
                        <div class="icon-box-content">
                            <h3 class="card-title text-uppercase text-dark">Quality guarantee</h3>
                            <p>Dolor sit amet orem ipsu mcons ectetur adipi elit.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 pb-3">
                    <div class="icon-box d-flex">
                        <div class="icon-box-icon pe-3 pb-3">
                            <svg class="price-tag">
                            <use xlink:href="#price-tag" />
                            </svg>
                        </div>
                        <div class="icon-box-content">
                            <h3 class="card-title text-uppercase text-dark">Daily offers</h3>
                            <p>Amet consectetur adipi elit loreme ipsum dolor sit.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 pb-3">
                    <div class="icon-box d-flex">
                        <div class="icon-box-icon pe-3 pb-3">
                            <svg class="shield-plus">
                            <use xlink:href="#shield-plus" />
                            </svg>
                        </div>
                        <div class="icon-box-content">
                            <h3 class="card-title text-uppercase text-dark">100% secure payment</h3>
                            <p>Rem Lopsum dolor sit amet, consectetur adipi elit.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="mobile-products" class="product-store position-relative padding-large no-padding-top">
        <div class="container">
            <div class="row">
                <div class="display-header d-flex justify-content-between pb-3">
                    <h2 class="display-7 text-dark text-uppercase">Mobile Products</h2>
                    <div class="btn-right">
                        <a href="shop.html" class="btn btn-medium btn-normal text-uppercase">Go to Shop</a>
                    </div>
                </div>

                <!-- Swiper -->
                <%
                    ProductDAO pdao = new ProductDAO();
                    List<Variants> listVariant = (List<Variants>) request.getAttribute("listVariant");
                    List<Products> listProduct = (List<Products>) request.getAttribute("listProduct");


                %>
                <%                    for (Products p : listProduct) {
                %>
                <div class="col-md-3 col-sm-6 mb-4">
                    <div class="product-card border rounded-3 p-3 text-center position-relative shadow-sm">

                        <!-- Badges -->


                        <!-- Image -->
                        <div class="image-holder mb-3">
                            <img src="<%= p.getVariants().get(0).getImageUrl()%>" alt="<%= p.getName()%>" 
                                 class="img-fluid rounded-3" style="height: 220px; object-fit: contain;">
                        </div>

                        <!-- Product Info -->
                        <h5 class="fw-bold text-primary mb-1">
                            <a href="product?action=viewDetail&pID=<%= p.getProductID()%>" class="text-decoration-none text-dark">
                                <%= p.getName()%>
                            </a>
                        </h5>

                        <!--                        <div class="text-muted small mb-2">
                                                    Super Retina XDR 6.3"
                                                </div>-->

                        <!-- Storage Options -->

                        <div class="d-flex justify-content-center gap-2 mb-3">
                            
                            
                        </div>

                        <!-- Price -->
                        <div class="price fw-bold text-primary fs-5">
                            <%= String.format("%,.0f", p.getVariants().get(0).getDiscountPrice())%>?
                        </div>

                    </div>
                </div>
                <%
                    }
                %>

            </div>
    </section>



    <section id="yearly-sale" class="bg-light-blue overflow-hidden mt-5 padding-xlarge" style="background-image: url('images/single-image1.png');background-position: right; background-repeat: no-repeat;">
        <div class="row d-flex flex-wrap align-items-center">
            <div class="col-md-6 col-sm-12">
                <div class="text-content offset-4 padding-medium">
                    <h3>10% off</h3>
                    <h2 class="display-2 pb-5 text-uppercase text-dark">New year sale</h2>
                    <a href="shop.html" class="btn btn-medium btn-dark text-uppercase btn-rounded-none">Shop Sale</a>
                </div>
            </div>
            <div class="col-md-6 col-sm-12">

            </div>
        </div>
    </section>
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