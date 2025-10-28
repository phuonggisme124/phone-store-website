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
        <link rel="stylesheet" href="css/admin_review.css">

        <link href="css/dashboard_table.css" rel="stylesheet">
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


                <%
                    int productID = (int) request.getAttribute("productID");
                    Variants variant = (Variants) request.getAttribute("variant");
                    Products product = (Products) request.getAttribute("product");
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                    List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
                %>
                <!-- Table -->
                <form action="admin" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow" enctype="multipart/form-data">
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="vID" value="" readonly>
                    </div>

                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="pID" value="<%= productID%>" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="pName" value="<%= product.getName()%>" required>
                    </div>




                    <div class="mb-3">
                        <label class="form-label">Color</label>
                        <input type="text" class="form-control" name="color" value="" required>

                    </div>
                    <div class="mb-3">
                        <label class="form-label">Storage</label>
                        <input type="text" class="form-control" name="storage" value="">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price</label>
                        <input type="text" class="form-control" name="price" value="">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Stock</label>
                        <input type="text" class="form-control" name="stock" value="">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <input type="text" class="form-control" name="description" value="">
                    </div>

                    <div class="mb-3 options-row">
                        <span class="photo-upload">
                            <input type="file" name="photos" id="photo-upload-input" accept="image/*" multiple style="display: none;">
                            <label for="photo-upload-input" class="photo-upload-label">
                                <span class="camera-icon">📷</span> Send photos (up to 3 photos)
                            </label>
                        </span>
                    </div>

                    <div id="image-preview-container" class="image-preview-container"></div>

                    <div class="mb-3">
                        <button type="submit" name="action" value="createVariant" class="btn btn-primary w-100">Create</button>
                    </div>


                </form>
            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
            <script>
                // ======================== Xử lý Ảnh Preview ========================
                var fileInput = document.getElementById('photo-upload-input');
                var previewContainer = document.getElementById('image-preview-container');
                

                fileInput.addEventListener('change', function () {
                    previewContainer.innerHTML = '';
                    const files = fileInput.files;

                    for (let i = 0; i < files.length; i++) {
                        const file = files[i];

                        if (file.type.startsWith('image/')) {
                            const reader = new FileReader();

                            reader.onload = function (e) {
                                const img = document.createElement('img');
                                img.src = e.target.result;
                                img.alt = 'Ảnh thực tế sản phẩm';
                                previewContainer.appendChild(img);
                            };
                            reader.readAsDataURL(file);
                        }
                    }
                });

            </script>
    </body>
</html>
