<%@page import="model.InterestRate"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="model.Carts"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- BỎ DÒNG isELIgnored="true" HOẶC DÙNG SCRIPTLET NHƯ BÊN DƯỚI --%>
<%@ include file="/layout/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <link rel="stylesheet" type="text/css" href="css/home.css?v=<%=System.currentTimeMillis()%>">
        <link rel="stylesheet" type="text/css" href="css/payment.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f4f7fc;
            }
            .payment-option.selected {
                border-color: #72AEC8;
                box-shadow: 0 0 0 2px rgba(114, 174, 200, 0.4);
            }
            .term-column.selected {
                background-color: #eaf4f7;
                border-color: #72AEC8;
            }
            .term-column.selected .term-button {
                background-color: #72AEC8;
                color: white;
                cursor: default;
            }
            .term-column.selected .term-header {
                color: #72AEC8;
            }
            .text-theme {
                color: #72AEC8;
            }
            .border-theme {
                border-color: #72AEC8;
            }
            .bg-theme {
                background-color: #72AEC8;
            }
            .bg-theme-light {
                background-color: #eaf4f7;
            }
            .hover\:bg-theme-dark:hover {
                background-color: #619db5;
            }
            .term-button {
                border-color: #72AEC8;
                color: #72AEC8;
            }
        </style>
    </head>

    <body class="bg-gray-100">
        <section id="billboard" class="bg-light-blue overflow-hidden padding-large" >
            <div class="container mx-auto max-w-2xl bg-white shadow-lg my-4 sm:my-8 rounded-lg">
                <header class="p-4 border-b flex items-center relative">
                    <button onclick="window.history.back()" class="absolute left-4 text-gray-600 hover:text-gray-900">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                        </svg>
                    </button>
                    <h1 class="text-xl font-semibold text-center w-full">Payment</h1>
                </header>

                <main class="p-4 sm:p-6">
                    <div class="flex justify-center border-b mb-6">
                        <div class="flex-1 text-center py-2 border-b-2 border-gray-200 text-gray-400 font-semibold">
                            <a href="javascript:window.history.back();" class="cursor-pointer hover:text-gray-600">1. INFORMATION</a>
                        </div>
                        <div class="flex-1 text-center py-2 border-b-2 border-theme text-theme font-semibold">
                            <span class="cursor-pointer">2. PAYMENT</span>
                        </div>
                    </div>

                    <%  List<Carts> cartsCheckout = (List<Carts>) session.getAttribute("cartCheckout");
                        ProductDAO pDAO = new ProductDAO();
                        // Lấy các attribute từ Servlet gửi sang
                        String receiverName = (String) request.getAttribute("receiverName");
                        String receiverPhone = (String) request.getAttribute("receiverPhone");
                        String specificAddress = (String) request.getAttribute("specificAddress");
                        String saveAddress = (String) request.getAttribute("saveAddress"); // Lấy biến saveAddress
                        String city = (String) request.getAttribute("city");
                        String address = (String) request.getAttribute("address");

                        double totalPriceBeforeDiscount = 0;
                        double totalPriceAfterDiscount = 0;
                        int totalQuantity = 0;
//                        if (carts != null) {
//                            for (Carts c : cartsCheckout) {
//                                totalPriceBeforeDiscount += c.getVariant().getPrice() * c.getQuantity();
//                                totalPriceAfterDiscount += c.getVariant().getDiscountPrice() * c.getQuantity();
//                                totalQuantity += c.getQuantity();
//                            }
//                        }
                        if (cartsCheckout != null) {
                            for (Carts c : cartsCheckout) {
                                totalPriceBeforeDiscount += c.getVariant().getPrice() * c.getQuantity();
                                totalPriceAfterDiscount += c.getVariant().getDiscountPrice() * c.getQuantity();
                                totalQuantity += c.getQuantity();
                            }
                        }
                        double discountAmount = totalPriceBeforeDiscount - totalPriceAfterDiscount;
                        Double reqVoucherDiscount = (Double) request.getAttribute("discountAmount");
                        double voucherDiscountValue = (reqVoucherDiscount != null) ? reqVoucherDiscount : 0;

                        // Tính TỔNG TIỀN THANH TOÁN CUỐI CÙNG (Final Total)
                        // = Giá bán sản phẩm - Giảm giá Voucher
                        double finalPaymentTotal = totalPriceAfterDiscount - voucherDiscountValue;
                        if (finalPaymentTotal < 0)
                            finalPaymentTotal = 0;
                    %>

                    <div class="space-y-4 mb-6">
                        <h3 class="font-bold text-lg text-gray-700">SHIPPING INFORMATION</h3>
                        <div class="border rounded-lg p-4 bg-gray-50 space-y-3 text-sm">
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Receiver</span>
                                <span class="font-semibold text-gray-800"><%= receiverName != null ? receiverName : "Not available"%> - <%= receiverPhone != null ? receiverPhone : "Not available"%></span>
                            </div>
                            <div class="flex justify-between items-start">
                                <span class="text-gray-500">Shipping Address</span>
                                <span class="font-semibold text-gray-800 text-right max-w-xs"><%= specificAddress != null ? specificAddress : "No address provided"%></span>
                            </div>
                        </div>
                    </div>
                    <div class="space-y-4 mb-6">
                        <h3 class="font-bold text-lg text-gray-700">VOUCHER</h3>

                        <%-- Hiển thị thông báo --%>
                        <% String voucherMsg = (String) request.getAttribute("voucherMsg"); %>
                        <% if (voucherMsg != null && !voucherMsg.isEmpty()) {%>
                        <div class="text-sm p-2 rounded mb-2 <%= voucherMsg.contains("success") ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"%>">
                            <%= voucherMsg%>
                        </div>
                        <% } %>

                        <% model.Vouchers appliedVoucher = (model.Vouchers) session.getAttribute("appliedVoucher"); %>

                      
                        <div class="border rounded-lg p-4 bg-white">
                            <% if (appliedVoucher == null) {%>

                            <%-- Form nhập tay --%>
                            <form action="payment" method="post" class="flex gap-2 mb-2">
                                <input type="hidden" name="action" value="applyVoucher">
                                <%-- Các input hidden giữ thông tin shipping --%>
                                <input type="hidden" name="receiverName" value="<%= receiverName%>">
                                <input type="hidden" name="receiverPhone" value="<%= receiverPhone%>">
                                <input type="hidden" name="city" value="<%= city%>">
                                <input type="hidden" name="address" value="<%= address%>">
                                <input type="hidden" name="saveAddress" value="<%= saveAddress%>">

                                <input type="text" name="voucherCode" placeholder="Enter Code" class="flex-1 border rounded px-3 py-2 text-sm uppercase">
                                <button type="submit" class="bg-gray-800 text-white px-4 py-2 rounded text-sm hover:bg-gray-700">Apply</button>
                            </form>

                            <%-- [MỚI] Nút mở Modal danh sách voucher --%>
                            <button type="button" id="openVoucherModalBtn" class="w-full border border-theme text-theme py-2 rounded text-sm font-medium hover:bg-blue-50 transition-colors">
                                <i class="fa-solid fa-tags mr-2"></i> Select from My Vouchers
                            </button>

                            <% } else {%>
                            <%-- Phần hiển thị khi ĐÃ áp dụng voucher (Giữ nguyên code cũ của bạn) --%>
                            <div class="flex justify-between items-center">
                                <div>
                                    <p class="font-semibold text-theme"><i class="fa-solid fa-ticket mr-2"></i><%= appliedVoucher.getCode()%></p>
                                    <p class="text-xs text-green-600">Reduced: -<%= String.format("%,.0f", voucherDiscountValue)%> VND</p>
                                </div>
                                <form action="payment" method="post">
                                    <input type="hidden" name="action" value="removeVoucher">
                                    <%-- Các input hidden giữ thông tin shipping --%>
                                    <input type="hidden" name="receiverName" value="<%= receiverName%>">
                                    <input type="hidden" name="receiverPhone" value="<%= receiverPhone%>">
                                    <input type="hidden" name="city" value="<%= city%>">
                                    <input type="hidden" name="address" value="<%= address%>">
                                    <input type="hidden" name="saveAddress" value="<%= saveAddress%>">
                                    <button type="submit" class="text-red-500 text-sm font-medium hover:underline">Remove</button>
                                </form>
                            </div>
                            <% }%>
                        </div>
                    </div>
                    <div class="space-y-4">
                        <h3 class="font-bold text-lg text-gray-700">ORDER SUMMARY</h3>
                        <div class="border rounded-lg p-4 space-y-4 bg-theme-light">
                            <div class="space-y-3 text-sm text-gray-700 pt-2">
                                <div class="flex justify-between">
                                    <span>Subtotal</span>
                                    <span class="font-semibold"><%= String.format("%,.0f", totalPriceBeforeDiscount)%> VND</span>
                                </div>
                                <% if (discountAmount > 0) {%>
                                <div class="flex justify-between">
                                    <span>Discount</span>
                                    <span class="font-semibold text-theme">-<%= String.format("%,.0f", discountAmount)%> VND</span>
                                </div>
                                <% }%>
                                
                                <% if (voucherDiscountValue > 0) {%>
                                <div class="flex justify-between text-theme">
                                    <span>Voucher Applied</span>
                                    <span class="font-semibold">-<%= String.format("%,.0f", voucherDiscountValue)%> VND</span>
                                </div>
                                <% }%>
                                <hr class="my-2 border-dashed">
                                <div class="flex justify-between items-center">
                                    <span class="font-semibold">Total</span>
                                    <div class="text-right">
                                        <p id="totalOrderAmount" class="font-bold text-lg text-theme" data-amount="<%= finalPaymentTotal%>"><%= String.format("%,.0f", finalPaymentTotal)%> VND</p>
                                        <p class="text-xs text-gray-500">VAT included</p>
                                    </div>
                                </div>
                            </div>

                            <form action="payment" method="post" id="payment-form">
                                <input type="hidden" name="action" value="createOrder">
                                <input type="hidden" name="receiverName" value="<%= receiverName%>">
                                <input type="hidden" name="receiverPhone" value="<%= receiverPhone%>">
                                <input type="hidden" name="specificAddress" value="<%= specificAddress%>">
                                <input type="hidden" name="totalAmount" value="<%= finalPaymentTotal%>">
                                <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="">
                                <input type="hidden" name="installmentTerm" id="installmentTermInput" value="">

                                <%-- FIX 1: Dùng scriptlet thay vì EL vì page isELIgnored="true" --%>
                                <input type="hidden" name="saveAddress" value="<%= saveAddress != null ? saveAddress : ""%>">

                                <%-- FIX 1: Dùng scriptlet thay vì EL vì page isELIgnored="true" --%>
                                <input type="hidden" name="saveAddress" value="<%= saveAddress != null ? saveAddress : ""%>">

                                <div class="border-t pt-4">
                                    <h4 class="font-semibold text-gray-800 mb-3">Select a payment method:</h4>
                                    <div id="openPaymentModalBtn" class="border rounded-lg p-3 flex justify-between items-center cursor-pointer hover:bg-gray-100 bg-white">
                                        <div class="flex items-center space-x-4">
                                            <i id="selected-payment-icon" class="text-theme text-2xl w-8 text-center hidden"></i>
                                            <span id="selected-payment-text" class="font-medium text-gray-700">Please select a payment method</span>
                                        </div>
                                        <i class="fa-solid fa-chevron-right text-gray-400"></i>
                                    </div>
                                </div>

                                <div class="mt-4">
                                    <button type="submit" class="w-full bg-theme text-white font-bold py-3 rounded-lg hover:bg-theme-dark transition-colors text-base">
                                        Confirm and Place Order
                                    </button>
                                    <div class="text-center mt-3">
                                        <a href="#" id="openProductListModalBtn" class="text-theme font-semibold text-sm hover:underline">
                                            Check product list (<%= totalQuantity%>)
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>

            <div id="productModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 hidden">
                <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
                    <div class="p-4 border-b flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800">Products in Order</h2>
                        <button class="js-close-modal text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                    </div>
                    <div class="p-4 space-y-4 max-h-[60vh] overflow-y-auto">
                        <% if (carts != null && !carts.isEmpty()) {
                                for (Carts c : carts) {%>
                        <div class="flex items-start space-x-4">
                            <img src="images/<%= c.getVariant().getImageUrl()%>" alt="Product Image" class="w-20 h-20 object-contain border rounded-md">
                            <div class="flex-1">
                                <p class="font-semibold text-sm text-gray-800"><%= pDAO.getProductByID(c.getVariant().getProductID()).getName() + " " + c.getVariant().getStorage() + " " + c.getVariant().getColor()%></p>
                                <div class="flex items-center space-x-2 mt-1">
                                    <p class="font-bold text-theme text-sm"><%= String.format("%,.0f", c.getVariant().getDiscountPrice())%> VND</p>
                                    <p class="text-gray-500 line-through text-xs"><%= String.format("%,.0f", c.getVariant().getPrice())%> VND</p>
                                </div>
                                <p class="text-sm text-gray-600 mt-1">Quantity: <span class="font-semibold"><%= c.getQuantity()%></span></p>
                            </div>
                        </div>
                        <%  }
                        } else { %>
                        <p>There are no products in the cart.</p>
                        <% } %>
                    </div>
                </div>
            </div>

            <div id="paymentMethodModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-end sm:items-center justify-center p-0 sm:p-4 z-[60] hidden">
                <div class="bg-white rounded-t-lg sm:rounded-lg shadow-xl w-full max-w-2xl">
                    <div class="p-4 border-b flex justify-between items-center">
                        <h2 class="text-lg font-semibold text-gray-800">Select Payment Method</h2>
                        <button class="js-close-modal text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                    </div>
                    <div class="p-4 space-y-3 max-h-[70vh] overflow-y-auto">
                        <div class="payment-option border rounded-lg p-4 flex items-center cursor-pointer" data-value="COD" data-text="Cash on Delivery" data-fa-icon-class="fa-solid fa-money-bill-wave">
                            <div class="flex-grow flex items-center space-x-4">
                                <i class="fa-solid fa-money-bill-wave text-theme text-2xl w-8 text-center"></i>
                                <span class="font-medium">Cash on Delivery</span>
                            </div>
                        </div>
                        <div id="openInstallmentModalBtn" class="payment-option border rounded-lg p-4 flex items-center cursor-pointer" data-value="INSTALLMENT" data-text="Installment via Card/Wallet" data-fa-icon-class="fa-solid fa-credit-card">
                            <div class="flex-grow flex items-center space-x-4">
                                <i class="fa-solid fa-credit-card text-theme text-2xl w-8 text-center"></i>
                                <span class="font-medium">Installment via Card/Wallet</span>
                            </div>
                        </div>
                        <div id="openTransferModalBtn" class="payment-option border rounded-lg p-4 flex items-center cursor-pointer" data-value="TRANSFER" data-text="Payment via Bank Transfer" data-fa-icon-class="fa-solid fa-building-columns">
                            <div class="flex-grow flex items-center space-x-4">
                                <i class="fa-solid fa-building-columns text-theme text-2xl w-8 text-center"></i>
                                <span class="font-medium">Payment via Bank Transfer</span>
                            </div>
                        </div>
                    </div>
                    <div class="p-4 border-t">
                        <button id="confirmPaymentBtn" class="w-full bg-theme text-white font-bold py-3 rounded-lg hover:bg-theme-dark">Confirm</button>
                    </div>
                </div>
            </div>

            <div id="installmentModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-end sm:items-center justify-center p-0 sm:p-4 z-[70] hidden">
                <div class="bg-white rounded-t-lg sm:rounded-lg shadow-xl w-full max-w-2xl">
                    <div class="p-4 border-b flex items-center relative">
                        <button id="backToPaymentModalBtn" class="absolute left-4 text-gray-600 hover:text-gray-900"><i class="fa-solid fa-arrow-left"></i></button>
                        <h2 class="text-lg font-semibold text-gray-800 w-full text-center">Choose Installment Plan</h2>
                        <button class="js-close-modal absolute right-4 text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                    </div>
                    <div class="p-4 space-y-4">
                        <p class="text-sm font-semibold">2. Select payment term</p>
                        <div id="installmentTermContainer" class="w-full overflow-x-auto">
                            <div class="flex text-center text-sm">
                                <div class="w-1/4 font-semibold text-left flex flex-col pr-2">
                                    <div class="h-12 flex items-center">Term</div>
                                    <div class="h-10 flex items-center">Platform Fee</div>
                                    <div class="h-10 flex items-center">Interest Rate</div>
                                    <div class="h-10 flex items-center">Monthly Payment</div>
                                    <div class="h-10 flex items-center">Total Amount</div>
                                </div>
                                <% List<InterestRate> iRList = (List<InterestRate>) request.getAttribute("iRList"); %>
                                <div class="w-3/4 flex">
                                    <% for (InterestRate iR : iRList) { %>
                                    <%
                                        double instalmentPrice = (totalPriceAfterDiscount * iR.getPercent()) / 100;
                                        double totalPriceEachMothPay = (totalPriceAfterDiscount + instalmentPrice) / iR.getInstalmentPeriod();
                                        double totalPriceAfterInstalment = totalPriceAfterDiscount + instalmentPrice;
                                    %>
                                    <div class="term-column w-1/3 border rounded-md p-2 mx-1 flex flex-col" data-term="<%=iR.getInstalmentPeriod()%>">
                                        <div class="flex-grow">
                                            <div class="h-12 flex items-center justify-center font-bold term-header"><%=iR.getInstalmentPeriod()%> months</div>
                                            <div class="h-10 flex items-center justify-center"><%= String.format("%,.0f", instalmentPrice)%> VND</div>
                                            <div class="h-10 flex items-center justify-center text-theme font-semibold"><%=iR.getPercent()%>%/year</div>
                                            <div class="h-10 flex items-center justify-center font-semibold"><%= String.format("%,.0f", totalPriceEachMothPay)%> VND</div>
                                            <div class="h-10 flex items-center justify-center font-semibold"><%= String.format("%,.0f", totalPriceAfterInstalment)%> VND</div>
                                        </div>
                                        <button class="term-button mt-2 w-full py-1 border rounded-md font-semibold">SELECT</button>
                                    </div>
                                    <% }%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="p-4 border-t">
                        <button id="confirmInstallmentBtn" class="w-full bg-theme text-white font-bold py-3 rounded-lg hover:bg-theme-dark disabled:bg-gray-400" disabled>
                            Confirm
                        </button>
                    </div>
                </div>
            </div>

            <div id="transferModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-end sm:items-center justify-center p-0 sm:p-4 z-[70] hidden">
                <div class="bg-white rounded-t-lg sm:rounded-lg shadow-xl w-full max-w-md">
                    <div class="p-4 border-b flex items-center relative">
                        <button id="backToPaymentModalBtnFromTransfer" class="absolute left-4 text-gray-600 hover:text-gray-900"><i class="fa-solid fa-arrow-left"></i></button>
                        <h2 class="text-lg font-semibold text-gray-800 w-full text-center">Bank Transfer Information</h2>
                        <button class="js-close-modal absolute right-4 text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                    </div>
                    <div class="p-6 text-center">
                        <p class="text-sm text-gray-600 mb-4">Scan the QR code to pay or use the details below for a manual transfer.</p>
                        <div class="flex justify-center mb-4">
                            <img id="qrCodeImage" src="" alt="QR Code" class="w-48 h-48 border rounded-lg">
                        </div>
                        <div class="space-y-3 text-left bg-gray-50 p-4 rounded-lg">
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Amount:</span>
                                <span class="font-bold text-lg text-theme"><%= String.format("%,.0f", totalPriceAfterDiscount)%> VND</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Bank:</span>
                                <span class="font-semibold text-gray-800">MB Bank</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Account Holder:</span>
                                <span class="font-semibold text-gray-800">TRANG TIEN DAT</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Content:</span>
                                <div class="flex items-center space-x-2">
                                    <span id="transferContent" class="font-semibold" style="color: #3B82F6;"></span>
                                    <button id="copyContentBtn" class="text-gray-500 hover:text-blue-600" title="Copy">
                                        <i class="fa-regular fa-copy"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <p class="text-xs text-gray-500 mt-4">Note: Please enter the correct transfer content for automatic order confirmation.</p>
                    </div>
                    <div class="p-4 border-t">
                        <button id="confirmTransferBtn" class="w-full bg-theme text-white font-bold py-3 rounded-lg hover:bg-theme-dark">
                            Confirm
                        </button>
                    </div>
                </div>
            </div>

        </section>
        <%-- [MỚI] MODAL DANH SÁCH VOUCHER --%>
        <div id="voucherModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-[80] hidden">
            <div class="bg-white rounded-lg shadow-xl w-full max-w-md h-[80vh] flex flex-col">
                <%-- Header Modal --%>
                <div class="p-4 border-b flex justify-between items-center">
                    <h2 class="text-lg font-semibold text-gray-800">My Vouchers</h2>
                    <button class="js-close-modal text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
                </div>

                <%-- Body Modal (List) --%>
                <div class="p-4 flex-1 overflow-y-auto bg-gray-50 space-y-3">
                    <%
                        List<model.Vouchers> myVouchers = (List<model.Vouchers>) request.getAttribute("myVouchers");
                        if (myVouchers != null && !myVouchers.isEmpty()) {
                            for (model.Vouchers v : myVouchers) {
                                boolean isUsable = "Active".equalsIgnoreCase(v.getStatus()) && v.getQuantity() > 0;
                    %>
                    <div class="bg-white border <%= isUsable ? "border-gray-200" : "border-gray-100 opacity-60"%> rounded-lg p-3 shadow-sm relative overflow-hidden">
                        <%-- Trang trí chấm tròn --%>
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
                                    <%-- Các input hidden để giữ lại thông tin form --%>
                                    <input type="hidden" name="receiverName" value="<%= receiverName%>">
                                    <input type="hidden" name="receiverPhone" value="<%= receiverPhone%>">
                                    <input type="hidden" name="city" value="<%= city%>">
                                    <input type="hidden" name="address" value="<%= address%>">
                                    <input type="hidden" name="saveAddress" value="<%= saveAddress%>">

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
        // --- CÁC BIẾN DOM ---
        const productModal = document.getElementById('productModal');
        const paymentMethodModal = document.getElementById('paymentMethodModal');
        const installmentModal = document.getElementById('installmentModal');
        const transferModal = document.getElementById('transferModal');
        
        // ============================================================
        // [VOUCHER] 1. KHAI BÁO BIẾN CHO VOUCHER Ở ĐÂY
        // ============================================================
        const voucherModal = document.getElementById('voucherModal'); 
        const openVoucherModalBtn = document.getElementById('openVoucherModalBtn');
        // ============================================================

        const openProductListModalBtn = document.getElementById('openProductListModalBtn');
        const openPaymentModalBtn = document.getElementById('openPaymentModalBtn');
        const openInstallmentModalBtn = document.getElementById('openInstallmentModalBtn');
        const openTransferModalBtn = document.getElementById('openTransferModalBtn');

        const backToPaymentModalBtn = document.getElementById('backToPaymentModalBtn');
        const backToPaymentModalBtnFromTransfer = document.getElementById('backToPaymentModalBtnFromTransfer');
        const confirmPaymentBtn = document.getElementById('confirmPaymentBtn');
        const confirmInstallmentBtn = document.getElementById('confirmInstallmentBtn');
        const confirmTransferBtn = document.getElementById('confirmTransferBtn');
        const copyContentBtn = document.getElementById('copyContentBtn');
        const paymentMethodInput = document.getElementById('paymentMethodInput');
        const installmentTermInput = document.getElementById('installmentTermInput');
        const selectedPaymentText = document.getElementById('selected-payment-text');
        const selectedPaymentIcon = document.getElementById('selected-payment-icon');
        let selectedInstallmentTerm = null;

        // --- BIẾN QUẢN LÝ POLLING ---
        let paymentCheckInterval = null;
        const paymentForm = document.getElementById('payment-form');

        // Hàm mở Modal (Dùng chung cho tất cả, bao gồm cả Voucher)
        const openModal = (modal) => modal.classList.remove('hidden');

        const closeModal = (modal) => {
            modal.classList.add('hidden');
            if (modal.id === 'transferModal' && paymentCheckInterval) {
                clearInterval(paymentCheckInterval);
            }
        };

        // Close modal listeners
        document.querySelectorAll('.fixed[id$="Modal"]').forEach(modal => {
            modal.querySelectorAll('.js-close-modal').forEach(button => {
                button.addEventListener('click', () => closeModal(modal));
            });
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    closeModal(modal);
                }
            });
        });

        function updateSelectedPaymentDisplay(text, iconClass) {
            selectedPaymentText.textContent = text;
            selectedPaymentText.classList.remove('text-gray-700');
            selectedPaymentText.classList.add('text-gray-800');
            selectedPaymentIcon.className = 'text-theme text-2xl w-8 text-center';
            if (iconClass) {
                const classes = iconClass.split(' ');
                selectedPaymentIcon.classList.add(...classes);
                selectedPaymentIcon.classList.remove('hidden');
            } else {
                selectedPaymentIcon.classList.add('hidden');
            }
        }

        // --- Modal Navigation Listeners ---
        openProductListModalBtn.addEventListener('click', (e) => {
            e.preventDefault();
            openModal(productModal);
        });

        openPaymentModalBtn.addEventListener('click', () => {
            document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
            const currentMethod = paymentMethodInput.value;
            if (currentMethod) {
                const currentSelection = document.querySelector(`.payment-option[data-value^="${currentMethod.split('_')[0]}"]`);
                if (currentSelection) {
                    currentSelection.classList.add('selected');
                }
            }
            openModal(paymentMethodModal);
        });

        // ============================================================
        // [VOUCHER] 2. LOGIC MỞ MODAL VOUCHER KHI BẤM NÚT
        // ============================================================
        if (openVoucherModalBtn) {
            openVoucherModalBtn.addEventListener('click', (e) => {
                e.preventDefault(); // Chặn load lại trang
                openModal(voucherModal); // Gọi hàm mở modal
            });
        }
        // ============================================================

        backToPaymentModalBtn.addEventListener('click', () => {
            closeModal(installmentModal);
            openModal(paymentMethodModal);
        });

        backToPaymentModalBtnFromTransfer.addEventListener('click', () => {
            closeModal(transferModal);
            openModal(paymentMethodModal);
        });

        openInstallmentModalBtn.addEventListener('click', (e) => {
            document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
            e.currentTarget.classList.add('selected');
            closeModal(paymentMethodModal);
            openModal(installmentModal);
        });

        // --- QR CODE GENERATION ---
        openTransferModalBtn.addEventListener('click', (e) => {
            document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
            e.currentTarget.classList.add('selected');
            const qrCodeImage = document.getElementById('qrCodeImage');

            const totalElement = document.getElementById('totalOrderAmount'); 
            const totalAmount = totalElement ? parseInt(totalElement.getAttribute('data-amount')) : 2000;

            const orderId = 'DH' + Math.floor(Date.now() / 1000);
            const transferDescription = 'TT ' + orderId;
            document.getElementById('transferContent').innerText = transferDescription;

            const bankId = "970422";
            const accountNumber = "0968418098";
            const accountName = "TRANG TIEN DAT";

            const encodedDescription = encodeURIComponent(transferDescription);
            const encodedAccountName = encodeURIComponent(accountName);
            const cacheBuster = `&t=${Date.now()}`;
            const vietQrApiUrl = `https://img.vietqr.io/image/${bankId}-${accountNumber}-compact.png?amount=${totalAmount}&addInfo=${encodedDescription}&accountName=${encodedAccountName}${cacheBuster}`;

            qrCodeImage.src = vietQrApiUrl;
            closeModal(paymentMethodModal);
            openModal(transferModal);

            if (paymentCheckInterval) {
                clearInterval(paymentCheckInterval);
            }

            setTimeout(() => {
                paymentCheckInterval = setInterval(() => {
                    checkPaid(transferDescription);
                }, 3000);
            }, 5000);
        });

        async function checkPaid(description) {
            try {
                const response = await fetch("https://script.google.com/macros/s/AKfycbwVGFzfs_VMzmWN9kXOcLW2o5HNR407tycQzyyq20NjEOn32MBZw6GSBFVi5uRtWtSwqw/exec");
                const data = await response.json();
                const lastPaid = data.data[data.data.length - 1];
                const lastDescription = lastPaid["Mô tả"];

                if (lastDescription.includes(description)) {
                    alert("Payment successful!");
                    clearInterval(paymentCheckInterval);
                    paymentMethodInput.value = 'TRANSFER';
                    installmentTermInput.value = '';
                    paymentForm.submit();
                }
            } catch (error) {
                console.error("Error checking payment:", error);
            }
        }

        confirmPaymentBtn.addEventListener('click', () => {
            const selectedOption = document.querySelector('.payment-option.selected');
            if (selectedOption && selectedOption.dataset.value === 'COD') {
                updateSelectedPaymentDisplay(selectedOption.dataset.text, selectedOption.dataset.faIconClass);
                paymentMethodInput.value = selectedOption.dataset.value;
                installmentTermInput.value = '';
                closeModal(paymentMethodModal);
            } else if (selectedOption) {
                if (selectedOption.dataset.value === 'INSTALLMENT') {
                    openInstallmentModalBtn.click();
                } else if (selectedOption.dataset.value === 'TRANSFER') {
                    openTransferModalBtn.click();
                }
            } else {
                alert('Please select a payment method.');
            }
        });

        confirmInstallmentBtn.addEventListener('click', () => {
            if (selectedInstallmentTerm) {
                const text = `Installment ${selectedInstallmentTerm} months`;
                const iconClass = document.getElementById('openInstallmentModalBtn').dataset.faIconClass;
                const value = `INSTALLMENT_${selectedInstallmentTerm}M`;
                updateSelectedPaymentDisplay(text, iconClass);
                paymentMethodInput.value = value;
                installmentTermInput.value = selectedInstallmentTerm;
                closeModal(installmentModal);
            } else {
                alert('Please select an installment term.');
            }
        });

        confirmTransferBtn.addEventListener('click', () => {
            const selectedOption = document.querySelector('.payment-option[data-value="TRANSFER"]');
            updateSelectedPaymentDisplay(selectedOption.dataset.text, selectedOption.dataset.faIconClass);
            paymentMethodInput.value = selectedOption.dataset.value;
            installmentTermInput.value = '';
            closeModal(transferModal);
        });

        document.querySelectorAll('.term-column').forEach(column => {
            column.addEventListener('click', () => {
                document.querySelectorAll('.term-column').forEach(col => col.classList.remove('selected'));
                column.classList.add('selected');
                selectedInstallmentTerm = column.dataset.term;
                confirmInstallmentBtn.disabled = false;
            });
        });

        copyContentBtn.addEventListener('click', (e) => {
            e.preventDefault(); 
            const content = document.getElementById('transferContent').innerText;
            navigator.clipboard.writeText(content).then(() => {
                alert('Copied content: ' + content);
            });
        });

        document.querySelectorAll('.payment-option').forEach(option => {
            option.addEventListener('click', () => {
                document.querySelectorAll('.payment-option')
                        .forEach(o => o.classList.remove('selected'));
                option.classList.add('selected');
            });
        });
    });
</script>

    </body>
</html> 

