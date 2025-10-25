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
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
                border-width: 13px 10px 13px 0; /* Chỉnh lại để cân đối hơn */
                border-style: solid; border-color: transparent #ef4444 transparent transparent;
            }
        </style>
    </head>

    <body class="bg-gray-100 text-gray-900 font-sans">
        <div class="container max-w-7xl mx-auto p-4 sm:p-6">

            <%
                String currentVariation = request.getParameter("variation");
                if (currentVariation == null || currentVariation.isEmpty()) {
                    currentVariation = "ALL"; // Giá trị mặc định
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
                                 src="images/<%=v.getImageList()[0]%>"
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
                        } // end for(Variants)
                    } else {
                %>
                <p class="text-gray-500 col-span-full text-center">Không có sản phẩm nào để hiển thị.</p>
                <%
                    } // end if(listVariant != null)
                %>
            </div>
        </div>

        </body>
</html>