<%@page import="model.Specification"%>
<%@page import="dao.UsersDAO"%>
<%@page import="model.Review"%>
<%@page import="dao.ReviewDAO"%>
<%@page import="model.Category"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>


<%@ include file="/layout/header.jsp" %>

<title>Product Detail</title>
<link rel="stylesheet" href="css/product_detail.css">
<link rel="stylesheet" href="css/gallery.css">
<link rel="stylesheet" href="css/select_product.css">
<link rel="stylesheet" href="css/customer_review.css">
<script src="js/modernizr.js"></script>
<%    ProductDAO pdao = new ProductDAO();
    ReviewDAO rdao = new ReviewDAO();
    UsersDAO udao = new UsersDAO();
    int productID = (int) request.getAttribute("productID");
    int categoryID = (int) request.getAttribute("categoryID");
    double rating = (Double) request.getAttribute("rating");
    Variants variants = (Variants) request.getAttribute("variants");
    int stock = variants.getStock();
    int currentVariantID = variants.getVariantID();

    Specification specification = (Specification) request.getAttribute("specification");

    //Get product from category page
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

<section id="billboard" class="bg-light-blue overflow-hidden padding-large" style="margin-top:-1px;">
    <div class="container">
        <h1 class="product-title"><%= pdao.getNameByID(variants.getProductID())%></h1>
    </div>
    <div class="product-container">
        <div class="product-left">
            <div class="gallery">
                <%for (int i = 0; i < variants.getImageList().length; i++) {%>
                <input type="radio" name="gallery" id="img<%= i + 1%>" <%=(i + 1 == 1) ? "checked" : ""%>>
                <% } %>

                <div class="main-image">
                    <%for (int i = 0; i < variants.getImageList().length; i++) {%>
                    <img src="images/<%=variants.getImageList()[i]%>" alt="img<%=i + 1%>">
                    <% }%> 
                </div>

                <div class="thumbnails">
                    <%for (int i = 0; i < variants.getImageList().length; i++) {%>
                    <label for="img<%=i + 1%>"><img src="images/<%=variants.getImageList()[i]%>" alt="thumb<%=i + 1%>"></label>
                        <% }%> 

                </div>

            </div>
            <div class="spec-table">
                <div class="spec-row">
                    <span class="spec-label">DESCRIPTIONS</span>
                    <span class="spec-value"><%=variants.getDescription()%></span>
                </div> 
            </div  >

            <div class="spec-table">
                <div class="spec-row">
                    <span class="spec-label">DESCRIPTIONS</span>
                    <span class="spec-value"><%=variants.getDescription()%></span>
                </div> 
            </div>

            <div class="spec-section">
                <h2>Specifications</h2>

                <div class="spec-table">
                    <div class="spec-row">
                        <span class="spec-label">OS</span>
                        <span class="spec-value"><%=specification.getOs()%></span>
                    </div>
                    <div class="spec-row">
                        <span class="spec-label">CPU</span>
                        <span class="spec-value"><%=specification.getCpu()%></span>
                    </div>
                    <div class="spec-row">
                        <span class="spec-label">GPU</span>
                        <span class="spec-value"><%=specification.getGpu()%></span>
                    </div>
                    <div class="spec-row">
                        <span class="spec-label">RAM</span>
                        <span class="spec-value"><%=specification.getRam()%></span>
                    </div>
                    <div class="spec-row">
                        <span class="spec-label">ROM</span>
                        <span class="spec-value"><%=variants.getStorage()%></span>
                    </div>
                    <div class="spec-row">
                        <span class="spec-label">Battery Capacity</span>
                        <span class="spec-value"><%=specification.getBatteryCapacity()%> mAh</span>
                    </div>
                    <div class="spec-row">
                        <span class="spec-label">Touchscreen</span>
                        <span class="spec-value"><%=specification.getTouchscreen()%></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="product-right">
            <div class="price-box">
                <p>Price</p>
                <h2 id="price"><%= String.format("%,.0f", variants.getDiscountPrice())%> VND</h2>
            </div>

            <% if (!variants.getStorage().equals("N/A")) { %>
            <div class="option-box">
                <p>Version</p>
                <div class="option-list">
                    <% int i = 0;
                        for (String v : listStorage) {
                            String storageId = "storage_" + i;%>
                    <input type="radio" id="<%= storageId%>" name="storage" <%= (variants.getStorage().equals(v)) ? "checked" : ""%> >
                    <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= variants.getColor()%>&storage=<%= v%>&cID=<%= categoryID%>" class="option-label"><%= v%></a>
                    <% i++;
                        } %>
                </div>
            </div>
            <% } %>

            <div class="option-box">
                <p>Color</p>
                <div class="color-list">
                    <% int j = 0;
                        for (Variants v : listVariants) {
                            if (variants.getStorage().equals(v.getStorage())) {
                                String colorId = "color_" + j;
                                if (variants.getColor().equals(v.getColor())) {
                                    currentVariantID = v.getVariantID();
                                }%>
                    <input type="radio" id="<%= colorId%>" name="color" value="<%= v.getColor()%>"<%= (variants.getColor().equals(v.getColor())) ? "checked" : ""%> >
                    <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= v.getColor()%>&storage=<%= variants.getStorage()%>&cID=<%= categoryID%>&vID=<%= v.getVariantID()%>" class="color-label" style="background-color:<%= v.getColor()%>;"></a>
                    <% }
                            j++;
                        }%>
                </div>
            </div>

            <div class="option-box">
                <p>Quantity</p>
                <div class="quantity-selector" data-stock="<%= stock%>">
                    <button type="button" class="quantity-btn minus-btn" aria-label="Decrease quantity">-</button>
                    <input type="text" id="quantity-display" class="quantity-input" value="1" readonly>
                    <button type="button" class="quantity-btn plus-btn" aria-label="Increase quantity">+</button>
                </div>
                <div id="stock-error" class="stock-error">
                    Sorry, you can only buy a maximum of <%= stock%> products.
                </div>
            </div>

            <div class="action-buttons">
                <% if (isLoggedIn) {%>
                <form action="payment" method="get" style="display: inline-block;">
                    <input type="hidden" name="variantID" value="<%= currentVariantID%>">
                    <input type="hidden" name="quantity" class="hiddenQuantityInput" value="1">
                    <input type="hidden" name="action" value="buyNowFromProductDetail">
                    <button type="submit" class="buy-now">BUY NOW</button>
                </form>
                <form action="${pageContext.request.contextPath}/cart" method="post" style="display: inline-block;">
                    <input type="hidden" name="userID" value="<%= userID%>">
                    <input type="hidden" name="variantID" value="<%= currentVariantID%>">
                    <input type="hidden" name="quantity" class="hiddenQuantityInput" value="1">
                    <button type="submit" class="add-cart">Add to cart</button>
                </form>
                <% } else { %>
                <a href="login.jsp" class="buy-now">BUY NOW</a>
                <p class="text-danger fw-bold mt-2">B?n c?n <a href="login.jsp">??ng nh?p</a> ?? thêm vào gi? hàng.</p>
                <% }%>
            </div>
        </div>
    </div>
</section>

<section id="billboard" class="bg-light-blue overflow-hidden padding-large" style="margin-top:-1px;">
    <div class="review-container">
        <h2><%= pdao.getNameByID(variants.getProductID())%> <%= variants.getStorage().equals("N/A") ? "" : variants.getStorage()%></h2>
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
        <!-- Modal -->
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
        <% } %>

        <% for (Variants v : listVariantRating) {
                for (Review r : listReview) {
                    if (v.getVariantID() == r.getVariantID()) {%>
        <div class="user-review">
            <div class="reviewer-info"><span class="name"><%= udao.getUserByID(r.getUserID()).getFullName()%></span></div>
            <div class="review-header">
                <span class="star-rating">
                    <% for (int k = 1; k <= r.getRating(); k++) { %>&#9733;<% }%>
                </span>
                <span class="recommend"></span>
            </div>
            <p class="review-content"><%= r.getComment()%></p>
            <% if (isLoggedIn && userID == r.getUserID()) {%>
            <form action="review?action=deleteReview" method="post">
                <input type="hidden" name="pID" value="<%= productID%>">
                <input type="hidden" name="cID" value="<%= categoryID%>">
                <input type="hidden" name="vID" value="<%= variants.getVariantID()%>">
                <button type="submit" name="rID" value="<%= r.getReviewID()%>" class="delete-review-btn" onclick="return confirm('B?n có ch?c ch?n mu?n xóa bài ?ánh giá này không?');">
                    <span class="delete-icon"><i class="fa-solid fa-trash"></i></span>Delete
                </button>
            </form>
            <% } %>
            <% List<String> listImage = rdao.getImages(r.getImage());
                if (listImage != null && !listImage.isEmpty()) { %>
            <div class="review-images-gallery">
                <% for (String image : listImage) {%>
                <img src="images_review/<%= image%>" alt="<%= image%>" class="review-thumbnail">
                <% } %>
            </div>
            <% } %>
            <% if (r.getReply() != null && !r.getReply().trim().isEmpty()) {%>
            <div class="replies-section">
                <div class="nested-comment">
                    <div class="reviewer-info">
                        <span class="name"></span>
                        <span class="tag seller-tag">MiniStore</span>
                        <span class="tag reply-date"></span>
                    </div>
                    <p class="reply-content"><%= r.getReply()%></p>
                </div>
            </div>
            <% } %>
        </div>
        <% }
                }
            }%>
    </div>
</section>


<footer id="footer" class="overflow-hidden">
    <div class="container">
        <p class="text-center mt-3">© 2025 MiniStore</p>
    </div>
</footer>

<script src="js/jquery-1.11.0.min.js"></script>
<script src="js/bootstrap.bundle.min.js"></script>
<script src="js/script.js"></script>
<script>
                    // Script cho Modal Review
                    const modal = document.getElementById("reviewModal");
                    const openModalBtn = document.getElementById("openReviewModal");
                    const closeBtn = document.getElementsByClassName("close-button")[0];
                    if (openModalBtn) {
                    openModalBtn.onclick = function () {
                    modal.style.display = "block";
                    }
                    }

                    if (closeBtn)
                    {
                    closeBtn.onclick = function () {
                    modal.style.display = "none";
                    }
                    }


                    window.onclick = function (event) {
                    if (event.target == modal) {
                    modal.style.display = "none";
                    }
                    }


                    // Script cho Preview áº£nh
                    var fileInput = document.getElementById('photo-upload-input');
                    var previewContainer = document.getElementById('image-preview-container');
                    const MAX_IMAGES = 3;
                    if (fileInput)
                    {
                    fileInput.addEventListener('change', function () {
                    previewContainer.innerHTML = '';
                    const files = Array.from(fileInput.files).slice(0, MAX_IMAGES);
                    files.forEach(file => {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'preview-thumb';
                    previewContainer.appendChild(img);
                    }
                    reader.readAsDataURL(file);
                    });
                    });
                    }


                    // Script chá»n sá»‘ lÆ°á»£ng
                    const minusBtn = document.querySelector('.minus-btn');
                    const plusBtn = document.querySelector('.plus-btn');
                    const quantityInput = document.querySelector('#quantity-display');
                    const stockError = document.getElementById('stock-error');
                    const stock = parseInt(document.querySelector('.quantity-selector').dataset.stock);
                    const hiddenInputs = document.querySelectorAll('.hiddenQuantityInput');
                    if (minusBtn && plusBtn && quantityInput)
                    {
                    minusBtn.addEventListener('click', function () {
                    let value = parseInt(quantityInput.value);
                    if (value > 1) {
                    value--;
                    quantityInput.value = value;
                    hiddenInputs.forEach(i => i.value = value);
                    stockError.style.display = "none";
                    }
                    });
                    plusBtn.addEventListener('click', function () {
                    let value = parseInt(quantityInput.value);
                    if (value < stock) {
                    value++;
                    quantityInput.value = value;
                    hiddenInputs.forEach(i => i.value = value);
                    stockError.style.display = "none";
                    } else {
                    stockError.style.display = "block";
                    }
                    });
                    }

</script>
<script>
    };
    }

    if (closeBtn) {
    closeBtn.onclick = function () {
    modal.style.display = "none";
    };
    }

    window.onclick = function (event) {
    if (event.target == modal) {
    modal.style.display = "none";
    }
    }

    // Script cho Preview ?nh (?ã s?a l?i)
    var fileInput = document.getElementById('photo-upload-input');
    var previewContainer = document.getElementById('image-preview-container');
    const MAX_IMAGES = 3;
    if (fileInput) {
    fileInput.addEventListener('change', function () {
    previewContainer.innerHTML = ''; // Xóa preview c?

    const allFiles = Array.from(fileInput.files);
    let filesToProcess = allFiles;
// 1. Ki?m tra s? l??ng ?nh
    if (allFiles.length > MAX_IMAGES) {
// 1.1 Thông báo cho ng??i dùng
    alert('ban chi duoc chon toi da ' + MAX_IMAGES + ' anh.');
// 1.2 C?t m?ng ?? ch? l?y 3 file ??u tiên
    filesToProcess = allFiles.slice(0, MAX_IMAGES);
// 1.3 (R?t quan tr?ng) C?p nh?t l?i fileInput ?? nó ch? ch?a 3 file
// Cái này ?? ??m b?o form submit ?i c?ng ch? có 3 file
    const dataTransfer = new DataTransfer();
    filesToProcess.forEach(file => {
    dataTransfer.items.add(file);
    });
    fileInput.files = dataTransfer.files;
    }

// 2. Hi?n th? 3 ?nh (ho?c ít h?n) ra preview
    filesToProcess.forEach(file => {
    const reader = new FileReader();
    reader.onload = function (e) {
    const img = document.createElement('img');
    img.src = e.target.result;
// Dâu th?y file CSS c?a ??i ca dùng class 'review-thumbnail'
// Dùng class này ?nh s? ??p và ??ng b? h?n là 'preview-thumb' ?
    img.className = 'review-thumbnail'; // S?a class cho ??p

    previewContainer.appendChild(img);
    }
    reader.readAsDataURL(file);
    });
    });
    }

    // Script ch?n s? l??ng
    const minusBtn = document.querySelector('.minus-btn');
    const plusBtn = document.querySelector('.plus-btn');
    const quantityInput = document.querySelector('#quantity-display');
    const stockError = document.getElementById('stock-error');
    const stock = parseInt(document.querySelector('.quantity-selector').dataset.stock);
    const hiddenInputs = document.querySelectorAll('.hiddenQuantityInput');
    if (minusBtn && plusBtn && quantityInput) {
    minusBtn.addEventListener('click', function () {
    let value = parseInt(quantityInput.value);
    if (value > 1) {
    value--;
    quantityInput.value = value;
    hiddenInputs.forEach(i => i.value = value);
    stockError.style.display = "none";
    }
    });
    plusBtn.addEventListener('click', function () {
    let value = parseInt(quantityInput.value);
    if (value < stock) {
    value++;
    quantityInput.value = value;
    hiddenInputs.forEach(i => i.value = value);
    stockError.style.display = "none";
    } else {
    stockError.style.display = "block";
    }
    });
    }
</script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
    const starContainer = document.getElementById('star-rating-js');
    if (starContainer) {
    const starOptions = starContainer.querySelectorAll('.star-option');
    const radioInputs = starContainer.querySelectorAll('input[type="radio"]');
    // Hàm ?? c?p nh?t class 'selected' cho các sao
    function updateSelectedStars(selectedValue) {
    starOptions.forEach(option => {
    const ratingValue = option.dataset.ratingValue;
    if (ratingValue <= selectedValue) {
    option.classList.add('selected');
    } else {
    option.classList.remove('selected');
    }
    });
    }

    // 1. X? lý khi CLICK vào m?t sao
    starOptions.forEach(option => {
    option.addEventListener('click', function () {
    const selectedValue = this.dataset.ratingValue;
    // C?p nh?t radio input (?? form submit)
    this.querySelector('input[type="radio"]').checked = true;
    // C?p nh?t giao di?n (thêm class 'selected')
    updateSelectedStars(selectedValue);
    });
    });
    // 2. X? lý khi R?I CHU?T kh?i khu v?c ch?n sao
    starContainer.addEventListener('mouseleave', function () {
    // Ki?m tra xem ?ã có sao nào ???c "checked" (?ã ch?n) ch?a
    let checkedValue = 0;
    radioInputs.forEach(radio => {
    if (radio.checked) {
    checkedValue = radio.value;
    }
    });
    // Ph?c h?i l?i tr?ng thái "selected" theo sao ?ã "checked"
    // (Vi?c này ?? h?y hi?u ?ng hover và ch? gi? l?i sao ?ã ch?n)
    updateSelectedStars(checkedValue);
    });
    }
    });
</script>

</body>
</html>

