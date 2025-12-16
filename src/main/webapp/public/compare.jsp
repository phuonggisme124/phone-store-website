<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="model.Variants" %>
<%@ page import="model.Specification" %>

<%!
    /**
     * Format price to Vietnamese currency (₫), no decimal part
     */
    private String formatPrice(double price) {
        NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        nf.setMaximumFractionDigits(0);
        return nf.format(price);
    }

    /**
     * Check null or empty string
     */
    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="/layout/header.jsp" %>
        <link rel="stylesheet" href="css/compare.css">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>So sánh sản phẩm</title>

        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

        <style>
            body {
                padding-top: 70px;
                background-color: #f3f4f6;
            }
        </style>
    </head>

    <%
    List<Variants> compareList = (List<Variants>) request.getAttribute("compareList");
    Map<Integer, Specification> specMap = (Map<Integer, Specification>) request.getAttribute("specMap");
    if (specMap == null) {
        specMap = new HashMap<>();
    }

    Map<Integer, String> productNameMap = (Map<Integer, String>) request.getAttribute("productNameMap");
    if (productNameMap == null) {
        productNameMap = new HashMap<>();
    }
    %>


    <body>

        <%-- ================= NO DATA ================= --%>
        <% if (compareList == null || compareList.isEmpty()) { %>
        <div class="max-w-7xl mx-auto p-10 text-center text-gray-600 text-lg">
            Chưa có sản phẩm nào để so sánh.
        </div>
        <% } else { %>
        <div class="max-w-7xl mx-auto p-4">

            <h2 class="text-3xl font-extrabold text-gray-800 mb-8 border-b pb-2">
                <i class="fas fa-balance-scale mr-2 text-red-500"></i>
                SO SÁNH SẢN PHẨM
            </h2>

            <%-- Product Cards --%>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                <div class="hidden md:block"></div>
                <% for (Variants v : compareList) {
                    double priceToShow = (v.getDiscountPrice()!=null && v.getDiscountPrice()>0) ? v.getDiscountPrice() : v.getPrice();
                    String imageName = (v.getImageList()!=null && v.getImageList().length>0) ? v.getImageList()[0] : "no-image.png";
                %>
                <div class="border rounded-lg p-4 bg-white shadow-md text-center relative">
                    <div class="h-28 flex items-center justify-center mb-2">
                        <img src="<%= request.getContextPath() + "/images/" + imageName %>"
                             alt="<%= v.getProductName() %>"
                             class="max-h-full object-contain">
                    </div>
                    <h3 class="font-bold text-sm min-h-[2.5rem]">
                        <%= productNameMap.get(v.getProductID()) %>

                    </h3>
                    <p class="text-xs text-gray-500 mb-2">
                        <%= v.getColor() %> / <%= v.getStorage() %>
                    </p>
                    <% if (v.getDiscountPrice() != null && v.getDiscountPrice() > 0 && v.getPrice() > v.getDiscountPrice()) { %>
                    <p class="text-xs text-gray-400 line-through">
                        <%= formatPrice(v.getPrice()) %>
                    </p>
                    <% } %>
                    <p class="text-xl text-red-600 font-extrabold">
                        <%= formatPrice(priceToShow) %>
                    </p>
                </div>
                <% } %>
            </div>

            <%-- Specification Table --%>
            <h3 class="text-2xl font-bold text-gray-700 mb-4">
                <i class="fas fa-list-ul mr-2 text-red-500"></i>
                THÔNG SỐ KỸ THUẬT
            </h3>

            <div class="overflow-x-auto bg-white shadow-lg rounded-lg">
                <table class="w-full text-center border-collapse">
                    <tbody>
                        <%
                            String[] specs = {"RAM","Bộ nhớ","Màu sắc","Pin","CPU","GPU","OS","Màn hình"};
                            for (String specName : specs) {
                        %>
                        <tr class="border-b">
                            <td class="p-3 font-bold bg-gray-100 text-left w-1/4"><%= specName %></td>
                            <% for (Variants v : compareList) {
                                Specification s = specMap.get(v.getProductID());
                                String value = "N/A";
                                if (s != null) {
                                    switch (specName) {
                                        case "RAM": if (!isNullOrEmpty(s.getRam())) value = s.getRam() + " GB"; break;
                                        case "Bộ nhớ": if (!isNullOrEmpty(v.getStorage())) value = v.getStorage(); break;
                                        case "Màu sắc": if (!isNullOrEmpty(v.getColor())) value = v.getColor(); break;
                                        case "Pin": if (s.getBatteryCapacity() > 0) value = s.getBatteryCapacity() + " mAh"; break;
                                        case "CPU": if (!isNullOrEmpty(s.getCpu())) value = s.getCpu(); break;
                                        case "GPU": if (!isNullOrEmpty(s.getGpu())) value = s.getGpu(); break;
                                        case "OS": if (!isNullOrEmpty(s.getOs())) value = s.getOs(); break;
                                        case "Màn hình": if (!isNullOrEmpty(s.getTouchscreen())) value = s.getTouchscreen() + " inch"; break;
                                    }
                                }
                            %>
                            <td class="p-3"><%= value %></td>
                            <% } %>
                        </tr>
                        <% } %>

                        <%-- Price row --%>
                        <tr class="font-bold">
                            <td class="p-3 text-left text-red-700">Giá</td>
                            <% for (Variants v : compareList) {
                                double priceToShow = (v.getDiscountPrice()!=null && v.getDiscountPrice()>0) ? v.getDiscountPrice() : v.getPrice();
                            %>
                            <td class="p-3 text-red-600"><%= formatPrice(priceToShow) %></td>
                            <% } %>
                        </tr>



                    </tbody>
                </table>
            </div>

            <%-- Action buttons --%>
            <div class="mt-8 flex justify-center space-x-4">
                <a href="javascript:history.back()" class="px-6 py-3 bg-gray-200 rounded-lg hover:bg-gray-300">
                    <i class="fas fa-arrow-left mr-2"></i> Quay lại
                </a>
                <!--                <a href="javascript:;" onclick="removeAllCompare()"
                                   class="px-6 py-3 bg-red-500 text-white rounded-lg hover:bg-red-600">
                                    <i class="fas fa-trash-alt mr-2"></i> Xóa tất cả
                                </a>-->
            </div>

        </div>

        <!--        <script>
                    function removeAllCompare() {
                        window.location.href = "<%= request.getContextPath() %>/product?action=removeCompareList&cID=1";
                    }
                </script>-->

        <% } %>
    </body>
</html>
