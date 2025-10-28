<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Map"%>
<%@page import="model.Payments"%>
<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Trả Góp</title>
        <link href="css/instalment.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>

        <div class="installment-container">
            <h1>Quản Lý Trả Góp</h1>

            <%
                List<Order> oList = (List<Order>) request.getAttribute("oList");
                Map<Integer, List<Payments>> allPayments = (Map<Integer, List<Payments>>) request.getAttribute("allPayments");
                NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            %>

            <div class="installment-list">
                <% if (oList != null && !oList.isEmpty()) {
                        for (Order o : oList) {
                            List<Payments> pList = allPayments.get(o.getOrderID());
                %>
                <div class="installment-card">
                    <div class="card-header">
                        <div class="product-info">
                            <h4>Đơn hàng #<%= o.getOrderID()%></h4>
                            <p>Ngày tạo: <%= o.getOrderDate()%></p>
                        </div>
                        <div class="plan-summary">
                            <%
                                int paidCount = 0;
                                if (pList != null) {
                                    for (Payments p : pList) {
                                        if ("Paid".equalsIgnoreCase(p.getPaymentStatus())) {
                                            paidCount++;
                                        }
                                    }
                                }
                            %>
                            <h4>Đã trả <%= paidCount%> / <%= (pList != null ? pList.size() : 0)%> tháng</h4>
                            <div class="status-badge <%= (paidCount == (pList != null ? pList.size() : 0)) ? "status-done" : "status-ongoing"%>">
                                <%= (paidCount == (pList != null ? pList.size() : 0)) ? "Hoàn tất" : "Đang trả góp"%>
                            </div>
                        </div>
                    </div>

                    <% if (pList != null && !pList.isEmpty()) { %>
                    <div class="card-details-wrapper">
                        <h5>Lịch sử thanh toán</h5>
                        <div class="payment-schedule">
                            <% for (Payments p : pList) {%>
                            <div class="payment-item <%= p.getPaymentStatus().equalsIgnoreCase("Paid") ? "paid" : "unpaid"%>">
                                <div class="payment-period">Kỳ <%= p.getCurrentMonth()%></div>
                                <div class="payment-date"><%= p.getPaymentDate() != null ? p.getPaymentDate() : "-"%></div>
                                <div class="payment-amount"><%= vnFormat.format(p.getAmount())%></div>

                                <div class="payment-status">
                                    <% if ("Paid".equalsIgnoreCase(p.getPaymentStatus())) { %>
                                    <i class="fas fa-check-circle"></i> Đã thanh toán
                                    <% } else { %>
                                    <%if (ChronoUnit.DAYS.between(LocalDateTime.now(), p.getPaymentDate()) >= 0) {%>
                                    <button class="pay-btn" data-paymentid="<%=p.getPaymentID()%>">
                                        <i class="fas fa-credit-card"></i> Thanh toán
                                    </button>
                                    <%} else { %>
                                    <i class="fas fa-clock"></i> Chưa thanh toán
                                    <%}%>
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

            <!-- MODAL THANH TOÁN (giữ nguyên giao diện cũ) -->
            <div id="transferModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-end sm:items-center justify-center p-0 sm:p-4 z-[70] hidden">
                <div class="bg-white rounded-t-lg sm:rounded-lg shadow-xl w-full max-w-md">
                    <div class="p-4 border-b flex items-center relative">
                        <button id="backToPaymentModalBtnFromTransfer" class="absolute left-4 text-gray-600 hover:text-gray-900">
                            <i class="fa-solid fa-arrow-left"></i>
                        </button>
                        <h2 class="text-lg font-semibold text-gray-800 w-full text-center">Bank Transfer Information</h2>
                        <button class="js-close-modal absolute right-4 text-gray-400 hover:text-gray-600">
                            <i class="fa-solid fa-times fa-lg"></i>
                        </button>
                    </div>
                    <div class="p-6 text-center">
                        <p class="text-sm text-gray-600 mb-4">Scan the QR code to pay or use the details below for a manual transfer.</p>
                        <div class="flex justify-center mb-4">
                            <img id="qrCodeImage" src="" alt="QR Code" class="w-48 h-48 border rounded-lg">
                        </div>
                        <div class="space-y-3 text-left bg-gray-50 p-4 rounded-lg">
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Amount:</span>
                                <span id="transferAmount" class="font-bold text-lg text-theme"></span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Bank:</span>
                                <span class="font-semibold text-gray-800">MB Bank</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Account Holder:</span>
                                <span class="font-semibold text-gray-800">PHAM HOANG PHUONG</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-gray-500">Content:</span>
                                <div class="flex items-center space-x-2">
                                    <span id="transferContent" class="font-semibold" style="color: #3B82F6;"></span>
                                    <button id="copyContentBtn" class="text-gray-500 hover:text-blue-600" title="Copy">
                                        <i class="fa-regular fa-copy"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <p class="text-xs text-gray-500 mt-4">Note: Please enter the correct transfer content for automatic order confirmation.</p>
                    </div>
                    <div class="p-4 border-t">
                        <button id="confirmTransferBtn" class="w-full bg-theme text-white font-bold py-3 rounded-lg hover:bg-theme-dark">
                            Confirm
                        </button>
                    </div>
                </div>
            </div>

            <script>
                document.addEventListener("DOMContentLoaded", function () {

                    // Toggle mở/đóng card trả góp
                    document.querySelectorAll(".card-header").forEach(header => {
                        header.addEventListener("click", function () {
                            const card = this.closest(".installment-card");
                            card.classList.toggle("open");
                        });
                    });

                    // === Modal xử lý ===
                    const modal = document.getElementById("transferModal");
                    const closeModalBtn = document.querySelector(".js-close-modal");
                    const confirmTransferBtn = document.getElementById("confirmTransferBtn");
                    const copyContentBtn = document.getElementById("copyContentBtn");
                    let selectedPaymentId = null;

                    // Mở modal khi click "Thanh toán"
                    document.querySelectorAll(".pay-btn").forEach(btn => {
                        btn.addEventListener("click", function (e) {
                            e.stopPropagation(); // tránh mở card khi bấm
                            selectedPaymentId = this.dataset.paymentid;
                            modal.classList.remove("hidden");

                            // Lấy số tiền
                            const amountText = this.closest(".payment-item").querySelector(".payment-amount").textContent.trim();
                            document.getElementById("transferAmount").textContent = amountText;

                            // Tạo nội dung chuyển khoản
                            const transferContent = "PAYMENT" + selectedPaymentId;
                            document.getElementById("transferContent").textContent = transferContent;

                            // Gán QR (tùy bạn đổi link thật)
                            document.getElementById("qrCodeImage").src = "img/qr_example.png";
                        });
                    });

                    // Đóng modal
                    closeModalBtn.addEventListener("click", () => modal.classList.add("hidden"));
                    window.addEventListener("click", (e) => {
                        if (e.target === modal)
                            modal.classList.add("hidden");
                    });

                    // Sao chép nội dung chuyển khoản
                    copyContentBtn.addEventListener("click", () => {
                        const text = document.getElementById("transferContent").textContent;
                        navigator.clipboard.writeText(text).then(() => alert("Đã sao chép nội dung: " + text));
                    });

                    // Xác nhận thanh toán
                    confirmTransferBtn.addEventListener("click", () => {
                        modal.classList.add("hidden");
                        alert("✅ Đã xác nhận thanh toán cho PaymentID = " + selectedPaymentId);
                        // TODO: gọi servlet cập nhật trạng thái Payment
                        // fetch('PaymentServlet?action=confirm&id=' + selectedPaymentId)
                    });
                });
            </script>


    </body>
</html>
