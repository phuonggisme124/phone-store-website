<%@page import="java.util.ArrayList"%>
<%@page import="model.Promotions"%>
<%@page import="dao.PromotionsDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.ReviewDAO"%>
<%@page import="dao.VariantsDAO"%>
<%@page import="model.Review"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>

<%@page import="dao.WishlistDAO"%>


<%
    // Lấy Context Path của ứng dụng web
    String contextPath = request.getContextPath();
%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="css/home.css">
<link rel="stylesheet" href="css/compare.css">

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="/layout/header.jsp" %>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Sản Phẩm</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        fontFamily: {
                            'sans': ['Inter', 'sans-serif']
                        },
                        colors: {
                            'custom-accent': '#72AEC8',
                            'custom-accent-hover': '#639bba'
                        }
                    }
                }
            }
        </script>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                background-color: #f3f4f6;
            }
            .discount-tag {
                position: absolute;
                top: 10px;
                left: -5px;
                background-color: #ef4444;
                color: white;
                font-weight: bold;
                padding: 4px 12px 4px 18px;
                border-radius: 4px;
                font-size: 0.75rem;
                line-height: 1rem;
                z-index: 10;
                display: flex;
                align-items: center;
            }
            .discount-tag::before {
                content: '';
                position: absolute;
                top: 0;
                left: -10px;
                border-width: 13px 10px 13px 0;
                border-style: solid;
                border-color: transparent #ef4444 transparent transparent;
            }

            #searchSection {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 40px 0;
                margin-bottom: 30px;
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
        </style>
    </head>

    <body class="bg-gray-100 text-gray-900 font-sans">

        <%            String categoryName = "All Products";

            if ("1".equals(currentCategoryId)) {
                categoryName = "Phone";
            } else if ("2".equals(currentCategoryId)) {
                categoryName = "Smartwatch";
            } else if ("3".equals(currentCategoryId)) {
                categoryName = "Tablet";
            } else if ("5".equals(currentCategoryId)) {
                categoryName = "Phone Case";
            }
        %>

        <section id="searchSection" style="padding-top: 100px;">
            <div class="container">
                <div class="row">
                    <div class="col-12 text-center mb-3">
                        <h2 class="text-white">Find Your Perfect <%= categoryName%></h2>
                        <span class="search-category-badge" id="categoryBadge">Searching in: <%= categoryName%></span>
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
                            <input type="text" id="searchInput" placeholder="Search for <%= categoryName.toLowerCase()%>..." autocomplete="off">
                            <button class="search-icon-btn" type="button">
                                <i class="fa-solid fa-magnifying-glass text-white"></i>
                            </button>

                            <div id="searchResults">
                                <%
                                    if (variantsList_search != null && !productNameMap_search.isEmpty()) {
                                        for (Variants v : variantsList_search) {
                                            String productName = productNameMap_search.get(v.getProductID());
                                            Integer categoryID = productCategoryMap_search.get(v.getProductID());
                                            if (productName != null && categoryID != null) {
                                                String image = "";
                                                if (v.getImageList() != null && v.getImageList().length > 0) {
                                                    String raw = v.getImageList()[0];
                                                    image = raw.contains("#") ? raw.split("#")[0] : raw;
                                                }
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
                                    <img src="images/<%= image%>" width="50" height="50" alt="<%= productName%>" class="object-cover">
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
                const searchContainer = document.getElementById('searchContainer');

                let currentCategory = '<%= currentCategoryId != null ? currentCategoryId : "all"%>';

                const categoryNames = {
                    'all': 'All Products',
                    '1': 'Phone',
                    '2': 'Smartwatch',
                    '3': 'Tablet',
                    '5': 'Phone Case'
                };

                categoryBadge.textContent = 'Searching in: ' + (categoryNames[currentCategory] || 'All Products');

                // Filter suggestions by category
                function filterByCategory(items) {
                    items.forEach(item => {
                        const itemCategory = item.dataset.cid;
                        item.dataset.categoryMatch = (currentCategory === 'all' || itemCategory === currentCategory) ? 'true' : 'false';
                    });
                }

                filterByCategory(allSuggestionItems);

                // Search logic
                searchInput.addEventListener('keyup', function () {
                    const query = searchInput.value.toLowerCase().trim();
                    let hasResults = false;

                    let noResultDiv = searchResults.querySelector('.no-results');
                    if (noResultDiv)
                        noResultDiv.style.display = 'none';

                    if (query.length > 0) {
                        allSuggestionItems.forEach(item => {
                            const text = item.textContent.toLowerCase();
                            const match = item.dataset.categoryMatch === 'true' && text.includes(query);
                            item.style.display = match ? 'flex' : 'none';
                            hasResults = hasResults || match;
                        });

                        searchResults.classList.add('show');
                        if (!hasResults) {
                            if (!noResultDiv) {
                                noResultDiv = document.createElement('div');
                                noResultDiv.className = 'no-results';
                                searchResults.appendChild(noResultDiv);
                            }
                            noResultDiv.textContent = 'No products found';
                            noResultDiv.style.display = 'block';
                        }
                    } else {
                        searchResults.classList.remove('show');
                        allSuggestionItems.forEach(item => item.style.display = 'none');
                    }
                });

                allSuggestionItems.forEach(item => {
                    item.addEventListener('click', function () {
                        document.getElementById('formPID').value = this.dataset.pid;
                        document.getElementById('formCID').value = this.dataset.cid;
                        document.getElementById('formStorage').value = this.dataset.storage;
                        document.getElementById('formColor').value = this.dataset.color;
                        document.getElementById('productSearchForm').submit();
                    });
                });

                document.addEventListener('click', function (e) {
                    if (!searchContainer.contains(e.target)) {
                        searchResults.classList.remove('show');
                    }
                });
            });
        </script>

        <div class="container max-w-7xl mx-auto p-4 sm:p-6">

            <%
                String currentVariation = request.getParameter("variation");
                if (currentVariation == null || currentVariation.isEmpty()) {
                    currentVariation = "ALL";
                }
                boolean isPromotionFilterActive = "PROMOTION".equals(currentVariation);
            %>

            <div class="mb-4">
                <h2 class="text-lg font-semibold text-gray-900 mb-3">Filter By</h2>
                <div class="flex flex-wrap gap-2 items-center">

                    <form action="product" method="get" class="flex flex-wrap gap-2 items-center">
                        <input type="hidden" name="action" value="category">
                        <input type="hidden" name="cID" value="${categoryID}">

                        <button name="variation" value="ALL" type="submit"
                                class="px-4 py-1.5 text-sm font-medium rounded-full flex items-center gap-1.5 <%= "ALL".equals(currentVariation) ? "bg-custom-accent text-white" : "bg-white text-gray-800 border border-gray-300"%>">
                            <i class="fa-solid fa-star fa-xs"></i> Popular
                        </button>

                        <button name="variation" value="PROMOTION" type="submit"
                                class="px-4 py-1.5 text-sm font-medium rounded-full flex items-center gap-1.5 <%= isPromotionFilterActive ? "bg-custom-accent text-white" : "bg-white text-gray-800 border border-gray-300"%>">
                            <i class="fa-solid fa-fire-flame-curved fa-xs"></i> HOT Promotion
                        </button>

                        <button name="variation" value="ASC" type="submit"
                                class="px-4 py-1.5 text-sm font-medium rounded-full flex items-center gap-1.5 <%= "ASC".equals(currentVariation) ? "bg-custom-accent text-white" : "bg-white text-gray-800 border border-gray-300"%>">
                            <i class="fa-solid fa-arrow-up-wide-short fa-xs"></i> Low - High Price
                        </button>

                        <button name="variation" value="DESC" type="submit"
                                class="px-4 py-1.5 text-sm font-medium rounded-full flex items-center gap-1.5 <%= "DESC".equals(currentVariation) ? "bg-custom-accent text-white" : "bg-white text-gray-800 border border-gray-300"%>">
                            <i class="fa-solid fa-arrow-down-wide-short fa-xs"></i> High - Low Price
                        </button>
                    </form>
                </div>
            </div>

            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                <%
                    List<Products> listProduct = (List<Products>) request.getAttribute("listProduct");
                    List<Variants> listVariant = (List<Variants>) request.getAttribute("listVariant");
                    ReviewDAO rDAO = new ReviewDAO();
                    NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                    PromotionsDAO prDAO = new PromotionsDAO();

                    List<Promotions> promotionsList = (List<Promotions>) request.getAttribute("promotionsList");

                    if (isPromotionFilterActive) {
                        List<Variants> listVariantFiltered = new ArrayList<>();

                        if (promotionsList != null && !promotionsList.isEmpty() && listVariant != null) {
                            for (Variants v : listVariant) {
                                for (Promotions promotion : promotionsList) {
                                    if (v.getProductID() == promotion.getProductID() && "active".equalsIgnoreCase(promotion.getStatus())) {
                                        listVariantFiltered.add(v);
                                        break;
                                    }
                                }
                            }
                        }
                        listVariant = listVariantFiltered;
                    }

                    if (listVariant != null && !listVariant.isEmpty() && listProduct != null) {
                        for (Variants v : listVariant) {
                            double rating = 0;
                            String image = "";
                            if (v.getImageList() != null && v.getImageList().length > 0) {
                                String raw = v.getImageList()[0];
                                image = raw.contains("#") ? raw.split("#")[0] : raw;
                            }
                            String pName = "";
                            for (Products p : listProduct) {
                                if (p.getProductID() == v.getProductID()) {
                                    pName = p.getName();
                                    break;
                                }
                            }

                            List<Review> listReviewByVariantID = rDAO.getReviewsByVariantID(v.getVariantID());
                            Promotions pr = prDAO.getPromotionByProductID(v.getProductID());

                            if (listReviewByVariantID != null && !listReviewByVariantID.isEmpty()) {
                                for (Review r : listReviewByVariantID) {
                                    rating += r.getRating();
                                }
                                rating = rating / listReviewByVariantID.size();
                            }
                %>

                <div class="bg-white rounded-2xl shadow-md overflow-hidden flex flex-col transition duration-300 hover:scale-[1.02] hover:shadow-lg">
                    <div class="relative">
                        <a href="product?action=viewDetail&vID=<%=v.getVariantID()%>&pID=<%=v.getProductID()%>" class="block w-full aspect-square overflow-hidden">
                            <img class="w-full h-full object-cover transition-transform duration-300 hover:scale-110"
                                 src="images/<%=image%>"
                                 alt="<%=pName%>">
                        </a>

                        <% if (pr != null && pr.getDiscountPercent() > 0 && "active".equalsIgnoreCase(pr.getStatus())) {%>
                        <div class="discount-tag">Giảm <%=pr.getDiscountPercent()%>%</div>
                        <% }%>
                    </div>

                    <div class="p-4 flex flex-col flex-grow">
                        <a href="product?action=viewDetail&vID=<%=v.getVariantID()%>&pID=<%=v.getProductID()%>">
                            <h3 class="font-bold text-base mb-2 text-gray-900 h-12 overflow-hidden">
                                <%=pName%> <%=v.getStorage()%> <%=v.getColor()%>
                            </h3>
                        </a>

                        <div class="mb-2">
                            <span class="text-red-500 font-bold text-lg">
                                <%=vnFormat.format(v.getDiscountPrice())%>
                            </span>
                            <% if (v.getPrice() > v.getDiscountPrice()) {%>
                            <span class="text-gray-500 line-through text-sm ml-2">
                                <%=vnFormat.format(v.getPrice())%>
                            </span>
                            <% }%>
                        </div>

                        <div class="flex flex-wrap gap-2 mb-3 text-xs">
                            <span class="bg-gray-200 px-2 py-0.5 rounded text-gray-700"><%=v.getStorage()%></span>                       
                        </div>


                        <div class="mt-auto flex justify-between items-center text-sm pt-2">
                            <% if (rating > 0) {%>
                            <div class="flex items-center gap-1 text-yellow-500">
                                <i class="fa-solid fa-star"></i>
                                <span class="font-semibold text-gray-800"><%=String.format("%.1f", rating)%></span>
                            </div>
                            <% } else { %>
                            <span class="text-gray-500 text-xs">Be the first to review this product.</span>
                            <% } %>
                            <!--
                                                        <div class="wishlist-wrap">
                            <%
                                // 1. Tìm đối tượng Products (rp) tương ứng với Variant v
                                Products rp = null;
                                for (Products prod : listProduct) {
                                    if (prod.getProductID() == v.getProductID()) {
                                        rp = prod;
                                        break;
                                    }
                                }

                                Customer u = (Customer) session.getAttribute("user");
                                boolean logged = (u != null);
                                boolean liked = false;
                                int variantID = -1;

                                int productID = 0;
                                if (rp != null) {
                                    variantID = v.getVariantID(); // Lấy VariantID từ đối tượng v hiện tại
                                    productID = rp.getProductID(); // Lấy ProductID từ đối tượng rp đã tìm thấy

                                    if (logged && variantID > 0) {
                                        try {
                                            WishlistDAO wdao = new WishlistDAO();
                                            // Sử dụng ProductID của rp và VariantID của v
                                            liked = wdao.isExist(u.getCustomerID(), productID, variantID); 
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            %>
                            <% if (variantID > 0) { %>
                            <% if (logged) { %>
                            <button class="wishlist-btn toggle-wishlist"
                                    data-productid="<%= productID %>"
                                    data-variantid="<%= variantID %>"
                                    style="position:absolute; top:40px; right:10px; background:none; border:none; padding:0; z-index:10;">
                                <i class="<%= liked ? "fas fa-heart" : "far fa-heart" %>"
                                   style="<%= liked ? "color:#e53e3e; font-size:1.5rem;" : "font-size:1.5rem;" %>"></i>
                            </button>
                            <% } else { %>
                            <button class="wishlist-btn" 
                                    data-productid="<%= rp != null ? rp.getProductID() : 0 %>" 
                                    data-variantid="<%= variantID %>"
                                    data-login-required="true"
                                    style="background:none; border:none; padding:0;">
                                <i class="far fa-heart"></i> 
                            </button>
                            <% } %>
                            <% } %>
                        </div>
                            -->

                            <%
     // 1. Tìm sản phẩm rp tương ứng
     rp = null;
     for (Products prod : listProduct) {
         if (prod.getProductID() == v.getProductID()) {
             rp = prod;
             break;
         }
     }

     // 2. Các biến dùng cho nút compare
     String variantIDStr = String.valueOf(v.getVariantID());
     String productIDStr = String.valueOf(v.getProductID());
     String productNameFull = pName + " " + v.getStorage() + " " + v.getColor();

     // 3. Xử lý ảnh
     String imageURL = contextPath + "/images/no-image.png"; // default
     if (v.getImageList() != null && v.getImageList().length > 0) {
         String imageName = v.getImageList()[0];
         if (imageName.startsWith("/")) {
             imageURL = imageName;
         } else {
             imageURL = contextPath + "/images/" + imageName;
         }
     }
                            %>
                            <button class="compare-btn"
                                    data-variantid="<%= variantIDStr %>"
                                    data-productid="<%= productIDStr %>"
                                    data-name="<%= productNameFull %>"
                                    data-image="<%= imageURL %>">
                                <i class="fa-solid fa-plus"></i> <span class="compare-text">So sánh</span>
                            </button>

                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                    String message = "No products to display.";
                    if (isPromotionFilterActive) {
                        message = "Unfortunately, no products are featured in our HOT PROMOTION right now.";
                    }
                %>
                <div class="col-span-full text-center py-10 bg-white rounded-xl shadow-lg">
                    <p class="text-xl font-semibold text-gray-700"><%= message%></p>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <!-- Compare tray HTML -->
        <div id="comparison-tray" class="stickcompare stickcompare_new cp-desktop hidden fixed bottom-0 left-0 right-0 bg-white shadow-2xl p-3 z-50 border-t border-gray-200">
            <div class="container max-w-7xl mx-auto flex items-center justify-between">
                <div class="flex items-center space-x-4 flex-grow">
                    <label id="compare-error-label" class="error text-red-600 font-semibold hidden">Vui lòng xóa bớt sản phẩm để tiếp tục so sánh!</label>
                    <ul id="compare-list" class="listcompare flex space-x-3">
                        <!-- Template li (ẩn) -->
                        <template id="compare-item-template">
                            <li class="relative bg-gray-50 rounded-lg p-2 flex items-center space-x-2 border border-gray-200 w-32 h-24">
                                <a href="" class="flex flex-col items-center">
                                    <img src="" alt="" class="w-10 h-10 object-contain">
                                    <h3 class="text-xs font-medium text-gray-800 line-clamp-2 mt-1"></h3>
                                </a>
                                <span class="remove-ic-compare absolute top-0 right-0 m-1 cursor-pointer text-gray-400 hover:text-red-500">
                                    <i class="fa-solid fa-xmark fa-xs"></i>
                                </span>
                            </li>
                        </template>

                    </ul>
                </div>
                <div class="closecompare flex items-center space-x-3 ml-4">
                    <a href="javascript:;" onclick="removeAllCompare()" id="remove-all-btn" class="txtremoveall text-gray-500 hover:text-gray-700 text-sm hidden">Xóa tất cả sản phẩm</a>
                    <button id="do-compare-btn"
                            type="button"
                            class="doss px-6 py-2 bg-custom-accent text-white font-semibold rounded-lg">
                        So sánh ngay
                    </button>

                </div>
            </div>
        </div>

        <script>
            const CONTEXT_PATH = '<%= contextPath %>';
            const MAX_COMPARE = 3;
            let compareItems = [];

// --- Clone template li và render toàn bộ tray ---
            function renderCompareTray() {
                const tray = document.getElementById('comparison-tray');
                const compareList = document.getElementById('compare-list');
                compareList.querySelectorAll('li:not(#compare-item-template)').forEach(li => li.remove());

                compareItems.forEach(item => {
                    const template = document.getElementById('compare-item-template');
                    const clone = template.content.cloneNode(true);
                    const li = clone.querySelector('li');

                    li.id = `compare-item-${item.vID}`;
                    li.dataset.variantid = item.vID;
                    li.dataset.productid = item.pID;
                    li.querySelector('img').src = item.img;
                    li.querySelector('h3').textContent = item.name;
                    li.querySelector('.remove-ic-compare').onclick = (e) => removeCompare(item.vID, e);

                    compareList.appendChild(li);
                });

                // Render ô trống
                for (let i = compareItems.length + 1; i <= MAX_COMPARE; i++) {
                    const emptyLi = document.createElement('li');
                    emptyLi.className = "text-xs text-gray-500 p-2 border border-dashed border-gray-300 rounded-lg w-32 text-center h-20 flex items-center justify-center";
                    emptyLi.textContent = `Chọn sản phẩm ${i}`;
                    compareList.appendChild(emptyLi);
                }

                // Hiện/ẩn tray
                tray.classList.toggle('hidden', compareItems.length === 0);

                // Nút so sánh
                const doCompareBtn = document.getElementById('do-compare-btn');
// Nút so sánh (UI only)
                doCompareBtn.classList.toggle('opacity-50', compareItems.length < 2);
                doCompareBtn.classList.toggle('cursor-not-allowed', compareItems.length < 2);
                doCompareBtn.disabled = compareItems.length < 2;

                doCompareBtn.addEventListener('click', () => {
                    if (compareItems.length < 2) {
                        alert("Vui lòng chọn ít nhất 2 sản phẩm để so sánh.");
                        return;
                    }

                    const variantIDs = compareItems.map(item => item.vID).join(',');
                    window.location.href =
                            "<%= request.getContextPath() %>/product?action=compare&vIDs=" + variantIDs;
                });
                // Nút xóa tất cả
                const removeAllBtn = document.getElementById('remove-all-btn');
                removeAllBtn.classList.toggle('hidden', compareItems.length === 0);

                updateCompareButtons();
            }

// --- Toggle sản phẩm ---
            function toggleCompare(vID, pID, name, img) {
                const index = compareItems.findIndex(item => item.vID === vID);

                if (index !== -1) {
                    compareItems.splice(index, 1);
                } else {
                    if (compareItems.length >= MAX_COMPARE) {
                        document.getElementById('compare-error-label').classList.remove('hidden');
                        return;
                    }
                    compareItems.push({vID, pID, name, img});
                }

                document.getElementById('compare-error-label').classList.add('hidden');
                renderCompareTray();
            }

// --- Xóa sản phẩm ---
            function removeCompare(vID, event) {
                if (event)
                    event.stopPropagation();
                const index = compareItems.findIndex(item => item.vID === vID);
                if (index !== -1)
                    compareItems.splice(index, 1);
                document.getElementById('compare-error-label').classList.add('hidden');
                renderCompareTray();
            }

// --- Xóa tất cả ---
            function removeAllCompare() {
                compareItems = [];
                document.getElementById('compare-error-label').classList.add('hidden');
                renderCompareTray();
            }

// --- So sánh ngay ---
            function doCompare() {
                if (compareItems.length < 2) {
                    alert("Vui lòng chọn ít nhất 2 sản phẩm để so sánh.");
                    return;
                }
                const variantIDs = compareItems.map(item => item.vID);
                window.location.href =
                        "<%= request.getContextPath() %>/product?action=compare&vIDs=" + variantIDs;
            }

// --- Cập nhật nút compare trên sản phẩm ---
            function updateCompareButtons() {
                document.querySelectorAll('.compare-btn').forEach(button => {
                    const vID = parseInt(button.getAttribute('data-variantid'));
                    const icon = button.querySelector('i');
                    const textSpan = button.querySelector('.compare-text');

                    const isSelected = compareItems.findIndex(item => item.vID === vID) !== -1;

                    if (isSelected) {
                        if (icon) {
                            icon.classList.replace('fa-plus', 'fa-check');
                            icon.classList.add('text-green-500');
                        }
                        if (textSpan)
                            textSpan.textContent = 'Đã chọn';
                        button.classList.add('compare-selected');
                    } else {
                        if (icon) {
                            icon.classList.replace('fa-check', 'fa-plus');
                            icon.classList.remove('text-green-500');
                        }
                        if (textSpan)
                            textSpan.textContent = 'So sánh';
                        button.classList.remove('compare-selected');
                    }
                });
            }

// --- Gắn sự kiện ---
            function initCompareButtons() {
                document.querySelectorAll('.compare-btn').forEach(button => {
                    button.removeEventListener('click', handleCompareClick);
                    button.addEventListener('click', handleCompareClick);
                });
            }
            function handleCompareClick(event) {
                const btn = event.currentTarget;
                toggleCompare(
                        parseInt(btn.getAttribute('data-variantid')),
                        parseInt(btn.getAttribute('data-productid')),
                        btn.getAttribute('data-name'),
                        btn.getAttribute('data-image')
                        );
            }

// --- Khởi tạo ---
            window.addEventListener('DOMContentLoaded', () => {
                renderCompareTray();
                initCompareButtons();
            });

        </script>

    </body>
</html>