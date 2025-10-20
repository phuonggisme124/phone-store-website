<<<<<<< HEAD
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment</title>
  <link rel="stylesheet" href="css/payment.css">
</head>
<body>
  <div class="payment-container">
    <h2 class="payment-title">Payment ?</h2>

    <!-- User Information -->
    <div class="user-info">
      <label>Full Name</label>
      <input type="text" id="name" placeholder="Enter your full name">

      <label>Phone Number</label>
      <input type="text" id="phone" placeholder="Enter your phone number">

      <label>Shipping Address</label>
      <textarea id="address" placeholder="Enter your shipping address"></textarea>
    </div>

    <!-- Payment Methods -->
    <div class="payment-methods">
      <h3>Payment Method</h3>
      <label><input type="radio" name="payment" value="Momo"> Momo</label>
      <label><input type="radio" name="payment" value="Bank Card"> Bank Card</label>
      <label><input type="radio" name="payment" value="COD"> COD (Cash on Delivery)</label>
    </div>

    <!-- Installment Option -->
    <div class="installment">
      <label>
        <input type="checkbox" id="installment-check"> Installment Plan (0% interest)
      </label>
    </div>

    <!-- Installment Policy -->
    <div id="installment-policy" class="installment-policy hidden">
      <h4>Installment Policy</h4>
      <ul>
        <li>Applicable for orders from 10,000,000 VND and above.</li>
        <li>0% interest installment via credit cards from partner banks.</li>
        <li>Flexible terms: 3, 6, or 12 months.</li>
        <li>Not applicable with other promotions or discounts.</li>
      </ul>

      <!-- Installment Duration Selection -->
      <div class="installment-duration">
        <p class="installment-label">Choose installment period:</p>
        <label><input type="radio" name="duration" value="3 months"> 3 months</label>
        <label><input type="radio" name="duration" value="6 months"> 6 months</label>
        <label><input type="radio" name="duration" value="12 months"> 12 months</label>
      </div>
    </div>

    <!-- Confirm Button -->
    <button id="confirm-btn">Confirm Payment</button>
  </div>

  <script src="js/payment.js"></script>
</body>
=======
<%-- 
    Document   : payment
    Created on : Oct 15, 2025, 3:01:17 PM
    Author     : ADMIN
--%>

<%@page import="model.CartItems"%>
<%@page import="model.Carts"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment Information</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
            }
            .confirm-btn {
                background: #ef4444;
                color: #fff;
                font-weight: 600;
                border: none;
                padding: 12px;
                border-radius: 8px;
                width: 100%;
                font-size: 16px;
                cursor: pointer;
                transition: background 0.2s;
            }
            .confirm-btn:hover {
                background: #dc2626;
            }
        </style>
    </head>

    <body class="bg-gray-100">
        <div class="container mx-auto max-w-2xl bg-white shadow-lg my-4 sm:my-8 rounded-lg">
            <header class="p-4 border-b flex items-center relative">
                <button class="absolute left-4 text-gray-600 hover:text-gray-900">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                    </svg>
                </button>
                <h1 class="text-xl font-semibold text-center w-full">Thông tin</h1>
            </header>

            <main class="p-4 sm:p-6">
                <div class="flex justify-center border-b mb-6">
                    <div class="flex-1 text-center py-2 border-b-2 border-red-500 text-red-500 font-semibold">
                        <a href="#" class="cursor-pointer">1. THÔNG TIN</a>
                    </div>
                    <div class="flex-1 text-center py-2 border-b-2 border-gray-200 text-gray-400 font-semibold">
                        <a href="#" class="cursor-pointer">2. THANH TOÁN</a>
                    </div>
                </div>

                <%
                    model.Users user = (model.Users) session.getAttribute("user");
                    Carts cart = (Carts) session.getAttribute("cartCheckout");
                    ProductDAO pDAO = new ProductDAO();
                    double totalPrice = 0;
                   
                %>

                <% for (CartItems ci : cart.getListCartItems()) {%>
                <div class="bg-white rounded-lg mb-6">
                    <div class="flex items-center space-x-4">
                        <img src="images/<%=ci.getVariants().getImageUrl()%>" class="w-20 h-20 object-cover rounded-md border">
                        <div class="flex-1">
                            <h2 class="font-semibold text-gray-800">
                                <%=pDAO.getProductByID(ci.getVariants().getProductID()).getName() + " " + ci.getVariants().getStorage() + " " + ci.getVariants().getColor()%>
                            </h2>
                            <div class="flex items-baseline space-x-2 mt-1">
                                <p class="text-red-600 font-bold text-lg"><%=String.format("%,.0f", ci.getVariants().getDiscountPrice())%> VND</p>
                                <p class="text-gray-400 line-through text-sm"><%=String.format("%,.0f", ci.getVariants().getPrice())%> VND</p>
                            </div>
                        </div>
                       

                        <p class="text-gray-600">Số lượng: <span class="font-semibold"><%=ci.getQuantity() %></span></p>
                            <% totalPrice += ci.getVariants().getDiscountPrice() * ci.getQuantity(); %>
                    </div>
                </div>
                <% }%>

                <div class="space-y-4">
                    <h3 class="font-bold text-lg text-gray-700">THÔNG TIN KHÁCH HÀNG</h3>
                    <div class="border rounded-lg p-4 space-y-4 bg-gray-50">
                        <div class="flex justify-between items-center">
                            <div class="flex items-center space-x-2">
                                <p class="font-medium text-gray-800"><%=user.getFullName()%></p>
                                <span class="bg-pink-100 text-pink-700 text-xs font-semibold px-2 py-1 rounded-full">Customer</span>
                            </div>
                            <p class="text-gray-600"><%=user.getPhone()%></p>
                        </div>
                        <div class="border-t pt-4">
                            <p class="text-sm text-gray-500">EMAIL</p>
                            <p class="font-medium text-gray-800"><%=user.getEmail()%></p>
                        </div>
                    </div>
                </div>

                <!-- FORM GỬI THÔNG TIN NHẬN HÀNG -->
                <form action="payment" method="get" class="space-y-4 mt-6">
                    <input type="hidden" name="action" value="checkout">
                    <h3 class="font-bold text-lg text-gray-700">THÔNG TIN NHẬN HÀNG</h3>
                    <div class="border rounded-lg p-4 space-y-4 bg-blue-50/30">
                        <div class="space-y-3">
                            <div>
                                <label for="receiverName" class="block text-sm font-medium text-gray-700">Họ và tên người nhận</label>
                                <input type="text" id="receiverName" name="receiverName" value="<%=user.getFullName()%>" placeholder="Nhập họ và tên người nhận" class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:ring-red-500 focus:border-red-500 sm:text-sm" required>
                            </div>

                            <div>
                                <label for="receiverPhone" class="block text-sm font-medium text-gray-700">Số điện thoại</label>
                                <input type="text" id="receiverPhone" name="receiverPhone" value="<%=user.getPhone()%>" placeholder="Nhập số điện thoại nhận hàng" class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:ring-red-500 focus:border-red-500 sm:text-sm" required>
                            </div>

                            <div>
                                <label for="city" class="block text-sm font-medium text-gray-700">Tỉnh/Thành phố</label>
                                <select id="city" name="city" class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:ring-red-500 focus:border-red-500 sm:text-sm" required>
                                    <option value="">-- Chọn tỉnh/thành --</option>
                                </select>
                            </div>

                            <div>
                                <label for="address" class="block text-sm font-medium text-gray-700">Địa chỉ cụ thể</label>
                                <textarea id="address" name="address" rows="3" placeholder="Số nhà, tên đường, phường/xã, quận/huyện..." class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:ring-red-500 focus:border-red-500 sm:text-sm" required></textarea>
                            </div>
                        </div>

                        <div class="flex justify-between items-center border-t pt-4">
                            <p class="text-gray-700">Tổng tiền tạm tính:</p>
                            <p class="text-red-600 font-bold text-xl"><%= String.format("%,.0f", totalPrice)%> VND</p>
                        </div>

                        <button type="submit" id="confirm-btn" class="confirm-btn">Tiếp tục</button>
                    </div>
                </form>
            </main>
        </div>

        <script>
            const citySelect = document.getElementById("city");
            fetch("https://provinces.open-api.vn/api/p/")
                    .then(res => res.json())
                    .then(provinces => {
                        citySelect.innerHTML = '<option value="">-- Chọn tỉnh/thành --</option>';
                        provinces.forEach(p => {
                            const opt = document.createElement("option");
                            opt.value = p.name;
                            opt.textContent = p.name;
                            citySelect.appendChild(opt);
                        });
                    })
                    .catch(error => {
                        console.error("Lỗi khi tải danh sách tỉnh/thành:", error);
                        citySelect.innerHTML = '<option value="">Lỗi tải dữ liệu</option>';
                    });
        </script>
    </body>
>>>>>>> 8a98e4a (Implement payment and installment feature)
</html>
