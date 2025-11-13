<%@page import="model.Carts"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.Variants"%>
<%@page import="dao.CategoryDAO"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@ page import="utils.DBContext" %>
<%@ page import="dao.NotificationDAO" %>
<%@ page import="model.Users" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Notification" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>


<!DOCTYPE html>
<html>
    <head>
        <title>Ministore</title>
        <link rel="icon" type="image/x-icon" href="images/favicon.jpg">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="format-detection" content="telephone=no">
        <link rel="icon" type="image/png" href="images/favicon.png">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/home.css">
        <link rel="stylesheet" href="css/notification.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> 
        <script src="js/bootstrap.min.js"></script>
        <script src="js/modernizr.js"></script>
        <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
        <script src="js/plugins.js"></script>
        <script src="js/script.js"></script> 
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            #headerSearchContainer {
                position: relative;
                flex-grow: 1;
                max-width: 300px;
                margin: 0 20px;
            }

            #headerSearchInput {
                width: 100%;
                padding: 10px 45px 10px 20px;
                border: 1px solid #ddd;
                border-radius: 50px;
                font-size: 14px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                outline: none;
            }

            #headerSearchInput:focus {
                box-shadow: 0 4px 10px rgba(0,0,0,0.15);
                border-color: #667eea;
            }

            .header-search-icon-btn {
                position: absolute;
                right: 5px;
                top: 50%;
                transform: translateY(-50%);
                background: #667eea;
                border: none;
                border-radius: 50%;
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s;
            }

            .header-search-icon-btn:hover {
                background: #764ba2;
            }

            .header-search-icon-btn svg {
                width: 16px;
                height: 16px;
                fill: white;
            }

            #headerSearchResults {
                position: absolute;
                top: calc(100% + 5px);
                left: 0;
                width: 100%;
                background-color: #fff;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                z-index: 2000;
                max-height: 400px;
                overflow-y: auto;
                display: none;
            }

            #headerSearchResults.show {
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
            .no-results {
                padding: 20px;
                text-align: center;
                color: #999;
            }
        </style>
    </head>


    <body data-bs-spy="scroll" data-bs-target="#navbar" data-bs-root-margin="0px 0px -40%" data-bs-smooth-scroll="true" tabindex="0">

        <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="search" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
        <title>Search</title>
        <path fill="currentColor" d="M19 3C13.488 3 9 7.488 9 13c0 2.395.84 4.59 2.25 6.313L3.281 27.28l1.439 1.44l7.968-7.969A9.922 9.922 0 0 0 19 23c5.512 0 10-4.488 10-10S24.512 3 19 3zm0 2c4.43 0 8 3.57 8 8s-3.57 8-8 8s-8-3.57-8-8s3.57-8 8-8z" />
    </symbol>
    <symbol xmlns="http://www.w3.org/2000/svg" id="user" viewBox="0 0 16 16">
        <path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H3Zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" />
    </symbol>
    <symbol xmlns="http://www.w3.org/2000/svg" id="cart" viewBox="0 0 16 16">
        <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z" />
    </symbol>
    <symbol xmlns="http://www.w3.org/2000/svg" id="navbar-icon" viewBox="0 0 16 16">
        <path d="M14 10.5a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 .5-.5zm0-3a.5.5 0 0 0-.5-.5h-7a.5.5 0 0 0 0 1h7a.5.5 0 0 0 .5-.5zm0-3a.5.5 0 0 0-.5-.5h-11a.5.5 0 0 0 0 1h11a.5.5 0 0 0 .5-.5z" />
    </symbol>
    <symbol xmlns="http://www.w3.org/2000/svg" id="chevron-left" viewBox="0 0 16 16">
        <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z" />
    </symbol>
    <symbol xmlns="http://www.w3.org/2000/svg" id="chevron-right" viewBox="0 0 16 16">
        <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z" />
    </symbol>
    <symbol xmlns="http://www.w3.org/2000/svg" id="cart-outline" viewBox="0 0 16 16">
        <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .49.598l-1 5a.5.5 0 0 1-.465.401l-9.397.472L4.415 11H13a.5.5 0 0 1 0 1H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l.84 4.479 9.144-.459L13.89 4H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z" />
    </symbol>
    <symbol xmlns="http://www.w3.org/2000/svg" id="quality" viewBox="0 0 16 16">
        <path d="M9.669.864 8 0 6.331.864l-1.858.282-.842 1.68-1.337 1.32L2.6 6l-.306 1.854 1.337 1.32.842 1.68 1.858.282L8 12l1.669-.864 1.858-.282.842-1.68 1.337-1.32L13.4 6l.306-1.854-1.337-1.32-.842-1.68L9.669.864zm1.196 1.193.684 1.365 1.086 1.072L12.387 6l.248 1.506-1.086 1.072-.684 1.365-1.51.229L8 10.874l-1.355-.702-1.51-.229-.684-1.365-1.086-1.072L3.614 6l-.25-1.506 1.087-1.072.684-1.365 1.51-.229L8 1.126l1.356.702 1.509.229z" />
        <path d="M4 11.794V16l4-1 4 1v-4.206l-2.018.306L8 13.126 6.018 12.1 4 11.794z" />
    </symbol>
    <symbol xmlns="http://www.w3.org/2000/svg" id="price-tag" viewBox="0 0 16 16">
        <path d="M6 4.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm-1 0a.5.5 0 1 0-1 0 .5.5 0 0 0 1 0z" />
        <path d="M2 1h4.586a1 1 0 0 1 .707.293l7 7a1 1 0 0 1 0 1.414l-4.586 4.586a1 1 0 0 1-1.414 0l-7-7A1 1 0 0 1 1 6.586V2a1 1 0 0 1 1-1zm0 5.586 7 7L13.586 9l-7-7H2v4.586z" />
    </symbol>
    <symbol xmlns="http://www.w3.org/2000/svg" id="shield-plus" viewBox="0 0 16 16">
        <path d="M5.338 1.59a61.44 61.44 0 0 0-2.837.856.481.481 0 0 0-.328.39c-.554 4.157.726 7.19 2.253 9.188a10.725 10.725 0 0 0 2.287 2.233c.346.244.652.42.893.533.12.057.218.095.293.118a.55.55 0 0 0 .101.025.615.615 0 0 0 .1-.025c.076-.023.174-.061.294-.118.24-.113.547-.29.893-.533a10.726 10.726 0 0 0 2.287-2.233c1.527-1.997 2.807-5.031 2.253-9.188a.48.48 0 0 0-.328-.39c-.651-.213-1.75-.56-2.837-.855C9.552 1.29 8.531 1.067 8 1.067c-.53 0-1.552.223-2.662.524zM5.072.56C6.157.265 7.31 0 8 0s1.843.265 2.928.56c1.11.3 2.229.655 2.887.87a1.54 1.54 0 0 1 1.044 1.262c.596 4.477-.787 7.795-2.465 9.99a11.775 11.775 0 0 1-2.517 2.453 7.159 7.159 0 0 1-1.048.625c-.28.132-.581.24-.829.24s-.548-.108-.829-.24a7.158 7.158 0 0 1-1.048-.625 11.777 11.777 0 0 1-2.517-2.453C1.928 10.487.545 7.169 1.141 2.692A1.54 1.54 0 0 1 2.185 1.43 62.456 62.456 0 0 1 5.072.56z" />
        <path d="M8 4.5a.5.5 0 0 1 .5.5v1.5H10a.5.5 0 0 1 0 1H8.5V9a.5.5 0 0 1-1 0V7.5H6a.5.5 0 0 1 0-1h1.5V5a.5.5 0 0 1 .5-.5z" />
    </symbol>
    </svg> 
    <header id="header" class="site-header position-fixed">
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
                        <a class="navbar-brand" href="homepage">
                            <img src="images/main-logo.png" class="logo">
                        </a>
                        <button type="button" class="btn-close btn-close-black" data-bs-dismiss="offcanvas" aria-label="Close" data-bs-target="#bdNavbar"></button>
                    </div>
                    <%
                        CategoryDAO ctDAO = new CategoryDAO();

                        List<Category> listCategory = ctDAO.getAllCategories();
                        String currentAction = request.getParameter("action");
                        String currentCategoryId = request.getParameter("cID");
                    %>
                    <div class="offcanvas-body">
                        <ul id="navbar" class="navbar-nav text-uppercase justify-content-end align-items-center flex-grow-1 pe-3">
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= (currentAction == null || currentAction.equals("")) ? "active" : ""%>" 
                                   href="homepage" data-category="all">Home</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= ("3".equals(currentCategoryId)) ? "active" : ""%>" 
                                   href="product?action=category&cID=3" data-category="3">Tablet</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= ("1".equals(currentCategoryId)) ? "active" : ""%>" 
                                   href="product?action=category&cID=1" data-category="1">Phone</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= ("2".equals(currentCategoryId)) ? "active" : ""%>" 
                                   href="product?action=category&cID=2" data-category="2">Smartwatch</a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link me-4 dropdown-toggle link-dark" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false">Accessories</a>
                                <ul class="dropdown-menu">
                                    <%
                                        if (listCategory != null) {
                                            for (Category c : listCategory) {
                                                if (c.getCategoryId() > 3) {
                                    %>
                                    <li>
                                        <a href="product?action=category&cID=<%= c.getCategoryId()%>" 
                                           class="dropdown-item" 
                                           data-category="<%= c.getCategoryId()%>">
                                            <%= c.getCategoryName()%>
                                        </a>
                                    </li>
                                    <%
                                                }
                                            }
                                        }
                                    %>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <%-- Ki?m tra n?u action hi?n t?i là "viewpromotion" thì thêm class "active" --%>
                                <a class="nav-link me-4 <%= ("viewpromotion".equals(currentAction)) ? "active" : ""%>"
                                   href="homepage?action=viewpromotion">View Hot Promotions</a> <%-- Link ??n servlet v?i action=viewpromotion --%>
                            </li>
                            <li class="nav-item flex-grow-1"> 
                                <div id="headerSearchContainer">
                                    <%
                                        List<Products> header_productList = (List<Products>) application.getAttribute("globalProductList");
                                        List<Variants> header_variantsList = (List<Variants>) application.getAttribute("globalVariantsList");

                                        Map<Integer, String> header_productNameMap = new HashMap<>();
                                        Map<Integer, Integer> header_productCategoryMap = new HashMap<>();

                                        if (header_productList != null) {
                                            for (Products p : header_productList) {
                                                header_productNameMap.put(p.getProductID(), p.getName());
                                                header_productCategoryMap.put(p.getProductID(), p.getCategoryID());
                                            }
                                        }
                                    %>

                                    <input type="text" id="headerSearchInput" placeholder="Search for products..." autocomplete="off">
                                    <button class="header-search-icon-btn" type="button">
                                        <svg class="search"><use xlink:href="#search"></use></svg>
                                    </button>

                                    <div id="headerSearchResults">
                                        <%
                                            if (header_variantsList != null && !header_productNameMap.isEmpty()) {
                                                for (Variants v : header_variantsList) {
                                                    String productName = header_productNameMap.get(v.getProductID());
                                                    Integer categoryID = header_productCategoryMap.get(v.getProductID());
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
                            </li>


                            <div class="user-items ps-5">
                                <ul class="d-flex justify-content-end list-unstyled align-items-center">
                                    <%
                                        model.Users user = (model.Users) session.getAttribute("user");
                                        boolean isLoggedIn = (user != null);
                                        String displayName = "";
                                        List<Carts> carts = (List<Carts>) session.getAttribute("cart");
                                        if (isLoggedIn) {
                                            if (user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
                                                displayName = user.getFullName();
                                            } else {
                                                displayName = user.getEmail();
                                            }
                                    %>
                                    <li class="pe-3">
                                        <form action="cart" method="get" class="d-inline-block position-relative">
                                            <input type="hidden" name="userID" value="<%=user.getUserId()%>">
                                            <button type="submit" class="position-relative border-0 bg-transparent p-0">
                                                <i class="bi bi-cart text-dark fs-4"></i>
                                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"><%=carts.size()%></span>
                                            </button>
                                        </form>
                                    </li>


                                    <li class="pe-3 position-relative">
                                        <button id="notification-bell" class="btn p-0 border-0 bg-transparent position-relative">
                                            <i class="bi bi-bell fs-4"></i>
                                        </button>

                                        <div id="notification-dropdown" class="notification-dropdown shadow rounded">
                                            <%
                                                // K?t n?i DB tr?c ti?p
                                                try (Connection conn = new DBContext().conn) {
                                                    NotificationDAO dao = new NotificationDAO(conn);

                                                    // Hardcode userID = 1 (ho?c l?y t? session n?u mu?n)
                                                    List<Notification> notifications = dao.getNotificationsByUser(1);

                                                    if(notifications != null && !notifications.isEmpty()) {
                                                        for(Notification n : notifications) {
                                            %>
                                            <div class="notification-item" style="border:1px solid #ccc; border-radius:8px; padding:8px; margin-bottom:8px;">
                                                <p style="margin:0;font-size:14px;"><%= n.getContent() %></p>
                                                <small style="color:gray;"><%= n.getCreatedAt() %></small>
                                            </div>
                                            <%
                                                        }
                                                    } else {
                                            %>
                                            <div style="padding:10px;text-align:center;color:gray;">Không có thông báo</div>
                                            <%
                                                    }

                                                } catch(Exception e) {
                                                    out.println("<div style='padding:10px;color:red;'>L?i load thông báo</div>");
                                                    e.printStackTrace();
                                                }
                                            %>
                                        </div>
                                    </li>

                                    <li class="pe-3">
                                        <a href="logout" class="nav-link p-0 text-dark text-uppercase fw-bold">Logout</a> 
                                    </li>
                                    <li class="text-dark fw-bold">

                                        <a href="user?action=view" class="nav-link p-0 text-dark text-uppercase fw-bold"><%= displayName%></a> 


                                    </li>
                                    <%
                                    } else {
                                    %>
                                    <li class="pe-3">
                                        <a href="login" class="nav-link p-0 text-dark text-uppercase fw-bold">Login/Register</a>
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

    <form id="productSearchForm" action="product" method="GET" style="display:none;">
        <input type="hidden" name="action" value="selectStorage">
        <input type="hidden" name="pID" id="formPID">
        <input type="hidden" name="cID" id="formCID">
        <input type="hidden" name="storage" id="formStorage">
        <input type="hidden" name="color" id="formColor">
    </form>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const headerSearchInput = document.getElementById('headerSearchInput');
            const headerSearchResults = document.getElementById('headerSearchResults');
            const headerSearchContainer = document.getElementById('headerSearchContainer');
            const headerAllSuggestionItems = headerSearchResults.querySelectorAll('.suggestion-item');

            // Hi?n th? g?i ý khi gõ
            headerSearchInput.addEventListener('keyup', function () {
                const query = headerSearchInput.value.toLowerCase().trim();
                let hasResults = false;

                if (query.length > 0) {
                    headerAllSuggestionItems.forEach(item => {
                        const productName = item.dataset.productname.toLowerCase();
                        const itemText = item.textContent.toLowerCase();

                        if (productName.includes(query) || itemText.includes(query)) {
                            item.style.display = 'flex';
                            hasResults = true;
                        } else {
                            item.style.display = 'none';
                        }
                    });

                    let noResultDiv = headerSearchResults.querySelector('.no-results');
                    if (hasResults) {
                        if (noResultDiv)
                            noResultDiv.style.display = 'none';
                    } else {
                        if (!noResultDiv) {
                            noResultDiv = document.createElement('div');
                            noResultDiv.className = 'no-results';
                            headerSearchResults.appendChild(noResultDiv);
                        }
                        noResultDiv.textContent = 'No products found';
                        noResultDiv.style.display = 'block';
                    }
                    headerSearchResults.classList.add('show');
                } else {
                    headerSearchResults.classList.remove('show');
                    headerAllSuggestionItems.forEach(item => {
                        item.style.display = 'none';
                    });
                }
            });

            // Click vào suggestion
            headerAllSuggestionItems.forEach(item => {
                item.addEventListener('click', function () {
                    document.getElementById('formPID').value = this.dataset.pid;
                    document.getElementById('formCID').value = this.dataset.cid;
                    document.getElementById('formStorage').value = this.dataset.storage;
                    document.getElementById('formColor').value = this.dataset.color;
                    document.getElementById('productSearchForm').submit();
                });
            });

            // Enter ?? ch?n suggestion ??u tiên
            headerSearchInput.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    const firstVisible = Array.from(headerAllSuggestionItems).find(
                            item => item.style.display === 'flex'
                    );
                    if (firstVisible)
                        firstVisible.click();
                }
            });

            // Click outside ?? ?óng results
            document.addEventListener('click', function (e) {
                if (headerSearchContainer && !headerSearchContainer.contains(e.target)) {
                    headerSearchResults.classList.remove('show');
                }
            });
        });


    </script>
    <script>

// === CODE THÊM N?N TR?NG KHI CU?N ===
        (function () {
            // L?y ra ph?n header
            const header = document.querySelector('header.site-header');

            // ??t ng??ng cu?n (tính b?ng pixel), ví d? 50px
            // T?c là cu?n xu?ng 50px thì n?n s? ??i
            const scrollThreshold = 50;

            if (!header) {
                return; // D?ng l?i n?u không tìm th?y header
            }

            // L?ng nghe s? ki?n cu?n trang
            window.addEventListener('scroll', function () {
                // L?y v? trí cu?n hi?n t?i
                let scrollTop = window.pageYOffset || document.documentElement.scrollTop;

                // N?u cu?n qua ng??ng
                if (scrollTop > scrollThreshold) {
                    header.classList.add('header-scrolled');
                }
                // N?u cu?n ng??c l?i lên trên cùng
                else {
                    header.classList.remove('header-scrolled');
                }
            });
        })();

        document.addEventListener("DOMContentLoaded", function () {
            const bell = document.getElementById("notification-bell");
            const dropdown = document.getElementById("notification-dropdown");

            bell.addEventListener("click", function (e) {
                e.stopPropagation(); // tránh click ra ngoài ?óng ngay
                dropdown.classList.toggle("show"); // b?t/t?t dropdown
            });

            // Click ra ngoài ?? ?óng
            document.addEventListener("click", function (e) {
                if (!dropdown.contains(e.target) && !bell.contains(e.target)) {
                    dropdown.classList.remove("show");
                }
            });
        });
    </script>
</body>
</html>