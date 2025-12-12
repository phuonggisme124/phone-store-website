<%@page import="model.Staff"%> <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@page contentType="text/html" pageEncoding="UTF-8"%>
        <title>Nhập Hàng - Admin Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">

        <style>
            body {
                background-color: #f8f9fa;
                overflow-x: hidden;
            }
            .d-flex-wrapper {
                display: flex !important;
                width: 100%;
                min-height: 100vh;
                overflow-x: hidden;
            }
            .sidebar {
                width: 250px !important;
                min-width: 250px !important;
                flex-shrink: 0 !important;
                background-color: #fff;
                border-right: 1px solid #dee2e6;
                min-height: 100vh;
                position: relative !important;
                z-index: 100;
            }
            .main-content {
                flex-grow: 1 !important;
                width: calc(100% - 250px) !important;
                padding: 0;
                overflow-x: auto;
                position: relative;
            }
            .card-custom {
                background: #fff;
                border: none;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                padding: 25px;
            }
            @media (max-width: 992px) {
                .d-flex-wrapper {
                    flex-direction: column !important;
                }
                .sidebar {
                    width: 100% !important;
                    height: auto !important;
                    min-height: auto !important;
                }
                .main-content {
                    width: 100% !important;
                }
            }
        </style>
    </head>
    <body>
        <%
            // 2. SỬA DÒNG LẤY SESSION: Ép kiểu về Staff
            Staff currentUser = (Staff) session.getAttribute("user");

            // Kiểm tra null để tránh lỗi (Optional)
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <div class="d-flex-wrapper">
            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                    <li class="mb-2"><a href="product?action=manageProduct" class="text-decoration-none text-dark d-block p-2"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li class="mb-2"><a href="order?action=manageOrder" class="text-decoration-none text-dark d-block p-2"><i class="bi bi-bag me-2"></i>Orders</a></li>
                    <li class="mb-2"><a href="review?action=manageReview" class="text-decoration-none text-dark d-block p-2"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>
                    <li class="mb-2"><a href="importproduct?action=staff_import" class="fw-bold text-primary bg-light d-block p-2 rounded"><i class="bi bi-file-earmark-arrow-down me-2"></i>Import Product</a></li>
                </ul>
            </nav>

            <div class="main-content">
                <nav class="navbar navbar-light bg-white shadow-sm mb-4 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary d-lg-none" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto">
                            <form action="#" class="d-flex position-relative me-3" autocomplete="off">
                                <div class="input-group">
                                    <input class="form-control" type="text" placeholder="Tìm kiếm...">
                                    <button class="btn btn-outline-primary" type="button"><i class="bi bi-search"></i></button>
                                </div>
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span class="fw-bold small"><%= currentUser.getFullName()%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-5">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold text-primary mb-0">Nhập Sản Phẩm (Import Product)</h2>
                        <a href="importproduct?action=staff_import" class="text-decoration-none text-secondary fw-bold small hover-link">
                            <i class="bi bi-arrow-left"></i> Quay lại lịch sử nhập
                        </a>
                    </div>

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
                                <h6 class="mb-3 text-primary fw-bold"><i class="bi bi-cart-plus-fill"></i> Thông tin hàng hóa</h6>
                                <div class="row align-items-end g-2"> 
                                    <div class="col-md-2">
                                        <label class="form-label small text-muted">Danh mục:</label>
                                        <select id="selectCategory" class="form-select form-select-sm" onchange="filterProductsByCategory()">
                                            <option value="all">-- Tất cả --</option>
                                            <c:forEach items="${listCategories}" var="c">
                                                <option value="${c.categoryId}">${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label small text-muted">Tên sản phẩm:</label>
                                        <div class="input-group input-group-sm">
                                            <select id="selectProductName" class="form-select" onchange="filterVariantsByProduct()">
                                                <option value="">-- Chọn tên --</option>
                                            </select>
                                            <a href="${pageContext.request.contextPath}/importproduct?action=createProductPage" class="btn btn-primary" title="Tạo sản phẩm mới">
                                                <i class="bi bi-plus-lg"></i>
                                            </a>
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label small text-muted">Phiên bản:</label>
                                        <div class="input-group input-group-sm">
                                            <select id="selectVariant" class="form-select" onchange="updatePriceInfo()">
                                                <option value="" data-price="0">-- Màu / DL --</option>
                                            </select>
                                            <a href="${pageContext.request.contextPath}/importproduct?action=createProductPage" class="btn btn-primary" title="Tạo biến thể mới">
                                                <i class="bi bi-plus-lg"></i>
                                            </a>
                                            <button type="button" class="btn btn-outline-secondary" onclick="location.reload()" title="Tải lại dữ liệu">
                                                <i class="bi bi-arrow-clockwise"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label small text-muted">Giá bán:</label>
                                        <div class="input-group input-group-sm">
                                            <input type="text" id="inputSellingPrice" class="form-control fw-bold text-success" 
                                                   onkeyup="formatCurrencyInput(this)" placeholder="0">
                                            <span class="input-group-text small">đ</span>
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label small text-muted">Giá nhập (Vốn):</label>
                                        <div class="input-group input-group-sm">
                                            <input type="text" id="inputPrice" class="form-control fw-bold text-danger" 
                                                   onkeyup="formatCurrencyInput(this)" placeholder="0">
                                            <span class="input-group-text small">đ</span>
                                        </div>
                                    </div>

                                    <div class="col-md-1">
                                        <label class="form-label small text-muted">SL:</label>
                                        <input type="number" id="inputQty" class="form-control form-control-sm" min="1" value="1">
                                    </div>

                                    <div class="col-md-1">
                                        <button type="button" class="btn btn-primary btn-sm w-100" onclick="addRow()">
                                            <i class="bi bi-plus-lg"></i> Thêm
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-bordered table-hover align-middle">
                                    <thead class="table-light text-center">
                                        <tr>
                                            <th>Tên sản phẩm</th>
                                            <th>Giá nhập</th>
                                            <th>Số lượng</th>
                                            <th>Thành tiền</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tableBody">
                                    </tbody>
                                </table>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                <div class="h4 mb-0">Tổng cộng: <span id="displayTotal" class="text-danger fw-bold">0</span> <span class="text-danger small">VNĐ</span></div>
                                <button type="submit" class="btn btn-success btn-lg px-5 shadow">
                                    <i class="bi bi-check2-circle me-2"></i> LƯU PHIẾU NHẬP
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            let totalAmount = 0;
            // 1. KHỞI TẠO DỮ LIỆU TỪ SERVER (JSP)
            const allVariants = [
            <c:forEach items="${listVar}" var="v">
                {
                    variantID: "${v.variantID}",
                    productName: `<c:out value="${v.productName}" />`,
                    categoryID: "${v.categoryID}",
                    details: `<c:out value="${v.color}" /> - <c:out value="${v.storage}" /> (Tồn: ${v.stock})`,
                    fullDisplay: `<c:out value="${v.productName}" /> - <c:out value="${v.color}" /> - <c:out value="${v.storage}" />`,
                                sellingPrice: <c:choose><c:when test="${not empty v.discountPrice and v.discountPrice > 0}">${v.discountPrice}</c:when><c:otherwise>${not empty v.price ? v.price : 0}</c:otherwise></c:choose>,
                                stock: ${not empty v.stock ? v.stock : 0}
                            },
            </c:forEach>
                        ];

                        // 2. CÁC HÀM LỌC (FILTER)
                        function filterProductsByCategory() {
                            const selectedCatID = document.getElementById("selectCategory").value;
                            const productSelect = document.getElementById("selectProductName");
                            const variantSelect = document.getElementById("selectVariant");

                            // Reset dropdown
                            productSelect.innerHTML = '<option value="">-- Chọn tên --</option>';
                            variantSelect.innerHTML = '<option value="" data-price="0">-- Màu / DL --</option>';
                            resetInputs();

                            const uniqueProducts = new Set();
                            allVariants.forEach(v => {
                                if (selectedCatID === "all" || (v.categoryID + "") === selectedCatID) {
                                    uniqueProducts.add(v.productName);
                                }
                            });

                            uniqueProducts.forEach(name => {
                                const option = document.createElement("option");
                                option.value = name;
                                option.text = name;
                                productSelect.appendChild(option);
                            });
                        }

                        function filterVariantsByProduct() {
                            const selectedName = document.getElementById("selectProductName").value;
                            const variantSelect = document.getElementById("selectVariant");

                            variantSelect.innerHTML = '<option value="" data-price="0">-- Màu / DL --</option>';
                            resetInputs();

                            if (!selectedName)
                                return;

                            const filteredVars = allVariants.filter(v => v.productName === selectedName);
                            filteredVars.forEach(v => {
                                const option = document.createElement("option");
                                option.value = v.variantID;
                                option.setAttribute("data-price", v.sellingPrice);
                                option.setAttribute("data-name", v.fullDisplay);
                                option.text = v.details;
                                variantSelect.appendChild(option);
                            });
                        }

                        // 3. CÁC HÀM XỬ LÝ GIÁ VÀ UI
                        function formatCurrency(number) {
                            return new Intl.NumberFormat('vi-VN').format(number);
                        }

                        function formatCurrencyInput(input) {
                            let value = input.value.replace(/\./g, '').replace(/[^0-9]/g, '');
                            input.value = value ? new Intl.NumberFormat('vi-VN').format(parseInt(value)) : '';
                        }

                        function resetInputs() {
                            document.getElementById("inputSellingPrice").value = "";
                            document.getElementById("inputPrice").value = "";
                            document.getElementById("inputQty").value = "1";
                        }

                        function updatePriceInfo() {
                            var selectBox = document.getElementById("selectVariant");
                            var selectedOption = selectBox.options[selectBox.selectedIndex];
                            // Kiểm tra xem có option nào được chọn không để tránh lỗi
                            if (selectedOption) {
                                var currentSellingPrice = parseFloat(selectedOption.getAttribute("data-price")) || 0;
                                var inputSelling = document.getElementById("inputSellingPrice");

                                if (currentSellingPrice > 0) {
                                    inputSelling.value = formatCurrency(currentSellingPrice);
                                } else {
                                    inputSelling.value = "";
                                }
                            }
                        }

                        function updateTotalDisplay() {
                            document.getElementById("displayTotal").innerText = formatCurrency(totalAmount);
                        }

                       
                        // 4. HÀM THÊM DÒNG (LOGIC CỘNG DỒN)
                        function addRow() {
                            var selectBox = document.getElementById("selectVariant");
                            var variantID = selectBox.value;

                            if (!variantID) {
                                alert("Vui lòng chọn phiên bản sản phẩm!");
                                return;
                            }

                            var variantName = selectBox.options[selectBox.selectedIndex].getAttribute("data-name");
                            var rawSellingPrice = document.getElementById("inputSellingPrice").value.replace(/\./g, '');
                            var sellingPrice = parseFloat(rawSellingPrice) || 0;
                            var rawCostPrice = document.getElementById("inputPrice").value.replace(/\./g, '');
                            var costPrice = parseFloat(rawCostPrice) || 0;
                            var qty = parseInt(document.getElementById("inputQty").value);

                            if (isNaN(qty) || qty <= 0 || costPrice < 0) {
                                alert("Số lượng và giá nhập phải hợp lệ!");
                                return;
                            }

                            if (costPrice > sellingPrice && sellingPrice > 0) {
                                if (!confirm("Cảnh báo: Giá nhập (" + formatCurrency(costPrice) + ") đang CAO HƠN giá bán (" + formatCurrency(sellingPrice) + ")! Bạn có chắc chắn muốn nhập?")) {
                                    document.getElementById("inputPrice").focus();
                                    return;
                                }
                            }

                            // LOGIC CỘNG DỒN: ID dòng bây giờ kết hợp cả variantID và giá nhập
                            // Ví dụ: row-101-5000000 (Variant 101, giá nhập 5tr)
                            var rowId = "row-" + variantID + "-" + costPrice;
                            var existingRow = document.getElementById(rowId);

                            if (existingRow) {
                                // Update dòng cũ (Chỉ khi cùng Variant VÀ cùng Giá nhập)
                                var qtyInput = existingRow.querySelector("input[name='quantity']");
                                // Giá nhập không đổi vì đã check trùng giá rồi

                                var oldQty = parseInt(qtyInput.value);

                                var oldSubTotal = oldQty * costPrice;
                                var newQty = oldQty + qty;
                                var newSubTotal = newQty * costPrice;

                                totalAmount = totalAmount - oldSubTotal + newSubTotal;

                                // Cập nhật lại số lượng và thành tiền
                                existingRow.cells[2].innerHTML = newQty + "<input type='hidden' name='quantity' value='" + newQty + "'>";
                                existingRow.cells[3].innerText = formatCurrency(newSubTotal);
                            } else {
                                // Tạo dòng mới (Khác Variant HOẶC Khác Giá)
                                var subTotal = costPrice * qty;
                                totalAmount += subTotal;

                                var row = "<tr id='" + rowId + "'>" +
                                        "<td>" + variantName +
                                        "<input type='hidden' name='variantID' value='" + variantID + "'>" +
                                        "<input type='hidden' name='discountPrice' value='" + sellingPrice + "'>" +
                                        "</td>" +
                                        "<td class='text-center'>" + formatCurrency(costPrice) +
                                        "<input type='hidden' name='costPrice' value='" + costPrice + "'>" +
                                        "</td>" +
                                        "<td class='text-center'>" + qty +
                                        "<input type='hidden' name='quantity' value='" + qty + "'>" +
                                        "</td>" +
                                        "<td class='text-end fw-bold'>" + formatCurrency(subTotal) + "</td>" +
                                        "<td class='text-center'>" +
                                        "<button type='button' class='btn btn-outline-danger btn-sm' onclick='removeRow(this)'><i class='bi bi-trash'></i></button>" +
                                        "</td>" +
                                        "</tr>";
                                document.getElementById("tableBody").insertAdjacentHTML('beforeend', row);
                            }

                            updateTotalDisplay();

                            // --- PHẦN SỬA ĐỔI ĐỂ RESET FORM ---
                            resetInputs();
                            var variantSelect = document.getElementById("selectVariant");
                            variantSelect.innerHTML = '<option value="" data-price="0">-- Màu / DL --</option>';
                            variantSelect.value = "";
                            document.getElementById("selectProductName").value = "";
                            // -----------------------------------
                        }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>