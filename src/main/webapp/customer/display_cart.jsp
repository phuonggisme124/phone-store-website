<%@page import="model.CartItems"%>
<%@page import="model.Carts"%>
<%@page import="model.Category"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="layout/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Your Cart</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css?v=1.1"> <%-- Thêm version để tránh cache CSS cũ --%>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        
        <style>
            /* Thêm CSS để xử lý cảnh báo tồn kho */
            .cart-item.out-of-stock {
                background-color: #fff5f5; /* Màu nền đỏ nhạt */
                border: 1px solid #e53e3e; /* Viền đỏ */
                opacity: 0.8;
            }

            .stock-warning {
                color: #e53e3e; /* Màu chữ đỏ */
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
            List<Carts> carts = (List<Carts>) request.getAttribute("carts");
            NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            double initialTotalPrice = 0; // Chỉ dùng để hiển thị ban đầu, JS sẽ cập nhật
            session.setAttribute("cart", carts);
            ProductDAO pDAO = new ProductDAO();
        %>

        <section id="billboard" class="bg-light-blue overflow-hidden padding-large" >
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
                boolean canProceedToCheckout = true; // Cờ kiểm tra toàn bộ giỏ hàng
                for (Carts c : carts) {
                    // KIỂM TRA TỒN KHO
                    boolean isOutOfStock = c.getQuantity() > c.getVariant().getStock();
                    if (isOutOfStock) {
                        canProceedToCheckout = false; // Nếu có 1 sản phẩm hết hàng, không cho thanh toán
                    }
                    // Tính tổng tiền ban đầu cho các sản phẩm hợp lệ
                    if (!isOutOfStock) {
                        initialTotalPrice += c.getVariant().getDiscountPrice() * c.getQuantity();
                    }
            %>
            <div class="cart-item <%= isOutOfStock ? "out-of-stock" : "" %>" 
                 data-id="<%= c.getVariant().getVariantID() %>" 
                 data-price="<%= c.getVariant().getDiscountPrice() %>">

                <input type="checkbox" class="item-checkbox" checked <%= isOutOfStock ? "disabled" : "" %>>
                <img src="images/<%= c.getVariant().getImageList()[0] %>" class="product-img" alt="Product">
                <div class="item-info">
                    <p class="product-name"><%= pDAO.getNameByID(c.getVariant().getProductID()) + " - " + c.getVariant().getStorage() %></p>
                    <p class="product-price"><%= vnFormat.format(c.getVariant().getDiscountPrice()) %></p>
                    <p class="product-color"><%= c.getVariant().getColor() %></p>
                    
                    <%-- HIỂN THỊ CẢNH BÁO NẾU HẾT HÀNG --%>
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

                <form action="cart" method="post" class="delete-form">
                    <input type="hidden" name="action" value="delete" />
                    <input type="hidden" name="cartID" value="<%= c.getCartID() %>" />
                    <input type="hidden" name="variantID" value="<%= c.getVariant().getVariantID() %>" />
                    <button type="submit" class="delete-btn"><i class="fa-solid fa-trash"></i></button>
                </form>
            </div>
            <% } %>

            <div class="cart-total">
                <h3 id="totalAmount">Total: <%= vnFormat.format(initialTotalPrice) %></h3>
                <form id="buyForm" action="payment" method="get" onsubmit="return collectSelectedItems()">
                    <input type="hidden" name="action" value="buyNowFromCart" />
                    <input type="hidden" name="selectedIds" id="selectedIds" />
                    <button type="submit" class="buy-btn" <%= !canProceedToCheckout ? "disabled" : "" %>>Buy</button>
                </form>
            </div>
            <% } %>
        </section>
        </section>
        

        <footer> <%-- Phần Footer của bạn --%> </footer>

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
                        // Chỉ tính tổng cho các item được chọn và không bị vô hiệu hóa
                        if (checkbox && checkbox.checked && !checkbox.disabled) {
                            const price = parseFloat(item.getAttribute("data-price"));
                            const quantity = parseInt(item.querySelector(".item-quantity span").textContent);
                            total += price * quantity;
                        }
                    });

                    const formattedTotal = new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(total);

                    if (totalElement) {
                        totalElement.textContent = "Total: " + formattedTotal;
                    }
                }

                function updateSelectAllState() {
                    if (selectAllCheckbox) {
                        // Select All chỉ được check nếu TẤT CẢ các checkbox HỢP LỆ đều được check
                        const allValidChecked = Array.from(itemCheckboxes).every(cb => cb.checked);
                        selectAllCheckbox.checked = allValidChecked;
                    }
                }
                
                if (selectAllCheckbox) {
                    selectAllCheckbox.addEventListener("change", function () {
                        itemCheckboxes.forEach(checkbox => {
                            checkbox.checked = selectAllCheckbox.checked;
                        });
                        updateTotal();
                    });
                }
                
                itemCheckboxes.forEach(checkbox => {
                    checkbox.addEventListener("change", function () {
                        updateSelectAllState();
                        updateTotal();
                    });
                });
                
                // Cập nhật trạng thái ban đầu của "Select All"
                updateSelectAllState();
            });

            function collectSelectedItems() {
                let selected = [];
                document.querySelectorAll(".cart-item").forEach(item => {
                    const checkbox = item.querySelector(".item-checkbox");
                    if (checkbox && checkbox.checked && !checkbox.disabled) {
                        selected.push(item.getAttribute("data-id"));
                    }
                });

                if (selected.length === 0) {
                    alert("Please select at least one valid product to buy!");
                    return false;
                }

                document.getElementById("selectedIds").value = selected.join(",");
                return true;
            }
        </script>

    </body>
</html>