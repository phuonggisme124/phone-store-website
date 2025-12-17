<%@page import="model.Address"%>
<%@page import="model.Carts"%>
<%@page import="dao.ProductDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Customer"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>

<%    // 1. LẤY DỮ LIỆU TỪ SERVLET
    Address defaultAddress = (Address) request.getAttribute("defaultAddress"); // Địa chỉ hiển thị chính
    List<Address> otherAddresses = (List<Address>) request.getAttribute("otherAddresses");
    List<Carts> cartsCheckout = (List<Carts>) session.getAttribute("cartCheckout");
    String errorMsg = (String) request.getAttribute("error");

    ProductDAO pDAO = new ProductDAO();
    double totalPrice = 0;

    // 2. GỘP LIST ĐỊA CHỈ (Để hiển thị trong Modal Danh sách)
    java.util.List<Address> allAddresses = new java.util.ArrayList<>();
    if (defaultAddress != null) {
        allAddresses.add(defaultAddress);
    }
    if (otherAddresses != null) {
        allAddresses.addAll(otherAddresses);
    }

    boolean hasAddress = !allAddresses.isEmpty();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Checkout Information</title>
        <link rel="stylesheet" href="css/payment.css">

        <style>
            /* =========================================
               CSS BỔ SUNG CHO GIAO DIỆN CHỌN ĐỊA CHỈ
               ========================================= */

            /* 1. Box hiển thị địa chỉ đã chọn (Màn hình chính) */
            .selected-addr-box {
                border: 1px solid #72AEC8;
                background-color: #f8fcfd; /* Xanh rất nhạt */
                border-radius: 8px;
                padding: 16px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                transition: all 0.2s;
            }

            .selected-addr-content {
                flex: 1;
                margin-right: 15px;
                font-size: 15px;
                color: #333;
                line-height: 1.5;
            }

            .change-addr-btn {
                color: #007bff;
                font-weight: 600;
                cursor: pointer;
                font-size: 14px;
                text-transform: uppercase;
                padding: 8px 12px;
                border-radius: 4px;
            }
            .change-addr-btn:hover {
                background-color: #e3f2fd;
            }

            /* 2. Modal Danh sách (List Modal) */
            .addr-list-container {
                max-height: 400px;
                overflow-y: auto;
                margin-bottom: 15px;
                border-top: 1px solid #eee;
            }

            .addr-item-row {
                display: flex;
                align-items: flex-start;
                padding: 15px 10px;
                border-bottom: 1px solid #eee;
                cursor: pointer;
                transition: background 0.2s;
            }
            .addr-item-row:hover {
                background-color: #f9f9f9;
            }

            .addr-radio {
                margin-top: 4px;
                margin-right: 12px;
                accent-color: #72AEC8;
                transform: scale(1.2);
                cursor: pointer;
            }

            .addr-item-content {
                flex: 1;
            }

            /* Nhãn Default */
            .tag-default {
                color: #72AEC8;
                border: 1px solid #72AEC8;
                font-size: 11px;
                padding: 2px 6px;
                border-radius: 4px;
                margin-right: 5px;
                font-weight: 600;
            }

            .addr-item-actions {
                margin-top: 8px;
                display: flex;
                gap: 15px;
            }

            .addr-action-link {
                font-size: 13px;
                cursor: pointer;
                background: none;
                border: none;
                padding: 0;
                text-decoration: underline;
                color: #666;
            }
            .addr-action-link:hover {
                color: #007bff;
            }
            .addr-action-link.delete {
                color: #dc3545;
            }

            .btn-add-new-modal {
                width: 100%;
                padding: 12px;
                border: 2px dashed #ccc;
                background: #fff;
                color: #555;
                font-weight: 600;
                border-radius: 8px;
                cursor: pointer;
                margin-top: 10px;
                transition: all 0.2s;
            }
            .btn-add-new-modal:hover {
                border-color: #72AEC8;
                color: #72AEC8;
                background: #eaf4f7;
            }
        </style>
    </head>

    <body>

        <div class="payment-container">
            <div class="payment-header">
                <button class="back-button" onclick="window.history.back();">
                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                    </svg>
                </button>
                <h1 class="header-title">Checkout Information</h1>
            </div>

            <div class="payment-main">

                <% if (errorMsg != null) {%>
                <div style="background-color: #fee2e2; color: #b91c1c; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #fca5a5; display: flex; align-items: center; gap: 8px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                    <span><%= errorMsg%></span>
                </div>
                <% } %>

                <% if (cartsCheckout != null) {
                        for (Carts c : cartsCheckout) {%>
                <div class="product-info-container">
                    <div class="product-info">
                        <img src="images/<%=c.getVariant().getImageList()[0]%>" class="product-image" alt="Product">
                        <div class="product-details">
                            <p class="product-name"><%= pDAO.getProductByID(c.getVariant().getProductID()).getName().toUpperCase() + " - " + c.getVariant().getColor().toUpperCase() + " - " + c.getVariant().getStorage()%></p>
                            <div class="product-price">
                                <span class="current-price"><%= String.format("%,.0f", c.getVariant().getDiscountPrice())%> VND</span><span class="original-price"
                                                                                                                                              style="<%= c.getVariant().getDiscountPrice() < c.getVariant().getPrice() ? "" : "display:none;"%>">
                                    <%= String.format("%,.0f", c.getVariant().getPrice())%> VND
                                </span>

                            </div>
                        </div>
                        <p class="product-quantity">x<%= c.getQuantity()%></p>
                        <% totalPrice += c.getVariant().getDiscountPrice() * c.getQuantity(); %>
                    </div>
                </div>
                <% }
                    }%>

                <form action="payment" method="get" id="checkoutForm">
                    <input type="hidden" name="action" value="checkout">
                    <input type="hidden" name="addressID" id="mainAddressID" 
                           value="<%= defaultAddress != null ? defaultAddress.getAddressID() : ""%>">

                    <div class="recipient-info-section">
                        <h3 class="section-title">Receiver Information</h3>
                        <div class="info-box user-info">
                            <label>Full Name</label>
                            <input type="text" name="receiverName" value="<%= user.getFullName()%>" required>
                            <label>Phone Number</label>
                            <input type="tel" name="receiverPhone" value="<%= user.getPhone()%>" required>
                        </div>
                    </div>

                    <div class="recipient-info-section">
                        <h3 class="section-title">Shipping Address</h3>

                        <% if (!hasAddress) { %>
                        <div class="btn-add-new-modal" onclick="openFormModal('add')" style="text-align: center;">
                            + Add new address
                        </div>
                        <p id="displayAddressText" class="hidden"></p> 

                        <% } else { %>
                        <div class="selected-addr-box">
                            <div class="selected-addr-content">
                                <div style="display: flex; align-items: flex-start; gap: 8px;">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="#72AEC8" style="margin-top: 2px; flex-shrink: 0;">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                    </svg>
                                    <span id="displayAddressText">
                                        <% if (defaultAddress != null) {%>
                                        <%= defaultAddress.getAddress()%>
                                        <% } %>
                                    </span>
                                </div>
                            </div>
                            <div class="change-addr-btn" onclick="openListModal()">Change</div>
                        </div>
                        <% }%>
                    </div>

                    <div class="summary-box">
                        <div class="total-row">
                            <p>Subtotal</p>
                            <p class="total-price"><%= String.format("%,.0f", totalPrice)%> VND</p>
                        </div>
                    </div>

                    <button type="button" id="confirm-btn" onclick="validateAndSubmit()">Place Order</button>
                </form>
            </div>
        </div>

        <div id="listAddrModal" class="addr-modal-backdrop">
            <div class="addr-modal">
                <h3>My Addresses</h3>

                <div class="addr-list-container">
                    <% if (hasAddress) {
                            for (Address a : allAddresses) {%>

                    <div class="addr-item-row" onclick="selectFromList(<%=a.getAddressID()%>, '<%=a.getAddress()%>')">
                        <input type="radio" name="addrGroup" class="addr-radio" 
                               value="<%=a.getAddressID()%>" 
                               <%= (defaultAddress != null && a.getAddressID() == defaultAddress.getAddressID()) ? "checked" : ""%>>

                        <div class="addr-item-content">
                            <div>
                                <% if (a.isDefault()) { %> <span class="tag-default">Default</span> <% }%>
                                <%= a.getAddress()%>
                            </div>
                            <div class="addr-item-actions">
                                <button type="button" class="addr-action-link" 
                                        onclick="event.stopPropagation(); openFormModal('edit', <%=a.getAddressID()%>, '<%=a.getAddress()%>', <%=a.isDefault()%>)">
                                    Edit
                                </button>
                                <button type="button" class="addr-action-link delete" 
                                        onclick="event.stopPropagation(); deleteAddress(<%=a.getAddressID()%>)">
                                    Delete
                                </button>
                            </div>
                        </div>
                    </div>

                    <% }
                    } else { %>
                    <div style="text-align:center; padding: 20px; color:#999;">
                        <p>No addresses found.</p>
                    </div>
                    <% } %>
                </div>

                <button type="button" class="btn-add-new-modal" onclick="openFormModal('add')">
                    + Add New Address
                </button>

                <div class="addr-modal-actions" style="margin-top: 15px;">
                    <button type="button" class="addr-btn addr-btn-cancel" onclick="closeListModal()">Close</button>
                </div>
            </div>
        </div>

        <div id="formAddrModal" class="addr-modal-backdrop" style="z-index: 10000;">
            <div class="addr-modal">
                <h3 id="formModalTitle">Add new address</h3>

                <input type="hidden" id="mode" value="add">
                <input type="hidden" id="editAddressID" value="">

                <label>Province/City</label>
                <select id="modalCity">
                    <option value="">-- Select --</option>
                </select>

                <label>Address Details</label>
                <textarea id="modalSpecific" rows="3" placeholder="Ex: 123 Nguyen Trai, Ward 5..."></textarea>

                <label style="display: flex; align-items: center; cursor: pointer;">
                    <input type="checkbox" id="modalDefault" style="width: auto; margin-right: 10px; transform: scale(1.2);"> 
                    Set as default address
                </label>

                <div class="addr-modal-actions">
                    <button type="button" class="addr-btn addr-btn-cancel" onclick="closeFormModal()">Back</button>
                    <button type="button" class="addr-btn addr-btn-save" onclick="submitAddress()">Save</button>
                </div>
            </div>
        </div>

        <script>
            // --- 1. TỰ ĐỘNG MỞ MODAL SAU KHI RELOAD ---
            document.addEventListener("DOMContentLoaded", function () {
                // Kiểm tra trên URL xem có cờ 'openModal=1' không
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('openModal') === '1') {
                    openListModal();

                    // Xóa param khỏi URL để F5 không bị mở lại, nhưng giữ lại action=checkout
                    // Điều này giúp trải nghiệm mượt hơn
                    const newUrl = window.location.protocol + "//" + window.location.host + window.location.pathname + "?action=checkout";
                    window.history.replaceState({path: newUrl}, '', newUrl);
                }
            });

            // --- 2. KHỞI TẠO API TỈNH THÀNH ---
            fetch("https://provinces.open-api.vn/api/p/")
                    .then(res => res.json())
                    .then(data => {
                        const city = document.getElementById("modalCity");
                        data.forEach(p => {
                            const opt = document.createElement("option");
                            opt.value = p.name;
                            opt.textContent = p.name;
                            city.appendChild(opt);
                        });
                    });

            // --- 3. LOGIC MODAL DANH SÁCH (List Modal) ---
            function openListModal() {
                document.getElementById("listAddrModal").classList.add("show");
            }

            function closeListModal() {
                document.getElementById("listAddrModal").classList.remove("show");
            }

            // Khi chọn 1 dòng trong danh sách -> Cập nhật màn hình chính & Đóng modal
            function selectFromList(id, addressText) {
                document.getElementById("mainAddressID").value = id;
                document.getElementById("displayAddressText").innerText = addressText;

                // Update Radio button UI
                const radios = document.getElementsByName("addrGroup");
                radios.forEach(r => {
                    if (r.value == id)
                        r.checked = true;
                });

                closeListModal();
            }

            // --- 4. LOGIC MODAL NHẬP LIỆU (Form Modal) ---
            function openFormModal(mode, id = 0, fullAddress = '', isDefault = false) {
                // Đóng modal list trước
                closeListModal();

                const modal = document.getElementById("formAddrModal");
                const title = document.getElementById("formModalTitle");
                const citySelect = document.getElementById("modalCity");
                const specificInput = document.getElementById("modalSpecific");
                const defaultCheck = document.getElementById("modalDefault");

                document.getElementById("mode").value = mode;
                document.getElementById("editAddressID").value = id;

                if (mode === 'edit') {
                    title.innerText = "Edit Address";
                    if (fullAddress.includes(",")) {
                        let parts = fullAddress.split(",");
                        let cityVal = parts[parts.length - 1].trim();
                        let specificVal = fullAddress.substring(0, fullAddress.lastIndexOf(",")).trim();
                        citySelect.value = cityVal;
                        specificInput.value = specificVal;
                    } else {
                        specificInput.value = fullAddress;
                    }
                    defaultCheck.checked = isDefault;
                } else {
                    title.innerText = "Add New Address";
                    citySelect.value = "";
                    specificInput.value = "";
                    defaultCheck.checked = false;
                }
                modal.classList.add("show");
            }

            function closeFormModal() {
                document.getElementById("formAddrModal").classList.remove("show");
                // Khi ấn nút Back/Cancel từ Form -> Mở lại List Modal để user chọn tiếp
            <% if (hasAddress) { %>
                openListModal();
            <% }%>
            }

            // --- 5. SUBMIT & DELETE (CÓ UPDATE URL KHI RELOAD) ---
            function submitAddress() {
                const mode = document.getElementById("mode").value;
                const id = document.getElementById("editAddressID").value;
                const city = document.getElementById("modalCity").value;
                const specific = document.getElementById("modalSpecific").value;
                const isDefault = document.getElementById("modalDefault").checked;

                if (!city || !specific) {
                    alert("Please enter full address (City & Details).");
                    return;
                }

                const params = new URLSearchParams({
                    action: mode,
                    addressID: id,
                    city: city,
                    specificAddress: specific,
                    isDefault: isDefault
                });

                fetch("address", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: params
                }).then(res => {
                    if (res.ok) {
                        // RELOAD KÈM THAM SỐ openModal=1
                        const currentUrl = new URL(window.location.href);
                        currentUrl.searchParams.set("openModal", "1");
                        window.location.href = currentUrl.toString();
                    } else {
                        alert("Error saving address.");
                    }
                });
            }

            function deleteAddress(id) {
                if (!confirm("Are you sure you want to delete this address?"))
                    return;
                fetch("address", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: new URLSearchParams({action: "delete", addressID: id})
                }).then(res => {
                    if (res.ok) {
                        // RELOAD KÈM THAM SỐ openModal=1
                        const currentUrl = new URL(window.location.href);
                        currentUrl.searchParams.set("openModal", "1");
                        window.location.href = currentUrl.toString();
                    } else
                        alert("Error deleting.");
                });
            }

            // --- 6. VALIDATE FORM CHECKOUT ---
            function validateAndSubmit() {
                var addrID = document.getElementById("mainAddressID").value;

                // Kiểm tra xem ID có rỗng không
                if (!addrID || addrID.trim() === "") {
                    alert("⚠️ Please select a shipping address to continue.");
                    // Nếu chưa chọn, tự mở modal list lên cho người ta chọn
                    openListModal();
                    return;
                }
                document.getElementById("checkoutForm").submit();
            }
        </script>

    </body>
</html>

