<%@page import="java.util.ArrayList"%>
<%@page import="model.Promotions"%>
<%@page import="dao.PromotionsDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.ReviewDAO"%>
<%@page import="dao.VariantsDAO"%>
<%@page import="model.Review"%>
<%@page import="model.Variants"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/layout/header.jsp" %>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🔥 Hot Deals - Huge Discounts</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Hero Section với Animation */
        .hero-section {
            position: relative;
            padding: 80px 0 60px;
            overflow: hidden;
        }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: 4.5rem;
            font-weight: 900;
            background: linear-gradient(45deg, #FFD700, #FFA500, #FF6347, #FFD700);
            background-size: 300% 300%;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: gradientShift 3s ease infinite;
            text-shadow: 0 0 30px rgba(255, 215, 0, 0.5);
            letter-spacing: 2px;
        }

        @keyframes gradientShift {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .hero-subtitle {
            font-size: 1.5rem;
            color: #fff;
            margin-top: 20px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Sparkle Icon Animation */
        .sparkle-icon {
            display: inline-block;
            font-size: 3rem;
            color: #FFD700;
            animation: sparkle 1.5s ease-in-out infinite;
            filter: drop-shadow(0 0 10px #FFD700);
        }

        @keyframes sparkle {
            0%, 100% {
                transform: scale(1) rotate(0deg);
                opacity: 1;
            }
            25% {
                transform: scale(1.3) rotate(90deg);
                opacity: 0.8;
            }
            50% {
                transform: scale(1) rotate(180deg);
                opacity: 1;
            }
            75% {
                transform: scale(1.3) rotate(270deg);
                opacity: 0.8;
            }
        }

        /* Floating Animation cho decorative elements */
        .floating {
            animation: floating 3s ease-in-out infinite;
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        /* Horizontal Scrolling Container */
        .scroll-container {
            position: relative;
            width: 100%;
            overflow: hidden;
            padding: 40px 0;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 30px;
            margin: 40px 0;
        }

        .scroll-wrapper {
            display: flex;
            animation: scroll 60s linear infinite;
            width: fit-content;
        }

        .scroll-wrapper:hover {
            animation-play-state: paused;
        }

        @keyframes scroll {
            0% {
                transform: translateX(0);
            }
            100% {
                transform: translateX(-50%);
            }
        }

        /* Product Card Luxury Design */
        .product-card {
            min-width: 320px;
            margin: 0 15px;
            background: linear-gradient(145deg, #ffffff, #f0f0f0);
            border-radius: 25px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            border: 3px solid transparent;
        }

        .product-card:hover {
            transform: translateY(-15px) scale(1.05);
            box-shadow: 0 30px 80px rgba(138, 43, 226, 0.5);
            border-color: #FFD700;
        }

        .product-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 215, 0, 0.1), transparent);
            transform: rotate(45deg);
            transition: all 0.6s;
        }

        .product-card:hover::before {
            left: 100%;
        }

        /* Discount Badge - Lấp lánh */
        .discount-badge {
            position: absolute;
            top: 20px;
            left: -10px;
            background: linear-gradient(135deg, #FF6B6B, #FF0000);
            color: white;
            padding: 12px 25px 12px 20px;
            font-weight: 800;
            font-size: 1.2rem;
            clip-path: polygon(0 0, 100% 0, 90% 50%, 100% 100%, 0 100%);
            box-shadow: 0 5px 15px rgba(255, 0, 0, 0.5);
            z-index: 10;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                box-shadow: 0 5px 15px rgba(255, 0, 0, 0.5);
            }
            50% {
                transform: scale(1.1);
                box-shadow: 0 8px 25px rgba(255, 215, 0, 0.8);
            }
        }

        /* Image Container */
        .image-container {
            position: relative;
            width: 100%;
            height: 280px;
            overflow: hidden;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
        }

        .image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.7s ease;
        }

        .product-card:hover .image-container img {
            transform: scale(1.15) rotate(3deg);
        }

        /* Product Info */
        .product-info {
            padding: 25px;
            background: white;
        }

        .product-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2563eb;
            margin-bottom: 15px;
            line-height: 1.4;
            height: 60px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .price-container {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .discount-price {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, #8B5CF6, #6D28D9);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .original-price {
            font-size: 1.1rem;
            color: #9CA3AF;
            text-decoration: line-through;
        }

        /* Storage Tag */
        .storage-tag {
            display: inline-block;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 15px;
        }

        /* Rating */
        .rating-container {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 10px;
        }

        .star-icon {
            color: #FFD700;
            font-size: 1.2rem;
        }

        .rating-text {
            font-weight: 600;
            color: #1F2937;
            font-size: 1.1rem;
        }

        /* View Detail Button */
        .view-btn {
            display: inline-block;
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            text-align: center;
            border-radius: 15px;
            font-weight: 700;
            font-size: 1.1rem;
            text-decoration: none;
            transition: all 0.4s;
            margin-top: 15px;
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }

        .view-btn:hover {
            background: linear-gradient(135deg, #764ba2, #667eea);
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.6);
        }

        /* Countdown Timer */
        .countdown-timer {
            background: linear-gradient(135deg, #FF6B6B, #FF0000);
            color: white;
            padding: 20px;
            border-radius: 20px;
            text-align: center;
            margin: 40px auto;
            max-width: 600px;
            box-shadow: 0 10px 30px rgba(255, 0, 0, 0.4);
        }

        .timer-display {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 15px;
        }

        .timer-unit {
            background: rgba(255, 255, 255, 0.2);
            padding: 15px 25px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }

        .timer-unit span {
            display: block;
            font-size: 2.5rem;
            font-weight: 800;
        }

        .timer-unit small {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        /* Decorative Elements - Geometric Shapes */
        .deco-circle {
            position: absolute;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
            backdrop-filter: blur(10px);
            animation: float 8s ease-in-out infinite;
        }

        .deco-square {
            position: absolute;
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 165, 0, 0.1));
            backdrop-filter: blur(5px);
            animation: rotate3d 10s linear infinite;
        }

        .deco-triangle {
            position: absolute;
            width: 0;
            height: 0;
            border-left: 50px solid transparent;
            border-right: 50px solid transparent;
            border-bottom: 86px solid rgba(138, 43, 226, 0.1);
            animation: float 6s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px) translateX(0px);
                opacity: 0.3;
            }
            25% {
                transform: translateY(-30px) translateX(20px);
                opacity: 0.6;
            }
            50% {
                transform: translateY(-50px) translateX(-20px);
                opacity: 0.8;
            }
            75% {
                transform: translateY(-30px) translateX(-40px);
                opacity: 0.5;
            }
        }

        @keyframes rotate3d {
            0% {
                transform: rotate(0deg) scale(1);
                opacity: 0.2;
            }
            50% {
                transform: rotate(180deg) scale(1.2);
                opacity: 0.5;
            }
            100% {
                transform: rotate(360deg) scale(1);
                opacity: 0.2;
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            .hero-subtitle {
                font-size: 1.1rem;
            }
            .product-card {
                min-width: 280px;
            }
        }
    </style>
</head>

<body>
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container mx-auto px-4 text-center">
            
            <h1 class="hero-title">HOT DEALS</h1>
            <p class="hero-subtitle">🔥 Massive Discounts - Don't Miss Out! 🔥</p>
            
            <!-- Decorative Geometric Shapes -->
            <div class="deco-circle" style="top: 5%; left: 8%; width: 120px; height: 120px;"></div>
            <div class="deco-circle" style="top: 10%; right: 10%; width: 80px; height: 80px;"></div>
            <div class="deco-square" style="top: 15%; left: 20%; width: 60px; height: 60px; transform: rotate(45deg);"></div>
            <div class="deco-square" style="bottom: 25%; right: 15%; width: 90px; height: 90px; transform: rotate(25deg);"></div>
            <div class="deco-triangle" style="bottom: 20%; left: 15%;"></div>
            <div class="deco-circle" style="bottom: 15%; right: 25%; width: 100px; height: 100px;"></div>
        </div>

        <!-- Countdown Timer -->
        <div class="countdown-timer">
            <h3 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 10px;">⏰ Deal ends in:</h3>
            <div class="timer-display">
                <div class="timer-unit">
                    <span id="days">00</span>
                    <small>Days</small>
                </div>
                <div class="timer-unit">
                    <span id="hours">00</span>
                    <small>Hours</small>
                </div>
                <div class="timer-unit">
                    <span id="minutes">00</span>
                    <small>Mins</small>
                </div>
                <div class="timer-unit">
                    <span id="seconds">00</span>
                    <small>Secs</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Horizontal Scrolling Products -->
    <div class="scroll-container" style="margin-top:-30px;">
        <div class="scroll-wrapper">
            <%
                // Lấy dữ liệu từ request
                List<Products> listProduct = (List<Products>) request.getAttribute("listProduct");
                List<Variants> listVariant = (List<Variants>) request.getAttribute("listVariant");
                List<Promotions> promotionsList = (List<Promotions>) request.getAttribute("promotionsList");
                
                ReviewDAO rDAO = new ReviewDAO();
                PromotionsDAO prDAO = new PromotionsDAO();
                NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                
                // Lấy thời gian hiện tại
                LocalDateTime currentTime = LocalDateTime.now();
                
                // Tìm ngày kết thúc xa nhất từ các promotion còn hạn
                LocalDateTime furthestEndDate = null;
                if (promotionsList != null && !promotionsList.isEmpty()) {
                    for (Promotions promotion : promotionsList) {
                        if ("active".equalsIgnoreCase(promotion.getStatus()) 
                            && promotion.getEndDate() != null 
                            && promotion.getEndDate().isAfter(currentTime)) {
                            
                            if (furthestEndDate == null || promotion.getEndDate().isAfter(furthestEndDate)) {
                                furthestEndDate = promotion.getEndDate();
                            }
                        }
                    }
                }
                
                // Chuyển endDate sang milliseconds để JavaScript xử lý
                long endTimeMillis = 0;
                if (furthestEndDate != null) {
                    java.time.ZoneId vnZone = java.time.ZoneId.of("Asia/Ho_Chi_Minh");
                    endTimeMillis = furthestEndDate.atZone(vnZone).toInstant().toEpochMilli();
                }
                
                // Lọc sản phẩm có khuyến mãi active VÀ còn hạn
                List<Variants> promotionVariants = new ArrayList<>();
                if (promotionsList != null && listVariant != null) {
                    for (Variants v : listVariant) {
                        for (Promotions promotion : promotionsList) {
                            // Kiểm tra cả status active VÀ endDate còn hạn
                            if (v.getProductID() == promotion.getProductID() 
                                && "active".equalsIgnoreCase(promotion.getStatus())
                                && promotion.getEndDate() != null
                                && promotion.getEndDate().isAfter(currentTime)) {
                                
                                promotionVariants.add(v);
                                break;
                            }
                        }
                    }
                }
                
                // Nhân đôi danh sách để tạo hiệu ứng scroll liên tục
                List<Variants> doubledList = new ArrayList<>();
                doubledList.addAll(promotionVariants);
                doubledList.addAll(promotionVariants);
                
                if (!doubledList.isEmpty() && listProduct != null) {
                    for (Variants v : doubledList) {
                        String pName = "";
                        for (Products p : listProduct) {
                            if (p.getProductID() == v.getProductID()) {
                                pName = p.getName();
                                break;
                            }
                        }
                        
                        Promotions pr = prDAO.getPromotionByProductID(v.getProductID());
                        List<Review> listReview = rDAO.getReviewsByVariantID(v.getVariantID());
                        
                        double rating = 0;
                        if (listReview != null && !listReview.isEmpty()) {
                            for (Review r : listReview) {
                                rating += r.getRating();
                            }
                            rating = rating / listReview.size();
                        }
            %>
            
            <!-- Product Card -->
            <a href="product?action=viewDetail&vID=<%= v.getVariantID() %>&pID=<%= v.getProductID() %>" style="text-decoration: none; color: inherit;">
                <div class="product-card">
                    <!-- Discount Badge -->
                    <% if (pr != null && pr.getDiscountPercent() > 0) { %>
                    <div class="discount-badge">
                        -<%= pr.getDiscountPercent() %>%
                    </div>
                    <% } %>
                    
                    <!-- Image -->
                    <div class="image-container">
                        <img src="images/<%= v.getImageList()[0] %>" alt="<%= pName %>">
                    </div>
                    
                    <!-- Product Info -->
                    <div class="product-info">
                        <h3 class="product-name">
                            <%= pName %> <%= v.getStorage() %> <%= v.getColor() %>
                        </h3>
                        
                        <div class="storage-tag">
                            <%= v.getStorage() %>
                        </div>
                        
                        <div class="price-container">
                            <span class="discount-price">
                                <%= vnFormat.format(v.getDiscountPrice()) %>
                            </span>
                            <% if (v.getPrice() > v.getDiscountPrice()) { %>
                            <span class="original-price">
                                <%= vnFormat.format(v.getPrice()) %>
                            </span>
                            <% } %>
                        </div>
                        
                        <% if (rating > 0) { %>
                        <div class="rating-container">
                            <i class="fas fa-star star-icon"></i>
                            <span class="rating-text"><%= String.format("%.1f", rating) %></span>
                        </div>
                        <% } else { %>
                        <div class="rating-container">
                            <span style="color: #9CA3AF; font-size: 0.9rem;">No reviews yet</span>
                        </div>
                        <% } %>
                        
                        <div class="view-btn">
                            <i class="fas fa-shopping-cart"></i> View Details
                        </div>
                    </div>
                </div>
            </a>
            
            <%
                    }
                } else {
            %>
            <div style="width: 100%; text-align: center; padding: 60px; color: white;">
                <i class="fas fa-inbox" style="font-size: 4rem; margin-bottom: 20px; opacity: 0.5;"></i>
                <h3 style="font-size: 1.8rem; font-weight: 700;">No active promotions</h3>
                <p style="margin-top: 10px; opacity: 0.8;">All deals have expired. Please check back later!</p>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <!-- JavaScript for Countdown Timer -->
    <script>
        // Lấy thời gian kết thúc từ JSP
        const endTimeMillis = <%= endTimeMillis %>;
        
        function startCountdown() {
            const daysEl = document.getElementById('days');
            const hoursEl = document.getElementById('hours');
            const minutesEl = document.getElementById('minutes');
            const secondsEl = document.getElementById('seconds');
            
            function updateTimer() {
                const now = new Date().getTime();
                const distance = endTimeMillis - now;
                
                if (distance <= 0) {
                    daysEl.textContent = '00';
                    hoursEl.textContent = '00';
                    minutesEl.textContent = '00';
                    secondsEl.textContent = '00';
                    
                    // Tự động reload trang khi hết giờ để cập nhật danh sách
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                    return;
                }
                
                const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                
                daysEl.textContent = days.toString().padStart(2, '0');
                hoursEl.textContent = hours.toString().padStart(2, '0');
                minutesEl.textContent = minutes.toString().padStart(2, '0');
                secondsEl.textContent = seconds.toString().padStart(2, '0');
            }
            
            // Cập nhật ngay lập tức
            updateTimer();
            
            // Sau đó cập nhật mỗi giây
            setInterval(updateTimer, 1000);
        }
        
        // Chỉ chạy countdown nếu có endTime hợp lệ
        if (endTimeMillis > 0) {
            startCountdown();
        } else {
            // Nếu không có endDate, hiển thị "Coming Soon"
            document.getElementById('days').textContent = '--';
            document.getElementById('hours').textContent = '--';
            document.getElementById('minutes').textContent = '--';
            document.getElementById('seconds').textContent = '--';
        }
    </script>
</body>
</html>