<%@page import="model.InterestRate"%>
<%@page import="dao.InterestRateDAO"%>
<%@page import="dao.InstallmentDetailDAO"%>
<%@page import="model.InstallmentDetail"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Map"%>
<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<%@ include file="/layout/header.jsp" %>

<%
    InterestRateDAO irDAO = new InterestRateDAO();
%>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/instalment.css">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="css/profile.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    </head>
    <body>
        <section id="billboard" class="bg-light-blue overflow-hidden padding-large" style="margin-top: -60px;">
            <div class="profile-container">
                <div class="profile-wrapper">
                    <%@ include file="sidebar.jsp" %>

                    <main class="profile-content">
                        <div class="profile-header">
                            <h1>Quản Lý Trả Góp</h1>

                            <%
                                List<Order> oList = (List<Order>) request.getAttribute("oList");
                                Map<Integer, List<InstallmentDetail>> allPayments = (Map<Integer, List<InstallmentDetail>>) request.getAttribute("allPayments");
                                NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                            %>

                            <div class="installment-list">
                                <% if (oList != null && !oList.isEmpty()) {
                                        for (int i = oList.size() - 1; i >= 0; i--) {
                                            Order o = oList.get(i);
                                            List<InstallmentDetail> pList = allPayments.get(o.getOrderID());
                                            int paidCount = 0;

                                            if (pList != null) {
                                                for (InstallmentDetail p : pList) {
                                                    if ("Paid".equalsIgnoreCase(p.getPaymentStatus())) {
                                                        paidCount++;
                                                    }
                                                }
                                            }
                                            String cardClass = "installment-card";
                                %>


                                <div class="<%= cardClass%>">
                                    <div class="card-header">
                                        <div class="product-info">
                                            <h4>Đơn hàng #<%= o.getOrderID()%></h4>
                                            <p>Ngày tạo: <%= o.getOrderDate()%></p>
                                        </div>
                                        <div class="plan-summary">
                                            <h4>Đã trả <%= paidCount%> / <%= (pList != null ? pList.size() : 0)%> tháng</h4>
                                            <%-- ICON TRẠNG THÁI --%>
                                            <div class="status-badge <%= (paidCount == (pList != null ? pList.size() : 0)) ? "status-done" : "status-ongoing"%>">
                                                <% if (paidCount == (pList != null ? pList.size() : 0)) { %>
                                                <i class="fas fa-check-circle"></i> Hoàn tất
                                                <% } else { %>
                                                <i class="fas fa-hourglass-half"></i> Đang trả góp
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>

                                    <% if (pList != null && !pList.isEmpty()) { %>
                                    <div class="card-details-wrapper">
                                        <h5>Lịch sử thanh toán</h5>
                                        <div class="payment-schedule">
                                            <% for (InstallmentDetail p : pList) {%>
                                            <div class="payment-item <%= p.getPaymentStatus().equalsIgnoreCase("Paid") ? "paid" : "unpaid"%>">
                                                <div class="payment-period">Kỳ <%= p.getCurrentMonth()%></div>
                                                
                                                <div class="payment-date">
                                                    <%= p.getPaymentDate() != null ? p.getPaymentDate() : "-"%>
                                                    <% if (p.getExpriedDay() > 0 && !"Paid".equalsIgnoreCase(p.getPaymentStatus())) { %>
                                                        <br><span style="color: red; font-size: 0.8rem; font-weight: bold;">(Trễ <%= p.getExpriedDay() %> ngày)</span>
                                                    <% } %>
                                                </div>
                                                
                                                <div class="payment-amount">
                                                    <% 
                                                        // Nếu có ngày trễ và chưa trả -> Tính tách lãi và gốc
                                                        if (p.getExpriedDay() > 0 && !"Paid".equalsIgnoreCase(p.getPaymentStatus())) {
                                                            try {
                                                                InterestRate ir = irDAO.getInterestRatePercentByIstalmentPeriod(p.getTotalMonth());
                                                                double percent = ir.getPercentExpried(); 
                                                                int days = p.getExpriedDay();
                                                                double currentTotal = p.getAmount(); 
                                       
                                                                
                                                                double originalPrice = currentTotal / (1.0 + ((percent * days) / 10.0));
                                                                double penaltyPrice = currentTotal - originalPrice;
                                                    %>
                                                        <div style="display: flex; flex-direction: column; align-items: flex-end;">
                                                            <span style="text-decoration: line-through; color: #888; font-size: 0.85em;">
                                                                Gốc: <%= vnFormat.format(originalPrice) %>
                                                            </span>
                                                            <span style="color: #dc3545; font-size: 0.85em;">
                                                                Lãi phạt: +<%= vnFormat.format(penaltyPrice) %>
                                                            </span>
                                                            <strong style="color: #d63384; font-size: 1.1em;">
                                                                <%= vnFormat.format(currentTotal) %>
                                                            </strong>
                                                        </div>
                                                    <% 
                                                            } catch (Exception e) {
                                                                
                                                                out.print(vnFormat.format(p.getAmount()));
                                                            }
                                                        } else {
                                                            
                                                    %>
                                                        <%= vnFormat.format(p.getAmount())%>
                                                    <% } %>
                                                </div>

                                                <div class="payment-status">
                                                    <% if ("Paid".equalsIgnoreCase(p.getPaymentStatus())) { %>
                                                    <i class="fas fa-check-circle"></i> Đã thanh toán
                                                    <% } else {%>
                                                    <button class="pay-btn"
                                                            data-paymentid="<%= p.getInstallmentDetailID()%>"
                                                            data-amount="<%= (long)p.getAmount()%>"
                                                            data-period="Kỳ <%= p.getCurrentMonth()%>">
                                                        <i class="fas fa-credit-card"></i> Thanh toán
                                                    </button>
                                                    <% } %>
                                                </div>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                                <% }
                    } else { %>
                                <p>Không có đơn hàng trả góp nào.</p>
                                <% }%>
                            </div>

                            <div id="paymentModal" class="payment-modal">
                                <div class="modal-content">
                                    <form id="paymentConfirmForm" action="user" method="POST">

                                        <input type="hidden" name="action" value="paidInstalment">
                                        <input type="hidden" id="modalPaymentID" name="paymentID" value=""> 

                                        <span class="close-btn js-close-modal">×</span>
                                        <h4 id="modalTitle">Thanh toán</h4>
                                        <p>Quét mã QR để thanh toán hoặc chuyển khoản với nội dung bên dưới.</p>

                                        <img id="qrCodeImage" src="" alt="QR Code" class="qr-code">

                                        <p>Số tiền: <strong id="transferAmount" class="highlight">0đ</strong></p>
                                        <p>Nội dung: 
                                            <strong id="transferContent" class="highlight"></strong> 
                                            <button id="copyContentBtn" type="button" title="Copy">
                                                <i class="fas fa-copy"></i>
                                            </button>
                                        </p>
                                        <p style="font-size: 0.8em; color: #6c757d;">(Vui lòng nhập đúng nội dung để được xác nhận tự động)</p>

                                        <button id="confirmTransferBtn" class="confirm-btn" type="button">
                                            <i class="fas fa-check"></i> Đã thanh toán
                                        </button>

                                    </form> 
                                </div>
                            </div>
                            
                        </div>
                    </main>
                </div>
            </div>
        </section>


    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const vnFormat = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'});
            const modal = document.getElementById("paymentModal");
            const closeBtn = document.querySelector(".js-close-modal");
            let paymentCheckInterval = null;

            // === MỞ/ĐÓNG CARD ===
            document.querySelectorAll(".card-header").forEach(header => {
                header.addEventListener("click", function (e) {
                    this.closest(".installment-card").classList.toggle("open");
                });
            });

            // === MỞ MODAL KHI BẤM "THANH TOÁN" ===
            document.querySelectorAll(".pay-btn").forEach(btn => {
                btn.addEventListener("click", function (e) {

                    // --- Dữ liệu động từ nút được bấm ---
                    const paymentId = this.dataset.paymentid;
                    const period = this.dataset.period;
                    const realAmount = parseInt(this.dataset.amount);

                    // === YÊU CẦU 3: Giữ giá 2000 để test ===
                    const totalAmountTest = 2000;

                    // --- Logic tạo VietQR ---
                    const qrCodeImage = document.getElementById('qrCodeImage');
                    const transferDescription = 'PAYMENT' + paymentId + Date.now();

                    // Cập nhật thông tin trên Modal
                    document.getElementById('transferContent').innerText = transferDescription;
                    document.getElementById("modalTitle").textContent = "Thanh toán " + period;
                    document.getElementById("transferAmount").textContent = vnFormat.format(realAmount);

                    // === Gán paymentId vào form NGAY KHI MỞ MODAL ===
                    document.getElementById("modalPaymentID").value = paymentId;

                    // Thông tin ngân hàng của bạn
                    const bankId = "970422"; // MB Bank
                    const accountNumber = "0968418098";
                    const accountName = "TRANG TIEN DAT";

                    // Tạo link VietQR
                    const encodedDescription = encodeURIComponent(transferDescription);
                    const encodedAccountName = encodeURIComponent(accountName);
                    const cacheBuster = `&t=${Date.now()}`;
                    const vietQrApiUrl = `https://img.vietqr.io/image/${bankId}-${accountNumber}-compact.png?amount=${totalAmountTest}&addInfo=${encodedDescription}&accountName=${encodedAccountName}${cacheBuster}`;
                    qrCodeImage.src = vietQrApiUrl;

                    // Mở modal
                    modal.style.display = "flex"; // 

                    // Cập nhật UI nút "Đã thanh toán"
                    const confirmBtn = document.getElementById('confirmTransferBtn');
                    confirmBtn.disabled = true;
                    confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang chờ thanh toán...';

 
                    if (paymentCheckInterval) {
                        clearInterval(paymentCheckInterval);
                    }

                    setTimeout(() => {
                        paymentCheckInterval = setInterval(() => {
                            console.log("Đang kiểm tra thanh toán cho: " + transferDescription);
                            checkPaid(transferDescription, paymentId);
                        }, 3000);
                    }, 5000);
                });
            });


            const closeModalAndStopCheck = () => {
                modal.style.display = "none"; // <-- Dòng này sẽ ẩn modal


                const confirmBtn = document.getElementById('confirmTransferBtn');
                confirmBtn.disabled = false;
                confirmBtn.innerHTML = '<i class="fas fa-check"></i> Đã thanh toán';

                if (paymentCheckInterval) {
                    clearInterval(paymentCheckInterval);
                    console.log("Đã dừng kiểm tra thanh toán.");
                }
            };

            closeBtn.onclick = closeModalAndStopCheck;
            window.onclick = (e) => {
                if (e.target === modal) {
                    closeModalAndStopCheck();
                }
            };

            document.getElementById("copyContentBtn").onclick = () => {
                const text = document.getElementById("transferContent").textContent;
                navigator.clipboard.writeText(text).then(() => {
                    alert("Đã sao chép: " + text);
                });
            };

            async function checkPaid(description, paymentId) {
                try {
                    const response = await fetch("https://script.google.com/macros/s/AKfycbwVGFzfs_VMzmWN9kXOcLW2o5HNR407tycQzyyq20NjEOn32MBZw6GSBFVi5uRtWtSwqw/exec");
                    const data = await response.json();
                    const lastPaid = data.data[data.data.length - 1];
                    const lastDescription = lastPaid["Mô tả"];

                    if (lastDescription.includes(description)) {
                        clearInterval(paymentCheckInterval);

                        alert("Thanh toán thành công!");

                        const paymentForm = document.getElementById('paymentConfirmForm');

                        document.getElementById('modalPaymentID').value = paymentId;
                        paymentForm.submit();

                    } else {
                        console.log("Checking payment... Not yet paid.");
                    }
                } catch (error) {
                    console.error("Error checking payment:", error);
                }
            }
        });
    </script>

</body>
</html>