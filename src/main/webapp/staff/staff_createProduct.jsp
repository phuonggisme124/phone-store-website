<%@page import="model.Staff"%>
<%@page import="model.Category"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Products"%>
<%@page import="model.Variants"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Create Product - Admin Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

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
            .form-card {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                padding: 40px;
                max-width: 900px; /* Giới hạn chiều rộng form cho đẹp */
                margin: 0 auto;
            }
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
                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span class="fw-bold small"><%= currentUser != null ? currentUser.getFullName() : "Admin"%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-5">

                    <%
                        Variants variant = (Variants) request.getAttribute("variant");
                        Products product = (Products) request.getAttribute("product");
                        List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                        List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
                    %>

                    <form action="product" method="post" id="productForm" class="form-card">

                        <h3 class="fw-bold text-primary border-bottom pb-3 mb-4">Create New Product</h3>

                        <div class="mb-3">
                            <%
                                if (session.getAttribute("existName") != null) {
                                    String exist = (String) session.getAttribute("existName");
                                    out.println("<div class='alert alert-danger'>" + exist + "</div>");
                                }
                                session.removeAttribute("existName");
                            %>
                        </div>

                        <input type="hidden" name="vID" value="">
                        <input type="hidden" name="pID" value="">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Product Name</label>
                                <input type="text" class="form-control" name="pName" id="pName" placeholder="e.g. iPhone 15 Pro Max">
                                <p id="productNameError" class="text-danger mt-1 small" style="display:none;">Please enter product name!</p>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Category</label>
                                <select class="form-select" name="category" id="category">
                                    <option selected value="">-- Select Category --</option>
                                    <% if (listCategories != null) {
                                            for (Category ct : listCategories) {%>
                                    <option value="<%= ct.getCategoryId()%>"><%= ct.getCategoryName()%></option>
                                    <%  }
                                        } %>
                                </select>
                                <p id="categoryError" class="text-danger mt-1 small" style="display:none;">Please select a category!</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Brand</label>
                                <input type="text" class="form-control" name="brand" id="brand" placeholder="e.g. Apple">
                                <p id="brandError" class="text-danger mt-1 small" style="display:none;">Please enter product brand!</p>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Warranty Period</label>
                                <input type="text" class="form-control" name="warrantyPeriod" id="warrantyPeriod" placeholder="e.g. 12 months">
                                <p id="warrantyPeriodError" class="text-danger mt-1 small" style="display:none;">Please enter warranty period!</p>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Supplier</label>
                            <select class="form-select" name="supplierID" id="supplierID">
                                <option selected value="">-- Select Supplier --</option>
                                <% if (listSupplier != null) {
                                        for (Suppliers sl : listSupplier) {%>
                                <option value="<%= sl.getSupplierID()%>"><%= sl.getName()%></option>
                                <%  }
                                    }%>
                            </select>
                            <p id="supplierError" class="text-danger mt-1 small" style="display:none;">Please select a supplier!</p>
                        </div>

                        <h5 class="text-secondary border-bottom pb-2 mb-3 mt-4">Technical Specifications</h5>

                        <div class="row">
                            <div class="col-md-6 mb-3" id="group-tech">
                                <label class="form-label fw-bold">OS (Operating System)</label>
                                <input type="text" class="form-control" name="os" id="os" placeholder="e.g. iOS 17">
                                <p id="osError" class="text-danger mt-1 small" style="display:none;">Please enter OS!</p>
                            </div>
                            <div class="col-md-6 mb-3" id="group-cpu">
                                <label class="form-label fw-bold">CPU</label>
                                <input type="text" class="form-control" name="cpu" id="cpu" placeholder="e.g. A17 Pro">
                                <p id="cpuError" class="text-danger mt-1 small" style="display:none;">Please enter CPU!</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3" id="group-gpu">
                                <label class="form-label fw-bold">GPU</label>
                                <input type="text" class="form-control" name="gpu" id="gpu" placeholder="e.g. Apple GPU (6-core graphics)">
                                <p id="gpuError" class="text-danger mt-1 small" style="display:none;">Please enter GPU!</p>
                            </div>
                            <div class="col-md-6 mb-3" id="group-ram">
                                <label class="form-label fw-bold">RAM</label>
                                <input type="text" class="form-control" name="ram" id="ram" placeholder="e.g. 8GB">
                                <p id="ramError" class="text-danger mt-1 small" style="display:none;">Please enter RAM!</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3" id="group-battery">
                                <label class="form-label fw-bold">Battery Capacity (mAh)</label>
                                <input type="number" class="form-control" name="batteryCapacity" id="batteryCapacity" placeholder="e.g. 4422">
                                <p id="batteryCapacityError" class="text-danger mt-1 small" style="display:none;">Please enter battery capacity!</p>
                            </div>
                            <div class="col-md-6 mb-3" id="group-touchscreen">
                                <label class="form-label fw-bold">Touchscreen Technology</label>
                                <input type="text" class="form-control" name="touchscreen" id="touchscreen" placeholder="e.g. Super Retina XDR OLED">
                                <p id="touchscreenError" class="text-danger mt-1 small" style="display:none;">Please enter touchscreen info!</p>
                            </div>
                        </div>

                        <div class="mt-4">
                            <button type="submit" name="action" value="createProduct" class="btn btn-primary btn-lg w-100 shadow-sm">
                                <i class="bi bi-plus-circle-fill me-2"></i> Create Product
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
            document.getElementById("productForm").addEventListener("submit", function (e) {
                const category = document.getElementById("category");
                const supplier = document.getElementById("supplierID");
                const productName = document.getElementById("pName");
                const brand = document.getElementById("brand");
                const warrantyPeriod = document.getElementById("warrantyPeriod");

                // Tech specs
                const os = document.getElementById("os");
                const cpu = document.getElementById("cpu");
                const gpu = document.getElementById("gpu");
                const ram = document.getElementById("ram");
                const batteryCapacity = document.getElementById("batteryCapacity");
                const touchscreen = document.getElementById("touchscreen");

                // Errors
                const categoryError = document.getElementById("categoryError");
                const supplierError = document.getElementById("supplierError");
                const productNameError = document.getElementById("productNameError");
                const brandError = document.getElementById("brandError");
                const warrantyPeriodError = document.getElementById("warrantyPeriodError");

                let isValid = true;

                // Helper function to show error
                function showError(input, errorMsg, isShow) {
                    if (isShow) {
                        errorMsg.style.display = "block";
                        input.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        errorMsg.style.display = "none";
                        input.classList.remove("is-invalid");
                    }
                }

                // Basic Validation
                showError(category, categoryError, category.value === "");
                showError(supplier, supplierError, supplier.value === "");
                showError(productName, productNameError, productName.value === "");
                showError(brand, brandError, brand.value === "");
                showError(warrantyPeriod, warrantyPeriodError, warrantyPeriod.value === "");

                // Validate Dynamic Fields based on Category
                const catVal = category.value;

                if (catVal === "1" || catVal === "3") { // Phone
                    showError(os, document.getElementById("osError"), os.value === "");
                    showError(cpu, document.getElementById("cpuError"), cpu.value === "");
                    showError(gpu, document.getElementById("gpuError"), gpu.value === "");
                    showError(ram, document.getElementById("ramError"), ram.value === "");
                    showError(batteryCapacity, document.getElementById("batteryCapacityError"), batteryCapacity.value === "");
                    showError(touchscreen, document.getElementById("touchscreenError"), touchscreen.value === "");
                } else if (catVal === "2") { // Tablet/Laptop
                    showError(gpu, document.getElementById("gpuError"), gpu.value === "");
                    showError(batteryCapacity, document.getElementById("batteryCapacityError"), batteryCapacity.value === "");
                    showError(touchscreen, document.getElementById("touchscreenError"), touchscreen.value === "");
                }

                if (!isValid) {
                    e.preventDefault();
                    const firstInvalid = document.querySelector(".is-invalid");
                    if (firstInvalid) {
                        firstInvalid.scrollIntoView({behavior: "smooth", block: "center"});
                        firstInvalid.focus();
                    }
                }
            });

            // Logic ẩn hiện field theo category
            const categorySelect = document.getElementById("category");
            const techGroups = [
                "group-tech", "group-cpu", "group-gpu", "group-ram",
                "group-battery", "group-touchscreen"
            ];
            const filteredGroups = techGroups.filter(id => id !== "group-cpu" && id !== "group-tech" && id !== "group-ram");

            function hideAllGroups() {
                techGroups.forEach(id => document.getElementById(id).style.display = "none");
            }

            // Init call
            hideAllGroups();

            categorySelect.addEventListener("change", function () {
                const selectedValue = this.value;
                hideAllGroups();

                if (selectedValue === "1" || selectedValue === "3") {
                    techGroups.forEach(id => document.getElementById(id).style.display = "block");
                } else if (selectedValue === "2") {
                    filteredGroups.forEach(id => document.getElementById(id).style.display = "block");
                }
            });
        </script>
    </body>
</html>