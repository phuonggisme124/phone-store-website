
<%@page import="model.Staff"%>
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
        <title>Create Variant</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
        <link href="css/dashboard_admin_manageproduct.css" rel="stylesheet">

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
            .sidebar-container {
                width: 250px !important;
                min-width: 250px !important;
                flex-shrink: 0 !important;
                background-color: #fff;
                border-right: 1px solid #dee2e6;
                min-height: 100vh;
            }
            .main-content {
                flex-grow: 1 !important;
                width: calc(100% - 250px) !important;
                padding: 0;
                overflow-x: auto;
            }
            .image-preview-item {
                position: relative;
                display: inline-block;
                margin: 10px;
            }
            .remove-image-btn {
                position: absolute;
                top: -5px;
                right: -5px;
                border-radius: 50%;
                padding: 2px 6px;
                font-size: 12px;
            }
            /* Mobile Responsive */
            @media (max-width: 992px) {
                .d-flex-wrapper {
                    flex-direction: column !important;
                }
                .sidebar-container {
                    width: 100% !important;
                    height: auto !important;
                }
                .main-content {
                    width: 100% !important;
                }
            }
        </style>
    </head>
    <body>
        <% Staff currentUser = (Staff) session.getAttribute("user");%>

        <div class="d-flex-wrapper">

            <nav class="sidebar bg-white shadow-sm border-end">
                <div class="sidebar-header p-3">
                    <h4 class="fw-bold text-primary">Mantis</h4>
                </div>
                <ul class="list-unstyled ps-3">
                                        <li><a href="product?action=manageProduct"><i class="bi bi-box me-2"></i>Products</a></li>
                    <li><a href="order?action=manageOrder"><i class="bi bi-bag me-2"></i>Orders</a></li>

                    <li><a href="review?action=manageReview"><i class="bi bi-chat-left-text me-2"></i>Reviews</a></li>

                    <li><a href="importproduct?action=staff_import" class="fw-bold text-primary"><i class="bi bi-chat-left-text me-2"></i>importProduct</a></li>
                    <li><a href="voucher?action=viewVoucher" class="fw-bold text-primary">
                        <i class="bi bi-ticket-perforated me-2"></i>Voucher
                    </a></li>
                </ul>
            </nav>

            <div class="main-content">

                <nav class="navbar navbar-light bg-white shadow-sm mb-4">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary d-lg-none" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto">
                            <form action="admin" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="manageProduct">
                                <div class="input-group">
                                    <input class="form-control" type="text" id="searchProduct" name="productName" placeholder="Search product..." oninput="showSuggestions(this.value)">
                                    <button class="btn btn-outline-primary" type="submit"><i class="bi bi-search"></i></button>
                                </div>
                                <div id="suggestionBox" class="list-group position-absolute" style="top: 100%; left: 0; width: 100%; z-index: 1000;"></div>
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span class="fw-bold small"><%= currentUser != null ? currentUser.getFullName() : "Admin"%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <%
                    int pID = (int) request.getAttribute("pID");
                    Products product = (Products) request.getAttribute("product");
                %>

                <div class="container-fluid px-4 pb-5">

                    <form action="variants?action=createVariant" method="post" class="bg-white p-5 rounded shadow-sm w-75 mx-auto" enctype="multipart/form-data" onsubmit="return validateForm()">

                        <h3 class="fw-bold text-primary border-bottom pb-2 mb-4">Create Variant for: <span class="text-dark"><%= product.getName()%></span></h3>

                        <% if (session.getAttribute("existVariant") != null) {
                                String exist = (String) session.getAttribute("existVariant");
                                out.println("<div class='alert alert-danger'>" + exist + "</div>");
                            }
                            session.removeAttribute("existVariant");
                        %>

                        <input type="hidden" name="pID" value="<%= pID%>">
                        <input type="hidden" name="ctID" value="<%= product.getCategoryID()%>">
                        <input type="hidden" name="pName" value="<%= product.getName()%>">

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Color / Version Name</label>
                                    <input type="text" class="form-control" name="color" placeholder="e.g. Midnight Black" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Sell Price (VND)</label>
                                    <input type="text" class="form-control" name="price" placeholder="0" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Cost Price (VND)</label>
                                    <input type="text" class="form-control" name="cost" placeholder="0" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <% if (product.getCategoryID() == 1 || product.getCategoryID() == 3) { %>
                                <div class="mb-3">
                                    <label for="storage" class="form-label fw-bold">Storage</label>
                                    <input type="text" name="storage" id="storage" class="form-control" placeholder="e.g. 128GB, 1TB" required>
                                    <span id="storageError" class="text-danger small"></span>
                                </div>
                                <% }%>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Stock Quantity</label>
                                    <input type="number" class="form-control" name="stock" placeholder="0" required>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3 mt-2">
                            <label class="form-label fw-bold">Description</label>
                            <textarea class="form-control" name="description" rows="3" placeholder="Additional details..."></textarea>
                        </div>

                        <div class="mb-3 p-3 border rounded bg-light">
                            <label class="form-label fw-bold d-block mb-2">Product Images</label>

                            <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display: none;">
                            <label for="photo-upload-input" class="btn btn-outline-primary btn-sm">
                                <i class="bi bi-camera-fill me-2"></i> Add Photos
                            </label>

                            <div id="image-preview-container" class="mt-3 d-flex flex-wrap align-items-center">
                                <p id="no-photo-message" class="text-muted small fst-italic ms-1">No photos selected.</p>
                            </div>
                        </div>

                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary btn-lg w-100 shadow-sm">
                                <i class="bi bi-check-circle-fill me-2"></i> Create Variant
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

        <script src="js/dashboard.js"></script>

        <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            const fileInput = document.getElementById('photo-upload-input');
                            const previewContainer = document.getElementById('image-preview-container');
                            const noPhotoMessage = document.getElementById('no-photo-message');

                            function updateNoPhotoMessage() {
                                const totalImages = previewContainer.querySelectorAll('.image-preview-item').length;
                                noPhotoMessage.style.display = totalImages === 0 ? 'block' : 'none';
                            }

                            function displayImagePreview(file) {
                                if (!file.type || !file.type.startsWith('image/'))
                                    return;

                                const reader = new FileReader();
                                reader.onload = function (e) {
                                    const imgURL = e.target.result;
                                    const imgWrapper = document.createElement('div');
                                    imgWrapper.classList.add('image-preview-item', 'new-image');

                                    const img = document.createElement('img');
                                    img.src = imgURL;
                                    img.className = "img-thumbnail border shadow-sm";
                                    img.alt = "Preview";
                                    img.style.width = "100px";
                                    img.style.height = "100px";
                                    img.style.objectFit = "cover";

                                    const button = document.createElement('button');
                                    button.type = "button";
                                    button.className = "btn btn-danger btn-sm remove-image-btn";
                                    button.innerHTML = '<i class="bi bi-x"></i>';

                                    imgWrapper.appendChild(img);
                                    imgWrapper.appendChild(button);
                                    previewContainer.appendChild(imgWrapper);
                                    updateNoPhotoMessage();
                                };
                                reader.readAsDataURL(file);
                            }

                            function renderImagePreviews() {
                                previewContainer.querySelectorAll('.image-preview-item.new-image').forEach(item => item.remove());
                                Array.from(fileInput.files).forEach(displayImagePreview);
                            }

                            fileInput.addEventListener('change', function () {
                                renderImagePreviews();
                            });

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
                        });

                        // Validation Storage
                        const storageInput = document.getElementById("storage");
                        if (storageInput) {
                            storageInput.addEventListener("input", function () {
                                const storage = this.value.trim().toUpperCase();
                                const regex = /^[0-9]+(GB|TB)$/;
                                if (!regex.test(storage)) {
                                    document.getElementById("storageError").innerText = "Format: 64GB, 128GB, 1TB";
                                    this.classList.add("is-invalid");
                                } else {
                                    document.getElementById("storageError").innerText = "";
                                    this.classList.remove("is-invalid");
                                    this.classList.add("is-valid");
                                }
                            });
                        }

                        function validateForm() {
                            const storageInput = document.getElementById("storage");
                            if (storageInput) {
                                const storage = storageInput.value.trim().toUpperCase();
                                const regex = /^[0-9]+(GB|TB)$/;
                                if (!regex.test(storage)) {
                                    alert("Invalid capacity! Format: 64GB, 128GB, 1TB");
                                    storageInput.focus();
                                    return false;
                                }
                            }
                            return true;
                        }
        </script>
    </body>
</html>