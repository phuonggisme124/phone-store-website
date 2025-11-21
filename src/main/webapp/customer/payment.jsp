<%-- 
    Document   : payment
    Created on : Oct 15, 2025, 3:01:17 PM
    Author     : ADMIN
--%>

<%@page import="model.Carts"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
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
                background-color: #f4f7fc;
            }
            .confirm-btn {
                background: #72AEC8;
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
                background: #619db5;
            }
            .text-theme {
                color: #72AEC8;
            }
            .border-theme {
                border-color: #72AEC8;
            }
            .bg-theme-light {
                background-color: #eaf4f7;
            }
            input:focus, select:focus, textarea:focus {
                border-color: #72AEC8;
                box-shadow: 0 0 0 2px rgba(114, 174, 200, 0.4);
                outline: none;
            }
        </style>
    </head>

    <body>
        <section id="billboard" class="bg-light-blue overflow-hidden padding-large" >
            <div class="container mx-auto max-w-2xl bg-white shadow-lg my-4 sm:my-8 rounded-lg">
                <header class="p-4 border-b flex items-center relative">
                    <button onclick="window.history.back();" class="absolute left-4 text-gray-600 hover:text-gray-900">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                        </svg>
                    </button>
                    <h1 class="text-xl font-semibold text-center w-full">Information</h1>
                </header>

                <main class="p-4 sm:p-6">
                    <div class="flex justify-center border-b mb-6">
                        <div class="flex-1 text-center py-2 border-b-2 border-theme text-theme font-semibold">
                            <a href="#" class="cursor-pointer">1. INFORMATION</a>
                        </div>
                        <div class="flex-1 text-center py-2 border-b-2 border-gray-200 text-gray-400 font-semibold">
                            <a href="#" class="cursor-pointer">2. PAYMENT</a>
                        </div>
                    </div>

                    <%  
                        List<Carts> cartsCheckout = (List<Carts>) session.getAttribute("cartCheckout");
                        ProductDAO pDAO = new ProductDAO();
                        double totalPrice = 0;
                    %>

                    <% for (Carts c : cartsCheckout) { %>
                    <div class="bg-white rounded-lg mb-6">
                        <div class="flex items-center space-x-4">
                            <img src="images/<%=c.getVariant().getImageUrl()%>" class="w-20 h-20 object-cover rounded-md border">
                            <div class="flex-1">
                                <h2 class="font-semibold text-gray-800">
                                    <%=pDAO.getProductByID(c.getVariant().getProductID()).getName() + " " + c.getVariant().getStorage() + " " + c.getVariant().getColor()%>
                                </h2>
                                <div class="flex items-baseline space-x-2 mt-1">
                                    <p class="text-theme font-bold text-lg"><%=String.format("%,.0f", c.getVariant().getDiscountPrice())%> VND</p>
                                    <p class="text-gray-400 line-through text-sm"><%=String.format("%,.0f", c.getVariant().getPrice())%> VND</p>
                                </div>
                            </div>
                            <p class="text-gray-600">Quantity: <span class="font-semibold"><%=c.getQuantity()%></span></p>
                                <% totalPrice += c.getVariant().getDiscountPrice() * c.getQuantity(); %>
                        </div>
                    </div>
                    <% } %>

                    <div class="space-y-4">
                        <h3 class="font-bold text-lg text-gray-700">CUSTOMER INFORMATION</h3>
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

                    <form action="payment" method="get" class="space-y-4 mt-6">
                        <input type="hidden" name="action" value="checkout">
                        <h3 class="font-bold text-lg text-gray-700">SHIPPING INFORMATION</h3>
                        <div class="border rounded-lg p-4 space-y-4 bg-theme-light">
                            <div class="space-y-3">
                                <div>
                                    <label for="receiverName" class="block text-sm font-medium text-gray-700">Receiver's Full Name</label>
                                    <input type="text" id="receiverName" name="receiverName" value="<%=user.getFullName()%>" placeholder="Enter receiver's full name" class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm sm:text-sm" required>
                                </div>

                                <div>
                                    <label for="receiverPhone" class="block text-sm font-medium text-gray-700">Phone Number</label>
                                    <input type="text" 
                                           id="receiverPhone" 
                                           name="receiverPhone" 
                                           value="<%= user.getPhone() != null ? user.getPhone() : ""%>" 
                                           placeholder="Enter receiver's phone number" 
                                           class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm sm:text-sm" 
                                           required>                                </div>
                            </div>

                            <div>
                                <label for="city" class="block text-sm font-medium text-gray-700">Province/City</label>
                                <select id="city" name="city" class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm sm:text-sm" required>
                                    <option value="">-- Select province/city --</option>
                                </select>
                            </div>

                            <div>
                                <label for="address" class="block text-sm font-medium text-gray-700">Specific Address</label>
                                <textarea id="address" name="address" rows="3" placeholder="House number, street name, ward/commune, district..." class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm sm:text-sm" required></textarea>
                            </div>
                        </div>

                        <div class="flex justify-between items-center border-t pt-4">
                            <p class="text-gray-700">Subtotal:</p>
                            <p class="text-theme font-bold text-xl"><%= String.format("%,.0f", totalPrice)%> VND</p>
                        </div>

                        <button type="submit" id="confirm-btn" class="confirm-btn">Continue</button>
                        </div>
                    </form>
                </main>
            </div>
        </section>

        <script>
            const citySelect = document.getElementById("city");
            fetch("http://provinces.open-api.vn/api/p/")
                    .then(res => res.json())
                    .then(provinces => {
                        citySelect.innerHTML = '<option value="">-- Select province/city --</option>';
                        provinces.forEach(p => {
                            const opt = document.createElement("option");
                            opt.value = p.name;
                            opt.textContent = p.name;
                            citySelect.appendChild(opt);
                        });
                    })
                    .catch(error => {
                        console.error("Error loading province/city list:", error);
                        citySelect.innerHTML = '<option value="">Error loading data</option>';
                    });
        </script>
    </body>
</html>
