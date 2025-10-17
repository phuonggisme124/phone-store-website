<%@page import="model.Category"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Product Detail</title>
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
        <link rel="stylesheet" href="css/rating.css">
        <link rel="stylesheet" href="css/product_detail.css">
        <link rel="stylesheet" href="css/gallery.css">
        <link rel="stylesheet" href="css/select_product.css">
        <!--        <script src="js/product_detail.js"></script>-->
        <script src="js/modernizr.js"></script>
        <!-- Swiper CSS -->
        <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />

        <!-- Swiper JS -->
        <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
    </head>
    <body data-bs-spy="scroll" data-bs-target="#navbar" data-bs-root-margin="0px 0px -40%" data-bs-smooth-scroll="true" tabindex="0">


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
                    <a class="navbar-brand" href="index.html">
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
                                    List<Category> listCategory = (List<Category>) request.getAttribute("listCategory");
                                    int categoryID = (int) request.getAttribute("categoryID");


                                %>

                                <%                                for (Category c : listCategory) {
                                %>
                                <li class="nav-item">
                                    <a class="nav-link me-4 <%= (categoryID == c.getCategoryId() ? "active" : "")%>" href="product?action=category&cID=<%= c.getCategoryId()%>"><%= c.getCategoryName()%></a>
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
                                                model.Users user = (model.Users) session.getAttribute("user");

                                                boolean isLoggedIn = (user != null);
                                                String displayName = ""; // Bi?n ?? l?u tr? T?n ng??i d?ng ho?c Email

                                                if (isLoggedIn) {
                                                    // B??C 2: D?ng ph??ng th?c getName() c? s?n ?? l?y t?n ng??i d?ng.
                                                    // Th?m logic ki?m tra null/r?ng ?? tr?nh l?i n?u t?n kh?ng ???c l?u.
                                                    if (user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
                                                        displayName = user.getFullName();
                                                    } else {
                                                        // N?u t?n b? r?ng, hi?n th? Email thay th? (t?y ch?n)
                                                        displayName = user.getEmail();
                                                    }
//                                                String displayName = "Guest";
//                                                boolean isLoggedIn = false;
//                                                if (user != null) {
//                                                    isLoggedIn = true;
//                                                    if (user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
//                                                        displayName = user.getFullName();
//                                                    } else if (user.getEmail() != null) {
//                                                        displayName = user.getEmail();
//                                                    }
//                                                }
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
                                                <%= displayName%>
                                            </li>

                                            <%
                                                }

                                                
                                                
                                                else {
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


        <section id="billboard" class="position-relative overflow-hidden bg-light-blue">

        </section>
        <!-- detail -->
        <%
            ProductDAO pdao = new ProductDAO();
            int productID = (int) request.getAttribute("productID");
            double rating = (double) request.getAttribute("rating");
            Variants variants = (Variants) request.getAttribute("variants");
            List<Variants> listVariants = (List<Variants>) request.getAttribute("listVariants");
            List<String> listStorage = (List<String>) request.getAttribute("listStorage");

        %>



        <section id="billboard" class="bg-light-blue overflow-hidden mt-5 padding-large">
            <div class="container">
                <h3><%= pdao.getNameByID(variants.getProductID())%></h3>
            </div>

            <div class="product-container">
                <!-- LEFT -->
                <div class="product-left">
                    <div class="gallery">
                        <!-- Radio buttons (?n) -->

                        <input type="radio" name="gallery" id="img1" checked>
                        <input type="radio" name="gallery" id="img2">
                        <input type="radio" name="gallery" id="img3">
                        <input type="radio" name="gallery" id="img4">

                        <!-- ?nh l?n -->
                        <div class="main-image">
                            <img src="images/post-item1.jpg" alt="?nh 1">
                            <img src="images/post-item2.jpg" alt="?nh 2">
                            <img src="images/post-item3.jpg" alt="?nh 3">
                            <img src="images/post-item4.jpg" alt="?nh 4">
                        </div>

                        <!-- Thumbnail -->
                        <div class="thumbnails">
                            <label for="img1"><img src="images/post-item1.jpg" alt="thumb 1"></label>
                            <label for="img2"><img src="images/post-item2.jpg" alt="thumb 2"></label>
                            <label for="img3"><img src="images/post-item3.jpg" alt="thumb 3"></label>
                            <label for="img4"><img src="images/post-item4.jpg" alt="thumb 4"></label>
                        </div>
                    </div>
                </div>

                <!-- RIGHT -->
                <%
                    String storage = variants.getStorage();
                %>

                <div class="product-right">

                    <!--                <form action="product">-->
                    <!-- Giá -->
                    <div class="price-box">
                        <p>Price</p>
                        <h2 id="price">
                            <%= String.format("%,.0f", variants.getDiscountPrice())%> VND
                        </h2>
                    </div>

                    <!-- Storage -->
                    <% if (!storage.equals("N/A")) { %>
                    <div class="option-box">
                        <p>Version</p>
                        <div class="option-list">
                            <%
                                int i = 0;
                                for (String v : listStorage) {

                                    String storageId = "storage_" + i;

                            %>
                            <input type="radio" id="<%= storageId%>"
                                   <%= (variants.getStorage().equals(v)) ? "checked" : ""%>>
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= variants.getColor()%>&storage=<%= v%>&cID=<%= categoryID%>" for="" class="option-label">
                                <%= v%>
                            </a>
                            <%

                                    i += 1;
                                }
                            %>
                        </div>
                    </div>
                    <%
                        }
                    %>
                    <!-- Color -->
                    <div class="option-box">
                        <p>Color</p>

                        <div class="color-list">

                            <% int i = 0;
                                for (Variants v : listVariants) {
                                    String storageV = v.getStorage();
                                    String colorV = v.getColor();
                                    String colorId = "color_" + i;
                                    if (variants.getStorage().equals(storageV)) {
                            %>
                            <input type="radio" id="<%= colorId%>" name="color" value="<%= colorV%>"
                                   <%= (variants.getColor().equals(colorV)) ? "checked" : ""%>>
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= colorV%>&storage=<%= variants.getStorage()%>&cID=<%= categoryID%>"   for="<%= colorId%>" class="color-label"
                               style="background-color:<%= colorV%>;">
                            </a>
                            <%
                                    }
                                    i += 1;
                                }
                            %>
                        </div>


                    </div>

                    <div class="action-buttons">
                        <button class="buy-now">BUY NOW</button>
                        <button class="add-cart">? Add to cart</button>

                    </div>

                    <!--                </form>             -->
                </div>
            </div>
        </section>


        <!-- ===================== REVIEW SECTION ===================== -->
        <div class="container mt-5">
            <h3 class="mb-4">Đánh giá sản phẩm</h3>
            <!-- ===================== RATING SUMMARY ===================== -->
            <c:if test="${totalReviews > 0}">
                <div class="rating-summary d-flex flex-wrap align-items-center border rounded p-4 mb-4" style="background-color:#fff;">
                    <!-- Cột trái -->
                    <div class="rating-left text-center me-5">
                        <h1 class="fw-bold mb-1">
                            <fmt:formatNumber value="${averageRating}" type="number" maxFractionDigits="1"/> / 5
                        </h1>
                        <div class="stars mb-2">
                            <c:forEach var="i" begin="1" end="5">
                                <i class="fa fa-star ${i <= averageRating ? 'text-warning' : 'text-secondary'}"></i>
                            </c:forEach>
                        </div>
                        <p class="text-muted">${totalReviews} đánh giá và nhận xét</p>
                    </div>

                    <!-- Cột phải -->
                    <div class="rating-bars flex-grow-1">
                        <c:forEach var="i" begin="5" end="1" step="-1">
                            <div class="d-flex align-items-center mb-2">
                                <div class="me-2" style="width: 40px;">${i} <i class="fa fa-star text-warning"></i></div>
                                <div class="progress flex-grow-1" style="height:10px;">
                                    <div class="progress-bar bg-warning" style="width: ${ratingDistribution[i]}%;"></div>
                                </div>
                                <div class="ms-2 text-muted" style="width:40px;">
                                    <fmt:formatNumber value="${ratingDistribution[i]}" type="number" maxFractionDigits="0"/>%
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
            <!-- ===================== END RATING SUMMARY ===================== -->
            <!--         Nếu chưa đăng nhập -->
            <c:if test="${empty sessionScope.user}">
                <p class="text-muted fst-italic">Vui lòng <a href="login.jsp">đăng nhập</a> để viết đánh giá.</p>
            </c:if>
            <!--         Nếu đã đăng nhập mới được gửi đánh giá -->
            <c:if test="${not empty sessionScope.user}">
                <form action="review" method="post" enctype="multipart/form-data" >
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="variantID" value="<%= variants.getVariantID()%>">
                    <div class="mb-3">
                        <label for="rating" class="form-label fw-bold">Đánh giá (1 - 5 sao):</label>
                        <input type="number" name="rating" id="rating" class="form-control" min="1" max="5" required>
                    </div>
                    <div class="mb-3">
                        <label for="comment" class="form-label fw-bold">Bình luận của bạn:</label>
                        <textarea name="comment" id="comment" class="form-control" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="image" class="form-label fw-bold">Thêm hình ảnh (tùy chọn):</label>
                        <input type="file" name="image" id="image" class="form-control" accept="image/*">
                    </div>
                    <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                </form>
            </c:if>



            <!-- ======= TỔNG QUAN ĐÁNH GIÁ ======= -->
            <c:if test="${not empty listReview}">
                <div class="border rounded p-3 mb-4 bg-light">
                    <c:set var="totalRating" value="0" />
                    <c:set var="count" value="0" />

                    <c:forEach var="r" items="${listReview}">
                        <c:set var="totalRating" value="${totalRating + r.rating}" />
                        <c:set var="count" value="${count + 1}" />
                    </c:forEach>

                    <c:set var="average" value="${totalRating / count}" />

                    <h5 class="mb-1 fw-bold">Đánh giá trung bình:</h5>
                    <p class="fs-5 mb-1 text-warning">
                        ⭐ <fmt:formatNumber value="${average}" type="number" maxFractionDigits="1"/> / 5
                    </p>
                    <p class="text-muted small mb-0">${count} đánh giá</p>
                </div>
            </c:if>

            <!-- ======= DANH SÁCH REVIEW ======= -->
            <c:forEach var="r" items="${listReview}">
                <div class="review-item border rounded p-3 mb-3">
                    <p class="mb-1">
                        <b>${r.userName}</b> 
                        <span class="text-warning">(${r.rating}/5 ⭐)</span>
                    </p>
                    <p class="mb-2">${r.comment}</p>
                    <!-- Nếu có hình ảnh thì hiển thị -->
                    <c:if test="${not empty r.image}">
                        <div class="mt-2">
                            <img src="${r.image}" alt="Ảnh đánh giá" 
                                 class="img-fluid rounded shadow-sm"
                                 style="max-width: 250px; height: auto;">
                        </div>
                    </c:if>

                    <!--                    Hiển thị nút Xóa nếu là chính chủ -->
                    <c:if test="${sessionScope.user != null and sessionScope.user.userId == r.userId}">
                        <form action="review" method="post" class="d-inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="variantID" value="${r.variantID}">
                            <input type="hidden" name="reviewID" value="${r.reviewId}">
                            <button type="submit" class="btn btn-sm btn-danger">Xóa</button>
                        </form>
                    </c:if>
                </div>
            </c:forEach>

            <!--            Nếu chưa có review -->
            <c:if test="${empty listReview}">
                <p class="text-muted fst-italic">Chưa có đánh giá nào cho sản phẩm này.</p>
            </c:if>
        </div> 
        <!-- ===================== END REVIEW SECTION ===================== -->



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


        <!--    <script src="js/product_detail.js"></script>-->

    </body>
</html>