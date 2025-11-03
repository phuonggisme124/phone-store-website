<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.Variants"%>
<%@page import="dao.VariantsDAO"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="model.OrderDetails"%>
<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="layout/header.jsp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch Sử Giao Dịch</title>
        <link href="css/transaction.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>

        <%-- KHỞI TẠO CÁC BIẾN CẦN THIẾT --%>
        <%        List<Order> oList = (List<Order>) request.getAttribute("oList");
            Map<Integer, List<OrderDetails>> allOrderDetails = (Map<Integer, List<OrderDetails>>) request.getAttribute("allOrderDetails");

            NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            DateTimeFormatter dtFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

            ProductDAO pDAO = new ProductDAO();
            VariantsDAO vDAO = new VariantsDAO();

            Map<String, String> statusCssMap = Map.of(
                    "In Transit", "shipping", "Delivered", "completed", "Cancelled", "cancelled"
            );

            String currentStatus = request.getParameter("status");
            if (currentStatus == null || currentStatus.isEmpty()) {
                currentStatus = "All";
            }
        %>
        <section id="billboard" class="bg-light-blue overflow-hidden padding-large" >
            <div class="transaction-container">
                <h1>Lịch Sử Giao Dịch</h1>

                <div class="custom-select-wrapper">
                    <div class="select-selected">
                        <%
                            if ("Delivered".equals(currentStatus))
                                out.print("Hoàn thành");
                            else if ("In Transit".equals(currentStatus))
                                out.print("Đang giao");
                            else if ("Cancelled".equals(currentStatus))
                                out.print("Đã hủy");
                            else if ("Pending".equals(currentStatus))
                                out.print("Dang xu ly");
                            else
                                out.print("Tất cả trạng thái");
                        %>
                    </div>
                    <div class="select-items select-hide">
                        <div data-value="All">Tất cả trạng thái</div>
                        <div data-value="Delivered">Hoàn thành</div>
                        <div data-value="In Transit">Đang giao</div>
                        <div data-value="Pending">Đang xu ly</div>
                        <div data-value="Cancelled">Đã hủy</div>
                    </div>
                </div>
                <form action="user" method="get" id="filterForm" style="display:none;">
                    <input type="hidden" name="status" id="statusInput" value="<%= currentStatus%>">
                    <input type="hidden" name="action" value="transaction">
                </form>
                <div class="timeline-list">
                    <% if (oList != null && !oList.isEmpty()) { %>
                    <% for (Order o : oList) {%>
                    <div class="timeline-item">
                        <div class="transaction-card">
                            <div class="card-header">
                                <div class="order-info">
                                    <div>
                                        <div class="order-id">Mã đơn #<%= o.getOrderID()%></div>
                                        <div class="order-date"><%= o.getOrderDate().format(dtFormatter)%></div>
                                    </div>
                                </div>
                                <div class="header-right">
                                    <div>
                                        <div class="total-amount-header"><%= vnFormat.format(o.getTotalAmount())%></div>
                                        <div class="status-badge status-<%= statusCssMap.getOrDefault(o.getStatus(), "")%>">
                                            <%= o.getStatus()%>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card-details-wrapper">
                                <div class="shipping-info">
                                    <p><strong>Người nhận</strong>: <%= o.getBuyer().getFullName() + " - " + o.getBuyer().getPhone()%></p>
                                    <p><strong>Địa chỉ</strong>: <%= o.getShippingAddress()%></p>
                                    <p><strong>Thanh toán</strong>: Thanh toán khi nhận hàng (COD)</p>
                                </div>

                                <div class="product-list">
                                    <%
                                        List<OrderDetails> details = allOrderDetails.get(o.getOrderID());
                                        if (details != null && !details.isEmpty()) {
                                            for (OrderDetails d : details) {
                                                Variants v = vDAO.getVariantByID(d.getVariantID());
                                    %>
                                    <div class="product-item">
                                        <img src="images/<%= v.getImageList()[0]%>" alt="Ảnh sản phẩm">
                                        <div class="product-details">
                                            <p class="product-name"><%= pDAO.getNameByID(v.getProductID())%></p>
                                            <p class="product-spec"><%= v.getStorage()%> - <%= v.getColor()%></p>
                                        </div>
                                        <div class="product-price-qty">
                                            <span>x<%= d.getQuantity()%></span>
                                            <strong><%= vnFormat.format(d.getUnitPrice())%></strong>
                                        </div>
                                    </div>
                                    <%
                                            }
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                    <% } else { %>
                    <p style="text-align:center; color:#6c757d; font-size:1.1em; margin-top:50px;">Bạn chưa có giao dịch nào.</p>
                    <% }%>
                </div>
            </div>
        </section>


        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // JAVASCRIPT CHO BỘ LỌC (ĐÃ THÊM LẠI)
                const selectSelected = document.querySelector(".select-selected");
                const selectItems = document.querySelector(".select-items");
                const filterForm = document.getElementById("filterForm");
                const statusInput = document.getElementById("statusInput");

                selectSelected.addEventListener("click", () => {
                    selectItems.classList.toggle("select-hide");
                });

                selectItems.querySelectorAll("div").forEach(option => {
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

                // JAVASCRIPT CHO ACCORDION
                document.querySelectorAll(".card-header").forEach(header => {
                    header.addEventListener("click", function () {
                        const card = this.closest(".transaction-card");
                        card.classList.toggle("open");
                    });
                });
            });
        </script>
    </body>
</html>