<%--
    Document   : payment_step2
    Created on : Oct 17, 2025
    Author     : ADMIN
--%>

<%@page import="model.InterestRate"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="model.CartItems"%>
<%@page import="model.Carts"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .payment-option.selected { border-color: #DC2626; box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.3); }
        .term-column.selected { background-color: #EFF6FF; border-color: #3B82F6; }
        .term-column.selected .term-button { background-color: #3B82F6; color: white; cursor: default; }
        .term-column.selected .term-header { color: #2563EB; }
    </style>
</head>

<body class="bg-gray-100">
    <div class="container mx-auto max-w-2xl bg-white shadow-lg my-4 sm:my-8 rounded-lg">
        <header class="p-4 border-b flex items-center relative">
            <button onclick="window.history.back()" class="absolute left-4 text-gray-600 hover:text-gray-900">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                </svg>
            </button>
            <h1 class="text-xl font-semibold text-center w-full">Thanh toán</h1>
        </header>

        <main class="p-4 sm:p-6">
            <div class="flex justify-center border-b mb-6">
                <div class="flex-1 text-center py-2 border-b-2 border-gray-200 text-gray-400 font-semibold">
                    <span class="cursor-pointer">1. THÔNG TIN</span>
                </div>
                <div class="flex-1 text-center py-2 border-b-2 border-red-600 text-red-600 font-semibold">
                    <span class="cursor-pointer">2. THANH TOÁN</span>
                </div>
            </div>

            <%
                Carts cart = (Carts) session.getAttribute("cartCheckout");
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
                NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            %>

            <div class="space-y-4 mb-6">
                <h3 class="font-bold text-lg text-gray-700">THÔNG TIN NHẬN HÀNG</h3>
                <div class="border rounded-lg p-4 bg-gray-50 space-y-3 text-sm">
                    <div class="flex justify-between items-center">
                        <span class="text-gray-500">Người nhận</span>
                        <span class="font-semibold text-gray-800"><%= receiverName != null ? receiverName : "Chưa có" %> - <%= receiverPhone != null ? receiverPhone : "Chưa có" %></span>
                    </div>
                    <div class="flex justify-between items-start">
                        <span class="text-gray-500">Nhận hàng tại</span>
                        <span class="font-semibold text-gray-800 text-right max-w-xs"><%= specificAddress != null ? specificAddress : "Chưa có địa chỉ" %></span>
                    </div>
                </div>
            </div>
            
            <div class="space-y-4">
                <h3 class="font-bold text-lg text-gray-700">TÓM TẮT ĐƠN HÀNG</h3>
                <div class="border rounded-lg p-4 space-y-4 bg-blue-50/30">
                    <div class="space-y-3 text-sm text-gray-700 pt-2">
                        <div class="flex justify-between">
                            <span>Tổng tiền hàng</span>
                            <span class="font-semibold"><%= currencyFormat.format(totalPriceBeforeDiscount) %></span>
                        </div>
                        <% if (discountAmount > 0) { %>
                        <div class="flex justify-between">
                            <span>Giảm giá</span>
                            <span class="font-semibold text-red-600">-<%= currencyFormat.format(discountAmount) %></span>
                        </div>
                        <% } %>
                        <hr class="my-2 border-dashed">
                        <div class="flex justify-between items-center">
                            <span class="font-semibold">Tổng tiền</span>
                            <div class="text-right">
                                <p id="totalOrderAmount" class="font-bold text-lg text-red-600" data-amount="<%= totalPriceAfterDiscount %>"><%= currencyFormat.format(totalPriceAfterDiscount) %></p>
                                <p class="text-xs text-gray-500">Đã gồm VAT</p>
                            </div>
                        </div>
                    </div>
                    
                    <form action="payment" method="post">
                        <input type="hidden" name="action" value="createOrder">
                        <input type="hidden" name="receiverName" value="<%= receiverName %>">
                        <input type="hidden" name="receiverPhone" value="<%= receiverPhone %>">
                        <input type="hidden" name="specificAddress" value="<%= specificAddress %>">
                        <input type="hidden" name="totalAmount" value="<%= totalPriceAfterDiscount %>">
                        <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="">
                        <input type="hidden" name="installmentTerm" id="installmentTermInput" value="">
                        
                        
                        <div class="border-t pt-4">
                            <h4 class="font-semibold text-gray-800 mb-3">Chọn phương thức thanh toán:</h4>
                            <div id="openPaymentModalBtn" class="border rounded-lg p-3 flex justify-between items-center cursor-pointer hover:bg-gray-100 bg-white">
                                <div class="flex items-center space-x-3">
                                    <img id="selected-payment-icon" src="" alt="icon" class="w-8 h-8 object-contain hidden">
                                    <span id="selected-payment-text" class="font-medium text-gray-700">Vui lòng chọn phương thức thanh toán</span>
                                </div>
                                <i class="fa-solid fa-chevron-right text-gray-400"></i>
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <button type="submit" class="w-full bg-red-600 text-white font-bold py-3 rounded-lg hover:bg-red-700 transition-colors text-base">
                                Xác nhận và Đặt hàng
                            </button>
                            <div class="text-center mt-3">
                                <a href="#" id="openProductListModalBtn" class="text-red-600 font-semibold text-sm hover:underline">
                                    Kiểm tra danh sách sản phẩm (<%= totalQuantity %>)
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
                <h2 class="text-lg font-semibold text-gray-800">Sản phẩm trong đơn hàng</h2>
                <button class="js-close-modal text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
            </div>
            <div class="p-4 space-y-4 max-h-[60vh] overflow-y-auto">
                <% if (cart != null && !cart.getListCartItems().isEmpty()) { 
                    for (CartItems ci : cart.getListCartItems()) { %>
                    <div class="flex items-start space-x-4">
                        <img src="images/<%= ci.getVariants().getImageUrl() %>" alt="Product Image" class="w-20 h-20 object-contain border rounded-md">
                        <div class="flex-1">
                            <p class="font-semibold text-sm text-gray-800"><%= pDAO.getProductByID(ci.getVariants().getProductID()).getName() + " " + ci.getVariants().getStorage() + " " + ci.getVariants().getColor() %></p>
                            <div class="flex items-center space-x-2 mt-1">
                                <p class="font-bold text-red-600 text-sm"><%= currencyFormat.format(ci.getVariants().getDiscountPrice()) %></p>
                                <p class="text-gray-500 line-through text-xs"><%= currencyFormat.format(ci.getVariants().getPrice()) %></p>
                            </div>
                            <p class="text-sm text-gray-600 mt-1">Số lượng: <span class="font-semibold"><%= ci.getQuantity() %></span></p>
                        </div>
                    </div>
                <%  } 
                   } else { %>
                    <p>Không có sản phẩm nào trong giỏ hàng.</p>
                <% } %>
            </div>
        </div>
    </div>
    
    <div id="paymentMethodModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-end sm:items-center justify-center p-0 sm:p-4 z-[60] hidden">
        <div class="bg-white rounded-t-lg sm:rounded-lg shadow-xl w-full max-w-2xl">
            <div class="p-4 border-b flex justify-between items-center">
                <h2 class="text-lg font-semibold text-gray-800">Chọn phương thức thanh toán</h2>
                <button class="js-close-modal text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
            </div>
            <div class="p-4 space-y-3 max-h-[70vh] overflow-y-auto">
                <div class="payment-option border rounded-lg p-3 flex items-center cursor-pointer" data-value="COD" data-text="Thanh toán khi nhận hàng" data-icon="https://cellphones.com.vn/smember/_nuxt/img/COD.7245ca2.png">
                    <img src="https://cellphones.com.vn/smember/_nuxt/img/COD.7245ca2.png" class="w-10 h-10 mr-4 object-contain">
                    <span class="font-medium">Thanh toán khi nhận hàng</span>
                </div>
                <div id="openInstallmentModalBtn" class="payment-option border rounded-lg p-3 flex items-center cursor-pointer" data-value="INSTALLMENT" data-text="Trả góp qua thẻ/ví" data-icon="https://cellphones.com.vn/smember/_nuxt/img/kredivo.f281f69.png">
                    <img src="https://cellphones.com.vn/smember/_nuxt/img/kredivo.f281f69.png" class="w-10 h-10 mr-4 object-contain">
                    <span class="font-medium">Trả góp qua thẻ/ví</span>
                </div>
            </div>
            <div class="p-4 border-t">
                <button id="confirmPaymentBtn" class="w-full bg-red-600 text-white font-bold py-3 rounded-lg hover:bg-red-700">Xác nhận</button>
            </div>
        </div>
    </div>
    
    <div id="installmentModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-end sm:items-center justify-center p-0 sm:p-4 z-[70] hidden">
        <div class="bg-white rounded-t-lg sm:rounded-lg shadow-xl w-full max-w-2xl">
            <div class="p-4 border-b flex items-center relative">
                <button id="backToPaymentModalBtn" class="absolute left-4 text-gray-600 hover:text-gray-900"><i class="fa-solid fa-arrow-left"></i></button>
                <h2 class="text-lg font-semibold text-gray-800 w-full text-center">Chọn cách thức trả góp</h2>
                <button class="js-close-modal absolute right-4 text-gray-400 hover:text-gray-600"><i class="fa-solid fa-times fa-lg"></i></button>
            </div>
            <div class="p-4 space-y-4">
                <p class="text-sm font-semibold">2. Chọn kì hạn thanh toán</p>
                <div id="installmentTermContainer" class="w-full overflow-x-auto">
                    <div class="flex text-center text-sm">
                        <div class="w-1/4 font-semibold text-left flex flex-col pr-2">
                            <div class="h-12 flex items-center">Kì hạn</div>
                            <div class="h-10 flex items-center">Phí nền tảng</div>
                            <div class="h-10 flex items-center">Lãi suất</div>
                            <div class="h-10 flex items-center">Góp mỗi tháng</div>
                            <div class="h-10 flex items-center">Tổng cộng</div>
                        </div>
                        <%List<InterestRate> iRList = (List<InterestRate>) request.getAttribute("iRList"); %>
                        <div class="w-3/4 flex">
                            <%for(InterestRate iR : iRList) { %>
                            <%
                             double instalmentPrice = (totalPriceAfterDiscount*iR.getPercent())/100;
                             double totalPriceEachMothPay = totalPriceAfterDiscount/iR.getInstalmentPeriod();
                             double totalPriceAfterInstalment = totalPriceAfterDiscount + instalmentPrice ;
                            %>
                            <div class="term-column w-1/3 border rounded-md p-2 mx-1 flex flex-col" data-term="<%=iR.getInstalmentPeriod() %>">
                                <div class="flex-grow">
                                    <div class="h-12 flex items-center justify-center font-bold term-header"><%=iR.getInstalmentPeriod() %> <i class="fa-solid fa-circle-check text-white"></i></div>
                                    <div class="h-10 flex items-center justify-center"><%=currencyFormat.format(instalmentPrice) %></div>
                                    <div class="h-10 flex items-center justify-center text-blue-600 font-semibold"><%=iR.getPercent()%>%</div>
                                    <div class="h-10 flex items-center justify-center"><%=currencyFormat.format(totalPriceEachMothPay) %></div>
                                    <div class="h-10 flex items-center justify-center"><%=currencyFormat.format(totalPriceAfterInstalment) %></div>
                                </div>
                                <button class="term-button mt-2 w-full py-1 border border-blue-500 text-blue-500 rounded-md font-semibold">CHỌN</button>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                
            </div>
            <div class="p-4 border-t">
                <button id="confirmInstallmentBtn" class="w-full bg-red-600 text-white font-bold py-3 rounded-lg hover:bg-red-700 disabled:bg-gray-400" disabled>
                    Xác nhận
                </button>
            </div>
        </div>
    </div>

    <script>
document.addEventListener('DOMContentLoaded', () => {
    const productModal = document.getElementById('productModal');
    const paymentMethodModal = document.getElementById('paymentMethodModal');
    const installmentModal = document.getElementById('installmentModal');
    const openProductListModalBtn = document.getElementById('openProductListModalBtn');
    const openPaymentModalBtn = document.getElementById('openPaymentModalBtn');
    const openInstallmentModalBtn = document.getElementById('openInstallmentModalBtn');
    const backToPaymentModalBtn = document.getElementById('backToPaymentModalBtn');
    const confirmPaymentBtn = document.getElementById('confirmPaymentBtn');
    const confirmInstallmentBtn = document.getElementById('confirmInstallmentBtn');
    const paymentMethodInput = document.getElementById('paymentMethodInput');
    const installmentTermInput = document.getElementById('installmentTermInput');
    const selectedPaymentText = document.getElementById('selected-payment-text');
    const selectedPaymentIcon = document.getElementById('selected-payment-icon');
    let selectedInstallmentTerm = null;

    const openModal = (modal) => modal.classList.remove('hidden');
    const closeModal = (modal) => modal.classList.add('hidden');

    // Mở modal danh sách sản phẩm
    openProductListModalBtn.addEventListener('click', (e) => { 
        e.preventDefault(); 
        openModal(productModal); 
    });
    
    // Mở modal chọn phương thức thanh toán
    openPaymentModalBtn.addEventListener('click', () => {
        document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
        const currentMethod = paymentMethodInput.value;
        if (currentMethod) {
            const currentSelection = document.querySelector(`.payment-option[data-value^="${currentMethod.split('_')[0]}"]`);
            if(currentSelection) currentSelection.classList.add('selected');
        }
        openModal(paymentMethodModal);
    });
    
    // Mở modal chọn cách thức trả góp
    openInstallmentModalBtn.addEventListener('click', (e) => {
        const isSelected = e.currentTarget.classList.contains('selected');
        if (!isSelected) {
            document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
            e.currentTarget.classList.add('selected');
        }
        closeModal(paymentMethodModal);
        openModal(installmentModal);
    });
    
    // Quay lại modal thanh toán từ modal trả góp
    backToPaymentModalBtn.addEventListener('click', () => { 
        closeModal(installmentModal); 
        openModal(paymentMethodModal); 
    });
    
    // Đóng tất cả modal
    document.querySelectorAll('.js-close-modal').forEach(btn => btn.addEventListener('click', () => {
        closeModal(productModal);
        closeModal(paymentMethodModal);
        closeModal(installmentModal);
    }));
    
    // Chọn phương thức thanh toán (COD)
    document.querySelectorAll('.payment-option').forEach(option => {
        if (option.id !== 'openInstallmentModalBtn') {
            option.addEventListener('click', () => {
                document.querySelectorAll('.payment-option').forEach(el => el.classList.remove('selected'));
                option.classList.add('selected');
            });
        }
    });
    
    // Xác nhận chọn phương thức thanh toán
    confirmPaymentBtn.addEventListener('click', () => {
        const selectedOption = document.querySelector('.payment-option.selected');
        if (selectedOption && selectedOption.id !== 'openInstallmentModalBtn') {
            updateSelectedPaymentDisplay(selectedOption.dataset.text, selectedOption.dataset.icon);
            paymentMethodInput.value = selectedOption.dataset.value;
            closeModal(paymentMethodModal);
        } else if (!selectedOption) {
            alert('Vui lòng chọn một phương thức thanh toán.');
        }
    });

    // Chọn kì hạn trả góp
    document.querySelectorAll('.term-column').forEach(column => {
        column.addEventListener('click', () => {
            document.querySelectorAll('.term-column').forEach(col => col.classList.remove('selected'));
            document.querySelectorAll('.term-button').forEach(btn => { btn.textContent = 'CHỌN'; });
            column.classList.add('selected');
            column.querySelector('.term-button').textContent = 'ĐÃ CHỌN';
            selectedInstallmentTerm = column.dataset.term; // ✅ Lưu giá trị term
            console.log('Selected term:', selectedInstallmentTerm); // Debug
            confirmInstallmentBtn.disabled = false;
        });
    });

    // Xác nhận chọn kì hạn trả góp
    confirmInstallmentBtn.addEventListener('click', () => {
        if (selectedInstallmentTerm) {
            const text = `Trả góp ${selectedInstallmentTerm} tháng`;
            const icon = 'https://cellphones.com.vn/smember/_nuxt/img/kredivo.f281f69.png';
            const value = `INSTALLMENT_${selectedInstallmentTerm}M`; // ✅ Format đúng: INSTALLMENT_6M
            
            console.log('Payment value:', value); // Debug
            console.log('Installment term:', selectedInstallmentTerm); // Debug
            
            updateSelectedPaymentDisplay(text, icon);
            paymentMethodInput.value = value;
            installmentTermInput.value = selectedInstallmentTerm; // ✅ Gửi term riêng
            
            closeModal(installmentModal);
        } else {
            alert('Vui lòng chọn kì hạn trả góp.');
        }
    });

    // Cập nhật hiển thị phương thức thanh toán được chọn
    function updateSelectedPaymentDisplay(text, iconSrc) {
        selectedPaymentText.textContent = text;
        selectedPaymentText.classList.remove('text-gray-700');
        selectedPaymentText.classList.add('text-gray-800');
        selectedPaymentIcon.src = iconSrc;
        selectedPaymentIcon.classList.remove('hidden');
    }
});
    </script>
</body>
</html>