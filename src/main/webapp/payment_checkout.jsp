<%@page import="model.InterestRate"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="model.CartItems"%>
<%@page import="model.Carts"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ include file="layout/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment</title>
        <script src="https://cdn.tailwindcss.com"></script>
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

                    <%                    Carts cart = (Carts) session.getAttribute("cartCheckout");
                        ProductDAO pDAO = new ProductDAO();
                        String receiverName = (String) request.getAttribute("receiverName");
                        String receiverPhone = (String) request.getAttribute("receiverPhone");
                        String specificAddress = (String) request.getAttribute("specificAddress");
                        double totalPriceBeforeDiscount = 0;
                        double totalPriceAfterDiscount = 0;
                        int totalQuantity = 0;
                        if (cart != null) {
                            for (CartItems ci : cart.getListCartItems()) {
                                totalPriceBeforeDiscount += ci.getVariants().getPrice() * ci.getQuantity();
                                totalPriceAfterDiscount += ci.getVariants().getDiscountPrice() * ci.getQuantity();
                                totalQuantity += ci.getQuantity();
                            }
                        }
                        double discountAmount = totalPriceBeforeDiscount - totalPriceAfterDiscount;
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
                                <hr class="my-2 border-dashed">
                                <div class="flex justify-between items-center">
                                    <span class="font-semibold">Total</span>
                                    <div class="text-right">
                                        <p id="totalOrderAmount" class="font-bold text-lg text-theme" data-amount="<%= totalPriceAfterDiscount%>"><%= String.format("%,.0f", totalPriceAfterDiscount)%> VND</p>
                                        <p class="text-xs text-gray-500">VAT included</p>
                                    </div>
                                </div>
                            </div>

                            <form action="payment" method="post" id="payment-form">
                                <input type="hidden" name="action" value="createOrder">
                                <input type="hidden" name="receiverName" value="<%= receiverName%>">
                                <input type="hidden" name="receiverPhone" value="<%= receiverPhone%>">
                                <input type="hidden" name="specificAddress" value="<%= specificAddress%>">
                                <input type="hidden" name="totalAmount" value="<%= totalPriceAfterDiscount%>">
                                <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="">
                                <input type="hidden" name="installmentTerm" id="installmentTermInput" value="">

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
                        <% if (cart != null && !cart.getListCartItems().isEmpty()) {
                                for (CartItems ci : cart.getListCartItems()) {%>
                        <div class="flex items-start space-x-4">
                            <img src="images/<%= ci.getVariants().getImageUrl()%>" alt="Product Image" class="w-20 h-20 object-contain border rounded-md">
                            <div class="flex-1">
                                <p class="font-semibold text-sm text-gray-800"><%= pDAO.getProductByID(ci.getVariants().getProductID()).getName() + " " + ci.getVariants().getStorage() + " " + ci.getVariants().getColor()%></p>
                                <div class="flex items-center space-x-2 mt-1">
                                    <p class="font-bold text-theme text-sm"><%= String.format("%,.0f", ci.getVariants().getDiscountPrice())%> VND</p>
                                    <p class="text-gray-500 line-through text-xs"><%= String.format("%,.0f", ci.getVariants().getPrice())%> VND</p>
                                </div>
                                <p class="text-sm text-gray-600 mt-1">Quantity: <span class="font-semibold"><%= ci.getQuantity()%></span></p>
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
                                <span class="font-semibold text-gray-800">PHAM HOANG PHUONG</span>
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

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                // --- CÁC BIẾN DOM GIỮ NGUYÊN ---
                const productModal = document.getElementById('productModal');
                const paymentMethodModal = document.getElementById('paymentMethodModal');
                const installmentModal = document.getElementById('installmentModal');
                const transferModal = document.getElementById('transferModal');
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

                // --- BIẾN MỚI ĐỂ QUẢN LÝ VÒNG LẶP KIỂM TRA THANH TOÁN ---
                let paymentCheckInterval = null;
                const paymentForm = document.getElementById('payment-form'); // Lấy form chính

                const openModal = (modal) => modal.classList.remove('hidden');

                // --- SỬA ĐỔI HÀM closeModal ĐỂ DỪNG KIỂM TRA KHI ĐÓNG MODAL ---
                const closeModal = (modal) => {
                    modal.classList.add('hidden');
                    // Nếu modal chuyển khoản bị đóng, dừng việc kiểm tra
                    if (modal.id === 'transferModal' && paymentCheckInterval) {
                        clearInterval(paymentCheckInterval);
                        console.log("Payment check stopped.");
                    }
                };

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

                // --- SỬA ĐỔI LOGIC KHI MỞ MODAL CHUYỂN KHOẢN ---
                openTransferModalBtn.addEventListener('click', (e) => {
                    document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
                    e.currentTarget.classList.add('selected');
                    const qrCodeImage = document.getElementById('qrCodeImage');


                    const totalAmount = 2000;


                    const orderId = 'DH' + Math.floor(Date.now() / 1000);
                    const transferDescription = 'TT ' + orderId; // Nội dung chuyển khoản gốc
                    document.getElementById('transferContent').innerText = transferDescription;

                    const bankId = "970422";
                    const accountNumber = "343339799999";
                    const accountName = "PHAM HOANG PHUONG";

                    const encodedDescription = encodeURIComponent(transferDescription);
                    const encodedAccountName = encodeURIComponent(accountName);
                    const cacheBuster = `&t=${Date.now()}`;
                    const vietQrApiUrl = `https://img.vietqr.io/image/${bankId}-${accountNumber}-compact.png?amount=${totalAmount}&addInfo=${encodedDescription}&accountName=${encodedAccountName}${cacheBuster}`;

                    qrCodeImage.src = vietQrApiUrl;
                    closeModal(paymentMethodModal);
                    openModal(transferModal);

                    // Dừng bất kỳ vòng lặp kiểm tra cũ nào đang chạy
                    if (paymentCheckInterval) {
                        clearInterval(paymentCheckInterval);
                    }

                    // Bắt đầu vòng lặp kiểm tra mới
                    paymentCheckInterval = setInterval(() => {
                        checkPaid(transferDescription);
                    }, 3000); // Giữ khoảng thời gian 3 giây để tránh quá tải API
                });

                // --- HÀM checkPaid ĐƯỢC CẬP NHẬT HOÀN TOÀN ---
                async function checkPaid(description) {
                    try {
                        const response = await fetch("https://script.google.com/macros/s/AKfycbz2ZSvZF7bJkTqXnOUXbdqUQMmuc7w27wAjB4efbKSSA1q6yqGj6uxek5nP0W4VgK6xgw/exec");
                        const data = await response.json();
                        const lastPaid = data.data[data.data.length - 1];
                        const lastDescription = lastPaid["Mô tả"];

                        // So sánh nội dung chuyển khoản
                        if (lastDescription.includes(description)) {
                            console.log("Payment successful! Submitting form...");
                            alert("Payment successful!");

                            // 1. Dừng vòng lặp
                            clearInterval(paymentCheckInterval);

                            // 2. Cập nhật các giá trị trong form
                            paymentMethodInput.value = 'TRANSFER';
                            installmentTermInput.value = ''; // Xóa thông tin trả góp nếu có

                            // 3. Tự động nộp form
                            paymentForm.submit();
                        } else {
                            console.log("Checking payment... Not yet paid.");
                        }
                    } catch (error) {
                        console.error("Error checking payment:", error);
                    }
                }

                // --- CÁC HÀM XÁC NHẬN KHÁC GIỮ NGUYÊN ---
                document.querySelectorAll('.payment-option').forEach(option => {
                    if (option.id !== 'openInstallmentModalBtn' && option.id !== 'openTransferModalBtn') {
                        option.addEventListener('click', () => {
                            document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
                            option.classList.add('selected');
                        });
                    }
                });

                confirmPaymentBtn.addEventListener('click', () => {
                    const selectedOption = document.querySelector('.payment-option.selected');
                    if (selectedOption && selectedOption.dataset.value === 'COD') {
                        updateSelectedPaymentDisplay(selectedOption.dataset.text, selectedOption.dataset.faIconClass);
                        paymentMethodInput.value = selectedOption.dataset.value;
                        installmentTermInput.value = '';
                        closeModal(paymentMethodModal);
                    } else if (selectedOption) {
                        alert('Please click on the selected method to continue.');
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

                // Nút này giờ đóng vai trò là phương án thủ công nếu người dùng không muốn chờ
                confirmTransferBtn.addEventListener('click', () => {
                    const selectedOption = document.querySelector('.payment-option[data-value="TRANSFER"]');
                    updateSelectedPaymentDisplay(selectedOption.dataset.text, selectedOption.dataset.faIconClass);
                    paymentMethodInput.value = selectedOption.dataset.value;
                    installmentTermInput.value = '';
                    closeModal(transferModal); // Chỉ đóng modal, không submit form
                });

                document.querySelectorAll('.term-column').forEach(column => {
                    column.addEventListener('click', () => {
                        document.querySelectorAll('.term-column').forEach(col => col.classList.remove('selected'));
                        column.classList.add('selected');
                        selectedInstallmentTerm = column.dataset.term;
                        confirmInstallmentBtn.disabled = false;
                    });
                });

                copyContentBtn.addEventListener('click', () => {
                    const content = document.getElementById('transferContent').innerText;
                    navigator.clipboard.writeText(content).then(() => {
                        alert('Copied content: ' + content);
                    }).catch(err => {
                        console.error('Could not copy text: ', err);
                        alert('Failed to copy!');
                    });
                });
            });
        </script>
    </body>
</html>