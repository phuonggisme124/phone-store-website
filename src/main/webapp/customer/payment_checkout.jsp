<%@page import="model.InterestRate"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="model.Carts"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/layout/header.jsp" %>
<%    Customer userC = (Customer) session.getAttribute("user");

    boolean isOver18 = false;
    boolean hasCCCD = false;
    boolean hasYob = false;

    if (userC != null) {
        if (userC.getCccd() != null && !userC.getCccd().trim().isEmpty()) {
            hasCCCD = true;
        }
        if (userC.getYob() != null) {
            hasYob = true;
            if (userC.getAge() >= 18) {
                isOver18 = true;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Confirm Payment</title>

        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/home.css?v=<%=System.currentTimeMillis()%>">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

        <script src="https://cdn.tailwindcss.com"></script>

        <style>
            :root {
                --main-color: #FF424F;
                --main-hover: #e03a45;
                --addr-border: #72AEC8;
                --addr-bg: #f8fcfd;
                --addr-text: #007bff;
            }
            .payment-wrapper {
                font-family: 'Poppins', sans-serif;
                background-color: #f8f9fa;
                min-height: 100vh;
                padding-bottom: 50px;
            }
            .payment-wrapper *, .payment-wrapper *::before, .payment-wrapper *::after {
                box-sizing: border-box;
            }
            .text-main {
                color: var(--main-color) !important;
            }
            .bg-main {
                background-color: var(--main-color) !important;
            }

            .payment-container {
                max-width: 42rem;
                margin: 2rem auto;
                background-color: #ffffff;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                border-radius: 12px;
                position: relative;
                overflow: hidden;
            }
            .payment-form-header {
                padding: 1.25rem;
                border-bottom: 1px solid #f0f0f0;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                background: #fff;
            }
            .header-title {
                font-size: 1.2rem;
                font-weight: 700;
                color: #111;
                margin: 0;
            }
            .back-button {
                position: absolute;
                left: 1rem;
                background: none;
                border: none;
                cursor: pointer;
                color: #666;
                padding: 5px;
            }
            .back-button:hover {
                color: var(--main-color);
            }
            .payment-main {
                padding: 1.5rem;
            }
            .section-title {
                font-weight: 700;
                font-size: 0.95rem;
                color: #555;
                margin-bottom: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-top: 1.5rem;
            }
            .recipient-info-section:first-of-type .section-title {
                margin-top: 0;
            }
            .info-box {
                background-color: #fafafa;
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 1rem;
                display: flex;
                flex-direction: column;
                gap: 0.8rem;
            }
            .info-row {
                display: flex;
                justify-content: space-between;
            }
            .info-label {
                color: #666;
                font-weight: 500;
                font-size: 0.9rem;
            }
            .info-value {
                color: #222;
                font-weight: 600;
                font-size: 0.95rem;
                text-align: right;
            }
            .selected-addr-box {
                border: 1px solid var(--addr-border);
                background-color: var(--addr-bg);
                border-radius: 8px;
                padding: 16px;
                display: flex;
                align-items: flex-start;
                gap: 12px;
            }
            .selected-addr-box i {
                color: var(--addr-border);
                margin-top: 3px;
                font-size: 1.2rem;
            }
            .payment-selector-box {
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 14px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                cursor: pointer;
                background-color: white;
                transition: all 0.2s;
            }
            .payment-selector-box:hover {
                border-color: var(--main-color);
                background-color: #fff0f1;
            }
            .summary-box {
                background-color: #f8f9fa;
                margin-top: 25px;
                border: 1px solid #eee;
                border-radius: 8px;
                padding: 1.25rem;
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }
            #confirm-btn {
                width: 100%;
                background-color: var(--main-color);
                color: white;
                font-weight: 600;
                font-size: 1rem;
                border: none;
                border-radius: 8px;
                padding: 14px;
                cursor: pointer;
                margin-top: 24px;
                transition: background 0.3s;
                box-shadow: 0 4px 10px rgba(255, 66, 79, 0.3);
            }
            #confirm-btn:hover {
                background-color: var(--main-hover);
            }
            .check-product-link {
                color: var(--main-color);
                font-weight: 500;
                font-size: 0.85rem;
                text-decoration: none;
                cursor: pointer;
                display: block;
                text-align: center;
                margin-top: 10px;
            }
            .check-product-link:hover {
                text-decoration: underline;
            }
            .payment-option.selected {
                border-color: var(--main-color);
                box-shadow: 0 0 0 1px var(--main-color) inset;
                background-color: #fff0f1;
            }
            .term-column.selected {
                background-color: #fff0f1;
                border-color: var(--main-color);
            }
            .term-column.selected .term-button {
                background-color: var(--main-color);
                color: white;
                cursor: default;
                border-color: var(--main-color);
            }
            .term-button {
                border-color: var(--main-color);
                color: var(--main-color);
            }
            .hover\:bg-theme-dark:hover {
                background-color: var(--main-hover) !important;
            }
            .bg-theme {
                background-color: var(--main-color) !important;
            }
            .text-theme {
                color: var(--main-color) !important;
            }
            #qrCodeImage {
                max-width: 100%;
                height: auto;
            }
        </style>
    </head>

    <body class="payment-wrapper">
        <%
            List<Carts> cartsCheckout = (List<Carts>) session.getAttribute("cartCheckout");
            ProductDAO pDAO = new ProductDAO();

            String receiverName = (String) request.getAttribute("receiverName");
            String receiverPhone = (String) request.getAttribute("receiverPhone");
            String specificAddress = (String) request.getAttribute("specificAddress");
            String saveAddress = (String) request.getAttribute("saveAddress");
            String city = (String) request.getAttribute("city");
            String address = (String) request.getAttribute("address");
            
            // Lấy addressID để giữ lại khi reload
            String addrID = (String) request.getAttribute("addressID");
            if (addrID == null) addrID = request.getParameter("addressID");

            double totalPriceBeforeDiscount = 0;
            double totalPriceAfterDiscount = 0;
            int totalQuantity = 0;
            if (cartsCheckout != null) {
                for (Carts c : cartsCheckout) {
                    totalPriceBeforeDiscount += c.getVariant().getPrice() * c.getQuantity();
                    totalPriceAfterDiscount += c.getVariant().getDiscountPrice() * c.getQuantity();
                    totalQuantity += c.getQuantity();
                }
            }
            double discountAmount = totalPriceBeforeDiscount - totalPriceAfterDiscount;
            
            // --- XỬ LÝ VOUCHER ---
            Double reqVoucherDiscount = (Double) request.getAttribute("discountAmount");
            double voucherDiscountValue = (reqVoucherDiscount != null) ? reqVoucherDiscount : 0;

            // Tính TỔNG TIỀN THANH TOÁN CUỐI CÙNG
            double finalPaymentTotal = totalPriceAfterDiscount - voucherDiscountValue;
            if (finalPaymentTotal < 0) finalPaymentTotal = 0;
        %>

        <div class="payment-container">
            <div class="payment-form-header">
                <button class="back-button" onclick="window.history.back()">
                    <i class="fa-solid fa-arrow-left fa-lg"></i>
                </button>
                <h1 class="header-title">Confirm Payment</h1>
            </div>

            <div class="payment-main">
                <form action="payment" method="post" id="payment-form">
                    <input type="hidden" name="receiverName" value="<%= receiverName%>">
                    <input type="hidden" name="receiverPhone" value="<%= receiverPhone%>">
                    <input type="hidden" name="specificAddress" value="<%= specificAddress%>">
                    <input type="hidden" name="totalAmount" value="<%= finalPaymentTotal%>">

                    <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="">
                    <input type="hidden" name="installmentTerm" id="installmentTermInput" value="">

                    <input type="hidden" name="saveAddress" value="<%= saveAddress != null ? saveAddress : ""%>">
                    <input type="hidden" name="city" value="<%= city != null ? city : ""%>">
                    <input type="hidden" name="address" value="<%= address != null ? address : ""%>">
                    <input type="hidden" name="addressID" value="<%= addrID != null ? addrID : ""%>">

                    <div class="recipient-info-section">
                        <h3 class="section-title">Receiver Information</h3>
                        <div class="info-box">
                            <div class="info-row">
                                <span class="info-label">Name</span>
                                <span class="info-value"><%= receiverName != null ? receiverName : "Not set"%></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Phone</span>
                                <span class="info-value"><%= receiverPhone != null ? receiverPhone : "Not set"%></span>
                            </div>
                        </div>
                    </div>

                    <div class="recipient-info-section">
                        <h3 class="section-title">Shipping Address</h3>
                        <div class="selected-addr-box">
                            <i class="fa-solid fa-location-dot"></i>
                            <span style="color:#333; font-size:0.95rem; line-height:1.5; font-weight: 500; flex: 1;">
                                <%= specificAddress != null ? specificAddress : "No address provided"%>
                            </span>
                        </div>
                    </div>



                    <div class="space-y-4 mb-6">
                        <h3 class="font-bold text-lg text-gray-700 section-title">VOUCHER</h3>

                        <%-- Hiển thị thông báo Voucher --%>
                        <% String voucherMsg = (String) request.getAttribute("voucherMsg"); %>
                        <% if (voucherMsg != null && !voucherMsg.isEmpty()) {%>
                        <div class="text-sm p-2 rounded mb-2 <%= voucherMsg.contains("success") ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"%>">
                            <%= voucherMsg%>
                        </div>
                        <% } %>

                        <% model.Vouchers appliedVoucher = (model.Vouchers) session.getAttribute("appliedVoucher"); %>

                        <div class="border rounded-lg p-4 bg-white">
                            <% if (appliedVoucher == null) {%>
                            <%-- Nút mở Modal Voucher --%>
                            <button type="button" id="openVoucherModalBtn" class="w-full border border-theme text-theme py-2 rounded text-sm font-medium hover:bg-blue-50 transition-colors">
                                <i class="fa-solid fa-tags mr-2"></i> Select from My Vouchers
                            </button>
                            <% } else {%>
                            <%-- Hiển thị voucher đang áp dụng --%>
                            <div class="flex justify-between items-center">
                                <div>
                                    <p class="font-semibold text-theme"><i class="fa-solid fa-ticket mr-2"></i><%= appliedVoucher.getCode()%></p>
                                    <p class="text-xs text-green-600">Reduced: -<%= String.format("%,.0f", voucherDiscountValue)%> VND</p>
                                </div>
                                <button type="submit" name="action" value="removeVoucher" formnovalidate 
                                        class="text-red-500 text-sm font-medium hover:underline border-none bg-transparent cursor-pointer">
                                    Remove
                                </button>
                            </div>
                            <% }%>
                        </div>
                    </div>
                    <div class="recipient-info-section">
                        <h3 class="section-title">Payment Method</h3>
                        <div id="openPaymentModalBtn" class="payment-selector-box">
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <i id="selected-payment-icon" class="text-theme text-2xl w-8 text-center hidden"></i>
                                <span id="selected-payment-text" style="font-weight: 500; color: #555;">Select Payment Method</span>
                            </div>
                            <i class="fa-solid fa-chevron-right" style="color: #ccc;"></i>
                        </div>
                    </div>

                    <div class="summary-box">
                        <div style="display: flex; justify-content: space-between;">
                            <p style="color:#666;">Subtotal</p>
                            <p style="font-weight: 600;"><%= String.format("%,.0f", totalPriceBeforeDiscount)%> VND</p>
                        </div>
                        <% if (discountAmount > 0) {%>
                        <div style="display: flex; justify-content: space-between;">
                            <p style="color:#666;">Discount</p>
                            <p class="text-theme" style="font-weight: 600;">-<%= String.format("%,.0f", discountAmount)%> VND</p>
                        </div>
                        <% }%>
                        <% if (voucherDiscountValue > 0) {%>
                        <div class="flex justify-between text-theme">
                            <span>Voucher Applied</span>
                            <span class="font-semibold">-<%= String.format("%,.0f", voucherDiscountValue)%> VND</span>
                        </div>
                        <% }%>
                        <hr style="border-top: 1px dashed #ddd; margin: 5px 0;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <p style="font-weight: 600; color:#333;">Total Payment</p>
                            <div style="text-align: right;">
                                <%-- Input ẩn lưu giá gốc (để reset khi hủy trả góp) --%>
                                <input type="hidden" id="originalFinalTotal" value="<%= finalPaymentTotal %>">

                                <%-- Giá hiển thị (sẽ thay đổi bằng JS khi chọn trả góp) --%>
                                <p id="totalPaymentDisplay" style="color: var(--main-color); font-weight: 700; font-size: 1.25rem;">
                                    <%= String.format("%,.0f", finalPaymentTotal)%> VND
                                </p>
                                <p id="installmentNote" style="font-size: 0.8rem; color: #666; display: none;">(Included installment interest)</p>
                            </div>
                        </div>

                        <% if (totalQuantity > 0) {%>
                        <a id="openProductListModalBtn" class="check-product-link">
                            Check product list (<%= totalQuantity%> items) <i class="fa-solid fa-chevron-right text-xs"></i>
                        </a>
                        <% } %>
                    </div>

                    <button type="button" id="confirm-btn">Place Order</button>
                </form>
            </div>

            <div id="productModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 hidden" style="font-family: 'Poppins', sans-serif;">
                <div class="bg-white rounded-lg shadow-xl w-full max-w-md overflow-hidden">
                    <div class="p-4 border-b flex justify-between items-center bg-gray-50">
                        <h2 class="text-lg font-semibold text-gray-800" style="margin:0;">Products List</h2>
                        <button class="js-close-modal text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                    </div>
                    <div class="p-4 space-y-4 max-h-[60vh] overflow-y-auto">
                        <% if (cartsCheckout != null && !cartsCheckout.isEmpty()) {
                            for (Carts c : cartsCheckout) {%>
                        <div class="flex items-start space-x-4 border-b pb-3 last:border-0 last:pb-0">
                            <img src="${pageContext.request.contextPath}/images/<%= c.getVariant().getImageList()[0]%>" class="w-16 h-16 object-contain border rounded-md" onerror="this.src='https://placehold.co/60'">
                            <div class="flex-1">
                                <p class="font-semibold text-sm text-gray-800 line-clamp-2"><%= pDAO.getProductByID(c.getVariant().getProductID()).getName().toUpperCase() + " " + c.getVariant().getStorage().toUpperCase() + " " + c.getVariant().getColor()%></p>
                                <div class="flex items-center justify-between mt-2">
                                    <span class="font-bold text-theme text-sm"><%= String.format("%,.0f", c.getVariant().getDiscountPrice())%> VND</span>
                                    <span class="text-gray-600 text-sm">x<%= c.getQuantity()%></span>
                                </div>
                            </div>
                        </div>
                        <%  }
                        } else { %>
                        <p class="text-center text-gray-500">Cart is empty.</p>
                        <% }%>
                    </div>
                </div>
            </div>

            <div id="paymentMethodModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-end sm:items-center justify-center p-0 sm:p-4 z-[60] hidden" style="font-family: 'Poppins', sans-serif;">
                <div class="bg-white rounded-t-lg sm:rounded-lg shadow-xl w-full max-w-lg">
                    <div class="p-4 border-b flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800" style="margin:0;">Select Payment Method</h2>
                        <button class="js-close-modal text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                    </div>
                    <div class="p-4 space-y-3 max-h-[70vh] overflow-y-auto">
                        <div class="payment-option border rounded-lg p-4 flex items-center cursor-pointer hover:bg-gray-50 transition-all" data-value="COD" data-text="Cash on Delivery" data-fa-icon-class="fa-solid fa-money-bill-wave">
                            <div class="flex-grow flex items-center space-x-4">
                                <i class="fa-solid fa-money-bill-wave text-theme text-2xl w-8 text-center"></i>
                                <span class="font-medium">Cash on Delivery</span>
                            </div>
                            <i class="fa-regular fa-circle text-gray-300 check-icon"></i>
                        </div>

                        <div id="openInstallmentModalBtn" 
                             class="payment-option border rounded-lg p-4 flex items-center cursor-pointer hover:bg-gray-50 transition-all <%= !isOver18 ? "opacity-50 bg-gray-100" : ""%>" 
                             data-value="INSTALLMENT" 
                             data-text="Installment via Card/Wallet" 
                             data-fa-icon-class="fa-solid fa-credit-card"
                             data-age-ok="<%= isOver18%>"       
                             data-cccd-ok="<%= hasCCCD%>"
                             data-has-yob="<%= hasYob%>">
                            <div class="flex-grow flex items-center space-x-4">
                                <i class="fa-solid fa-credit-card text-theme text-2xl w-8 text-center <%= !isOver18 ? "text-gray-400" : ""%>"></i>
                                <div class="flex flex-col">
                                    <span class="font-medium <%= !isOver18 ? "text-gray-500" : ""%>">Installment via Card/Wallet</span>
                                    <% if (!hasYob) { %>
                                    <span class="text-xs text-orange-500 font-semibold">(Need to update YOB)</span>
                                    <% } else if (!hasCCCD) { %>
                                    <span class="text-xs text-orange-500 font-semibold">(Need to update CCCD)</span>
                                    <% } else if (!isOver18) { %>
                                    <span class="text-xs text-red-500 font-semibold">(Must be at least 18 years old)</span>
                                    <% } %>
                                </div>
                            </div>
                            <% if (!hasYob || !hasCCCD || !isOver18) { %>
                            <i class="fa-solid fa-lock text-gray-400"></i>
                            <% } else { %>
                            <i class="fa-solid fa-chevron-right text-gray-400"></i>
                            <% } %>
                        </div>

                        <div id="openTransferModalBtn" class="payment-option border rounded-lg p-4 flex items-center cursor-pointer hover:bg-gray-50 transition-all" data-value="TRANSFER" data-text="Payment via Bank Transfer" data-fa-icon-class="fa-solid fa-building-columns">
                            <div class="flex-grow flex items-center space-x-4">
                                <i class="fa-solid fa-building-columns text-theme text-2xl w-8 text-center"></i>
                                <span class="font-medium">Payment via Bank Transfer</span>
                            </div>
                            <i class="fa-solid fa-chevron-right text-gray-400"></i>
                        </div>
                    </div>
                    <div class="p-4 border-t">
                        <button id="confirmPaymentBtn" class="w-full bg-theme text-white font-bold py-3 rounded-lg hover:bg-theme-dark shadow-md">Confirm</button>
                    </div>
                </div>
            </div>

            <div id="installmentModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-end sm:items-center justify-center p-0 sm:p-4 z-[70] hidden" style="font-family: 'Poppins', sans-serif;">
                <div class="bg-white rounded-t-lg sm:rounded-lg shadow-xl w-full max-w-2xl">
                    <div class="p-4 border-b flex items-center relative">
                        <button id="backToPaymentModalBtn" class="absolute left-4 text-gray-600 hover:text-gray-900"><i class="fa-solid fa-arrow-left"></i></button>
                        <h2 class="text-lg font-semibold text-gray-800 w-full text-center" style="margin:0;">Installment Plan</h2>
                        <button class="js-close-modal absolute right-4 text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                    </div>
                    <div class="p-4 space-y-4">
                        <div id="installmentTermContainer" class="w-full overflow-x-auto">
                            <div class="flex text-center text-sm">
                                <div class="w-1/4 font-semibold text-left flex flex-col pr-2 text-gray-500">
                                    <div class="h-12 flex items-center">Term</div>
                                    <div class="h-10 flex items-center">Fee</div>
                                    <div class="h-10 flex items-center">Interest</div>
                                    <div class="h-10 flex items-center">Monthly</div>
                                    <div class="h-10 flex items-center">Total</div>
                                </div>
                                <% List<InterestRate> iRList = (List<InterestRate>) request.getAttribute("iRList"); %>
                                <div class="w-3/4 flex">
                                    <% if (iRList != null) {
                                            for (InterestRate iR : iRList) {
                                                double instalmentPrice = (finalPaymentTotal * iR.getPercent()) / 100;
                                                double totalPriceEachMothPay = (finalPaymentTotal + instalmentPrice) / iR.getInstalmentPeriod();
                                                double totalPriceAfterInstalment = finalPaymentTotal + instalmentPrice;
                                    %>
                                    <div class="term-column w-1/3 border rounded-md p-2 mx-1 flex flex-col cursor-pointer transition-colors" 
                                         data-term="<%=iR.getInstalmentPeriod()%>"
                                         data-final-price="<%= totalPriceAfterInstalment %>">
                                        <div class="flex-grow">
                                            <div class="h-12 flex items-center justify-center font-bold term-header text-theme"><%=iR.getInstalmentPeriod()%> months</div>
                                            <div class="h-10 flex items-center justify-center text-xs"><%= String.format("%,.0f", instalmentPrice)%> đ</div>
                                            <div class="h-10 flex items-center justify-center text-xs font-semibold"><%=iR.getPercent()%>%</div>
                                            <div class="h-10 flex items-center justify-center font-semibold text-sm"><%= String.format("%,.0f", totalPriceEachMothPay)%> đ</div>
                                            <div class="h-10 flex items-center justify-center font-semibold text-sm text-red-500"><%= String.format("%,.0f", totalPriceAfterInstalment)%> đ</div>
                                        </div>
                                        <button type="button" class="term-button mt-2 w-full py-1 border rounded-md font-semibold text-xs transition-colors">SELECT</button>
                                    </div>
                                    <% }
                                    }%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="p-4 border-t">
                        <button id="confirmInstallmentBtn" class="w-full bg-theme text-white font-bold py-3 rounded-lg hover:bg-theme-dark disabled:bg-gray-300 disabled:cursor-not-allowed" disabled>Confirm</button>
                    </div>
                </div>
            </div>

            <div id="transferModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-end sm:items-center justify-center p-0 sm:p-4 z-[70] hidden" style="font-family: 'Poppins', sans-serif;">
                <div class="bg-white rounded-t-lg sm:rounded-lg shadow-xl w-full max-w-md">
                    <div class="p-4 border-b flex items-center relative">
                        <button id="backToPaymentModalBtnFromTransfer" class="absolute left-4 text-gray-600 hover:text-gray-900"><i class="fa-solid fa-arrow-left"></i></button>
                        <h2 class="text-lg font-semibold text-gray-800 w-full text-center" style="margin:0;">Bank Transfer</h2>
                        <button class="js-close-modal absolute right-4 text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                    </div>
                    <div class="p-6 text-center">
                        <div class="flex justify-center mb-4">
                            <img id="qrCodeImage" src="" alt="QR Code" class="w-48 h-48 border rounded-lg shadow-sm">
                        </div>
                        <div class="space-y-3 text-left bg-gray-50 p-4 rounded-lg text-sm border border-gray-100">
                            <div class="flex justify-between">
                                <span class="text-gray-500">Amount:</span>
                                <span class="font-bold text-theme text-lg"><%= String.format("%,.0f", finalPaymentTotal)%> VND</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Content:</span>
                                <div class="flex items-center space-x-2 bg-white px-2 py-1 rounded border">
                                    <span id="transferContent" class="font-semibold text-blue-600"></span>
                                    <button id="copyContentBtn" class="text-gray-400 hover:text-blue-600"><i class="fa-regular fa-copy"></i></button>
                                </div>
                            </div>
                        </div>
                        <p class="text-xs text-gray-400 mt-4 italic">Waiting for automatic confirmation...</p>
                    </div>
                    <div class="p-4 border-t">
                        <button id="confirmTransferBtn" class="w-full bg-theme text-white font-bold py-3 rounded-lg hover:bg-theme-dark">I have paid</button>
                    </div>
                </div>
            </div>

            <div id="voucherModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-[80] hidden">
                <div class="bg-white rounded-lg shadow-xl w-full max-w-md h-[80vh] flex flex-col">
                    <div class="p-4 border-b flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800">My Vouchers</h2>
                        <button class="js-close-modal text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                    </div>

                    <div class="p-4 flex-1 overflow-y-auto bg-gray-50 space-y-3">
                        <%
                            List<model.Vouchers> myVouchers = (List<model.Vouchers>) request.getAttribute("myVouchers");
                            if (myVouchers != null && !myVouchers.isEmpty()) {
                                for (model.Vouchers v : myVouchers) {
                                    boolean isUsable = "Active".equalsIgnoreCase(v.getStatus()) && v.getQuantity() > 0;
                        %>
                        <div class="bg-white border <%= isUsable ? "border-gray-200" : "border-gray-100 opacity-60"%> rounded-lg p-3 shadow-sm relative overflow-hidden">
                            <div class="absolute top-1/2 -left-2 w-4 h-4 bg-gray-50 rounded-full"></div>
                            <div class="absolute top-1/2 -right-2 w-4 h-4 bg-gray-50 rounded-full"></div>

                            <div class="flex justify-between items-center ml-3 mr-3">
                                <div>
                                    <h4 class="font-bold text-gray-800 text-lg"><%= v.getCode()%></h4>
                                    <p class="text-red-500 font-bold text-sm">Discount <%= v.getPercentDiscount()%>%</p>
                                    <p class="text-xs text-gray-500 mt-1">Exp: <%= v.getEndDay()%></p>
                                    <% if (v.getQuantity() <= 0) { %>
                                    <span class="text-[10px] bg-gray-200 px-2 py-0.5 rounded text-gray-500">Out of stock</span>
                                    <% } else if (!"Active".equalsIgnoreCase(v.getStatus())) {%>
                                    <span class="text-[10px] bg-red-100 px-2 py-0.5 rounded text-red-500"><%= v.getStatus()%></span>
                                    <% } %>
                                </div>

                                <div>
                                    <% if (isUsable) {%>
                                    <form action="payment" method="post">
                                        <input type="hidden" name="action" value="applyVoucher">
                                        <input type="hidden" name="voucherCode" value="<%= v.getCode()%>">

                                        <input type="hidden" name="receiverName" value="<%= receiverName%>">
                                        <input type="hidden" name="receiverPhone" value="<%= receiverPhone%>">
                                        <input type="hidden" name="city" value="<%= city%>">
                                        <input type="hidden" name="address" value="<%= address%>">
                                        <input type="hidden" name="saveAddress" value="<%= saveAddress%>">
                                        <input type="hidden" name="addressID" value="<%= addrID != null ? addrID : ""%>">

                                        <button type="submit" class="bg-theme text-white text-xs font-bold px-4 py-2 rounded-full hover:bg-theme-dark transition">
                                            Apply
                                        </button>
                                    </form>
                                    <% } else { %>
                                    <button disabled class="bg-gray-100 text-gray-400 text-xs font-bold px-4 py-2 rounded-full cursor-not-allowed">
                                        Invalid
                                    </button>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div class="text-center py-10">
                            <i class="fa-regular fa-folder-open text-4xl text-gray-300 mb-3"></i>
                            <p class="text-gray-500">You don't have any vouchers yet.</p>
                        </div>
                        <% }%>
                    </div>
                </div>
            </div>        

            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    // --- DOM ELEMENTS ---
                    const productModal = document.getElementById('productModal');
                    const openProductListModalBtn = document.getElementById('openProductListModalBtn');

                    const paymentMethodModal = document.getElementById('paymentMethodModal');
                    const installmentModal = document.getElementById('installmentModal');
                    const transferModal = document.getElementById('transferModal');
                    const voucherModal = document.getElementById('voucherModal');

                    const openPaymentModalBtn = document.getElementById('openPaymentModalBtn');
                    const openVoucherModalBtn = document.getElementById('openVoucherModalBtn');

                    const confirmPaymentBtn = document.getElementById('confirmPaymentBtn');
                    const confirmInstallmentBtn = document.getElementById('confirmInstallmentBtn');
                    const confirmTransferBtn = document.getElementById('confirmTransferBtn');
                    const mainSubmitBtn = document.getElementById('confirm-btn');

                    const backToPaymentModalBtn = document.getElementById('backToPaymentModalBtn');
                    const backToPaymentModalBtnFromTransfer = document.getElementById('backToPaymentModalBtnFromTransfer');

                    // Inputs & Display
                    const paymentMethodInput = document.getElementById('paymentMethodInput');
                    const installmentTermInput = document.getElementById('installmentTermInput');
                    const selectedPaymentText = document.getElementById('selected-payment-text');
                    const selectedPaymentIcon = document.getElementById('selected-payment-icon');
                    const paymentForm = document.getElementById('payment-form');

                    // Display Price Elements
                    const totalPaymentDisplay = document.getElementById('totalPaymentDisplay');
                    const originalFinalTotal = parseFloat(document.getElementById('originalFinalTotal').value);
                    const installmentNote = document.getElementById('installmentNote');

                    let selectedInstallmentTerm = null;
                    let selectedInstallmentPrice = 0;
                    let paymentCheckInterval = null;

                    // --- HELPER FUNCTIONS ---
                    const openModal = (modal) => {
                        if (modal)
                            modal.classList.remove('hidden');
                    };
                    const closeModal = (modal) => {
                        if (modal) {
                            modal.classList.add('hidden');
                            if (modal.id === 'transferModal' && paymentCheckInterval)
                                clearInterval(paymentCheckInterval);
                        }
                    };
                    const formatCurrency = (amount) => new Intl.NumberFormat('vi-VN').format(amount) + " VND";

                    const updateSelectedPaymentDisplay = (text, iconClass) => {
                        selectedPaymentText.textContent = text;
                        selectedPaymentText.style.color = "#333";
                        selectedPaymentIcon.className = 'text-theme text-2xl w-8 text-center ' + iconClass;
                        selectedPaymentIcon.classList.remove('hidden');
                    };

                    const resetToOriginalPrice = () => {
                        totalPaymentDisplay.textContent = formatCurrency(originalFinalTotal);
                        installmentNote.style.display = 'none';
                    };

                    document.querySelectorAll('.js-close-modal').forEach(btn => {
                        btn.addEventListener('click', (e) => {
                            e.preventDefault();
                            closeModal(e.target.closest('.fixed'));
                        });
                    });

                    // --- OPEN MODAL EVENTS ---
                    if (openProductListModalBtn)
                        openProductListModalBtn.addEventListener('click', (e) => {
                            e.preventDefault();
                            openModal(productModal);
                        });
                    if (openPaymentModalBtn)
                        openPaymentModalBtn.addEventListener('click', () => {
                            document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
                            openModal(paymentMethodModal);
                        });
                    if (openVoucherModalBtn)
                        openVoucherModalBtn.addEventListener('click', (e) => {
                            e.preventDefault();
                            openModal(voucherModal);
                        });
                    if (backToPaymentModalBtn)
                        backToPaymentModalBtn.addEventListener('click', () => {
                            closeModal(installmentModal);
                            openModal(paymentMethodModal);
                        });
                    if (backToPaymentModalBtnFromTransfer)
                        backToPaymentModalBtnFromTransfer.addEventListener('click', () => {
                            closeModal(transferModal);
                            openModal(paymentMethodModal);
                        });

                    // --- PAYMENT METHOD SELECTION LOGIC ---
                    document.querySelectorAll('.payment-option').forEach(option => {
                        option.addEventListener('click', (e) => {
                            if (option.dataset.value === 'INSTALLMENT') {
                                const isAgeOk = option.dataset.ageOk === 'true';
                                const isCccdOk = option.dataset.cccdOk === 'true';
                                const hasYob = option.dataset.hasYob === 'true';

                                if (!hasYob || !isCccdOk) {
                                    if (confirm("Bạn cần bổ sung thông tin để sử dụng trả góp. Đi đến trang cập nhật ngay?")) {
                                        window.location.href = "customer/editProfile.jsp?redirect=payment";
                                    }
                                    e.stopPropagation();
                                    return;
                                }
                                if (!isAgeOk) {
                                    alert("Rất tiếc, phương thức trả góp chỉ áp dụng cho khách hàng từ 18 tuổi trở lên.");
                                    e.stopPropagation();
                                    return;
                                }
                            }

                            document.querySelectorAll('.payment-option').forEach(o => o.classList.remove('selected'));
                            option.classList.add('selected');

                            document.querySelectorAll('.check-icon').forEach(i => {
                                i.classList.replace('fa-circle-check', 'fa-circle');
                                i.classList.remove('text-theme');
                            });
                            const icon = option.querySelector('.check-icon');
                            if (icon) {
                                icon.classList.replace('fa-circle', 'fa-circle-check');
                                icon.classList.add('text-theme');
                            }
                        });
                    });

                    // --- CONFIRM PAYMENT SELECTION ---
                    confirmPaymentBtn.addEventListener('click', () => {
                        const selected = document.querySelector('.payment-option.selected');
                        if (!selected) {
                            alert('Vui lòng chọn một phương thức thanh toán.');
                            return;
                        }

                        const val = selected.dataset.value;

                        if (val === 'COD') {
                            updateSelectedPaymentDisplay(selected.dataset.text, selected.dataset.faIconClass);
                            paymentMethodInput.value = 'COD';
                            installmentTermInput.value = '';
                            resetToOriginalPrice(); // Reset giá
                            closeModal(paymentMethodModal);
                        } else if (val === 'INSTALLMENT') {
                            closeModal(paymentMethodModal);
                            openModal(installmentModal);
                        } else if (val === 'TRANSFER') {
                            resetToOriginalPrice(); // Reset giá
                            const totalAmount = <%= (long) finalPaymentTotal%>;
                            const orderId = 'DH' + Math.floor(Date.now() / 1000);
                            const transferDescription = 'TT ' + orderId;

                            document.getElementById('transferContent').innerText = transferDescription;
                            const qrUrl = "https://img.vietqr.io/image/970422-0968418098-compact.png?amount=" + totalAmount + "&addInfo=" + encodeURIComponent(transferDescription) + "&accountName=TRANG TIEN DAT";
                            document.getElementById('qrCodeImage').src = qrUrl;

                            closeModal(paymentMethodModal);
                            openModal(transferModal);

                            if (paymentCheckInterval)
                                clearInterval(paymentCheckInterval);
                            setTimeout(() => {
                                paymentCheckInterval = setInterval(() => checkPaid(transferDescription), 3000);
                            }, 5000);
                        }
                    });

                    // --- INSTALLMENT LOGIC ---
                    document.querySelectorAll('.term-column').forEach(column => {
                        column.addEventListener('click', () => {
                            document.querySelectorAll('.term-column').forEach(col => col.classList.remove('selected'));
                            column.classList.add('selected');
                            selectedInstallmentTerm = column.dataset.term;
                            selectedInstallmentPrice = parseFloat(column.dataset.finalPrice);
                            confirmInstallmentBtn.disabled = false;
                        });
                    });

                    confirmInstallmentBtn.addEventListener('click', () => {
                        if (selectedInstallmentTerm) {
                            updateSelectedPaymentDisplay("Installment " + selectedInstallmentTerm + " months", 'fa-solid fa-credit-card');
                            paymentMethodInput.value = "INSTALLMENT_" + selectedInstallmentTerm + "M";
                            installmentTermInput.value = selectedInstallmentTerm;

                            // Cập nhật giá hiển thị + Note
                            totalPaymentDisplay.textContent = formatCurrency(selectedInstallmentPrice);
                            installmentNote.style.display = 'block';

                            closeModal(installmentModal);
                        }
                    });

                    // --- TRANSFER LOGIC ---
                    confirmTransferBtn.addEventListener('click', () => {
                        const selected = document.querySelector('.payment-option[data-value="TRANSFER"]');
                        if (selected)
                            updateSelectedPaymentDisplay(selected.dataset.text, selected.dataset.faIconClass);
                        paymentMethodInput.value = 'TRANSFER';
                        resetToOriginalPrice();
                        closeModal(transferModal);
                    });

                    document.getElementById('copyContentBtn').addEventListener('click', (e) => {
                        e.preventDefault();
                        navigator.clipboard.writeText(document.getElementById('transferContent').innerText);
                        alert('Đã sao chép nội dung chuyển khoản!');
                    });

                    async function checkPaid(desc) {
                        try {
                            const response = await fetch("https://script.google.com/macros/s/AKfycbwVGFzfs_VMzmWN9kXOcLW2o5HNR407tycQzyyq20NjEOn32MBZw6GSBFVi5uRtWtSwqw/exec");
                            const data = await response.json();
                            const last = data.data[data.data.length - 1];
                            if (last["Mô tả"].includes(desc)) {
                                clearInterval(paymentCheckInterval);
                                paymentMethodInput.value = 'TRANSFER';
                                submitOrderForm();
                            }
                        } catch (e) {
                            console.error(e);
                        }
                    }

                    // --- SUBMIT FORM ---
                    mainSubmitBtn.addEventListener('click', () => {
                        if (!paymentMethodInput.value) {
                            alert('Vui lòng chọn phương thức thanh toán trước khi đặt hàng.');
                            return;
                        }
                        submitOrderForm();
                    });

                    function submitOrderForm() {
                        // SỬA LỖI TẠI ĐÂY: Chỉ tìm input nằm trong paymentForm
                        // Code cũ: let actionInput = document.querySelector('input[name="action"]');
                        let actionInput = paymentForm.querySelector('input[name="action"]');

                        if (!actionInput) {
                            actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            paymentForm.appendChild(actionInput);
                        }
                        actionInput.value = 'createOrder';
                        paymentForm.submit();
                    }
                });
            </script>
        </div>
    </body>
</html>


