<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.VariantsDAO"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="model.Variants"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="model.Customer"%>
<%@page import="dao.WishlistDAO"%>

<%@ include file="/layout/header.jsp" %>
<link rel="stylesheet" type="text/css" href="css/home.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<style>
    #searchSection {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 40px 0;
        margin-bottom: 0;
    }

    #searchContainer {
        position: relative;
        max-width: 600px;
        margin: 0 auto;
    }

    #searchInput {
        width: 100%;
        padding: 15px 50px 15px 20px;
        border: none;
        border-radius: 50px;
        font-size: 16px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        outline: none;
    }

    #searchInput:focus {
        box-shadow: 0 6px 20px rgba(0,0,0,0.3);
    }

    .search-icon-btn {
        position: absolute;
        right: 5px;
        top: 50%;
        transform: translateY(-50%);
        background: #667eea;
        border: none;
        border-radius: 50%;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s;
    }

    .search-icon-btn:hover {
        background: #764ba2;
        transform: translateY(-50%) scale(1.1);
    }

    .search-icon-btn svg {
        width: 20px;
        height: 20px;
        fill: white;
    }

    #searchResults {
        position: absolute;
        top: calc(100% + 10px);
        left: 0;
        width: 100%;
        background-color: #fff;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        z-index: 1000;
        max-height: 400px;
        overflow-y: auto;
        display: none;
    }

    #searchResults.show {
        display: block;
    }

    .suggestion-item {
        padding: 12px 15px;
        cursor: pointer;
        display: none;
        align-items: center;
        border-bottom: 1px solid #f0f0f0;
        transition: all 0.2s;
    }

    .suggestion-item:hover {
        background-color: #f8f9fa;
        transform: translateX(5px);
    }

    .suggestion-item:last-child {
        border-bottom: none;
    }

    .suggestion-item img {
        border-radius: 8px;
        margin-right: 12px;
    }

    .search-category-badge {
        display: inline-block;
        padding: 5px 15px;
        background: rgba(255,255,255,0.3);
        border-radius: 20px;
        color: white;
        font-size: 14px;
        margin-bottom: 15px;
    }

    .no-results {
        padding: 20px;
        text-align: center;
        color: #999;
    }
    .product-card .image-holder {
        position: relative;
        width: 100%;
        /* ??y l? k? thu?t t?o t? l? 1:1 (h?nh vu?ng) */
        padding-top: 100%;
        background-color: #f4f4f4; /* Th?m m?u n?n nh?t cho ?? tr?ng */
        border-radius: 8px; /* Bo g?c cho ??p */
        overflow: hidden; /* ?n ph?n ?nh th?a */
    }
    /* CSS cho s?n ph?m 8*/

    .product-card .image-holder img {
        /* B?t ?nh ph?i l?p ??y div cha */
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover; /* 'cover' ?? l?p ??y, 'contain' ?? v?a v?n */

        /* Gi? l?i hi?u ?ng c?a b?n */
        transition: transform 0.3s ease;
    }

    .product-card:hover img {
        transform: scale(1.08);
    }

    .swiper-slide {
        height: auto !important;
    }

    /* hi?u ?ng menu */


</style>

<html>
    <body>
        <!-- Video Background -->
        <section id="billboard">
            <video autoplay muted loop playsinline>
                <source src="<%= request.getContextPath()%>/video/demo.webm" type="video/webm">
            </video>

            <div class="overlay-content">
                <h2>NEW ARRIVAL</h2>
                <h1>iPhone 17</h1>
                <a href="product?action=viewDetail&pID=13" class="btn-discover">Discover Now</a>
            </div>
        </section>

        <section id="searchSection">
            <div class="container">
                <div class="row">
                    <div class="col-12 text-center mb-3">
                        <h2 class="text-white">Find Your Perfect Product</h2>
                        <span class="search-category-badge" id="categoryBadge">Searching in: All Products</span>

                    </div>
                    <div class="col-12">
                        <%
                            List<Products> productList1_search = (List<Products>) request.getAttribute("productList1");
                            List<Variants> variantsList_search = (List<Variants>) request.getAttribute("variantsList");

                            Map<Integer, String> productNameMap_search = new HashMap<>();
                            Map<Integer, Integer> productCategoryMap_search = new HashMap<>();

                            if (productList1_search != null) {
                                for (Products p : productList1_search) {
                                    productNameMap_search.put(p.getProductID(), p.getName());
                                    productCategoryMap_search.put(p.getProductID(), p.getCategoryID());
                                }
                            }
                        %>
                        <div id="searchContainer">
                            <input type="text" id="searchInput" placeholder="Search for products..." autocomplete="off">
                            <button class="search-icon-btn" type="button">
                                <svg class="search"><use xlink:href="#search"></use></svg>
                            </button>

                            <div id="searchResults">
                                <%
                                    if (variantsList_search != null && !productNameMap_search.isEmpty()) {
                                        for (Variants v : variantsList_search) {
                                            String productName = productNameMap_search.get(v.getProductID());
                                            Integer categoryID = productCategoryMap_search.get(v.getProductID());
                                            if (productName != null && categoryID != null) {
                                                String image = (v.getImageUrl() != null) ? v.getImageUrl() : "";
                                                String color = (v.getColor() != null) ? v.getColor() : "N/A";
                                                String storage = (v.getStorage() != null) ? v.getStorage() : "N/A";
                                %>
                                <div class="suggestion-item" 
                                     data-variantid="<%= v.getVariantID()%>"
                                     data-pid="<%= v.getProductID()%>"
                                     data-cid="<%= categoryID%>"
                                     data-color="<%= color%>"
                                     data-storage="<%= storage%>"
                                     data-productname="<%= productName%>">
                                    <img src="images/<%= image%>" width="50" height="50" alt="<%= productName%>">
                                    <div>
                                        <strong><%= productName%></strong><br>
                                        <small><%= storage%> - <%= color%></small>
                                    </div>
                                </div>
                                <%
                                            }
                                        }
                                    }
                                %>
                            </div>
                        </div>
                        <form id="productSearchForm" action="product" method="GET" style="display:none;">
                            <input type="hidden" name="action" value="selectStorage">
                            <input type="hidden" name="pID" id="formPID">
                            <input type="hidden" name="cID" id="formCID">
                            <input type="hidden" name="storage" id="formStorage">
                            <input type="hidden" name="color" id="formColor">
                        </form>
                    </div>
                </div>
            </div>
        </section>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const searchInput = document.getElementById('searchInput');
                const searchResults = document.getElementById('searchResults');
                const allSuggestionItems = searchResults.querySelectorAll('.suggestion-item');
                const categoryBadge = document.getElementById('categoryBadge');

                // Lu?n search theo "All Products" v? ??y l? homepage
                let currentCategory = 'all';

                const categoryNames = {
                    'all': 'All Products',
                    '1': 'Phone',
                    '2': 'watch',
                    '3': 'Tablet',
                    '5': 'Phone Case'
                };

                // C?p nh?t badge
                categoryBadge.textContent = 'Searching in: All Products';

                // L?c suggestions theo category
                function filterByCategory(items) {
                    items.forEach(item => {
                        const itemCategory = item.dataset.cid;
                        if (currentCategory === 'all' || itemCategory === currentCategory) {
                            item.dataset.categoryMatch = 'true';
                        } else {
                            item.dataset.categoryMatch = 'false';
                        }
                    });
                }

                filterByCategory(allSuggestionItems);

                // Hi?n th? g?i ? khi g?
                searchInput.addEventListener('keyup', function () {
                    const query = searchInput.value.toLowerCase().trim();
                    let hasResults = false;

                    if (query.length > 0) {
                        allSuggestionItems.forEach(item => {
                            const productName = item.dataset.productname.toLowerCase();
                            const itemText = item.textContent.toLowerCase();
                            const categoryMatch = item.dataset.categoryMatch === 'true';

                            // Ki?m tra n?u query c? trong t?n s?n ph?m ho?c text
                            if ((productName.includes(query) || itemText.includes(query)) && categoryMatch) {
                                item.style.display = 'flex';
                                hasResults = true;
                            } else {
                                item.style.display = 'none';
                            }
                        });

                        if (hasResults) {
                            searchResults.classList.add('show');
                        } else {
                            // Hi?n th? th?ng b?o kh?ng t?m th?y
                            let noResultDiv = searchResults.querySelector('.no-results');
                            if (!noResultDiv) {
                                noResultDiv = document.createElement('div');
                                noResultDiv.className = 'no-results';
                                searchResults.appendChild(noResultDiv);
                            }
                            noResultDiv.textContent = 'No products found';
                            noResultDiv.style.display = 'block';
                            searchResults.classList.add('show');
                        }
                    } else {
                        // ?n t?t c? khi kh?ng c? query
                        searchResults.classList.remove('show');
                        allSuggestionItems.forEach(item => {
                            item.style.display = 'none';
                        });
                    }
                });

                // Click v?o suggestion
                allSuggestionItems.forEach(item => {
                    item.addEventListener('click', function () {
                        document.getElementById('formPID').value = this.dataset.pid;
                        document.getElementById('formCID').value = this.dataset.cid;
                        document.getElementById('formStorage').value = this.dataset.storage;
                        document.getElementById('formColor').value = this.dataset.color;
                        document.getElementById('productSearchForm').submit();
                    });
                });

                // Enter ?? ch?n suggestion ??u ti?n
                searchInput.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        const firstVisible = Array.from(allSuggestionItems).find(
                                item => item.style.display === 'flex'
                        );
                        if (firstVisible)
                            firstVisible.click();
                    }
                });

                // Click outside ?? ??ng results
                document.addEventListener('click', function (e) {
                    if (!searchContainer.contains(e.target)) {
                        searchResults.classList.remove('show');
                        const noResultDiv = searchResults.querySelector('.no-results');
                        if (noResultDiv) {
                            noResultDiv.style.display = 'none';
                        }
                    }
                });
            });
        </script>

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
                                <p>Connecting Your World.</p>
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
                                <p>Your Next Phone Starts Here.</p>
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
                                <p>Discover the Future of Mobile.</p>
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
                                <p>Find Your Perfect Device.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="mobile-products" class="product-store position-relative padding-large no-padding-top">
            <div class="container">
                <div class="row mb-5">
                    <div class="display-header d-flex justify-content-between pb-3">
                        <h2 class="display-7 text-dark text-uppercase">Mobile Products</h2>
                        <div class="btn-right">
                            <a href="product?action=category&cID=1" class="btn btn-medium btn-normal text-uppercase">Go to Shop</a>
                        </div>
                    </div>

                    <%
                        List<Products> productList1 = (List<Products>) request.getAttribute("productList1");
                        NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

                        if (productList1 == null && request.getParameter("fromProduct") == null) {
                            response.sendRedirect(request.getContextPath() + "/product?fromProduct=true");
                            return;
                        }
                    %>

                    <div class="swiper product-swiper">
                        <div class="swiper-wrapper">
                            <%
                                if (productList1 != null) {
                                    for (Products p : productList1) {
                                        if (p.getCategoryID() != null && p.getCategoryID() == 1) {

                            %>
                            <div class="swiper-slide">
                                <div class="product-card text-center position-relative">
                                    <div class="image-holder">
                                        <a href="product?action=viewDetail&pID=<%= p.getProductID()%>">
                                            <img src="images/<%= p.getVariants().get(0).getImageUrl()%>" alt="<%= p.getName()%>" class="img-fluid rounded-3">
                                        </a>
                                    </div>
                                    <div class="card-detail pt-3">
                                        <h3 class="card-title text-uppercase">
                                            <a href="product?action=viewDetail&pID=<%= p.getProductID()%>">
                                                <%=p.getName()%>
                                                <%=p.getVariants().get(0).getColor()%>
                                                <%=p.getVariants().get(0).getStorage()%></a>
                                        </h3>

                                        <!--WISH LIST BUTTON-->
                                        <div class="wishlist-wrap">
                                            <%
 Customer u = (Customer) session.getAttribute("user");
 boolean logged = (u != null);
 boolean liked = false;
 int variantID = p.getVariants().get(0).getVariantID();
 int productID = p.getProductID();

 if (logged && variantID > 0) {
     WishlistDAO wdao = new WishlistDAO();
     liked = wdao.isExist(u.getCustomerID(), productID, variantID);
 }
                                            %>

                                            <button class="wishlist-btn toggle-wishlist"
                                                    data-productid="<%= productID %>"
                                                    data-variantid="<%= variantID %>"
                                                    style="background:none; border:none; padding:0;">
                                                <i class="<%= liked ? "fas fa-heart" : "far fa-heart" %>"
                                                   style="<%= liked ? "color:#e53e3e;" : "" %>"></i>
                                            </button>

                                        </div>


                                        <span class="item-price text-primary"><%= vnFormat.format(p.getVariants().get(0).getDiscountPrice())%></span>
                                    </div>
                                </div>
                            </div>
                            <%         }
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>

                <div class="row  pb-3 mb-5" >
                    <div class="display-header d-flex justify-content-between pb-3">
                        <h2 class="display-7 text-dark text-uppercase">SmartWatch</h2>
                        <div class="btn-right">
                            <a href="product?action=category&cID=4" class="btn btn-medium btn-normal text-uppercase">Go to Shop</a>
                        </div>
                    </div>

                    <%
                        if (productList1 == null && request.getParameter("fromProduct") == null) {
                            response.sendRedirect(request.getContextPath() + "/product?fromProduct=true");
                            return;
                        }
                    %>

                    <div class="swiper product-swiper">
                        <div class="swiper-wrapper">
                            <%
                                if (productList1 != null) {
                                    for (Products p : productList1) {
                                        if (p.getCategoryID() != null && p.getCategoryID() == 2) {

                            %>
                            <div class="swiper-slide">
                                <div class="product-card text-center position-relative">
                                    <div class="image-holder">
                                        <a href="product?action=viewDetail&pID=<%= p.getProductID()%>">
                                            <img src="images/<%= p.getVariants().get(0).getImageUrl()%>" alt="<%= p.getName()%>" class="img-fluid rounded-3">
                                        </a>
                                    </div>
                                    <div class="card-detail pt-3">
                                        <h3 class="card-title text-uppercase">
                                            <a href="product?action=viewDetail&pID=<%= p.getProductID()%>">
                                                <%=p.getName()%>
                                                <%=p.getVariants().get(0).getColor()%>
                                                <%=p.getVariants().get(0).getStorage()%></a>
                                        </h3>

                                        <!--WISH LIST BUTTON-->
                                        <div class="wishlist-wrap">
                                            <%
                                                Customer u = (Customer) session.getAttribute("user");
                                                boolean logged = (u != null);
                                                boolean liked = false;
                                                int variantID = p.getVariants().get(0).getVariantID();
                                                int productID = p.getProductID();

                                                if (logged && variantID > 0) {
                                                    WishlistDAO wdao = new WishlistDAO();
                                                    liked = wdao.isExist(u.getCustomerID(), productID, variantID);
                                                }
                                            %>

                                            <button class="wishlist-btn toggle-wishlist"
                                                    data-productid="<%= productID %>"
                                                    data-variantid="<%= variantID %>"
                                                    style="background:none; border:none; padding:0;">
                                                <i class="<%= liked ? "fas fa-heart" : "far fa-heart" %>"
                                                   style="<%= liked ? "color:#e53e3e;" : "" %>"></i>
                                            </button>

                                        </div>

                                        <span class="item-price text-primary"><%= vnFormat.format(p.getVariants().get(0).getPrice())%></span>
                                    </div>
                                </div>
                            </div>
                            <%         }
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
                <div class="row pb-3" >
                    <div class="display-header d-flex justify-content-between pb-3">
                        <h2 class="display-7 text-dark text-uppercase">Tablet</h2>
                        <div class="btn-right">
                            <a href="product?action=category&cID=1" class="btn btn-medium btn-normal text-uppercase">Go to Shop</a>
                        </div>
                    </div>

                    <%
                        if (productList1 == null && request.getParameter("fromProduct") == null) {
                            response.sendRedirect(request.getContextPath() + "/product?fromProduct=true");
                            return;
                        }
                    %>

                    <div class="swiper product-swiper">
                        <div class="swiper-wrapper">
                            <%
                                if (productList1 != null) {
                                    for (Products p : productList1) {
                                        if (p.getCategoryID() != null && p.getCategoryID() == 3) {
                            %>
                            <div class="swiper-slide">
                                <div class="product-card text-center position-relative">  <!-- Thêm div này -->
                                    <div class="image-holder">
                                        <a href="product?action=viewDetail&pID=<%= p.getProductID()%>">
                                            <img src="images/<%= p.getVariants().get(0).getImageUrl()%>" alt="<%= p.getName()%>" class="img-fluid rounded-3">
                                        </a>
                                    </div>
                                    <div class="card-detail pt-3">  <!-- Thêm div này -->
                                        <h3 class="card-title text-uppercase">
                                            <a href="product?action=viewDetail&pID=<%= p.getProductID()%>">
                                                <%=p.getName()%>
                                                <%=p.getVariants().get(0).getColor()%>
                                                <%=p.getVariants().get(0).getStorage()%></a>
                                        </h3>

                                        <!--WISH LIST BUTTON-->
                                        <div class="wishlist-wrap">
                                            <%
                                                Customer u = (Customer) session.getAttribute("user");
                                                boolean logged = (u != null);
                                                boolean liked = false;
                                                int variantID = p.getVariants().get(0).getVariantID();
                                                int productID = p.getProductID();

                                                if (logged && variantID > 0) {
                                                    WishlistDAO wdao = new WishlistDAO();
                                                    liked = wdao.isExist(u.getCustomerID(), productID, variantID);
                                                }
                                            %>

                                            <button class="wishlist-btn toggle-wishlist"
                                                    data-productid="<%= productID %>"
                                                    data-variantid="<%= variantID %>"
                                                    style="background:none; border:none; padding:0;">
                                                <i class="<%= liked ? "fas fa-heart" : "far fa-heart" %>"
                                                   style="<%= liked ? "color:#e53e3e;" : "" %>"></i>
                                            </button>

                                        </div>

                                        <span class="item-price text-primary"><%= vnFormat.format(p.getVariants().get(0).getPrice())%></span>
                                    </div>      
                                </div>  
                            </div>
                            <%         }
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </section>



        <section id="yearly-sale" class="bg-light-blue overflow-hidden mt-5 padding-xlarge" 
                 style="background-image: url('images/single-image1.png');background-position: right; background-repeat: no-repeat;">
            <div class="row d-flex flex-wrap align-items-center">
                <div class="col-md-6 col-sm-12">
                    <div class="text-content offset-4 padding-medium">
                        <h3>10% off</h3>
                        <h2 class="display-2 pb-5 text-uppercase text-dark">New year sale</h2>
                        <a href="product?action=category&cID=1&variation=PROMOTION" class="btn btn-medium btn-dark text-uppercase btn-rounded-none">Shop Sale</a>
                    </div>
                </div>
                <div class="col-md-6 col-sm-12"></div>
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
                                        <p>Unless, pure life, now ultrices. Let it be and let it be hendrerit.</p>
                                    </div>
                                </div>
                                <div class="col-lg-2 col-sm-6 pb-3">
                                    <div class="footer-menu text-uppercase">
                                        <h5 class="widget-title pb-2">Quick Links</h5>
                                        <ul class="menu-list list-unstyled text-uppercase">
                                            <li class="menu-item pb-2"><a href="homepage">Home</a></li>
                                            <li class="menu-item pb-2"><a href="#">About</a></li>
                                            <li class="menu-item pb-2"><a href="#">Shop</a></li>
                                            <li class="menu-item pb-2"><a href="#">Contact</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-sm-6 pb-3">
                                    <div class="footer-menu contact-item">
                                        <h5 class="widget-title text-uppercase pb-2">Contact Us</h5>
                                        <p>Do you have any queries? <a href="mailto:">yourinfo@gmail.com</a></p>
                                        <p>Need support? <a href="">+55 111 222 333 44</a></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
        </div>

        <div id="footer-bottom">
            <div class="container">
                <div class="row d-flex flex-wrap justify-content-between">
                    <div class="col-md-4 col-sm-6">
                        <div class="copyright">
                            <p>Copyright 2025 MiniStore.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", () => {

                // N?U Google redirect v? homepage v?i access_token trong URL:
                if (window.location.hash.includes("access_token")) {
                    if (typeof getUserInfor === "function") {
                        getUserInfor();
                    } else {
                        console.error("google_login.js ch?a load ho?c getUserInfor undefined");
                    }
                }

            });
        </script>
        <script>
            document.addEventListener("click", function (e) {
                const btn = e.target.closest(".toggle-wishlist");
                if (!btn)
                    return;

                e.preventDefault();
                e.stopPropagation();

                const productId = btn.dataset.productid;
                const variantId = btn.dataset.variantid || 0;
                const icon = btn.querySelector("i");

                fetch("<%= request.getContextPath() %>/product", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "action=toggleWishlist&productId=" + productId + "&variantId=" + variantId
                })
                        .then(res => {
                            if (res.status === 401) {
                                // Chuyển hướng nếu chưa login
                                window.location.href = 'login.jsp';
                                return Promise.reject("Unauthorized");
                            }
                            if (!res.ok)
                                return Promise.reject("Wishlist toggle failed");
                            return res.text();
                        })
                        .then(text => {
                            if (text === "ok") {
                                if (icon.classList.contains("fas")) {
                                    icon.classList.remove("fas");
                                    icon.classList.add("far");
                                    icon.style.color = "";
                                } else {
                                    icon.classList.remove("far");
                                    icon.classList.add("fas");
                                    icon.style.color = "#e53e3e";
                                }
                            }
                        })
                        .catch(err => console.error(err));
            });
        </script>

        <script src="${pageContext.request.contextPath}/js/google_login.js?v=10"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>
            </body>
</html>