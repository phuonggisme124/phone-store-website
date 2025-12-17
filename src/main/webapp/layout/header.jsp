<%@page import="model.Notification"%>
<%@page import="dao.NotificationDAO"%>
<%@page import="java.sql.Connection"%>
<%@page import="utils.DBContext"%>
<%@page import="model.Carts"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.Variants"%>
<%@page import="dao.CategoryDAO"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@ page import="model.Customer" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Ministore</title>
        <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.jpg">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="format-detection" content="telephone=no">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notification.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> 
        <script src="${pageContext.request.contextPath}/js/modernizr.js"></script>
        <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/plugins.js"></script>
        <script src="${pageContext.request.contextPath}/js/script.js"></script> 
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
    <symbol xmlns="http://www.w3.org/2000/svg" id="navbar-icon" viewBox="0 0 16 16">
        <path d="M14 10.5a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 .5-.5zm0-3a.5.5 0 0 0-.5-.5h-7a.5.5 0 0 0 0 1h7a.5.5 0 0 0 .5-.5zm0-3a.5.5 0 0 0-.5-.5h-11a.5.5 0 0 0 0 1h11a.5.5 0 0 0 .5-.5z" />
    </symbol>
    </svg> 

    <header id="header" class="site-header position-fixed">
        <nav id="header-nav" class="navbar navbar-expand-lg px-3 mb-3">
            <div class="container-fluid">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/homepage">
                    <img src="${pageContext.request.contextPath}/images/main-logo.png" class="logo">
                </a>

                <button class="navbar-toggler d-flex d-lg-none order-3 p-2" type="button" data-bs-toggle="offcanvas" data-bs-target="#bdNavbar" aria-controls="bdNavbar" aria-expanded="false" aria-label="Toggle navigation">
                    <svg class="navbar-icon">
                    <use xlink:href="#navbar-icon"></use>
                    </svg>
                </button>

                <div class="offcanvas offcanvas-end" tabindex="-1" id="bdNavbar" aria-labelledby="bdNavbarOffcanvasLabel">
                    <div class="offcanvas-header px-4 pb-0">
                        <a class="navbar-brand" href="${pageContext.request.contextPath}/homepage">
                            <img src="${pageContext.request.contextPath}/images/main-logo.png" class="logo">
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
                                   href="${pageContext.request.contextPath}/homepage" data-category="all">Home</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= ("3".equals(currentCategoryId)) ? "active" : ""%>" 
                                   href="${pageContext.request.contextPath}/product?action=category&cID=3" data-category="3">Tablet</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= ("1".equals(currentCategoryId)) ? "active" : ""%>" 
                                   href="${pageContext.request.contextPath}/product?action=category&cID=1" data-category="1">Phone</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= ("2".equals(currentCategoryId)) ? "active" : ""%>" 
                                   href="${pageContext.request.contextPath}/product?action=category&cID=2" data-category="2">Smartwatch</a>
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
                                        <a href="${pageContext.request.contextPath}/product?action=category&cID=<%= c.getCategoryId()%>" 
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
                                <a class="nav-link me-4 <%= ("viewpromotion".equals(currentAction)) ? "active" : ""%>"
                                   href="${pageContext.request.contextPath}/homepage?action=viewpromotion">View Hot Promotions</a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="voucher?action=viewMyVouchers">
                                    <i class="fas fa-ticket-alt me-2"></i> Voucher
                                </a>
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
                                            <img src="${pageContext.request.contextPath}/images/<%= image%>" width="50" height="50" alt="<%= productName%>">
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
                                        model.Customer user = (model.Customer) session.getAttribute("user");
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
                                        <form action="${pageContext.request.contextPath}/cart" method="get" class="d-inline-block position-relative">
                                            <input type="hidden" name="userID" value="<%=user.getCustomerID()%>">
                                            <button type="submit" class="position-relative border-0 bg-transparent p-0">
                                                <i class="bi bi-cart text-dark fs-4"></i>
                                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"><%=carts != null ? carts.size() : 0%></span>
                                            </button>
                                        </form>
                                    </li>

                                    <li class="pe-3 position-relative">
                                        <button id="notification-bell" class="btn p-0 border-0 bg-transparent position-relative">
                                            <i class="bi bi-bell fs-4"></i>
                                            <span id="notifCount" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                                0
                                            </span>
                                        </button>

                                        <div id="notification-dropdown" class="notification-dropdown shadow rounded">
                                            <%
                                                try (Connection conn = new DBContext().conn) {
                                                    NotificationDAO dao = new NotificationDAO(conn);

                                                    Customer currentUser = (Customer) session.getAttribute("user");
                                                    int userId = (currentUser != null) ? currentUser.getCustomerID() : 1;

                                                    List<Notification> notifications = dao.getNotificationsByUser(userId);

                                                    if(notifications != null && !notifications.isEmpty()) {
                                                        for(Notification n : notifications) {
                                            %>
                                            <div class="notification-item" style="border:1px solid #ccc; border-radius:8px; padding:8px; margin-bottom:8px;">
                                                <p style="margin:0;font-size:14px; color: black;"><%= n.getContent() %></p>
                                                <small style="color:gray;"><%= n.getCreatedAt() %></small>
                                            </div>
                                            <%
                                                        }
                                                    } else {
                                            %>
                                            <div style="padding:10px;text-align:center;color:gray;">No notifications</div>
                                            <%
                                                    }

                                                    int unreadCount = dao.countUnread(userId);
                                            %>
                                            <script>
                                                document.getElementById('notifCount').innerText = '<%= unreadCount %>';
                                            </script>
                                            <%
                                                } catch(Exception e) {
                                                    out.println("<div style='padding:10px;color:red;'>Error loading notifications</div>");
                                                    e.printStackTrace();
                                                }
                                            %>
                                        </div>
                                    </li>

                                    <li class="pe-3">
                                        <a href="${pageContext.request.contextPath}/logout" class="nav-link p-0 text-dark text-uppercase fw-bold">Logout</a> 
                                    </li>
                                    <li class="text-dark fw-bold">
                                        <a href="${pageContext.request.contextPath}/customer?action=view" class="nav-link p-0 text-dark text-uppercase fw-bold"><%= displayName%></a> 
                                    </li>
                                    <%
                                    } else {
                                    %>
                                    <li class="pe-3">
                                        <a href="${pageContext.request.contextPath}/login" class="nav-link p-0 text-dark text-uppercase fw-bold">Login/Register</a>
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

    <form id="productSearchForm" action="${pageContext.request.contextPath}/product" method="GET" style="display:none;">
        <input type="hidden" name="action" value="selectStorage">
        <input type="hidden" name="pID" id="formPID">
        <input type="hidden" name="cID" id="formCID">
        <input type="hidden" name="storage" id="formStorage">
        <input type="hidden" name="color" id="formColor">
    </form>

    <script>
        // SCRIPT LOGIC GIỮ NGUYÊN NHƯNG ĐÃ ĐƯỢC CHUẨN HÓA VỚI JS HIỆN Đ� I
        document.addEventListener("DOMContentLoaded", function () {
            const headerSearchInput = document.getElementById('headerSearchInput');
            const headerSearchResults = document.getElementById('headerSearchResults');
            const headerSearchContainer = document.getElementById('headerSearchContainer');
            const headerAllSuggestionItems = headerSearchResults.querySelectorAll('.suggestion-item');


            headerSearchInput.addEventListener('keyup', function () {
                const query = headerSearchInput.value.toLowerCase().trim();
                let hasResults = false;

                if (query.length > 0) {
                    headerAllSuggestionItems.forEach(item => {
                        const productName = item.dataset.productname.toLowerCase();
                        if (productName.includes(query)) {
                            item.style.display = 'flex';
                            hasResults = true;
                        } else {
                            item.style.display = 'none';
                        }
                    });
                    headerSearchResults.classList.add('show');
                } else {
                    headerSearchResults.classList.remove('show');
                }
            });


            headerAllSuggestionItems.forEach(item => {
                item.addEventListener('click', function () {
                    document.getElementById('formPID').value = this.dataset.pid;
                    document.getElementById('formCID').value = this.dataset.cid;
                    document.getElementById('formStorage').value = this.dataset.storage;
                    document.getElementById('formColor').value = this.dataset.color;
                    document.getElementById('productSearchForm').submit();
                });
            });


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



            document.addEventListener('click', function (e) {
                if (headerSearchContainer && !headerSearchContainer.contains(e.target)) {
                    headerSearchResults.classList.remove('show');
                }
            });
        });


    </script>
    <script>


        (function () {

            const header = document.querySelector('header.site-header');


            const scrollThreshold = 50;

            if (!header) {
                return;
            }


            window.addEventListener('scroll', function () {

                let scrollTop = window.pageYOffset || document.documentElement.scrollTop;


                if (scrollTop > scrollThreshold) {
                    header.classList.add('header-scrolled');
                } else {

                    header.classList.remove('header-scrolled');
                }
            });
        })();


        document.addEventListener("DOMContentLoaded", function () {
            const bell = document.getElementById("notification-bell");
            const dropdown = document.getElementById("notification-dropdown");

            bell.addEventListener("click", function (e) {
                e.stopPropagation();
                const dropdown = document.getElementById("notification-dropdown");
                dropdown.classList.toggle("show");

                if (dropdown.classList.contains("show")) {
                    fetch('notification', {
                        method: 'POST'
                    })
                            .then(res => res.text())
                            .then(data => {
                                if (data === 'success') {
                                    notifCount.innerText = '0'; // ?n badge
                                }
                            });
                }
            });



            document.addEventListener("click", function (e) {
                if (!dropdown.contains(e.target) && !bell.contains(e.target)) {
                    dropdown.classList.remove("show");
                }
            });
        });

    </script>

</body>
</html>

