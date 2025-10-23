<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="java.util.Map"%>
<%@page import="dao.VariantsDAO"%>
<%@page import="model.OrderDetails"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch Sử Giao Dịch</title>
        <link rel="stylesheet" href="css/transaction.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>

        <div class="transaction-container">
            <h1>Lịch Sử Giao Dịch</h1>
            <div class="custom-select-wrapper">
                <div class="select-selected">Tất cả trạng thái</div>
                <div class="select-items select-hide">
                    <div data-value="All">Tất cả trạng thái</div>
                    <div data-value="Delivered">Hoàn thành</div>
                    <div data-value="In Transit">Đang giao</div>
                    <div data-value="Cancelled">Đã hủy</div>
                </div>
            </div>
            <form action="user" method="get" id="filterForm">
                <input type="hidden" name="status" id="statusInput" value="All">
                <input type="hidden" name="action" value="transaction">
            </form>

            <% List<Order> oList = (List<Order>) request.getAttribute("oList"); %>
            <div class="transaction-list">
                <% for (Order o : oList) {%>
                <div class="transaction-card" data-order-id="<%= o.getOrderID()%>">
                    <div class="card-header">
                        <div class="order-details">
                            <span class="order-id">Mã đơn: <%= o.getOrderID()%></span>
                            <span class="order-date"><%= o.getOrderDate()%></span>
                        </div>
                        <%
                            List<String> arrayStatus = List.of("In Transit", "Delivered", "Cancelled");
                            List<String> cssArrayStatus = List.of("shipping", "completed", "cancelled");
                            NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                        %>
                        <div class="order-status status-<%= cssArrayStatus.get(arrayStatus.indexOf(o.getStatus()))%>"><%= o.getStatus()%></div>
                    </div>
                    <div class="card-body">
                        <p><strong>Người nhận:</strong> <%= o.getBuyer().getFullName() + " - " + o.getBuyer().getPhone()%></p>
                        <p><strong>Địa chỉ:</strong> <%= o.getShippingAddress()%></p>
                    </div>
                    <div class="card-footer">
                        <div class="payment-method">
                            <i class="fas fa-money-bill-wave"></i> Thanh toán khi nhận hàng (COD)
                        </div>
                        <div class="total-amount"><%= vnFormat.format(o.getTotalAmount())%></div>
                    </div>
                </div>
                <% }%>
            </div>
        </div>

        <form id="orderForm" action="user" method="get">
            <input type="hidden" name="action" value="transaction">
            <input type="hidden" name="orderID" id="orderIDInput">
        </form>

        <%
            List<OrderDetails> oDList = (List<OrderDetails>) request.getAttribute("oDList");
            VariantsDAO vDAO = new VariantsDAO();
            ProductDAO pDAO = new ProductDAO();
            NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        %>
        <div id="orderModal" class="modal">
            <div class="modal-content">
                <span class="close-btn">&times;</span>
                <%
                    if (oDList != null && !oDList.isEmpty()) {
                        Order parentOrderForModal = null;
                        int modalOrderId = oDList.get(0).getOrderID();
                        // Tìm đơn hàng tương ứng trong oList
                        for (Order o : oList) {
                            if (o.getOrderID() == modalOrderId) {
                                parentOrderForModal = o;
                                break;
                            }
                        }

                        if (parentOrderForModal != null) {
                %>
                <div class="modal-header">
                    <h2>Chi tiết đơn hàng</h2>
                    <p>Mã đơn: #<%= parentOrderForModal.getOrderID() %> | Ngày đặt: <%= parentOrderForModal.getOrderDate() %></p>
                </div>

                <div class="order-items-list">
                    <% for (OrderDetails od : oDList) {
                           Variants v = vDAO.getVariantByID(od.getVariantID());
                    %>
                    <div class="order-item">
                        <div class="item-image">
                            <img src="images/<%=v.getImageUrl()%>" alt="Tên sản phẩm">
                        </div>
                        <div class="item-details">
                            <h4 class="item-name"><%=pDAO.getNameByID(v.getProductID()) + " - " + v.getStorage() + " - " + v.getColor()%></h4>
                            <p class="item-quantity">Số lượng: <%= od.getQuantity()%></p>
                        </div>
                        <div class="item-price">
                            <%= vnFormat.format(od.getUnitPrice())%>
                        </div>
                    </div>
                    <% } %>
                </div>

                <div class="modal-footer">
                    <span>Tổng cộng: <strong><%= vnFormat.format(parentOrderForModal.getTotalAmount()) %></strong></span>
                </div>
                <%
                        } // Kết thúc if (parentOrderForModal != null)
                    } // Kết thúc if (oDList != null)
                %>
            </div>
        </div>
    </body>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Dropdown chọn trạng thái
            const selectSelected = document.querySelector(".select-selected");
            const selectItems = document.querySelector(".select-items");
            const selectOptions = document.querySelectorAll(".select-items div");
            const statusInput = document.getElementById("statusInput");
            const filterForm = document.getElementById("filterForm");
            selectSelected.addEventListener("click", () => selectItems.classList.toggle("select-hide"));
            selectOptions.forEach(option => {
                option.addEventListener("click", function () {
                    statusInput.value = this.getAttribute("data-value");
                    filterForm.submit();
                });
            });
            document.addEventListener("click", event => {
                if (!event.target.closest(".custom-select-wrapper")) {
                    selectItems.classList.add("select-hide");
                }
            });

            // Xử lý click vào mỗi order
            document.querySelectorAll(".transaction-card").forEach(card => {
                card.addEventListener("click", function () {
                    const orderId = this.getAttribute("data-order-id");
                    document.getElementById("orderIDInput").value = orderId;
                    document.getElementById("orderForm").submit();
                });
            });

            // Modal
            const modal = document.getElementById("orderModal");
            const closeBtn = document.querySelector("#orderModal .close-btn");
            <% if (request.getAttribute("oDList") != null) { %>
                modal.style.display = "flex";
            <% } %>
            if (closeBtn) {
                closeBtn.addEventListener("click", () => window.location.href = "user?action=transaction");
            }
            window.addEventListener("click", event => {
                if (event.target === modal) {
                    window.location.href = "user?action=transaction";
                }
            });
        });
    </script>
</html>