<%@page import="model.Specification"%>
<%@page import="dao.UsersDAO"%>
<%@page import="model.Review"%>
<%@page import="dao.ReviewDAO"%>
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
<link rel="stylesheet" href="css/customer_review.css?v=1.0.1">

<%    ProductDAO pdao = new ProductDAO();
    ReviewDAO rdao = new ReviewDAO();
    int productID = (int) request.getAttribute("productID");
    int categoryID = (int) request.getAttribute("categoryID");
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
        userID = user.getUserId();
        displayName = (user.getFullName() != null && !user.getFullName().trim().isEmpty())
                ? user.getFullName() : user.getEmail();
    }
%>

<body>
    <section class="bg-light-blue padding-large " style="margin-top:-1px;">
        <div class="container ">
            <h1 class="product-title"><%= pdao.getNameByID(variants.getProductID())%></h1>

            <div class="product-container">
                <!-- LEFT -->
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
                                 class="thumbnail <% if (i == 0) {
                                         out.print("active");
                                     } %>" 
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

                <!-- RIGHT -->
                <div class="product-right">
                    <div class="price-box">
                        <p>Price</p>
                        <h2 id="price"><%= String.format("%,.0f", variants.getDiscountPrice())%> VND</h2>
                    </div>

                    <% if (!variants.getStorage().equals("N/A")) { %>
                    <div class="option-box">
                        <p>Version</p>
                        <div class="option-list">
                            <% for (String v : listStorage) {%>
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= variants.getColor()%>&storage=<%= v%>&cID=<%= categoryID%>"
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
                                    if (variants.getStorage().equals(v.getStorage())) {%>
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= v.getColor()%>&storage=<%= variants.getStorage()%>&cID=<%= categoryID%>&vID=<%= v.getVariantID()%>"
                               class="color-label"
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
                        <div id="stock-error" class="stock-error">Sorry, you can only buy a maximum of <%= stock%> products.</div>
                    </div>

                    <div class="action-buttons">
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
                        <% } else { %>
                        <a href="login.jsp" class="buy-now">BUY NOW</a>
                        <p class="text-danger fw-bold mt-2">
                           <a href="login.jsp">đăng nhập</a> để thêm vào giỏ hàng.
                        </p>
                        <% }%>
                    </div>
                </div>
            </div>
            <div class="product-info " >      
                <div class="spec-section">
                    <h2>Specifications</h2> 
                </div> 
                <div class="spec-table"> 
                    <div class="spec-row"> 
                        <span class="spec-label">OS</span>
                        <span class="spec-value"><%=specification.getOs()%></span>
                    </div> 
                    <div class="spec-row"> <span class="spec-label">CPU</span>
                        <span class="spec-value"><%=specification.getCpu()%></span> </div> 
                    <div class="spec-row"> 
                        <span class="spec-label">GPU</span> 
                        <span class="spec-value"><%=specification.getGpu()%></span> 
                    </div> <div class="spec-row"> <span class="spec-label">RAM</span>
                        <span class="spec-value"><%=specification.getRam()%></span> </div>
                    <div class="spec-row"> <span class="spec-label">ROM</span> 
                        <span class="spec-value"><%=variants.getStorage()%></span> 
                    </div> 
                    <div class="spec-row"> 
                        <span class="spec-label">Battery Capacity</span> 
                        <span class="spec-value"><%=specification.getBatteryCapacity()%> mAh</span> 
                    </div> 
                    <div class="spec-row"> 
                        <span class="spec-label">Touchscreen</span> <span class="spec-value"><%=specification.getTouchscreen()%></span> 
                    </div> 
                </div> 
            </div> 
            <!-- Review Section -->
            <div class="review-container ">
                <div class="overall-rating">
                    <div class="score-display">
                        <span class="star-icon">&#9733;</span>
                        <span class="main-score"><%= String.format("%.1f", rating)%></span>
                        <span class="max-score">/5</span>
                    </div>
                    <p class="stats"><%= rdao.getTotalReview(listVariantRating, listReview)%> Review</p>
                </div>

                <div class="rating-breakdown">
                    <% for (int k = 5; k > 0; k--) {
                        double percentRating = rdao.getPercentRating(listVariantRating, listReview, k);%>
                    <div class="star-row">
                        <span class="star-level"><%= k%>&#9733;</span>
                        <div class="progress-bar-wrap">
                            <div class="progress-bar" style="width: <%= percentRating%>%"></div>
                        </div>
                        <span class="percentage"><%= String.format("%.0f", percentRating)%>&#37;</span>
                    </div>
                    <% } %>
                </div>
                <%
                    String[] images = variants.getImageList();
                %>
                <% if (isLoggedIn) {%>
                Modal 
                <button id="openReviewModal" class="write-review-button" type="button">Write Review</button>
                <div id="reviewModal" class="modal">
                    <div class="modal-content">
                        <span class="close-button">&times;</span>
                        <form class="review-form-container" action="review" method="POST" enctype="multipart/form-data">
                            <div class="product-header">
                                <input type="hidden" name="vID" value="<%= currentVariantID%>">
                                <img src="images/<%= images[0]%>" alt="<%= pdao.getNameByID(productID)%> <%= variants.getStorage()%>" class="product-image">
                                <h2 class="product-title"><%= pdao.getNameByID(productID)%> <%= variants.getStorage().equals("N/A") ? "" : variants.getStorage()%></h2>
                            </div>

                            <div id="star-rating-js" class="star-rating-selection">
                                <% String[] ratingTexts = {"Very bad", "Bad", "Okay", "Good", "Excellent"};
                                for (int k = 1; k <= 5; k++) {%>
                                <label class="star-option" data-rating-value="<%= k%>">
                                    <input type="radio" name="rating" value="<%= k%>" required>
                                    <span class="star-icon">&#9733;</span>
                                    <span class="rating-text"><%= ratingTexts[k - 1]%></span>
                                </label>
                                <% }%>
                            </div>

                            <textarea name="comment" class="comment-textarea" placeholder="Please share your thoughts..." rows="5" required></textarea>

                            <div class="options-row">
                                <span class="photo-upload">
                                    <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display: none;">
                                    <label for="photo-upload-input" class="photo-upload-label">
                                        <span class="camera-icon">&#128247;</span>
                                        Send photos (up to 3 photos)
                                    </label>
                                </span>
                            </div>

                            <div id="image-preview-container" class="image-preview-container"></div>

                            <div class="info-input-row">
                                <input type="hidden" name="uID" value="<%= userID%>" >
                            </div>

                            <div class="policy-and-submit">
                                <button type="submit" class="submit-button">Submit Review</button>
                            </div>
                        </form>
                    </div>
                </div>
                <% }%>

                <div class="review-list ">
                    <% if (listReview.isEmpty()) { %>
                    <p>No reviews yet for this product.</p>
                    <% } else { %>
                    <% for (Review r : listReview) {
                            String[] reviewImages = rdao.getImages(r.getImage()) != null ? rdao.getImages(r.getImage()).toArray(new String[0]) : new String[0];
                    %>
                    <div class="review-item">
                        <p><strong><%= r.getUserName() != null ? r.getUserName() : "Anonymous"%></strong> 
                            <%

                                for (int i = 0; i < rating; i++) {
                            %>
                            &#9733;
                            <%
                                }
                            %>
                        </p>
                        <p><%= r.getComment()%></p>

                        <% if (reviewImages.length > 0) { %>
                        <div class="review-images">
                            <% for (String img : reviewImages) {%>
                            <img src="images_review/<%= img%>" alt="review image" style="width:100px; margin:5px;">
                            <% } %>
                        </div>
                        <% } %>

                        <% if (r.getReply() != null && !r.getReply().isEmpty()) {%>
                        <div class="review-reply">
                            <strong>Reply:</strong> <%= r.getReply()%>
                        </div>
                        <% } %>

                        <hr/>
                    </div>
                    <% } %>
                    <% }%>
                </div>
            </div>
        </div>


    </section>

    <footer id="footer" class="overflow-hidden">
        <div class="container">
            <p class="text-center mt-3">© 2025 MiniStore</p>
        </div>
    </footer>

    <script src="js/jquery-1.11.0.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>

    <script>
                                     const modal = document.getElementById("reviewModal");
                                     const openModalBtn = document.getElementById("openReviewModal");
                                     const closeBtn = document.getElementsByClassName("close-button")[0];
                                     if (openModalBtn && modal) {
                                         openModalBtn.onclick = () => modal.style.display = "block";
                                     }
                                     if (closeBtn) {
                                         closeBtn.onclick = () => modal.style.display = "none";
                                     }
                                     window.onclick = (e) => {
                                         if (e.target === modal)
                                             modal.style.display = "none";
                                     };

                                     // Quantity selector
                                     const minusBtn = document.querySelector('.minus-btn');
                                     const plusBtn = document.querySelector('.plus-btn');
                                     const quantityInput = document.getElementById('quantity-display');
                                     const stockError = document.getElementById('stock-error');
                                     const stock = parseInt(document.querySelector('.quantity-selector').dataset.stock);
                                     const hiddenInputs = document.querySelectorAll('.hiddenQuantityInput');

                                     if (minusBtn && plusBtn && quantityInput) {
                                         minusBtn.addEventListener('click', () => {
                                             let val = parseInt(quantityInput.value);
                                             if (val > 1) {
                                                 val--;
                                                 quantityInput.value = val;
                                                 hiddenInputs.forEach(i => i.value = val);
                                                 stockError.style.display = "none";
                                             }
                                         });
                                         plusBtn.addEventListener('click', () => {
                                             let val = parseInt(quantityInput.value);
                                             if (val < stock) {
                                                 val++;
                                                 quantityInput.value = val;
                                                 hiddenInputs.forEach(i => i.value = val);
                                                 stockError.style.display = "none";
                                             } else {
                                                 stockError.style.display = "block";
                                             }
                                         });
                                     }
                                     function changeImage(thumb) {
                                         const mainImg = document.getElementById('displayedImage');
                                         const allThumbs = document.querySelectorAll('.thumbnail');

                                         // đổi ảnh chính
                                         mainImg.src = thumb.src;

                                         // xóa active ở tất cả thumbnail
                                         allThumbs.forEach(t => t.classList.remove('active'));

                                         // thêm active cho thumbnail hiện tại
                                         thumb.classList.add('active');
                                     }
    </script>

</body>
</html>
