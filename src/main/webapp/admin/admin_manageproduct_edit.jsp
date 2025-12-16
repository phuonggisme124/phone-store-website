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
        <title>Admin Dashboard - Edit Variant</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">

        <style>
            /* --- 1. GENERAL TONE --- */
            body { background-color: #f5f5f9; font-family: 'Segoe UI', sans-serif; }
            .text-primary { color: #696cff !important; }
            
            /* --- 2. NAVBAR --- */
            .border-light-purple { border-color: rgba(102, 126, 234, 0.3) !important; }
            
            /* --- 3. FORM CARD STYLING --- */
            .form-card {
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 8px 24px rgba(105, 108, 255, 0.1);
                border: none;
                transition: transform 0.3s ease;
            }
            .form-header {
                border-bottom: 1px solid #eceef1;
                padding-bottom: 1.5rem;
                margin-bottom: 2rem;
            }

            /* --- 4. INPUTS & LABELS --- */
            .form-label {
                font-weight: 600;
                color: #566a7f;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .form-control, .form-select {
                border-radius: 8px;
                border: 1px solid #d9dee3;
                padding: 0.7rem 1rem;
                color: #697a8d;
            }
            .form-control:focus {
                border-color: #696cff;
                box-shadow: 0 0 0 0.25rem rgba(105, 108, 255, 0.25);
            }

            /* --- 5. IMAGE UPLOAD STYLE --- */
            .photo-upload-label {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 10px 20px;
                border: 2px dashed #696cff;
                border-radius: 10px;
                color: #696cff;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                background: rgba(105, 108, 255, 0.05);
            }
            .photo-upload-label:hover {
                background: rgba(105, 108, 255, 0.1);
                transform: translateY(-2px);
            }
            .image-preview-item {
                position: relative;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .image-preview-item img {
                transition: transform 0.3s;
            }
            .image-preview-item:hover img {
                transform: scale(1.1);
            }
            .remove-image-btn, .remove-existing-image-btn {
                position: absolute;
                top: 5px;
                right: 5px;
                border-radius: 50%;
                width: 24px;
                height: 24px;
                padding: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
            }

            /* --- 6. BUTTONS --- */
            .btn-gradient-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none; color: white; transition: all 0.3s ease;
                font-weight: 600; letter-spacing: 1px;
                box-shadow: 0 4px 12px rgba(105, 108, 255, 0.4);
            }
            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(105, 108, 255, 0.6);
                color: white;
            }
            .btn-danger-soft {
                background-color: #ffe5e5;
                color: #ff3e1d;
                border: none;
                font-weight: 600;
            }
            .btn-danger-soft:hover {
                background-color: #ff3e1d;
                color: white;
                box-shadow: 0 4px 12px rgba(255, 62, 29, 0.4);
            }

            /* Navbar Profile */
            .hover-danger:hover { background-color: #ffe5e5 !important; color: #dc3545 !important; transform: rotate(90deg); transition: 0.3s; }
        </style>
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
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                %>

                <div class="container-fluid p-4">
                    <form action="variants" method="post" id="productForm" class="form-card p-5 mx-auto" style="max-width: 900px;" enctype="multipart/form-data">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Edit Product Variant</h2>
                            <p class="text-muted">Update details for <%= product.getName() %></p>
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
                        <input type="hidden" name="images" value="<%= variant.getImageUrl()%>">
                        <input type="hidden" name="imagesToDelete" id="imagesToDelete" value="">

                        <div class="row g-4">
                            
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-tag me-2"></i>Variant Details</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Product Name</label>
                                    <input type="text" class="form-control" name="pName" value="<%= product.getName()%>" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Color</label>
                                    <input type="text" class="form-control" name="color" value="<%= variant.getColor()%>" required>
                                </div>

                                <% if (product.getCategoryID() == 1 || product.getCategoryID() == 3) { %>
                                <div class="mb-3">
                                    <label class="form-label">Storage</label>
                                    <input type="text" class="form-control" name="storage" value="<%= variant.getStorage()%>">
                                </div>
                                <% } %>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Price (VND)</label>
                                        <input type="text" class="form-control" name="price" value="<%= String.format("%.0f", variant.getPrice())%>">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Stock</label>
                                        <input type="text" class="form-control" name="stock" value="<%= variant.getStock()%>">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-images me-2"></i>Gallery & Info</h5>

                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea class="form-control" name="description" rows="3"><%= variant.getDescription()%></textarea>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Images</label>
                                    <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display: none;">
                                    <label for="photo-upload-input" class="photo-upload-label w-100 mb-3">
                                        <i class="bi bi-cloud-arrow-up fs-4"></i>
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
                                            <img src="images/<%= imageName%>" alt="<%= imageName%>" style="width: 80px; height: 80px; object-fit: cover;">
                                            <button type="button" class="btn btn-danger btn-sm remove-existing-image-btn" data-image-name="<%= imageName%>">
                                                <i class="bi bi-x"></i>
                                            </button>
                                        </div>
                                        <% } } %>
                                    </div>
                                    
                                    <p class="text-muted small mt-2 fst-italic" id="no-photo-message" style="<%= (hasExistingImages ? "display: none;" : "display: block;")%>">
                                        No images available.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex gap-3 justify-content-end">
                            <button type="submit" name="action" value="deleteVariant" class="btn btn-danger-soft px-4 rounded-pill">
                                <i class="bi bi-trash3 me-2"></i>Delete Variant
                            </button>
                            <button type="submit" name="action" value="updateVariant" class="btn btn-gradient-primary px-5 rounded-pill">
                                <i class="bi bi-check-circle me-2"></i>Save Changes
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
                const fileInput = document.getElementById('photo-upload-input');
                const previewContainer = document.getElementById('image-preview-container');
                const noPhotoMessage = document.getElementById('no-photo-message');
                const imagesToDeleteInput = document.getElementById('imagesToDelete');

                function updateNoPhotoMessage() {
                    const totalImages = previewContainer.querySelectorAll('.image-preview-item').length;
                    noPhotoMessage.style.display = totalImages === 0 ? 'block' : 'none';
                }

                // Display New Image
                function displayImagePreview(file) {
                    if (!file.type || !file.type.startsWith('image/')) return;
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        const imgURL = e.target.result;
                        const imgWrapper = document.createElement('div');
                        imgWrapper.classList.add('image-preview-item', 'new-image', 'shadow-sm');
                        imgWrapper.innerHTML = `
                            <img src="\${imgURL}" style="width: 80px; height: 80px; object-fit: cover;">
                            <button type="button" class="btn btn-danger btn-sm remove-image-btn"><i class="bi bi-x"></i></button>
                        `;
                        previewContainer.appendChild(imgWrapper);
                        updateNoPhotoMessage();
                    };
                    reader.readAsDataURL(file);
                }

                function renderImagePreviews() {
                    previewContainer.querySelectorAll('.image-preview-item.new-image').forEach(item => item.remove());
                    Array.from(fileInput.files).forEach(displayImagePreview);
                }

                fileInput.addEventListener('change', renderImagePreviews);

                // Remove New Image
                previewContainer.addEventListener('click', function (e) {
                    const removeBtn = e.target.closest('.remove-image-btn');
                    if (removeBtn) {
                        const item = removeBtn.closest('.image-preview-item');
                        const allNewImages = Array.from(previewContainer.querySelectorAll('.image-preview-item.new-image'));
                        const indexToRemove = allNewImages.indexOf(item);
                        
                        if (indexToRemove >= 0) {
                            const dt = new DataTransfer();
                            Array.from(fileInput.files).forEach((file, i) => {
                                if (i !== indexToRemove) dt.items.add(file);
                            });
                            fileInput.files = dt.files;
                            renderImagePreviews();
                        }
                    }
                });

                // Remove Existing Image
                previewContainer.addEventListener('click', function (e) {
                    const removeExistingBtn = e.target.closest('.remove-existing-image-btn');
                    if (removeExistingBtn) {
                        const imageName = removeExistingBtn.dataset.imageName;
                        if (imageName) {
                            let currentValue = imagesToDeleteInput.value.trim();
                            currentValue += currentValue ? "#" + imageName : imageName;
                            imagesToDeleteInput.value = currentValue;
                        }
                        removeExistingBtn.closest('.image-preview-item').remove();
                        updateNoPhotoMessage();
                    }
                });

                // SweetAlert for Delete
                const deleteBtn = document.querySelector('button[value="deleteVariant"]');
                const form = document.getElementById('productForm');
                
                if (deleteBtn) {
                    deleteBtn.addEventListener('click', function (e) {
                        e.preventDefault();
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
                                // Create hidden input to submit delete action
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
                
                // Sidebar Toggle
                document.getElementById("menu-toggle").addEventListener("click", function () {
                    document.getElementById("wrapper").classList.toggle("toggled");
                });
            });
        </script>
    </body>
</html>