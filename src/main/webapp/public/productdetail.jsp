<%@page import="model.Specification"%>
<%@page import="dao.UsersDAO"%>
<%@page import="model.Review"%>
<%@page import="dao.ReviewDAO"%>
<%@page import="model.Category"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/layout/header.jsp" %>

<title>Product Detail</title>
<link rel="stylesheet" href="css/product_detail.css">
<link rel="stylesheet" href="css/review_detail.css">
<link rel="stylesheet" href="css/gallery.css">
<link rel="stylesheet" href="css/home.css">
<link rel="stylesheet" href="css/select_product.css">
<link rel="stylesheet" href="css/customer_review.css?v=1.0.1">
<script src="js/modernizr.js"></script>

<%
    ProductDAO pdao = new ProductDAO();
    ReviewDAO rdao = new ReviewDAO();
    UsersDAO udao = new UsersDAO();
    int productID = (int) request.getAttribute("productID");
    int categoryID = (int) request.getAttribute("categoryID");
    double rating = (Double) request.getAttribute("rating");
    Variants variants = (Variants) request.getAttribute("variants");
    int stock = variants.getStock();
    int currentVariantID = variants.getVariantID();
    Specification specification = (Specification) request.getAttribute("specification");

    String vIDFromProductByCategoryStr = (String) request.getAttribute("vID");
    if (vIDFromProductByCategoryStr != null) {
        currentVariantID = Integer.parseInt(vIDFromProductByCategoryStr);
    }

    List<Variants> listVariants = (List<Variants>) request.getAttribute("listVariants");
    List<Variants> listVariantRating = (List<Variants>) request.getAttribute("listVariantRating");
    List<Review> listReview = (List<Review>) request.getAttribute("listReview");
    List<String> listStorage = (List<String>) request.getAttribute("listStorage");

    int userID = 0;
    if (isLoggedIn) {
        userID = user.getUserId();
        displayName = (user.getFullName() != null && !user.getFullName().trim().isEmpty()) ? user.getFullName() : user.getEmail();
    }
%>

<body>
    <% 
        String res = (String) session.getAttribute("res");
        if (res != null) {
            session.removeAttribute("res");
    %>
        <div class="alert-success" id="successAlert" style="display: block;">
            <i class="bi bi-check-circle-fill"></i>
            <span><%= res %></span>
        </div>
        <script>
            const alertBox = document.getElementById('successAlert');
            setTimeout(() => {
                if (alertBox) alertBox.style.display = 'none';
            }, 3500);
        </script>
    <% } %>

    <div class="product-container">
        <div class="product-left">
            <div class="gallery">
                <% for (int i = 0; i < variants.getImageList().length; i++) { %>
                    <input type="radio" name="gallery" id="img<%= i + 1 %>" <%= (i == 0) ? "checked" : "" %>>
                <% } %>
                <div class="main-image">
                    <% for (String img : variants.getImageList()) { %>
                        <img src="images/<%= img %>" alt="image">
                    <% } %>
                </div>
                <div class="thumbnails">
                    <% for (int i = 0; i < variants.getImageList().length; i++) { %>
                        <label for="img<%= i + 1 %>"><img src="images/<%= variants.getImageList()[i] %>" alt="thumb"></label>
                    <% } %>
                </div>
            </div>

            <div class="spec-table">
                <div class="spec-row">
                    <span class="spec-label">DESCRIPTIONS</span>
                    <span class="spec-value"><%= variants.getDescription() %></span>
                </div>
            </div>

            <div class="spec-section">
                <h2>Specifications</h2>
                <div class="spec-table">
                    <div class="spec-row"><span class="spec-label">OS</span><span class="spec-value"><%= specification.getOs() %></span></div>
                    <div class="spec-row"><span class="spec-label">CPU</span><span class="spec-value"><%= specification.getCpu() %></span></div>
                    <div class="spec-row"><span class="spec-label">GPU</span><span class="spec-value"><%= specification.getGpu() %></span></div>
                    <div class="spec-row"><span class="spec-label">RAM</span><span class="spec-value"><%= specification.getRam() %></span></div>
                    <div class="spec-row"><span class="spec-label">ROM</span><span class="spec-value"><%= variants.getStorage() %></span></div>
                    <div class="spec-row"><span class="spec-label">Battery Capacity</span><span class="spec-value"><%= specification.getBatteryCapacity() %> mAh</span></div>
                    <div class="spec-row"><span class="spec-label">Touchscreen</span><span class="spec-value"><%= specification.getTouchscreen() %></span></div>
                </div>
            </div>
        </div>

        <div class="product-right">
            <div class="price-box">
                <p>Price</p>
                <h2 id="price"><%= String.format("%,.0f", variants.getDiscountPrice()) %> VND</h2>
            </div>

            <% if (!variants.getStorage().equals("N/A")) { %>
            <div class="option-box">
                <p>Version</p>
                <div class="option-list">
                    <% for (String v : listStorage) { %>
                        <a href="product?action=selectStorage&pID=<%= variants.getProductID() %>&color=<%= variants.getColor() %>&storage=<%= v %>&cID=<%= categoryID %>" 
                           class="option-label <%= (variants.getStorage().equals(v)) ? "selected" : "" %>"><%= v %></a>
                    <% } %>
                </div>
            </div>
            <% } %>

            <div class="option-box">
                <p>Color</p>
                <div class="color-list">
                    <% for (Variants v : listVariants) {
                        if (variants.getStorage().equals(v.getStorage())) { %>
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID() %>&color=<%= v.getColor() %>&storage=<%= variants.getStorage() %>&cID=<%= categoryID %>&vID=<%= v.getVariantID() %>"
                               class="color-label"
                               style="background-color:<%= v.getColor() %>;">
                            </a>
                    <%  } } %>
                </div>
            </div>

            <div class="option-box">
                <p>Quantity</p>
                <div class="quantity-selector" data-stock="<%= stock %>">
                    <button type="button" class="quantity-btn minus-btn">-</button>
                    <input type="text" id="quantity-display" class="quantity-input" value="1" readonly>
                    <button type="button" class="quantity-btn plus-btn">+</button>
                </div>
                <div id="stock-error" class="stock-error">Sorry, you can only buy a maximum of <%= stock %> products.</div>
            </div>

            <div class="action-buttons">
                <% if (isLoggedIn) { %>
                    <form action="payment" method="get" style="display: inline-block;">
                        <input type="hidden" name="variantID" value="<%= currentVariantID %>">
                        <input type="hidden" name="quantity" class="hiddenQuantityInput" value="1">
                        <input type="hidden" name="action" value="buyNowFromProductDetail">
                        <button type="submit" class="buy-now">BUY NOW</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/cart" method="post" style="display: inline-block;">
                        <input type="hidden" name="userID" value="<%= userID %>">
                        <input type="hidden" name="variantID" value="<%= currentVariantID %>">
                        <input type="hidden" name="quantity" class="hiddenQuantityInput" value="1">
                        <button type="submit" class="add-cart">Add to cart</button>
                    </form>
                <% } else { %>
                    <a href="login.jsp" class="buy-now">BUY NOW</a>
                    <p class="text-danger fw-bold mt-2">Bạn cần <a href="login.jsp">đăng nhập</a> để thêm vào giỏ hàng.</p>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Reviews -->
    <div class="review-container">
        <div class="overall-rating">
            <div class="score-display">
                <span class="star-icon">&#9733;</span>
                <span class="main-score"><%= String.format("%.1f", rating) %></span>
                <span class="max-score">/5</span>
            </div>
            <p class="stats"><%= rdao.getTotalReview(listVariantRating, listReview) %> Review</p>
        </div>

        <% if (isLoggedIn) { %>
        <button id="openReviewModal" class="write-review-button" type="button">Write Review</button>
        <% } %>

        <div class="review-list">
            <% if (listReview.isEmpty()) { %>
                <p>No reviews yet for this product.</p>
            <% } else {
                for (Review r : listReview) {
                    List<String> imgs = rdao.getImages(r.getImage());
            %>
            <div class="review-item">
                <p><strong><%= r.getUserName() != null ? r.getUserName() : "Anonymous" %></strong></p>
                <p><%= r.getComment() %></p>
                <% if (imgs != null && !imgs.isEmpty()) { %>
                <div class="review-images">
                    <% for (String img : imgs) { %>
                        <img src="images_review/<%= img %>" class="review-thumbnail">
                    <% } %>
                </div>
                <% } %>
            </div>
            <% } } %>
        </div>
    </div>

<footer id="footer" class="overflow-hidden">
    <div class="container">
        <p class="text-center mt-3">© 2025 MiniStore</p>
    </div>
</footer>

<script src="js/jquery-1.11.0.min.js"></script>
<script src="js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>

<script>
    // Modal Review
    const modal = document.getElementById("reviewModal");
    const openModalBtn = document.getElementById("openReviewModal");
    const closeBtn = document.getElementsByClassName("close-button")[0];
    if (openModalBtn) openModalBtn.onclick = () => modal.style.display = "block";
    if (closeBtn) closeBtn.onclick = () => modal.style.display = "none";
    window.onclick = (e) => { if (e.target === modal) modal.style.display = "none"; };

    // Quantity selection
    const minusBtn = document.querySelector('.minus-btn');
    const plusBtn = document.querySelector('.plus-btn');
    const quantityInput = document.querySelector('#quantity-display');
    const stockError = document.getElementById('stock-error');
    const stock = parseInt(document.querySelector('.quantity-selector').dataset.stock);
    const hiddenInputs = document.querySelectorAll('.hiddenQuantityInput');
    if (minusBtn && plusBtn && quantityInput) {
        minusBtn.addEventListener('click', () => {
            let val = parseInt(quantityInput.value);
            if (val > 1) { val--; quantityInput.value = val; hiddenInputs.forEach(i => i.value = val); stockError.style.display = "none"; }
        });
        plusBtn.addEventListener('click', () => {
            let val = parseInt(quantityInput.value);
            if (val < stock) { val++; quantityInput.value = val; hiddenInputs.forEach(i => i.value = val); stockError.style.display = "none"; }
            else { stockError.style.display = "block"; }
        });
    }
</script>

</body>
</html>
