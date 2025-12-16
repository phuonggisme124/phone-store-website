<%@page import="model.Specification"%>
<%@page import="model.Review"%>
<%@page import="dao.ReviewDAO"%>
<%@page import="dao.ProductDAO"%>
<%@page import="dao.VariantsDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@ page import="dao.WishlistDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="/layout/header.jsp" %>


<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="css/product_detail.css">
<link rel="stylesheet" href="css/review_detail.css">
<link rel="stylesheet" href="css/gallery.css">
<link rel="stylesheet" href="css/customer_review.css?v=1.0.1">

<%    ProductDAO pdao = new ProductDAO();
    ReviewDAO rdao = new ReviewDAO();

    int productID = (int) request.getAttribute("productID");
    double rating = (Double) request.getAttribute("rating");
    Variants variants = (Variants) request.getAttribute("variants");
    Specification specification = (Specification) request.getAttribute("specification");

    List<Variants> listVariants = (List<Variants>) request.getAttribute("listVariants");
    List<String> listStorage = (List<String>) request.getAttribute("listStorage");
    List<Review> listReview = (List<Review>) request.getAttribute("listReview");
    List<Variants> listVariantRating = (List<Variants>) request.getAttribute("listVariantRating");

    int stock = variants.getStock();
    int currentVariantID = variants.getVariantID();

    int userID = 0;
    if (isLoggedIn) {
        userID = user.getCustomerID();
        displayName = (user.getFullName() != null && !user.getFullName().trim().isEmpty())
                ? user.getFullName() : user.getEmail();
    }
%>

<body>

    <section class="bg-light-blue padding-large" style="margin-top:-1px;">

        <%
            String reviewError = (String) session.getAttribute("reviewError");
            if (reviewError != null) {
        %>
        <div class="alert alert-warning" style="color: red; font-weight: bold; margin-bottom: 15px;">
            <%= reviewError%>
        </div>
        <%
                session.removeAttribute("reviewError");
            }
        %>

        <div class="container">
            <h1 class="product-title"><%= pdao.getNameByID(variants.getProductID())%></h1>

            <div class="product-container">
                <div class="product-left">

                    <div class="gallery">
                        <div class="main-image">
                            <img id="displayedImage" src="images/<%= variants.getImageList()[0]%>" alt="main image">
                        </div>

                        <div class="thumbnails">
                            <%
                                String[] imgs = variants.getImageList();
                                for (int i = 0; i < imgs.length; i++) {
                                    String img = imgs[i];
                            %>
                            <img src="images/<%= img%>"
                                 class="thumbnail <%= (i == 0) ? "active" : ""%>"
                                 onclick="changeImage(this)">
                            <% }%>
                        </div>
                    </div>

                    <div class="spec-table1">
                        <div class="spec-row">
                            <span class="spec-label">DESCRIPTION</span>
                            <span class="spec-value"><%= variants.getDescription()%></span>
                        </div>
                    </div>
                </div>

                <div class="product-right">
                    <div class="price-box">
                        <p>Price</p>
                        <h2 id="price"><%= String.format("%,.0f", variants.getDiscountPrice())%> VND</h2>
                    </div>

                    <% if (variants.getStorage() != null && !variants.getStorage().equals("N/A")) { %>
                    <div class="option-box">
                        <p>Version</p>
                        <div class="option-list">
                            <% for (String v : listStorage) {%>
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= variants.getColor()%>&storage=<%= v%>"
                               class="option-label <%= (variants.getStorage().equals(v)) ? "selected" : ""%>">
                                <%= v%>
                            </a>
                            <% } %>
                        </div>
                    </div>
                    <% } %>

                    <div class="option-box">
                        <p>Color</p>
                        <div class="color-list">
                            <% for (Variants v : listVariants) {
                                    if (variants.getStorage() != null && variants.getStorage().equals(v.getStorage())) {
                            %>
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= v.getColor()%>&storage=<%= variants.getStorage()%>&vID=<%= v.getVariantID()%>"
                               class="color-label <%= (variants.getColor().equals(v.getColor())) ? "selected" : ""%>"
                               style="background-color:<%= v.getColor()%>;">
                            </a>
                            <% }
                                }%>
                        </div>
                    </div>

                    <div class="option-box">
                        <p>Quantity</p>

                        <div class="quantity-selector" data-stock="<%= stock%>">
                            <button type="button" class="quantity-btn minus-btn">-</button>
                            <input type="text" id="quantity-display" class="quantity-input" value="1" readonly>
                            <button type="button" class="quantity-btn plus-btn">+</button>
                        </div>

                        <div class="stock-status-inline">
                            <% if (variants.getStock() > 0) {%>
                            <span class="in-stock">In stock: <%= variants.getStock()%> items</span>
                            <% } else { %>
                            <span class="out-stock">Out of stock</span>
                            <% }%>
                        </div>

                        <div id="stock-error" class="stock-error">
                            Sorry, you can only buy a maximum of <%= stock%> products.
                        </div>
                    </div>

                    <div class="action-buttons">
                        <% if (variants.getStock() > 0) { %>
                        <% if (isLoggedIn) {%>

                        <form action="payment" method="get">
                            <input type="hidden" name="variantID" value="<%= currentVariantID%>">
                            <input type="hidden" name="quantity" class="hiddenQuantityInput" value="1">
                            <input type="hidden" name="action" value="buyNowFromProductDetail">
                            <button type="submit" class="buy-now">BUY NOW</button>
                        </form>

                        <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="userID" value="<%= userID%>">
                            <input type="hidden" name="variantID" value="<%= currentVariantID%>">
                            <input type="hidden" name="quantity" class="hiddenQuantityInput" value="1">
                            <button type="submit" class="add-cart">Add to cart</button>
                        </form>

                        <% } else {
                            String redirectURL = "product?action=viewDetail&pID=" + variants.getProductID()
                                    + "&color=" + variants.getColor()
                                    + "&storage=" + variants.getStorage();
                            String encodedURL = java.net.URLEncoder.encode(redirectURL, "UTF-8");
                        %>

                        <a href="login?redirect=<%= encodedURL%>" class="buy-now">BUY NOW</a>
                        <p class="text-danger fw-bold mt-2">
                            <a href="login?redirect=<%= encodedURL%>">Login</a> to add product to cart.
                        </p>

                        <% } %>

                        <% } else { %>
                        <button class="out-of-stock-btn" disabled>OUT OF STOCK</button>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- SPECIFICATIONS -->
            <div class="product-info">
                <div class="spec-section">
                    <h2>Specifications</h2>
                </div>

                <% if (specification != null) { %>

                <% if (specification.getOs() != null && !specification.getOs().trim().isEmpty()) {%>
                <div class="spec-row">
                    <span class="spec-label">OS</span>
                    <span class="spec-value"><%= specification.getOs()%></span>
                </div>
                <% } %>

                <% if (specification.getCpu() != null && !specification.getCpu().trim().isEmpty()) {%>
                <div class="spec-row">
                    <span class="spec-label">CPU</span>
                    <span class="spec-value"><%= specification.getCpu()%></span>
                </div>
                <% } %>

                <% if (specification.getGpu() != null && !specification.getGpu().trim().isEmpty()) {%>
                <div class="spec-row">
                    <span class="spec-label">GPU</span>
                    <span class="spec-value"><%= specification.getGpu()%></span>
                </div>
                <% } %>

                <% if (specification.getRam() != null && !specification.getRam().trim().isEmpty()) {%>
                <div class="spec-row">
                    <span class="spec-label">RAM</span>
                    <span class="spec-value"><%= specification.getRam()%></span>
                </div>
                <% } %>

                <% if (specification.getBatteryCapacity() > 0) {%>
                <div class="spec-row">
                    <span class="spec-label">Battery Capacity</span>
                    <span class="spec-value"><%= specification.getBatteryCapacity()%> mAh</span>
                </div>
                <% } %>

                <% if (specification.getTouchscreen() != null && !specification.getTouchscreen().trim().isEmpty()) {%>
                <div class="spec-row">
                    <span class="spec-label">Touchscreen</span>
                    <span class="spec-value"><%= specification.getTouchscreen()%></span>
                </div>
                <% } %>

                <% } %>

                <% if (variants != null && variants.getStorage() != null && !variants.getStorage().trim().isEmpty()) {%>
                <div class="spec-row">
                    <span class="spec-label">ROM</span>
                    <span class="spec-value"><%= variants.getStorage()%></span>
                </div>
                <% }%>



            </div>

            <!-- REVIEWS -->
            <div class="review-container">
                <div class="overall-rating">
                    <div class="score-display">
                        <span class="star-icon">&#9733;</span>
                        <span class="main-score"><%= String.format("%.1f", rating)%></span>
                        <span class="max-score">/5</span>
                    </div>

                    <p class="stats">
                        <%= rdao.getTotalReview(listVariantRating, listReview)%> Review
                    </p>
                </div>

                <div class="rating-breakdown">
                    <% for (int k = 5; k > 0; k--) {
                            double percentRating = rdao.getPercentRating(listVariantRating, listReview, k);
                    %>
                    <div class="star-row">
                        <span class="star-level"><%= k%>★</span>
                        <div class="progress-bar-wrap">
                            <div class="progress-bar" style="width: <%= percentRating%>%"></div>
                        </div>
                        <span class="percentage"><%= String.format("%.0f", percentRating)%>%</span>
                    </div>
                    <% } %>
                </div>

                <% String[] images = variants.getImageList(); %>

                <% if (isLoggedIn) {%>
                <!-- WRITE REVIEW BUTTON -->
                <button id="openReviewModal" class="write-review-button">Write Review</button>

                <!-- REVIEW MODAL -->
                <div id="reviewModal" class="modal">
                    <div class="modal-content">

                        <span class="close-button">&times;</span>

                        <form class="review-form-container" action="review" method="POST" enctype="multipart/form-data">
                            <div class="product-header">
                                <input type="hidden" name="vID" value="<%= currentVariantID%>">
                                <img src="images/<%= images[0]%>" alt="product image" class="product-image">
                                <h2 class="product-title">
                                    <%= pdao.getNameByID(productID)%> 
                                    <%= variants.getStorage().equals("N/A") ? "" : variants.getStorage()%>
                                </h2>
                            </div>

                            <div id="star-rating-js" class="star-rating-selection">
                                <%
                                    String[] ratingTexts = {"Very bad", "Bad", "Okay", "Good", "Excellent"};
                                    for (int k = 1; k <= 5; k++) {
                                %>
                                <label class="star-option" data-rating-value="<%= k%>">
                                    <input type="radio" name="rating" value="<%= k%>" required>
                                    <span class="star-icon">&#9733;</span>
                                    <span class="rating-text"><%= ratingTexts[k - 1]%></span>
                                </label>
                                <% }%>
                            </div>

                            <textarea name="comment" class="comment-textarea" placeholder="Please share your thoughts..." required></textarea>

                            <div class="options-row">
                                <span class="photo-upload">
                                    <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display:none;">
                                    <label for="photo-upload-input" class="photo-upload-label">
                                        <span class="camera-icon">&#128247;</span>
                                        Send photos (up to 3)
                                    </label>
                                </span>
                            </div>

                            <div id="image-preview-container" class="image-preview-container"></div>

                            <input type="hidden" name="uID" value="<%= userID%>">

                            <div class="policy-and-submit">
                                <button type="submit" class="submit-button">Submit Review</button>
                            </div>
                        </form>
                    </div>
                </div>
                <% } %>

                <!-- REVIEW LIST -->
                <div class="review-list">
                    <% if (listReview.isEmpty()) { %>
                    <p class="no-review-message">No reviews yet for this product.</p>
                    <% } else {
                        for (Review r : listReview) {
                            String[] reviewImages = rdao.getImages(r.getImage()) != null
                                    ? rdao.getImages(r.getImage()).toArray(new String[0])
                                    : new String[0];
                    %>

                    <div class="review-item" data-variant-id="<%= r.getVariantID()%>">

                        <p>
                            <strong><%= r.getUser().getFullName() != null ? r.getUser().getFullName() : "Anonymous"%></strong>
                            <% for (int s = 0; s < r.getRating(); s++) { %>
                            <span style="color: #fdd835;">&#9733;</span>
                            <% }%>
                        </p>

                        <p><%= r.getComment()%></p>

                        <% if (reviewImages.length > 0) { %>
                        <div class="review-images">
                            <% for (String img : reviewImages) {%>
                            <img src="images_review/<%= img%>" style="width:100px; margin:5px;">
                            <% } %>
                        </div>
                        <% } %>

                        <% if (r.getReply() != null && !r.getReply().isEmpty()) {%>
                        <div class="review-reply">
                            <strong>Reply:</strong> <%= r.getReply()%>
                        </div>
                        <% }%>
                        <div style="background: yellow; color: black;">

                        </div>
                        <% if (isLoggedIn && userID == r.getUser().getCustomerID()) {%>
                        <form action="review?action=deleteReview" method="post" style="display:inline;">
                            <input type="hidden" name="rID" value="<%= r.getReviewID()%>">
                            <input type="hidden" name="vID" value="<%= r.getVariant().getVariantID()%>">

                            <button type="submit" 
                                    class="btn-delete-review" 
                                    onclick="return confirm('Are you sure you want to delete this review?');">
                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                Delete
                            </button>
                        </form>
                        <% } %>

                        <hr/>
                    </div>

                    <% }
                        }%>
                </div>

                <!-- RELATED PRODUCTS -->
                <%
                    // Lấy danh sách sản phẩm liên quan do servlet setAttribute
                    List<Products> relatedList = (List<Products>) request.getAttribute("relatedList");
                %>
                <section class="related-products position-relative padding-large no-padding-top">
                    <div class="container">
                        <div class="row mb-5">
                            <div class="display-header d-flex justify-content-between pb-3">
                                <h2 class="display-7 text-dark text-uppercase">Related Products</h2>
                            </div>

                            <%
                                // Import NumberFormat và Locale ở đầu JSP rồi
                                NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

                                // Giới hạn tối đa 10 sản phẩm
                                List<Products> relatedList10 = new ArrayList<>();
                                if (relatedList != null) {
                                    for (int i = 0; i < relatedList.size() && i < 10; i++) {
                                        relatedList10.add(relatedList.get(i));
                                    }
                                }
                            %>

                            <div class="swiper related-swiper">
                                <div class="swiper-wrapper">
                                    <%
                                        for (Products rp : relatedList10) {
                                            if (rp.getVariants() != null && !rp.getVariants().isEmpty()) {
                                    %>
                                    <div class="swiper-slide">
                                        <div class="product-card text-center position-relative">

                                            <div class="image-holder position-relative">
                                                <a href="product?action=viewDetail&pID=<%= rp.getProductID()%>">
                                                    <img src="images/<%= rp.getVariants().get(0).getImageUrl()%>" 
                                                         alt="<%= rp.getName()%>" class="img-fluid rounded-3">
                                                </a>
                                            </div>

                                            <div class="card-detail pt-3">
                                                <h3 class="card-title text-uppercase">
                                                    <a href="product?action=viewDetail&pID=<%= rp.getProductID()%>">
                                                        <%= rp.getName()%> 
                                                        <%= rp.getVariants().get(0).getColor()%> 
                                                        <%= rp.getVariants().get(0).getStorage()%>
                                                    </a>
                                                </h3>

                                                <!-- WISH LIST BUTTON -->
                                                <div class="wishlist-wrap">
                                                    <%
                                                        Customer u = (Customer) session.getAttribute("user");
                                                        boolean logged = (u != null);
                                                        boolean liked = false;
                                                        int variantID = -1;

                                                        if (rp.getVariants() != null && !rp.getVariants().isEmpty()) {
                                                            variantID = rp.getVariants().get(0).getVariantID();
                                                        }

                                                        if (logged && variantID > 0) {
                                                            try {
                                                                WishlistDAO wdao = new WishlistDAO();
                                                                liked = wdao.isExist(u.getCustomerID(), rp.getProductID(), variantID);
                                                            } catch (Exception e) {
                                                                e.printStackTrace();
                                                            }
                                                        }
                                                    %>

                                                    <% if (variantID > 0) { %>
                                                    <% if (logged) {%>
                                                    <button class="wishlist-btn" 
                                                            data-productid="<%= rp.getProductID()%>" 
                                                            data-variantid="<%= variantID%>"
                                                            style="background:none; border:none; padding:0;">
                                                        <i class="<%= liked ? "fas fa-heart" : "far fa-heart"%>" 
                                                           style="<%= liked ? "color:#e53e3e;" : ""%>"></i>
                                                    </button>
                                                    <% } else { %>
                                                    <a href="login.jsp" class="wishlist-btn">
                                                        <i class="far fa-heart"></i>
                                                    </a>
                                                    <% } %>
                                                    <% }%>
                                                </div>

                                                <script>
                                                    document.querySelectorAll('.wishlist-btn').forEach(btn => {
                                                        btn.addEventListener('click', function (e) {
                                                            e.preventDefault(); // chặn reload
                                                            const productId = this.dataset.productid;
                                                            const variantId = this.dataset.variantid;
                                                            const icon = this.querySelector('i');

                                                            fetch('<%=request.getContextPath()%>/product', {
                                                                method: 'POST',
                                                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                                                body: `action=toggleWishlist&productId=${productId}&variantId=${variantId}`
                                                            })
                                                                    .then(response => response.text())
                                                                    .then(() => {
                                                                        // đổi icon đỏ / xám
                                                                        if (icon.classList.contains('far')) {
                                                                            icon.classList.remove('far');
                                                                            icon.classList.add('fas');
                                                                            icon.style.color = '#e53e3e';
                                                                        } else {
                                                                            icon.classList.remove('fas');
                                                                            icon.classList.add('far');
                                                                            icon.style.color = '';
                                                                        }
                                                                    })
                                                                    .catch(err => console.error(err));
                                                        });
                                                    });
                                                </script>

                                                <span class="item-price text-primary">
                                                    <%= vnFormat.format(rp.getVariants().get(0).getDiscountPrice() != null ? rp.getVariants().get(0).getDiscountPrice() : rp.getVariants().get(0).getPrice())%>

                                                </span>
                                            </div>

                                        </div>
                                    </div>

                                    <%
                                            }
                                        }
                                    %>
                                </div>
                                <div class="swiper-button-next"></div>
                                <div class="swiper-button-prev"></div>
                            </div>
                        </div>
                    </div>
                </section>

                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css"/>
                <script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>

                <script>
                                                    var swiper = new Swiper('.related-swiper', {
                                                        slidesPerView: 4,
                                                        spaceBetween: 20,
                                                        navigation: {
                                                            nextEl: '.swiper-button-next',
                                                            prevEl: '.swiper-button-prev',
                                                        },
                                                        breakpoints: {
                                                            320: {slidesPerView: 1},
                                                            576: {slidesPerView: 2},
                                                            768: {slidesPerView: 3},
                                                            992: {slidesPerView: 4}
                                                        }
                                                    });
                </script>

            </div>


    </section>

    <footer id="footer">
        <div class="container">
            <p class="text-center mt-3">© 2025 MiniStore</p>
        </div>
    </footer>

    <script src="js/jquery-1.11.0.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>

    <script>
                                                        /* ------------------ REVIEW MODAL ------------------ */

                                                        const modal = document.getElementById("reviewModal");
                                                        const openModalBtn = document.getElementById("openReviewModal");
                                                        const closeBtn = document.getElementsByClassName("close-button")[0];

                                                        if (openModalBtn && modal)
                                                            openModalBtn.onclick = () => modal.style.display = "block";

                                                        if (closeBtn)
                                                            closeBtn.onclick = () => modal.style.display = "none";

                                                        window.onclick = (e) => {
                                                            if (e.target === modal)
                                                                modal.style.display = "none";
                                                        };

                                                        /* ------------------ QUANTITY SELECTOR ------------------ */

                                                        document.addEventListener("DOMContentLoaded", function () {

                                                            const minusBtn = document.querySelector('.minus-btn');
                                                            const plusBtn = document.querySelector('.plus-btn');
                                                            const quantityInput = document.getElementById('quantity-display');
                                                            const stockError = document.getElementById('stock-error');

                                                            const quantitySelector = document.querySelector('.quantity-selector');
                                                            const stock = quantitySelector ? parseInt(quantitySelector.dataset.stock) : 0;

                                                            const hiddenInputs = document.querySelectorAll('.hiddenQuantityInput');

                                                            function updateHiddenQuantity(val) {
                                                                hiddenInputs.forEach(input => {
                                                                    input.value = val;
                                                                    input.setAttribute('value', val);
                                                                });
                                                            }

                                                            if (minusBtn && plusBtn && quantityInput) {

                                                                quantityInput.value = 1;
                                                                updateHiddenQuantity(1);

                                                                minusBtn.onclick = () => {
                                                                    let val = parseInt(quantityInput.value);
                                                                    if (isNaN(val))
                                                                        val = 1;

                                                                    if (val > 1) {
                                                                        val--;
                                                                        quantityInput.value = val;
                                                                        updateHiddenQuantity(val);
                                                                        if (stockError)
                                                                            stockError.style.display = "none";
                                                                    }
                                                                };

                                                                plusBtn.onclick = () => {
                                                                    let val = parseInt(quantityInput.value);
                                                                    if (isNaN(val))
                                                                        val = 1;

                                                                    if (val < stock) {
                                                                        val++;
                                                                        quantityInput.value = val;
                                                                        updateHiddenQuantity(val);
                                                                        if (stockError)
                                                                            stockError.style.display = "none";
                                                                    } else {
                                                                        if (stockError)
                                                                            stockError.style.display = "block";
                                                                    }
                                                                };
                                                            }
                                                        });

                                                        /* ------------------ CHANGE IMAGE ------------------ */

                                                        function changeImage(thumb) {
                                                            const mainImg = document.getElementById('displayedImage');
                                                            const allThumbs = document.querySelectorAll('.thumbnail');

                                                            mainImg.src = thumb.src;
                                                            allThumbs.forEach(t => t.classList.remove('active'));
                                                            thumb.classList.add('active');
                                                        }
    </script>

    <script src="js/review-filter.js"></script>

    <script>
                                                        /* ------------------ STAR RATING HIGHLIGHT ------------------ */
                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            const starOptions = document.querySelectorAll('.star-option');
                                                            const allStars = document.querySelectorAll('.star-option .star-icon');

                                                            starOptions.forEach(option => {
                                                                option.addEventListener('click', function () {
                                                                    const ratingValue = parseInt(this.getAttribute('data-rating-value'));

                                                                    allStars.forEach(star => star.style.color = '#ccc');

                                                                    let count = 0;
                                                                    document.querySelectorAll('.star-option').forEach(opt => {
                                                                        if (++count <= ratingValue) {
                                                                            opt.querySelector('.star-icon').style.color = '#ffc107';
                                                                        }
                                                                    });

                                                                    const input = this.querySelector('input[type="radio"]');
                                                                    if (input)
                                                                        input.checked = true;
                                                                });
                                                            });
                                                        });
    </script>

    <script>
        /* ------------------ REVIEW IMAGE PREVIEW ------------------ */
        document.addEventListener("DOMContentLoaded", function () {
            const input = document.getElementById("photo-upload-input");
            const previewContainer = document.getElementById("image-preview-container");

            input.addEventListener("change", function () {
                previewContainer.innerHTML = "";

                const files = Array.from(this.files);
                if (files.length > 3) {
                    alert("You can only upload up to 3 photos!");
                    this.value = "";
                    return;
                }

                files.forEach(f => {
                    const img = document.createElement("img");
                    img.src = URL.createObjectURL(f);
                    img.classList.add("preview-img");
                    img.style.width = "90px";
                    img.style.margin = "5px";
                    previewContainer.appendChild(img);
                });
            });
        });
    </script>
</body>
</html>


