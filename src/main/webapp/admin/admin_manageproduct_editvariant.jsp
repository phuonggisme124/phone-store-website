<%@page import="model.Staff"%>
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
        <title>Admin Dashboard - Update Variant</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_editvariant.css">
       
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
                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>
                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="position-relative">
                                        <img src="https://i.pravatar.cc/150?u=<%= currentUser.getStaffID()%>" 
                                             class="rounded-circle border border-2 border-white shadow-sm" 
                                             width="40" height="40" alt="Avatar">
                                        <span class="position-absolute bottom-0 start-100 translate-middle p-1 bg-success border border-light rounded-circle">
                                            <span class="visually-hidden">Online</span>
                                        </span>
                                    </div>
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;"><%= currentUser.getFullName()%></span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                    </div>
                                </div>
                                <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" 
                                   style="width: 38px; height: 38px;" title="Logout">
                                    <i class="bi bi-box-arrow-right fs-6"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </nav>

                <% 
                    Variants variant = (Variants) request.getAttribute("variant");
                    String[] existingImages = variant.getImageList();
                    Products product = (Products) request.getAttribute("product");
                %>

                <div class="container-fluid p-4">
                    <form action="variants" method="post" id="variantForm" class="form-card p-5 mx-auto" style="max-width: 900px;" enctype="multipart/form-data" onsubmit="return validateForm()">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Update Variant</h2>
                            <p class="text-muted">Modify details for variant #<%= variant.getVariantID() %></p>
                        </div>

                        <div class="mb-4 text-center">
                            <% if (session.getAttribute("existVariant") != null) {
                                String exist = (String) session.getAttribute("existVariant");
                                out.println("<div class='alert alert-danger shadow-sm border-0 rounded-3'><i class='bi bi-exclamation-circle-fill me-2'></i>" + exist + "</div>");
                            } session.removeAttribute("existVariant"); %>
                        </div>

                        <input type="hidden" name="vID" value="<%= variant.getVariantID()%>">
                        <input type="hidden" name="ctID" value="<%= product.getCategoryID()%>">
                        <input type="hidden" name="pID" value="<%= product.getProductID()%>">
                        <input type="hidden" name="oldStock" value="<%= variant.getStock()%>">
                        
                        <% 
                            String imageUrl = variant.getImageUrl();
                            if (imageUrl == null) imageUrl = ""; 
                        %>
                        <input type="hidden" name="images" value="<%= imageUrl%>">
                        <input type="hidden" name="imagesToDelete" id="imagesToDelete" value="">

                        <div class="row g-4">
                            
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-sliders me-2"></i>Specifications</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Color</label>
                                    <input type="text" class="form-control" name="color" value="<%= variant.getColor()%>" required>
                                </div>

                                <% if (product.getCategoryID() == 1 || product.getCategoryID() == 3) { %>
                                <div class="mb-3">
                                    <label class="form-label">Storage</label>
                                    <input type="text" class="form-control" name="storage" id="storage" value="<%= variant.getStorage()%>" required>
                                    <div id="storageError" class="text-danger small mt-1" style="display: none;"></div>
                                </div>
                                <% } %>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Sell Price</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="price" value="<%= String.format("%.0f", variant.getPrice())%>" required>
                                            <span class="input-group-text bg-light text-muted">VND</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Cost Price</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="cost" required> <span class="input-group-text bg-light text-muted">VND</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Stock Quantity</label>
                                    <input type="number" class="form-control" name="stock" value="<%= variant.getStock()%>" required>
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
                                    <textarea class="form-control" name="description" rows="3"><%= variant.getDescription()%></textarea>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Images</label>
                                    <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display: none;">
                                    <label for="photo-upload-input" class="photo-upload-label w-100 mb-3">
                                        <i class="bi bi-cloud-arrow-up fs-1 mb-2"></i>
                                        <span>Click to Upload New Photos</span>
                                    </label>

                                    <div id="image-preview-container" class="d-flex flex-wrap gap-3">
                                        <%
                                            boolean hasExistingImages = (existingImages != null && existingImages.length > 0);
                                            if (hasExistingImages) {
                                                for (String imageName : existingImages) {
                                                    if (imageName == null || imageName.trim().isEmpty()) continue;
                                        %>
                                        <div class="image-preview-item existing-image shadow-sm">
                                            <img src="images/<%= imageName%>" alt="<%= imageName%>" class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover;">
                                            <button type="button" class="btn btn-danger btn-sm remove-existing-image-btn" data-image-name="<%= imageName%>">
                                                <i class="bi bi-x"></i>
                                            </button>
                                        </div>
                                        <% } } %>
                                    </div>
                                    
                                    <p class="text-muted small mt-2 fst-italic text-center" id="no-photo-message" style="<%= (hasExistingImages ? "display: none;" : "display: block;")%>">
                                        No images available.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex gap-3 justify-content-end">
                            <button type="submit" name="action" value="deleteVariant" class="btn btn-danger-soft px-4 rounded-pill">
                                <i class="bi bi-trash3 me-2"></i>Delete
                            </button>
                            <button type="submit" name="action" value="updateVariant" class="btn btn-gradient-primary px-5 rounded-pill">
                                <i class="bi bi-check-circle me-2"></i>Update Variant
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="js/dashboard.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // 1. Sidebar Toggle
                document.getElementById("menu-toggle").addEventListener("click", function () {
                    document.getElementById("wrapper").classList.toggle("toggled");
                });

                // 2. Image Logic
                const fileInput = document.getElementById('photo-upload-input');
                const previewContainer = document.getElementById('image-preview-container');
                const noPhotoMessage = document.getElementById('no-photo-message');
                const imagesToDeleteInput = document.getElementById('imagesToDelete');

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
                        imgWrapper.classList.add('image-preview-item', 'new-image', 'shadow-sm');
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
                    previewContainer.querySelectorAll('.image-preview-item.new-image').forEach(item => item.remove());
                    Array.from(fileInput.files).forEach(displayImagePreview);
                });

                previewContainer.addEventListener('click', function (e) {
                    // Xóa ảnh mới
                    if (e.target.closest('.remove-image-btn')) {
                        const btn = e.target.closest('.remove-image-btn');
                        btn.closest('.image-preview-item').remove();
                        // Reset input file nếu xóa hết ảnh mới (cơ bản)
                        if(previewContainer.querySelectorAll('.image-preview-item.new-image').length === 0) fileInput.value = "";
                        updateNoPhotoMessage();
                    }
                    // Xóa ảnh cũ
                    if (e.target.closest('.remove-existing-image-btn')) {
                        const btn = e.target.closest('.remove-existing-image-btn');
                        const imageName = btn.dataset.imageName;
                        if (imageName) {
                            let currentValue = imagesToDeleteInput.value.trim();
                            currentValue += currentValue ? "#" + imageName : imageName;
                            imagesToDeleteInput.value = currentValue;
                        }
                        btn.closest('.image-preview-item').remove();
                        updateNoPhotoMessage();
                    }
                });

                // 3. Storage Validation
                const storageInput = document.getElementById("storage");
                if (storageInput) {
                    storageInput.addEventListener("input", function () {
                        const val = this.value.trim().toUpperCase();
                        const regex = /^[0-9]+(GB|TB)$/;
                        const errorMsg = document.getElementById("storageError");
                        
                        if (!regex.test(val) && val !== "") {
                            errorMsg.innerHTML = '<i class="bi bi-exclamation-circle me-1"></i> Format: 64GB, 128GB, 1TB...';
                            errorMsg.style.display = "block";
                            this.classList.add("is-invalid");
                        } else {
                            errorMsg.style.display = "none";
                            this.classList.remove("is-invalid");
                            if(val !== "") this.classList.add("is-valid");
                        }
                    });
                }

                // 4. Delete Confirmation
                const form = document.getElementById('variantForm');
                const deleteBtn = form.querySelector('button[value="deleteVariant"]');

                if (deleteBtn) {
                    deleteBtn.addEventListener('click', function (event) {
                        event.preventDefault();
                        Swal.fire({
                            title: 'Are you sure?',
                            text: "You won't be able to revert this!",
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#dc3545',
                            cancelButtonColor: '#6c757d',
                            confirmButtonText: 'Yes, delete it!',
                            background: '#fff',
                            customClass: { popup: 'rounded-4' }
                        }).then((result) => {
                            if (result.isConfirmed) {
                                // Tạo hidden input để gửi action delete
                                const hiddenAction = document.createElement('input');
                                hiddenAction.type = 'hidden';
                                hiddenAction.name = 'action';
                                hiddenAction.value = 'deleteVariant';
                                form.appendChild(hiddenAction);
                                form.submit();
                            }
                        });
                    });
                }
            });

            // Form Submit Validation
            function validateForm() {
                const storageInput = document.getElementById("storage");
                if (storageInput) {
                    const val = storageInput.value.trim().toUpperCase();
                    const regex = /^[0-9]+(GB|TB)$/;
                    if (!regex.test(val)) {
                        storageInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        storageInput.focus();
                        return false;
                    }
                }
                return true;
            }
        </script>
    </body>
</html>