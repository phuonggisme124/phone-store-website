<%@page import="dao.UsersDAO"%>
<%@page import="model.Review"%>
<%@page import="dao.ReviewDAO"%>
<%@page import="model.Category"%>
<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product Detail</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="format-detection" content="telephone=no">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="author" content="">
        <meta name="keywords" content="">
        <meta name="description" content="">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css" />
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="css/product_detail.css">
        <link rel="stylesheet" href="css/gallery.css">
        <link rel="stylesheet" href="css/select_product.css">
        <link rel="stylesheet" href="css/customer_review.css">
        <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
        <script src="js/modernizr.js"></script>
        </head>

    <body data-bs-spy="scroll" data-bs-target="#navbar" tabindex="0">

        <%
            // L?y d? li?u t? request/session
            ProductDAO pdao = new ProductDAO();
            ReviewDAO rdao = new ReviewDAO();
            UsersDAO udao = new UsersDAO();

            int productID = (int) request.getAttribute("productID");
            int categoryID = (int) request.getAttribute("categoryID");
            double rating = (Double) request.getAttribute("rating"); // C?n ki?m tra null c?n th?n
            Variants variants = (Variants) request.getAttribute("variants");
            int currentVariantID = variants.getVariantID();
            List<Variants> listVariants = (List<Variants>) request.getAttribute("listVariants");
            List<Variants> listVariantRating = (List<Variants>) request.getAttribute("listVariantRating");
            List<Review> listReview = (List<Review>) request.getAttribute("listReview");
            List<String> listStorage = (List<String>) request.getAttribute("listStorage");
            List<Category> listCategory = (List<Category>) request.getAttribute("listCategory");
            
            // Th?ng tin ng??i d?ng
            model.Users user = (model.Users) session.getAttribute("user");
            boolean isLoggedIn = (user != null);
            String displayName = "";
            int userID = 0;
            if (isLoggedIn) {
                userID = user.getUserId();
                displayName = (user.getFullName() != null && !user.getFullName().trim().isEmpty())
                        ? user.getFullName() : user.getEmail();
            }
        %>
        
        <header id="header" class="site-header header-scrolled position-fixed text-black bg-light">
            <nav id="header-nav" class="navbar navbar-expand-lg px-3 mb-3">
                <div class="container-fluid">
                    <a class="navbar-brand" href="index.html">
                        <img src="images/main-logo.png" class="logo">
                    </a>

                    <div class="offcanvas-body">
                        <ul id="navbar" class="navbar-nav text-uppercase justify-content-end align-items-center flex-grow-1 pe-3">
                            <li class="nav-item">
                                <a class="nav-link me-4" href="homepage">Home</a>
                            </li>

                            <%
                                for (Category c : listCategory) {
                            %>
                            <li class="nav-item">
                                <a class="nav-link me-4 <%= (categoryID == c.getCategoryId() ? "active" : "")%>"
                                   href="product?action=category&cID=<%= c.getCategoryId()%>"><%= c.getCategoryName()%></a>
                            </li>
                            <% } %>

                            <li class="nav-item">
                                <div class="user-items ps-5">
                                    <ul class="d-flex justify-content-end list-unstyled align-items-center">
                                        <% if (isLoggedIn) { %>
                                        <li class="pe-3"><a href="cart.html"><svg class="cart"><use xlink:href="#cart"></use></svg></a></li>
                                        <li class="pe-3"><a href="logout" class="nav-link p-0 text-dark fw-bold">Logout</a></li>
                                        <li class="text-dark fw-bold"><%= displayName%></li>
                                            <% } else { %>
                                        <li class="pe-3"><a href="login.jsp" class="nav-link p-0 text-dark fw-bold">Login/Register</a></li>
                                        <li class="text-dark fw-bold">Hello Guest</li>
                                            <% } %>
                                    </ul>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>

        <section id="billboard" class="bg-light-blue overflow-hidden mt-5 padding-large">
            <div class="container">
                <h3><%= pdao.getNameByID(variants.getProductID())%></h3>
            </div>

            <div class="product-container">
                <div class="product-left">
                    <div class="gallery">
                        <input type="radio" name="gallery" id="img1" checked>
                        <input type="radio" name="gallery" id="img2">
                        <input type="radio" name="gallery" id="img3">
                        <input type="radio" name="gallery" id="img4">

                        <div class="main-image">
                            <img src="images/post-item1.jpg" alt="img1"><img src="images/post-item2.jpg" alt="img2">
                            <img src="images/post-item3.jpg" alt="img3">
                            <img src="images/post-item4.jpg" alt="img4">
                        </div>

                        <div class="thumbnails">
                            <label for="img1"><img src="images/post-item1.jpg" alt="thumb1"></label>
                            <label for="img2"><img src="images/post-item2.jpg" alt="thumb2"></label>
                            <label for="img3"><img src="images/post-item3.jpg" alt="thumb3"></label>
                            <label for="img4"><img src="images/post-item4.jpg" alt="thumb4"></label>
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
                            <%
                                int i = 0;
                                for (String v : listStorage) {
                                    String storageId = "storage_" + i;
                            %>
                            <input type="radio" id="<%= storageId%>" name="storage"
                                   <%= (variants.getStorage().equals(v)) ? "checked" : ""%> >
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= variants.getColor()%>&storage=<%= v%>&cID=<%= categoryID%>"
                               class="option-label"><%= v%></a>
                            <% i++;
                                } %>
                        </div>
                    </div>
                    <% } %>

                    <div class="option-box">
                        <p>Color</p>
                        <div class="color-list">
                            <%
                                int j = 0;
                                for (Variants v : listVariants) {
                                    if (variants.getStorage().equals(v.getStorage())) {
                                        String colorId = "color_" + j;
                                        // C?p nh?t variantID khi ch?n mu
                                        if(variants.getColor().equals(v.getColor())){
                                            currentVariantID = v.getVariantID();
                                        }
                            %>
                            <input type="radio" id="<%= colorId%>" name="color"
                                   value="<%= v.getColor()%>"<%= (variants.getColor().equals(v.getColor())) ? "checked" : ""%> >
                            <a href="product?action=selectStorage&pID=<%= variants.getProductID()%>&color=<%= v.getColor()%>&storage=<%= variants.getStorage()%>&cID=<%= categoryID%>&vID=<%= v.getVariantID()%>"
                               class="color-label"
                               style="background-color:<%= v.getColor()%>;"></a>
                            <% }
                                    j++;
                                }%>
                        </div>
                    </div>

                    <div>
                        <p>Quantity</p>
                        <input type="number" name="quantity" id="quantity" value="1" min="1" max="99" required>
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

                        <script>
                            // T?i t?o script c?p nh?t s? l??ng
                            const qtyInput = document.getElementById('quantity');
                            const hiddenQtyFields = document.querySelectorAll('.hiddenQuantityInput');
                            if(qtyInput && hiddenQtyFields.length > 0) {
                                qtyInput.addEventListener('input', () => {
                                    hiddenQtyFields.forEach(field => {
                                        // ??m b?o s? l??ng lu?n l s? nguy?n d??ng
                                        let val = parseInt(qtyInput.value);
                                        if (isNaN(val) || val < 1) val = 1;
                                        field.value = val;
                                    });
                                });
                            }
                        </script>

                        <% } else { %>
                        <a href="login.jsp" class="buy-now">BUY NOW</a>
                        <p class="text-danger fw-bold mt-2">Bạn cần <a href="login.jsp">đăng nhập</a> để thêm vào giỏ hàng.</p>
                        <% }%>
                    </div>
                </div>
            </div>
        </section>
        
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
                <%
                    for (int k = 5; k > 0; k--) {
                        double percentRating = rdao.getPercentRating(listVariantRating, listReview, k);
                %>
                <div class="star-row">
                    <span class="star-level"><%= k%>&#9733;</span>
                    <div class="progress-bar-wrap">
                        <div class="progress-bar" style="width: <%= percentRating%>%"></div>
                    </div>
                    <span class="percentage"><%= String.format("%.0f", percentRating)%>&#37;</span>
                </div>
                <%
                    }
                %>
            </div>
            
            <%
                if (isLoggedIn) {
            %>
            <button id="openReviewModal" class="write-review-button" type="button">
                Write Review
            </button>

            <div id="reviewModal" class="modal">

                <div class="modal-content">
                    <span class="close-button">&times;</span>

                    <form class="review-form-container" action="review" method="POST" enctype="multipart/form-data">
                        
                        <div class="product-header">
                            <input type="hidden" name="vID" value="<%= currentVariantID%>">
                            <img src="images/post-item1.jpg" alt="<%= pdao.getNameByID(productID)%> <%= variants.getStorage()%>" class="product-image">
                            <h2 class="product-title"><%= pdao.getNameByID(productID)%> <%= variants.getStorage().equals("N/A") ? "" : variants.getStorage()%></h2>
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
                            <%
                                }
                            %>
                        </div>

                        <textarea name="comment" class="comment-textarea" 
                                  placeholder="Please share your thoughts..." rows="5" required></textarea>

                        <div class="options-row">
                            <span class="photo-upload">
                                <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display: none;">
                                <label for="photo-upload-input" class="photo-upload-label">
                                    <span class="camera-icon">&#128247;</span> Send photos (up to 3 photos)
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
            <%
                }
            %>
            
            <%
                for (Variants v : listVariantRating) {
                    for (Review r : listReview) {
                        if (v.getVariantID() == r.getVariantID()) {
            %>
            <div class="user-review">
                <div class="reviewer-info">
                    <span class="name"><%= udao.getUserByID(r.getUserID()).getFullName()%></span>
                </div>
                <div class="review-header">
                    <span class="star-rating">
                        <%
                            for (int k = 1; k <= r.getRating(); k++) {
                        %>
                        &#9733;
                        <%
                            }
                        %>
                    </span> <span class="recommend"></span>
                </div>
                <p class="review-content"><%= r.getComment()%></p>
                <%
                    if (isLoggedIn && userID == r.getUserID()) {
                %>
                <form action="review?action=deleteReview" method="post">
                    <input type="hidden" name="pID" value="<%= productID%>">
                    <input type="hidden" name="cID" value="<%= categoryID%>">
                    <button type="submit" name="rID" value="<%= r.getReviewID() %>" class="delete-review-btn" onclick="return confirm('??i ca c? ch?c ch?n mu?n xa bi ?nh gi ny kh?ng?');">
                        <span class="delete-icon"><i class="fa-solid fa-trash"></i></span>Delete
                    </button>
                </form>

                <%
                    }
                %>
                <%
                    List<String> listImage = rdao.getImages(r.getImage());
                    if (listImage != null && !listImage.isEmpty()) {
                %>
                <div class="review-images-gallery">
                    <%
                        for (String image : listImage) {
                    %>
                    <img src="images_review/<%= image%>" 
                         alt="Review Image" 
                         class="review-thumbnail" 
                         >
                    <%
                        }
                    %>
                </div>
                <%
                    }
                %>
                <%
                    if (r.getReply() != null && !r.getReply().trim().isEmpty()) {
                %>
                <div class="replies-section">
                    <div class="nested-comment">
                        <div class="reviewer-info">
                            <span class="name"></span>
                            <span class="tag seller-tag">MiniStore</span>
                            <span class="tag reply-date"></span> </div>
                        <p class="reply-content">
                            <%= r.getReply()%>
                        </p>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
            <%
                        }
                    }
                }
            %>
        </div>

        <footer id="footer" class="overflow-hidden">
            <div class="container">
                <p class="text-center mt-3">© 2023 MiniStore. Design by TemplatesJungle</p>
            </div>
            </footer>
        

        <script src="js/jquery-1.11.0.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="js/script.js"></script>
        <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
        <script>
            // Script cho Modal Review
            const modal = document.getElementById("reviewModal");
            const openModalBtn = document.getElementById("openReviewModal");
            const closeBtn = document.getElementsByClassName("close-button")[0];

            if (openModalBtn) {
                openModalBtn.onclick = function() {
                    modal.style.display = "block";
                }
            }

            if (closeBtn) {
                closeBtn.onclick = function() {
                    modal.style.display = "none";
                }
            }

            window.onclick = function(event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
            
            // X? l ?nh Preview trong Review
            var fileInput = document.getElementById('photo-upload-input');
            var previewContainer = document.getElementById('image-preview-container');
            const MAX_IMAGES = 3;

            if (fileInput) {
                fileInput.addEventListener('change', function () {
                    previewContainer.innerHTML = '';
                    const files = fileInput.files;

                    for (let i = 0; i < files.length && i < MAX_IMAGES; i++) {
                        const file = files[i];

                        if (file.type.startsWith('image/')) {
                            const reader = new FileReader();

                            reader.onload = function (e) {
                                const img = document.createElement('img');
                                img.src = e.target.result;
                                img.alt = 'Ảnh thực tế sản phẩm';
                                previewContainer.appendChild(img);
                            };
                            reader.readAsDataURL(file);
                        }
                    }
                });
            }
            
            // X? l Star Rating trong Review Modal (T?i ?u giao di?n ch?n sao)
            const starOptions = document.querySelectorAll('#star-rating-js .star-option');
            starOptions.forEach(option => {
                option.addEventListener('click', function() {
                    const ratingValue = parseInt(this.getAttribute('data-rating-value'));
                    starOptions.forEach(opt => {
                        const optValue = parseInt(opt.getAttribute('data-rating-value'));
                        if (optValue <= ratingValue) {
                            opt.classList.add('selected');
                        } else {
                            opt.classList.remove('selected');
                        }
                    });
                });
            });

        </script>
    </body>
</html>