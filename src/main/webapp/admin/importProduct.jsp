<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Nhập Hàng - Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">

        <style>

            body {
                background-color: #f8f9fa;
                overflow-x: hidden;
            }


            .sidebar-wrapper {
                width: 260px;
                flex-shrink: 0;
                background: white;
                min-height: 100vh;
                border-right: 1px solid #dee2e6;
            }


            .main-content {
                flex-grow: 1;
                padding: 30px;
                width: 100%;
            }


            .card-custom {
                background: #fff;
                border: none;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                padding: 25px;
            }

            .page-title {
                color: #0d6efd;
                font-weight: 700;
                margin-bottom: 25px;
            }
        </style>
    </head>
    <body>

        <div class="d-flex">

            <div class="sidebar-wrapper">
                <jsp:include page="sidebar.jsp"/> 
            </div>

            <div class="main-content">
                <div class="container-fluid">

                    <h2 class="page-title">Nhập Sản Phẩm (Import Product)</h2>

                    <c:if test="${not empty ERROR}">
                        <div class="alert alert-danger shadow-sm mb-4">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${ERROR}
                        </div>
                    </c:if>
                    <c:if test="${not empty MESS}">
                        <div class="alert alert-success shadow-sm mb-4">
                            <i class="bi bi-check-circle-fill me-2"></i> ${MESS}
                        </div>
                    </c:if>

                    <div class="card card-custom">
                        <form action="importproduct" method="POST" id="importForm">

                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Nhà Cung Cấp:</label>
                                    <select name="supplierID" class="form-select" required>
                                        <option value="">-- Chọn nhà cung cấp --</option>
                                        <c:forEach items="${listSup}" var="s">
                                            <option value="${s.supplierID}">${s.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Ghi chú:</label>
                                    <input type="text" name="note" class="form-control" placeholder="Nhập ghi chú phiếu nhập...">
                                </div>
                            </div>

                            <div class="p-3 bg-light rounded-3 mb-3 border">
                                <h6 class="mb-3 text-primary"><i class="bi bi-plus-circle"></i> Thông tin nhập hàng</h6>
                                <div class="row align-items-end g-3">

                                    <div class="col-md-2">
                                        <label class="form-label small text-muted">Lọc Danh mục:</label>
                                        <select id="selectCategory" class="form-select" onchange="filterVariants()">
                                            <option value="all">-- Tất cả --</option>
                                            <c:forEach items="${listCategories}" var="c">
                                                <option value="${c.categoryId}">${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-3">
                                        <label class="form-label small text-muted">Sản phẩm:</label>
                                        <div class="input-group">
                                            <select id="selectVariant" class="form-select" onchange="updatePriceInfo()">
                                                <option value="" data-price="0" data-category="all">-- Chọn sản phẩm --</option>

                                                <c:forEach items="${listVar}" var="v">
                                                    <c:set var="finalPrice" value="${v.discountPrice != null && v.discountPrice > 0 ? v.discountPrice : v.price}" />

                                                    <option value="${v.variantID}" 
                                                            data-category="${v.categoryID}" 
                                                            data-name="${v.productName} - ${v.color} - ${v.storage}"
                                                            data-price="${finalPrice}"> 
                                                        ${v.productName} - ${v.color} - ${v.storage} (Tồn: ${v.stock})
                                                    </option>
                                                </c:forEach>
                                            </select>

                                            <a href="admin?action=createProductPage" class="btn btn-outline-primary" title="Tạo mới">
                                                <i class="bi bi-plus-lg"></i>
                                            </a>
                                            <button type="button" class="btn btn-outline-secondary" onclick="location.reload()">
                                                <i class="bi bi-arrow-clockwise"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label small text-muted">Giá bán (Mới):</label>
                                        <div class="input-group">
                                            <input type="text" id="inputSellingPrice" class="form-control fw-bold text-success" 
                                                   onkeyup="formatCurrencyInput(this)" placeholder="0">
                                            <span class="input-group-text small">đ</span>
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label small text-muted">Giá nhập (Vốn):</label>
                                        <input type="number" id="inputPrice" class="form-control" min="0" placeholder="0">
                                    </div>

                                    <div class="col-md-1">
                                        <label class="form-label small text-muted">SL:</label>
                                        <input type="number" id="inputQty" class="form-control" min="1" value="1">
                                    </div>

                                    <div class="col-md-2">
                                        <button type="button" class="btn btn-primary w-100" onclick="addRow()">
                                            <i class="bi bi-plus-lg"></i> Thêm
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-bordered table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Tên sản phẩm</th>
                                            <th class="text-center">Giá nhập</th>
                                            <th class="text-center">Số lượng</th>
                                            <th class="text-end">Thành tiền</th>
                                            <th class="text-center">Xóa</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tableBody">
                                    </tbody>
                                </table>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                <div class="h4 mb-0">Tổng cộng: <span id="displayTotal" class="text-danger fw-bold">0</span> <span class="text-danger small">VNĐ</span></div>
                                <button type="submit" class="btn btn-success btn-lg px-5 shadow">LƯU PHIẾU NHẬP</button>
                            </div>

                        </form>
                    </div> </div>
            </div> </div>

        <script>
            let totalAmount = 0;

            // 1. Hàm format tiền tệ hiển thị (VD: 1.000.000)
            function formatCurrency(number) {
                return new Intl.NumberFormat('vi-VN').format(number);
            }

            // 2. Hàm format khi đang gõ vào ô input (thêm dấu chấm động khi nhập Giá Bán)
            function formatCurrencyInput(input) {
                // Xóa dấu chấm cũ để lấy số thô
                let value = input.value.replace(/\./g, '').replace(/[^0-9]/g, '');
                if (value) {
                    // Format lại có dấu chấm
                    input.value = new Intl.NumberFormat('vi-VN').format(parseInt(value));
                } else {
                    input.value = '';
                }
            }

            // 3. Hàm tự động điền giá khi chọn sản phẩm từ dropdown
            function updatePriceInfo() {
                var selectBox = document.getElementById("selectVariant");
                var selectedOption = selectBox.options[selectBox.selectedIndex];

                // Lấy giá bán hiện tại từ attribute data-price
                var currentSellingPrice = parseFloat(selectedOption.getAttribute("data-price")) || 0;

                // Điền vào ô "Giá bán (Mới)" và format lại cho đẹp
                var inputSelling = document.getElementById("inputSellingPrice");
                inputSelling.value = formatCurrency(currentSellingPrice);
            }

            // 4. Hàm thêm dòng vào bảng (Main Logic)
            function addRow() {
                var selectBox = document.getElementById("selectVariant");
                var variantID = selectBox.value;

                // Validate: Chưa chọn sản phẩm
                if (!variantID) {
                    alert("Vui lòng chọn sản phẩm!");
                    return;
                }

                var variantName = selectBox.options[selectBox.selectedIndex].getAttribute("data-name");

                // Lấy giá bán từ ô input (Cần xóa dấu chấm trước khi chuyển sang số)
                var rawSellingPrice = document.getElementById("inputSellingPrice").value.replace(/\./g, '');
                var sellingPrice = parseFloat(rawSellingPrice) || 0;

                // Lấy giá nhập và số lượng
                var costPrice = parseFloat(document.getElementById("inputPrice").value);
                var qty = parseInt(document.getElementById("inputQty").value);

                // Validate: Số liệu không hợp lệ
                if (isNaN(qty) || qty <= 0 || isNaN(costPrice) || costPrice < 0) {
                    alert("Số lượng và giá nhập phải hợp lệ (phải là số dương)!");
                    return;
                }

                // === [QUAN TRỌNG] CHẶN NẾU GIÁ NHẬP > GIÁ BÁN ===
                if (costPrice > sellingPrice) {
                    alert("LỖI NGHIÊM TRỌNG:\nGiá nhập (" + formatCurrency(costPrice) + ") ĐANG CAO HƠN Giá bán (" + formatCurrency(sellingPrice) + ")!\n\nVui lòng tăng 'Giá bán (Mới)' lên cao hơn trước khi thêm.");

                    // Tự động đưa con trỏ chuột vào ô Giá bán để Admin sửa ngay
                    document.getElementById("inputSellingPrice").focus();

                    // Dừng hàm tại đây, không thêm dòng nào cả
                    return;
                }

                // Tính thành tiền
                var subTotal = costPrice * qty;
                totalAmount += subTotal;

                // Tạo chuỗi HTML cho dòng mới
                var row = "<tr>" +
                        "<td>" +
                        variantName +
                        // Input ẩn: Variant ID
                        "<input type='hidden' name='variantID' value='" + variantID + "'>" +
                        // Input ẩn: GIÁ BÁN MỚI (để Servlet cập nhật lại DB)
                        "<input type='hidden' name='sellingPrice' value='" + sellingPrice + "'>" +
                        "</td>" +
                        "<td class='text-center'>" +
                        formatCurrency(costPrice) +
                        // Input ẩn: GIÁ NHẬP
                        "<input type='hidden' name='costPrice' value='" + costPrice + "'>" +
                        "</td>" +
                        "<td class='text-center'>" +
                        qty +
                        // Input ẩn: SỐ LƯỢNG
                        "<input type='hidden' name='quantity' value='" + qty + "'>" +
                        "</td>" +
                        "<td class='text-end fw-bold'>" + formatCurrency(subTotal) + "</td>" +
                        "<td class='text-center'>" +
                        "<button type='button' class='btn btn-outline-danger btn-sm' onclick='removeRow(this, " + subTotal + ")'><i class='bi bi-trash'></i></button>" +
                        "</td>" +
                        "</tr>";

                // Chèn dòng vào bảng
                document.getElementById("tableBody").insertAdjacentHTML('beforeend', row);

                // Cập nhật tổng tiền toàn phiếu
                updateTotalDisplay();

                // Reset ô số lượng về 1 để nhập tiếp cho nhanh
                document.getElementById("inputQty").value = "1";
            }

            // 5. Hàm xóa dòng
            function removeRow(btn, subTotal) {
                var row = btn.parentNode.parentNode;
                row.parentNode.removeChild(row);

                // Trừ tiền đi
                totalAmount -= subTotal;
                updateTotalDisplay();
            }

            // 6. Hàm hiển thị tổng tiền
            function updateTotalDisplay() {
                document.getElementById("displayTotal").innerText = formatCurrency(totalAmount);
            }
            function filterVariants() {
                // 1. Lấy ID danh mục vừa chọn
                var selectedCatID = document.getElementById("selectCategory").value;

                // 2. Lấy danh sách các option trong ô Sản phẩm
                var variantSelect = document.getElementById("selectVariant");
                var options = variantSelect.options;

                // 3. Duyệt qua từng option để ẩn/hiện
                for (var i = 0; i < options.length; i++) {
                    var optionCat = options[i].getAttribute("data-category");

                    // Nếu chọn "Tất cả" HOẶC option này thuộc danh mục đang chọn HOẶC là dòng "-- Chọn sản phẩm --"
                    if (selectedCatID === "all" || optionCat === selectedCatID || options[i].value === "") {
                        options[i].hidden = false; // Hiện
                    } else {
                        options[i].hidden = true;  // Ẩn
                    }
                }

                // 4. Reset ô chọn sản phẩm về mặc định để tránh hiển thị sản phẩm sai danh mục
                variantSelect.value = "";

                // 5. Reset các ô giá
                document.getElementById("inputSellingPrice").value = "";
                document.getElementById("inputPrice").value = "";
            }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>