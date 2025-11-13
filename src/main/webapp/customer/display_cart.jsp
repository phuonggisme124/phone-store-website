<%@page import="model.Carts"%>
<%@page import="model.Category"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Your Cart</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            .cart-item.out-of-stock {
                background-color: #fff5f5;
                border: 1px solid #e53e3e;
                opacity: 0.8;
            }
            .stock-warning {
                color: #e53e3e;
                font-size: 0.875rem;
                font-weight: 500;
                margin-top: 5px;
            }
            .buy-btn:disabled,
            .plus:disabled,
            .minus:disabled {
                background-color: #ccc;
                cursor: not-allowed;
                opacity: 0.7;
            }
        </style>
    </head>

    <body>

        <section id="banner-top" class="position-relative overflow-hidden bg-light-blue"></section>

        <%
            NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            double initialTotalPrice = 0;
            ProductDAO pDAO = new ProductDAO();
        %>

        <% 
            String res = (String) session.getAttribute("res");
            if (res != null) {
                session.removeAttribute("res");
            }
        %>

        <% if (res != null) { %>
        <div class="alert-success" id="successAlert">
            <i class="bi bi-check-circle-fill"></i>
            <span><%= res %></span>
        </div>
        <% } %>

        <section id="billboard" class="bg-light-blue overflow-hidden padding-large">
            <section class="cart-container">
                <h2 class="cart-title">🛒 Your Cart</h2>

                <% if (carts == null || carts.isEmpty()) { %>
                <div class="empty-cart-message">
                    <h3>Your cart is empty.</h3>
                    <p><a href="homepage" class="btn btn-primary mt-3">Continue Shopping</a></p>
                </div>
                <% } else { %>
                
                <div class="cart-controls text-center mb-3">
                    <label class="select-all-label">
                        <input type="checkbox" id="selectAll" class="select-all-checkbox" checked> Select All
                    </label>
                </div>

                <%
                    boolean canProceedToCheckout = true;
                    for (Carts c : carts) {

                        boolean isOutOfStock = c.getQuantity() > c.getVariant().getStock();
                        if (isOutOfStock) {
                            canProceedToCheckout = false;
                        }

                        if (!isOutOfStock) {
                            initialTotalPrice += c.getVariant().getDiscountPrice() * c.getQuantity();
                        }
                %>

                <div class="cart-item <%= isOutOfStock ? "out-of-stock" : "" %>"
                     data-id="<%= c.getVariant().getVariantID() %>"
                     data-price="<%= c.getVariant().getDiscountPrice() %>">

                    <input type="checkbox" class="item-checkbox" checked <%= isOutOfStock ? "disabled" : "" %>>

                    <img src="images/<%= c.getVariant().getImageList()[0] %>" class="product-img">

                    <div class="item-info">
                        <p class="product-name">
                            <a href="product?action=selectStorage&pID=<%= c.getVariant().getProductID() %>
                                     &color=<%= c.getVariant().getColor() %>
                                     &storage=<%= c.getVariant().getStorage() %>
                                     &vID=<%= c.getVariant().getVariantID() %>">
                                <%= pDAO.getNameByID(c.getVariant().getProductID()) %> 
                                - <%= c.getVariant().getStorage() %>
                            </a>
                        </p>

                        <p class="product-price"><%= vnFormat.format(c.getVariant().getDiscountPrice()) %></p>
                        <p class="product-color"><%= c.getVariant().getColor() %></p>

                        <% if (isOutOfStock) { %>
                        <p class="stock-warning">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            Số lượng vượt quá tồn kho (Chỉ còn: <%= c.getVariant().getStock() %>)
                        </p>
                        <% } %>
                    </div>

                    <div class="item-quantity">
                        <form action="cart" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="updateQuantity">
                            <input type="hidden" name="userID" value="<%= c.getCartID() %>">
                            <input type="hidden" name="variantID" value="<%= c.getVariant().getVariantID() %>">
                            <input type="hidden" name="quantityChange" value="-1">
                            <button type="submit" class="minus" <%= c.getQuantity() <= 1 ? "disabled" : "" %>>-</button>
                        </form>

                        <span><%= c.getQuantity() %></span>

                        <form action="cart" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="updateQuantity">
                            <input type="hidden" name="userID" value="<%= c.getCartID() %>">
                            <input type="hidden" name="variantID" value="<%= c.getVariant().getVariantID() %>">
                            <input type="hidden" name="quantityChange" value="1">
                            <button type="submit" class="plus" <%= isOutOfStock ? "disabled" : "" %>>+</button>
                        </form>
                    </div>

                    <form action="cart" class="delete-form" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="cartID" value="<%= c.getCartID() %>">
                        <input type="hidden" name="variantID" value="<%= c.getVariant().getVariantID() %>">
                        <button type="submit" class="delete-btn"><i class="fa-solid fa-trash"></i></button>
                    </form>
                </div>

                <% } %>

                <div class="cart-total">
                    <h3 id="totalAmount">Total: <%= vnFormat.format(initialTotalPrice) %></h3>

                    <form id="buyForm" action="payment" method="get" onsubmit="return collectSelectedItems()">
                        <input type="hidden" name="action" value="buyNowFromCart">
                        <input type="hidden" name="selectedIds" id="selectedIds">
                        <button type="submit" class="buy-btn" <%= !canProceedToCheckout ? "disabled" : "" %>>Buy</button>
                    </form>
                </div>

                <% } %>
            </section>
        </section>

        <footer></footer>

        <script src="${pageContext.request.contextPath}/js/jquery-1.11.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {

                const selectAllCheckbox = document.getElementById("selectAll");
                const itemCheckboxes = document.querySelectorAll(".item-checkbox:not([disabled])");
                const totalElement = document.getElementById("totalAmount");

                function updateTotal() {
                    let total = 0;

                    document.querySelectorAll(".cart-item").forEach(item => {
                        const checkbox = item.querySelector(".item-checkbox");
                        if (checkbox && checkbox.checked && !checkbox.disabled) {
                            const price = parseFloat(item.dataset.price);
                            const quantity = parseInt(item.querySelector(".item-quantity span").textContent);
                            total += price * quantity;
                        }
                    });

                    totalElement.textContent =
                            "Total: " + new Intl.NumberFormat("vi-VN", {style: "currency", currency: "VND"}).format(total);
                }

                function updateSelectAllState() {
                    selectAllCheckbox.checked =
                        Array.from(itemCheckboxes).every(cb => cb.checked);
                }

                selectAllCheckbox.addEventListener("change", function () {
                    itemCheckboxes.forEach(cb => cb.checked = selectAllCheckbox.checked);
                    updateTotal();
                });

                itemCheckboxes.forEach(cb => {
                    cb.addEventListener("change", function () {
                        updateSelectAllState();
                        updateTotal();
                    });
                });

                updateSelectAllState();
            });

            function collectSelectedItems() {
                let selected = [];

                document.querySelectorAll(".cart-item").forEach(item => {
                    const checkbox = item.querySelector(".item-checkbox");
                    if (checkbox && checkbox.checked && !checkbox.disabled) {
                        selected.push(item.dataset.id);
                    }
                });

                if (selected.length === 0) {
                    alert("Please select at least one valid product to buy!");
                    return false;
                }

                document.getElementById("selectedIds").value = selected.join(",");
                return true;
            }

            const alertBox = document.getElementById("successAlert");
            if (alertBox) {
                alertBox.style.display = "block";
                setTimeout(() => alertBox.style.display = "none", 3000);
            }
        </script>

    </body>
</html>
