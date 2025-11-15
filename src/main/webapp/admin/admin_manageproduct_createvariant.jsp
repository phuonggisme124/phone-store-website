<%@page import="model.Category"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Products"%>
<%@page import="model.Variants"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/dashboard_admin.css">

        <link href="css/dashboard_table.css" rel="stylesheet">
        <link href="css/dashboard_admin_manageproduct.css" rel="stylesheet">

    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>

            <%
                Users currentUser = (Users) session.getAttribute("user");
            %>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">
                            <!-- Search bar in navbar -->
                            <form action="admin" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off" style="width: 250px;">
                                <input type="hidden" name="action" value="manageProduct">
                               
                                <input class="form-control me-2" type="text" id="searchProduct" name="productName"
                                       
                                       oninput="showSuggestions(this.value)">
                                <button class="btn btn-outline-primary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                                <div id="suggestionBox" class="list-group position-absolute"
                                     style="top: 100%; left: 0; width: 250px; z-index: 1000;"></div>
                            </form>

                            <!-- Filter Brand -->
                            <form action="admin" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="manageProduct">
                                

                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle"
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i> Brand
                                </button>
                                
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser.getFullName()%></span>

                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Search bar -->               

                <%                    int pID = (int) request.getAttribute("pID");
                    Products product = (Products) request.getAttribute("product");

                %>
                <!-- Table -->
                <form action="variants?action=createVariant" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow" enctype="multipart/form-data">
                    <%                        if (session.getAttribute("existVariant") != null) {
                            String exist = (String) session.getAttribute("existVariant");
                            out.println("<p class='error-message'>" + exist + "</p>");
                        }
                        session.removeAttribute("existVariant");
                    %>
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="pID" value="<%= pID%>">
                    </div>
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="ctID" value="<%= product.getCategoryID() %>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="pName" value="<%= product.getName()%>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Color</label>
                        <input type="text" class="form-control" name="color" value="" required>

                    </div>
                    <%
                        if (product.getCategoryID() == 1 || product.getCategoryID() == 3) {
                    %>
                    <div class="mb-3" >
                        <label class="form-label">Storage</label>
                        <input type="text" class="form-control" name="storage" value="">
                    </div>
                    <%
                        }
                    %>
                    <div class="mb-3">
                        <label class="form-label">Sell Price</label>
                        <input type="text" class="form-control" name="price" value="" required>
                    </div>
<!--                    <div class="mb-3">
                        <label class="form-label">Cost Price</label>
                        <input type="text" class="form-control" name="cost" value="" required>
                    </div>-->

                    <div class="mb-3">
                        <label class="form-label">Stock</label>
                        <input type="text" class="form-control" name="stock" value="" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <input type="text" class="form-control" name="description" value="">
                    </div>

                    <div class="mb-3 options-row">
                        <span class="photo-upload">
                            <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display: none;">
                            <label for="photo-upload-input" class="photo-upload-label">
                                <span class="camera-icon">📷</span> Add photos
                            </label>
                        </span>
                    </div>

                    <div id="image-preview-container" class="image-preview-container"></div>

                    <div class="mb-3">
                        <button type="submit"  class="btn btn-primary w-100">Create Variant</button>
                    </div>
                </form>
            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const fileInput = document.getElementById('photo-upload-input');
                    const previewContainer = document.getElementById('image-preview-container');
                    const noPhotoMessage = document.getElementById('no-photo-message');
                    const imagesToDeleteInput = document.getElementById('imagesToDelete');

                    // 🧩 Cập nhật thông báo "no images"
                    function updateNoPhotoMessage() {
                        const totalImages = previewContainer.querySelectorAll('.image-preview-item').length;
                        noPhotoMessage.style.display = totalImages === 0 ? 'block' : 'none';
                    }

                    // 🧩 Hiển thị preview ảnh mới
                    // 🧩 Hiển thị preview ảnh mới (PHIÊN BẢN SỬA LỖI)
                    function displayImagePreview(file) {
                        if (!file.type || !file.type.startsWith('image/'))
                            return;

                        const reader = new FileReader();

                        reader.onload = function (e) {
                            const imgURL = e.target.result; // Vẫn lấy link ảnh như cũ

                            // 1. Tạo div bọc ngoài
                            const imgWrapper = document.createElement('div');
                            imgWrapper.classList.add('image-preview-item', 'new-image');

                            // 2. Tạo thẻ <img>
                            const img = document.createElement('img');
                            img.src = imgURL; // <--- GÁN TRỰC TIẾP, không qua chuỗi
                            img.className = "img-thumbnail";
                            img.alt = "Ảnh thực tế sản phẩm";
                            img.style.width = "100px";
                            img.style.height = "100px";
                            img.style.objectFit = "cover";

                            // 3. Tạo thẻ <button>
                            const button = document.createElement('button');
                            button.type = "button";
                            button.className = "btn btn-danger btn-sm remove-image-btn";
                            button.innerHTML = '<i class="bi bi-x-circle-fill"></i>';

                            // 4. Gắn img và button vào div bọc ngoài
                            imgWrapper.appendChild(img);
                            imgWrapper.appendChild(button);

                            // 5. Gắn div bọc ngoài vào container
                            previewContainer.appendChild(imgWrapper);
                            updateNoPhotoMessage();
                        };

                        reader.readAsDataURL(file);
                    }

                    // 🧩 Render preview cho tất cả file trong input
                    function renderImagePreviews() {
                        // Xóa toàn bộ ảnh preview mới (nhưng KHÔNG xóa ảnh cũ từ DB)
                        previewContainer.querySelectorAll('.image-preview-item.new-image').forEach(item => item.remove());

                        // Tạo preview cho tất cả file được chọn
                        Array.from(fileInput.files).forEach(displayImagePreview);
                    }

                    // 🧩 Khi chọn ảnh mới
                    fileInput.addEventListener('change', function () {
                        console.log('1. Đã chọn file!'); // LOG 1
                        renderImagePreviews();
                    });

                    // 🧩 Khi nhấn nút "x" xóa ảnh mới
                    previewContainer.addEventListener('click', function (e) {
                        const removeBtn = e.target.closest('.remove-image-btn');
                        if (!removeBtn)
                            return;

                        const item = removeBtn.closest('.image-preview-item');
                        const allNewImages = Array.from(previewContainer.querySelectorAll('.image-preview-item.new-image'));
                        const indexToRemove = allNewImages.indexOf(item);

                        if (indexToRemove >= 0) {
                            const dt = new DataTransfer();
                            Array.from(fileInput.files).forEach((file, i) => {
                                if (i !== indexToRemove)
                                    dt.items.add(file);
                            });
                            fileInput.files = dt.files;
                            renderImagePreviews();
                        }
                    });

                    // 🧩 Khi nhấn nút "x" xóa ảnh cũ (ảnh đã có trong DB)
                    previewContainer.addEventListener('click', function (e) {
                        const removeExistingBtn = e.target.closest('.remove-existing-image-btn');
                        if (!removeExistingBtn)
                            return;

                        const imageName = removeExistingBtn.dataset.imageName;
                        if (imageName) {
                            let currentValue = imagesToDeleteInput.value.trim();
                            currentValue += currentValue ? "#" + imageName : imageName;
                            imagesToDeleteInput.value = currentValue;
                        }

                        removeExistingBtn.closest('.image-preview-item').remove();
                        updateNoPhotoMessage();
                    });
                });
            </script>
    </body>
</html>
