<%@page import="model.InterestRate"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="model.Carts"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/layout/header.jsp" %>

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
            /* ======================================================= */
            /* 3. CẤU HÌNH MÀU SẮC RIÊNG BIỆT                        */
            /* ======================================================= */
            :root { 
                /* MÀU CHỦ ĐẠO (BUTTON, ICON CHUNG) -> HỒNG/ĐỎ */
                --main-color: #FF424F; 
                --main-hover: #e03a45;
                
                /* MÀU RIÊNG CHO ĐỊA CHỈ -> XANH DƯƠNG */
                --addr-border: #72AEC8;
                --addr-bg: #f8fcfd;
                --addr-text: #007bff;
            }

            /* Reset cho vùng Payment để không ảnh hưởng Header */
            .payment-wrapper { 
                font-family: 'Poppins', sans-serif; 
                background-color: #f8f9fa; 
                min-height: 100vh;
                padding-bottom: 50px;
            }
            .payment-wrapper *, .payment-wrapper *::before, .payment-wrapper *::after { box-sizing: border-box; }

            /* --- HELPER CLASSES --- */
            .text-main { color: var(--main-color) !important; }
            .bg-main { background-color: var(--main-color) !important; }
            
            /* --- CONTAINER --- */
            .payment-container {
                max-width: 42rem; margin: 2rem auto; background-color: #ffffff;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); border-radius: 12px; position: relative; overflow: hidden;
            }
            
            /* Header Form */
            .payment-form-header {
                padding: 1.25rem; border-bottom: 1px solid #f0f0f0; 
                display: flex; align-items: center; justify-content: center; position: relative; background: #fff;
            }
            .header-title { font-size: 1.2rem; font-weight: 700; color: #111; margin: 0; }
            .back-button { position: absolute; left: 1rem; background: none; border: none; cursor: pointer; color: #666; padding: 5px; }
            .back-button:hover { color: var(--main-color); }

            .payment-main { padding: 1.5rem; }

            /* --- CÁC KHỐI THÔNG TIN --- */
            .section-title { 
                font-weight: 700; font-size: 0.95rem; color: #555; 
                margin-bottom: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; margin-top: 1.5rem; 
            }
            .recipient-info-section:first-of-type .section-title { margin-top: 0; }

            .info-box {
                background-color: #fafafa; border: 1px solid #eee; border-radius: 8px; padding: 1rem;
                display: flex; flex-direction: column; gap: 0.8rem;
            }
            .info-row { display: flex; justify-content: space-between; }
            .info-label { color: #666; font-weight: 500; font-size: 0.9rem; }
            .info-value { color: #222; font-weight: 600; font-size: 0.95rem; text-align: right;}

            /* --- ĐỊA CHỈ (MÀU XANH THEO YÊU CẦU) --- */
            .selected-addr-box {
                border: 1px solid var(--addr-border); 
                background-color: var(--addr-bg); 
                border-radius: 8px;
                padding: 16px; display: flex; align-items: flex-start; gap: 12px;
            }
            .selected-addr-box i { color: var(--addr-border); margin-top: 3px; font-size: 1.2rem;}
            .change-addr-text { color: var(--addr-text); font-weight: 600; font-size: 0.85rem; text-transform: uppercase; text-decoration: none; cursor: pointer; white-space: nowrap;}

            /* --- NÚT CHỌN THANH TOÁN --- */
            .payment-selector-box {
                border: 1px solid #eee; border-radius: 8px; padding: 14px;
                display: flex; justify-content: space-between; align-items: center;
                cursor: pointer; background-color: white; transition: all 0.2s;
            }
            .payment-selector-box:hover { border-color: var(--main-color); background-color: #fff0f1; }

            /* --- TỔNG KẾT & NÚT ĐẶT HÀNG (MÀU HỒNG) --- */
            .summary-box { 
                background-color: #f8f9fa; margin-top: 25px; border: 1px solid #eee; 
                border-radius: 8px; padding: 1.25rem; display: flex; flex-direction: column; gap: 1rem; 
            }
            
            #confirm-btn {
                width: 100%; 
                background-color: var(--main-color); /* HỒNG */
                color: white; font-weight: 600; font-size: 1rem;
                border: none; border-radius: 8px; /* Bo góc vừa phải như ảnh Place Order */
                padding: 14px; cursor: pointer; margin-top: 24px; 
                transition: background 0.3s;
                box-shadow: 0 4px 10px rgba(255, 66, 79, 0.3);
            }
            #confirm-btn:hover { background-color: var(--main-hover); }

            .check-product-link {
                color: var(--main-color); font-weight: 500; font-size: 0.85rem; 
                text-decoration: none; cursor: pointer; display: block; text-align: center; margin-top: 10px;
            }
            .check-product-link:hover { text-decoration: underline; }

            /* --- STYLE CHO MODAL (Dùng chung màu hồng cho đồng bộ nút Confirm) --- */
            .payment-option.selected { border-color: var(--main-color); box-shadow: 0 0 0 1px var(--main-color) inset; background-color: #fff0f1; }
            .term-column.selected { background-color: #fff0f1; border-color: var(--main-color); }
            .term-column.selected .term-button { background-color: var(--main-color); color: white; cursor: default; border-color: var(--main-color); }
            .term-button { border-color: var(--main-color); color: var(--main-color); }
            .hover\:bg-theme-dark:hover { background-color: var(--main-hover) !important; }
            .bg-theme { background-color: var(--main-color) !important; }
            .text-theme { color: var(--main-color) !important; }
            
            #qrCodeImage { max-width: 100%; height: auto; }
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
                    <input type="hidden" name="action" value="createOrder">
                    <input type="hidden" name="receiverName" value="<%= receiverName%>">
                    <input type="hidden" name="receiverPhone" value="<%= receiverPhone%>">
                    <input type="hidden" name="specificAddress" value="<%= specificAddress%>">
                    <input type="hidden" name="totalAmount" value="<%= totalPriceAfterDiscount%>">
                    <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="">
                    <input type="hidden" name="installmentTerm" id="installmentTermInput" value="">
                    <input type="hidden" name="saveAddress" value="<%= saveAddress != null ? saveAddress : ""%>">

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
                        <% } %>
                        <hr style="border-top: 1px dashed #ddd; margin: 5px 0;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <p style="font-weight: 600; color:#333;">Total Payment</p>
                            <div style="text-align: right;">
                                <p style="color: var(--main-color); font-weight: 700; font-size: 1.25rem;">
                                    <%= String.format("%,.0f", totalPriceAfterDiscount)%> VND
                                </p>
                            </div>
                        </div>
                        
                        <% if (totalQuantity > 0) { %>
                        <a id="openProductListModalBtn" class="check-product-link">
                            Check product list (<%= totalQuantity %> items) <i class="fa-solid fa-chevron-right text-xs"></i>
                        </a>
                        <% } %>
                    </div>

                    <button type="button" id="confirm-btn">Place Order</button>
                </form>
            </div>
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
                    <% } %>
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
                    <div id="openInstallmentModalBtn" class="payment-option border rounded-lg p-4 flex items-center cursor-pointer hover:bg-gray-50 transition-all" data-value="INSTALLMENT" data-text="Installment via Card/Wallet" data-fa-icon-class="fa-solid fa-credit-card">
                        <div class="flex-grow flex items-center space-x-4">
                            <i class="fa-solid fa-credit-card text-theme text-2xl w-8 text-center"></i>
                            <span class="font-medium">Installment via Card/Wallet</span>
                        </div>
                        <i class="fa-solid fa-chevron-right text-gray-400"></i>
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
                                <% if (iRList != null) { for (InterestRate iR : iRList) {
                                        double instalmentPrice = (totalPriceAfterDiscount * iR.getPercent()) / 100;
                                        double totalPriceEachMothPay = (totalPriceAfterDiscount + instalmentPrice) / iR.getInstalmentPeriod();
                                        double totalPriceAfterInstalment = totalPriceAfterDiscount + instalmentPrice;
                                %>
                                <div class="term-column w-1/3 border rounded-md p-2 mx-1 flex flex-col cursor-pointer transition-colors" data-term="<%=iR.getInstalmentPeriod()%>">
                                    <div class="flex-grow">
                                        <div class="h-12 flex items-center justify-center font-bold term-header text-theme"><%=iR.getInstalmentPeriod()%> months</div>
                                        <div class="h-10 flex items-center justify-center text-xs"><%= String.format("%,.0f", instalmentPrice)%> đ</div>
                                        <div class="h-10 flex items-center justify-center text-xs font-semibold"><%=iR.getPercent()%>%</div>
                                        <div class="h-10 flex items-center justify-center font-semibold text-sm"><%= String.format("%,.0f", totalPriceEachMothPay)%> đ</div>
                                        <div class="h-10 flex items-center justify-center font-semibold text-sm"><%= String.format("%,.0f", totalPriceAfterInstalment)%> đ</div>
                                    </div>
                                    <button class="term-button mt-2 w-full py-1 border rounded-md font-semibold text-xs transition-colors">SELECT</button>
                                </div>
                                <% }} %>
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
                            <span class="font-bold text-theme text-lg"><%= String.format("%,.0f", totalPriceAfterDiscount)%> VND</span>
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

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                // DOM ELEMENTS
                const openProductListModalBtn = document.getElementById('openProductListModalBtn');
                const productModal = document.getElementById('productModal');
                
                const paymentMethodModal = document.getElementById('paymentMethodModal');
                const installmentModal = document.getElementById('installmentModal');
                const transferModal = document.getElementById('transferModal');
                
                const openPaymentModalBtn = document.getElementById('openPaymentModalBtn');
                const confirmPaymentBtn = document.getElementById('confirmPaymentBtn');
                const confirmInstallmentBtn = document.getElementById('confirmInstallmentBtn');
                const confirmTransferBtn = document.getElementById('confirmTransferBtn');
                
                const backToPaymentModalBtn = document.getElementById('backToPaymentModalBtn');
                const backToPaymentModalBtnFromTransfer = document.getElementById('backToPaymentModalBtnFromTransfer');
                
                const paymentMethodInput = document.getElementById('paymentMethodInput');
                const installmentTermInput = document.getElementById('installmentTermInput');
                const selectedPaymentText = document.getElementById('selected-payment-text');
                const selectedPaymentIcon = document.getElementById('selected-payment-icon');
                
                let selectedInstallmentTerm = null;
                let paymentCheckInterval = null;

                // --- HELPER FUNCTIONS ---
                const openModal = (modal) => modal.classList.remove('hidden');
                const closeModal = (modal) => {
                    modal.classList.add('hidden');
                    if (modal.id === 'transferModal' && paymentCheckInterval) clearInterval(paymentCheckInterval);
                };

                document.querySelectorAll('.js-close-modal').forEach(btn => {
                    btn.addEventListener('click', (e) => { e.preventDefault(); closeModal(e.target.closest('.fixed')); });
                });

                // --- PRODUCT MODAL ---
                if(openProductListModalBtn) {
                    openProductListModalBtn.addEventListener('click', (e) => {
                        e.preventDefault();
                        openModal(productModal);
                    });
                }

                // --- PAYMENT LOGIC ---
                function updateSelectedPaymentDisplay(text, iconClass) {
                    selectedPaymentText.textContent = text;
                    selectedPaymentText.style.color = "#333";
                    selectedPaymentIcon.className = 'text-theme text-2xl w-8 text-center ' + iconClass;
                    selectedPaymentIcon.classList.remove('hidden');
                }

                openPaymentModalBtn.addEventListener('click', () => {
                    document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
                    openModal(paymentMethodModal);
                });

                backToPaymentModalBtn.addEventListener('click', () => { closeModal(installmentModal); openModal(paymentMethodModal); });
                backToPaymentModalBtnFromTransfer.addEventListener('click', () => { closeModal(transferModal); openModal(paymentMethodModal); });

                document.querySelectorAll('.payment-option').forEach(option => {
                    option.addEventListener('click', () => {
                        document.querySelectorAll('.payment-option').forEach(o => o.classList.remove('selected'));
                        option.classList.add('selected');
                        // Reset check icon
                        document.querySelectorAll('.check-icon').forEach(i => i.classList.replace('fa-circle-check', 'fa-circle'));
                        document.querySelectorAll('.check-icon').forEach(i => i.classList.remove('text-theme'));
                        
                        const icon = option.querySelector('.check-icon');
                        if(icon) {
                            icon.classList.replace('fa-circle', 'fa-circle-check');
                            icon.classList.add('text-theme');
                        }
                    });
                });

                confirmPaymentBtn.addEventListener('click', () => {
                    const selected = document.querySelector('.payment-option.selected');
                    if (!selected) { alert('Please select a payment method.'); return; }
                    
                    const val = selected.dataset.value;
                    if (val === 'COD') {
                        updateSelectedPaymentDisplay(selected.dataset.text, selected.dataset.faIconClass);
                        paymentMethodInput.value = 'COD';
                        installmentTermInput.value = '';
                        closeModal(paymentMethodModal);
                    } else if (val === 'INSTALLMENT') {
                        closeModal(paymentMethodModal);
                        openModal(installmentModal);
                    } else if (val === 'TRANSFER') {
                        const totalAmount = <%= (int)totalPriceAfterDiscount %>; 
                        const orderId = 'DH' + Math.floor(Date.now() / 1000);
                        const transferDescription = 'TT ' + orderId;
                        document.getElementById('transferContent').innerText = transferDescription;
                        
                        const qrUrl = "https://img.vietqr.io/image/970422-0968418098-compact.png?amount=" + totalAmount + "&addInfo=" + encodeURIComponent(transferDescription) + "&accountName=TRANG TIEN DAT";
                        document.getElementById('qrCodeImage').src = qrUrl;

                        closeModal(paymentMethodModal);
                        openModal(transferModal);

                        if (paymentCheckInterval) clearInterval(paymentCheckInterval);
                        setTimeout(() => {
                            paymentCheckInterval = setInterval(() => checkPaid(transferDescription), 3000);
                        }, 5000);
                    }
                });

                document.querySelectorAll('.term-column').forEach(column => {
                    column.addEventListener('click', () => {
                        document.querySelectorAll('.term-column').forEach(col => col.classList.remove('selected'));
                        column.classList.add('selected');
                        selectedInstallmentTerm = column.dataset.term;
                        confirmInstallmentBtn.disabled = false;
                    });
                });

                confirmInstallmentBtn.addEventListener('click', () => {
                    if (selectedInstallmentTerm) {
                        const text = "Installment " + selectedInstallmentTerm + " months";
                        updateSelectedPaymentDisplay(text, 'fa-solid fa-credit-card');
                        paymentMethodInput.value = "INSTALLMENT_" + selectedInstallmentTerm + "M";
                        installmentTermInput.value = selectedInstallmentTerm;
                        closeModal(installmentModal);
                    }
                });
                
                confirmTransferBtn.addEventListener('click', () => {
                     const selected = document.querySelector('.payment-option[data-value="TRANSFER"]');
                     if(selected) updateSelectedPaymentDisplay(selected.dataset.text, selected.dataset.faIconClass);
                     paymentMethodInput.value = 'TRANSFER';
                     closeModal(transferModal);
                });

                async function checkPaid(desc) {
                    try {
                        const response = await fetch("https://script.google.com/macros/s/AKfycbwVGFzfs_VMzmWN9kXOcLW2o5HNR407tycQzyyq20NjEOn32MBZw6GSBFVi5uRtWtSwqw/exec");
                        const data = await response.json();
                        const last = data.data[data.data.length - 1];
                        if (last["Mô tả"].includes(desc)) {
                            clearInterval(paymentCheckInterval);
                            paymentMethodInput.value = 'TRANSFER';
                            document.getElementById('payment-form').submit();
                        }
                    } catch (e) { console.error(e); }
                }

                document.getElementById('confirm-btn').addEventListener('click', () => {
                    if (!paymentMethodInput.value) {
                        alert('Please select a payment method.'); return;
                    }
                    document.getElementById('payment-form').submit();
                });

                document.getElementById('copyContentBtn').addEventListener('click', (e) => {
                    e.preventDefault();
                    navigator.clipboard.writeText(document.getElementById('transferContent').innerText);
                    alert('Copied!');
                });
            });
        </script>
    </body>
</html>