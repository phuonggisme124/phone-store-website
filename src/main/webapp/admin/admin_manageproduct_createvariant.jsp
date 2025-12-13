<%@page import="model.Staff"%>
<%@page import="model.Category"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Products"%>
<%@page import="model.Variants"%>
<%@page import="java.util.List"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Create Variant</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_createvariant.css">

        
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>
            <% Staff currentUser = (Staff) session.getAttribute("user"); %>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto gap-3">
                            <div class="d-flex align-items-center gap-2">
                                <img src="https://i.pravatar.cc/150?u=<%= currentUser.getStaffID()%>" class="rounded-circle border border-2 border-white shadow-sm" width="40" height="40">
                                <span class="d-none d-md-block fw-bold text-dark"><%= currentUser.getFullName()%></span>
                            </div>
                            <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" style="width: 38px; height: 38px;">
                                <i class="bi bi-box-arrow-right fs-6"></i>
                            </a>
                        </div>
                    </div>
                </nav>

                <% 
                    Variants variant = (Variants) request.getAttribute("variant");
                    Products product = (Products) request.getAttribute("product");
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                    int pID = (int) request.getAttribute("pID");
                %>

                <div class="container-fluid p-4">
                    <form action="variants?action=createVariant" method="post" id="productForm" class="form-card p-5 mx-auto" style="max-width: 900px;" enctype="multipart/form-data">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Add New Variant</h2>
                            <p class="text-muted">Create a new version for this product</p>
                        </div>

                        <div class="mb-4 text-center">
                            <% if (session.getAttribute("existVariant") != null) {
                                String exist = (String) session.getAttribute("existVariant");
                                out.println("<div class='alert alert-danger shadow-sm border-0 rounded-3'><i class='bi bi-exclamation-circle-fill me-2'></i>" + exist + "</div>");
                            } session.removeAttribute("existVariant"); %>
                        </div>

                        <input type="hidden" name="vID" value="<%= (variant != null) ? variant.getVariantID() : "" %>">
                        <input type="hidden" name="pID" value="<%= pID %>">
                        <input type="hidden" name="ctID" value="<%= product.getCategoryID() %>">

                        <div class="row g-4">
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-sliders me-2"></i>Specifications</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Color</label>
                                    <input type="text" class="form-control" name="color" id="color" placeholder="e.g. Titanium Blue">
                                    <p id="colorError" class="text-danger mt-2" style="display:none;">Please enter color!</p>
                                </div>

                                <% if (product.getCategoryID() == 1 || product.getCategoryID() == 3) { %>
                                <div class="mb-3">
                                    <label class="form-label">Storage</label>
                                    <input type="text" class="form-control" name="storage" id="storage" placeholder="e.g. 128GB, 1TB">
                                    <p id="storageError" class="text-danger mt-2" style="display:none;">Enter storage (e.g. 128GB)!</p>
                                </div>
                                <% } %>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Sell Price</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="price" id="price">
                                            <span class="input-group-text bg-light text-muted">VND</span>
                                        </div>
                                        <p id="priceError" class="text-danger mt-2" style="display:none;">Enter valid price!</p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Cost Price</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="cost" id="cost">
                                            <span class="input-group-text bg-light text-muted">VND</span>
                                        </div>
                                        <p id="costError" class="text-danger mt-2" style="display:none;">Enter valid cost!</p>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Stock Quantity</label>
                                    <input type="number" class="form-control" name="stock" id="stock">
                                    <p id="stockError" class="text-danger mt-2" style="display:none;">Enter stock quantity!</p>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-info-circle me-2"></i>Info & Media</h5>

                                <div class="mb-3">
                                    <label class="form-label">Product Name</label>
                                    <input type="text" class="form-control" name="pName" value="<%= product.getName()%>" readonly>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea class="form-control" name="description" rows="3" placeholder="Additional details..."></textarea>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Upload Images</label>
                                    <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display: none;">
                                    <label for="photo-upload-input" class="photo-upload-label w-100">
                                        <i class="bi bi-cloud-arrow-up fs-1 mb-2"></i>
                                        <span>Drop files here or click to upload</span>
                                        <small class="fw-normal text-muted mt-1">Supports JPG, PNG</small>
                                    </label>
                                    
                                    <div id="image-preview-container" class="d-flex flex-wrap gap-3 mt-3"></div>
                                    <p class="text-muted small mt-2 fst-italic text-center" id="no-photo-message">No images selected.</p>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top text-center">
                            <button type="submit" name="action" value="createVariant" class="btn btn-gradient-primary rounded-pill w-50">
                                <i class="bi bi-plus-circle me-2"></i> Create Variant
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/dashboard.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // 1. Sidebar Toggle
                document.getElementById("menu-toggle").addEventListener("click", function () {
                    document.getElementById("wrapper").classList.toggle("toggled");
                });

                // 2. Image Upload Logic (Giữ nguyên logic cũ của đại ca)
                const fileInput = document.getElementById('photo-upload-input');
                const previewContainer = document.getElementById('image-preview-container');
                const noPhotoMessage = document.getElementById('no-photo-message');

                function updateNoPhotoMessage() {
                    const totalImages = previewContainer.querySelectorAll('.image-preview-item').length;
                    noPhotoMessage.style.display = totalImages === 0 ? 'block' : 'none';
                }

                function displayImagePreview(file) {
                    if (!file.type || !file.type.startsWith('image/')) return;
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        const imgURL = e.target.result;
                        const imgWrapper = document.createElement('div');
                        imgWrapper.classList.add('image-preview-item', 'new-image');
                        imgWrapper.innerHTML = `
                            <img src="\${imgURL}" class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover;">
                            <button type="button" class="btn btn-danger btn-sm remove-image-btn"><i class="bi bi-x"></i></button>
                        `;
                        previewContainer.appendChild(imgWrapper);
                        updateNoPhotoMessage();
                    };
                    reader.readAsDataURL(file);
                }

                fileInput.addEventListener('change', function () {
                    previewContainer.innerHTML = '';
                    Array.from(fileInput.files).forEach(displayImagePreview);
                });

                previewContainer.addEventListener('click', function (e) {
                    const removeBtn = e.target.closest('.remove-image-btn');
                    if (removeBtn) {
                        removeBtn.closest('.image-preview-item').remove();
                        // Reset input nếu xóa hết (Logic đơn giản)
                        if(previewContainer.querySelectorAll('.image-preview-item').length === 0) fileInput.value = "";
                        updateNoPhotoMessage();
                    }
                });

                // 3. VALIDATION LOGIC (ĐÃ CẬP NHẬT)
                document.getElementById("productForm").addEventListener("submit", function (e) {
                    let isValid = true;

                    // Helper function để validate từng ô
                    function validateField(id, errorId, regex = null, errorMsg = "") {
                        const field = document.getElementById(id);
                        const error = document.getElementById(errorId);
                        
                        // Nếu field không tồn tại trên DOM (ví dụ storage khi chọn phụ kiện) thì bỏ qua
                        if (!field) return true;

                        const val = field.value.trim();
                        let isError = false;

                        // Check rỗng
                        if (val === "") {
                            isError = true;
                            if(errorMsg === "") error.innerText = "This field is required!";
                        } 
                        // Check Regex (nếu có)
                        else if (regex && !regex.test(val)) {
                            isError = true;
                            if(errorMsg !== "") error.innerText = errorMsg;
                        }

                        if (isError) {
                            error.style.display = "block"; // Hiện thẻ P lỗi
                            field.classList.add("is-invalid");
                            return false;
                        } else {
                            error.style.display = "none"; // Ẩn thẻ P lỗi
                            field.classList.remove("is-invalid");
                            field.classList.add("is-valid");
                            return true;
                        }
                    }

                    // Validate các trường
                    if (!validateField("color", "colorError")) isValid = false;
                    
                    // Validate Storage (Format GB/TB)
                    if (!validateField("storage", "storageError", /^[0-9]+(GB|TB)$/i, "Invalid format! e.g. 128GB, 1TB")) isValid = false;
                    
                    // Validate Price (Số dương)
                    if (!validateField("price", "priceError", /^[0-9]+$/, "Enter valid price!")) isValid = false;
                    
                    // Validate Cost (Số dương)
                    if (!validateField("cost", "costError", /^[0-9]+$/, "Enter valid cost!")) isValid = false;
                    
                    // Validate Stock (Số dương)
                    if (!validateField("stock", "stockError", /^[0-9]+$/, "Enter valid stock!")) isValid = false;

                    // Nếu có lỗi => Chặn submit và cuộn tới lỗi
                    if (!isValid) {
                        e.preventDefault();
                        const firstError = document.querySelector(".is-invalid");
                        if (firstError) {
                            firstError.scrollIntoView({ behavior: "smooth", block: "center" });
                            firstError.focus();
                        }
                    }
                });
            });
        </script>
    </body>
</html>