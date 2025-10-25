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
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="layout/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
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
            body { background-color: #f3f4f6; }
            .discount-tag {
                position: absolute; top: 10px; left: -5px; background-color: #ef4444; color: white;
                font-weight: bold; padding: 4px 12px 4px 18px; border-radius: 4px; font-size: 0.75rem;
                line-height: 1rem; z-index: 10; display: flex; align-items: center;
            }
            .discount-tag::before {
                content: ''; position: absolute; top: 0; left: -10px;
                border-width: 13px 10px 13px 0;
                border-style: solid; border-color: transparent #ef4444 transparent transparent;
            }
            
            /* Search Section Styles */
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
        
        <%
            // Sử dụng lại biến currentCategoryId từ header.jsp (không khai báo lại)
            String categoryName = "All Products";
            
            // Xác định tên category
            if ("1".equals(currentCategoryId)) {
                categoryName = "Phone";
            } else if ("3".equals(currentCategoryId)) {
                categoryName = "Tablet";
            } else if ("4".equals(currentCategoryId)) {
                categoryName = "Smartwatch";
            }
        %>
        
        <!-- Search Section - THEO CATEGORY -->
        <section id="searchSection">
            <div class="container">
                <div class="row">
                    <div class="col-12 text-center mb-3">
                        <h2 class="text-white">Find Your Perfect <%= categoryName %></h2>
                        <span class="search-category-badge" id="categoryBadge">Searching in: <%= categoryName %></span>
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
                            <input type="text" id="searchInput" placeholder="Search for <%= categoryName.toLowerCase() %>..." autocomplete="off">
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

                        <!-- Form search ẩn -->
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
            
            // Lấy category hiện tại từ JSP
            let currentCategory = '<%= currentCategoryId != null ? currentCategoryId : "all" %>';
            
            const categoryNames = {
                'all': 'All Products',
                '1': 'Phone',
                '3': 'Tablet',
                '4': 'Smartwatch'
            };
            
            // Cập nhật badge
            categoryBadge.textContent = 'Searching in: ' + (categoryNames[currentCategory] || 'All Products');
            
            // Lọc suggestions theo category
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

            // Hiển thị gợi ý khi gõ
            searchInput.addEventListener('keyup', function () {
                const query = searchInput.value.toLowerCase().trim();
                let hasResults = false;
                
                if (query.length > 0) {
                    allSuggestionItems.forEach(item => {
                        const productName = item.dataset.productname.toLowerCase();
                        const itemText = item.textContent.toLowerCase();
                        const categoryMatch = item.dataset.categoryMatch === 'true';
                        
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
                    searchResults.classList.remove('show');
                    allSuggestionItems.forEach(item => {
                        item.style.display = 'none';
                    });
                }
            });

            // Click vào suggestion
            allSuggestionItems.forEach(item => {
                item.addEventListener('click', function () {
                    document.getElementById('formPID').value = this.dataset.pid;
                    document.getElementById('formCID').value = this.dataset.cid;
                    document.getElementById('formStorage').value = this.dataset.storage;
                    document.getElementById('formColor').value = this.dataset.color;
                    document.getElementById('productSearchForm').submit();
                });
            });

            // Enter để chọn suggestion đầu tiên
            searchInput.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    const firstVisible = Array.from(allSuggestionItems).find(
                        item => item.style.display === 'flex'
                    );
                    if (firstVisible) firstVisible.click();
                }
            });

            // Click outside để đóng results
            document.addEventListener('click', function(e) {
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

        <div class="container max-w-7xl mx-auto p-4 sm:p-6">

            <%
                String currentVariation = request.getParameter("variation");
                if (currentVariation == null || currentVariation.isEmpty()) {
                    currentVariation = "ALL";
                }
            %>

            <div class="mb-4">
                <h2 class="text-lg font-semibold text-gray-900 mb-3">Sắp xếp theo</h2>
                <div class="flex flex-wrap gap-2 items-center">
                    
                    <form action="product" method="get" class="flex flex-wrap gap-2 items-center">
                        <input type="hidden" name="action" value="category">
                        <input type="hidden" name="cID" value="${categoryID}">
                        
                        <button name="variation" value="ALL" type="submit"
                                class="px-4 py-1.5 text-sm font-medium rounded-full flex items-center gap-1.5 <%= "ALL".equals(currentVariation) ? "bg-custom-accent text-white" : "bg-white text-gray-800 border border-gray-300" %>">
                            <i class="fa-solid fa-star fa-xs"></i> Phổ biến
                        </button>
                        <button name="variation" value="PROMOTION" type="submit"
                                class="px-4 py-1.5 text-sm font-medium rounded-full flex items-center gap-1.5 <%= "PROMOTION".equals(currentVariation) ? "bg-custom-accent text-white" : "bg-white text-gray-800 border border-gray-300" %>">
                            <i class="fa-solid fa-fire-flame-curved fa-xs"></i> Khuyến mãi HOT
                        </button>
                        <button name="variation" value="ASC" type="submit"
                                class="px-4 py-1.5 text-sm font-medium rounded-full flex items-center gap-1.5 <%= "ASC".equals(currentVariation) ? "bg-custom-accent text-white" : "bg-white text-gray-800 border border-gray-300" %>">
                            <i class="fa-solid fa-arrow-up-wide-short fa-xs"></i> Giá Thấp - Cao
                        </button>
                        <button name="variation" value="DESC" type="submit"
                                class="px-4 py-1.5 text-sm font-medium rounded-full flex items-center gap-1.5 <%= "DESC".equals(currentVariation) ? "bg-custom-accent text-white" : "bg-white text-gray-800 border border-gray-300" %>">
                            <i class="fa-solid fa-arrow-down-wide-short fa-xs"></i> Giá Cao - Thấp
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
                    if (promotionsList != null && !promotionsList.isEmpty()) {
                        List<Variants> listVariantFiltered = new ArrayList<>();
                        for (Variants v : listVariant) {
                            for (Promotions promotion : promotionsList) {
                                if (v.getProductID() == promotion.getProductID()) {
                                    listVariantFiltered.add(v);
                                    break; 
                                }
                            }
                        }
                        listVariant = listVariantFiltered; 
                    }

                    if (listVariant != null && !listVariant.isEmpty() && listProduct != null) {
                        for (Variants v : listVariant) {
                            double rating = 0;
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
                        <a href="product?action=viewDetail&vID=<%=v.getVariantID() %>&pID=<%=v.getProductID() %>" class="block w-full aspect-square overflow-hidden">
                            <img class="w-full h-full object-cover transition-transform duration-300 hover:scale-110"
                                 src="images/<%=v.getImageUrl()%>"
                                 alt="<%=pName%>">
                        </a>

                        <% if (pr != null && pr.getDiscountPercent() > 0) { %>
                        <div class="discount-tag">
                            Giảm <%=pr.getDiscountPercent()%>%
                        </div>
                        <% } %>
                    </div>

                    <div class="p-4 flex flex-col flex-grow">
                        <a href="product?action=viewDetail&vID=<%=v.getVariantID() %>&pID=<%=v.getProductID() %>">
                            <h3 class="font-bold text-base mb-2 text-gray-900 h-12 overflow-hidden">
                                <%=pName%> <%=v.getStorage()%> <%=v.getColor()%>
                            </h3>
                        </a>

                        <div class="mb-2">
                            <span class="text-red-500 font-bold text-lg">
                                <%=vnFormat.format(v.getDiscountPrice())%>
                            </span>
                            <% if (v.getDiscountPrice() < v.getPrice()) { %>
                            <span class="text-gray-500 line-through text-sm ml-2">
                                <%=vnFormat.format(v.getPrice())%>
                            </span>
                            <% } %>
                        </div>

                        <div class="flex flex-wrap gap-2 mb-3 text-xs">
                            <span class="bg-gray-200 px-2 py-0.5 rounded text-gray-700"><%=v.getStorage()%></span>
                        </div>
                        
                        <div class="mt-auto flex justify-between items-center text-sm pt-2">
                            <% if (rating > 0) { %>
                                <div class="flex items-center gap-1 text-yellow-500">
                                    <i class="fa-solid fa-star"></i>
                                    <span class="font-semibold text-gray-800"><%=String.format("%.1f", rating)%></span>
                                </div>
                            <% } else { %>
                                <span class="text-gray-500 text-xs">Chưa có đánh giá</span>
                            <% } %>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <p class="text-gray-500 col-span-full text-center">Không có sản phẩm nào để hiển thị.</p>
                <%
                    }
                %>
            </div>
        </div>

    </body>
</html>