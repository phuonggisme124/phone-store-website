<%@page import="model.Review"%>
<%@page import="model.Category"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<<<<<<< HEAD
<%@ page import="model.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
=======
<%@page contentType="text/html" pageEncoding="UTF-8"%>
>>>>>>> 8a98e4a (Implement payment and installment feature)
<!DOCTYPE html>
<html>
    <head>
        <title>Product Detail</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css" />
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
<<<<<<< HEAD
        <link rel="stylesheet" href="css/rating.css">
=======
>>>>>>> 8a98e4a (Implement payment and installment feature)
        <link rel="stylesheet" href="css/product_detail.css">
        <link rel="stylesheet" href="css/gallery.css">
        <link rel="stylesheet" href="css/select_product.css">
        <script src="js/modernizr.js"></script>
    </head>

    <body data-bs-spy="scroll" data-bs-target="#navbar" tabindex="0">

        <header id="header" class="site-header header-scrolled position-fixed text-black bg-light">
            <nav id="header-nav" class="navbar navbar-expand-lg px-3 mb-3">
                <div class="container-fluid">
                    <a class="navbar-brand" href="index.html">
                        <img src="images/main-logo.png" class="logo">
                    </a>
<<<<<<< HEAD
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

=======
>>>>>>> 8a98e4a (Implement payment and installment feature)

                    <div class="offcanvas-body">
                        <ul id="navbar" class="navbar-nav text-uppercase justify-content-end align-items-center flex-grow-1 pe-3">
                            <li class="nav-item">
                                <a class="nav-link me-4" href="homepage">Home</a>
                            </li>

                            <%
                                List<Category> listCategory = (List<Category>) request.getAttribute("listCategory");
                                int categoryID = (int) request.getAttribute("categoryID");
                                for (Category c : listCategory) {
                            %>
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= (categoryID == c.getCategoryId() ? "active" : "")%>"
                                   href="product?action=category&cID=<%= c.getCategoryId()%>"><%= c.getCategoryName()%></a>
                            </li>
                            <% } %>

                            <li class="nav-item">
                                <div class="user-items ps-5">
                                    <ul class="d-flex justify-content-end list-unstyled align-items-center">
                                        <%
                                            model.Users user = (model.Users) session.getAttribute("user");
                                            boolean isLoggedIn = (user != null);
                                            String displayName = "";
                                            int userID = user.getUserId();
                                            if (isLoggedIn) {
                                                displayName = (user.getFullName() != null && !user.getFullName().trim().isEmpty())
                                                        ? user.getFullName() : user.getEmail();
                                        %>
                                        <li class="pe-3"><a href="cart.html"><svg class="cart"><use xlink:href="#cart"></use></svg></a></li>
                                        <li class="pe-3"><a href="logout" class="nav-link p-0 text-dark fw-bold">Logout</a></li>
                                        <li class="text-dark fw-bold"><%= displayName%></li>
                                            <% } else { %>
                                        <li class="pe-3"><a href="login.jsp" class="nav-link p-0 text-dark fw-bold">Login/Register</a></li>
                                        <li class="text-dark fw-bold">Hello Guest</li>
                                            <% } %>
                                    </ul>
<<<<<<< HEAD
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
=======
                                </div>
                            </li>
                        </ul>
>>>>>>> 8a98e4a (Implement payment and installment feature)
                    </div>
                </div>
            </nav>
        </header>

<<<<<<< HEAD

        <section id="billboard" class="position-relative overflow-hidden bg-light-blue">

        </section>
        <!-- detail -->
=======
>>>>>>> 8a98e4a (Implement payment and installment feature)
        <%
            ProductDAO pdao = new ProductDAO();
            int productID = (int) request.getAttribute("productID");
            //double rating = (double) request.getAttribute("rating");
            Variants variants = (Variants) request.getAttribute("variants");
            int currentVariantID = variants.getVariantID();
            List<Variants> listVariants = (List<Variants>) request.getAttribute("listVariants");
            List<String> listStorage = (List<String>) request.getAttribute("listStorage");
        %>

<<<<<<< HEAD


=======
>>>>>>> 8a98e4a (Implement payment and installment feature)
        <section id="billboard" class="bg-light-blue overflow-hidden mt-5 padding-large">
            <div class="container">
                <h3><%= pdao.getNameByID(variants.getProductID())%></h3>
            </div>

            <div class="product-container">
                <!-- LEFT -->
                <div class="product-left">
                    <div class="gallery">
                        <input type="radio" name="gallery" id="img1" checked>
                        <input type="radio" name="gallery" id="img2">
                        <input type="radio" name="gallery" id="img3">
                        <input type="radio" name="gallery" id="img4">

                        <div class="main-image">
                            <img src="images/post-item1.jpg" alt="img1">
                            <img src="images/post-item2.jpg" alt="img2">
                            <img src="images/post-item3.jpg" alt="img3">
                            <img src="images/post-item4.jpg" alt="img4">
                        </div>

                        <div class="thumbnails">
                            <label for="img1"><img src="images/post-item1.jpg" alt="thumb1"></label>
                            <label for="img2"><img src="images/post-item2.jpg" alt="thumb2"></label>
                            <label for="img3"><img src="images/post-item3.jpg" alt="thumb3"></label>
                            <label for="img4"><img src="images/post-item4.jpg" alt="thumb4"></label>
                        </div>
                    </div>
                </div>

                <!-- RIGHT -->
                <div class="product-right">
<<<<<<< HEAD

                    <!--                <form action="product">-->
                    <!-- Giá -->
=======
>>>>>>> 8a98e4a (Implement payment and installment feature)
                    <div class="price-box">
                        <p>Price</p>
                        <h2 id="price"><%= String.format("%,.0f", variants.getDiscountPrice())%> VND</h2>
                    </div>

                    <% if (!variants.getStorage().equals("N/A")) { %>
                    <div class="option-box">
                        <p>Version</p>
                        <div class="option-list">
                            <%
                                int i = 0;
                                for (String v : listStorage) {
                                    String storageId = "storage_" + i;
<<<<<<< HEAD

                            %>
                            <input type="radio" id="<%= storageId%>"
                                   <%= (variants.getStorage().equals(v)) ? "checked" : ""%>>
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= variants.getColor()%>&storage=<%= v%>&cID=<%= categoryID%>" for="" class="option-label">
                                <%= v%>
                            </a>
                            <%

                                    i += 1;
                                }
=======
>>>>>>> 8a98e4a (Implement payment and installment feature)
                            %>
                            <input type="radio" id="<%= storageId%>" name="storage"
                                   <%= (variants.getStorage().equals(v)) ? "checked" : ""%> >
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= variants.getColor()%>&storage=<%= v%>&cID=<%= categoryID%>"
                               class="option-label"><%= v%></a>
                            <% i++;
                                } %>
                        </div>
                    </div>
                    <% } %>

                    <!-- COLOR -->
                    <div class="option-box">
                        <p>Color</p>
                        <div class="color-list">
<<<<<<< HEAD

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
=======
>>>>>>> 8a98e4a (Implement payment and installment feature)
                            <%
                                int j = 0;
                                for (Variants v : listVariants) {
                                    if (variants.getStorage().equals(v.getStorage())) {
                                        String colorId = "color_" + j;
                            %>
                            <input type="radio" id="<%= colorId%>" name="color"
                                   value="<%= v.getColor()%>"
                                   <%= (variants.getColor().equals(v.getColor())) ? "checked" : ""%> >
                            <%currentVariantID = v.getVariantID();%>
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= v.getColor()%>&storage=<%= variants.getStorage()%>&cID=<%= categoryID%>&vID=<%= v.getVariantID()%>"
                               class="color-label"
                               style="background-color:<%= v.getColor()%>;"></a>
                            <% }
                                    j++;
                                }%>
                        </div>
                    </div>

<<<<<<< HEAD
                    <div class="action-buttons">
                        <button class="buy-now">BUY NOW</button>
                        <button class="add-cart">? Add to cart</button>

=======
                    <!-- QUANTITY -->
                    <div>
                        <p>Quantity</p>
                        <input type="number" name="quantity" id="quantity" value="1" min="1" max="99" required>
>>>>>>> 8a98e4a (Implement payment and installment feature)
                    </div>

                                        <!-- ACTION BUTTONS -->
                                        <div class="action-buttons">
                                                <% if (user != null) {%>
                                                    <!-- BUY NOW FORM -->
                                                    <form action="payment" method="get" style="display: inline-block;">
                                                            <input type="hidden" name="variantID" value="<%= currentVariantID%>">
                                                            <input type="hidden" name="quantity" class="hiddenQuantityInput" value="1">
                                                            <!-- Trường này để phân biệt hành động 'buy now' và 'add to cart' ở phía server -->
                                                            <input type="hidden" name="action" value="buyNowFromProductDetail">
                                                            <button type="submit" class="buy-now">BUY NOW</button>
                                                        </form>
                                                
                                                    <!-- ADD TO CART FORM -->
                                                    <form action="${pageContext.request.contextPath}/cart" method="post" style="display: inline-block;">
                                                            <input type="hidden" name="userID" value="<%= user.getUserId()%>">
                                                            <input type="hidden" name="variantID" value="<%= currentVariantID%>">
                                                            <input type="hidden" name="quantity" class="hiddenQuantityInput" value="1">
                                                          
                                                            <button type="submit" class="add-cart">Add to cart</button>
                                                        </form>
                                                
                                                    <script>
                                                            const qtyInput = document.getElementById('quantity');
                                                            // Lấy tất cả các trường số lượng ẩn
                                                            const hiddenQtyFields = document.querySelectorAll('.hiddenQuantityInput');
                                                            qtyInput.addEventListener('input', () => {
                                                                    // Cập nhật giá trị cho tất cả các trường ẩn khi số lượng thay đổi
                                                                    hiddenQtyFields.forEach(field => {
                                                                            field.value = qtyInput.value;
                                                                    });
                                                            });
                                                    </script>

                                                <% } else { %>
                                                    <!-- If user is not logged in, BUY NOW button just goes to login -->
                                                    <a href="login.jsp" class="buy-now">BUY NOW</a>
                                                    <p class="text-danger fw-bold mt-2">Bạn cần <a href="login.jsp">đăng nhập</a> để thêm vào giỏ hàng.</p>
                                                <% }%>
                                            </div>
                </div>
            </div>
        </section>


        <!-- ===================== REVIEW SECTION ===================== -->
      <%
    // ===================== Khởi tạo biến =====================
    List<Review> listReview = (List<Review>) request.getAttribute("listReview");

    int totalReviews = (listReview != null) ? listReview.size() : 0;

    double averageRating = 0;
    int[] ratingDistribution = new int[6]; // 1-5 stars
    if (totalReviews > 0) {
        int sumRating = 0;
        for (Review r : listReview) {
            int rating = r.getRating();
            sumRating += rating;
            if (rating >= 1 && rating <= 5) {
                ratingDistribution[rating]++;
            }
        }
        averageRating = (double) sumRating / totalReviews;
        for (int j = 1; j <= 5; j++) {
            ratingDistribution[j] = (int) Math.round((double) ratingDistribution[j] * 100 / totalReviews);
        }
    }

   
%>

<div class="container mt-5">
    <h3 class="mb-4">Product Reviews</h3>

 <!-- ===================== REVIEW SECTION ===================== -->
        <div class="container mt-5">
            <h3 class="mb-4">Product Reviews</h3>

            <%-- ===================== RATING SUMMARY ===================== --%>
            <% if (totalReviews > 0) { %>
                <div class="rating-summary d-flex flex-wrap align-items-center border rounded p-4 mb-4" style="background-color:#fff;">
                    <div class="rating-left text-center me-5">
                        <h1 class="fw-bold mb-1"><%= String.format("%.1f", averageRating) %> / 5</h1>
                        <div class="stars mb-2">
                            <% for (int k = 1; k <= 5; k++) { %>  <!-- Đổi tên biến lặp nếu cần -->
                                <i class="fa fa-star <%= (k <= averageRating) ? "text-warning" : "text-secondary" %>"></i>
                            <% } %>
                        </div>
                        <p class="text-muted"><%= totalReviews %> reviews and comments</p>
                    </div>
                    <div class="rating-bars flex-grow-1">
                        <% for (int m = 5; m >= 1; m--) { %>
                            <div class="d-flex align-items-center mb-2">
                                <div class="me-2" style="width: 40px;"><%= m %> <i class="fa fa-star text-warning"></i></div>
                                <div class="progress flex-grow-1" style="height:10px;">
                                    <div class="progress-bar bg-warning" style="width: <%= ratingDistribution[m] %>%;"></div>
                                </div>
                                <div class="ms-2 text-muted" style="width:40px;"><%= ratingDistribution[m] %>%</div>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>

            <%-- Nếu chưa đăng nhập --%>
            <% if (!isLoggedIn) { %>
                <p class="text-muted fst-italic">Please <a href="login.jsp">login</a> to write a review.</p>
            <% } else { %>
                <form action="review" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="variantID" value="<%= variants.getVariantID() %>">

                    <div class="mb-3">
                        <label for="rating" class="form-label fw-bold">Evaluate (1 - 5):</label>
                        <input type="number" name="rating" id="rating" class="form-control" min="1" max="5" required>
                    </div>

                    <div class="mb-3">
                        <label for="comment" class="form-label fw-bold">Your comment:</label>
                        <textarea name="comment" id="comment" class="form-control" rows="3" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="image" class="form-label fw-bold">Add picture (optional):</label>
                        <input type="file" name="image" id="image" class="form-control" accept="image/*">
                    </div>

                    <button type="submit" class="btn btn-primary">Submit a review</button>
                </form>
            <% } %>

            <%-- Danh sách review: THÊM NULL-CHECK --%>
            <% if (listReview != null && !listReview.isEmpty()) { 
                for (Review r : listReview) { %>
                    <div class="review-item border rounded p-3 mb-3">
                        <p class="mb-1">
                            <b><%= r.getUserName() %></b>
                            <span class="text-warning">(<%= r.getRating() %>/5 ⭐)</span>
                        </p>
                        <p class="mb-2"><%= r.getComment() %></p>

                        <% if (r.getImage() != null && !r.getImage().isEmpty()) { %>
                            <div class="mt-2">
                                <img src="<%= r.getImage() %>" alt="Ảnh đánh giá" class="img-fluid rounded shadow-sm" style="max-width: 250px; height: auto;">
                            </div>
                        <% } %>

                        <% if (isLoggedIn && user.getUserId() == r.getUserID()) { %>
                            <form action="review" method="post" class="d-inline">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="variantID" value="<%= r.getVariantID() %>">
                                <input type="hidden" name="reviewID" value="<%= r.getReviewID() %>">
                                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        <% } %>
                    </div>
            <%  }
               } else { %>
                <p class="text-muted fst-italic">There are no reviews for this product yet.</p>
            <% } %>
        </div>
        <!-- ===================== END REVIEW SECTION ===================== -->



        <footer id="footer" class="overflow-hidden">
            <div class="container">
                <p class="text-center mt-3">© 2023 MiniStore. Design by TemplatesJungle</p>
            </div>
        </footer>

        <script src="js/jquery-1.11.0.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/script.js"></script>
        <script>
                            const qtyInput = document.getElementById('quantity');
                            const hiddenQty = document.getElementById('hiddenQuantity');
                            qtyInput.addEventListener('input', () => hiddenQty.value = qtyInput.value);
        </script>


    </body>
</html>
