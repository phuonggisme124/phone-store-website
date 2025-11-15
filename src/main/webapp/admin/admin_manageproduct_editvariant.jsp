<%@page import="model.Profit"%>
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
        <link rel="stylesheet" href="css/manage_product.css">
        <link href="css/phone.css" rel="stylesheet">

    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <form class="d-none d-md-flex ms-3">
                            <input class="form-control" type="search" placeholder="Ctrl + K" readonly>
                        </form>
                        <div class="d-flex align-items-center ms-auto">
                            <div class="position-relative me-3">
                                <a href="logout">logout</a>
                            </div>
                            <i class="bi bi-bell me-3 fs-5"></i>
                            <div class="position-relative me-3">
                                <i class="bi bi-github fs-5"></i>
                            </div>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span>Admin</span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Search bar -->
                <div class="container-fluid p-4">
                    <input type="text" class="form-control w-25" placeholder="🔍 Search">
                </div>


                <%                    Variants variant = (Variants) request.getAttribute("variant");
                    String[] existingImages = variant.getImageList();
                    Products product = (Products) request.getAttribute("product");
                    Profit profit = (Profit) request.getAttribute("profit");

                %>
                <!-- Table -->
                <form action="variants" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow" enctype="multipart/form-data">
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="vID" value="<%= variant.getVariantID()%>" readonly>
                    </div>
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="ctID" value="<%= product.getCategoryID()%>" readonly>
                    </div>


                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="pID" value="<%= product.getProductID()%>" readonly>
                    </div>
                    <%                        if (session.getAttribute("existVariant") != null) {
                            String exist = (String) session.getAttribute("existVariant");
                            out.println("<p class='error-message'>" + exist + "</p>");
                        }
                        session.removeAttribute("existVariant");
                    %>
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="pName" value="<%= product.getName()%>" required>
                    </div>

                    <div class="mb-3" >
                        <label class="form-label">Color</label>
                        <input type="text" class="form-control" name="color" value="<%= variant.getColor()%>" required>

                    </div>
                    <%
                        if (product.getCategoryID() == 1 || product.getCategoryID() == 3) {
                    %>
                    <div class="mb-3" >
                        <label class="form-label">Storage</label>
                        <input type="text" class="form-control" name="storage" value="<%= variant.getStorage()%>">
                    </div>
                    <%
                        }
                    %>
                    <div class="mb-3">
                        <label class="form-label">Sell Price</label>

                        <input type="text" class="form-control" name="price" value="<%= String.format("%.0f", variant.getPrice())%>">
                    </div>

                  

                    <div class="mb-3">

                        <label class="form-label">Stock</label>
                        <input type="text" class="form-control" name="stock" value="<%= variant.getStock()%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Stock</label>
                        <input type="hidden" class="form-control" name="oldStock" value="<%= variant.getStock()%>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <input type="text" class="form-control" name="description" value="<%= variant.getDescription()%>">
                    </div>



                    <div class="mb-3 options-row">
                        <span class="photo-upload">
                            <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display: none;">
                            <label for="photo-upload-input" class="photo-upload-label">
                                <span class="camera-icon">📷</span> Add photos
                            </label>
                        </span>
                    </div>

                    <input type="hidden" name="imagesToDelete" id="imagesToDelete" value="">

                    <div id="image-preview-container" class="image-preview-container d-flex flex-wrap gap-2 mb-3 options-row">
                        <input type="hidden" name="images" value="<%= variant.getImageUrl()%>">
                        <%
                            boolean hasExistingImages = (existingImages != null && existingImages.length > 0); // Dâu sửa lại check này một chút
                            if (hasExistingImages) {
                                for (String imageName : existingImages) {
                                    if (imageName == null || imageName.trim().isEmpty()) {
                                        continue; // Bỏ qua nếu tên ảnh rỗng
                                    }%>

                        <div class="image-preview-item existing-image"> 
                            <img src="images/<%= imageName%>"
                                 alt="<%= imageName%>"
                                 class="img-thumbnail"
                                 style="width: 100px; height: 100px; object-fit: cover;">

                            <button type="button" 
                                    class="btn btn-danger btn-sm remove-existing-image-btn" 
                                    data-image-name="<%= imageName%>">
                                <i class="bi bi-x-circle-fill"></i>
                            </button>
                        </div>
                        <%
                                }
                            }
                        %>

                        <p class="text-muted" id="no-photo-message"
                           style="<%= (hasExistingImages ? "display: none;" : "display: block;")%>">
                            <%= (hasExistingImages ? "" : "no images.")%>
                        </p>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="action" value="updateVariant" class="btn btn-primary flex-fill">Update</button>
                        <button type="submit" name="action" value="deleteVariant" class="btn btn-danger flex-fill">Delete</button>
                    </div>

                </form>
            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const form = document.querySelector('form[action="variants"]');
                    const deleteBtn = form?.querySelector('button[name="action"][value="deleteVariant"]');

                    if (!deleteBtn) {
                        console.error("Delete button not found!");
                        return;
                    }

                    deleteBtn.addEventListener('click', function (event) {
                        event.preventDefault(); // Prevent default submit

                        Swal.fire({
                            title: 'Are you sure you want to delete this variant?',
                            text: 'This action cannot be undone.',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#dc3545',
                            cancelButtonColor: '#6c757d',
                            confirmButtonText: 'Delete',
                            cancelButtonText: 'Cancel',
                            reverseButtons: true,
                            background: '#fff',
                            color: '#333',
                            customClass: {
                                popup: 'shadow-lg rounded-4 p-3',
                                confirmButton: 'px-4 py-2 rounded-3',
                                cancelButton: 'px-4 py-2 rounded-3'
                            }
                        }).then((result) => {
                            if (result.isConfirmed) {
                                // Ensure correct action is sent
                                let actionInput = form.querySelector('input[name="action"]');
                                if (!actionInput) {
                                    actionInput = document.createElement('input');
                                    actionInput.type = 'hidden';
                                    actionInput.name = 'action';
                                    form.appendChild(actionInput);
                                }
                                actionInput.value = 'deleteVariant';
                                form.submit();
                            }
                        });
                    });
                });
            </script>

    </body>
</html>
