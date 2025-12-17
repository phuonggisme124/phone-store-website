<%@page import="model.Vouchers"%>
<%@ page pageEncoding="UTF-8"%>
<%@page import="model.Customer"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%
    Customer userCheck = (Customer) session.getAttribute("user");
    if (userCheck == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<jsp:include page="/layout/header.jsp" />
<link rel="stylesheet" type="text/css" href="css/home.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<style>
    .voucher-page {
        background-color: #f0f2f5;
        min-height: 80vh;
        padding: 40px 0;
    }

    /* Style cho Tabs */
    .nav-pills .nav-link {
        background-color: white;
        color: #555;
        border-radius: 30px;
        padding: 10px 25px;
        margin-right: 15px;
        font-weight: 600;
        border: 1px solid #ddd;
        transition: all 0.3s;
    }
    .nav-pills .nav-link.active {
        background-color: #d0011b; /* Màu đỏ chủ đạo */
        color: white;
        border-color: #d0011b;
        box-shadow: 0 4px 10px rgba(208, 1, 27, 0.3);
    }

    /* Style Voucher Card */
    .voucher-card {
        background: white;
        border-radius: 12px;
        overflow: hidden;
        position: relative;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        transition: transform 0.2s;
        height: 100%;
        display: flex;
        flex-direction: column;
    }
    .voucher-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    }

    .voucher-left {
        background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 99%, #fecfef 100%);
        padding: 15px;
        text-align: center;
        color: #d0011b;
        border-right: 2px dashed #fff;
        position: relative;
    }
    /* Răng cưa trang trí giữa 2 phần */
    .voucher-left::after {
        content: "";
        position: absolute;
        right: -8px;
        top: 0;
        height: 100%;
        width: 16px;
        background-image: radial-gradient(#f0f2f5 5px, transparent 5px);
        background-size: 16px 16px;
        background-position: -8px 0;
    }

    .voucher-right {
        padding: 15px;
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .v-code {
        font-weight: bold;
        color: #333;
        font-size: 1.1rem;
    }
    .v-desc {
        font-size: 0.85rem;
        color: #666;
        margin-bottom: 10px;
    }
    .v-date {
        font-size: 0.75rem;
        color: #999;
    }

    .btn-action {
        width: 100%;
        border-radius: 5px;
        font-size: 0.9rem;
        font-weight: 600;
        padding: 6px 0;
        margin-top: 10px;
    }
    .btn-save {
        background-color: #d0011b;
        color: white;
        border: none;
    }
    .btn-save:hover {
        background-color: #a00115;
        color: white;
    }

    .btn-use {
        background-color: #fff;
        color: #d0011b;
        border: 1px solid #d0011b;
    }
    .btn-use:hover {
        background-color: #fff5f5;
        color: #d0011b;
    }

    .saved-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        background: #28a745;
        color: white;
        padding: 2px 8px;
        border-radius: 10px;
        font-size: 0.7rem;
        font-weight: bold;
    }
</style>

<body>


    <section class="voucher-page">

        <div class="col-12 text-center mb-3">
            <h2 class="text-white"></h2>
            <span class="search-category-badge" id="categoryBadge"></span>

        </div>
        <div class="container">
            <h2 class="text-center mb-4 text-uppercase fw-bold"><i class="fas fa-ticket-alt text-danger"></i> Kho Ưu Đãi</h2>

            <%
                String msg = (String) session.getAttribute("msg");
                if (msg != null) {
            %>
            <div class="alert alert-success text-center mb-4"><%= msg%></div>
            <% session.removeAttribute("msg");
                } %>

            <ul class="nav nav-pills mb-4 justify-content-center" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="pills-all-tab" data-bs-toggle="pill" data-bs-target="#pills-all" type="button" role="tab">
                        Săn Voucher (Tất cả)
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="pills-my-tab" data-bs-toggle="pill" data-bs-target="#pills-my" type="button" role="tab">
                        Ví của tôi (Đã lưu)
                    </button>
                </li>
            </ul>

            <%
                List<Vouchers> allList = (List<Vouchers>) request.getAttribute("listAllVouchers");
                List<Integer> savedIds = (List<Integer>) request.getAttribute("mySavedIds");
                if (savedIds == null)
                    savedIds = new ArrayList<>();
            %>

            <div class="tab-content" id="pills-tabContent">

                <div class="tab-pane fade show active" id="pills-all" role="tabpanel">
                    <div class="row">
                        <%
                            boolean hasUnsaved = false;
                            if (allList != null) {
                                for (Vouchers v : allList) {
                                    // Chỉ hiện những cái CHƯA LƯU ở tab này
                                    if (!savedIds.contains(v.getVoucherID())) {
                                        hasUnsaved = true;
                        %>
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="voucher-card d-flex flex-row">
                                <div class="voucher-left d-flex align-items-center justify-content-center" style="width: 30%;">
                                    <div>
                                        <h3 class="m-0"><%= v.getPercentDiscount()%>%</h3>
                                        <small>OFF</small>
                                    </div>
                                </div>
                                <div class="voucher-right">
                                    <div class="v-code"><%= v.getCode()%></div>
                                    <div class="v-desc">Số lượng: <%= v.getQuantity()%></div>
                                    <div class="v-date"><i class="far fa-clock"></i> HSD: <%= v.getEndDay()%></div>
                                    <a href="voucher?action=saveVoucher&id=<%= v.getVoucherID()%>" class="btn btn-action btn-save">
                                        Lưu ngay
                                    </a>
                                </div>
                            </div>
                        </div>
                        <%      }
                                }
                            }
                            if (!hasUnsaved) {
                        %>
                        <div class="col-12 text-center py-5">
                            <img src="https://cdn-icons-png.flaticon.com/512/4076/4076432.png" width="100" class="mb-3 opacity-50">
                            <p class="text-muted">Bạn đã lưu hết các mã hiện có rồi!</p>
                        </div>
                        <% } %>
                    </div>
                </div>

                <div class="tab-pane fade" id="pills-my" role="tabpanel">
                    <div class="row">
                        <%
                            boolean hasSaved = false;
                            if (allList != null) {
                                for (Vouchers v : allList) {
                                    // Chỉ hiện những cái ĐÃ LƯU ở tab này
                                    if (savedIds.contains(v.getVoucherID())) {
                                        hasSaved = true;
                        %>
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="voucher-card d-flex flex-row">
                                <div class="voucher-left d-flex align-items-center justify-content-center" style="width: 30%; filter: grayscale(0.2);">
                                    <div>
                                        <h3 class="m-0"><%= v.getPercentDiscount()%>%</h3>
                                        <small>OFF</small>
                                    </div>
                                </div>
                                <div class="voucher-right">
                                    <span class="saved-badge"><i class="fas fa-check"></i> Đã có</span>
                                    <div class="v-code"><%= v.getCode()%></div>
                                    <div class="v-desc">Áp dụng toàn sàn</div>
                                    <div class="v-date"><i class="far fa-clock"></i> HSD: <%= v.getEndDay()%></div>
                                    <a href="product?action=category&cID=1" class="btn btn-action btn-use">
                                        Dùng ngay
                                    </a>
                                </div>
                            </div>
                        </div>
                        <%      }
                                }
                            }
                            if (!hasSaved) {
                        %>
                        <div class="col-12 text-center py-5">
                            <p class="text-muted">Ví trống trơn. Hãy qua tab "Săn Voucher" để lưu mã nhé!</p>
                        </div>
                        <% }%>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <%@ include file="/layout/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>